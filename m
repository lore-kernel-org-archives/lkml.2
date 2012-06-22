Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762468Ab2FVP26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:28:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55718 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2FVP0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 17/22] rcu: RCU_SAVE_DYNTICK code no longer ever dead
Date: Fri, 22 Jun 2012 08:17:16 -0700
Message-Id: <1340378241-6458-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7606-0000-0000-00000160F154
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
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 68a9d8b..1b0e441 100644
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

