Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab1KOSRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:17:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39495 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1KOSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:17:04 -0500
From: Il Han <corone.il.han@gmail.com>
To: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] sched: add the inline keyword to the prototype.
Date: Wed, 16 Nov 2011 03:16:34 +0900
Message-Id: <1321380994-5768-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype has to agree with the definition.
Add the inline keyword to the prototype also

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..c7c93d2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -306,7 +306,7 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				   unsigned long delta_exec);
 
 /**************************************************************
@@ -1052,7 +1052,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__clear_buddies_skip(se);
 }
 
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
-- 
1.7.4.1

