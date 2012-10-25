Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945942Ab2JYK1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:27:07 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54953 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422783Ab2JYK1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:27:02 -0400
Subject: [RFC PATCH 09/13] sched: Modify check_asym_packing to use PJT's
 metric
To: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: mingo@kernel.org, venki@google.com, robin.randhawa@arm.com,
        linaro-dev@lists.linaro.org, a.p.zijlstra@chello.nl,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Date: Thu, 25 Oct 2012 15:55:54 +0530
Message-ID: <20121025102554.21022.45715.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-2674-0000-0000-00000678B38F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make appropriate modifications in check_asym_packing to reflect PJT's
metric.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 68a6b1d..3b18f5f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4814,6 +4814,8 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 
 	env->imbalance = DIV_ROUND_CLOSEST(
 		sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
+	env->load_imbalance = DIV_ROUND_CLOSEST(
+		sds->max_sg_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
 
 	return 1;
 }

