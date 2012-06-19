Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2FSSDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:03:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:43331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/20] perf evsel: Make some methods private
Date: Tue, 19 Jun 2012 14:50:20 -0300
Message-Id: <1340128221-17348-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now that __event_name is gone, no need to export __perf_evsel__[hs]w_name().

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rpjnarbt83nu9uowrfatmy12@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    6 +++---
 tools/perf/util/evsel.h |    5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8f0e9dd..876f639 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -78,7 +78,7 @@ static const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
 	"ref-cycles",
 };
 
-const char *__perf_evsel__hw_name(u64 config)
+static const char *__perf_evsel__hw_name(u64 config)
 {
 	if (config < PERF_COUNT_HW_MAX && perf_evsel__hw_names[config])
 		return perf_evsel__hw_names[config];
@@ -140,7 +140,7 @@ static const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX] = {
 	"emulation-faults",
 };
 
-const char *__perf_evsel__sw_name(u64 config)
+static const char *__perf_evsel__sw_name(u64 config)
 {
 	if (config < PERF_COUNT_SW_MAX && perf_evsel__sw_names[config])
 		return perf_evsel__sw_names[config];
@@ -219,7 +219,7 @@ int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 			 perf_evsel__hw_cache_op[op][1]);
 }
 
-int __perf_evsel__hw_cache_name(u64 config, char *bf, size_t size)
+static int __perf_evsel__hw_cache_name(u64 config, char *bf, size_t size)
 {
 	u8 op, result, type = (config >>  0) & 0xff;
 	const char *err = "unknown-ext-hardware-cache-type";
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index c936feb..67cc503 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -95,11 +95,6 @@ const char *perf_evsel__hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX]
 				       [PERF_EVSEL__MAX_ALIASES];
 int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 					    char *bf, size_t size);
-int __perf_evsel__hw_cache_name(u64 config, char *bf, size_t size);
-
-const char *__perf_evsel__hw_name(u64 config);
-const char *__perf_evsel__sw_name(u64 config);
-
 const char *perf_evsel__name(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
-- 
1.7.1

