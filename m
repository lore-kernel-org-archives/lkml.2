Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0IRTNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:13:31 -0400
Received: from kroah.org ([198.145.64.141]:51717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab0IRTCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:11 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.692635617@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [092/123] sched: set_cpus_allowed_ptr(): Dont use rq->migration_thread after unlock
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-set_cpus_allowed_ptr-don-t-use-rq-migration_thread-after-unlock.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 47a70985e5c093ae03d8ccf633c70a93761d86f2 upstream

Trivial typo fix. rq->migration_thread can be NULL after
task_rq_unlock(), this is why we have "mt" which should be
 used instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100330165829.GA18284@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7273,7 +7273,7 @@ int set_cpus_allowed_ptr(struct task_str
 
 		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
+		wake_up_process(mt);
 		put_task_struct(mt);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);


