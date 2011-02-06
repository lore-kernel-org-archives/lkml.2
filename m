Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1BFXj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:26 -0500
Received: from www.tglx.de ([62.245.132.106]:40328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab1BFXjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:24 -0500
Message-Id: <20110206233904.395333689@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 03/10] m68knommu: Convert coldfire intc-2 irq_chip to new
	functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-nommu-convert-coldfire-intc2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/coldfire/intc-2.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-next/arch/m68knommu/platform/coldfire/intc-2.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/coldfire/intc-2.c
+++ linux-next/arch/m68knommu/platform/coldfire/intc-2.c
@@ -43,8 +43,10 @@ static u8 intc_intpri = MCFSIM_ICR_LEVEL
 #define NR_VECS	64
 #endif
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECBASE + NR_VECS)) {
 		unsigned long imraddr;
 		u32 val, imrbit;
@@ -64,8 +66,10 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECBASE + NR_VECS)) {
 		unsigned long intaddr, imraddr, icraddr;
 		u32 val, imrbit;
@@ -93,16 +97,16 @@ static void intc_irq_unmask(unsigned int
 	}
 }
 
-static int intc_irq_set_type(unsigned int irq, unsigned int type)
+static int intc_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	return 0;
 }
 
 static struct irq_chip intc_irq_chip = {
 	.name		= "CF-INTC",
-	.mask		= intc_irq_mask,
-	.unmask		= intc_irq_unmask,
-	.set_type	= intc_irq_set_type,
+	.irq_mask	= intc_irq_mask,
+	.irq_unmask	= intc_irq_unmask,
+	.irq_set_type	= intc_irq_set_type,
 };
 
 void __init init_IRQ(void)


