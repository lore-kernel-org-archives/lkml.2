Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2H3Vqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:46:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40532 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2H3Vnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/15] rcu: Fix obsolete rcu_initiate_boost() header comment
Date: Thu, 30 Aug 2012 11:56:20 -0700
Message-Id: <1346352988-32444-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002BA06F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Commit 1217ed1b (rcu: permit rcu_read_unlock() to be called while holding
runqueue locks) made rcu_initiate_boost() restore irq state when releasing
the rcu_node structure's ->lock, but failed to update the header comment
accordingly.  This commit therefore brings the header comment up to date.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c930a47..3ea60c9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1193,9 +1193,9 @@ static int rcu_boost_kthread(void *arg)
  * kthread to start boosting them.  If there is an expedited grace
  * period in progress, it is always time to boost.
  *
- * The caller must hold rnp->lock, which this function releases,
- * but irqs remain disabled.  The ->boost_kthread_task is immortal,
- * so we don't need to worry about it going away.
+ * The caller must hold rnp->lock, which this function releases.
+ * The ->boost_kthread_task is immortal, so we don't need to worry
+ * about it going away.
  */
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 {
-- 
1.7.8

