Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2JRRI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:08:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2JRRI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:08:57 -0400
Date: Thu, 18 Oct 2012 10:08:32 -0700
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-8ed92e51f99c2199c64cb33b4ba95ab12940a94c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Add WAKEUP_PREEMPTION feature flag,
  on by default
Git-Commit-ID: 8ed92e51f99c2199c64cb33b4ba95ab12940a94c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:08:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ed92e51f99c2199c64cb33b4ba95ab12940a94c
Gitweb:     http://git.kernel.org/tip/8ed92e51f99c2199c64cb33b4ba95ab12940a94c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 14 Oct 2012 14:28:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Oct 2012 10:05:27 +0200

sched: Add WAKEUP_PREEMPTION feature flag, on by default

As per the recent discussion with Mike and Linus, make it easier to
test with/without this feature. No change in default behavior.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-izoxq4haeg4mTognnDbwcevt@git.kernel.org
---
 kernel/sched/fair.c     |    2 +-
 kernel/sched/features.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..f936552 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2907,7 +2907,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
 	 * is driven by the tick):
 	 */
-	if (unlikely(p->policy != SCHED_NORMAL))
+	if (unlikely(p->policy != SCHED_NORMAL) || !sched_feat(WAKEUP_PREEMPTION))
 		return;
 
 	find_matching_se(&se, &pse);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index eebefca..e68e69a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -32,6 +32,11 @@ SCHED_FEAT(LAST_BUDDY, true)
 SCHED_FEAT(CACHE_HOT_BUDDY, true)
 
 /*
+ * Allow wakeup-time preemption of the current task:
+ */
+SCHED_FEAT(WAKEUP_PREEMPTION, true)
+
+/*
  * Use arch dependent cpu power functions
  */
 SCHED_FEAT(ARCH_POWER, true)
