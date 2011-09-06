Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1IGGXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:23:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45045 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab1IGGWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/55] rcu: Drive configuration directly from SMP and PREEMPT
Date: Tue,  6 Sep 2011 11:00:05 -0700
Message-Id: <1315332049-2604-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit eliminates the possibility of running TREE_PREEMPT_RCU
when SMP=n and of running TINY_RCU when PREEMPT=y.  People who really
want these combinations can hand-edit init/Kconfig, but eliminating
them as choices for production systems reduces the amount of testing
required.  It will also allow cutting out a few #ifdefs.

Note that running TREE_RCU and TINY_RCU on single-CPU systems using
SMP-built kernels is still supported.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 412c21b..e22a691 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -391,7 +391,7 @@ config TREE_RCU
 
 config TREE_PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
-	depends on PREEMPT
+	depends on PREEMPT && SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
@@ -401,7 +401,7 @@ config TREE_PREEMPT_RCU
 
 config TINY_RCU
 	bool "UP-only small-memory-footprint RCU"
-	depends on !SMP
+	depends on !PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for UP systems from which real-time response
@@ -410,7 +410,7 @@ config TINY_RCU
 
 config TINY_PREEMPT_RCU
 	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on !SMP && PREEMPT
+	depends on PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is designed
 	  for real-time UP systems.  This option greatly reduces the
-- 
1.7.3.2

