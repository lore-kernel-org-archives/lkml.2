Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2J1RFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:05:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2J1RFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:05:51 -0400
Date: Sun, 28 Oct 2012 10:05:34 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-6e27d9318a551b14a6ef8a1956b497f1477680a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm: Introduce sched_feat_numa()
Git-Commit-ID: 6e27d9318a551b14a6ef8a1956b497f1477680a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 28 Oct 2012 10:05:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e27d9318a551b14a6ef8a1956b497f1477680a1
Gitweb:     http://git.kernel.org/tip/6e27d9318a551b14a6ef8a1956b497f1477680a1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 May 2012 23:47:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 28 Oct 2012 17:31:10 +0100

sched, numa, mm: Introduce sched_feat_numa()

Avoid a few #ifdef's later on.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-sxrRsaqz4cj1plnzyjbtWzbf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..741272e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -648,6 +648,12 @@ extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 #endif /* SCHED_DEBUG && HAVE_JUMP_LABEL */
 
+#ifdef CONFIG_SCHED_NUMA
+#define sched_feat_numa(x) sched_feat(x)
+#else
+#define sched_feat_numa(x) (0)
+#endif
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
