Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0GNUNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:13:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52326 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab0GNUKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 27/30] rcu: apply ->rda changes to rcutree_trace.c
Date: Wed, 14 Jul 2010 13:10:01 -0700
Message-Id: <1279138204-12849-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The print_rcu_pendings() function used the ->rda[] array, so this
commit makes it instead use per_cpu_ptr().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 36c95b4..458e032 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -262,7 +262,7 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_data *rdp;
 
 	for_each_possible_cpu(cpu) {
-		rdp = rsp->rda[cpu];
+		rdp = per_cpu_ptr(rsp->rda, cpu);
 		if (rdp->beenonline)
 			print_one_rcu_pending(m, rdp);
 	}
-- 
1.7.0.6

