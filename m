Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab2GEPqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:46:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2GEPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 10/20] tools lib traceevent: Pass string type argument to args
Date: Thu,  5 Jul 2012 12:45:08 -0300
Message-Id: <1341503118-13198-11-git-send-email-acme@infradead.org>
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

It seems PEVENT_FUNC_ARG_STRING missed passing the allocated string to
the args array.  Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1335157118-14658-7-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 05eb6b4..337ca02 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3489,6 +3489,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			if (!string->str)
 				die("malloc str");
 
+			args[i] = (unsigned long long)string->str;
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
-- 
1.7.9.2.358.g22243

