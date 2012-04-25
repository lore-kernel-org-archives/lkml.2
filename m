Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab2DYM2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:28:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41891 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2DYM23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:28:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/15] parse-events: Let pevent_free() take a NULL pointer
Date: Wed, 25 Apr 2012 14:26:55 +0200
Message-Id: <1335356819-16710-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The pevent_free() should ack like other free()s and allow a
NULL pointer to be passed to it which makes error handling a bit
easier for the users of pevent_free().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/lib/traceevent/event-parse.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index cdb32c7..4d5092f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4960,13 +4960,20 @@ static void free_event(struct event_format *event)
  */
 void pevent_free(struct pevent *pevent)
 {
-	struct cmdline_list *cmdlist = pevent->cmdlist, *cmdnext;
-	struct func_list *funclist = pevent->funclist, *funcnext;
-	struct printk_list *printklist = pevent->printklist, *printknext;
+	struct cmdline_list *cmdlist, *cmdnext;
+	struct func_list *funclist, *funcnext;
+	struct printk_list *printklist, *printknext;
 	struct pevent_function_handler *func_handler;
 	struct event_handler *handle;
 	int i;
 
+	if (!pevent)
+		return;
+
+	cmdlist = pevent->cmdlist;
+	funclist = pevent->funclist;
+	printklist = pevent->printklist;
+
 	pevent->ref_count--;
 	if (pevent->ref_count)
 		return;
-- 
1.7.5.4

