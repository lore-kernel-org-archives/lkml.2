Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1AFKjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:39:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1AFKjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:39:08 -0500
Date: Thu, 6 Jan 2011 11:39:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking changes for v2.6.38
Message-ID: <20110106103901.GA26167@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

 Thanks,

	Ingo

------------------>
Joe Perches (1):
      locking, lockdep: Convert sprintf_symbol to %pS


 kernel/lockdep_proc.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 59b76c8..1969d2f 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -494,7 +494,6 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		namelen += 2;
 
 	for (i = 0; i < LOCKSTAT_POINTS; i++) {
-		char sym[KSYM_SYMBOL_LEN];
 		char ip[32];
 
 		if (class->contention_point[i] == 0)
@@ -503,15 +502,13 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		if (!i)
 			seq_line(m, '-', 40-namelen, namelen);
 
-		sprint_symbol(sym, class->contention_point[i]);
 		snprintf(ip, sizeof(ip), "[<%p>]",
 				(void *)class->contention_point[i]);
-		seq_printf(m, "%40s %14lu %29s %s\n", name,
-				stats->contention_point[i],
-				ip, sym);
+		seq_printf(m, "%40s %14lu %29s %pS\n",
+			   name, stats->contention_point[i],
+			   ip, (void *)class->contention_point[i]);
 	}
 	for (i = 0; i < LOCKSTAT_POINTS; i++) {
-		char sym[KSYM_SYMBOL_LEN];
 		char ip[32];
 
 		if (class->contending_point[i] == 0)
@@ -520,12 +517,11 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		if (!i)
 			seq_line(m, '-', 40-namelen, namelen);
 
-		sprint_symbol(sym, class->contending_point[i]);
 		snprintf(ip, sizeof(ip), "[<%p>]",
 				(void *)class->contending_point[i]);
-		seq_printf(m, "%40s %14lu %29s %s\n", name,
-				stats->contending_point[i],
-				ip, sym);
+		seq_printf(m, "%40s %14lu %29s %pS\n",
+			   name, stats->contending_point[i],
+			   ip, (void *)class->contending_point[i]);
 	}
 	if (i) {
 		seq_puts(m, "\n");
