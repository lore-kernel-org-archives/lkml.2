Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1LSIdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:33:49 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38198 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1LSIdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:33:47 -0500
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/4] sched: Gang using set_next_buddy
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 14:04:58 +0530
Message-ID: <20111219083443.32311.61046.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11121908-5816-0000-0000-0000008107CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gang task group is faroured to be picked up using the set_next_buddy api and
hope that scheduler gives it priority.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c03efd2..9a2f291 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5518,8 +5518,11 @@ static void gang_sched_member(void *info)
 
 	/* Check if the runqueue has runnable tasks */
 	if (cfs_rq->nr_running) {
-		/* Favour this task group and set need_resched flag,
-		 * added by following patches */
+		struct sched_entity *se = tg->se[cpu];
+
+		/* Make the parent favourable */
+		set_next_buddy(se);
+		set_tsk_need_resched(current);
 	}
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }

