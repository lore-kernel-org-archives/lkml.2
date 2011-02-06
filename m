Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1BFXja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:30 -0500
Received: from www.tglx.de ([62.245.132.106]:40344 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab1BFXj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:29 -0500
Message-Id: <20110206233904.585812336@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 05/10] m68knommu: Convert 68328 ints irq_chip to new functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-nommu-convert-68328-ints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/68328/ints.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-next/arch/m68knommu/platform/68328/ints.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/68328/ints.c
+++ linux-next/arch/m68knommu/platform/68328/ints.c
@@ -135,20 +135,20 @@ void process_int(int vec, struct pt_regs
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *d)
 {
-	IMR &= ~(1<<irq);
+	IMR &= ~(1 << d->irq);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_data *d)
 {
-	IMR |= (1<<irq);
+	IMR |= (1 << d->irq);
 }
 
 static struct irq_chip intc_irq_chip = {
 	.name		= "M68K-INTC",
-	.mask		= intc_irq_mask,
-	.unmask		= intc_irq_unmask,
+	.irq_mask	= intc_irq_mask,
+	.irq_unmask	= intc_irq_unmask,
 };
 
 /*


