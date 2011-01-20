Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1ATVkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:40:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab1ATViu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:38:50 -0500
Date: Thu, 20 Jan 2011 16:37:22 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [RFC -v6 PATCH 5/8] sched: drop superfluous tests from yield_to
Message-ID: <20110120163722.476accf5@annuminas.surriel.com>
In-Reply-To: <20110120163127.2568f4fe@annuminas.surriel.com>
References: <20110120163127.2568f4fe@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fairness is enforced by pick_next_entity, so we can drop some
superfluous tests from yield_to.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1f38ed2..398eedf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5307,14 +5307,6 @@ again:
 	if (task_running(p_rq, p) || p->state)
 		goto out;
 
-	if (!same_thread_group(p, curr))
-		goto out;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	if (task_group(p) != task_group(curr))
-		goto out;
-#endif
-
 	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
 
 out:
