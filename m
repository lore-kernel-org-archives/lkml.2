Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1EANfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:35:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38933 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 31/86] rcu: further lower priority in rcu_yield()
Date: Sun,  1 May 2011 06:21:11 -0700
Message-Id: <1304256126-26015-31-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Although rcu_yield() dropped from real-time to normal priority, there
is always the possibility that the competing tasks have been niced.
So nice to 19 in rcu_yield() to help ensure that other tasks have a
better chance of running.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3295c7b..963b4b1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1561,6 +1561,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 	mod_timer(&yield_timer, jiffies + 2);
 	sp.sched_priority = 0;
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
+	set_user_nice(current, 19);
 	schedule();
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
-- 
1.7.3.2

