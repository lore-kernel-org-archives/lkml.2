Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0DOSNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:13:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33070 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0DOSNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 15/16] rcu: permit discontiguous cpu_possible_mask CPU numbering
Date: Thu, 15 Apr 2010 11:13:38 -0700
Message-Id: <1271355219-20714-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100415181255.GA19588@linux.vnet.ibm.com>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TREE_RCU assumes that CPU numbering is contiguous, but some users need
large holes in the numbering to better map to hardware layout.  This patch
makes TREE_RCU (and TREE_PREEMPT_RCU) tolerate large holes in the CPU
numbering.  However, NR_CPUS must still be greater than the largest
CPU number.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f391886..c60fd74 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1913,7 +1913,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 
 	rnp = rsp->level[NUM_RCU_LVLS - 1];
 	for_each_possible_cpu(i) {
-		if (i > rnp->grphi)
+		while (i > rnp->grphi)
 			rnp++;
 		rsp->rda[i]->mynode = rnp;
 		rcu_boot_init_percpu_data(i, rsp);
-- 
1.7.0

