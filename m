Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1BFVq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:46:29 -0500
Received: from www.tglx.de ([62.245.132.106]:45940 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab1BFVqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:46:07 -0500
Message-Id: <20110206214534.953224553@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 6/7] mn103000: asb2364: Convert FPGA irq_chip to new functions
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn103000-asb2364-convert-fga-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/unit-asb2364/irq-fpga.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-next/arch/mn10300/unit-asb2364/irq-fpga.c
===================================================================
--- linux-next.orig/arch/mn10300/unit-asb2364/irq-fpga.c
+++ linux-next/arch/mn10300/unit-asb2364/irq-fpga.c
@@ -17,38 +17,38 @@
 /*
  * FPGA PIC operations
  */
-static void asb2364_fpga_mask(unsigned int irq)
+static void asb2364_fpga_mask(struct irq_data *d)
 {
-	ASB2364_FPGA_REG_MASK(irq - NR_CPU_IRQS) = 0x0001;
+	ASB2364_FPGA_REG_MASK(d->irq - NR_CPU_IRQS) = 0x0001;
 	SyncExBus();
 }
 
-static void asb2364_fpga_ack(unsigned int irq)
+static void asb2364_fpga_ack(struct irq_data *d)
 {
-	ASB2364_FPGA_REG_IRQ(irq - NR_CPU_IRQS) = 0x0001;
+	ASB2364_FPGA_REG_IRQ(d->irq - NR_CPU_IRQS) = 0x0001;
 	SyncExBus();
 }
 
-static void asb2364_fpga_mask_ack(unsigned int irq)
+static void asb2364_fpga_mask_ack(struct irq_data *d)
 {
-	ASB2364_FPGA_REG_MASK(irq - NR_CPU_IRQS) = 0x0001;
+	ASB2364_FPGA_REG_MASK(d->irq - NR_CPU_IRQS) = 0x0001;
 	SyncExBus();
-	ASB2364_FPGA_REG_IRQ(irq - NR_CPU_IRQS) = 0x0001;
+	ASB2364_FPGA_REG_IRQ(d->irq - NR_CPU_IRQS) = 0x0001;
 	SyncExBus();
 }
 
-static void asb2364_fpga_unmask(unsigned int irq)
+static void asb2364_fpga_unmask(struct irq_data *d)
 {
-	ASB2364_FPGA_REG_MASK(irq - NR_CPU_IRQS) = 0x0000;
+	ASB2364_FPGA_REG_MASK(d->irq - NR_CPU_IRQS) = 0x0000;
 	SyncExBus();
 }
 
 static struct irq_chip asb2364_fpga_pic = {
 	.name		= "fpga",
-	.ack		= asb2364_fpga_ack,
-	.mask		= asb2364_fpga_mask,
-	.mask_ack	= asb2364_fpga_mask_ack,
-	.unmask		= asb2364_fpga_unmask,
+	.irq_ack	= asb2364_fpga_ack,
+	.irq_mask	= asb2364_fpga_mask,
+	.irq_mask_ack	= asb2364_fpga_mask_ack,
+	.irq_unmask	= asb2364_fpga_unmask,
 };
 
 /*


