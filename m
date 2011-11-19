Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1KSMus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 07:50:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56026 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1KSMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 07:50:40 -0500
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/3] rcu: Drive configuration directly from SMP and PREEMPT
Date: Sat, 19 Nov 2011 13:50:28 +0100
Message-Id: <1321707028-12487-4-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This commit eliminates the possibility of running TREE_PREEMPT_RCU
when SMP=n and of running TINY_RCU when PREEMPT=y.  People who really
want these combinations can hand-edit init/Kconfig, but eliminating
them as choices for production systems reduces the amount of testing
required.  It will also allow cutting out a few #ifdefs.

Note that running TREE_RCU and TINY_RCU on single-CPU systems using
SMP-built kernels is still supported.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit 8008e129dc90ff4f7a56cb033d6bd042afe3ed52 upstream
Cherry-picked for v3.0-rt and fixed-up merge conflicts
Note: This makes the depends lines for these options in init/Kconfig for v3.0-rt
match those for v3.2-rc2-rt3
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 init/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 89e40a4..5c1147e 100644
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
-	depends on !SMP && !PREEMPT_RT_FULL
+	depends on !PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for UP systems from which real-time response
@@ -410,7 +410,7 @@ config TINY_RCU
 
 config TINY_PREEMPT_RCU
 	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on !SMP && PREEMPT && !PREEMPT_RT_FULL
+	depends on PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is designed
 	  for real-time UP systems.  This option greatly reduces the
-- 
1.7.2.3

