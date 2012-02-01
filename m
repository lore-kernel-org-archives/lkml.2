Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2BATse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:48:34 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50742 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2BATn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:26 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/41] rcu: Move RCU_TRACE to lib/Kconfig.debug
Date: Wed,  1 Feb 2012 11:41:24 -0800
Message-Id: <1328125319-5205-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-2398-0000-0000-000003DD0E22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The RCU_TRACE kernel parameter has always been intended for debugging,
not for production use.  Formalize this by moving RCU_TRACE from
init/Kconfig to lib/Kconfig.debug.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig      |    9 ---------
 lib/Kconfig.debug |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..72f33fa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -438,15 +438,6 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
-config RCU_TRACE
-	bool "Enable tracing for RCU"
-	help
-	  This option provides tracing in RCU which presents stats
-	  in debugfs for debugging RCU implementation.
-
-	  Say Y here if you want to enable RCU tracing
-	  Say N if you are unsure.
-
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..bb67ce2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -927,6 +927,15 @@ config RCU_CPU_STALL_VERBOSE
 
 	  Say Y if you want to enable such checks.
 
+config RCU_TRACE
+	bool "Enable tracing for RCU"
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
-- 
1.7.8

