Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1BJXiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:52 -0500
Received: from www.tglx.de ([62.245.132.106]:44612 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab1BJXis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:48 -0500
Message-Id: <20110210223301.339808040@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 73/75] x86: ioapic: Use new move_irq functions
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=x86-use-new-move-irq-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the functions which take irq_data. We already have a pointer to
irq_data. That avoids a sparse irq lookup in move_*_irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -2405,7 +2405,7 @@ static inline void irq_complete_move(str
 static void ack_apic_edge(struct irq_data *data)
 {
 	irq_complete_move(data->chip_data);
-	move_native_irq(data->irq);
+	irq_move_irq(data);
 	ack_APIC_irq();
 }
 
@@ -2551,7 +2551,7 @@ static void ack_apic_level(struct irq_da
 		 * and you can go talk to the chipset vendor about it.
 		 */
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
+			irq_move_masked_irq(data);
 		unmask_ioapic(cfg);
 	}
 }


