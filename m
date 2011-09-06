Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1IFIuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:50:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56505 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1IFIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:50:10 -0400
Date: Tue, 6 Sep 2011 09:49:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] gpio: rewrite U300 GPIO to use gpiolib
Message-ID: <20110906084938.GI6619@n2100.arm.linux.org.uk>
References: <1315297950-12720-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315297950-12720-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 10:32:30AM +0200, Linus Walleij wrote:
> This is based on top of the pending GPIO cleanups in Russells
> tree, if I can get some ACK on this I presume Russell can
> apply it to his branch.

> diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
> index 430a054..ba224b5 100644
> --- a/arch/arm/mach-u300/include/mach/gpio.h
> +++ b/arch/arm/mach-u300/include/mach/gpio.h
> @@ -13,35 +13,15 @@
>  #ifndef __MACH_U300_GPIO_H
>  #define __MACH_U300_GPIO_H
>  
> +#include <linux/io.h>
> +#include <mach/hardware.h>
> +#include <asm/irq.h>
> +#include <asm-generic/gpio.h>
>  
> +/* Map these overrides to gpiolib functions, simply */
> +#define gpio_get_value  __gpio_get_value
> +#define gpio_set_value  __gpio_set_value
> +#define gpio_cansleep   __gpio_cansleep
> +#define gpio_to_irq     __gpio_to_irq
>  
> +#endif

This is how mach/gpio.h ends up looking - two things:

1. is there any reason for asm/irq.h and linux/io.h in there?
2. asm/gpio.h already includes asm-generic/gpio.h and defines
   the dispatchers for the trivial case.

So, I think this is how it should look:

#ifndef __MACH_U300_GPIO_H
#define __MACH_U300_GPIO_H
#include <mach/hardware.h>
#endif

Or even just:

/* empty */

if mach/hardware.h include is not required for ARCH_NR_GPIOS.
