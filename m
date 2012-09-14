Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2INFsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:48:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:23161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2INFsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,421,1344236400"; 
   d="scan'208";a="203627575"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] sched:nohz rename clear_nohz_tick_stopped as nohz_balance_exit_idle
Date: Fri, 14 Sep 2012 13:47:24 +0800
Message-Id: <1347601645-20139-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347601645-20139-1-git-send-email-alex.shi@intel.com>
References: <1347601645-20139-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just rename the function clear_nohz_tick_stopped() to
nohz_balance_exit_idle(), that align with nohz_balance_enter_idle.

no function changes.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b681941..60d5505 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4634,7 +4634,7 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
-static inline void clear_nohz_tick_stopped(int cpu)
+static inline void nohz_balance_exit_idle(int cpu)
 {
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
@@ -4698,7 +4698,7 @@ static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DYING:
-		clear_nohz_tick_stopped(smp_processor_id());
+		nohz_balance_exit_idle(smp_processor_id());
 		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
@@ -4858,7 +4858,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
 	set_cpu_sd_state_busy();
-	clear_nohz_tick_stopped(cpu);
+	nohz_balance_exit_idle(cpu);
 
 	/*
 	 * None are in tickless mode and hence no need for NOHZ idle load
-- 
1.7.12

