Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1LSO6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:58:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43600 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1LSO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:58:18 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [RFC PATCH v2 1/6] sched: Introduce the finish_arch_post_lock_switch() scheduler hook
Date: Mon, 19 Dec 2011 14:57:48 +0000
Message-Id: <1324306673-4282-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
References: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 19 Dec 2011 14:58:08.0574 (UTC) FILETIME=[9EB495E0:01CCBE5E]
X-MC-Unique: 111121914581403801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pBJEwZeH030985

This hook is called by the scheduler after rq->lock has been released
and interrupts enabled. It will be used in subsequent patches on the ARM
architecture.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..35390bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -984,6 +984,9 @@ static inline u64 global_rt_runtime(void)
 #ifndef finish_arch_switch
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
+#ifndef finish_arch_post_lock_switch
+# define finish_arch_post_lock_switch()	do { } while (0)
+#endif
 
 static inline int task_current(struct rq *rq, struct task_struct *p)
 {
@@ -3204,6 +3207,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	finish_arch_post_lock_switch();
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)

