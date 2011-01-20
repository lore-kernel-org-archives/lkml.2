Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1ATViz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:38:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab1ATViw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:38:52 -0500
Date: Thu, 20 Jan 2011 16:32:36 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [RFC -v6 PATCH 1/8] sched: check the right ->nr_running in
 yield_task_fair
Message-ID: <20110120163236.60ce3079@annuminas.surriel.com>
In-Reply-To: <20110120163127.2568f4fe@annuminas.surriel.com>
References: <20110120163127.2568f4fe@annuminas.surriel.com>
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

