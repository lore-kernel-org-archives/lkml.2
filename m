Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1LWVyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:54:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:50737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab1LWVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/15] perf tools: Continue processing header on unknown features
Date: Fri, 23 Dec 2011 19:53:12 -0200
Message-Id: <1324677198-5191-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

A feature may be unknown if perf.data is created and parsed on different
perf tool versions. This should not stop the header to be processed,
instead continue processing it.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323248577-11268-2-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c48be8..428a4a2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1109,7 +1109,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 	}
 	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
 		pr_warning("unknown feature %d\n", feat);
-		return -1;
+		return 0;
 	}
 	if (!feat_ops[feat].print)
 		return 0;
-- 
1.7.8.rc0.35.gee6df

