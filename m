Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab1BKAHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:07:44 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:31444 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BKAHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:07:43 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1297382862!12328969!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Thu, 10 Feb 2011 18:07:40 -0600
Subject: RE: [patch 34/75] arm: ep93xx: Kill another instance of broken
 irq_desc	fiddling
Thread-Topic: [patch 34/75] arm: ep93xx: Kill another instance of broken
 irq_desc	fiddling
Thread-Index: AcvJe5FZeriZo9JPQz69YdLjdALeBwAAyLNA
Message-ID: <0D753D10438DA54287A00B027084269764CF3F0132@AUSP01VMBX24.collaborationhost.net>
References: <20110210222908.661199947@linutronix.de>
 <20110210223257.597367298@linutronix.de>
In-Reply-To: <20110210223257.597367298@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 10, 2011 4:37 PM, Thomas Gleixner wrote:
>
> 1. This is a copy of the borked code in gpiolib
> 2. If you need information about irq state which is not exposed, then talk
>    to the maintainer of that code instead of adding totaly horrible open
>    coded access.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Russell King <linux@arm.linux.org.uk>

As stated, this was following what was provided in gpiolib.

The information was only provided by debugfs to help development.  It's
not necessarily needed.

Minor note below.  But otherwise,

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

> ---
>  arch/arm/mach-ep93xx/gpio.c |   38 --------------------------------------
>  1 file changed, 38 deletions(-)
> 
> Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
> +++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> @@ -354,44 +354,6 @@ static void ep93xx_gpio_dbg_show(struct 
>  				is_out ? "out" : "in ",
>  				(data_reg & (1 << i)) ? "hi" : "lo");
>  
> -		if (!is_out) {
> -			int irq = gpio_to_irq(gpio);
> -			struct irq_desc *desc = irq_desc + irq;
> -
> -			if (irq >= 0 && desc->action) {
> -				char *trigger;
> -
> -				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
> -				case IRQ_TYPE_NONE:
> -					trigger = "(default)";
> -					break;
> -				case IRQ_TYPE_EDGE_FALLING:
> -					trigger = "edge-falling";
> -					break;
> -				case IRQ_TYPE_EDGE_RISING:
> -					trigger = "edge-rising";
> -					break;
> -				case IRQ_TYPE_EDGE_BOTH:
> -					trigger = "edge-both";
> -					break;
> -				case IRQ_TYPE_LEVEL_HIGH:
> -					trigger = "level-high";
> -					break;
> -				case IRQ_TYPE_LEVEL_LOW:
> -					trigger = "level-low";
> -					break;
> -				default:
> -					trigger = "?trigger?";
> -					break;
> -				}
> -
> -				seq_printf(s, " irq-%d %s%s",
> -						irq, trigger,
> -						(desc->status & IRQ_WAKEUP)
> -							? " wakeup" : "");
> -			}
> -		}
> -
>  		seq_printf(s, "\n");

This could just be merged into the previous seq_printf().

For that matter, the is_out variable could be removed and just code the test
into the seq_printf().

>  	}
>  }
