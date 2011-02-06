Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1BFTWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:22:13 -0500
Received: from www.tglx.de ([62.245.132.106]:45167 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1BFTWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:12 -0500
Message-Id: <20110206192106.401266547@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:21:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 5/7] frv: Convert mb93493 irq_chip to new functions
References: <20110206192032.393682621@linutronix.de>
Content-Disposition: inline; filename=frv-convert-mb93493-irq-chips.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/irq-mb93493.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-next/arch/frv/kernel/irq-mb93493.c
===================================================================
--- linux-next.orig/arch/frv/kernel/irq-mb93493.c
+++ linux-next/arch/frv/kernel/irq-mb93493.c
@@ -45,46 +45,46 @@
  * daughter board PIC operations
  * - there is no way to ACK interrupts in the MB93493 chip
  */
-static void frv_mb93493_mask(unsigned int irq)
+static void frv_mb93493_mask(struct irq_data *d)
 {
 	uint32_t iqsr;
 	volatile void *piqsr;
 
-	if (IRQ_ROUTING & (1 << (irq - IRQ_BASE_MB93493)))
+	if (IRQ_ROUTING & (1 << (d->irq - IRQ_BASE_MB93493)))
 		piqsr = __addr_MB93493_IQSR(1);
 	else
 		piqsr = __addr_MB93493_IQSR(0);
 
 	iqsr = readl(piqsr);
-	iqsr &= ~(1 << (irq - IRQ_BASE_MB93493 + 16));
+	iqsr &= ~(1 << (d->irq - IRQ_BASE_MB93493 + 16));
 	writel(iqsr, piqsr);
 }
 
-static void frv_mb93493_ack(unsigned int irq)
+static void frv_mb93493_ack(struct irq_data *d)
 {
 }
 
-static void frv_mb93493_unmask(unsigned int irq)
+static void frv_mb93493_unmask(struct irq_data *d)
 {
 	uint32_t iqsr;
 	volatile void *piqsr;
 
-	if (IRQ_ROUTING & (1 << (irq - IRQ_BASE_MB93493)))
+	if (IRQ_ROUTING & (1 << (d->irq - IRQ_BASE_MB93493)))
 		piqsr = __addr_MB93493_IQSR(1);
 	else
 		piqsr = __addr_MB93493_IQSR(0);
 
 	iqsr = readl(piqsr);
-	iqsr |= 1 << (irq - IRQ_BASE_MB93493 + 16);
+	iqsr |= 1 << (d->irq - IRQ_BASE_MB93493 + 16);
 	writel(iqsr, piqsr);
 }
 
 static struct irq_chip frv_mb93493_pic = {
 	.name		= "mb93093",
-	.ack		= frv_mb93493_ack,
-	.mask		= frv_mb93493_mask,
-	.mask_ack	= frv_mb93493_mask,
-	.unmask		= frv_mb93493_unmask,
+	.irq_ack	= frv_mb93493_ack,
+	.irq_mask	= frv_mb93493_mask,
+	.irq_mask_ack	= frv_mb93493_mask,
+	.irq_unmask	= frv_mb93493_unmask,
 };
 
 /*


