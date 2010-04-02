Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0DBTLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:11:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0DBTLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:11:14 -0400
Date: Fri, 2 Apr 2010 19:10:52 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100330165829.GA18284@redhat.com>
References: <20100330165829.GA18284@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: set_cpus_allowed_ptr(): Don't use rq->migration_thread after unlock
Message-ID: <tip-47a70985e5c093ae03d8ccf633c70a93761d86f2@git.kernel.org>
Git-Commit-ID: 47a70985e5c093ae03d8ccf633c70a93761d86f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:10:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47a70985e5c093ae03d8ccf633c70a93761d86f2
Gitweb:     http://git.kernel.org/tip/47a70985e5c093ae03d8ccf633c70a93761d86f2
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 30 Mar 2010 18:58:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:11:05 +0200

sched: set_cpus_allowed_ptr(): Don't use rq->migration_thread after unlock

Trivial typo fix. rq->migration_thread can be NULL after
task_rq_unlock(), this is why we have "mt" which should be
 used instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100330165829.GA18284@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 49d2fa7..528a105 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5387,7 +5387,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 
 		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
+		wake_up_process(mt);
 		put_task_struct(mt);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);
