Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1AZHPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:15:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:55717 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab1AZHPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:15:38 -0500
Date: Wed, 26 Jan 2011 07:15:12 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Allow specifying if the inherit bit should be set
Message-ID: <tip-9d04f1781772e11bd58806391555fc23ebb54377@git.kernel.org>
Git-Commit-ID: 9d04f1781772e11bd58806391555fc23ebb54377
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:15:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d04f1781772e11bd58806391555fc23ebb54377
Gitweb:     http://git.kernel.org/tip/9d04f1781772e11bd58806391555fc23ebb54377
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Jan 2011 00:08:18 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:29 -0200

perf evsel: Allow specifying if the inherit bit should be set

As this is a per-cpu attribute, we can't set it up in advance and use it
for all the calls.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    4 ++--
 tools/perf/builtin-test.c |    4 ++--
 tools/perf/util/evsel.c   |   16 +++++++++-------
 tools/perf/util/evsel.h   |    6 +++---
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b5fe522..e2a2d02 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -169,7 +169,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, cpus, false);
+		return perf_evsel__open_per_cpu(evsel, cpus, false, false);
 
 	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
@@ -177,7 +177,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, threads, false);
+	return perf_evsel__open_per_thread(evsel, threads, false, false);
 }
 
 /*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 4282d67..7287158 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -289,7 +289,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -364,7 +364,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index da473ec..82a0053 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -128,7 +128,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group)
+			      struct thread_map *threads, bool group, bool inherit)
 {
 	int cpu, thread;
 
@@ -139,6 +139,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
 
+		evsel->attr.inherit = (cpus->map[cpu] < 0) && inherit;
+
 		for (thread = 0; thread < threads->nr; thread++) {
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     threads->map[thread],
@@ -182,7 +184,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group)
+		     struct thread_map *threads, bool group, bool inherit)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -192,17 +194,17 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group);
+	return __perf_evsel__open(evsel, cpus, threads, group, inherit);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group)
+			     struct cpu_map *cpus, bool group, bool inherit)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group, inherit);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group)
+				struct thread_map *threads, bool group, bool inherit)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0962b50..1594696 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -46,11 +46,11 @@ void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group);
+			     struct cpu_map *cpus, bool group, bool inherit);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group);
+				struct thread_map *threads, bool group, bool inherit);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group);
+		     struct thread_map *threads, bool group, bool inherit);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
