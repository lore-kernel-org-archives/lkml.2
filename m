Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2IJHLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:11:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:54476 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2IJHLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:11:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="220137257"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] sched: trigger_load_balance clean up
Date: Mon, 10 Sep 2012 15:10:59 +0800
Message-Id: <1347261059-24747-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347261059-24747-1-git-send-email-alex.shi@intel.com>
References: <1347261059-24747-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a redundant check for on_null_domain(cpu), and rerange the code
that make it more readable.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5bbc4bf..529092d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4934,11 +4934,13 @@ static inline int on_null_domain(int cpu)
 void trigger_load_balance(struct rq *rq, int cpu)
 {
 	/* Don't need to rebalance while attached to NULL domain */
-	if (time_after_eq(jiffies, rq->next_balance) &&
-	    likely(!on_null_domain(cpu)))
+	if (unlikely(on_null_domain(cpu)))
+		return;
+
+	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu))
 		nohz_balancer_kick(cpu);
 #endif
 }
-- 
1.7.5.4

