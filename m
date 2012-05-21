Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2EUBoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 21:44:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63687 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2EUBoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 21:44:17 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-d0-4fb99dec73fd
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf target: Add cpu flag to sample_type if target has cpu
Date: Mon, 21 May 2012 10:42:07 +0900
Message-Id: <1337564527-9367-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PERF_SAMPLE_CPU flag into attr->sample_type if an user
specified any of cpu target (either system-wide or cpu list).
It will show correct values when cpu sort key is given for
perf top and perf report.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-top.c |    3 +++
 tools/perf/util/evsel.c  |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ebcd15883ab8..8e3cf429dd18 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -900,6 +900,9 @@ static void perf_top__start_counters(struct perf_top *top)
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
+		if (perf_target__has_cpu(&top->target))
+			attr->sample_type |= PERF_SAMPLE_CPU;
+
 		if (symbol_conf.use_callchain)
 			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d7a2b4b9801d..d26b8fe0abd1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -107,7 +107,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	if (opts->call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (opts->target.system_wide)
+	if (perf_target__has_cpu(&opts->target))
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
 	if (opts->period)
-- 
1.7.10.1

