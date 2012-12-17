Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2LQGj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:26 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2LQGjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:14 -0500
X-AuditID: 9c930179-b7becae000000e51-95-50cebe0f92df
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 13/14] perf report: Add --group option
Date: Mon, 17 Dec 2012 15:39:04 +0900
Message-Id: <1355726345-29553-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add --group option to enable event grouping.  When enabled, all the
group members information will be shown together with the leader.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 3 +++
 tools/perf/builtin-report.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index f4d91bebd59d..b3e8fcb9bbce 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -171,6 +171,9 @@ OPTIONS
 --objdump=<path>::
         Path to objdump binary.
 
+--group::
+	Show event group information together.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 50263ec0b0d0..9fb3e4bf49d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -668,6 +668,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
+		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
-- 
1.7.11.7

