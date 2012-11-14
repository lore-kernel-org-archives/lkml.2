Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2KNHtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:49:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2KNHti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:49:38 -0500
Date: Tue, 13 Nov 2012 23:49:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0k5g8urwu7vwkgbcbt2x05fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Use 'const'
  in variables pointing to const strings
Git-Commit-ID: 27f94d52394003d444a383eaf8d4824daf32432e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:49:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f94d52394003d444a383eaf8d4824daf32432e
Gitweb:     http://git.kernel.org/tip/27f94d52394003d444a383eaf8d4824daf32432e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Nov 2012 17:40:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 17:42:47 -0300

tools lib traceevent: Use 'const' in variables pointing to const strings

Fixing the build on fedora 14, 32-bit:

  tools/lib/traceevent/event-parse.c: In function ‘find_cmdline’:
  tools/lib/traceevent/event-parse.c:183:3: error: return discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c:186:3: error: return discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c:195:2: error: return discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c: In function ‘process_func_handler’:
  tools/lib/traceevent/event-parse.c:2658:9: error: assignment discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c:2660:9: error: assignment discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c: In function ‘print_mac_arg’:
  tools/lib/traceevent/event-parse.c:3892:14: error: initialization discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c:3906:7: error: assignment discards qualifiers from pointer target type
  tools/lib/traceevent/event-parse.c: In function ‘pevent_print_event’:
  tools/lib/traceevent/event-parse.c:4412:24: error: initialization discards qualifiers from pointer target type

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-0k5g8urwu7vwkgbcbt2x05fe@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 669953a..5a824e3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -174,7 +174,7 @@ static int cmdline_init(struct pevent *pevent)
 	return 0;
 }
 
-static char *find_cmdline(struct pevent *pevent, int pid)
+static const char *find_cmdline(struct pevent *pevent, int pid)
 {
 	const struct cmdline *comm;
 	struct cmdline key;
@@ -2637,7 +2637,7 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	struct print_arg *farg;
 	enum event_type type;
 	char *token;
-	char *test;
+	const char *test;
 	int i;
 
 	arg->type = PRINT_FUNC;
@@ -3889,7 +3889,7 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 			  struct event_format *event, struct print_arg *arg)
 {
 	unsigned char *buf;
-	char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
+	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
 
 	if (arg->type == PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
@@ -4409,7 +4409,7 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 			struct pevent_record *record)
 {
-	static char *spaces = "                    "; /* 20 spaces */
+	static const char *spaces = "                    "; /* 20 spaces */
 	struct event_format *event;
 	unsigned long secs;
 	unsigned long usecs;
