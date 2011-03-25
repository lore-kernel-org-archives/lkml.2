Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1CYO0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:26:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:51375 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753605Ab1CYO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:26:44 -0400
Message-Id: <20110325142511.639954930@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:26:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 1/2] unicore32: Convert to new irq function names
References: <20110325142344.058372664@linutronix.de>
Content-Disposition: inline; filename=unicore-namespace.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scripted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/unicore32/kernel/irq.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/arch/unicore32/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/unicore32/kernel/irq.c
+++ linux-2.6-tip/arch/unicore32/kernel/irq.c
@@ -321,24 +321,24 @@ void __init init_IRQ(void)
 	writel(1, INTC_ICCR);
 
 	for (irq = 0; irq < IRQ_GPIOHIGH; irq++) {
-		set_irq_chip(irq, &puv3_low_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &puv3_low_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		irq_modify_status(irq,
 			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN,
 			0);
 	}
 
 	for (irq = IRQ_GPIOHIGH + 1; irq < IRQ_GPIO0; irq++) {
-		set_irq_chip(irq, &puv3_normal_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &puv3_normal_chip);
+		irq_set_handler(irq, handle_level_irq);
 		irq_modify_status(irq,
 			IRQ_NOREQUEST | IRQ_NOAUTOEN,
 			IRQ_NOPROBE);
 	}
 
 	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO27; irq++) {
-		set_irq_chip(irq, &puv3_high_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &puv3_high_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		irq_modify_status(irq,
 			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN,
 			0);
@@ -347,8 +347,8 @@ void __init init_IRQ(void)
 	/*
 	 * Install handler for GPIO 0-27 edge detect interrupts
 	 */
-	set_irq_chip(IRQ_GPIOHIGH, &puv3_normal_chip);
-	set_irq_chained_handler(IRQ_GPIOHIGH, puv3_gpio_handler);
+	irq_set_chip(IRQ_GPIOHIGH, &puv3_normal_chip);
+	irq_set_chained_handler(IRQ_GPIOHIGH, puv3_gpio_handler);
 
 #ifdef CONFIG_PUV3_GPIO
 	puv3_init_gpio();


