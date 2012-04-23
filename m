Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2DWFAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48856 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2DWE70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:26 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-c6-4f94e1ab9bbe
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/11] parse-events: Fix some comments
Date: Mon, 23 Apr 2012 13:58:35 +0900
Message-Id: <1335157118-14658-9-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update and add missing argument descriptions and fix some typo
on function comments.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 52cf331..0d785c2 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3920,8 +3920,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
  * pevent_data_lat_fmt - parse the data for the latency format
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
- * @data: the raw data to read from
- * @size: currently unused.
+ * @record: the record to read from
  *
  * This parses out the Latency format (interrupts disabled,
  * need rescheduling, in hard/soft interrupt, preempt count
@@ -4056,10 +4055,7 @@ const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid)
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
@@ -4811,7 +4807,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not fould, or 1 if buffer is full.
+ * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
@@ -4853,11 +4849,12 @@ static void free_func_handle(struct pevent_function_handler *func)
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
@@ -4928,12 +4925,13 @@ int pevent_register_print_function(struct pevent *pevent,
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
1.7.10

