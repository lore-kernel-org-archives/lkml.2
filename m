Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1HNQOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:14:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1HNQOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:14:04 -0400
Date: Sun, 14 Aug 2011 16:13:43 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-5710f15b52664ae0bfa60a66d75464769d297b2b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, yong.zhang0@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
In-Reply-To: <20110806001004.GA2207@zhy>
References: <20110806001004.GA2207@zhy>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpupri: Remove cpupri->pri_active
Git-Commit-ID: 5710f15b52664ae0bfa60a66d75464769d297b2b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:13:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5710f15b52664ae0bfa60a66d75464769d297b2b
Gitweb:     http://git.kernel.org/tip/5710f15b52664ae0bfa60a66d75464769d297b2b
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Sat, 6 Aug 2011 08:10:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:01:11 +0200

sched/cpupri: Remove cpupri->pri_active

Since [sched/cpupri: Remove the vec->lock], member pri_active
of struct cpupri is not needed any more, just remove it. Also
clean stuff related to it.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110806001004.GA2207@zhy
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_cpupri.c |    3 +--
 kernel/sched_cpupri.h |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 90faffd..a86cf9d 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -152,8 +152,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 	 * If the cpu was currently mapped to a different value, we
 	 * need to map it to the new value then remove the old value.
 	 * Note, we must add the new value first, otherwise we risk the
-	 * cpu being cleared from pri_active, and this cpu could be
-	 * missed for a push or pull.
+	 * cpu being missed by the priority loop in cpupri_find.
 	 */
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 6b4cd17..f6d7561 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -4,7 +4,6 @@
 #include <linux/sched.h>
 
 #define CPUPRI_NR_PRIORITIES	(MAX_RT_PRIO + 2)
-#define CPUPRI_NR_PRI_WORDS	BITS_TO_LONGS(CPUPRI_NR_PRIORITIES)
 
 #define CPUPRI_INVALID -1
 #define CPUPRI_IDLE     0
@@ -18,7 +17,6 @@ struct cpupri_vec {
 
 struct cpupri {
 	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
-	long              pri_active[CPUPRI_NR_PRI_WORDS];
 	int               cpu_to_pri[NR_CPUS];
 };
 
