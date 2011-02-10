Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab1BJXs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:48:28 -0500
Received: from www.tglx.de ([62.245.132.106]:44158 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab1BJXhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:08 -0500
Message-Id: <20110210223257.299042487@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 31/75] genirq: Fixup core code namespace fallout
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-fixup-core.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c   |    6 +++---
 kernel/irq/manage.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -616,7 +616,7 @@ out_unlock:
 void
 handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
@@ -683,7 +683,7 @@ void
 set_irq_chip_and_handler(unsigned int irq, struct irq_chip *chip,
 			 irq_flow_handler_t handle)
 {
-	set_irq_chip(irq, chip);
+	irq_set_chip(irq, chip);
 	__set_irq_handler(irq, handle, 0, NULL);
 }
 
@@ -691,7 +691,7 @@ void
 set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name)
 {
-	set_irq_chip(irq, chip);
+	irq_set_chip(irq, chip);
 	__set_irq_handler(irq, handle, 0, name);
 }
 
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -260,7 +260,7 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notif
 static int
 setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct cpumask *set = irq_default_affinity;
 	int ret;
 


