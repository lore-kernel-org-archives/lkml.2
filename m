Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1DKOkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:40:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1DKOkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:40:15 -0400
Date: Mon, 11 Apr 2011 14:39:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-7dd04b730749f957c116f363524fd622b05e5141@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.553814623@chello.nl>
References: <20110407122942.553814623@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Remove some dead code
Git-Commit-ID: 7dd04b730749f957c116f363524fd622b05e5141
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:39:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7dd04b730749f957c116f363524fd622b05e5141
Gitweb:     http://git.kernel.org/tip/7dd04b730749f957c116f363524fd622b05e5141
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:22 +0200

sched: Remove some dead code

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.553814623@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    6 ------
 kernel/sched.c        |   16 ----------------
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a9168b..09d9e02 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -883,9 +883,6 @@ struct sched_group {
 	 * NOTE: this field is variable length. (Allocated dynamically
 	 * by attaching extra space to the end of the structure,
 	 * depending on how many CPUs the kernel has booted up with)
-	 *
-	 * It is also be embedded into static data structures at build
-	 * time. (See 'struct static_sched_group' in kernel/sched.c)
 	 */
 	unsigned long cpumask[0];
 };
@@ -994,9 +991,6 @@ struct sched_domain {
 	 * NOTE: this field is variable length. (Allocated dynamically
 	 * by attaching extra space to the end of the structure,
 	 * depending on how many CPUs the kernel has booted up with)
-	 *
-	 * It is also be embedded into static data structures at build
-	 * time. (See 'struct static_sched_domain' in kernel/sched.c)
 	 */
 	unsigned long span[0];
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index f4d3a62..5ec685c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6816,22 +6816,6 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
-/*
- * The cpus mask in sched_group and sched_domain hangs off the end.
- *
- * ( See the the comments in include/linux/sched.h:struct sched_group
- *   and struct sched_domain. )
- */
-struct static_sched_group {
-	struct sched_group sg;
-	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
-};
-
-struct static_sched_domain {
-	struct sched_domain sd;
-	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
-};
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
