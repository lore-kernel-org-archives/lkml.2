Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0HIWPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:30 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49295 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/10] rcu: Fix RCU_FANOUT help message
Date: Mon,  9 Aug 2010 15:15:08 -0700
Message-Id: <1281392111-25060-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cf244dc01bf68 added a fourth level to the TREE_RCU hierarchy,
but the RCU_FANOUT help message still said "cube root".  This commit
fixes this to "fourth root" and also emphasizes that production
systems are well-served by the default.  (Stress-testing RCU itself
uses small RCU_FANOUT values in order to test large-system code paths
on small(er) systems.)

Located-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9366954..7faa5d8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -384,9 +384,12 @@ config RCU_FANOUT
 	help
 	  This option controls the fanout of hierarchical implementations
 	  of RCU, allowing RCU to work efficiently on machines with
-	  large numbers of CPUs.  This value must be at least the cube
-	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
-	  systems and up to 262,144 for 64-bit systems.
+	  large numbers of CPUs.  This value must be at least the fourth
+	  root of NR_CPUS, which allows NR_CPUS to be insanely large.
+	  The default value of RCU_FANOUT should be used for production
+	  systems, but if you are stress-testing the RCU implementation
+	  itself, small RCU_FANOUT values allow you to test large-system
+	  code paths on small(er) systems.
 
 	  Select a specific number if testing RCU itself.
 	  Take the default if unsure.
-- 
1.7.0.6

