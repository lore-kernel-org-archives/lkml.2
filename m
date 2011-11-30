Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1K3Fmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:42:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46800 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1K3Fmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:42:43 -0500
Date: Tue, 29 Nov 2011 23:42:29 -0600
From: Heechul Yun <heechul@illinois.edu>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [PATCH] sched: Proper initialization of root_task_group
Message-ID: <20111130054227.GA7808@heechul-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch fix a initialization issue.

Thanks

Heechul

---
The root_task_group.cfs_bandwidth and root_task_group.shares
were initialized multiple times unnecessarily which are corrected
by this patch.

Signed-off-by: Heechul Yun <heechul@illinois.edu>
---
 kernel/sched/core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca8fd44..0ed6978 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6772,6 +6772,11 @@ void __init sched_init(void)
 	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	root_task_group.shares = ROOT_TASK_GROUP_LOAD;
+	init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -6783,7 +6788,6 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		/*
 		 * How much cpu bandwidth does root_task_group get?
@@ -6804,7 +6808,6 @@ void __init sched_init(void)
 		 * We achieve this by letting root_task_group's tasks sit
 		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
-		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-- 
1.7.5.4

