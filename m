Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2FNNdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:33:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:53291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2FNNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:33:16 -0400
Message-Id: <20120614133212.750636820@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jun 2012 15:29:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/4] sched/fair: clean up __clear_buddies_*
References: <20120614132902.800827488@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly easier code flow, no functional changes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1115,10 +1115,10 @@ static void __clear_buddies_last(struct 
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->last == se)
-			cfs_rq->last = NULL;
-		else
+		if (cfs_rq->last != se)
 			break;
+
+		cfs_rq->last = NULL;
 	}
 }
 
@@ -1126,10 +1126,10 @@ static void __clear_buddies_next(struct 
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->next == se)
-			cfs_rq->next = NULL;
-		else
+		if (cfs_rq->next != se)
 			break;
+
+		cfs_rq->next = NULL;
 	}
 }
 
@@ -1137,10 +1137,10 @@ static void __clear_buddies_skip(struct 
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->skip == se)
-			cfs_rq->skip = NULL;
-		else
+		if (cfs_rq->skip != se)
 			break;
+
+		cfs_rq->skip = NULL;
 	}
 }
 


