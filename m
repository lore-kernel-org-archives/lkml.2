Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1BPBxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:53:22 -0500
Received: from kroah.org ([198.145.64.141]:49419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612Ab1BPBwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:05 2011
Message-Id: <20110216014705.349177479@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <efault@gmx.de>, Nikhil Rao <ncrao@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [111/115] sched: Fix volanomark performance regression
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: b5482cfa1c95a188b3054fa33274806add91bbe5 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3326,10 +3326,6 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
-
-	/* re-arm NEWIDLE balancing when moving tasks */
-	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
-	this_rq->idle_stamp = 0;
 }
 
 /*


