Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1C3Vwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:52:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab1C3VHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236907"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: ncrao@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [93/275] sched: Do not consider SCHED_IDLE tasks to be cache hot
Message-Id: <20110330210531.8B7AE3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: ef8002f6848236de5adc613063ebeabddea8a6fb upstream

This patch adds a check in task_hot to return if the task has SCHED_IDLE
policy. SCHED_IDLE tasks have very low weight, and when run with regular
workloads, are typically scheduled many milliseconds apart. There is no
need to consider these tasks hot for load balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1287173550-30365-2-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:02:59.968300981 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:55:02.689398361 -0700
@@ -1972,6 +1972,9 @@
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
