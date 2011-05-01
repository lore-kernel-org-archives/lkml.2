Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab1EANcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:55 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48517 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 45/86] net,act_police,rcu: remove rcu_barrier()
Date: Sun,  1 May 2011 06:21:25 -0700
Message-Id: <1304256126-26015-45-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

There is no callback of this module maybe queued
since we use kfree_rcu(), we can safely remove the rcu_barrier().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/sched/act_police.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index d6bcd64..b3b9b32 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -396,7 +396,6 @@ static void __exit
 police_cleanup_module(void)
 {
 	tcf_unregister_action(&act_police_ops);
-	rcu_barrier(); /* Wait for completion of call_rcu()'s (tcf_police_free_rcu) */
 }
 
 module_init(police_init_module);
-- 
1.7.3.2

