Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1ASVtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:18 -0500
Received: from www.tglx.de ([62.245.132.106]:33325 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1ASVtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:12 -0500
Message-Id: <20110119210838.852885775@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch 01/37] h8300: Convert to new irq_chip functions
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline;
 filename=h8300-convert-to-new-irq-chip-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just straight forward conversion.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/h8300/kernel/irq.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c
+++ linux-2.6/arch/h8300/kernel/irq.c
@@ -38,34 +38,34 @@ static inline int is_ext_irq(unsigned in
 	return (irq >= EXT_IRQ0 && irq <= (EXT_IRQ0 + EXT_IRQS));
 }
 
-static void h8300_enable_irq(unsigned int irq)
+static void h8300_enable_irq(struct irq_data *data)
 {
-	if (is_ext_irq(irq))
-		IER_REGS |= 1 << (irq - EXT_IRQ0);
+	if (is_ext_irq(data->irq))
+		IER_REGS |= 1 << (data->irq - EXT_IRQ0);
 }
 
-static void h8300_disable_irq(unsigned int irq)
+static void h8300_disable_irq(struct irq_data *data)
 {
-	if (is_ext_irq(irq))
-		IER_REGS &= ~(1 << (irq - EXT_IRQ0));
+	if (is_ext_irq(data->irq))
+		IER_REGS &= ~(1 << (data->irq - EXT_IRQ0));
 }
 
 static void h8300_end_irq(unsigned int irq)
 {
 }
 
-static unsigned int h8300_startup_irq(unsigned int irq)
+static unsigned int h8300_startup_irq(struct irq_data *data)
 {
-	if (is_ext_irq(irq))
-		return h8300_enable_irq_pin(irq);
+	if (is_ext_irq(data->irq))
+		return h8300_enable_irq_pin(data->irq);
 	else
 		return 0;
 }
 
-static void h8300_shutdown_irq(unsigned int irq)
+static void h8300_shutdown_irq(struct irq_data *data)
 {
-	if (is_ext_irq(irq))
-		h8300_disable_irq_pin(irq);
+	if (is_ext_irq(data->irq))
+		h8300_disable_irq_pin(data->irq);
 }
 
 /*
@@ -73,11 +73,10 @@ static void h8300_shutdown_irq(unsigned 
  */
 struct irq_chip h8300irq_chip = {
 	.name		= "H8300-INTC",
-	.startup	= h8300_startup_irq,
-	.shutdown	= h8300_shutdown_irq,
-	.enable		= h8300_enable_irq,
-	.disable	= h8300_disable_irq,
-	.ack		= NULL,
+	.irq_startup	= h8300_startup_irq,
+	.irq_shutdown	= h8300_shutdown_irq,
+	.irq_enable	= h8300_enable_irq,
+	.irq_disable	= h8300_disable_irq,
 	.end		= h8300_end_irq,
 };
 


