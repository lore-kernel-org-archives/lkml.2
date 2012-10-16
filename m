Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2JPJoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:44:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60061 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2JPJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:44:00 -0400
Message-ID: <507D2C3C.8050706@gmail.com>
Date: Tue, 16 Oct 2012 20:43:24 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 RESEND] gpio: samsung: use pr_* instead of printk
References: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
In-Reply-To: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/12 19:25, Jingoo Han wrote:

> This patch uses pr_* instead of printk. Also, gpio_dbg
> is replaced with pr_debug.
> 
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>


If I recall correctly, I only offered review comments on this patch,
I wasn't directly involved in writing it, or in the submission
process, so you don't need to have my signed-off-by here.  It's also
generally considered impolite to add someone's signed-off-by without
asking for permission. I don't mind either way, but you don't need
my tag since you wrote the patch, I only provided feedback.

Thanks,
~Ryan

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-samsung.c |   18 ++++++------------
>  1 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index a006f0d..5c5ccdf 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -42,12 +42,6 @@
>  #include <plat/gpio-fns.h>
>  #include <plat/pm.h>
>  
> -#ifndef DEBUG_GPIO
> -#define gpio_dbg(x...) do { } while (0)
> -#else
> -#define gpio_dbg(x...) printk(KERN_DEBUG x)
> -#endif
> -
>  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
>  				unsigned int off, samsung_gpio_pull_t pull)
>  {
> @@ -599,7 +593,7 @@ static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
>  	con &= ~(0xf << con_4bit_shift(offset));
>  	__raw_writel(con, base + GPIOCON_OFF);
>  
> -	gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
> +	pr_debug("%s: %p: CON now %08lx\n", __func__, base, con);
>  
>  	return 0;
>  }
> @@ -627,7 +621,7 @@ static int samsung_gpiolib_4bit_output(struct gpio_chip *chip,
>  	__raw_writel(con, base + GPIOCON_OFF);
>  	__raw_writel(dat, base + GPIODAT_OFF);
>  
> -	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
> +	pr_debug("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
>  
>  	return 0;
>  }
> @@ -671,7 +665,7 @@ static int samsung_gpiolib_4bit2_input(struct gpio_chip *chip,
>  	con &= ~(0xf << con_4bit_shift(offset));
>  	__raw_writel(con, regcon);
>  
> -	gpio_dbg("%s: %p: CON %08lx\n", __func__, base, con);
> +	pr_debug("%s: %p: CON %08lx\n", __func__, base, con);
>  
>  	return 0;
>  }
> @@ -706,7 +700,7 @@ static int samsung_gpiolib_4bit2_output(struct gpio_chip *chip,
>  	__raw_writel(con, regcon);
>  	__raw_writel(dat, base + GPIODAT_OFF);
>  
> -	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
> +	pr_debug("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
>  
>  	return 0;
>  }
> @@ -926,10 +920,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
>  #ifdef CONFIG_PM
>  	if (chip->pm != NULL) {
>  		if (!chip->pm->save || !chip->pm->resume)
> -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
> +			pr_err("gpio: %s has missing PM functions\n",
>  			       gc->label);
>  	} else
> -		printk(KERN_ERR "gpio: %s has no PM function\n", gc->label);
> +		pr_err("gpio: %s has no PM function\n", gc->label);
>  #endif
>  
>  	/* gpiochip_add() prints own failure message on error. */


