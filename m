Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2HNCDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:03:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63288 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2HNCDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:03:46 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-6f-5029b2004fd6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH] perf script: Fix a NULL pointer dereference
Date: Tue, 14 Aug 2012 10:57:03 +0900
Message-Id: <1344909423-26384-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If 'perf script --gen-script' was called with a perf.data which
contains no tracepoint event, it'd segfault due to NULL pevent
pointer. Fix it.

Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4cb7f3831f78..a5a554efeb50 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -293,7 +293,7 @@ struct event_format *trace_find_next_event(struct pevent *pevent,
 {
 	static int idx;
 
-	if (!pevent->events)
+	if (!pevent || !pevent->events)
 		return NULL;
 
 	if (!event) {
-- 
1.7.11.2

