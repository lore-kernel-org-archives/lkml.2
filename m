Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab1BJXrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:47:31 -0500
Received: from www.tglx.de ([62.245.132.106]:44220 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab1BJXhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:25 -0500
Message-Id: <20110210223257.597367298@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 34/75] arm: ep93xx: Kill another instance of broken irq_desc
	fiddling
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=arm-ep93xx-kill-another-instance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. This is a copy of the borked code in gpiolib
2. If you need information about irq state which is not exposed, then talk
   to the maintainer of that code instead of adding totaly horrible open
   coded access.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-ep93xx/gpio.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
+++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
@@ -354,44 +354,6 @@ static void ep93xx_gpio_dbg_show(struct 
 				is_out ? "out" : "in ",
 				(data_reg & (1 << i)) ? "hi" : "lo");
 
-		if (!is_out) {
-			int irq = gpio_to_irq(gpio);
-			struct irq_desc *desc = irq_desc + irq;
-
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-						irq, trigger,
-						(desc->status & IRQ_WAKEUP)
-							? " wakeup" : "");
-			}
-		}
-
 		seq_printf(s, "\n");
 	}
 }


