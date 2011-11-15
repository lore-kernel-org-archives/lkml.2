Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1KOU3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:29:16 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54065 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab1KOU3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:29:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH tip/core/rcu 7/9] kdb: Make KDB use the new is_idle_task() API
Date: Tue, 15 Nov 2011 12:28:03 -0800
Message-Id: <1321388885-11211-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-3534-0000-0000-000001F6315C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Change from direct comparison of ->pid with zero to is_idle_task().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_support.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index 5532dd3..7d6fb40 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -636,7 +636,7 @@ char kdb_task_state_char (const struct task_struct *p)
 		(p->exit_state & EXIT_ZOMBIE) ? 'Z' :
 		(p->exit_state & EXIT_DEAD) ? 'E' :
 		(p->state & TASK_INTERRUPTIBLE) ? 'S' : '?';
-	if (p->pid == 0) {
+	if (is_idle_task(p)) {
 		/* Idle task.  Is it really idle, apart from the kdb
 		 * interrupt? */
 		if (!kdb_task_has_cpu(p) || kgdb_info[cpu].irq_depth == 1) {
-- 
1.7.3.2

