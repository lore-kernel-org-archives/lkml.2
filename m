Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0K3DtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:49:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:24933 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab0K3DtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:49:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,278,1288594800"; 
   d="scan'208";a="631466369"
Subject: [PATCH -tip] sched: fix uninitialized variable usage
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:51:37 +0800
Message-ID: <1291089097.2405.152.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-2.6/kernel/sched.c: In function ‘sched_destroy_group’:
linux-2.6/kernel/sched.c:8101: warning: ‘i’ is used uninitialized in this function

This is caused by commit 3d4b47b(Implement on-demand (active) cfs_rq list)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/sched.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 717bf7d..c3af198 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8088,7 +8088,6 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
-	int i;
 
 	/*
 	* Only empty task groups can be destroyed; so we can speculatively
@@ -8098,7 +8097,7 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 		return;
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	list_del_leaf_cfs_rq(tg->cfs_rq[i]);
+	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 #else /* !CONFG_FAIR_GROUP_SCHED */


