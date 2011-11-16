Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1KPMp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:45:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55692 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1KPMp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:45:27 -0500
From: Il Han <corone.il.han@gmail.com>
To: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] sched: add the inline keyword to the prototype.
Date: Wed, 16 Nov 2011 21:45:04 +0900
Message-Id: <1321447504-4477-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype has to agree with the definition.
Add the inline keyword to the prototype also.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 kernel/sched_fair.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7e51b5b..74eeffe 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -306,7 +306,7 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				   unsigned long delta_exec);
 
 /**************************************************************
@@ -1065,7 +1065,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__clear_buddies_skip(se);
 }
 
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
@@ -1831,11 +1831,11 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	throttle_cfs_rq(cfs_rq);
 }
 #else
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
-- 
1.7.4.1

