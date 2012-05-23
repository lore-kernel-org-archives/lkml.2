Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab2EWVre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:47:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33808 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933769Ab2EWVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:46 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [PATCH 07/15] sched: SCHED_DEADLINE avg_update accounting.
Date: Wed, 23 May 2012 23:42:47 +0200
Message-Id: <1337809375-24295-8-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Make the core scheduler and load balancer aware of the load
produced by -deadline tasks, by updating the moving average
like for sched_rt.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/dl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/dl.c b/kernel/sched/dl.c
index 9bc48a0..0262c16 100644
--- a/kernel/sched/dl.c
+++ b/kernel/sched/dl.c
@@ -554,6 +554,8 @@ static void update_curr_dl(struct rq *rq)
 	curr->se.exec_start = rq->clock_task;
 	cpuacct_charge(curr, delta_exec);
 
+	sched_rt_avg_update(rq, delta_exec);
+
 	dl_se->runtime -= delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-- 
1.7.9.5

