Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1BFXjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:33 -0500
Received: from www.tglx.de ([62.245.132.106]:40357 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab1BFXjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:31 -0500
Message-Id: <20110206233904.680950623@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 06/10] m68knommu: Convert 68360 ints irq_chip to new functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-nommu-convert-68360-ints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/68360/ints.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-next/arch/m68knommu/platform/68360/ints.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/68360/ints.c
+++ linux-next/arch/m68knommu/platform/68360/ints.c
@@ -37,26 +37,26 @@ extern void *_ramvec[];
 /* The number of spurious interrupts */
 volatile unsigned int num_spurious;
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *d)
 {
-	pquicc->intr_cimr |= (1 << irq);
+	pquicc->intr_cimr |= (1 << d->irq);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_data *d)
 {
-	pquicc->intr_cimr &= ~(1 << irq);
+	pquicc->intr_cimr &= ~(1 << d->irq);
 }
 
-static void intc_irq_ack(unsigned int irq)
+static void intc_irq_ack(struct irq_data *d)
 {
-	pquicc->intr_cisr = (1 << irq);
+	pquicc->intr_cisr = (1 << d->irq);
 }
 
 static struct irq_chip intc_irq_chip = {
 	.name		= "M68K-INTC",
-	.mask		= intc_irq_mask,
-	.unmask		= intc_irq_unmask,
-	.ack		= intc_irq_ack,
+	.irq_mask	= intc_irq_mask,
+	.irq_unmask	= intc_irq_unmask,
+	.irq_ack	= intc_irq_ack,
 };
 
 /*


