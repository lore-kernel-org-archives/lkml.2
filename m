Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1CYNYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:24:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:34663 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752627Ab1CYNWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:06 -0400
Message-Id: <20110325132048.715335227@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 14/23] arm: gemini: Use proper irq accessor functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-gemini.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-gemini/gpio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-gemini/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-gemini/gpio.c
+++ linux-2.6-tip/arch/arm/mach-gemini/gpio.c
@@ -127,8 +127,8 @@ static int gpio_set_irq_type(struct irq_
 
 static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
+	unsigned int port = (unsigned int)irq_desc_get_handler_data(desc);
 	unsigned int gpio_irq_no, irq_stat;
-	unsigned int port = (unsigned int)get_irq_data(irq);
 
 	irq_stat = __raw_readl(GPIO_BASE(port) + GPIO_INT_STAT);
 
@@ -138,9 +138,7 @@ static void gpio_irq_handler(unsigned in
 		if ((irq_stat & 1) == 0)
 			continue;
 
-		BUG_ON(!(irq_desc[gpio_irq_no].handle_irq));
-		irq_desc[gpio_irq_no].handle_irq(gpio_irq_no,
-				&irq_desc[gpio_irq_no]);
+		generic_handle_irq(gpio_irq_no);
 	}
 }
 


