Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1AaVt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:49:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab1AaVsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:48:08 -0500
Date: Mon, 31 Jan 2011 16:41:54 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [PATCH -v8 1/7] sched: check the right ->nr_running in
 yield_task_fair
Message-ID: <20110131164154.564ee7bd@annuminas.surriel.com>
In-Reply-To: <20110131164049.0ad68e72@annuminas.surriel.com>
References: <20110131164049.0ad68e72@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_FAIR_GROUP_SCHED, each task_group has its own cfs_rq.
Yielding to a task from another cfs_rq may be worthwhile, since
a process calling yield typically cannot use the CPU right now.

Therefor, we want to check the per-cpu nr_running, not the
cgroup local one.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..7b338ac 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1304,7 +1304,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Are we the only task in the tree?
 	 */
-	if (unlikely(cfs_rq->nr_running == 1))
+	if (unlikely(rq->nr_running == 1))
 		return;
 
 	clear_buddies(cfs_rq, se);

