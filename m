Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1JULka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:40:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab1JULk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:40:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hamo <hamo.by@gmail.com>
Subject: Re: [PATCH] gpio: fix build error in include/asm-generic/gpio.h
Date: Fri, 21 Oct 2011 13:39:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
References: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
In-Reply-To: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110211339.59280.arnd@arndb.de>
X-Provags-ID: V02:K0:KCJY/uLtHrC8pRm42ubtN8piTvzRsCTzbVGz3TYbNUI
 svOfEp4uLD9YGpEGzRS4qZ11ebG5Vg2O5YmRMVlsFrrnU65VZP
 BaFf7H1IOvDREak0PY2O+bS5ZhJwkLitt/OYz1zWPY7KRq5+gZ
 YGvtkFH+A1No0x45xl2zNzm7jKQcQwXT1SL/eUqiX5G2F3j/H/
 0nxnelnq5RqhJa3Aa7dV2CcP1bWO31p/tgLWY4IOqAIHZuiXXN
 IRUohIo/KdXjQZPSAyWYkIK6pQdGywqrJESz68eXOZfy/phve0
 zU1CE5zSEB38t/dCcUl/+oxJTbqsMFsUfxfD56yOPPxT62Xn1o
 iD3RkFX6AXmEN5fLQdbE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 October 2011, Hamo wrote:
> Should call the platform-specific __gpio_{get,set}_value
> instead of generic gpio_{get,set}_value
> 
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> ---
>  include/asm-generic/gpio.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>

Grant, can you put that into the gpio tree?

> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index d494001..6acff5d 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -220,13 +220,13 @@ static inline int gpio_cansleep(unsigned gpio)
>  static inline int gpio_get_value_cansleep(unsigned gpio)
>  {
>  	might_sleep();
> -	return gpio_get_value(gpio);
> +	return __gpio_get_value(gpio);
>  }
> 
>  static inline void gpio_set_value_cansleep(unsigned gpio, int value)
>  {
>  	might_sleep();
> -	gpio_set_value(gpio, value);
> +	__gpio_set_value(gpio, value);
>  }
> 
>  #endif /* !CONFIG_GPIOLIB */
> -- 
> 1.7.1
> 

