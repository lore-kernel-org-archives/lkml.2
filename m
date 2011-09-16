Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab1IPFi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:38:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:26772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab1IPFi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:38:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,391,1312182000"; 
   d="scan'208";a="54342271"
From: Wang Xingchao <xingchao.wang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, yong.zhang0@gmail.com,
        Wang Xingchao <xingchao.wang@intel.com>
Subject: [PATCH] cfs: remove unused 'if' condition checking
Date: Fri, 16 Sep 2011 13:35:52 -0400
Message-Id: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_running must be more than 1, so remove the checking

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
---
 kernel/sched_fair.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1ca2cd4..fef0bfd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1106,6 +1106,8 @@ static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
 	unsigned long ideal_runtime, delta_exec;
+	struct sched_entity *se;
+	s64 delta;
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
@@ -1127,16 +1129,14 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	if (delta_exec < sysctl_sched_min_granularity)
 		return;
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_first_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
+	se = __pick_first_entity(cfs_rq);
+	delta = curr->vruntime - se->vruntime;
 
-		if (delta < 0)
-			return;
+	if (delta < 0)
+		return;
 
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+	if (delta > ideal_runtime)
+		resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
-- 
1.7.1

