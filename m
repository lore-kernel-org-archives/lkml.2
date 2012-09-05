Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2IEFK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:10:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47884 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2IEFKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:10:21 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-39-5046debc16bd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/7] perf header: Use evlist->nr_entries on write_event_desc()
Date: Wed,  5 Sep 2012 14:02:47 +0900
Message-Id: <1346821373-31621-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Number of events (evsels) in a evlist is kept on nr_entries field
so that we don't need to recalculate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9696e64c9dbd..a124b9328170 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -610,11 +610,10 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
-	u32 nre = 0, nri, sz;
+	u32 nre, nri, sz;
 	int ret;
 
-	list_for_each_entry(evsel, &evlist->entries, node)
-		nre++;
+	nre = evlist->nr_entries;
 
 	/*
 	 * write number of events
-- 
1.7.11.4

