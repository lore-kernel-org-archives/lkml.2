Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2KIQp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:45:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53884 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2KIQpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:45:21 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 11/12] perf report: Add --group option
Date: Sat, 10 Nov 2012 01:43:33 +0900
Message-Id: <1352479414-2324-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-report.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index be4941afa658..1a1a650fe952 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -665,6 +665,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
+		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
-- 
1.7.9.2

