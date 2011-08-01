Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1HAJDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:03:55 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:39659 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1HAJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:03:49 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH] sched: Remove rq->avg_load_per_task
Date: Mon,  1 Aug 2011 11:03:28 +0200
Message-Id: <1312189408-17172-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

Since commit a2d47777 ("sched: fix stale value in average load per task")
the variable rq->avg_load_per_task is no longer required. Remove it.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
Against current Linus' tree (applies to v3.0 as well)
---
 kernel/sched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..b1e8f0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -520,8 +520,6 @@ struct rq {
 	int cpu;
 	int online;
 
-	unsigned long avg_load_per_task;
-
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -1569,11 +1567,9 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		rq->avg_load_per_task = rq->load.weight / nr_running;
-	else
-		rq->avg_load_per_task = 0;
+		return rq->load.weight / nr_running;
 
-	return rq->avg_load_per_task;
+	return 0;
 }
 
 #ifdef CONFIG_PREEMPT
-- 
1.7.6

