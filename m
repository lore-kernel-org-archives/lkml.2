Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2AaNWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:22:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2AaNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:22:09 -0500
Date: Tue, 31 Jan 2012 05:21:43 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-d1eec3ecaef083affaf3210246b01b6e80d3a44e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1327827356-8786-5-git-send-email-namhyung@gmail.com>
References: <1327827356-8786-5-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Document lock info subcommand
Git-Commit-ID: d1eec3ecaef083affaf3210246b01b6e80d3a44e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:21:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1eec3ecaef083affaf3210246b01b6e80d3a44e
Gitweb:     http://git.kernel.org/tip/d1eec3ecaef083affaf3210246b01b6e80d3a44e
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 29 Jan 2012 17:55:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 18:30:48 -0200

perf lock: Document lock info subcommand

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
 
