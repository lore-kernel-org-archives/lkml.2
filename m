Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1DRRnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:43:18 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:61260 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1DRRnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:43:10 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1303148589!17293328!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Date: Mon, 18 Apr 2011 12:43:08 -0500
Subject: RE: [patch 21/23] arm: Cleanup the irq namespace
Thread-Topic: [patch 21/23] arm: Cleanup the irq namespace
Thread-Index: Acv8fEb+1oyemEq2QLuuSggOvV2OfgBc4Q2A
Message-ID: <0D753D10438DA54287A00B027084269764D221CD07@AUSP01VMBX24.collaborationhost.net>
References: <20110325131617.258789658@linutronix.de>
 <20110325132049.382413026@linutronix.de>
In-Reply-To: <20110325132049.382413026@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 25, 2011 6:22 AM, Thomas Gleixner wrote:
> 
> Convert to the new function names. Automated with coccinelle.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
 arch/arm/mach-ep93xx/gpio.c                    |   31 +++++++++++------

> Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
> +++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> @@ -231,20 +231,29 @@ void __init ep93xx_gpio_init_irq(void)
>  
>  	for (gpio_irq = gpio_to_irq(0);
>  	     gpio_irq <= gpio_to_irq(EP93XX_GPIO_LINE_MAX_IRQ); ++gpio_irq) {
> -		set_irq_chip(gpio_irq, &ep93xx_gpio_irq_chip);
> -		set_irq_handler(gpio_irq, handle_level_irq);
> +		irq_set_chip(gpio_irq, &ep93xx_gpio_irq_chip);
> +		irq_set_handler(gpio_irq, handle_level_irq);
>  		set_irq_flags(gpio_irq, IRQF_VALID);
>  	}
>  
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO_AB, ep93xx_gpio_ab_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO0MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO1MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO2MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO3MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO4MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO5MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO6MUX, ep93xx_gpio_f_irq_handler);
> -	set_irq_chained_handler(IRQ_EP93XX_GPIO7MUX, ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO_AB,
> +				ep93xx_gpio_ab_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO0MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO1MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO2MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO3MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO4MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO5MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO6MUX,
> +				ep93xx_gpio_f_irq_handler);
> +	irq_set_chained_handler(IRQ_EP93XX_GPIO7MUX,
> +				ep93xx_gpio_f_irq_handler);
>  }

This appears to be the same patch as [27/29] arm: Cleanup the irq namespace

Regards,
Hartley