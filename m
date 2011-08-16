Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1HPOlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:41:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33687 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab1HPOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:41:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] perf annotate: Add --symfs option
Date: Tue, 16 Aug 2011 11:41:34 -0300
Message-Id: <1313505695-20724-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313505695-20724-1-git-send-email-acme@infradead.org>
References: <1313505695-20724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

If you have --symfs in perf report, then you also need it for perf
annotate.  This allows off-box assembly level analysis of perf.data
samples.

This patch complements:

commit ec5761eab318e50e69fcf8e63e9edaef5949c067
Author: David Ahern <daahern@cisco.com>
Date:   Thu Dec 9 13:27:07 2010 -0700

    perf symbols: Add symfs option for off-box analysis using specified tree

Acked-by: David Ahern <daahern@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <daahern@cisco.com>
Link: http://lkml.kernel.org/r/20110729232040.GA21838@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |    3 +++
 tools/perf/builtin-annotate.c              |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 5bc0600..98a31e3 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -80,6 +80,9 @@ OPTIONS
 	Interleave source code with assembly code. Enabled by default,
 	disable with --no-source.
 
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5015e04..c5be288 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -267,6 +267,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		   "Look for files with symbols relative to this directory"),
 	OPT_BOOLEAN('0', "source", &symbol_conf.annotate_src,
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN('0', "asm-raw", &symbol_conf.annotate_asm_raw,
-- 
1.6.2.5

