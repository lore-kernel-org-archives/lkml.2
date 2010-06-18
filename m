Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab0FRKTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:19:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:46958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab0FRKTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:19:33 -0400
Date: Fri, 18 Jun 2010 10:19:12 GMT
From: tip-bot for Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mikey@neuling.org,
       mingo@elte.hu
In-Reply-To: <24737.1276135581@neuling.org>
References: <24737.1276135581@neuling.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix comments to make them DocBook happy
Message-ID: <tip-b6b12294405e6ec029e627c49adf3193829a2685@git.kernel.org>
Git-Commit-ID: b6b12294405e6ec029e627c49adf3193829a2685
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:19:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6b12294405e6ec029e627c49adf3193829a2685
Gitweb:     http://git.kernel.org/tip/b6b12294405e6ec029e627c49adf3193829a2685
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Thu, 10 Jun 2010 12:06:21 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:55 +0200

sched: Fix comments to make them DocBook happy

Docbook fails in sched_fair.c due to comments added in the asymmetric
packing patch series.

This fixes these errors. No code changes.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <24737.1276135581@neuling.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e82c572..5e8f98c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2462,7 +2462,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
  * @sd: sched_domain whose statistics are to be checked
  * @sds: sched_domain statistics
  * @sg: sched_group candidate to be checked for being the busiest
- * @sds: sched_group statistics
+ * @sgs: sched_group statistics
+ * @this_cpu: the current cpu
  *
  * Determine if @sg is a busier group than the previously selected
  * busiest group.
@@ -2588,13 +2589,13 @@ int __weak arch_sd_sibiling_asym_packing(void)
  * assuming lower CPU number will be equivalent to lower a SMT thread
  * number.
  *
+ * Returns 1 when packing is required and a task should be moved to
+ * this CPU.  The amount of the imbalance is returned in *imbalance.
+ *
  * @sd: The sched_domain whose packing is to be checked.
  * @sds: Statistics of the sched_domain which is to be packed
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: returns amount of imbalanced due to packing.
- *
- * Returns 1 when packing is required and a task should be moved to
- * this CPU.  The amount of the imbalance is returned in *imbalance.
  */
 static int check_asym_packing(struct sched_domain *sd,
 			      struct sd_lb_stats *sds,
