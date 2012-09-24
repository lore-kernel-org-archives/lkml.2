Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2IXQEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:04:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab2IXQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 25/30] tools lib traceevent: Fix afterlife gotos
Date: Mon, 24 Sep 2012 12:59:39 -0300
Message-Id: <1348502384-14442-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of dying, just use do_warning and let the goto that is there to
take place.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-aoaus46ngnt9oc2pt7ckot5d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2aeae55..2091991 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1270,7 +1270,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		}
 
 		if (!field->type) {
-			die("no type found");
+			do_warning("%s: no type found", __func__);
 			goto fail;
 		}
 		field->name = last_token;
@@ -1317,7 +1317,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 				free_token(token);
 				type = read_token(&token);
 				if (type == EVENT_NONE) {
-					die("failed to find token");
+					do_warning("failed to find token");
 					goto fail;
 				}
 			}
@@ -1669,7 +1669,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 	if (arg->type == PRINT_OP && !arg->op.left) {
 		/* handle single op */
 		if (token[1]) {
-			die("bad op token %s", token);
+			do_warning("bad op token %s", token);
 			goto out_free;
 		}
 		switch (token[0]) {
-- 
1.7.1

