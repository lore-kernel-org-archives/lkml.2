Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1ASVtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:49:02 -0500
Received: from www.tglx.de ([62.245.132.106]:33278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1ASVtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:49:00 -0500
Message-Id: <20110119210839.009582038@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:48:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mikael Starvik <starvik@axis.com>
Subject: [patch 04/37] cris: Use irq handling wrapper
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=cris-use-irq-handling-wrapper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper around __do_IRQ() so we can convert V10 and V32
seperately.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
---
 arch/cris/kernel/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c
+++ linux-2.6/arch/cris/kernel/irq.c
@@ -93,8 +93,8 @@ asmlinkage void do_IRQ(int irq, struct p
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq);
-        irq_exit();
+	generic_handle_irq(irq);
+	irq_exit();
 	set_irq_regs(old_regs);
 }
 


