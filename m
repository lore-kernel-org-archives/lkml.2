Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1BJXis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:48 -0500
Received: from www.tglx.de ([62.245.132.106]:44587 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432Ab1BJXip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:45 -0500
Message-Id: <20110210223301.244605299@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 72/75] x86: Use the proper accessors in fixup_irqs()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=x86-irq-use-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/irq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/irq.c
+++ linux-2.6-tip/arch/x86/kernel/irq.c
@@ -327,7 +327,8 @@ void fixup_irqs(void)
 			affinity = cpu_all_mask;
 		}
 
-		if (!(desc->status & IRQ_MOVE_PCNTXT) && data->chip->irq_mask)
+		if (!irqd_can_move_in_process_context(data) &&
+		    data->chip->irq_mask)
 			data->chip->irq_mask(data);
 
 		if (data->chip->irq_set_affinity)
@@ -335,7 +336,8 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (!(desc->status & IRQ_MOVE_PCNTXT) && data->chip->irq_unmask)
+		if (!irqd_can_move_in_process_context(data) &&
+		    data->chip->irq_unmask)
 			data->chip->irq_unmask(data);
 
 		raw_spin_unlock(&desc->lock);


