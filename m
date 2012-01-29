Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2A2I4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:56:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59349 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2A2I4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:56:14 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 5/5] perf lock: Document lock info subcommand
Date: Sun, 29 Jan 2012 17:55:56 +0900
Message-Id: <1327827356-8786-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 26242d859c9be ("perf lock: Add "info" subcommand for dumping
misc information") added the subcommand but missed documentation. Add
it. Also update stale 'trace' subcommand to 'script'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/Documentation/perf-lock.txt |   20 +++++++++++++++++---
 tools/perf/builtin-lock.c              |    4 ++--
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index d6b2a4f2108b..c7f5f55634ac 100644
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
index 2296c391d0f5..12c814838993 100644
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
1.7.8.2

