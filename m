Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2CYAc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:32:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2CYAcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:32:23 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: ep93xx: Remove unused inline function and useless pr_err message
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linus.walleij@stericsson.com
In-Reply-To: <201203211113.28122.hartleys@visionengravers.com>
References: <201203211113.28122.hartleys@visionengravers.com>
Date: Sat, 24 Mar 2012 17:07:36 +0000
Message-Id: <20120324170736.285BC3E0A0E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 11:13:27 -0700, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> Minor removal of an unused inline function and a useless pr_err message.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>

Applied, thanks.

g.

> ---
> 
> diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
> index 4ca5642..776b772 100644
> --- a/drivers/gpio/gpio-ep93xx.c
> +++ b/drivers/gpio/gpio-ep93xx.c
> @@ -12,8 +12,6 @@
>   *  published by the Free Software Foundation.
>   */
>  
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -65,11 +63,6 @@ static void ep93xx_gpio_update_int_params(unsigned port)
>  		EP93XX_GPIO_REG(int_en_register_offset[port]));
>  }
>  
> -static inline void ep93xx_gpio_int_mask(unsigned line)
> -{
> -	gpio_int_unmasked[line >> 3] &= ~(1 << (line & 7));
> -}
> -
>  static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
>  {
>  	int line = irq_to_gpio(irq);
> @@ -212,7 +205,6 @@ static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
>  		handler = handle_edge_irq;
>  		break;
>  	default:
> -		pr_err("failed to set irq type %d for gpio %d\n", type, gpio);
>  		return -EINVAL;
>  	}
>  

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
