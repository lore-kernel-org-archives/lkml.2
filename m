Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab1EANWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:38 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38909 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1EANW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/86] rcu: document new callback-queue trace information
Date: Sun,  1 May 2011 06:20:54 -0700
Message-Id: <1304256126-26015-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   58 +++++++++++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 13dbf9b..5aefd5f 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -21,23 +21,23 @@ rcu_pending() function decided that there was core RCU work to do).
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 b=10 ci=1460693 co=1648 ca=6448
-  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 b=10 ci=1459002 co=1614 ca=3310
-  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 b=10 ci=1610701 co=2015 ca=2378
-  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 b=10 ci=1427543 co=1430 ca=897
-  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 b=10 ci=1562249 co=1896 ca=533
-  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 b=10 ci=1777260 co=2137 ca=274
-  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 b=10 ci=1471186 co=1530 ca=243
-  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 b=10 ci=4026154 co=1948 ca=135
+  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 qs=.... b=10 ci=1460693 co=1648 ca=6448
+  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 qs=.... b=10 ci=1459002 co=1614 ca=3310
+  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 qs=.... b=10 ci=1610701 co=2015 ca=2378
+  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 qs=.... b=10 ci=1427543 co=1430 ca=897
+  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 qs=.... b=10 ci=1562249 co=1896 ca=533
+  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 qs=.... b=10 ci=1777260 co=2137 ca=274
+  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 qs=.... b=10 ci=1471186 co=1530 ca=243
+  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 qs=N.W. b=10 ci=4026154 co=1948 ca=135
 rcu_bh:
-  0!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=86475/1/0 df=11 of=0 ri=0 ql=0 b=10 ci=112 co=0 ca=0
-  1!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=90875/1/0 df=15 of=0 ri=0 ql=0 b=10 ci=143 co=0 ca=0
-  2!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=69661/1/0 df=21 of=0 ri=1 ql=0 b=10 ci=88 co=0 ca=0
-  3!c=18446744073709551494 g=18446744073709551494 pq=1 pqc=18446744073709551493 qp=0 dt=70349/1/0 df=13 of=0 ri=0 ql=0 b=10 ci=100 co=0 ca=0
-  4!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=38935/1/0 df=17 of=0 ri=0 ql=0 b=10 ci=36 co=0 ca=0
-  5!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=25127/1/0 df=7 of=0 ri=0 ql=0 b=10 ci=32 co=0 ca=0
-  6!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=22639/1/0 df=9 of=0 ri=0 ql=0 b=10 ci=44 co=0 ca=0
-  7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 b=10 ci=627 co=0 ca=0
+  0!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=86475/1/0 df=11 of=0 ri=0 ql=0 qs=.... b=10 ci=112 co=0 ca=0
+  1!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=90875/1/0 df=15 of=0 ri=0 ql=0 qs=.... b=10 ci=143 co=0 ca=0
+  2!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=69661/1/0 df=21 of=0 ri=1 ql=0 qs=.... b=10 ci=88 co=0 ca=0
+  3!c=18446744073709551494 g=18446744073709551494 pq=1 pqc=18446744073709551493 qp=0 dt=70349/1/0 df=13 of=0 ri=0 ql=0 qs=....  b=10 ci=100 co=0 ca=0
+  4!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=38935/1/0 df=17 of=0 ri=0 ql=0 qs=....  b=10 ci=36 co=0 ca=0
+  5!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=25127/1/0 df=7 of=0 ri=0 ql=0 qs=....  b=10 ci=32 co=0 ca=0
+  6!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=22639/1/0 df=9 of=0 ri=0 ql=0 qs=....  b=10 ci=44 co=0 ca=0
+  7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 qs=....  b=10 ci=627 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -120,6 +120,32 @@ o	"ql" is the number of RCU callbacks currently residing on
 	of what state they are in (new, waiting for grace period to
 	start, waiting for grace period to end, ready to invoke).
 
+o	"qs" gives an indication of the state of the callback queue
+	with four characters:
+
+	"N"	Indicates that there are callbacks queued that are not
+		ready to be handled by the next grace period, and thus
+		will be handled by the grace period following the next
+		one.
+
+	"R"	Indicates that there are callbacks queued that are
+		ready to be handled by the next grace period.
+
+	"W"	Indicates that there are callbacks queued that are
+		waiting on the current grace period.
+
+	"D"	Indicates that there are callbacks queued that have
+		already been handled by a prior grace period, and are
+		thus waiting to be invoked.  Note that callbacks in
+		the process of being invoked are not counted here.
+		Callbacks in the process of being invoked are those
+		that have been removed from the rcu_data structures
+		queues by rcu_do_batch(), but which have not yet been
+		invoked.
+
+	If there are no callbacks in a given one of the above states,
+	the corresponding character is replaced by ".".
+
 o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
-- 
1.7.3.2

