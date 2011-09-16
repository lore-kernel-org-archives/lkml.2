Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1IPFv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:51:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:33679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1IPFv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:51:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="49037829"
From: Wang Xingchao <xingchao.wang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, yong.zhang0@gmail.com,
        alex.shi@intel.com, Wang Xingchao <xingchao.wang@intel.com>
Subject: [PATCH] cfs: NULL pointer check
Date: Fri, 16 Sep 2011 13:48:53 -0400
Message-Id: <1316195333-12374-1-git-send-email-xingchao.wang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

se maybe NULL if cfs_rq->rb_leftmost is NULL

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
---
 kernel/sched_fair.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fef0bfd..109b232 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1130,6 +1130,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	se = __pick_first_entity(cfs_rq);
+
+	if (!se)
+		return;
+
 	delta = curr->vruntime - se->vruntime;
 
 	if (delta < 0)
-- 
1.7.1

