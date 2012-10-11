Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2JKE0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:26:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2JKE0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:26:00 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 9/9] perf evsel: remove perf_evsel__open_per_cpu
Date: Wed, 10 Oct 2012 22:25:35 -0600
Message-Id: <1349929535-92861-10-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
References: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer needed with perf-stat converted to perf_evlist__open_counters.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/evsel.c |    6 ------
 tools/perf/util/evsel.h |    2 --
 2 files changed, 8 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ffdd94e..ab3d1c8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -774,12 +774,6 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	return __perf_evsel__open(evsel, cpus, threads);
 }
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus)
-{
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
-}
-
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3ead0d5..bf32de4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -121,8 +121,6 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-- 
1.7.10.1

