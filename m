Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2H3SqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:46:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58119 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2H3Spw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:45:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/5] rcu: Update rcutorture defaults
Date: Thu, 30 Aug 2012 11:45:08 -0700
Message-Id: <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120830184448.GA31753@linux.vnet.ibm.com>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-5518-0000-0000-00000739EE1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

A number of new features have been added to rcutorture over the years, but
the defaults have not been updated to include them.  This commit therefore
turns on a couple of them that have proven helpful and trustworthy, namely
periodic progress reports and testing of NO_HZ.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 25b1503..86315d3 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -53,10 +53,10 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@fre
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
-static int stat_interval;	/* Interval between stats, in seconds. */
+static int stat_interval = 60;	/* Interval between stats, in seconds. */
 				/*  Defaults to "only at end of test". */
 static bool verbose;		/* Print more debug info. */
-static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
+static bool test_no_idle_hz = 1; /* Test RCU support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
-- 
1.7.8

