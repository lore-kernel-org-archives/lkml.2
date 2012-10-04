Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2JDSJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2JDSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/42] perf probe: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:21 -0300
Message-Id: <1349374122-27806-22-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-adql1rjwxlmahx9unvfi3wqo@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 118aa89..de38a03 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -250,19 +250,20 @@ static int opt_set_filter(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static const char * const probe_usage[] = {
-	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
-	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
-	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
-	"perf probe --list",
+int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	const char * const probe_usage[] = {
+		"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
+		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
+		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
+		"perf probe --list",
 #ifdef DWARF_SUPPORT
-	"perf probe [<options>] --line 'LINEDESC'",
-	"perf probe [<options>] --vars 'PROBEPOINT'",
+		"perf probe [<options>] --line 'LINEDESC'",
+		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
-	NULL
+		NULL
 };
-
-static const struct option options[] = {
+	const struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
 	OPT_BOOLEAN('l', "list", &params.list_events,
@@ -325,10 +326,7 @@ static const struct option options[] = {
 	OPT_CALLBACK('x', "exec", NULL, "executable|path",
 			"target executable name or path", opt_set_target),
 	OPT_END()
-};
-
-int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
-{
+	};
 	int ret;
 
 	argc = parse_options(argc, argv, options, probe_usage,
-- 
1.7.1

