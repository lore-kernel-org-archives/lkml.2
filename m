Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0KGCGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:06:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49261 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab0KGCFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/12] rcu: Distinguish between boosting and boosted
Date: Sat,  6 Nov 2010 19:05:26 -0700
Message-Id: <1289095532-5398-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU priority boosting's tracing did not distinguish between ongoing
boosting and completion of boosting.  This commit therefore adds this
capability.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 419b796..297aa35 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -229,6 +229,9 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 		seq_puts(m, "no");
 		break;
 	case 1:
+		seq_puts(m, "begun");
+		break;
+	case 2:
 		seq_puts(m, "done");
 		break;
 	default:
@@ -284,6 +287,7 @@ static int rcu_boost(void)
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
+	rcu_preempt_ctrlblk.boosted_this_gp++;
 	rt_mutex_unlock(&mtx);
 	return rcu_preempt_ctrlblk.boost_tasks != NULL;
 }
-- 
1.7.0.6

