Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1BJXuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:50:50 -0500
Received: from www.tglx.de ([62.245.132.106]:44003 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425Ab1BJXgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:36 -0500
Message-Id: <20110210223256.056643308@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 18/75] genirq: Do not fiddle with IRQ_MASKED in
	handle_edge_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-do-not-fiddle-with-irq_masked-in-handle_edge_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_MASKED is set in mask_ack_irq() anyway. Remove it from
handle_edge_irq() to allow simpler ab^HHreuse of that function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110202212551.918484270@linutronix.de>
---
 kernel/irq/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -609,7 +609,7 @@ handle_edge_irq(unsigned int irq, struct
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		if (!irq_check_poll(desc)) {
-			desc->status |= (IRQ_PENDING | IRQ_MASKED);
+			desc->status |= IRQ_PENDING;
 			mask_ack_irq(desc);
 			goto out_unlock;
 		}


