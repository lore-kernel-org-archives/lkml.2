Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0DTVsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:48:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54186 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0DTVpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:45:09 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/23] rcu: enable CPU_STALL_VERBOSE by default
Date: Tue, 20 Apr 2010 14:44:43 -0700
Message-Id: <1271799895-21028-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100420214431.GA20777@linux.vnet.ibm.com>
References: <20100420214431.GA20777@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_STALL_VERBOSE kernel configuration parameter was added to
2.6.34 to identify any preempted/blocked tasks that were preventing
the current grace period from completing when running preemptible
RCU.  As is conventional for new configurations parameters, this
defaulted disabled.  It is now time to enable it by default.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..40d7be7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -793,7 +793,7 @@ config RCU_CPU_STALL_DETECTOR
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
 	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
-	default n
+	default y
 	help
 	  This option causes RCU to printk detailed per-task information
 	  for any tasks that are stalling the current RCU grace period.
-- 
1.7.0

