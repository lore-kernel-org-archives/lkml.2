Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812Ab1EANiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:38:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48455 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab1EANWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 28/86] rcu: call __rcu_read_unlock() in exit_rcu for tree RCU
Date: Sun,  1 May 2011 06:21:08 -0700
Message-Id: <1304256126-26015-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Using __rcu_read_lock() in place of rcu_read_lock() leaves any debug
state as it really should be, namely with the lock still held.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a21413d..11b27f3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -858,7 +858,7 @@ void exit_rcu(void)
 	if (t->rcu_read_lock_nesting == 0)
 		return;
 	t->rcu_read_lock_nesting = 1;
-	rcu_read_unlock();
+	__rcu_read_unlock();
 }
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-- 
1.7.3.2

