Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2LERLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:11:16 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:51651 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2LERLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:11:15 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] sched: fix compilation warning
Date: Wed,  5 Dec 2012 17:10:40 +0000
Message-Id: <1354727440-20157-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following compilation warning is caused by Commit-ID:
c566e8e9e44b72b53091da20e2dedefc730f2ee2

kernel/sched/debug.c: In function ‘print_cfs_rq’:
kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
‘long int’, but argument 4 has type ‘long long int’ [-Wformat]
kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
‘long int’, but argument 3 has type ‘long long int’ [-Wformat]

where function atomic64_read returns long long int, but %ld was used in the
printf

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 kernel/sched/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.4.5

