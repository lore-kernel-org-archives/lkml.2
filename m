Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2DWFAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48856 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2DWE7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:25 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-be-4f94e1aa7496
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/11] parse-events: Pass string type argument to args
Date: Mon, 23 Apr 2012 13:58:33 +0900
Message-Id: <1335157118-14658-7-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems PEVENT_FUNC_ARG_STRING missed passing the allocated
string to the args array. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/parse-events.c b/parse-events.c
index b7c81d8..3b39923 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3384,6 +3384,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			if (!string->str)
 				die("malloc str");
 
+			args[i] = (unsigned long long)string->str;
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
-- 
1.7.10

