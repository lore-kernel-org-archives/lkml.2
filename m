Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab2GGHyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 03:54:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49048 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GGHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 03:53:59 -0400
X-AuditID: 9c93016f-b7c7eae0000025c5-23-4ff7eb145c9a
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] sched: Use task_rq_unlock on __sched_setscheduler
Date: Sat,  7 Jul 2012 16:49:02 +0900
Message-Id: <1341647342-6742-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems there's no specific reason to open-code it.  I guess the
commit 0122ec5b02f76 ("sched: Add p->pi_lock to task_rq_lock()")
simply missed it.  Let's be consistent with others.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/sched/core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3987b9ddc563..1327f4de2054 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4343,9 +4343,7 @@ recheck:
 	 */
 	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
 			param->sched_priority == p->rt_priority))) {
-
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
 
-- 
1.7.10.4

