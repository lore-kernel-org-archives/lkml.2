Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2ENNqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:46:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2ENNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:46:31 -0400
Date: Mon, 14 May 2012 06:46:19 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-zsriaft1dv7hhboyrpvqjy6s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Don't scale the imbalance
Git-Commit-ID: 870a0bb5d636156502769233d02a0d5791d4366a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:46:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  870a0bb5d636156502769233d02a0d5791d4366a
Gitweb:     http://git.kernel.org/tip/870a0bb5d636156502769233d02a0d5791d4366a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 May 2012 00:26:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:26 +0200

sched/numa: Don't scale the imbalance

It's far too easy to get ridiculously large imbalance pct when you
scale it like that. Use a fixed 125% for now.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-zsriaft1dv7hhboyrpvqjy6s@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24922b7..6883d99 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6261,11 +6261,6 @@ static int *sched_domains_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 
-static inline unsigned long numa_scale(unsigned long x, int level)
-{
-	return x * sched_domains_numa_distance[level] / sched_domains_numa_scale;
-}
-
 static inline int sd_local_flags(int level)
 {
 	if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
@@ -6286,7 +6281,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 		.min_interval		= sd_weight,
 		.max_interval		= 2*sd_weight,
 		.busy_factor		= 32,
-		.imbalance_pct		= 100 + numa_scale(25, level),
+		.imbalance_pct		= 125,
 		.cache_nice_tries	= 2,
 		.busy_idx		= 3,
 		.idle_idx		= 2,
