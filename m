Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2LJIby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:31:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LJI0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808691"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 01/18] sched: select_task_rq_fair clean up
Date: Mon, 10 Dec 2012 16:22:17 +0800
Message-Id: <1355127754-8444-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is impossible to miss a task allowed cpu in a eligible group.

And since find_idlest_group only return a different group which
excludes old cpu, it's also imporissible to find a new cpu same as old
cpu.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 59e072b..df99456 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3150,11 +3150,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		}
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
-			/* Now try balancing at a lower domain level of cpu */
-			sd = sd->child;
-			continue;
-		}
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
-- 
1.7.5.1

