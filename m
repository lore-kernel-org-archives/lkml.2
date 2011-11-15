Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1KOU2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:28:17 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54345 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab1KOU2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:28:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/9] rcu: Permit RCU_FAST_NO_HZ to be used by TREE_PREEMPT_RCU
Date: Tue, 15 Nov 2011 12:27:57 -0800
Message-Id: <1321388885-11211-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-5806-0000-0000-0000060E0078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The new implementation of RCU_FAST_NO_HZ is compatible with preemptible
RCU, so this commit removes the Kconfig restriction that previously
prohibited this.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 43298f9..82b6a4c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -469,14 +469,14 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on TREE_RCU && NO_HZ && SMP
+	depends on NO_HZ && SMP
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
-	  in order to allow the final CPU to enter dynticks-idle state
-	  more quickly.  On the other hand, this option increases the
-	  overhead of the dynticks-idle checking, particularly on systems
-	  with large numbers of CPUs.
+	  in order to allow CPUs to enter dynticks-idle state more
+	  quickly.  On the other hand, this option increases the overhead
+	  of the dynticks-idle checking, particularly on systems with
+	  large numbers of CPUs.
 
 	  Say Y if energy efficiency is critically important, particularly
 	  	if you have relatively few CPUs.
-- 
1.7.3.2

