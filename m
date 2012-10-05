Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2JEIsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:48:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60951 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2JEIsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:48:17 -0400
Date: Fri, 5 Oct 2012 01:47:57 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-adql1rjwxlmahx9unvfi3wqo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Don'
 t use globals where not needed to
Git-Commit-ID: 11c4e4a32b420db683cf58069c525e94797ce044
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:48:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11c4e4a32b420db683cf58069c525e94797ce044
Gitweb:     http://git.kernel.org/tip/11c4e4a32b420db683cf58069c525e94797ce044
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:37 -0300

perf probe: Don't use globals where not needed to

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
