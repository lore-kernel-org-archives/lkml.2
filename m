Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1BJMZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab1BJMZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:31 -0500
From: stable-bot for Alex Shi <alex.shi@intel.com>
Date: Thu, 10 Feb 2011 10:23:29 +0100
Subject: [PATCH 26/28] sched: Fix volanomark performance regression
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: b5482cfa1c95a188b3054fa33274806add91bbe5 upstream
Author: Alex Shi <alex.shi@intel.com>
AuthorDate: Tue Nov 16 17:34:02 2010 +0800

Commit fab4762 triggers excessive idle balancing, causing a ~30% loss in
volanomark throughput. Remove idle balancing throttle reset.

Originally-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1289928732.5169.211.camel@maggy.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 445f2d1..ffd4f57 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3326,10 +3326,6 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
-
-	/* re-arm NEWIDLE balancing when moving tasks */
-	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
-	this_rq->idle_stamp = 0;
 }
 
 /*
-- 
1.7.4


