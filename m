Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab2EWPWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:22:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597Ab2EWPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:22:38 -0400
Date: Wed, 23 May 2012 08:22:18 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-8784eb7497b928de33a715e26da2bd51d424bec1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        namhyung.kim@lge.com, fweisbec@gmail.com, rostedt@goodmis.org,
        fweisbec@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        namhyung.kim@lge.com, fweisbec@gmail.com, rostedt@goodmis.org,
        fweisbec@redhat.com, tglx@linutronix.de
In-Reply-To: <1337697049-30251-2-git-send-email-fweisbec@gmail.com>
References: <1337697049-30251-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Rename struct event to struct event_format in perl engine
Git-Commit-ID: 8784eb7497b928de33a715e26da2bd51d424bec1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:22:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8784eb7497b928de33a715e26da2bd51d424bec1
Gitweb:     http://git.kernel.org/tip/8784eb7497b928de33a715e26da2bd51d424bec1
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 22 May 2012 16:30:49 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:32:29 -0300

perf script: Rename struct event to struct event_format in perl engine

While migrating to the libtraceevent, the perl scripting engine
missed this structure rename.

This fixes:

     util/scripting-engines/trace-event-perl.c: In function "find_cache_event":
     util/scripting-engines/trace-event-perl.c:244: error: assignment from incompatible pointer type
     util/scripting-engines/trace-event-perl.c:248: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:248: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:250: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c: In function "perl_process_tracepoint":
     util/scripting-engines/trace-event-perl.c:286: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:286: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:307: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c: In function "perl_generate_script":
     util/scripting-engines/trace-event-perl.c:498: error: passing argument 1 of "trace_find_next_event" from incompatible pointer type
     util/scripting-engines/../trace-event.h:56: note: expected "struct event_format *" but argument is of type "struct event *"
     util/scripting-engines/trace-event-perl.c:498: error: assignment from incompatible pointer type
     util/scripting-engines/trace-event-perl.c:499: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:499: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:513: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:532: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:556: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:569: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:570: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:579: error: dereferencing pointer to incomplete type
     util/scripting-engines/trace-event-perl.c:580: error: dereferencing pointer to incomplete type

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/r/1337697049-30251-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d50658b..4c1b3d7 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -56,7 +56,7 @@ INTERP my_perl;
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event *events[FTRACE_MAX_EVENT];
+struct event_format *events[FTRACE_MAX_EVENT];
 
 extern struct scripting_context *scripting_context;
 
@@ -181,7 +181,7 @@ static void define_flag_field(const char *ev_name,
 	LEAVE;
 }
 
-static void define_event_symbols(struct event *event,
+static void define_event_symbols(struct event_format *event,
 				 const char *ev_name,
 				 struct print_arg *args)
 {
@@ -233,10 +233,10 @@ static void define_event_symbols(struct event *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event *find_cache_event(int type)
+static inline struct event_format *find_cache_event(int type)
 {
 	static char ev_name[256];
-	struct event *event;
+	struct event_format *event;
 
 	if (events[type])
 		return events[type];
@@ -262,7 +262,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
-	struct event *event;
+	struct event_format *event;
 	int type;
 	int pid;
 	int cpu = sample->cpu;
@@ -450,7 +450,7 @@ static int perl_stop_script(void)
 
 static int perl_generate_script(const char *outfile)
 {
-	struct event *event = NULL;
+	struct event_format *event = NULL;
 	struct format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
