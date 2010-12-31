Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0LaN7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 08:59:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41981 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0LaN7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 08:59:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IXJQjmLHAhw32Lnpq+TQQMueyRuwArsmEh3HClX6BX/Du2+SHE4fUArcMDgtovAF9y
         OIdhvveRFL8FB0y3W+mtlfYcrlpmv8vG4Vklnr4sGVT94+58giooryeCrPweajjJy1r+
         8j13+/TwbfW8CrV6eWgFol0EvHwG87hjxEEYs=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -tip] sched: remove redundant CONFIG_CGROUP_SCHED ifdef
Date: Fri, 31 Dec 2010 21:58:58 +0800
Message-Id: <1293803938-8157-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_[FAIR|RT]_GROUP_SCHED always means CONFIG_CGROUP_SCHED

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3925a1b..9f9dd8d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7777,7 +7777,6 @@ void __init sched_init(void)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
-#ifdef CONFIG_CGROUP_SCHED
 		/*
 		 * How much cpu bandwidth does init_task_group get?
 		 *
@@ -7798,16 +7797,13 @@ void __init sched_init(void)
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
-#endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
-#ifdef CONFIG_CGROUP_SCHED
 		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
 #endif
-#endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
-- 
1.7.0.4

