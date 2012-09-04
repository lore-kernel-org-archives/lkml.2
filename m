Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2IDSuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:50:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47924 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2IDSuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:50:44 -0400
Date: Tue, 4 Sep 2012 11:50:24 -0700
From: tip-bot for Michael Wang <wangyun@linux.vnet.ibm.com>
Message-ID: <tip-38b8dd6f87398524d02c21ff614c507ba8c9d295@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <4FF2925A.9060005@linux.vnet.ibm.com>
References: <4FF2925A.9060005@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove useless code in yield_to()
Git-Commit-ID: 38b8dd6f87398524d02c21ff614c507ba8c9d295
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:50:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38b8dd6f87398524d02c21ff614c507ba8c9d295
Gitweb:     http://git.kernel.org/tip/38b8dd6f87398524d02c21ff614c507ba8c9d295
Author:     Michael Wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Tue, 3 Jul 2012 14:34:02 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 14:31:42 +0200

sched: Remove useless code in yield_to()

It's impossible to enter the else branch if we have set
skip_clock_update in task_yield_fair(), as yield_to_task_fair()
 will directly return true after invoke task_yield_fair().

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Acked-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FF2925A.9060005@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec0f2b8..c46a011 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4348,13 +4348,6 @@ again:
 		 */
 		if (preempt && rq != p_rq)
 			resched_task(p_rq->curr);
-	} else {
-		/*
-		 * We might have set it in task_yield_fair(), but are
-		 * not going to schedule(), so don't want to skip
-		 * the next update.
-		 */
-		rq->skip_clock_update = 0;
 	}
 
 out:
