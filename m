Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162317Ab2CSUF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:05:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2CSUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:05:55 -0400
Date: Mon, 19 Mar 2012 13:05:33 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-6db6127c4dad634ab98709b81e2f2770890b0d53@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1331887855-874-5-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-5-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Treat an argument as a symbol filter
Git-Commit-ID: 6db6127c4dad634ab98709b81e2f2770890b0d53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:05:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6db6127c4dad634ab98709b81e2f2770890b0d53
Gitweb:     http://git.kernel.org/tip/6db6127c4dad634ab98709b81e2f2770890b0d53
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 16 Mar 2012 17:50:55 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 16:44:36 -0300

perf report: Treat an argument as a symbol filter

As Ingo requested, it'd be better off treating first (and the only)
argument as a symbol filter, so that user doesn't need to input the
symbol on the dialog window on TUI.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 80fb907..c005458 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -715,11 +715,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	} else
 		symbol_conf.exclude_other = false;
 
-	/*
-	 * Any (unrecognized) arguments left?
-	 */
-	if (argc)
-		usage_with_options(report_usage, options);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume that
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(report_usage, options);
+
+		report.symbol_filter_str = argv[0];
+	}
 
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 
