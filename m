Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1BCAr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:28 -0500
Received: from www.tglx.de ([62.245.132.106]:37639 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1BCArZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:25 -0500
Message-Id: <20110203004210.434316157@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 5/8] mn10300: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=mn10300-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the remnoval of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/mn10300-serial.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6-tip/arch/mn10300/kernel/mn10300-serial.c
===================================================================
--- linux-2.6-tip.orig/arch/mn10300/kernel/mn10300-serial.c
+++ linux-2.6-tip/arch/mn10300/kernel/mn10300-serial.c
@@ -384,17 +384,12 @@ static void mn10300_serial_mask_ack(unsi
 	arch_local_irq_restore(flags);
 }
 
-static void mn10300_serial_nop(unsigned int irq)
-{
-}
-
 static struct irq_chip mn10300_serial_pic = {
 	.name		= "mnserial",
 	.ack		= mn10300_serial_mask_ack,
 	.mask		= mn10300_serial_mask_ack,
 	.mask_ack	= mn10300_serial_mask_ack,
 	.unmask		= mn10300_serial_nop,
-	.end		= mn10300_serial_nop,
 };
 
 


