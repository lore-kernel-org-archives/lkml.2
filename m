Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2ISHIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:08:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47869 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2ISHH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:07:26 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-60-50596f29d175
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/4] tools lib traceevent: Free field if an error occurs on process_flags/symbols
Date: Wed, 19 Sep 2012 15:58:44 +0900
Message-Id: <1348037924-17568-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
References: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The field should be freed on error paths.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e0f755111bd0..4d6c1e9f45f0 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2329,7 +2329,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 		type = process_op(event, field, &token);
 
 	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
+		goto out_free_field;
 	free_token(token);
 
 	arg->flags.field = field;
@@ -2351,7 +2351,9 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 	type = read_token_item(tok);
 	return type;
 
- out_free:
+out_free_field:
+	free_arg(field);
+out_free:
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
@@ -2375,7 +2377,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 
 	type = process_arg(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
+		goto out_free_field;
 
 	arg->symbol.field = field;
 
@@ -2387,7 +2389,9 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
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
1.7.11.4

