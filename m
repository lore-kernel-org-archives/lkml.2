Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0LQUzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:55:14 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45568 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab0LQUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/20] rcu: Distinguish between boosting and boosted
Date: Fri, 17 Dec 2010 12:54:37 -0800
Message-Id: <1292619291-2468-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

RCU priority boosting's tracing did not distinguish between ongoing
boosting and completion of boosting.  This commit therefore adds this
capability.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f4e0df0..015abae 100644
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
1.7.3.2

