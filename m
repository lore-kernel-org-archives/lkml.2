Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1IPJTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:19:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:9757 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1IPJTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,392,1312182000"; 
   d="scan'208";a="49482450"
From: Wang Xingchao <xingchao.wang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, pjt@google.com, yong.zhang0@gmail.com,
        Wang Xingchao <xingchao.wang@intel.com>
Subject: [PATCH] sched: remove NULL pointer check
Date: Fri, 16 Sep 2011 17:16:03 -0400
Message-Id: <1316207763-3281-1-git-send-email-xingchao.wang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfs_rq->rb_leftmost is always true when calling __pick_first/last_entity(),
so it's safe to remove the NULL pointer check.

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
---
 kernel/sched_fair.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fef0bfd..55c67b5 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -417,9 +417,6 @@ static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
-	if (!left)
-		return NULL;
-
 	return rb_entry(left, struct sched_entity, run_node);
 }
 
@@ -438,9 +435,6 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
-	if (!last)
-		return NULL;
-
 	return rb_entry(last, struct sched_entity, run_node);
 }
 
-- 
1.7.1

