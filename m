Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0DOSN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:13:58 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33095 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0DOSNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 11/16] rcu: enable CPU_STALL_VERBOSE by default
Date: Thu, 15 Apr 2010 11:13:34 -0700
Message-Id: <1271355219-20714-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100415181255.GA19588@linux.vnet.ibm.com>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
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
index 8e5ec5e..4194e21 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -792,7 +792,7 @@ config RCU_CPU_STALL_DETECTOR
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

