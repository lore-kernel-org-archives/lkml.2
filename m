Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2LTTOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:14:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48935 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2LTTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:54 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] sched: fair: simplify can_migrate_task a bit
Date: Thu, 20 Dec 2012 14:11:29 -0500
Message-Id: <1356030701-16284-21-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already know that tsk_cache_hot is true at the end of
can_migrate_task, no need to double check that.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/sched/fair.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4603d6c..e03940e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3935,11 +3935,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		return 1;
 	}
 
-	if (tsk_cache_hot) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
-		return 0;
-	}
-	return 1;
+	schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
+	return 0;
 }
 
 /*
-- 
1.8.0

