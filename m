Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1DKOgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:36:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1DKOgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:36:39 -0400
Date: Mon, 11 Apr 2011 14:35:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3739494e08da50c8a68d65eed5ba3012a54b40d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.025636011@chello.nl>
References: <20110407122942.025636011@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Clean up some ALLNODES code
Git-Commit-ID: 3739494e08da50c8a68d65eed5ba3012a54b40d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:35:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3739494e08da50c8a68d65eed5ba3012a54b40d4
Gitweb:     http://git.kernel.org/tip/3739494e08da50c8a68d65eed5ba3012a54b40d4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:18 +0200

sched: Clean up some ALLNODES code

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.025636011@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 72d561f..fa10cf7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7280,7 +7280,9 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 
 	case SD_LV_ALLNODES:
-		init_sched_build_groups(cpu_map, cpu_map, &cpu_to_allnodes_group,
+		if (cpu == cpumask_first(cpu_map))
+			init_sched_build_groups(cpu_map, cpu_map,
+					&cpu_to_allnodes_group,
 					d->send_covered, d->tmpmask);
 		break;
 #endif
@@ -7331,14 +7333,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
 		build_sched_groups(&d, SD_LV_NODE, cpu_map, i);
+		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, i);
 	}
 
-#ifdef CONFIG_NUMA
-	/* Set up node groups */
-	if (d.sd_allnodes)
-		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
-#endif
-
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
 	for_each_cpu(i, cpu_map) {
