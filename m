Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2FOS6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:58:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38984 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab2FOS6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:58:17 -0400
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
Subject: [PATCH tip/core/rcu 5/6] rcu: Fix diagnostic-printk typo in rcutorture
Date: Fri, 15 Jun 2012 11:57:53 -0700
Message-Id: <1339786674-25265-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-5112-0000-0000-000009136D6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The rcu_torture_barrier() function has a copy-and-paste typo in the
string passed to rcutorture_shutdown_absorb(), which this commit fixes.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 08d8537..54a3745 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1700,7 +1700,7 @@ static int rcu_torture_barrier(void *arg)
 		schedule_timeout_interruptible(HZ / 10);
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_barrier task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
+	rcutorture_shutdown_absorb("rcu_torture_barrier");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(1);
 	return 0;
-- 
1.7.8

