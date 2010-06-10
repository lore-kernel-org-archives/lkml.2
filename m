Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0FJLLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:11:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39187 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886Ab0FJLK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:58 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/23] kernel/*: Fix unused but set warnings
Message-Id: <20100610111057.5BCBEB1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No real bugs I believe, just some dead code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/debug/kdb/kdb_bp.c  |    2 --
 kernel/hrtimer.c           |    3 +--
 kernel/sched_fair.c        |    3 +--
 kernel/sysctl.c            |    5 +----
 kernel/trace/ring_buffer.c |    2 --
 5 files changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6.35-rc2-gcc/kernel/sched_fair.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/sched_fair.c
+++ linux-2.6.35-rc2-gcc/kernel/sched_fair.c
@@ -1311,7 +1311,7 @@ static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
@@ -1346,7 +1346,6 @@ find_idlest_group(struct sched_domain *s
 
 		if (local_group) {
 			this_load = avg_load;
-			this = group;
 		} else if (avg_load < min_load) {
 			min_load = avg_load;
 			idlest = group;
Index: linux-2.6.35-rc2-gcc/kernel/sysctl.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/sysctl.c
+++ linux-2.6.35-rc2-gcc/kernel/sysctl.c
@@ -1711,10 +1711,7 @@ static __init int sysctl_init(void)
 {
 	sysctl_set_parent(NULL, root_table);
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
-	{
-		int err;
-		err = sysctl_check_table(current->nsproxy, root_table);
-	}
+	sysctl_check_table(current->nsproxy, root_table);
 #endif
 	return 0;
 }
Index: linux-2.6.35-rc2-gcc/kernel/hrtimer.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/hrtimer.c
+++ linux-2.6.35-rc2-gcc/kernel/hrtimer.c
@@ -1096,11 +1096,10 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
  */
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
-	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	ktime_t rem;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
 	rem = hrtimer_expires_remaining(timer);
 	unlock_hrtimer_base(timer, &flags);
 
Index: linux-2.6.35-rc2-gcc/kernel/debug/kdb/kdb_bp.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/debug/kdb/kdb_bp.c
+++ linux-2.6.35-rc2-gcc/kernel/debug/kdb/kdb_bp.c
@@ -274,7 +274,6 @@ static int kdb_bp(int argc, const char *
 	int i, bpno;
 	kdb_bp_t *bp, *bp_check;
 	int diag;
-	int free;
 	char *symname = NULL;
 	long offset = 0ul;
 	int nextarg;
@@ -305,7 +304,6 @@ static int kdb_bp(int argc, const char *
 	/*
 	 * Find an empty bp structure to allocate
 	 */
-	free = KDB_MAXBPT;
 	for (bpno = 0, bp = kdb_breakpoints; bpno < KDB_MAXBPT; bpno++, bp++) {
 		if (bp->bp_free)
 			break;
Index: linux-2.6.35-rc2-gcc/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/trace/ring_buffer.c
+++ linux-2.6.35-rc2-gcc/kernel/trace/ring_buffer.c
@@ -3007,13 +3007,11 @@ static void rb_advance_reader(struct rin
 
 static void rb_advance_iter(struct ring_buffer_iter *iter)
 {
-	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	unsigned length;
 
 	cpu_buffer = iter->cpu_buffer;
-	buffer = cpu_buffer->buffer;
 
 	/*
 	 * Check if we are at the end of the buffer.
