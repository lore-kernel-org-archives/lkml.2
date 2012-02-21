Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2BUHav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 02:30:51 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62859 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2BUHau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 02:30:50 -0500
Message-ID: <4F4347DF.2050002@ct.jp.nec.com>
Date: Tue, 21 Feb 2012 16:29:35 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] sched: Make initial SCHED_RR timeslace RR_TIMESLICE
References: <4F3C9995.3010800@ct.jp.nec.com> <1329744653.2293.342.camel@twins>
In-Reply-To: <1329744653.2293.342.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/20 22:30), Peter Zijlstra wrote:
> On Thu, 2012-02-16 at 14:52 +0900, Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Current the initial SCHED_RR timeslice of init_task is HZ, which means
>> 1s, and is not same as the default SCHED_RR timeslice DEF_TIMESLICE.
>>
>> Change that initial timeslice to the DEF_TIMESLICE.
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> No real objection, should we take the opportunity to rename to
> RR_TIMESLICE or somesuch?
> 

sounds reasonable.

===
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Current the initial SCHED_RR timeslice of init_task is HZ, which means
1s, and is not same as the default SCHED_RR timeslice DEF_TIMESLICE.

Change the initial timeslice to the RR_TIMESLICE, which is renamed from
DEF_TIMESLICE to clarify it's for SCHED_RR.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    6 ++++++
 kernel/sched/sched.h      |    4 ----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..f994d51 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,7 +149,7 @@ extern struct cred init_cred;
 	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
-		.time_slice	= HZ, 					\
+		.time_slice	= RR_TIMESLICE,				\
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2df7646..ee882cb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1234,6 +1234,12 @@ struct sched_rt_entity {
 #endif
 };
 
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
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


