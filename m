Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1CYORA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:17:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:36999 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752844Ab1CYOQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:16:57 -0400
Message-Id: <20110325141647.257414332@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:16:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 3/4] score: Convert to new irq function names
References: <20110325141528.825456671@linutronix.de>
Content-Disposition: inline; filename=score-namespace.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scripted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/score/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/score/kernel/irq.c
+++ linux-2.6-tip/arch/score/kernel/irq.c
@@ -92,7 +92,7 @@ void __init init_IRQ(void)
 	unsigned long target_addr;
 
 	for (index = 0; index < NR_IRQS; ++index)
-		set_irq_chip_and_handler(index, &score_irq_chip,
+		irq_set_chip_and_handler(index, &score_irq_chip,
 					 handle_level_irq);
 
 	for (target_addr = IRQ_VECTOR_BASE_ADDR;
@@ -136,7 +136,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_printf(p, "%3d: ", i);
 		seq_printf(p, "%10u ", kstat_irqs(i));
-		seq_printf(p, " %8s", get_irq_desc_chip(desc)->name ? : "-");
+		seq_printf(p, " %8s", irq_desc_get_chip(desc)->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);


