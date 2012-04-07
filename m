Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2DGI6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 04:58:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60790 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751588Ab2DGI6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 04:58:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198/LMrR0p8vKOM2cMuV4bDF/6JM6o7L7+yoPS0Iq
	UCt+8oqGE3bYOH
Message-ID: <1333789124.12677.15.camel@marge.simpson.net>
Subject: [patch] sched,cgroup_sched: fix up task_groups list buglet
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Date: Sat, 07 Apr 2012 10:58:44 +0200
In-Reply-To: <1333444788.9072.9.camel@marge.simpson.net>
References: <1333444106.9072.4.camel@marge.simpson.net>
	 <1333444788.9072.9.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 11:19 +0200, Mike Galbraith wrote: 
> ec514c48 made rt queues invisible in sched_debug, restore visibility.

<g> removing their cloak of invisibility might be a tad better than just
making them visible while futzing with annoying RT_GROUP_SCHED throttle.

sched,cgroup_sched: fix up task_groups list

Oops happened during sched migration to kernel/sched, fix it up.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: stable@kernel.org # v3.3
---
 kernel/sched/core.c  |    1 +
 kernel/sched/sched.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6871,6 +6871,7 @@ int in_sched_functions(unsigned long add
 
 #ifdef CONFIG_CGROUP_SCHED
 struct task_group root_task_group;
+LIST_HEAD(task_groups);
 #endif
 
 DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -80,7 +80,7 @@ extern struct mutex sched_domains_mutex;
 struct cfs_rq;
 struct rt_rq;
 
-static LIST_HEAD(task_groups);
+extern struct list_head task_groups;
 
 struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH


