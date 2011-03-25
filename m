Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1CYNWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:34653 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab1CYNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:04 -0400
Message-Id: <20110325132048.607758904@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 13/23] arm: mxc: Use generic_handle_irq()
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-mxc.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-mxc/3ds_debugboard.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-mxc/3ds_debugboard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/3ds_debugboard.c
+++ linux-2.6-tip/arch/arm/plat-mxc/3ds_debugboard.c
@@ -100,14 +100,9 @@ static void mxc_expio_irq_handler(u32 ir
 
 	expio_irq = MXC_BOARD_IRQ_START;
 	for (; int_valid != 0; int_valid >>= 1, expio_irq++) {
-		struct irq_desc *d;
 		if ((int_valid & 1) == 0)
 			continue;
-		d = irq_desc + expio_irq;
-		if (unlikely(!(d->handle_irq)))
-			pr_err("\nEXPIO irq: %d unhandled\n", expio_irq);
-		else
-			d->handle_irq(expio_irq, d);
+		generic_handle_irq(expio_irq);
 	}
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);


