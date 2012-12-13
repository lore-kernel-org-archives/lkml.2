Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2LMNJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:09:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2LMNJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:09:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 02/14] perf hists: Rename hist_entry__add_pair arguments
Date: Thu, 13 Dec 2012 14:09:00 +0100
Message-Id: <1355404152-16523-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic is to attach pair to the leader hist_entry.
Arguments of hist_entry__add_pair function were placed
the other way round.. driving me crazy.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index a1c0d56..7425f8d 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -115,10 +115,10 @@ static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
 	return NULL;
 }
 
-static inline void hist_entry__add_pair(struct hist_entry *he,
-					struct hist_entry *pair)
+static inline void hist_entry__add_pair(struct hist_entry *pair,
+					struct hist_entry *he)
 {
-	list_add_tail(&he->pairs.head, &pair->pairs.node);
+	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
 enum sort_type {
-- 
1.7.11.7

