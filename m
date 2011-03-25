Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1CYNuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:50:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:50880 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753316Ab1CYNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:50:41 -0400
Message-Id: <20110325135032.971429913@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:50:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch 1/2] microblaze: Convert to new irq function names
References: <20110325134935.999574075@linutronix.de>
Content-Disposition: inline; filename=microblaz.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namespace conversion scripted with coccinelle.

Also retrieve the irq type from irq_data in intc_enable_or_unmask()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/microblaze/kernel/intc.c    |    6 +++---
 arch/microblaze/pci/pci-common.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/arch/microblaze/kernel/intc.c
===================================================================
--- linux-2.6-tip.orig/arch/microblaze/kernel/intc.c
+++ linux-2.6-tip/arch/microblaze/kernel/intc.c
@@ -50,7 +50,7 @@ static void intc_enable_or_unmask(struct
 	 * ack function since the handle_level_irq function
 	 * acks the irq before calling the interrupt handler
 	 */
-	if (irq_to_desc(d->irq)->status & IRQ_LEVEL)
+	if (irqd_is_level_type(d))
 		out_be32(INTC_BASE + IAR, mask);
 }
 
@@ -157,11 +157,11 @@ void __init init_IRQ(void)
 
 	for (i = 0; i < nr_irq; ++i) {
 		if (intr_type & (0x00000001 << i)) {
-			set_irq_chip_and_handler_name(i, &intc_dev,
+			irq_set_chip_and_handler_name(i, &intc_dev,
 				handle_edge_irq, intc_dev.name);
 			irq_clear_status_flags(i, IRQ_LEVEL);
 		} else {
-			set_irq_chip_and_handler_name(i, &intc_dev,
+			irq_set_chip_and_handler_name(i, &intc_dev,
 				handle_level_irq, intc_dev.name);
 			irq_set_status_flags(i, IRQ_LEVEL);
 		}
Index: linux-2.6-tip/arch/microblaze/pci/pci-common.c
===================================================================
--- linux-2.6-tip.orig/arch/microblaze/pci/pci-common.c
+++ linux-2.6-tip/arch/microblaze/pci/pci-common.c
@@ -237,7 +237,7 @@ int pci_read_irq_line(struct pci_dev *pc
 
 		virq = irq_create_mapping(NULL, line);
 		if (virq != NO_IRQ)
-			set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
 	} else {
 		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
 			 oirq.size, oirq.specifier[0], oirq.specifier[1],


