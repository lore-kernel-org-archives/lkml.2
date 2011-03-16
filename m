Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1CPNyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:54:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1CPNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:54:36 -0400
Date: Wed, 16 Mar 2011 13:54:09 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <1299734608-5223-3-git-send-email-daahern@cisco.com>
References: <1299734608-5223-3-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tracing: Remove print_graph_cpu and print_graph_proc from trace-event-parse
Message-ID: <tip-2ee7a49f935b19f7daf0a110800488acd2479cba@git.kernel.org>
Git-Commit-ID: 2ee7a49f935b19f7daf0a110800488acd2479cba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:54:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ee7a49f935b19f7daf0a110800488acd2479cba
Gitweb:     http://git.kernel.org/tip/2ee7a49f935b19f7daf0a110800488acd2479cba
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 9 Mar 2011 22:23:24 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 17:05:51 -0300

perf tracing: Remove print_graph_cpu and print_graph_proc from trace-event-parse

Next patch moves printing of 'common' data into perf-script which
removes the need for these functions.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-3-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   65 +---------------------------------
 1 files changed, 2 insertions(+), 63 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8e622d..dd5f058 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2648,63 +2648,8 @@ static void print_lat_fmt(void *data, int size __unused)
 		printf("%d", lock_depth);
 }
 
-/* taken from Linux, written by Frederic Weisbecker */
-static void print_graph_cpu(int cpu)
-{
-	int i;
-	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpus);
-
-
-	/*
-	 * Start with a space character - to make it stand out
-	 * to the right a bit when trace output is pasted into
-	 * email:
-	 */
-	printf(" ");
-
-	/*
-	 * Tricky - we space the CPU field according to the max
-	 * number of online CPUs. On a 2-cpu system it would take
-	 * a maximum of 1 digit - on a 128 cpu system it would
-	 * take up to 3 digits:
-	 */
-	for (i = 0; i < log10_all - log10_this; i++)
-		printf(" ");
-
-	printf("%d) ", cpu);
-}
-
-#define TRACE_GRAPH_PROCINFO_LENGTH	14
 #define TRACE_GRAPH_INDENT	2
 
-static void print_graph_proc(int pid, const char *comm)
-{
-	/* sign + log10(MAX_INT) + '\0' */
-	char pid_str[11];
-	int spaces = 0;
-	int len;
-	int i;
-
-	sprintf(pid_str, "%d", pid);
-
-	/* 1 stands for the "-" character */
-	len = strlen(comm) + strlen(pid_str) + 1;
-
-	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
-		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
-
-	/* First spaces to align center */
-	for (i = 0; i < spaces / 2; i++)
-		printf(" ");
-
-	printf("%s-%s", comm, pid_str);
-
-	/* Last spaces to align center */
-	for (i = 0; i < spaces - (spaces / 2); i++)
-		printf(" ");
-}
-
 static struct record *
 get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 		    struct record *next)
@@ -2876,7 +2821,7 @@ static void print_graph_nested(struct event *event, void *data)
 
 static void
 pretty_print_func_ent(void *data, int size, struct event *event,
-		      int cpu, int pid, const char *comm,
+		      int cpu, int pid, const char *comm __unused,
 		      unsigned long secs, unsigned long usecs)
 {
 	struct format_field *field;
@@ -2886,9 +2831,6 @@ pretty_print_func_ent(void *data, int size, struct event *event,
 
 	printf("%5lu.%06lu |  ", secs, usecs);
 
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
 	printf(" | ");
 
 	if (latency_format) {
@@ -2924,7 +2866,7 @@ out_free:
 
 static void
 pretty_print_func_ret(void *data, int size __unused, struct event *event,
-		      int cpu, int pid, const char *comm,
+		      int cpu __unused, int pid __unused, const char *comm __unused,
 		      unsigned long secs, unsigned long usecs)
 {
 	unsigned long long rettime, calltime;
@@ -2934,9 +2876,6 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 
 	printf("%5lu.%06lu |  ", secs, usecs);
 
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
 	printf(" | ");
 
 	if (latency_format) {
