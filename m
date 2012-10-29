Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2J2QdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:33:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61611 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2J2QdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:33:11 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 9/9] perf evsel: remove perf_evsel__open_per_cpu
Date: Mon, 29 Oct 2012 10:31:49 -0600
Message-Id: <1351528309-87705-10-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
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
index 618d411..a9ccab7 100644
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
index 6f94d6d..4459cc0 100644
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

