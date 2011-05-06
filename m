Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1EFVF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:05:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:33070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab1EFVFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="639164488"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, arnd@arndb.de, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] SCHED: Don't use BKL count for idle preempt count initialization
Date: Fri,  6 May 2011 14:05:27 -0700
Message-Id: <1304715928-19266-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

No need for that ever as far as I can see. Just set it to 0.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/sched.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7fa5334..f70b2cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5776,11 +5776,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-#if defined(CONFIG_PREEMPT)
-	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
-#else
 	task_thread_info(idle)->preempt_count = 0;
-#endif
+
 	/*
 	 * The idle tasks have their own, simple scheduling class:
 	 */
-- 
1.7.4.4

