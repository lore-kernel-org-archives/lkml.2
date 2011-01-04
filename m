Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1ADJZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:25:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:52558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1ADJZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:25:16 -0500
Date: Tue, 4 Jan 2011 09:24:47 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, yong.zhang0@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
In-Reply-To: <1293803938-8157-1-git-send-email-yong.zhang0@gmail.com>
References: <1293803938-8157-1-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove redundant CONFIG_CGROUP_SCHED ifdef
Message-ID: <tip-6706125e291bd3dddd269e043323a6ab93ccd5fb@git.kernel.org>
Git-Commit-ID: 6706125e291bd3dddd269e043323a6ab93ccd5fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 09:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6706125e291bd3dddd269e043323a6ab93ccd5fb
Gitweb:     http://git.kernel.org/tip/6706125e291bd3dddd269e043323a6ab93ccd5fb
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Fri, 31 Dec 2010 21:58:58 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Jan 2011 09:42:03 +0100

sched: Remove redundant CONFIG_CGROUP_SCHED ifdef

CONFIG_[FAIR|RT]_GROUP_SCHED always means CONFIG_CGROUP_SCHED

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1293803938-8157-1-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
