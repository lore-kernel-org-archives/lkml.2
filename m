Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1BFTWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:22:20 -0500
Received: from www.tglx.de ([62.245.132.106]:45168 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1BFTWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:15 -0500
Message-Id: <20110206192106.501651128@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:21:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 6/7] frv: Convert cpu irq_chip to new functions
References: <20110206192032.393682621@linutronix.de>
Content-Disposition: inline; filename=frv-convertcpu-irq-chips.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/irq.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-next/arch/frv/kernel/irq.c
===================================================================
--- linux-next.orig/arch/frv/kernel/irq.c
+++ linux-next/arch/frv/kernel/irq.c
@@ -95,35 +95,35 @@ int show_interrupts(struct seq_file *p, 
 /*
  * on-CPU PIC operations
  */
-static void frv_cpupic_ack(unsigned int irqlevel)
+static void frv_cpupic_ack(struct irq_data *d)
 {
-	__clr_RC(irqlevel);
+	__clr_RC(d->irq);
 	__clr_IRL();
 }
 
-static void frv_cpupic_mask(unsigned int irqlevel)
+static void frv_cpupic_mask(struct irq_data *d)
 {
-	__set_MASK(irqlevel);
+	__set_MASK(d->irq);
 }
 
-static void frv_cpupic_mask_ack(unsigned int irqlevel)
+static void frv_cpupic_mask_ack(struct irq_data *d)
 {
-	__set_MASK(irqlevel);
-	__clr_RC(irqlevel);
+	__set_MASK(d->irq);
+	__clr_RC(d->irq);
 	__clr_IRL();
 }
 
-static void frv_cpupic_unmask(unsigned int irqlevel)
+static void frv_cpupic_unmask(struct irq_data *d)
 {
-	__clr_MASK(irqlevel);
+	__clr_MASK(d->irq);
 }
 
 static struct irq_chip frv_cpu_pic = {
 	.name		= "cpu",
-	.ack		= frv_cpupic_ack,
-	.mask		= frv_cpupic_mask,
-	.mask_ack	= frv_cpupic_mask_ack,
-	.unmask		= frv_cpupic_unmask,
+	.irq_ack	= frv_cpupic_ack,
+	.irq_mask	= frv_cpupic_mask,
+	.irq_mask_ack	= frv_cpupic_mask_ack,
+	.irq_unmask	= frv_cpupic_unmask,
 };
 
 /*


