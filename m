Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2KSFeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:34:12 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46756 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2KSFdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:16 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 55/58] sched: Add prototype for sched_set_stop_task
Date: Sun, 18 Nov 2012 21:28:34 -0800
Message-Id: <1353302917-13995-56-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched/core.c defines a function sched_set_stop_task, only
referenced from kernel/stop_machine.c via an extern declaration; no
header file defines a prototype for sched_set_stop_task.  Add a
prototype right before its definition, to satisfy GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/sched/core.c:803:6: warning: no previous prototype for ‘sched_set_stop_task’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..2d2f5a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -800,6 +800,8 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #endif
 }
 
+void sched_set_stop_task(int cpu, struct task_struct *stop);
+
 void sched_set_stop_task(int cpu, struct task_struct *stop)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
-- 
1.7.10.4

