Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab1D2OKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:10:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:41240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab1D2OKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:10:20 -0400
Date: Fri, 29 Apr 2011 14:09:58 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n005io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Leave more room for percentages
Git-Commit-ID: fce3c786d3a49eff397583b4b62fa38df90db937
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 14:09:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fce3c786d3a49eff397583b4b62fa38df90db937
Gitweb:     http://git.kernel.org/tip/fce3c786d3a49eff397583b4b62fa38df90db937
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 30 Apr 2011 09:03:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 16:06:09 +0200

perf stat: Leave more room for percentages

Triple digit percentages do not fit otherwise.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n005io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2492a0e..9e596ab 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -499,8 +499,8 @@ static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __us
 	else if (ratio > 10.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #   ");
-	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
 	fprintf(stderr, " frontend cycles idle   ");
 }
 
@@ -522,9 +522,9 @@ static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __use
 	else if (ratio > 20.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #   ");
-	color_fprintf(stderr, color, "%5.2f%%", ratio);
-	fprintf(stderr, "  backend cycles idle   ");
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " backend  cycles idle   ");
 }
 
 static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -545,8 +545,8 @@ static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #   ");
-	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
 	fprintf(stderr, " of all branches        ");
 }
 
@@ -568,8 +568,8 @@ static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, dou
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	fprintf(stderr, " #   ");
-	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
 	fprintf(stderr, " of all L1-dcache hits  ");
 }
 
@@ -607,14 +607,14 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " #    %4.2f  insns per cycle        ", ratio);
+		fprintf(stderr, " #   %5.2f  insns per cycle        ", ratio);
 
 		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
 		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
 
 		if (total && avg) {
 			ratio = total / avg;
-			fprintf(stderr, "\n                                            #    %4.2f  stalled cycles per insn", ratio);
+			fprintf(stderr, "\n                                            #   %5.2f  stalled cycles per insn", ratio);
 		}
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
