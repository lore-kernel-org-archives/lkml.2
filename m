Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab1LOQxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:53:40 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34979 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab1LOQxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:53:38 -0500
Date: Thu, 15 Dec 2011 08:49:18 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Glauber Costa <glommer@parallels.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH v2] sched: add missing rcu_deref around real_parent
Message-ID: <20111215164918.GA13003@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap another real_parent dereference while under rcu_read_lock.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: rebase to korg/tip/tip.git
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3c5b21e..c7ea688 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4784,7 +4784,7 @@ void sched_show_task(struct task_struct *p)
 	free = stack_not_used(p);
 #endif
 	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent),
+		task_pid_nr(p), task_pid_nr(rcu_dereference(p->real_parent)),
 		(unsigned long)task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
-- 
1.7.0.4

