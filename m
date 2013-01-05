Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3AEIji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:39:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab3AEIhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210164"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 18/22] sched: add power/performance balance allowed flag
Date: Sat,  5 Jan 2013 16:37:47 +0800
Message-Id: <1357375071-11793-19-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the cpu condition is suitable for power balance, power_lb
will be set, perf_lb will be clean. If the condition is suitable for
performance balance, their value will will set oppositely.

If the domain is suitable for power balance, but balance should not
be down by this cpu, both of perf_lb and power_lb are cleared to wait a
suitable cpu to do power balance. That mean no any balance, neither
power balance nor performance balance in this domain.

This logical will be implemented by following patches.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0596e81..380c8cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4029,6 +4029,8 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+	int			power_lb;  /* if power balance needed */
+	int			perf_lb;   /* if performance balance needed */
 };
 
 /*
@@ -5179,6 +5181,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.power_lb	= 0,
+		.perf_lb	= 1,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
-- 
1.7.12

