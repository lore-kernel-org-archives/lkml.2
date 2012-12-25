Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2LYDaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 22:30:17 -0500
Received: from mail-ye0-f177.google.com ([209.85.213.177]:47926 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2LYDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 22:30:14 -0500
X-Greylist: delayed 3270 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 22:30:14 EST
From: Fabio Estevam <festevam@gmail.com>
To: mingo@redhat.com
Cc: peterz@infradead.org, pjt@google.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] sched: Fix print format for u64
Date: Tue, 25 Dec 2012 00:28:18 -0200
Message-Id: <1356402498-25967-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit c566e8e9 (sched: Aggregate total task_group load) introduced the 
following build warning:

kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Wformat]
kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u64' [-Wformat]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..83ec463 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -222,7 +222,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
 			atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
-- 
1.7.9.5

