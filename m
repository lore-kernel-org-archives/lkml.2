Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2E2HSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:18:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45244 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2E2HSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:18:20 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: [RFC PATCH 10/10] smp: remove ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
Date: Tue, 29 May 2012 15:16:05 +0800
Message-Id: <1338275765-3217-11-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

There is no user of those APIs anymore, just remove it.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/smp.h |    4 ----
 kernel/smp.c        |   20 --------------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 717fb74..a34d4f1 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -90,10 +90,6 @@ void kick_all_cpus_sync(void);
 void __init call_function_init(void);
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void ipi_call_lock(void);
-void ipi_call_unlock(void);
-void ipi_call_lock_irq(void);
-void ipi_call_unlock_irq(void);
 #else
 static inline void call_function_init(void) { }
 #endif
diff --git a/kernel/smp.c b/kernel/smp.c
index d0ae5b2..29dd40a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -581,26 +581,6 @@ int smp_call_function(smp_call_func_t func, void *info, int wait)
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
-
-void ipi_call_lock(void)
-{
-	raw_spin_lock(&call_function.lock);
-}
-
-void ipi_call_unlock(void)
-{
-	raw_spin_unlock(&call_function.lock);
-}
-
-void ipi_call_lock_irq(void)
-{
-	raw_spin_lock_irq(&call_function.lock);
-}
-
-void ipi_call_unlock_irq(void)
-{
-	raw_spin_unlock_irq(&call_function.lock);
-}
 #endif /* USE_GENERIC_SMP_HELPERS */
 
 /* Setup configured maximum number of CPUs to activate */
-- 
1.7.5.4

