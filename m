Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2JEIwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:52:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2JEIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:52:12 -0400
Date: Fri, 5 Oct 2012 01:51:42 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-9cer20zhw64wbxyb0zias82i@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf inject: Don'
 t use globals where not needed to
Git-Commit-ID: 002439e84ed67cbb33cab4057fcd6a4146c0f815
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:51:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  002439e84ed67cbb33cab4057fcd6a4146c0f815
Gitweb:     http://git.kernel.org/tip/002439e84ed67cbb33cab4057fcd6a4146c0f815
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:41 -0300

perf inject: Don't use globals where not needed to

Some variables were global but used in just one function, so move it to
where it belongs.

Leftover from patch at the beggining of this series.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9cer20zhw64wbxyb0zias82i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3c9ab55..4688bea 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -242,11 +242,6 @@ static int __cmd_inject(struct perf_inject *inject)
 	return ret;
 }
 
-static const char * const report_usage[] = {
-	"perf inject [<options>]",
-	NULL
-};
-
 int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_inject inject = {
@@ -273,14 +268,18 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			 "be more verbose (show build ids, etc)"),
 		OPT_END()
 	};
+	const char * const inject_usage[] = {
+		"perf inject [<options>]",
+		NULL
+	};
 
-	argc = parse_options(argc, argv, options, report_usage, 0);
+	argc = parse_options(argc, argv, options, inject_usage, 0);
 
 	/*
 	 * Any (unrecognized) arguments left?
 	 */
 	if (argc)
-		usage_with_options(report_usage, options);
+		usage_with_options(inject_usage, options);
 
 	if (symbol__init() < 0)
 		return -1;
