FROM php:8.2-apache

# Instala extensões e dependências do Laravel
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd curl

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Aponta o Apache pra pasta public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 775 storage bootstrap/cache

EXPOSE 80
