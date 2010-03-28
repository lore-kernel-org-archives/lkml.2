Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0C1DOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:14:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab0C1DOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:14:49 -0400
Message-ID: <4BAEC9C8.8080704@cn.fujitsu.com>
Date: Sun, 28 Mar 2010 11:15:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: make dead code really dead
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cleanup: make dead code really dead

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e6014e1..1947c4e 100644
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

