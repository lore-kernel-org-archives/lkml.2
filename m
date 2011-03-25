Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1CYOVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:21:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:48784 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753309Ab1CYOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:21:18 -0400
Message-Id: <20110325142049.441954268@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:21:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 1/2] tile: Convert to new irq function names
References: <20110325141938.846639464@linutronix.de>
Content-Disposition: inline; filename=tile-namespace.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/arch/tile/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/tile/kernel/irq.c
+++ linux-2.6-tip/arch/tile/kernel/irq.c
@@ -241,14 +241,14 @@ void tile_irq_activate(unsigned int irq,
 	irq_flow_handler_t handle = handle_level_irq;
 	if (tile_irq_type == TILE_IRQ_PERCPU)
 		handle = handle_percpu_irq;
-	set_irq_chip_and_handler(irq, &tile_irq_chip, handle);
+	irq_set_chip_and_handler(irq, &tile_irq_chip, handle);
 
 	/*
 	 * Flag interrupts that are hardware-cleared so that ack()
 	 * won't clear them.
 	 */
 	if (tile_irq_type == TILE_IRQ_HW_CLEAR)
-		set_irq_chip_data(irq, (void *)IS_HW_CLEARED);
+		irq_set_chip_data(irq, (void *)IS_HW_CLEARED);
 }
 EXPORT_SYMBOL(tile_irq_activate);
 
@@ -290,7 +290,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
+		seq_printf(p, " %14s", irq_desc_get_chip(desc)->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action = action->next; action; action = action->next)


