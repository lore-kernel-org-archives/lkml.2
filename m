Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2FRCyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:54:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53084 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2FRCye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:54:34 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-a0-4fde9866280b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2 1/5] tools lib traceevent: Replace malloc_or_die to plain calloc in alloc_event()
Date: Mon, 18 Jun 2012 11:50:47 +0900
Message-Id: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Because the only caller of the alloc_event()
(pevent_parse_event) checks return value properly
and all it does after allocation is initializing,
it can be changed to use plain calloc.

Thanks to Steven for suggesting this simpler way.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-wagq5qbdy1mytvjkrjbqt095@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index c471075e4974..4f667fdc5fae 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -619,12 +619,7 @@ void pevent_print_printk(struct pevent *pevent)
 
 static struct event_format *alloc_event(void)
 {
-	struct event_format *event;
-
-	event = malloc_or_die(sizeof(*event));
-	memset(event, 0, sizeof(*event));
-
-	return event;
+	return calloc(1, sizeof(struct event_format));
 }
 
 static void add_event(struct pevent *pevent, struct event_format *event)
-- 
1.7.10.2

