Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab2GEPrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:47:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2GEPpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 12/20] tools lib traceevent: Fix some comments
Date: Thu,  5 Jul 2012 12:45:10 -0300
Message-Id: <1341503118-13198-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Update and add missing argument descriptions and fix some typo on
function comments.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1335157118-14658-9-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 99b0cd4..8630160 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4037,8 +4037,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
  * pevent_data_lat_fmt - parse the data for the latency format
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
- * @data: the raw data to read from
- * @size: currently unused.
+ * @record: the record to read from
  *
  * This parses out the Latency format (interrupts disabled,
  * need rescheduling, in hard/soft interrupt, preempt count
@@ -4173,10 +4172,7 @@ const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid)
  * pevent_data_comm_from_pid - parse the data into the print format
  * @s: the trace_seq to write to
  * @event: the handle to the event
- * @cpu: the cpu the event was recorded on
- * @data: the raw data
- * @size: the size of the raw data
- * @nsecs: the timestamp of the event
+ * @record: the record to read from
  *
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
@@ -4944,7 +4940,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not fould, or 1 if buffer is full.
+ * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
@@ -4986,11 +4982,12 @@ static void free_func_handle(struct pevent_function_handler *func)
  * pevent_register_print_function - register a helper function
  * @pevent: the handle to the pevent
  * @func: the function to process the helper function
+ * @ret_type: the return type of the helper function
  * @name: the name of the helper function
  * @parameters: A list of enum pevent_func_arg_type
  *
  * Some events may have helper functions in the print format arguments.
- * This allows a plugin to dynmically create a way to process one
+ * This allows a plugin to dynamically create a way to process one
  * of these functions.
  *
  * The @parameters is a variable list of pevent_func_arg_type enums that
@@ -5061,12 +5058,13 @@ int pevent_register_print_function(struct pevent *pevent,
 }
 
 /**
- * pevent_register_event_handle - register a way to parse an event
+ * pevent_register_event_handler - register a way to parse an event
  * @pevent: the handle to the pevent
  * @id: the id of the event to register
  * @sys_name: the system name the event belongs to
  * @event_name: the name of the event
  * @func: the function to call to parse the event information
+ * @context: the data to be passed to @func
  *
  * This function allows a developer to override the parsing of
  * a given event. If for some reason the default print format
-- 
1.7.9.2.358.g22243

