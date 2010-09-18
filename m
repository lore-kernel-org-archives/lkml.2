Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0IRTrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:47:41 -0400
Received: from kroah.org ([198.145.64.141]:51536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab0IRTBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:54 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.538618458@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [067/123] sched: Remove unused cpu_nr_migrations()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-remove-unused-cpu_nr_migrations.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

commit 9824a2b728b63e7ff586b9fd9293c819be79f0f3 upstream

cpu_nr_migrations() is not used, remove it.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4AF12A66.6020609@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    1 -
 kernel/sched.c        |   11 -----------
 2 files changed, 12 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,7 +145,6 @@ extern unsigned long this_cpu_load(void)
 
 
 extern void calc_global_load(void);
-extern u64 cpu_nr_migrations(int cpu);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -542,7 +542,6 @@ struct rq {
 	struct load_weight load;
 	unsigned long nr_load_updates;
 	u64 nr_switches;
-	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -2089,7 +2088,6 @@ void set_task_cpu(struct task_struct *p,
 #endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-		new_rq->nr_migrations_in++;
 #ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
@@ -3048,15 +3046,6 @@ static void calc_load_account_active(str
 }
 
 /*
- * Externally visible per-cpu scheduler statistics:
- * cpu_nr_migrations(cpu) - number of migrations into that cpu
- */
-u64 cpu_nr_migrations(int cpu)
-{
-	return cpu_rq(cpu)->nr_migrations_in;
-}
-
-/*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
  */


