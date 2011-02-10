Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1BJXyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:54:06 -0500
Received: from www.tglx.de ([62.245.132.106]:43880 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab1BJXgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:07 -0500
Message-Id: <20110210223254.610019049@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:35:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 03/75] genirq: Rremove redundant check
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-redundant-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_NO_BALANCING is already checked in irq_can_set_affinity() above,
no need to check it again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -256,6 +256,7 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notif
  */
 static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 {
+	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
@@ -263,7 +264,7 @@ static int setup_affinity(unsigned int i
 	 * Preserve an userspace affinity setup, but make sure that
 	 * one of the targets is online.
 	 */
-	if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
+	if (desc->status & (IRQ_AFFINITY_SET)) {
 		if (cpumask_any_and(desc->irq_data.affinity, cpu_online_mask)
 		    < nr_cpu_ids)
 			goto set_affinity;


