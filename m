Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1BBVlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:41:24 -0500
Received: from www.tglx.de ([62.245.132.106]:38861 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1BBVlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:23 -0500
Message-Id: <20110202212551.667607458@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/8] genirq: Remove bogus conditional
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-bogus-conditional.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if (chip->irq_shutdown) check will always evaluate to true, as we
fill in chip->irq_shutdown with default_shutdown in
irq_chip_set_defaults() if the chip does not provide its own function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -1003,10 +1003,7 @@ static struct irqaction *__free_irq(unsi
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


