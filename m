Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1D2Mrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:47:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:60614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1D2Mrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:47:51 -0400
Date: Fri, 29 Apr 2011 12:47:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n004io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Adjust stall cycles warning percentages
Git-Commit-ID: 2b427e14b77dbf3e05f1bd0785f1d07ea5fe924e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 12:47:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b427e14b77dbf3e05f1bd0785f1d07ea5fe924e
Gitweb:     http://git.kernel.org/tip/2b427e14b77dbf3e05f1bd0785f1d07ea5fe924e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 Apr 2011 14:16:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 14:35:57 +0200

perf stat: Adjust stall cycles warning percentages

Adjust to color thresholds to better match the percentages seen in
real workloads. Both are now a bit more sensitive.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n004io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e454499..2492a0e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -492,11 +492,11 @@ static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __us
 		ratio = avg / total * 100.0;
 
 	color = PERF_COLOR_NORMAL;
-	if (ratio > 75.0)
+	if (ratio > 50.0)
 		color = PERF_COLOR_RED;
-	else if (ratio > 50.0)
+	else if (ratio > 30.0)
 		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 20.0)
+	else if (ratio > 10.0)
 		color = PERF_COLOR_YELLOW;
 
 	fprintf(stderr, " #   ");
@@ -519,7 +519,7 @@ static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __use
 		color = PERF_COLOR_RED;
 	else if (ratio > 50.0)
 		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 25.0)
+	else if (ratio > 20.0)
 		color = PERF_COLOR_YELLOW;
 
 	fprintf(stderr, " #   ");
