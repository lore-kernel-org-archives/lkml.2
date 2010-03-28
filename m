Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0C1DNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:13:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab0C1DNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:13:41 -0400
Message-ID: <4BAEC985.6020302@cn.fujitsu.com>
Date: Sun, 28 Mar 2010 11:14:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: remove lock acquirement when very eary boot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cleanup: remove lock acquirement when very eary boot

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 112edb5..e6014e1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1646,13 +1646,10 @@ EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 static void __init
 rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
-	unsigned long flags;
 	int i;
 	struct rcu_data *rdp = rsp->rda[cpu];
-	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
-	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
@@ -1662,7 +1659,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 #endif /* #ifdef CONFIG_NO_HZ */
 	rdp->cpu = cpu;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*

