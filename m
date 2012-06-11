Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2FKGc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:32:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64929 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2FKGc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:32:27 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-f2-4fd590f99791
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tools lib traceevent: Replace malloc_or_die to plain malloc in alloc_event()
Date: Mon, 11 Jun 2012 15:28:53 +0900
Message-Id: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Because the only caller of the alloc_event()
(pevent_parse_event) checks return value properly,
it can be changed to use plain malloc.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index c471075e4974..a6b5bcdc5580 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -621,7 +621,9 @@ static struct event_format *alloc_event(void)
 {
 	struct event_format *event;
 
-	event = malloc_or_die(sizeof(*event));
+	event = malloc(sizeof(*event));
+	if (!event)
+		return NULL;
 	memset(event, 0, sizeof(*event));
 
 	return event;
-- 
1.7.10.2

