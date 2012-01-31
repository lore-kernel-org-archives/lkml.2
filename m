Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2AaBZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:25:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:44371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2AaBYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf lock: Document lock info subcommand
Date: Mon, 30 Jan 2012 23:24:37 -0200
Message-Id: <1327973079-29426-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The commit 26242d859c9be ("perf lock: Add "info" subcommand for dumping
misc information") added the subcommand but missed documentation. Add
it. Also update stale 'trace' subcommand to 'script'.

Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327827356-8786-5-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-lock.txt |   20 +++++++++++++++++---
 tools/perf/builtin-lock.c              |    4 ++--
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index d6b2a4f..c7f5f55 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -8,7 +8,7 @@ perf-lock - Analyze lock events
 SYNOPSIS
 --------
 [verse]
-'perf lock' {record|report|trace}
+'perf lock' {record|report|script|info}
 
 DESCRIPTION
 -----------
@@ -20,10 +20,13 @@ and statistics with this 'perf lock' command.
   produces the file "perf.data" which contains tracing
   results of lock events.
 
-  'perf lock trace' shows raw lock events.
-
   'perf lock report' reports statistical data.
 
+  'perf lock script' shows raw lock events.
+
+  'perf lock info' shows metadata like threads or addresses
+  of lock instances.
+
 COMMON OPTIONS
 --------------
 
@@ -47,6 +50,17 @@ REPORT OPTIONS
         Sorting key. Possible values: acquired (default), contended,
         wait_total, wait_max, wait_min.
 
+INFO OPTIONS
+------------
+
+-t::
+--threads::
+	dump thread list in perf.data
+
+-m::
+--map::
+	dump map of lock instances (address:name table)
+
 SEE ALSO
 --------
 linkperf:perf[1]
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2296c39..12c8148 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -922,12 +922,12 @@ static const struct option info_options[] = {
 	OPT_BOOLEAN('t', "threads", &info_threads,
 		    "dump thread list in perf.data"),
 	OPT_BOOLEAN('m', "map", &info_map,
-		    "map of lock instances (name:address table)"),
+		    "map of lock instances (address:name table)"),
 	OPT_END()
 };
 
 static const char * const lock_usage[] = {
-	"perf lock [<options>] {record|trace|report}",
+	"perf lock [<options>] {record|report|script|info}",
 	NULL
 };
 
-- 
1.7.9.rc2.1.g69204

