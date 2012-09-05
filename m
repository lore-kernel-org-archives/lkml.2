Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab2IEXJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:34330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab2IEXJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/17] perf header: Set tracepoint event name only if not set
Date: Wed,  5 Sep 2012 20:08:54 -0300
Message-Id: <1346886537-11621-15-git-send-email-acme@infradead.org>
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

The event name can be set already by processing a event_desc data.

So check it before setting to prevent possible leak.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346821373-31621-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a124b93..05c9310 100644
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
1.7.1

