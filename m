Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab2KIR30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:29:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2KIR3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:29:19 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 13/13] perf annotate: Add --group option
Date: Sat, 10 Nov 2012 02:27:24 +0900
Message-Id: <1352482044-3443-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add --group option to enable event grouping.  When enabled, all the
group members information will be shown together with the leader so
skip non-leader events.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0c6edd60d67e..4b12608707f0 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -214,6 +214,10 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		struct hists *hists = &pos->hists;
 		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
+
 		if (nr_samples > 0) {
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
@@ -293,6 +297,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
+		    "Show event grou information together"),
 	OPT_END()
 	};
 
-- 
1.7.9.2

