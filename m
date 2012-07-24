Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2GXJII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:08:08 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53057 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2GXJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:07:05 -0400
X-AuditID: 9c930179-b7bdcae000003d91-10-500e65b3f7db
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/12] perf report: Add --group option
Date: Tue, 24 Jul 2012 18:01:33 +0900
Message-Id: <1343120493-23059-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add --group option to enable event grouping. When enabled, all the
group members information will be shown together with the leader.

Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d7dfa2863ece..2570ca66e15b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -662,6 +662,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.report_group,
+		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_END()
-- 
1.7.10.4

