Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2GZPIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:08:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZPIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:08:49 -0400
Date: Thu, 26 Jul 2012 08:08:26 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-45afb1734fa6323a8ba08bd6c392ee227df67dde@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1341647342-6742-1-git-send-email-namhyung@kernel.org>
References: <1341647342-6742-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use task_rq_unlock()
  in __sched_setscheduler()
Git-Commit-ID: 45afb1734fa6323a8ba08bd6c392ee227df67dde
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:08:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45afb1734fa6323a8ba08bd6c392ee227df67dde
Gitweb:     http://git.kernel.org/tip/45afb1734fa6323a8ba08bd6c392ee227df67dde
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Sat, 7 Jul 2012 16:49:02 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 11:46:59 +0200

sched: Use task_rq_unlock() in __sched_setscheduler()

It seems there's no specific reason to open-code it.  I guess
commit 0122ec5b02f76 ("sched: Add p->pi_lock to task_rq_lock()")
simply missed it.  Let's be consistent with others.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1341647342-6742-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5d011ef..2cb4e77 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4340,9 +4340,7 @@ recheck:
 	 */
 	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
 			param->sched_priority == p->rt_priority))) {
-
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
 
