Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0FJCGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 22:06:25 -0400
Received: from ozlabs.org ([203.10.76.45]:34746 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab0FJCGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 22:06:23 -0400
From: Michael Neuling <mikey@neuling.org>
To: a.p.zijlstra@chello.nl
cc: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       Steve Best <sfbest@us.ibm.com>
Subject: [PATCH] sched: update comments to make docbook happy
In-reply-to: <12629.1276124617@neuling.org>
References: <20100608045702.21D03CC895@localhost.localdomain> <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org> <12629.1276124617@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Thu, 10 Jun 2010 09:03:37 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 10 Jun 2010 12:06:21 +1000
Message-ID: <24737.1276135581@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Docbook fails in sched_fair.c due to comments added in the asymmetric
packing patch series.

This fixes these errors.  No code changes.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---

Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -2462,7 +2462,8 @@ static inline void update_sg_lb_stats(st
  * @sd: sched_domain whose statistics are to be checked
  * @sds: sched_domain statistics
  * @sg: sched_group candidate to be checked for being the busiest
- * @sds: sched_group statistics
+ * @sgs: sched_group statistics
+ * @this_cpu: the current cpu
  *
  * Determine if @sg is a busier group than the previously selected
  * busiest group.
@@ -2588,13 +2589,13 @@ int __weak arch_sd_sibiling_asym_packing
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
