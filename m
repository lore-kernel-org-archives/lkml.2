Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2A3Mov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:44:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18591 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2A3Mou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:44:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 30 Jan 2012 04:44:49 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Diwakar Tundlam <dtundlam@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] scheduler: domain: init next_balance in nohz_idle_balancer with jiffies
Date: Mon, 30 Jan 2012 14:44:22 +0200
Message-Id: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Diwakar Tundlam <dtundlam@nvidia.com>

The next_balance parameter of nohz_idle_balancer should be initialized
to jiffies since jiffies itself is initialized to 300 seconds shy of
overflow. Otherwise, nohz_idle_balancer does not run for the first 5
mins after bootup.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
Reviewed-by: Aleksandr Frid <afrid@nvidia.com>
Reviewed-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
Reviewed-by: Satya Popuri <spopuri@nvidia.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b5efd6c..d3f291f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8383,6 +8383,7 @@ void __init sched_init(void)
 	atomic_set(&nohz.load_balancer, nr_cpu_ids);
 	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
 	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
+	nohz.next_balance = jiffies;
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
-- 
1.7.7.rc0.72.g4b5ea.dirty

