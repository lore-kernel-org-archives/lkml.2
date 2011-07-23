Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1GWMwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 08:52:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:54787 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1GWMwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 08:52:40 -0400
Date: Sat, 23 Jul 2011 14:52:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: x86@kernel.org
Subject: [PATCH] x86: kprobes: Remove remove bogus preempt_enable
Message-ID: <alpine.LFD.2.02.1107231450550.2702@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_PREEMPT=n section of setup_singlestep() contains:

    preempt_enable_no_resched();

That's bogus in the CONFIG_PREEMPT=n section and it just never blew up
because preempt_enable_no_resched() is a NOP there. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/kprobes.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6-tip/arch/x86/kernel/kprobes.c
@@ -475,7 +475,6 @@ static void __kprobes setup_singlestep(s
 		 * stepping.
 		 */
 		regs->ip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
 		return;
 	}
 #endif
