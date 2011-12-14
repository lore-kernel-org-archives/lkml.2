Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab1LNWsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:48:40 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56225 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294Ab1LNWsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:48:37 -0500
Date: Wed, 14 Dec 2011 14:44:48 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] sched: add missing rcu_deref around real_parent
Message-ID: <20111214224448.GA27785@www.outflux.net>
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
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..407ed65 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6019,7 +6019,7 @@ void sched_show_task(struct task_struct *p)
 	free = stack_not_used(p);
 #endif
 	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent),
+		task_pid_nr(p), task_pid_nr(rcu_dereference(p->real_parent)),
 		(unsigned long)task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
-- 
1.7.0.4

