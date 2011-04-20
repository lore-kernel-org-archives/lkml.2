Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1DTQYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:24:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab1DTQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:24:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf script: Add support for PERF_TYPE_RAW
Date: Wed, 20 Apr 2011 13:23:56 -0300
Message-Id: <1303316636-11923-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303316636-11923-1-git-send-email-acme@infradead.org>
References: <1303316636-11923-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Sharma <asharma@fb.com>

Useful for getting stack traces for hardware events not handled by
PERF_TYPE_HARDWARE.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/n/tip-qimdcdpekjqxuyqovy4kjusx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6cf811a..b3012c4 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -82,6 +82,16 @@ static struct {
 				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
 	},
+
+	[PERF_TYPE_RAW] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
 };
 
 static bool output_set_by_user(void)
@@ -502,6 +512,8 @@ static int parse_output_fields(const struct option *opt __used,
 			type = PERF_TYPE_SOFTWARE;
 		else if (!strcmp(str, "trace"))
 			type = PERF_TYPE_TRACEPOINT;
+		else if (!strcmp(str, "raw"))
+			type = PERF_TYPE_RAW;
 		else {
 			fprintf(stderr, "Invalid event type in field string.\n");
 			return -EINVAL;
@@ -902,7 +914,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,sym",
 		     parse_output_fields),
 
 	OPT_END()
-- 
1.6.2.5

