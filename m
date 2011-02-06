Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1BFXjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:24 -0500
Received: from www.tglx.de ([62.245.132.106]:40319 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab1BFXjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:22 -0500
Message-Id: <20110206233904.299042298@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 02/10] m68knommu Convert coldfire intc irq_chip to new
	functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-nommu-convert-coldfire-intc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/coldfire/intc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-next/arch/m68knommu/platform/coldfire/intc.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/coldfire/intc.c
+++ linux-next/arch/m68knommu/platform/coldfire/intc.c
@@ -111,28 +111,28 @@ void mcf_autovector(int irq)
 #endif
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_data *d)
 {
-	if (mcf_irq2imr[irq])
-		mcf_setimr(mcf_irq2imr[irq]);
+	if (mcf_irq2imr[d->irq])
+		mcf_setimr(mcf_irq2imr[d->irq]);
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *d)
 {
-	if (mcf_irq2imr[irq])
-		mcf_clrimr(mcf_irq2imr[irq]);
+	if (mcf_irq2imr[d->irq])
+		mcf_clrimr(mcf_irq2imr[d->irq]);
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


