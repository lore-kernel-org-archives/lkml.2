Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab2J3Qjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44477 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934070Ab2J3Qjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] rcu: Add new rcutorture module parameters to start/end test messages
Date: Tue, 30 Oct 2012 09:27:53 -0700
Message-Id: <1351614475-22895-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030162728.GA22648@linux.vnet.ibm.com>
 <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7606-0000-0000-000004EE34F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Several new rcutorture module parameters have been added, but are not
printed to the console at the beginning and end of tests, which makes
it difficult to reproduce a prior test.  This commit therefore adds
these new module parameters to the list printed at the beginning and
the end of the tests.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index aaa7b9f..7fa184f 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1396,12 +1396,16 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		 "fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		 "test_boost=%d/%d test_boost_interval=%d "
 		 "test_boost_duration=%d shutdown_secs=%d "
+		 "stall_cpu=%d stall_cpu_holdoff=%d "
+		 "n_barrier_cbs=%d "
 		 "onoff_interval=%d onoff_holdoff=%d\n",
 		 torture_type, tag, nrealreaders, nfakewriters,
 		 stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		 stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		 test_boost, cur_ops->can_boost,
 		 test_boost_interval, test_boost_duration, shutdown_secs,
+		 stall_cpu, stall_cpu_holdoff,
+		 n_barrier_cbs,
 		 onoff_interval, onoff_holdoff);
 }
 
-- 
1.7.8

