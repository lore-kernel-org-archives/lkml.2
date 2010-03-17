Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0CQL3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:29:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:36072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab0CQL3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:29:25 -0400
Date: Wed, 17 Mar 2010 11:28:32 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100316220544.32050.8788.stgit@localhost6.localdomain6>
References: <20100316220544.32050.8788.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Rename session to param
Message-ID: <tip-12a1fadb41b5a6733c36b488b881fb19a28c92d3@git.kernel.org>
Git-Commit-ID: 12a1fadb41b5a6733c36b488b881fb19a28c92d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 11:28:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12a1fadb41b5a6733c36b488b881fb19a28c92d3
Gitweb:     http://git.kernel.org/tip/12a1fadb41b5a6733c36b488b881fb19a28c92d3
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 16 Mar 2010 18:05:44 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 11:32:30 +0100

perf probe: Rename session to param

Since this name 'session' conflicts with 'perf_session', and
this structure just holds parameters anymore.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100316220544.32050.8788.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |   54 ++++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2087034..f577e14 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -56,20 +56,20 @@ static struct {
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
 	struct line_range line_range;
-} session;
+} params;
 
 
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
 {
-	struct probe_point *pp = &session.probes[session.nr_probe];
+	struct probe_point *pp = &params.probes[params.nr_probe];
 
-	pr_debug("probe-definition(%d): %s\n", session.nr_probe, str);
-	if (++session.nr_probe == MAX_PROBES)
+	pr_debug("probe-definition(%d): %s\n", params.nr_probe, str);
+	if (++params.nr_probe == MAX_PROBES)
 		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
 	/* Parse perf-probe event into probe_point */
-	parse_perf_probe_event(str, pp, &session.need_dwarf);
+	parse_perf_probe_event(str, pp, &params.need_dwarf);
 
 	pr_debug("%d arguments\n", pp->nr_args);
 }
@@ -103,9 +103,9 @@ static int opt_del_probe_event(const struct option *opt __used,
 			       const char *str, int unset __used)
 {
 	if (str) {
-		if (!session.dellist)
-			session.dellist = strlist__new(true, NULL);
-		strlist__add(session.dellist, str);
+		if (!params.dellist)
+			params.dellist = strlist__new(true, NULL);
+		strlist__add(params.dellist, str);
 	}
 	return 0;
 }
@@ -115,9 +115,9 @@ static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
 	if (str)
-		parse_line_range_desc(str, &session.line_range);
-	INIT_LIST_HEAD(&session.line_range.line_list);
-	session.show_lines = true;
+		parse_line_range_desc(str, &params.line_range);
+	INIT_LIST_HEAD(&params.line_range.line_list);
+	params.show_lines = true;
 	return 0;
 }
 #endif
@@ -140,7 +140,7 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 #endif
-	OPT_BOOLEAN('l', "list", &session.list_events,
+	OPT_BOOLEAN('l', "list", &params.list_events,
 		    "list up current probe events"),
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
@@ -168,7 +168,7 @@ static const struct option options[] = {
 #endif
 		"\t\t\tkprobe-tracer argument format.)\n",
 		opt_add_probe_event),
-	OPT_BOOLEAN('f', "force", &session.force_add, "forcibly add events"
+	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
 #ifndef NO_DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
@@ -190,20 +190,20 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		parse_probe_event_argv(argc, argv);
 	}
 
-	if ((!session.nr_probe && !session.dellist && !session.list_events &&
-	     !session.show_lines))
+	if ((!params.nr_probe && !params.dellist && !params.list_events &&
+	     !params.show_lines))
 		usage_with_options(probe_usage, options);
 
 	if (debugfs_valid_mountpoint(debugfs_path) < 0)
 		die("Failed to find debugfs path.");
 
-	if (session.list_events) {
-		if (session.nr_probe != 0 || session.dellist) {
+	if (params.list_events) {
+		if (params.nr_probe != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --list with"
 				   " --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
-		if (session.show_lines) {
+		if (params.show_lines) {
 			pr_warning("  Error: Don't use --list with --line.\n");
 			usage_with_options(probe_usage, options);
 		}
@@ -212,27 +212,27 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 
 #ifndef NO_DWARF_SUPPORT
-	if (session.show_lines) {
-		if (session.nr_probe != 0 || session.dellist) {
+	if (params.show_lines) {
+		if (params.nr_probe != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --line with"
 				   " --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
 
-		show_line_range(&session.line_range);
+		show_line_range(&params.line_range);
 		return 0;
 	}
 #endif
 
-	if (session.dellist) {
-		del_trace_kprobe_events(session.dellist);
-		strlist__delete(session.dellist);
-		if (session.nr_probe == 0)
+	if (params.dellist) {
+		del_trace_kprobe_events(params.dellist);
+		strlist__delete(params.dellist);
+		if (params.nr_probe == 0)
 			return 0;
 	}
 
-	add_trace_kprobe_events(session.probes, session.nr_probe,
-				session.force_add, session.need_dwarf);
+	add_trace_kprobe_events(params.probes, params.nr_probe,
+				params.force_add, params.need_dwarf);
 	return 0;
 }
 
