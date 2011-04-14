Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab1DNTxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:53:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab1DNTxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:53:46 -0400
MIME-Version: 1.0
In-Reply-To: <1302808850-7608-1-git-send-email-linus.walleij@linaro.org>
References: <1302808850-7608-1-git-send-email-linus.walleij@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 14 Apr 2011 13:53:26 -0600
X-Google-Sender-Auth: jAPWddGFIbxJbfqHFriztOD3sPI
Message-ID: <BANLkTi=qjFtWeavDZbzY5bQR5vdnwAfnqw@mail.gmail.com>
Subject: Re: [PATCH] gpio: expose gpio_to_chip()
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 1:20 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> This makes the gpio_to_chip() function available to drivers. The
> usecase is when you want to add a few chip-specific operations
> apart from the ones exposed in struct gpio_chip.

Similar to interrupt handling, it probably isn't a good idea to expose
the gpio_chip directly.  Go ahead and add the ops you need and see
what it looks like.

g.

>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Grant, would be great to have your input on this.
>
> I will need this for enabling/disabling IRQ in certain pins
> and setting pullup/pulldown mode, setting sleep modes for pins
> etc when migrating arch/arm/mach-u300/gpio.c and
> arch/arm/plat-nomadik/gpio.c out from the arch/arm hierarchy
> and into drivers/gpio where they belong.
>
> An alternative solution is to implement generic function pointers
> for these things in struct gpio_chip, which I'm happy to do.
> Beware that it'll be quite a number of enumerators for all the
> funky pullup/pulldown modes people have, and for the sleep modes
> alike.
>
> Yours,
> Linus Walleij
> ---
>  drivers/gpio/gpiolib.c     |    2 +-
>  include/asm-generic/gpio.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 36a2974..af219bd 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -112,7 +112,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
>  }
>
>  /* caller holds gpio_lock *OR* gpio is marked as requested */
> -static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
> +struct gpio_chip *gpio_to_chip(unsigned gpio)
>  {
>        return gpio_desc[gpio].chip;
>  }
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index ff5c660..5a4d219 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -132,6 +132,7 @@ struct gpio_chip {
>  #endif
>  };
>
> +extern struct gpio_chip *gpio_to_chip(unsigned gpio);
>  extern const char *gpiochip_is_requested(struct gpio_chip *chip,
>                        unsigned offset);
>  extern int __must_check gpiochip_reserve(int start, int ngpio);
> --
> 1.7.4.4
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
