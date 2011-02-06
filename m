Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1BFXjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:21 -0500
Received: from www.tglx.de ([62.245.132.106]:40312 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1BFXjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:20 -0500
Message-Id: <20110206233904.203393608@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 01/10] m68knommu: 5772: Replace private irq flow handler
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline;
	filename=m68knommu-5772-replace-private-irq-flow-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That handler lacks the minimal checks for action being zero etc. Keep
the weird flow - ack before handling - intact and call into
handle_simple_irq which does the right thing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Greg Ungerer <gerg@uclinux.org>
LKML-Reference: <20110202212552.413849952@linutronix.de>
---
 arch/m68knommu/platform/5272/intc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-next/arch/m68knommu/platform/5272/intc.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/5272/intc.c
+++ linux-next/arch/m68knommu/platform/5272/intc.c
@@ -137,11 +137,8 @@ static int intc_irq_set_type(unsigned in
  */
 static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
 {
-	kstat_incr_irqs_this_cpu(irq, desc);
-	desc->status |= IRQ_INPROGRESS;
 	desc->chip->ack(irq);
-	handle_IRQ_event(irq, desc->action);
-	desc->status &= ~IRQ_INPROGRESS;
+	handle_simple_irq(irq, desc);
 }
 
 static struct irq_chip intc_irq_chip = {


