Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1LPLgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:36:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LPLgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:36:03 -0500
Date: Fri, 16 Dec 2011 03:35:23 -0800
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-07cde2608a3b5c66515363f1b53623b1536b9785@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        glommer@parallels.com, a.p.zijlstra@chello.nl, keescook@chromium.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, a.p.zijlstra@chello.nl, glommer@parallels.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20111215164918.GA13003@www.outflux.net>
References: <20111215164918.GA13003@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add missing rcu_dereference() around ->
 real_parent usage
Git-Commit-ID: 07cde2608a3b5c66515363f1b53623b1536b9785
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 16 Dec 2011 03:35:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07cde2608a3b5c66515363f1b53623b1536b9785
Gitweb:     http://git.kernel.org/tip/07cde2608a3b5c66515363f1b53623b1536b9785
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 15 Dec 2011 08:49:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Dec 2011 09:42:09 +0100

sched: Add missing rcu_dereference() around ->real_parent usage

Wrap another ->real_parent dereference while under rcu_read_lock.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/20111215164918.GA13003@www.outflux.net
[ tidied up the changelog ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
