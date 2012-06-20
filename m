Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2FTRCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:02:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2FTRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:02:19 -0400
Date: Wed, 20 Jun 2012 10:00:51 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rpjnarbt83nu9uowrfatmy12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Make some methods private
Git-Commit-ID: dd4f52232c60bcb41205a67d2df2ac0ecdfe3683
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 10:00:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd4f52232c60bcb41205a67d2df2ac0ecdfe3683
Gitweb:     http://git.kernel.org/tip/dd4f52232c60bcb41205a67d2df2ac0ecdfe3683
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Jun 2012 15:52:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:22 -0300

perf evsel: Make some methods private

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
