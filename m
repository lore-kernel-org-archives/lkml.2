Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0IRTm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:42:59 -0400
Received: from kroah.org ([198.145.64.141]:51664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0IRTCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:06 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.095598413@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [085/123] sched: Fix hotplug hang
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-hotplug-hang.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 70f1120527797adb31c68bdc6f1b45e182c342c7 upstream

The hot-unplug kstopmachine usage does a wakeup after
deactivating the cpu, hence we cannot use cpu_active()
here but must rely on the good olde online.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <1261326987.4314.24.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2376,7 +2376,7 @@ int select_task_rq(struct task_struct *p
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
-		     !cpu_active(cpu)))
+		     !cpu_online(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;


