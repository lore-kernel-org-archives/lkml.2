Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3AEIi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:38:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab3AEIht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210178"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 20/22] sched: don't care if the local group has capacity
Date: Sat,  5 Jan 2013 16:37:49 +0800
Message-Id: <1357375071-11793-21-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power aware scheduling, we don't care load weight and
want not to pull tasks just because local group has capacity.
Because the local group maybe no tasks at the time, that is the power
balance hope so.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d43fe6a..cf4955c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4766,8 +4766,12 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
+		 *
+		 * In power aware scheduling, we don't care load weight and
+		 * want not to pull tasks just because local group has capacity.
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
+		if (prefer_sibling && !local_group && sds->this_has_capacity
+				&& env->perf_lb)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
-- 
1.7.12

