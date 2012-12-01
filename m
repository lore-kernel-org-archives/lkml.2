Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2LALV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:21:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2LALV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:21:26 -0500
Date: Sat, 1 Dec 2012 03:20:43 -0800
From: tip-bot for Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Message-ID: <tip-3786063a3c0ba26a2400a04476c0c0ccfd3c6beb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        namhyung@gmail.com, bp@alien8.de, runzhen@linux.vnet.ibm.com,
        dhowells@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        haodong@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        jwboyer@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, bp@alien8.de, namhyung@gmail.com,
        runzhen@linux.vnet.ibm.com, dhowells@redhat.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de, jwboyer@gmail.com
In-Reply-To: <50A488DD.6090106@linux.vnet.ibm.com>
References: <50A488DD.6090106@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm: Rename perf_kvm to perf_kvm_stat
Git-Commit-ID: 3786063a3c0ba26a2400a04476c0c0ccfd3c6beb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 01 Dec 2012 03:20:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3786063a3c0ba26a2400a04476c0c0ccfd3c6beb
Gitweb:     http://git.kernel.org/tip/3786063a3c0ba26a2400a04476c0c0ccfd3c6beb
Author:     Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
AuthorDate: Thu, 15 Nov 2012 14:17:01 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Nov 2012 19:44:05 -0300

perf kvm: Rename perf_kvm to perf_kvm_stat

Then let it only be used in 'perf kvm stat'.

Preparatory patch to stop trying to build parts of this tool that for
now are only supported on x86.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/50A488DD.6090106@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 111 +++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index e013bdb..9fa45fa 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -58,7 +58,7 @@ struct kvm_event_key {
 };
 
 
-struct perf_kvm;
+struct perf_kvm_stat;
 
 struct kvm_events_ops {
 	bool (*is_begin_event)(struct perf_evsel *evsel,
@@ -66,7 +66,7 @@ struct kvm_events_ops {
 			       struct event_key *key);
 	bool (*is_end_event)(struct perf_evsel *evsel,
 			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct perf_kvm *kvm, struct event_key *key,
+	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
 			   char decode[20]);
 	const char *name;
 };
@@ -79,7 +79,7 @@ struct exit_reasons_table {
 #define EVENTS_BITS		12
 #define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
 
-struct perf_kvm {
+struct perf_kvm_stat {
 	struct perf_tool    tool;
 	struct perf_session *session;
 
@@ -146,7 +146,7 @@ static struct exit_reasons_table svm_exit_reasons[] = {
 	SVM_EXIT_REASONS
 };
 
-static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm_stat *kvm, u64 exit_code)
 {
 	int i = kvm->exit_reasons_size;
 	struct exit_reasons_table *tbl = kvm->exit_reasons;
@@ -162,7 +162,7 @@ static const char *get_exit_reason(struct perf_kvm *kvm, u64 exit_code)
 	return "UNKNOWN";
 }
 
-static void exit_event_decode_key(struct perf_kvm *kvm,
+static void exit_event_decode_key(struct perf_kvm_stat *kvm,
 				  struct event_key *key,
 				  char decode[20])
 {
@@ -228,7 +228,7 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
 	return false;
 }
 
-static void mmio_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				  struct event_key *key,
 				  char decode[20])
 {
@@ -271,7 +271,7 @@ static bool ioport_event_end(struct perf_evsel *evsel,
 	return kvm_entry_event(evsel);
 }
 
-static void ioport_event_decode_key(struct perf_kvm *kvm __maybe_unused,
+static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
 				    struct event_key *key,
 				    char decode[20])
 {
@@ -286,7 +286,7 @@ static struct kvm_events_ops ioport_events = {
 	.name = "IO Port Access"
 };
 
-static bool register_kvm_events_ops(struct perf_kvm *kvm)
+static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 {
 	bool ret = true;
 
@@ -311,7 +311,7 @@ struct vcpu_event_record {
 };
 
 
-static void init_kvm_event_record(struct perf_kvm *kvm)
+static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 {
 	int i;
 
@@ -360,7 +360,7 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	return event;
 }
 
-static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
+static struct kvm_event *find_create_kvm_event(struct perf_kvm_stat *kvm,
 					       struct event_key *key)
 {
 	struct kvm_event *event;
@@ -381,7 +381,7 @@ static struct kvm_event *find_create_kvm_event(struct perf_kvm *kvm,
 	return event;
 }
 
-static bool handle_begin_event(struct perf_kvm *kvm,
+static bool handle_begin_event(struct perf_kvm_stat *kvm,
 			       struct vcpu_event_record *vcpu_record,
 			       struct event_key *key, u64 timestamp)
 {
@@ -425,7 +425,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
-static bool handle_end_event(struct perf_kvm *kvm,
+static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
 			     u64 timestamp)
@@ -486,7 +486,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 	return thread->priv;
 }
 
-static bool handle_kvm_event(struct perf_kvm *kvm,
+static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 			     struct thread *thread,
 			     struct perf_evsel *evsel,
 			     struct perf_sample *sample)
@@ -541,7 +541,7 @@ static struct kvm_event_key keys[] = {
 	{ NULL, NULL }
 };
 
-static bool select_key(struct perf_kvm *kvm)
+static bool select_key(struct perf_kvm_stat *kvm)
 {
 	int i;
 
@@ -577,7 +577,8 @@ static void insert_to_result(struct rb_root *result, struct kvm_event *event,
 	rb_insert_color(&event->rb, result);
 }
 
-static void update_total_count(struct perf_kvm *kvm, struct kvm_event *event)
+static void
+update_total_count(struct perf_kvm_stat *kvm, struct kvm_event *event)
 {
 	int vcpu = kvm->trace_vcpu;
 
@@ -590,7 +591,7 @@ static bool event_is_valid(struct kvm_event *event, int vcpu)
 	return !!get_event_count(event, vcpu);
 }
 
-static void sort_result(struct perf_kvm *kvm)
+static void sort_result(struct perf_kvm_stat *kvm)
 {
 	unsigned int i;
 	int vcpu = kvm->trace_vcpu;
@@ -627,7 +628,7 @@ static void print_vcpu_info(int vcpu)
 		pr_info("VCPU %d:\n\n", vcpu);
 }
 
-static void print_result(struct perf_kvm *kvm)
+static void print_result(struct perf_kvm_stat *kvm)
 {
 	char decode[20];
 	struct kvm_event *event;
@@ -670,7 +671,8 @@ static int process_sample_event(struct perf_tool *tool,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->tid);
-	struct perf_kvm *kvm = container_of(tool, struct perf_kvm, tool);
+	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
+						 tool);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -701,7 +703,7 @@ static int get_cpu_isa(struct perf_session *session)
 	return isa;
 }
 
-static int read_events(struct perf_kvm *kvm)
+static int read_events(struct perf_kvm_stat *kvm)
 {
 	int ret;
 
@@ -750,7 +752,7 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-static int kvm_events_report_vcpu(struct perf_kvm *kvm)
+static int kvm_events_report_vcpu(struct perf_kvm_stat *kvm)
 {
 	int ret = -EINVAL;
 	int vcpu = kvm->trace_vcpu;
@@ -798,7 +800,8 @@ static const char * const record_args[] = {
 		_p;			\
 	})
 
-static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -821,7 +824,8 @@ static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static int kvm_events_report(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	const struct option kvm_events_report_options[] = {
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
@@ -864,24 +868,36 @@ static void print_kvm_stat_usage(void)
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }
 
-static int kvm_cmd_stat(struct perf_kvm *kvm, int argc, const char **argv)
+static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 {
+	struct perf_kvm_stat kvm = {
+		.file_name = file_name,
+
+		.trace_vcpu	= -1,
+		.report_event	= "vmexit",
+		.sort_key	= "sample",
+
+		.exit_reasons = svm_exit_reasons,
+		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
+		.exit_reasons_isa = "SVM",
+	};
+
 	if (argc == 1) {
 		print_kvm_stat_usage();
 		goto perf_stat;
 	}
 
 	if (!strncmp(argv[1], "rec", 3))
-		return kvm_events_record(kvm, argc - 1, argv + 1);
+		return kvm_events_record(&kvm, argc - 1, argv + 1);
 
 	if (!strncmp(argv[1], "rep", 3))
-		return kvm_events_report(kvm, argc - 1 , argv + 1);
+		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
 
-static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
+static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -890,7 +906,7 @@ static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("record");
 	rec_argv[i++] = strdup("-o");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -899,7 +915,7 @@ static int __cmd_record(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
+static int __cmd_report(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -908,7 +924,7 @@ static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("report");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -917,7 +933,8 @@ static int __cmd_report(struct perf_kvm *kvm, int argc, const char **argv)
 	return cmd_report(i, rec_argv, NULL);
 }
 
-static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
+static int
+__cmd_buildid_list(const char *file_name, int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -926,7 +943,7 @@ static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("buildid-list");
 	rec_argv[i++] = strdup("-i");
-	rec_argv[i++] = strdup(kvm->file_name);
+	rec_argv[i++] = strdup(file_name);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -937,20 +954,12 @@ static int __cmd_buildid_list(struct perf_kvm *kvm, int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	struct perf_kvm kvm = {
-		.trace_vcpu	= -1,
-		.report_event	= "vmexit",
-		.sort_key	= "sample",
-
-		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
-		.exit_reasons_isa = "SVM",
-	};
+	const char *file_name;
 
 	const struct option kvm_options[] = {
-		OPT_STRING('i', "input", &kvm.file_name, "file",
+		OPT_STRING('i', "input", &file_name, "file",
 			   "Input file name"),
-		OPT_STRING('o', "output", &kvm.file_name, "file",
+		OPT_STRING('o', "output", &file_name, "file",
 			   "Output file name"),
 		OPT_BOOLEAN(0, "guest", &perf_guest,
 			    "Collect guest os data"),
@@ -985,32 +994,32 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!perf_host)
 		perf_guest = 1;
 
-	if (!kvm.file_name) {
+	if (!file_name) {
 		if (perf_host && !perf_guest)
-			kvm.file_name = strdup("perf.data.host");
+			file_name = strdup("perf.data.host");
 		else if (!perf_host && perf_guest)
-			kvm.file_name = strdup("perf.data.guest");
+			file_name = strdup("perf.data.guest");
 		else
-			kvm.file_name = strdup("perf.data.kvm");
+			file_name = strdup("perf.data.kvm");
 
-		if (!kvm.file_name) {
+		if (!file_name) {
 			pr_err("Failed to allocate memory for filename\n");
 			return -ENOMEM;
 		}
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(&kvm, argc, argv);
+		return __cmd_record(file_name, argc, argv);
 	else if (!strncmp(argv[0], "rep", 3))
-		return __cmd_report(&kvm, argc, argv);
+		return __cmd_report(file_name, argc, argv);
 	else if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
 	else if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
-		return __cmd_buildid_list(&kvm, argc, argv);
+		return __cmd_buildid_list(file_name, argc, argv);
 	else if (!strncmp(argv[0], "stat", 4))
-		return kvm_cmd_stat(&kvm, argc, argv);
+		return kvm_cmd_stat(file_name, argc, argv);
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
