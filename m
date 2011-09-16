Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1IPIim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:38:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45319 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1IPIil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:38:41 -0400
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
From: Peter Zijlstra <peterz@infradead.org>
To: Wang Xingchao <xingchao.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, yong.zhang0@gmail.com,
        Paul Turner <pjt@google.com>
Date: Fri, 16 Sep 2011 10:38:32 +0200
In-Reply-To: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316162312.10174.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queued it as:

---
Subject: sched: Remove redundant test in check_preempt_tick()
From: Wang Xingchao <xingchao.wang@intel.com>
Date: Fri, 16 Sep 2011 13:35:52 -0400

The caller already checks for nr_running > 1, therefore we don't have
to do so again.

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1316194552-12019-1-git-send-email-xingchao.wang@intel.com
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


