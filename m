Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2DWQnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:43:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42049 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2DWQnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:43:37 -0400
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
Subject: [PATCH RFC tip/core/rcu 4/6] rcu: Clarify help text for RCU_BOOST_PRIO
Date: Mon, 23 Apr 2012 09:42:25 -0700
Message-Id: <1335199347-13926-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-3352-0000-0000-000004369A46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The old text confused real-time applications with real-time threads, so
that you pretty much needed to understand how this kernel configuration
parameter worked to understand the help text.  This commit therefore
attempts to make the help text human-readable.

Reported-by: Jörn Engel <joern@purestorage.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..85c6870 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -515,10 +515,25 @@ config RCU_BOOST_PRIO
 	depends on RCU_BOOST
 	default 1
 	help
-	  This option specifies the real-time priority to which preempted
-	  RCU readers are to be boosted.  If you are working with CPU-bound
-	  real-time applications, you should specify a priority higher then
-	  the highest-priority CPU-bound application.
+	  This option specifies the real-time priority to which long-term
+	  preempted RCU readers are to be boosted.  If you are working
+	  with a real-time application that has one or more CPU-bound
+	  threads running at a real-time priority level, you should set
+	  RCU_BOOST_PRIO to a priority higher then the highest-priority
+	  real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
+	  of 1 is appropriate in the common case, which is real-time
+	  applications that do not have any CPU-bound threads.
+
+	  Some real-time applications might not have a single real-time
+	  thread that saturates a given CPU, but instead might have
+	  multiple real-time threads that, taken together, fully utilize
+	  that CPU.  In this case, you should set RCU_BOOST_PRIO to
+	  a priority higher than the lowest-priority thread that is
+	  conspiring to prevent the CPU from running any non-real-time
+	  tasks.  For example, if one thread at priority 10 and another
+	  thread at priority 5 are between themselves fully consuming
+	  the CPU time on a given CPU, then RCU_BOOST_PRIO should be
+	  set to priority 6 or higher.
 
 	  Specify the real-time priority, or take the default if unsure.
 
-- 
1.7.8

