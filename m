Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2HUQ1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:27:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2HUQ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:27:45 -0400
Date: Tue, 21 Aug 2012 09:27:27 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-db146f06ac0bbea63271b6c78f4341ee46843e10@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345144224-27280-5-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Rename global variable 'events'
  in util/header.c
Git-Commit-ID: db146f06ac0bbea63271b6c78f4341ee46843e10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:27:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db146f06ac0bbea63271b6c78f4341ee46843e10
Gitweb:     http://git.kernel.org/tip/db146f06ac0bbea63271b6c78f4341ee46843e10
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 16 Aug 2012 21:10:20 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Aug 2012 13:13:08 -0300

perf tools: Rename global variable 'events' in util/header.c

Trivial patch that renames global variable 'events' in util/header.c.

Use a more specific naming to avoid conflicts. Same for variable
'event_count'.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-5-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e2e5129..1e5b6aa 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -23,8 +23,8 @@
 
 static bool no_buildid_cache = false;
 
-static int event_count;
-static struct perf_trace_event_type *events;
+static int trace_event_count;
+static struct perf_trace_event_type *trace_events;
 
 static u32 header_argc;
 static const char **header_argv;
@@ -36,24 +36,24 @@ int perf_header__push_event(u64 id, const char *name)
 	if (strlen(name) > MAX_EVENT_NAME)
 		pr_warning("Event %s will be truncated\n", name);
 
-	nevents = realloc(events, (event_count + 1) * sizeof(*events));
+	nevents = realloc(trace_events, (trace_event_count + 1) * sizeof(*trace_events));
 	if (nevents == NULL)
 		return -ENOMEM;
-	events = nevents;
+	trace_events = nevents;
 
-	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
-	events[event_count].event_id = id;
-	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
-	event_count++;
+	memset(&trace_events[trace_event_count], 0, sizeof(struct perf_trace_event_type));
+	trace_events[trace_event_count].event_id = id;
+	strncpy(trace_events[trace_event_count].name, name, MAX_EVENT_NAME - 1);
+	trace_event_count++;
 	return 0;
 }
 
 char *perf_header__find_event(u64 id)
 {
 	int i;
-	for (i = 0 ; i < event_count; i++) {
-		if (events[i].event_id == id)
-			return events[i].name;
+	for (i = 0 ; i < trace_event_count; i++) {
+		if (trace_events[i].event_id == id)
+			return trace_events[i].name;
 	}
 	return NULL;
 }
@@ -1726,9 +1726,9 @@ out_err_write:
 	}
 
 	header->event_offset = lseek(fd, 0, SEEK_CUR);
-	header->event_size = event_count * sizeof(struct perf_trace_event_type);
-	if (events) {
-		err = do_write(fd, events, header->event_size);
+	header->event_size = trace_event_count * sizeof(struct perf_trace_event_type);
+	if (trace_events) {
+		err = do_write(fd, trace_events, header->event_size);
 		if (err < 0) {
 			pr_debug("failed to write perf header events\n");
 			return err;
@@ -2211,13 +2211,13 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	if (f_header.event_types.size) {
 		lseek(fd, f_header.event_types.offset, SEEK_SET);
-		events = malloc(f_header.event_types.size);
-		if (events == NULL)
+		trace_events = malloc(f_header.event_types.size);
+		if (trace_events == NULL)
 			return -ENOMEM;
-		if (perf_header__getbuffer64(header, fd, events,
+		if (perf_header__getbuffer64(header, fd, trace_events,
 					     f_header.event_types.size))
 			goto out_errno;
-		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
+		trace_event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
 	perf_header__process_sections(header, fd, &session->pevent,
@@ -2362,8 +2362,8 @@ int perf_event__synthesize_event_types(struct perf_tool *tool,
 	struct perf_trace_event_type *type;
 	int i, err = 0;
 
-	for (i = 0; i < event_count; i++) {
-		type = &events[i];
+	for (i = 0; i < trace_event_count; i++) {
+		type = &trace_events[i];
 
 		err = perf_event__synthesize_event_type(tool, type->event_id,
 							type->name, process,
