Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2CMEru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:47:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2CMErs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:47:48 -0400
Date: Mon, 12 Mar 2012 21:47:29 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-8e3fabfde445a872c8aec2296846badf24d7c8b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joe@perches.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1331056466.11248.327.camel@twins>
References: <1331056466.11248.327.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update yield() docs
Git-Commit-ID: 8e3fabfde445a872c8aec2296846badf24d7c8b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:47:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e3fabfde445a872c8aec2296846badf24d7c8b4
Gitweb:     http://git.kernel.org/tip/8e3fabfde445a872c8aec2296846badf24d7c8b4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 6 Mar 2012 18:54:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:17 +0100

sched: Update yield() docs

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331056466.11248.327.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8781cec..47614a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4577,8 +4577,24 @@ EXPORT_SYMBOL(__cond_resched_softirq);
 /**
  * yield - yield the current processor to other threads.
  *
- * This is a shortcut for kernel-space yielding - it marks the
- * thread runnable and calls sys_sched_yield().
+ * Do not ever use this function, there's a 99% chance you're doing it wrong.
+ *
+ * The scheduler is at all times free to pick the calling task as the most
+ * eligible task to run, if removing the yield() call from your code breaks
+ * it, its already broken.
+ *
+ * Typical broken usage is:
+ *
+ * while (!event)
+ * 	yield();
+ *
+ * where one assumes that yield() will let 'the other' process run that will
+ * make event true. If the current task is a SCHED_FIFO task that will never
+ * happen. Never use yield() as a progress guarantee!!
+ *
+ * If you want to use yield() to wait for something, use wait_event().
+ * If you want to use yield() to be 'nice' for others, use cond_resched().
+ * If you still want to use yield(), do not!
  */
 void __sched yield(void)
 {
