Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1DGMng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:43:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:57855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab1DGMne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:43:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,316,1299484800"; 
   d="scan'208";a="730322457"
Date: Thu, 7 Apr 2011 20:43:32 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, zheng.z.yan@intel.com
Subject: [PATCH]sched: convert wall-time to vruntime for check_preempt_tick
Message-ID: <20110407124332.GA31809@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In check_preempt_tick(), delta is vruntime and ideal_runtime is wall runtime.
Comparing vruntime and ideal_runtime looks buggy.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f7ec9e..0b76e3a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1121,7 +1121,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		if (delta < 0)
 			return;
 
-		if (delta > ideal_runtime)
+		if (delta > calc_delta_fair(ideal_runtime, curr))
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }
