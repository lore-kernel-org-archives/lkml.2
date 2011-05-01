Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab1EANiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:38:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48458 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab1EANW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 22/86] rcu: mark rcutorture boosting callback as being on-stack
Date: Sun,  1 May 2011 06:21:02 -0700
Message-Id: <1304256126-26015-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The CONFIG_DEBUG_OBJECTS_RCU_HEAD facility requires that on-stack RCU
callbacks be flagged explicitly to debug-objects using the
init_rcu_head_on_stack() and destroy_rcu_head_on_stack() functions.
This commit applies those functions to the rcutorture code that tests
RCU priority boosting.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 735d172..60984262 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -751,6 +751,7 @@ static int rcu_torture_boost(void *arg)
 		n_rcu_torture_boost_rterror++;
 	}
 
+	init_rcu_head_on_stack(&rbi.rcu);
 	/* Each pass through the following loop does one boost-test cycle. */
 	do {
 		/* Wait for the next test interval. */
@@ -810,6 +811,7 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 
 	/* Clean up and exit. */
 	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
+	destroy_rcu_head_on_stack(&rbi.rcu);
 	rcutorture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
-- 
1.7.3.2

