Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2BPFyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:54:09 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52245 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2BPFyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:54:05 -0500
Message-ID: <4F3C9995.3010800@ct.jp.nec.com>
Date: Thu, 16 Feb 2012 14:52:21 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: Make initial SCHED_RR timeslace DEF_TIMESLICE
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Current the initial SCHED_RR timeslice of init_task is HZ, which means
1s, and is not same as the default SCHED_RR timeslice DEF_TIMESLICE.

Change that initial timeslice to the DEF_TIMESLICE.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    6 ++++++
 kernel/sched/sched.h      |    4 ----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..d04d67d 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,7 +149,7 @@ extern struct cred init_cred;
 	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
-		.time_slice	= HZ, 					\
+		.time_slice	= DEF_TIMESLICE,			\
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3dbc6b5..e84315a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1234,6 +1234,12 @@ struct sched_rt_entity {
 #endif
 };
 
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define DEF_TIMESLICE		(100 * HZ / 1000)
+
 struct rcu_node;
 
 enum perf_event_task_context {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8a2c768..c0660a1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -36,11 +36,7 @@ extern __read_mostly int scheduler_running;
 
 /*
  * These are the 'tuning knobs' of the scheduler:
- *
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
  */
-#define DEF_TIMESLICE		(100 * HZ / 1000)
 
 /*
  * single value that denotes runtime == period, ie unlimited time.
-- 
1.7.7.6

