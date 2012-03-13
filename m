Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309Ab2CMJp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:45:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2CMJpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:45:23 -0400
Date: Tue, 13 Mar 2012 02:44:50 -0700
From: tip-bot for Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <tip-01f23e1630d944f7085cd8fd5793e31ea91c03d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        will.deacon@arm.com, catalin.marinas@arm.com, peterz@infradead.org,
        tglx@linutronix.de, frank.rowand@am.sony.com, Marc.Zyngier@arm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will.deacon@arm.com, peterz@infradead.org,
        tglx@linutronix.de, frank.rowand@am.sony.com, Marc.Zyngier@arm.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/arch] sched/arch:
  Introduce the finish_arch_post_lock_switch() scheduler callback
Git-Commit-ID: 01f23e1630d944f7085cd8fd5793e31ea91c03d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Mar 2012 02:44:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01f23e1630d944f7085cd8fd5793e31ea91c03d8
Gitweb:     http://git.kernel.org/tip/01f23e1630d944f7085cd8fd5793e31ea91c03d8
Author:     Catalin Marinas <catalin.marinas@arm.com>
AuthorDate: Sun, 27 Nov 2011 21:43:10 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Mar 2012 10:17:45 +0100

sched/arch: Introduce the finish_arch_post_lock_switch() scheduler callback

This callback is called by the scheduler after rq->lock has been released
and interrupts enabled. It will be used in subsequent patches on the ARM
architecture.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Tested-by: Marc Zyngier <Marc.Zyngier@arm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/sched.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..423f40f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1932,6 +1932,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	finish_arch_post_lock_switch();
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..d72483d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -692,6 +692,9 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #ifndef finish_arch_switch
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
+#ifndef finish_arch_post_lock_switch
+# define finish_arch_post_lock_switch()	do { } while (0)
+#endif
 
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
