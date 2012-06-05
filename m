Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2FEPvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:51:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2FEPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:51:45 -0400
Date: Tue, 5 Jun 2012 08:51:27 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-8feb8e896d77439146d2e2ab3d0ab55bb5baf5fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, yong.zhang0@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        akpm@linux-foundation.org, yong.zhang0@gmail.com, tglx@linutronix.de
In-Reply-To: <1338275765-3217-11-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-11-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smp: Remove ipi_call_lock[_irq]()/
 ipi_call_unlock[_irq]()
Git-Commit-ID: 8feb8e896d77439146d2e2ab3d0ab55bb5baf5fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:51:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8feb8e896d77439146d2e2ab3d0ab55bb5baf5fc
Gitweb:     http://git.kernel.org/tip/8feb8e896d77439146d2e2ab3d0ab55bb5baf5fc
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:16:05 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:14 +0200

smp: Remove ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()

There is no user of those APIs anymore, just remove it.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: ralf@linux-mips.org
Cc: sshtylyov@mvista.com
Cc: david.daney@cavium.com
Cc: nikunj@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: axboe@kernel.dk
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1338275765-3217-11-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
