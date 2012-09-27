Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2I0Fjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:39:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2I0Fjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:39:37 -0400
Date: Wed, 26 Sep 2012 22:39:17 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-70d9304475730a63dd8da884abc7c76ee4772cd2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1348037924-17568-5-git-send-email-namhyung@kernel.org>
References: <1348037924-17568-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Free field if an error occurs on process_flags/symbols
Git-Commit-ID: 70d9304475730a63dd8da884abc7c76ee4772cd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:39:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70d9304475730a63dd8da884abc7c76ee4772cd2
Gitweb:     http://git.kernel.org/tip/70d9304475730a63dd8da884abc7c76ee4772cd2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 19 Sep 2012 15:58:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:03:18 -0300

tools lib traceevent: Free field if an error occurs on process_flags/symbols

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
