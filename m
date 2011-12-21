Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1LULSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:18:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45346 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1LULSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:20 -0500
Message-Id: <20111221111143.460166212@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/7] printk, lockdep: Remove lockdep_off() usage
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=printk-remove-lockdep_off-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've removed all reasons for disabling lockdep in the printk
code, stop doing so.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |    2 --
 1 file changed, 2 deletions(-)
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -884,7 +884,6 @@ asmlinkage int vprintk(const char *fmt, 
 		zap_locks();
 	}
 
-	lockdep_off();
 	raw_spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
@@ -981,7 +980,6 @@ asmlinkage int vprintk(const char *fmt, 
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
 
-	lockdep_on();
 out_restore_irqs:
 	local_irq_restore(flags);
 


