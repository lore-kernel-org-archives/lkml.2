Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1BBVlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:41:46 -0500
Received: from www.tglx.de ([62.245.132.106]:38915 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1BBVlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:44 -0500
Message-Id: <20110202212551.918484270@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 3/8] genirq: Do not fiddle with IRQ_MASKED in handle_edge_irq()
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-redundant-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_MASKED is set in mask_ack_irq() anyway. Remove it from
handle_edge_irq() to allow simpler ab^HHreuse of that function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -632,7 +632,7 @@ handle_edge_irq(unsigned int irq, struct
 	 */
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
-		desc->status |= (IRQ_PENDING | IRQ_MASKED);
+		desc->status |= IRQ_PENDING;
 		mask_ack_irq(desc);
 		goto out_unlock;
 	}


