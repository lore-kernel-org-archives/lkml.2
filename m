Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2IXQER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:04:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab2IXQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/30] tools lib traceevent: Make sure that arg->op.right is set properly
Date: Mon, 24 Sep 2012 12:59:33 -0300
Message-Id: <1348502384-14442-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When process_op failed, @arg will be freed on a caller with type of
PRINT_OP.  Thus free_arg() will try to free ->op.right field which can
have stale value if something bad happens in the middle.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348037924-17568-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6270ee2..27088c5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1719,6 +1719,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->op.left = left;
 		arg->op.prio = 0;
 
+		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
 
 	} else if (strcmp(token, ">>") == 0 ||
@@ -1745,6 +1746,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->type = PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
+		arg->op.right = NULL;
 
 		if (set_op_prio(arg) == -1) {
 			event->flags |= EVENT_FL_FAILED;
@@ -1792,6 +1794,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		arg->op.prio = 0;
 
+		/* it will set arg->op.right */
 		type = process_array(event, arg, tok);
 
 	} else {
-- 
1.7.1

