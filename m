Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2LJI13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:27:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab2LJI0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808769"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 14/18] sched: add power/performance balance allowed flag
Date: Mon, 10 Dec 2012 16:22:30 +0800
Message-Id: <1355127754-8444-15-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
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
 kernel/sched/fair.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 729f35d..57a85cc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3759,6 +3759,8 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+	int			power_lb;  /* if power balance needed */
+	int			perf_lb;   /* if performance balance needed */
 };
 
 /*
@@ -4909,6 +4911,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.power_lb	= 0,
+		.perf_lb	= 1,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
-- 
1.7.5.1

