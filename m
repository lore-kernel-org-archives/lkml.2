Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1AaMur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:50:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:33182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1AaMup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:50:45 -0500
Date: Mon, 31 Jan 2011 12:50:17 GMT
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
Subject: [tip:perf/core] perf tools: Rename 'struct sample_data' to 'struct perf_sample'
Message-ID: <tip-8d50e5b4171a69cf48ca94a1e7c14033d0b4771d@git.kernel.org>
Git-Commit-ID: 8d50e5b4171a69cf48ca94a1e7c14033d0b4771d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:50:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d50e5b4171a69cf48ca94a1e7c14033d0b4771d
Gitweb:     http://git.kernel.org/tip/8d50e5b4171a69cf48ca94a1e7c14033d0b4771d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 29 Jan 2011 13:02:00 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 29 Jan 2011 16:25:20 -0200

perf tools: Rename 'struct sample_data' to 'struct perf_sample'

Making the namespace more uniform.

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
 tools/perf/builtin-annotate.c  |    2 +-
 tools/perf/builtin-diff.c      |    2 +-
 tools/perf/builtin-inject.c    |    8 ++++----
 tools/perf/builtin-kmem.c      |    2 +-
 tools/perf/builtin-lock.c      |    2 +-
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/builtin-report.c    |   36 ++++++++++++++++++------------------
 tools/perf/builtin-sched.c     |    2 +-
 tools/perf/builtin-script.c    |    2 +-
 tools/perf/builtin-test.c      |    2 +-
 tools/perf/builtin-timechart.c |    8 ++++----
 tools/perf/builtin-top.c       |    4 ++--
 tools/perf/util/build-id.c     |    4 ++--
 tools/perf/util/event.c        |   16 ++++++++--------
 tools/perf/util/event.h        |   18 +++++++++---------
 tools/perf/util/evsel.c        |    4 ++--
 tools/perf/util/session.c      |   26 +++++++++++++-------------
 tools/perf/util/session.h      |    4 ++--
 18 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8879463..ef36751 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -58,7 +58,7 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 	return hist_entry__inc_addr_samples(he, al->addr);
 }
 
-static int process_sample_event(event_t *event, struct sample_data *sample,
+static int process_sample_event(event_t *event, struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3153e49..0822149 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -31,7 +31,7 @@ static int hists__add_entry(struct hists *self,
 }
 
 static int diff__process_sample_event(event_t *event,
-				      struct sample_data *sample,
+				      struct perf_sample *sample,
 				      struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 0c78ffa..4c9388c 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -36,13 +36,13 @@ static int event__repipe_synth(event_t *event,
 	return 0;
 }
 
-static int event__repipe(event_t *event, struct sample_data *sample __used,
+static int event__repipe(event_t *event, struct perf_sample *sample __used,
 			 struct perf_session *session)
 {
 	return event__repipe_synth(event, session);
 }
 
-static int event__repipe_mmap(event_t *self, struct sample_data *sample,
+static int event__repipe_mmap(event_t *self, struct perf_sample *sample,
 			      struct perf_session *session)
 {
 	int err;
@@ -53,7 +53,7 @@ static int event__repipe_mmap(event_t *self, struct sample_data *sample,
 	return err;
 }
 
-static int event__repipe_task(event_t *self, struct sample_data *sample,
+static int event__repipe_task(event_t *self, struct perf_sample *sample,
 			      struct perf_session *session)
 {
 	int err;
@@ -119,7 +119,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 	return 0;
 }
 
-static int event__inject_buildid(event_t *event, struct sample_data *sample,
+static int event__inject_buildid(event_t *event, struct perf_sample *sample,
 				 struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index d97256d..3c1cdcf 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -304,7 +304,7 @@ process_raw_event(event_t *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(event_t *event, struct sample_data *sample,
+static int process_sample_event(event_t *event, struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2b36def..c3f5127 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -834,7 +834,7 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(event_t *self, struct sample_data *sample,
+static int process_sample_event(event_t *self, struct perf_sample *sample,
 				struct perf_session *s)
 {
 	struct thread *thread = perf_session__findnew(s, sample->tid);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index caf9279..5d3e4b3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -101,7 +101,7 @@ static void write_output(void *buf, size_t size)
 }
 
 static int process_synthesized_event(event_t *event,
-				     struct sample_data *sample __used,
+				     struct perf_sample *sample __used,
 				     struct perf_session *self __used)
 {
 	write_output(event, event->header.size);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f6a4349..bbbadcc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -77,9 +77,9 @@ static struct hists *perf_session__hists_findnew(struct perf_session *self,
 	return new;
 }
 
-static int perf_session__add_hist_entry(struct perf_session *self,
+static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
-					struct sample_data *data)
+					struct perf_sample *sample)
 {
 	struct symbol *parent = NULL;
 	int err = 0;
@@ -87,28 +87,28 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	struct hists *hists;
 	struct perf_event_attr *attr;
 
-	if ((sort__has_parent || symbol_conf.use_callchain) && data->callchain) {
-		err = perf_session__resolve_callchain(self, al->thread,
-						      data->callchain, &parent);
+	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
+		err = perf_session__resolve_callchain(session, al->thread,
+						      sample->callchain, &parent);
 		if (err)
 			return err;
 	}
 
-	attr = perf_header__find_attr(data->id, &self->header);
+	attr = perf_header__find_attr(sample->id, &session->header);
 	if (attr)
-		hists = perf_session__hists_findnew(self, data->id, attr->type, attr->config);
+		hists = perf_session__hists_findnew(session, sample->id, attr->type, attr->config);
 	else
-		hists = perf_session__hists_findnew(self, data->id, 0, 0);
+		hists = perf_session__hists_findnew(session, sample->id, 0, 0);
 	if (hists == NULL)
 		return -ENOMEM;
 
-	he = __hists__add_entry(hists, al, parent, data->period);
+	he = __hists__add_entry(hists, al, parent, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
 
 	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain, &self->callchain_cursor,
-				       data->period);
+		err = callchain_append(he->callchain, &session->callchain_cursor,
+				       sample->period);
 		if (err)
 			return err;
 	}
@@ -124,32 +124,32 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 }
 
 static int add_event_total(struct perf_session *session,
-			   struct sample_data *data,
+			   struct perf_sample *sample,
 			   struct perf_event_attr *attr)
 {
 	struct hists *hists;
 
 	if (attr)
-		hists = perf_session__hists_findnew(session, data->id,
+		hists = perf_session__hists_findnew(session, sample->id,
 						    attr->type, attr->config);
 	else
-		hists = perf_session__hists_findnew(session, data->id, 0, 0);
+		hists = perf_session__hists_findnew(session, sample->id, 0, 0);
 
 	if (!hists)
 		return -ENOMEM;
 
-	hists->stats.total_period += data->period;
+	hists->stats.total_period += sample->period;
 	/*
 	 * FIXME: add_event_total should be moved from here to
 	 * perf_session__process_event so that the proper hist is passed to
 	 * the event_op methods.
 	 */
 	hists__inc_nr_events(hists, PERF_RECORD_SAMPLE);
-	session->hists.stats.total_period += data->period;
+	session->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static int process_sample_event(event_t *event, struct sample_data *sample,
+static int process_sample_event(event_t *event, struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct addr_location al;
@@ -179,7 +179,7 @@ static int process_sample_event(event_t *event, struct sample_data *sample,
 	return 0;
 }
 
-static int process_read_event(event_t *event, struct sample_data *sample __used,
+static int process_read_event(event_t *event, struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	struct perf_event_attr *attr;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 29acb89..ff993c8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1607,7 +1607,7 @@ process_raw_event(event_t *raw_event __used, struct perf_session *session,
 		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(event_t *event, struct sample_data *sample,
+static int process_sample_event(event_t *event, struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct thread *thread;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b766c2a..5c4c809 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -63,7 +63,7 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static int process_sample_event(event_t *event, struct sample_data *sample,
+static int process_sample_event(event_t *event, struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 738830d..df62433 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -550,7 +550,7 @@ static int test__basic_mmap(void)
 		}
 
 	while ((event = perf_evlist__read_on_cpu(evlist, 0)) != NULL) {
-		struct sample_data sample;
+		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE) {
 			pr_debug("unexpected %s event\n",
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 746cf03..01cf0c3 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -276,21 +276,21 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int process_comm_event(event_t *event, struct sample_data *sample __used,
+static int process_comm_event(event_t *event, struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 
-static int process_fork_event(event_t *event, struct sample_data *sample __used,
+static int process_fork_event(event_t *event, struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
 }
 
-static int process_exit_event(event_t *event, struct sample_data *sample __used,
+static int process_exit_event(event_t *event, struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	pid_exit(event->fork.pid, event->fork.time);
@@ -487,7 +487,7 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 
 
 static int process_sample_event(event_t *event __used,
-				struct sample_data *sample,
+				struct perf_sample *sample,
 				struct perf_session *session)
 {
 	struct trace_entry *te;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7f92ab7..d923127 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -997,7 +997,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 }
 
 static void event__process_sample(const event_t *self,
-				  struct sample_data *sample,
+				  struct perf_sample *sample,
 				  struct perf_session *session)
 {
 	u64 ip = self->ip.ip;
@@ -1107,7 +1107,7 @@ static void event__process_sample(const event_t *self,
 
 static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 {
-	struct sample_data sample;
+	struct perf_sample sample;
 	event_t *event;
 
 	while ((event = perf_evlist__read_on_cpu(evsel_list, cpu)) != NULL) {
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index deffb8c..b184a7f 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -15,7 +15,7 @@
 #include "debug.h"
 
 static int build_id__mark_dso_hit(event_t *event,
-				  struct sample_data *sample __used,
+				  struct perf_sample *sample __used,
 				  struct perf_session *session)
 {
 	struct addr_location al;
@@ -37,7 +37,7 @@ static int build_id__mark_dso_hit(event_t *event,
 	return 0;
 }
 
-static int event__exit_del_thread(event_t *self, struct sample_data *sample __used,
+static int event__exit_del_thread(event_t *self, struct perf_sample *sample __used,
 				  struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->fork.tid);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index b9d4ac8..5c886fb 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -34,7 +34,7 @@ const char *event__get_event_name(unsigned int id)
 	return event__name[id];
 }
 
-static struct sample_data synth_sample = {
+static struct perf_sample synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
 	.time	   = -1,
@@ -440,7 +440,7 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm,
 	return 0;
 }
 
-int event__process_comm(event_t *self, struct sample_data *sample __used,
+int event__process_comm(event_t *self, struct perf_sample *sample __used,
 			struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->comm.tid);
@@ -456,7 +456,7 @@ int event__process_comm(event_t *self, struct sample_data *sample __used,
 	return 0;
 }
 
-int event__process_lost(event_t *self, struct sample_data *sample __used,
+int event__process_lost(event_t *self, struct perf_sample *sample __used,
 			struct perf_session *session)
 {
 	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
@@ -567,7 +567,7 @@ out_problem:
 	return -1;
 }
 
-int event__process_mmap(event_t *self, struct sample_data *sample __used,
+int event__process_mmap(event_t *self, struct perf_sample *sample __used,
 			struct perf_session *session)
 {
 	struct machine *machine;
@@ -609,7 +609,7 @@ out_problem:
 	return 0;
 }
 
-int event__process_task(event_t *self, struct sample_data *sample __used,
+int event__process_task(event_t *self, struct perf_sample *sample __used,
 			struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->fork.tid);
@@ -632,7 +632,7 @@ int event__process_task(event_t *self, struct sample_data *sample __used,
 	return 0;
 }
 
-int event__process(event_t *event, struct sample_data *sample,
+int event__process(event_t *event, struct perf_sample *sample,
 		   struct perf_session *session)
 {
 	switch (event->header.type) {
@@ -757,7 +757,7 @@ static void dso__calc_col_width(struct dso *self, struct hists *hists)
 }
 
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
-			     struct addr_location *al, struct sample_data *data,
+			     struct addr_location *al, struct perf_sample *sample,
 			     symbol_filter_t filter)
 {
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -788,7 +788,7 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
 	al->sym = NULL;
-	al->cpu = data->cpu;
+	al->cpu = sample->cpu;
 
 	if (al->map) {
 		if (symbol_conf.dso_list &&
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d79e4ed..84fd71f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -61,7 +61,7 @@ struct sample_event {
 	u64 array[];
 };
 
-struct sample_data {
+struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
 	u64 time;
@@ -138,7 +138,7 @@ struct perf_session;
 
 typedef int (*event__handler_synth_t)(event_t *event, 
 				      struct perf_session *session);
-typedef int (*event__handler_t)(event_t *event, struct sample_data *sample,
+typedef int (*event__handler_t)(event_t *event, struct perf_sample *sample,
 				struct perf_session *session);
 
 int event__synthesize_thread(pid_t pid, event__handler_t process,
@@ -154,25 +154,25 @@ int event__synthesize_modules(event__handler_t process,
 			      struct perf_session *session,
 			      struct machine *machine);
 
-int event__process_comm(event_t *self, struct sample_data *sample,
+int event__process_comm(event_t *event, struct perf_sample *sample,
 			struct perf_session *session);
-int event__process_lost(event_t *self, struct sample_data *sample,
+int event__process_lost(event_t *event, struct perf_sample *sample,
 			struct perf_session *session);
-int event__process_mmap(event_t *self, struct sample_data *sample,
+int event__process_mmap(event_t *event, struct perf_sample *sample,
 			struct perf_session *session);
-int event__process_task(event_t *self, struct sample_data *sample,
+int event__process_task(event_t *event, struct perf_sample *sample,
 			struct perf_session *session);
-int event__process(event_t *event, struct sample_data *sample,
+int event__process(event_t *event, struct perf_sample *sample,
 		   struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
-			     struct addr_location *al, struct sample_data *data,
+			     struct addr_location *al, struct perf_sample *sample,
 			     symbol_filter_t filter);
 
 const char *event__get_event_name(unsigned int id);
 
 int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
-			struct sample_data *sample);
+			struct perf_sample *sample);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f98b3e5..a134885 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -368,7 +368,7 @@ out_unmap:
 }
 
 static int event__parse_id_sample(const event_t *event, u64 type,
-				  struct sample_data *sample)
+				  struct perf_sample *sample)
 {
 	const u64 *array = event->sample.array;
 
@@ -406,7 +406,7 @@ static int event__parse_id_sample(const event_t *event, u64 type,
 }
 
 int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
-			struct sample_data *data)
+			struct perf_sample *data)
 {
 	const u64 *array;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e6a0740..ee0b611 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -67,7 +67,7 @@ out_close:
 
 static void perf_session__id_header_size(struct perf_session *session)
 {
-       struct sample_data *data;
+       struct perf_sample *data;
        u64 sample_type = session->sample_type;
        u16 size = 0;
 
@@ -299,7 +299,7 @@ static int process_event_synth_stub(event_t *event __used,
 }
 
 static int process_event_stub(event_t *event __used,
-			      struct sample_data *sample __used,
+			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
@@ -475,7 +475,7 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
-				      struct sample_data *sample,
+				      struct perf_sample *sample,
 				      struct perf_event_ops *ops,
 				      u64 file_offset);
 
@@ -485,7 +485,7 @@ static void flush_sample_queue(struct perf_session *s,
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
 	struct sample_queue *tmp, *iter;
-	struct sample_data sample;
+	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 
@@ -610,11 +610,11 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
 static int perf_session_queue_event(struct perf_session *s, event_t *event,
-				    struct sample_data *data, u64 file_offset)
+				    struct perf_sample *sample, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
-	u64 timestamp = data->time;
+	u64 timestamp = sample->time;
 	struct sample_queue *new;
 
 	if (!timestamp || timestamp == ~0ULL)
@@ -650,7 +650,7 @@ static int perf_session_queue_event(struct perf_session *s, event_t *event,
 	return 0;
 }
 
-static void callchain__printf(struct sample_data *sample)
+static void callchain__printf(struct perf_sample *sample)
 {
 	unsigned int i;
 
@@ -663,7 +663,7 @@ static void callchain__printf(struct sample_data *sample)
 
 static void perf_session__print_tstamp(struct perf_session *session,
 				       event_t *event,
-				       struct sample_data *sample)
+				       struct perf_sample *sample)
 {
 	if (event->header.type != PERF_RECORD_SAMPLE &&
 	    !session->sample_id_all) {
@@ -679,7 +679,7 @@ static void perf_session__print_tstamp(struct perf_session *session,
 }
 
 static void dump_event(struct perf_session *session, event_t *event,
-		       u64 file_offset, struct sample_data *sample)
+		       u64 file_offset, struct perf_sample *sample)
 {
 	if (!dump_trace)
 		return;
@@ -697,7 +697,7 @@ static void dump_event(struct perf_session *session, event_t *event,
 }
 
 static void dump_sample(struct perf_session *session, event_t *event,
-			struct sample_data *sample)
+			struct perf_sample *sample)
 {
 	if (!dump_trace)
 		return;
@@ -712,7 +712,7 @@ static void dump_sample(struct perf_session *session, event_t *event,
 
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
-				      struct sample_data *sample,
+				      struct perf_sample *sample,
 				      struct perf_event_ops *ops,
 				      u64 file_offset)
 {
@@ -745,7 +745,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 }
 
 static int perf_session__preprocess_sample(struct perf_session *session,
-					   event_t *event, struct sample_data *sample)
+					   event_t *event, struct perf_sample *sample)
 {
 	if (event->header.type != PERF_RECORD_SAMPLE ||
 	    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
@@ -789,7 +789,7 @@ static int perf_session__process_event(struct perf_session *session,
 				       struct perf_event_ops *ops,
 				       u64 file_offset)
 {
-	struct sample_data sample;
+	struct perf_sample sample;
 	int ret;
 
 	if (session->header.needs_swap && event__swap_ops[event->header.type])
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7823976..365bf53 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -57,7 +57,7 @@ struct perf_session {
 
 struct perf_event_ops;
 
-typedef int (*event_op)(event_t *self, struct sample_data *sample,
+typedef int (*event_op)(event_t *self, struct perf_sample *sample,
 			struct perf_session *session);
 typedef int (*event_synth_op)(event_t *self, struct perf_session *session);
 typedef int (*event_op2)(event_t *self, struct perf_session *session,
@@ -158,7 +158,7 @@ size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
 
 static inline int perf_session__parse_sample(struct perf_session *session,
 					     const event_t *event,
-					     struct sample_data *sample)
+					     struct perf_sample *sample)
 {
 	return event__parse_sample(event, session->sample_type,
 				   session->sample_id_all, sample);
