Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2BFWLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:11:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:56455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BFWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/8] perf stat: Adjust print unit
Date: Mon,  6 Feb 2012 20:10:22 -0200
Message-Id: <1328566223-27218-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328566223-27218-1-git-send-email-acme@infradead.org>
References: <1328566223-27218-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The default 'M/sec' unit is not useful if the result is small enough.

Adjust it dynamically according to the value.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328514285-26232-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 459b862..32d930eb 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -844,12 +844,18 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		fprintf(output, " # %8.3f GHz                    ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
+		char unit = 'M';
+
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
 			ratio = 1000.0 * avg / total;
+		if (ratio < 0.001) {
+			ratio *= 1000;
+			unit = 'K';
+		}
 
-		fprintf(output, " # %8.3f M/sec                  ", ratio);
+		fprintf(output, " # %8.3f %c/sec                  ", ratio, unit);
 	} else {
 		fprintf(output, "                                   ");
 	}
-- 
1.7.9.123.g65da0

