Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1BCAsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:48:32 -0500
Received: from www.tglx.de ([62.245.132.106]:37635 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab1BCArW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:22 -0500
Message-Id: <20110203004210.240154507@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 3/8] microblaze: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline;
	filename=microblaze-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/intc.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: linux-2.6-tip/arch/microblaze/kernel/intc.c
===================================================================
--- linux-2.6-tip.orig/arch/microblaze/kernel/intc.c
+++ linux-2.6-tip/arch/microblaze/kernel/intc.c
@@ -74,25 +74,12 @@ static void intc_mask_ack(unsigned int i
 	out_be32(INTC_BASE + IAR, mask);
 }
 
-static void intc_end(unsigned int irq)
-{
-	unsigned long mask = 1 << irq;
-	pr_debug("end: %d\n", irq);
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
-		out_be32(INTC_BASE + SIE, mask);
-		/* ack level sensitive intr */
-		if (irq_desc[irq].status & IRQ_LEVEL)
-			out_be32(INTC_BASE + IAR, mask);
-	}
-}
-
 static struct irq_chip intc_dev = {
 	.name = "Xilinx INTC",
 	.unmask = intc_enable_or_unmask,
 	.mask = intc_disable_or_mask,
 	.ack = intc_ack,
 	.mask_ack = intc_mask_ack,
-	.end = intc_end,
 };
 
 unsigned int get_irq(struct pt_regs *regs)


