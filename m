Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0DTVpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:45:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47146 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0DTVpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:45:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/23] rcu: make dead code really dead
Date: Tue, 20 Apr 2010 14:44:34 -0700
Message-Id: <1271799895-21028-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100420214431.GA20777@linux.vnet.ibm.com>
References: <20100420214431.GA20777@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

cleanup: make dead code really dead

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e54c123..6042fb8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1236,11 +1236,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
-
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
+
 		/* Record dyntick-idle state. */
 		force_qs_rnp(rsp, dyntick_save_progress_counter);
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-- 
1.7.0

