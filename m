Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2IEFKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:10:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48142 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2IEFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:10:22 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-3e-5046debc3de8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/7] perf header: Set tracepoint event name only if not set
Date: Wed,  5 Sep 2012 14:02:48 +0900
Message-Id: <1346821373-31621-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The event name can be set already by processing a event_desc data.
So check it before setting to prevent possible leak.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a124b9328170..05c9310c3da1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2314,7 +2314,7 @@ static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist,
 	struct perf_evsel *pos;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT && !pos->name &&
 		    perf_evsel__set_tracepoint_name(pos, pevent))
 			return -1;
 	}
-- 
1.7.11.4

