Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0KEXNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:13:30 -0400
Received: from mail.perches.com ([173.55.12.10]:4357 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab0KEXMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:12:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] kernel/lockdep_proc.c: Convert sprintf_symbol to %pS
Date: Fri,  5 Nov 2010 16:12:38 -0700
Message-Id: <1288998760-11775-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288998760-11775-1-git-send-email-joe@perches.com>
References: <1288998760-11775-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
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
-- 
1.7.3.2.146.gca209

