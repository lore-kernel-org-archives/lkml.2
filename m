Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0C3RAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab0C3RAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:00:13 -0400
Date: Tue, 30 Mar 2010 18:58:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] set_cpus_allowed_ptr: don't use rq->migration_thread after
	unlock
Message-ID: <20100330165829.GA18284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial typo fix. rq->migration_thread can be NULL after task_rq_unlock(),
this is why we have "mt" which should be used instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/kernel/sched.c~S_C_A_P_USE_MT	2010-03-29 19:46:21.000000000 +0200
+++ 34-rc1/kernel/sched.c	2010-03-30 18:52:05.000000000 +0200
@@ -5365,7 +5365,7 @@ int set_cpus_allowed_ptr(struct task_str
 
 		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
+		wake_up_process(mt);
 		put_task_struct(mt);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);

