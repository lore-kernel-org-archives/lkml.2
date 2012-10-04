Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2JDSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:22:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:39703 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2JDSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 23/42] perf evlist: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:23 -0300
Message-Id: <1349374122-27806-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.7.1

