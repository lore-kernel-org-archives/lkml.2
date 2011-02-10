Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab1BJXgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:50 -0500
Received: from www.tglx.de ([62.245.132.106]:44049 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab1BJXgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:46 -0500
Message-Id: <20110210223255.575795511@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 13/75] genirq: Remove bogus conditional
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-bogus-conditional.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if (chip->irq_shutdown) check will always evaluate to true, as we
fill in chip->irq_shutdown with default_shutdown in
irq_chip_set_defaults() if the chip does not provide its own function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110202212551.667607458@linutronix.de>
---
 kernel/irq/manage.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -1058,10 +1058,7 @@ static struct irqaction *__free_irq(unsi
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
-		if (desc->irq_data.chip->irq_shutdown)
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-		else
-			desc->irq_data.chip->irq_disable(&desc->irq_data);
+		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 	}
 
 #ifdef CONFIG_SMP


