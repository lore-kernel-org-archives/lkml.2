Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2INFsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:48:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:23161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2INFsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:48:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,421,1344236400"; 
   d="scan'208";a="203627608"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] sched/balance: remove on_null_domain() in trigger_load_balance
Date: Fri, 14 Sep 2012 13:47:25 +0800
Message-Id: <1347601645-20139-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347601645-20139-1-git-send-email-alex.shi@intel.com>
References: <1347601645-20139-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Suresh's inverstigation, the first on_null_domain in
trigger_load_balance is for avoiding unnecessary loadbalances(from
softirq) when a SMP kernel running on UP machine.
The second on_null_domain is not needed, since nohz_kick_needed()
will return 0 in this scenario.

So, remove the 2nd on_null_domain calling.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 60d5505..1ae2c66 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4938,7 +4938,7 @@ void trigger_load_balance(struct rq *rq, int cpu)
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu))
 		nohz_balancer_kick(cpu);
 #endif
 }
-- 
1.7.12

