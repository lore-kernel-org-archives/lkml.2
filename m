Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1BFTWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:22:10 -0500
Received: from www.tglx.de ([62.245.132.106]:45165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1BFTWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:09 -0500
Message-Id: <20110206192106.300303769@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:21:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 4/7] frv: Convert mb93093 irq_chip to new function
References: <20110206192032.393682621@linutronix.de>
Content-Disposition: inline; filename=frv-convert-mb93093-irq-chips.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/irq-mb93093.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-next/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-next.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-next/arch/frv/kernel/irq-mb93093.c
@@ -35,44 +35,44 @@
 /*
  * off-CPU FPGA PIC operations
  */
-static void frv_fpga_mask(unsigned int irq)
+static void frv_fpga_mask(struct irq_data *d)
 {
 	uint16_t imr = __get_IMR();
 
-	imr |= 1 << (irq - IRQ_BASE_FPGA);
+	imr |= 1 << (d->irq - IRQ_BASE_FPGA);
 	__set_IMR(imr);
 }
 
-static void frv_fpga_ack(unsigned int irq)
+static void frv_fpga_ack(struct irq_data *d)
 {
-	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
+	__clr_IFR(1 << (d->irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_mask_ack(unsigned int irq)
+static void frv_fpga_mask_ack(struct irq_data *d)
 {
 	uint16_t imr = __get_IMR();
 
-	imr |= 1 << (irq - IRQ_BASE_FPGA);
+	imr |= 1 << (d->irq - IRQ_BASE_FPGA);
 	__set_IMR(imr);
 
-	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
+	__clr_IFR(1 << (d->irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_unmask(unsigned int irq)
+static void frv_fpga_unmask(struct irq_data *d)
 {
 	uint16_t imr = __get_IMR();
 
-	imr &= ~(1 << (irq - IRQ_BASE_FPGA));
+	imr &= ~(1 << (d->irq - IRQ_BASE_FPGA));
 
 	__set_IMR(imr);
 }
 
 static struct irq_chip frv_fpga_pic = {
 	.name		= "mb93093",
-	.ack		= frv_fpga_ack,
-	.mask		= frv_fpga_mask,
-	.mask_ack	= frv_fpga_mask_ack,
-	.unmask		= frv_fpga_unmask,
+	.irq_ack	= frv_fpga_ack,
+	.irq_mask	= frv_fpga_mask,
+	.irq_mask_ack	= frv_fpga_mask_ack,
+	.irq_unmask	= frv_fpga_unmask,
 };
 
 /*


