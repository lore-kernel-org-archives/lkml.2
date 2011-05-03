Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1ECScG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:32:06 -0400
Received: from relay.parallels.com ([195.214.232.42]:60312 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1ECScF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:32:05 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH] sched: balance_tasks: remove unused this_best_prio arg
Date: Tue, 3 May 2011 22:31:07 +0400
Message-ID: <1304447467-29200-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched_fair.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6fa833a..0653229 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2102,7 +2102,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
+	      struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0;
 	long rem_load_move = max_load_move;
@@ -2140,9 +2140,6 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 */
 		if (rem_load_move <= 0)
 			break;
-
-		if (p->prio < *this_best_prio)
-			*this_best_prio = p->prio;
 	}
 out:
 	/*
@@ -2202,7 +2199,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -2227,7 +2224,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, all_pinned,
 				busiest_cfs_rq);
 
 		if (!moved_load)
@@ -2253,11 +2250,11 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			&busiest->cfs);
 }
 #endif
 
@@ -2274,12 +2271,11 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      int *all_pinned)
 {
 	unsigned long total_load_moved = 0, load_moved;
-	int this_best_prio = this_rq->curr->prio;
 
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
+				sd, idle, all_pinned);
 
 		total_load_moved += load_moved;
 
-- 
1.7.0.4

