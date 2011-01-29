Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1A2Q0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 11:26:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38280 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1A2Q0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 11:26:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsHLwKgP6A1x+KT/3sQ4v81Ic7fjFa1w3fSgHP9bouQPphMgZpnr1sbmfuL1q+zrbY
         bt76R1KyfsL3dKBIHCAsIWYYQJjcwwKlcCaJVgwpk7mShFRtNoi50t/wkNCyIcrKX3i/
         +MAPiD5YsL451D1CXqD+FCG1yrOLOKGawbWIo=
MIME-Version: 1.0
In-Reply-To: <1296314481-28028-1-git-send-email-lars@metafoo.de>
References: <1296314481-28028-1-git-send-email-lars@metafoo.de>
Date: Sun, 30 Jan 2011 00:26:14 +0800
Message-ID: <AANLkTik4K0df85ZiNehZgLARbRGivviF7iJnP-XoRB+g@mail.gmail.com>
Subject: Re: [PATCH] gpio: Make gpio_{request,free}_array gpio array parameter const
From: Eric Miao <eric.y.miao@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Brownell <david-b@pacbell.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 29, 2011, Lars-Peter Clausen <lars@metafoo.de> wrote:
> gpio_{request,free}_array should not (and do not) modify the passed gpio array,
> so make the parameter const.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/gpio/gpiolib.c     |    4 ++--
>  include/asm-generic/gpio.h |    4 ++--
>  include/linux/gpio.h       |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 649550e..27016c4 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1293,7 +1293,7 @@ EXPORT_SYMBOL_GPL(gpio_request_one);
>   * @array:     array of the 'struct gpio'
>   * @num:       how many GPIOs in the array
>   */
> -int gpio_request_array(struct gpio *array, size_t num)
> +int gpio_request_array(const struct gpio *array, size_t num)
>  {
>         int i, err;
>
> @@ -1316,7 +1316,7 @@ EXPORT_SYMBOL_GPL(gpio_request_array);
>   * @array:     array of the 'struct gpio'
>   * @num:       how many GPIOs in the array
>   */
> -void gpio_free_array(struct gpio *array, size_t num)
> +void gpio_free_array(const struct gpio *array, size_t num)
>  {
>         while (num--)
>                 gpio_free((array++)->gpio);
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index ff5c660..05119e7 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -193,8 +193,8 @@ struct gpio {
>  };
>
>  extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
> -extern int gpio_request_array(struct gpio *array, size_t num);
> -extern void gpio_free_array(struct gpio *array, size_t num);
> +extern int gpio_request_array(const struct gpio *array, size_t num);
> +extern void gpio_free_array(const struct gpio *array, size_t num);
>
>  #ifdef CONFIG_GPIO_SYSFS
>
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 32720ba..b2b610f 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -41,7 +41,7 @@ static inline int gpio_request_one(unsigned gpio,
>         return -ENOSYS;
>  }
>
> -static inline int gpio_request_array(struct gpio *array, size_t num)
> +static inline int gpio_request_array(const struct gpio *array, size_t num)
>  {
>         return -ENOSYS;
>  }
> @@ -54,7 +54,7 @@ static inline void gpio_free(unsigned gpio)
>         WARN_ON(1);
>  }
>
> -static inline void gpio_free_array(struct gpio *array, size_t num)
> +static inline void gpio_free_array(const struct gpio *array, size_t num)
>  {
>         might_sleep();
>
> --
> 1.7.2.3
>
>
