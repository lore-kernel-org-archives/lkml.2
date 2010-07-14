Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab0GNUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:15:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40862 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab0GNUKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 24/30] rcu: add shiny new debug assists to Documentation/RCU/checklist.txt
Date: Wed, 14 Jul 2010 13:09:58 -0700
Message-Id: <1279138204-12849-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a section describing PROVE_RCU, DEBUG_OBJECTS_RCU_HEAD, and
the __rcu sparse checking to the RCU checklist.

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 790d1a8..c7c6788 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -365,3 +365,26 @@ over a rather long period of time, but improvements are always welcome!
 	and the compiler to freely reorder code into and out of RCU
 	read-side critical sections.  It is the responsibility of the
 	RCU update-side primitives to deal with this.
+
+17.	Use CONFIG_PROVE_RCU, CONFIG_DEBUG_OBJECTS_RCU_HEAD, and
+	the __rcu sparse checks to validate your RCU code.  These
+	can help find problems as follows:
+
+	CONFIG_PROVE_RCU: check that accesses to RCU-protected data
+		structures are carried out under the proper RCU
+		read-side critical section, while holding the right
+		combination of locks, or whatever other conditions
+		are appropriate.
+
+	CONFIG_DEBUG_OBJECTS_RCU_HEAD: check that you don't pass the
+		same object to call_rcu() (or friends) before an RCU
+		grace period has elapsed since the last time that you
+		passed that same object to call_rcu() (or friends).
+
+	__rcu sparse checks: tag the pointer to the RCU-protected data
+		structure with __rcu, and sparse will warn you if you
+		access that pointer without the services of one of the
+		variants of rcu_dereference().
+
+	These debugging aids can help you find problems that are
+	otherwise extremely difficult to spot.
-- 
1.7.0.6

