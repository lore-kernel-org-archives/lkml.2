Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0CWOun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0CWOul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:50:41 -0400
Date: Tue, 23 Mar 2010 15:48:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] proc_sched_show_task: use get_nr_threads()
Message-ID: <20100323144839.GA10424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, use get_nr_threads() helper to read signal->count which
we are going to change.

Like other callers, proc_sched_show_task() doesn't need the exactly
precise nr_threads.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched_debug.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- 34-rc1/kernel/sched_debug.c~MISC_1_PROC_SCHED_SHOW_TASK	2009-12-18 19:05:38.000000000 +0100
+++ 34-rc1/kernel/sched_debug.c	2010-03-23 14:52:42.000000000 +0100
@@ -384,15 +384,9 @@ __initcall(init_sched_debug_procfs);
 void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
-	unsigned long flags;
-	int num_threads = 1;
-
-	if (lock_task_sighand(p, &flags)) {
-		num_threads = atomic_read(&p->signal->count);
-		unlock_task_sighand(p, &flags);
-	}
 
-	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid, num_threads);
+	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
+						get_nr_threads(p));
 	SEQ_printf(m,
 		"---------------------------------------------------------\n");
 #define __P(F) \

