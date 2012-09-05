Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab2IEXLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:11:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:34329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859Ab2IEXJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/17] perf header: Use evlist->nr_entries on write_event_desc()
Date: Wed,  5 Sep 2012 20:08:53 -0300
Message-Id: <1346886537-11621-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Number of events (evsels) in a evlist is kept on nr_entries field
so that we don't need to recalculate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346821373-31621-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9696e64..a124b93 100644
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
1.7.1

