Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2DWFA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46999 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2DWE7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:25 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-c2-4f94e1aa0854
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/11] parse-events: Do not call add_event() again if allocation failed
Date: Mon, 23 Apr 2012 13:58:34 +0900
Message-Id: <1335157118-14658-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory allocation for the field name is failed, do not
goto event_failed since we added the event already.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/parse-events.c b/parse-events.c
index 3b39923..52cf331 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -4637,7 +4637,8 @@ int pevent_parse_event(struct pevent *pevent,
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
 				do_warning("failed to allocate field name");
-				goto event_failed;
+				event->flags |= EVENT_FL_FAILED;
+				return -1;
 			}
 			arg->field.field = field;
 		}
-- 
1.7.10

