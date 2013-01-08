Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3AHCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:16:58 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:63360 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3AHCJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:11 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/33] sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
Date: Tue,  8 Jan 2013 03:08:12 +0100
Message-Id: <1357610913-1080-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to avoid confusion.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 63b25e2..bfac40f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1302,6 +1302,12 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 
+	/*
+	 * For adaptive nohz case: We called ttwu_activate()
+	 * which just updated the rq clock. There is an
+	 * exception with p->on_rq != 0 but in this case
+	 * we are not idle and rq->idle_stamp == 0
+	 */
 	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
-- 
1.7.5.4

