Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2IXQFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:05:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab2IXQAA (ORCPT
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
Subject: [PATCH 21/30] tools lib traceevent: Free field if an error occurs on process_flags/symbols
Date: Mon, 24 Sep 2012 12:59:35 -0300
Message-Id: <1348502384-14442-22-git-send-email-acme@infradead.org>
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

The field should be freed on error paths.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348037924-17568-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index a776ed5..acf4038 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2247,7 +2247,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 		type = process_op(event, field, &token);
 
 	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
+		goto out_free_field;
 	free_token(token);
 
 	arg->flags.field = field;
@@ -2269,7 +2269,9 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 	type = read_token_item(tok);
 	return type;
 
- out_free:
+out_free_field:
+	free_arg(field);
+out_free:
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
@@ -2289,7 +2291,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 
 	type = process_arg(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
+		goto out_free_field;
 
 	arg->symbol.field = field;
 
@@ -2301,7 +2303,9 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 	type = read_token_item(tok);
 	return type;
 
- out_free:
+out_free_field:
+	free_arg(field);
+out_free:
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
-- 
1.7.1

