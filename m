Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2DWFAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:38 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48856 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2DWE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:24 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-b6-4f94e1aaae8a
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] parse-events: Remove unused arg->dynarray.index
Date: Mon, 23 Apr 2012 13:58:31 +0900
Message-Id: <1335157118-14658-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems index field of struct print_arg_dynarray is not used.
Let's remove it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    4 ----
 parse-events.h |    1 -
 2 files changed, 5 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index b4ae313..3e5ac44 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -706,9 +706,6 @@ static void free_arg(struct print_arg *arg)
 	case PRINT_BSTRING:
 		free(arg->string.string);
 		break;
-	case PRINT_DYNAMIC_ARRAY:
-		free(arg->dynarray.index);
-		break;
 	case PRINT_OP:
 		free(arg->op.op);
 		free_arg(arg->op.left);
@@ -2315,7 +2312,6 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 		goto out_free;
 
 	arg->dynarray.field = field;
-	arg->dynarray.index = 0;
 
 	if (read_expected(EVENT_DELIM, ")") < 0)
 		goto out_free;
diff --git a/parse-events.h b/parse-events.h
index 67e7886..960e598 100644
--- a/parse-events.h
+++ b/parse-events.h
@@ -226,7 +226,6 @@ struct print_arg_symbol {
 
 struct print_arg_dynarray {
 	struct format_field	*field;
-	struct print_arg	*index;
 };
 
 struct print_arg;
-- 
1.7.10

