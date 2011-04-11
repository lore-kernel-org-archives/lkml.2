Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1DKOjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:39:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:54575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1DKOjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:39:22 -0400
Date: Mon, 11 Apr 2011 14:38:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3859173d43658d51a749bc0201b943922577d39c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.406226449@chello.nl>
References: <20110407122942.406226449@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Reduce some allocation pressure
Git-Commit-ID: 3859173d43658d51a749bc0201b943922577d39c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:38:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3859173d43658d51a749bc0201b943922577d39c
Gitweb:     http://git.kernel.org/tip/3859173d43658d51a749bc0201b943922577d39c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:21 +0200

sched: Reduce some allocation pressure

Since we now allocate SD_LV_MAX * nr_cpu_ids sched_domain/sched_group
structures when rebuilding the scheduler toplogy it might make sense
to shrink that depending on the CONFIG_ options.

This is only needed until we get rid of SD_LV_* alltogether and
provide a full dynamic topology interface.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.406226449@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 020b79d..5a9168b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -897,12 +897,20 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 
 enum sched_domain_level {
 	SD_LV_NONE = 0,
+#ifdef CONFIG_SCHED_SMT
 	SD_LV_SIBLING,
+#endif
+#ifdef CONFIG_SCHED_MC
 	SD_LV_MC,
+#endif
+#ifdef CONFIG_SCHED_BOOK
 	SD_LV_BOOK,
+#endif
 	SD_LV_CPU,
+#ifdef CONFIG_NUMA
 	SD_LV_NODE,
 	SD_LV_ALLNODES,
+#endif
 	SD_LV_MAX
 };
 
