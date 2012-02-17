Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2BQDFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:05:41 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43196 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2BQDEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:04:51 -0500
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [PATCH] sched: Remove rcu_read_lock/unlock() from
 select_idle_sibling()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 08:34:30 +0530
Message-ID: <20120217030409.11748.12491.stgit@abhimanyu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12021703-2000-0000-0000-000006713896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

select_idle_sibling() is called from select_task_rq_fair(), which
already has the RCU read lock held.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4ab60a2..6ce9992 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2670,8 +2670,6 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	rcu_read_lock();
-
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
@@ -2693,8 +2691,6 @@ next:
 		} while (sg != sd->groups);
 	}
 done:
-	rcu_read_unlock();
-
 	return target;
 }
 

