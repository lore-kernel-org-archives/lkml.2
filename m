Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1AWPRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:08 -0500
Received: from www.tglx.de ([62.245.132.106]:58640 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1AWPRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:05 -0500
Message-Id: <20110123143837.035565371@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:16:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [patch 2/9] cris: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=cris-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/arch-v32/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/cris/arch-v32/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6/arch/cris/arch-v32/kernel/smp.c
@@ -26,7 +26,9 @@
 #define FLUSH_ALL (void*)0xffffffff
 
 /* Vector of locks used for various atomic operations */
-spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
+spinlock_t cris_atomic_locks[] = {
+	[0 ... LOCK_COUNT - 1] = __SPIN_LOCK_UNLOCKED(cris_atomic_locks)
+};
 
 /* CPU masks */
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;


