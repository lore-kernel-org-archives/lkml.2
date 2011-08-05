Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1HEOyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:54:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57166 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1HEOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:54:06 -0400
Date: Fri, 5 Aug 2011 22:38:22 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        Luis Claudio =?utf-8?B?Ui4gR29u77+9YWx2ZXM=?= 
	<lgoncalv@redhat.com>,
        Matthew Hank Sabins <msabins@linux.vnet.ibm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched/cpupri: Remove cpupri->pri_active
Message-ID: <20110805143822.GA3199@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
 <20110805082008.GA6628@zhy>
 <1312547447.18583.195.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312547447.18583.195.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 08:30:47AM -0400, Steven Rostedt wrote:
> On Fri, 2011-08-05 at 16:20 +0800, Yong Zhang wrote:
> > 
> > So cpupri->pri_active and macro CPUPRI_NR_PRI_WORDS is not needed any more?
> 
> It doesn't appear so. Looks like they can be removed too.
> 
> Want to send a patch?

No problem :)

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] sched/cpupri: Remove cpupri->pri_active

Since [sched/cpupri: Remove the vec->lock], member pri_active
of struct cpupri is not needed any more, just remove it. Also
clean stuff related to it.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched_cpupri.c |    3 ---
 kernel/sched_cpupri.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 90faffd..5839559 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -151,9 +151,6 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 	/*
 	 * If the cpu was currently mapped to a different value, we
 	 * need to map it to the new value then remove the old value.
-	 * Note, we must add the new value first, otherwise we risk the
-	 * cpu being cleared from pri_active, and this cpu could be
-	 * missed for a push or pull.
 	 */
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 6b4cd17..f6d7561 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -4,7 +4,6 @@
 #include <linux/sched.h>
 
 #define CPUPRI_NR_PRIORITIES	(MAX_RT_PRIO + 2)
-#define CPUPRI_NR_PRI_WORDS	BITS_TO_LONGS(CPUPRI_NR_PRIORITIES)
 
 #define CPUPRI_INVALID -1
 #define CPUPRI_IDLE     0
@@ -18,7 +17,6 @@ struct cpupri_vec {
 
 struct cpupri {
 	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
-	long              pri_active[CPUPRI_NR_PRI_WORDS];
 	int               cpu_to_pri[NR_CPUS];
 };
 
-- 
1.7.1

