Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab2FHUSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:18:45 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56560 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758916Ab2FHUSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:18:44 -0400
Message-ID: <4FD25E19.6090809@xenotime.net>
Date: Fri, 08 Jun 2012 13:18:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched/fair: fix lots of kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix lots of new kernel-doc warnings in kernel/sched/fair.c:

Warning(kernel/sched/fair.c:3625): No description found for parameter 'env'
Warning(kernel/sched/fair.c:3625): Excess function parameter 'sd' description in 'update_sg_lb_stats'
Warning(kernel/sched/fair.c:3735): No description found for parameter 'env'
Warning(kernel/sched/fair.c:3735): Excess function parameter 'sd' description in 'update_sd_pick_busiest'
Warning(kernel/sched/fair.c:3735): Excess function parameter 'this_cpu' description in 'update_sd_pick_busiest'
Warning(kernel/sched/fair.c:3774): No description found for parameter 'env'
Warning(kernel/sched/fair.c:3774): Excess function parameter 'sd' description in 'update_sd_lb_stats'
Warning(kernel/sched/fair.c:3774): Excess function parameter 'this_cpu' description in 'update_sd_lb_stats'
Warning(kernel/sched/fair.c:3774): Excess function parameter 'idle' description in 'update_sd_lb_stats'
Warning(kernel/sched/fair.c:3861): No description found for parameter 'env'
Warning(kernel/sched/fair.c:3861): Excess function parameter 'sd' description in 'check_asym_packing'
Warning(kernel/sched/fair.c:3861): Excess function parameter 'this_cpu' description in 'check_asym_packing'
Warning(kernel/sched/fair.c:3861): Excess function parameter 'imbalance' description in 'check_asym_packing'
Warning(kernel/sched/fair.c:3890): No description found for parameter 'env'
Warning(kernel/sched/fair.c:3890): Excess function parameter 'this_cpu' description in 'fix_small_imbalance'
Warning(kernel/sched/fair.c:3890): Excess function parameter 'imbalance' description in 'fix_small_imbalance'
Warning(kernel/sched/fair.c:4045): No description found for parameter 'env'
Warning(kernel/sched/fair.c:4045): Excess function parameter 'sd' description in 'find_busiest_group'
Warning(kernel/sched/fair.c:4045): Excess function parameter 'this_cpu' description in 'find_busiest_group'
Warning(kernel/sched/fair.c:4045): Excess function parameter 'imbalance' description in 'find_busiest_group'
Warning(kernel/sched/fair.c:4045): Excess function parameter 'idle' description in 'find_busiest_group'


Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- lnx-35-rc1.orig/kernel/sched/fair.c
+++ lnx-35-rc1/kernel/sched/fair.c
@@ -3610,7 +3610,7 @@ fix_small_capacity(struct sched_domain *
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
- * @sd: The sched_domain whose statistics are to be updated.
+ * @env: The load balancing environment.
  * @group: sched_group whose statistics are to be updated.
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
@@ -3719,11 +3719,10 @@ static inline void update_sg_lb_stats(st
 
 /**
  * update_sd_pick_busiest - return 1 on busiest group
- * @sd: sched_domain whose statistics are to be checked
+ * @env: The load balancing environment.
  * @sds: sched_domain statistics
  * @sg: sched_group candidate to be checked for being the busiest
  * @sgs: sched_group statistics
- * @this_cpu: the current cpu
  *
  * Determine if @sg is a busier group than the previously selected
  * busiest group.
@@ -3761,9 +3760,7 @@ static bool update_sd_pick_busiest(struc
 
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
- * @sd: sched_domain whose statistics are to be updated.
- * @this_cpu: Cpu for which load balance is currently performed.
- * @idle: Idle status of this_cpu
+ * @env: The load balancing environment.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
@@ -3852,10 +3849,8 @@ static inline void update_sd_lb_stats(st
  * Returns 1 when packing is required and a task should be moved to
  * this CPU.  The amount of the imbalance is returned in *imbalance.
  *
- * @sd: The sched_domain whose packing is to be checked.
+ * @env: The load balancing environment.
  * @sds: Statistics of the sched_domain which is to be packed
- * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
- * @imbalance: returns amount of imbalanced due to packing.
  */
 static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 {
@@ -3881,9 +3876,8 @@ static int check_asym_packing(struct lb_
  * fix_small_imbalance - Calculate the minor imbalance that exists
  *			amongst the groups of a sched_domain, during
  *			load balancing.
+ * @env: The load balancing environment.
  * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
- * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
- * @imbalance: Variable to store the imbalance.
  */
 static inline
 void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
@@ -4026,11 +4020,7 @@ static inline void calculate_imbalance(s
  * Also calculates the amount of weighted load which should be moved
  * to restore balance.
  *
- * @sd: The sched_domain whose busiest group is to be returned.
- * @this_cpu: The cpu for which load balancing is currently being performed.
- * @imbalance: Variable which stores amount of weighted load which should
- *		be moved to restore balance/put a group to idle.
- * @idle: The idle status of this_cpu.
+ * @env: The load balancing environment.
  * @cpus: The set of CPUs under consideration for load-balancing.
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
