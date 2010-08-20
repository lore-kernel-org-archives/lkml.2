Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0HTSpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:45:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50182 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0HTSpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/7] rcu: document ways of stalling updates in low-memory situations
Date: Fri, 20 Aug 2010 11:45:41 -0700
Message-Id: <1282329945-26043-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index c7c6788..0c134f8 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -218,13 +218,22 @@ over a rather long period of time, but improvements are always welcome!
 	include:
 
 	a.	Keeping a count of the number of data-structure elements
-		used by the RCU-protected data structure, including those
-		waiting for a grace period to elapse.  Enforce a limit
-		on this number, stalling updates as needed to allow
-		previously deferred frees to complete.
-
-		Alternatively, limit only the number awaiting deferred
-		free rather than the total number of elements.
+		used by the RCU-protected data structure, including
+		those waiting for a grace period to elapse.  Enforce a
+		limit on this number, stalling updates as needed to allow
+		previously deferred frees to complete.	Alternatively,
+		limit only the number awaiting deferred free rather than
+		the total number of elements.
+
+		One way to stall the updates is to acquire the update-side
+		mutex.	(Don't try this with a spinlock -- other CPUs
+		spinning on the lock could prevent the grace period
+		from ever ending.)  Another way to stall the updates
+		is for the updates to use a wrapper function around
+		the memory allocator, so that this wrapper function
+		simulates OOM when there is too much memory awaiting an
+		RCU grace period.  There are of course many other
+		variations on this theme.
 
 	b.	Limiting update rate.  For example, if updates occur only
 		once per hour, then no explicit rate limiting is required,
-- 
1.7.0.6

