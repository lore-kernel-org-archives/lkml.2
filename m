Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2FOVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:07:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49140 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2FOVHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:07:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/15] rcu: RCU_SAVE_DYNTICK code no longer ever dead
Date: Fri, 15 Jun 2012 14:06:10 -0700
Message-Id: <1339794370-28119-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-3270-0000-0000-000007375E56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Before RCU had unified idle, the RCU_SAVE_DYNTICK leg of the switch
statement in force_quiescent_state() was dead code for CONFIG_NO_HZ=n
kernel builds.  With unified idle, the code is never dead.  This commit
therefore removes the "if" statement designed to make gcc aware of when
the code was and was not dead.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 75ad92a..0b0c9cc 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1744,8 +1744,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
-		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
-			break; /* So gcc recognizes the dead code. */
 
 		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 
-- 
1.7.8

