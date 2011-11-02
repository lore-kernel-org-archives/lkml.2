Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1KBUgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:36:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59093 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1KBUba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 09/28] rcu: Document failing tick as cause of RCU CPU stall warning
Date: Wed,  2 Nov 2011 13:30:30 -0700
Message-Id: <1320265849-5744-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5930-0000-0000-000000D635C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of lclaudio's systems was seeing RCU CPU stall warnings from idle.
These turned out to be caused by a bug that stopped scheduling-clock
tick interrupts from being sent to a given CPU for several hundred seconds.
This commit therefore updates the documentation to call this out as a
possible cause for RCU CPU stall warnings.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 4e95920..f3e0625 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -101,6 +101,11 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
 	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
 	messages.
 
+o	A hardware or software issue shuts off the scheduler-clock
+	interrupt on a CPU that is not in dyntick-idle mode.  This
+	problem really has happened, and seems to be most likely to
+	result in RCU CPU stall warnings for CONFIG_NO_HZ=n kernels.
+
 o	A bug in the RCU implementation.
 
 o	A hardware failure.  This is quite unlikely, but has occurred
-- 
1.7.3.2

