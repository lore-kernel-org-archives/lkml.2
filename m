Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1GVBOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 21:14:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:24606 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab1GVBOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 21:14:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,244,1309762800"; 
   d="scan'208";a="30139222"
Subject: sched: Cleanup duplicate local variable in
 {enqueue_dequeue}_task_fair
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 09:14:31 +0800
Message-ID: <1311297271.3938.1352.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to define a new "cfs_rq" variable in the "for" block.
Just use the one at the top of the function.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e7d67a9..47d6b17 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1336,7 +1336,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
@@ -1376,7 +1376,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);


