Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2IMH1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:20 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57860 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab2IMH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:09 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-18-50518ac88b22
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 15/15] perf report: Add --cumulate option
Date: Thu, 13 Sep 2012 16:20:11 +0900
Message-Id: <1347520811-28150-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When --cumulate option is given, it will print accumulated hist stat
information.  It requires callchain information.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 97b2e6300f4c..92da05c2151f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -282,6 +282,12 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 		}
 	}
 
+	if (!symbol_conf.use_callchain && symbol_conf.cumulate_callchain) {
+		ui__error("Selected --cumulate but no callchain data. "
+			  "Did you call 'perf record' without -g?\n");
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -641,6 +647,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "cumulate", &symbol_conf.cumulate_callchain,
+		    "Accumulate period along the callchain"),
 	OPT_END()
 	};
 
-- 
1.7.11.4

