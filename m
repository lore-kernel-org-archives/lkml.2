Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2JEIub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:50:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2JEIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:50:28 -0400
Date: Fri, 5 Oct 2012 01:49:49 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-p80wec3z0vafe8dd0kz6ynyz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Don'
 t use globals where not needed to
Git-Commit-ID: 94d668d0732d469e3237da0990b3512dc0f23d09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:49:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94d668d0732d469e3237da0990b3512dc0f23d09
Gitweb:     http://git.kernel.org/tip/94d668d0732d469e3237da0990b3512dc0f23d09
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:39 -0300

perf evlist: Don't use globals where not needed to

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-p80wec3z0vafe8dd0kz6ynyz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 1fb1641..997afb8 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -108,23 +108,20 @@ static int __cmd_evlist(const char *input_name, struct perf_attr_details *detail
 	return 0;
 }
 
-static const char * const evlist_usage[] = {
-	"perf evlist [<options>]",
-	NULL
-};
-
 int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_attr_details details = { .verbose = false, };
 	const char *input_name = NULL;
 	const struct option options[] = {
-		OPT_STRING('i', "input", &input_name, "file",
-			    "Input file name"),
-		OPT_BOOLEAN('F', "freq", &details.freq,
-			    "Show the sample frequency"),
-		OPT_BOOLEAN('v', "verbose", &details.verbose,
-			    "Show all event attr details"),
-		OPT_END()
+	OPT_STRING('i', "input", &input_name, "file", "Input file name"),
+	OPT_BOOLEAN('F', "freq", &details.freq, "Show the sample frequency"),
+	OPT_BOOLEAN('v', "verbose", &details.verbose,
+		    "Show all event attr details"),
+	OPT_END()
+	};
+	const char * const evlist_usage[] = {
+		"perf evlist [<options>]",
+		NULL
 	};
 
 	argc = parse_options(argc, argv, options, evlist_usage, 0);
