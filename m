Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1BJXiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:03 -0500
Received: from www.tglx.de ([62.245.132.106]:44374 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab1BJXh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:59 -0500
Message-Id: <20110210223259.419825613@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 53/75] genirq: Remove CHECK_IRQ_PER_CPU from core code
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-fix-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c    |    4 ++--
 kernel/irq/migration.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -73,8 +73,8 @@ int irq_can_set_affinity(unsigned int ir
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->irq_data.chip ||
-	    !desc->irq_data.chip->irq_set_affinity)
+	if ((desc->status & (IRQ_PER_CPU | IRQ_NO_BALANCING)) ||
+	    !desc->irq_data.chip || !desc->irq_data.chip->irq_set_affinity)
 		return 0;
 
 	return 1;
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -15,7 +15,7 @@ void move_masked_irq(int irq)
 	/*
 	 * Paranoia: cpu-local interrupts shouldn't be calling in here anyway.
 	 */
-	if (CHECK_IRQ_PER_CPU(desc->status)) {
+	if (desc->status & (IRQ_PER_CPU | IRQ_NO_BALANCING)) {
 		WARN_ON(1);
 		return;
 	}


