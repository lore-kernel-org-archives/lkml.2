Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0IWAwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:52:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47628 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab0IWAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/8] rcu: fix _oddness handling of verbose stall warnings
Date: Wed, 22 Sep 2010 17:50:48 -0700
Message-Id: <1285203053-22068-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RCU_CPU_STALL_VERBOSE depends on CONFIG_TREE_PREEMPT_RCU, but
rcu_bootup_announce_oddness() complains if CONFIG_RCU_CPU_STALL_VERBOSE
is not set even in the case of CONFIG_TREE_RCU.  This commit therefore
fixes rcu_bootup_announce_oddness() to avoid insisting on impossibilities.

Reported-by: Guy Martin <gmsoft@tuxicoman.be>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e9e0bc7..71a4147 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -57,7 +57,7 @@ static void __init rcu_bootup_announce_oddness(void)
 	printk(KERN_INFO
 	       "\tRCU-based detection of stalled CPUs is disabled.\n");
 #endif
-#ifndef CONFIG_RCU_CPU_STALL_VERBOSE
+#if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
-- 
1.7.0.6

