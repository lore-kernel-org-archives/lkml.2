Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1BFXj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:28 -0500
Received: from www.tglx.de ([62.245.132.106]:40336 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab1BFXj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:26 -0500
Message-Id: <20110206233904.490845204@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 04/10] m68knommu: Convert coldfire intc-simr irq_chip to new
	functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline;
	filename=m68k-nommu-convert-coldfire-intc-simr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/coldfire/intc-simr.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-next/arch/m68knommu/platform/coldfire/intc-simr.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/coldfire/intc-simr.c
+++ linux-next/arch/m68knommu/platform/coldfire/intc-simr.c
@@ -20,8 +20,10 @@
 #include <asm/mcfsim.h>
 #include <asm/traps.h>
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(irq - MCFINT_VECBASE, MCFINTC0_SIMR);
@@ -30,8 +32,10 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(irq - MCFINT_VECBASE, MCFINTC0_CIMR);
@@ -40,8 +44,10 @@ static void intc_irq_unmask(unsigned int
 	}
 }
 
-static int intc_irq_set_type(unsigned int irq, unsigned int type)
+static int intc_irq_set_type(struct irq_data *d, unsigned int type)
 {
+	unsigned int irq = d->irq;
+
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(5, MCFINTC0_ICR0 + irq - MCFINT_VECBASE);
@@ -53,9 +59,9 @@ static int intc_irq_set_type(unsigned in
 
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


