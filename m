Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2ILXju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:39:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab2ILXjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 48/85] sched,cgroup: Fix up task_groups list
Date: Wed, 12 Sep 2012 16:36:31 -0700
Message-Id: <20120912233546.776750627@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit 35cf4e50b16331def6cfcbee11e49270b6db07f5 upstream.

With multiple instances of task_groups, for_each_rt_rq() is a noop,
no task groups having been added to the rt.c list instance.  This
renders __enable/disable_runtime() and print_rt_stats() noop, the
user (non) visible effect being that rt task groups are missing in
/proc/sched_debug.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344308413.6846.7.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c  |    1 +
 kernel/sched/sched.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7011,6 +7011,7 @@ int in_sched_functions(unsigned long add
 
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


