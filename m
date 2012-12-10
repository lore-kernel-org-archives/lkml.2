Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2LJI0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:26:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab2LJI0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808780"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 15/18] sched: don't care if the local group has capacity
Date: Mon, 10 Dec 2012 16:22:31 +0800
Message-Id: <1355127754-8444-16-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power aware scheduling, we don't care load weight and
want not to pull tasks just because local group has capacity.
Because the local group maybe no tasks at the time, that is the power
balance hope so.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57a85cc..fe0ba07 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4496,8 +4496,12 @@ static inline void update_sd_lb_stats(struct lb_env *env,
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
1.7.5.1

