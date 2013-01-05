Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3AEIhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:37:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3AEIhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210038"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 02/22] sched: select_task_rq_fair clean up
Date: Sat,  5 Jan 2013 16:37:31 +0800
Message-Id: <1357375071-11793-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is impossible to miss a task allowed cpu in a eligible group.

And since find_idlest_group only return a different group which
excludes old cpu, it's also imporissible to find a new cpu same as old
cpu.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..6d3a95d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3378,11 +3378,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
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
1.7.12

