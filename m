Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1BFXEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:04:49 -0500
Received: from www.tglx.de ([62.245.132.106]:47664 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab1BFXEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:04:47 -0500
Message-Id: <20110206230415.574924775@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:04:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 1/3] tile: Convert irq_chip to new functions
References: <20110206230305.461141290@linutronix.de>
Content-Disposition: inline; filename=tile-convert-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/kernel/irq.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux-next/arch/tile/kernel/irq.c
===================================================================
--- linux-next.orig/arch/tile/kernel/irq.c
+++ linux-next/arch/tile/kernel/irq.c
@@ -176,43 +176,43 @@ void disable_percpu_irq(unsigned int irq
 EXPORT_SYMBOL(disable_percpu_irq);
 
 /* Mask an interrupt. */
-static void tile_irq_chip_mask(unsigned int irq)
+static void tile_irq_chip_mask(struct irq_data *d)
 {
-	mask_irqs(1UL << irq);
+	mask_irqs(1UL << d->irq);
 }
 
 /* Unmask an interrupt. */
-static void tile_irq_chip_unmask(unsigned int irq)
+static void tile_irq_chip_unmask(struct irq_data *d)
 {
-	unmask_irqs(1UL << irq);
+	unmask_irqs(1UL << d->irq);
 }
 
 /*
  * Clear an interrupt before processing it so that any new assertions
  * will trigger another irq.
  */
-static void tile_irq_chip_ack(unsigned int irq)
+static void tile_irq_chip_ack(struct irq_data *d)
 {
-	if ((unsigned long)get_irq_chip_data(irq) != IS_HW_CLEARED)
-		clear_irqs(1UL << irq);
+	if ((unsigned long)irq_data_get_irq_chip_data(d) != IS_HW_CLEARED)
+		clear_irqs(1UL << d->irq);
 }
 
 /*
  * For per-cpu interrupts, we need to avoid unmasking any interrupts
  * that we disabled via disable_percpu_irq().
  */
-static void tile_irq_chip_eoi(unsigned int irq)
+static void tile_irq_chip_eoi(struct irq_data *d)
 {
-	if (!(__get_cpu_var(irq_disable_mask) & (1UL << irq)))
-		unmask_irqs(1UL << irq);
+	if (!(__get_cpu_var(irq_disable_mask) & (1UL << d->irq)))
+		unmask_irqs(1UL << d->irq);
 }
 
 static struct irq_chip tile_irq_chip = {
 	.name = "tile_irq_chip",
-	.ack = tile_irq_chip_ack,
-	.eoi = tile_irq_chip_eoi,
-	.mask = tile_irq_chip_mask,
-	.unmask = tile_irq_chip_unmask,
+	.irq_ack = tile_irq_chip_ack,
+	.irq_eoi = tile_irq_chip_eoi,
+	.irq_mask = tile_irq_chip_mask,
+	.irq_unmask = tile_irq_chip_unmask,
 };
 
 void __init init_IRQ(void)


