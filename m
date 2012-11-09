Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab2KIVqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:46:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2KIVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 21/21] tools lib traceevent: Use 'const' in variables pointing to const strings
Date: Fri,  9 Nov 2012 18:43:10 -0300
Message-Id: <1352497390-17716-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
1.7.9.2.358.g22243

