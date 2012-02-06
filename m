Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2BFHa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:30:26 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57865 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2BFHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:30:25 -0500
X-AuditID: 9c930179-b7bf0ae00000132b-1b-4f2f818e2d78
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf stat: Adjust print unit
Date: Mon,  6 Feb 2012 16:44:44 +0900
Message-Id: <1328514285-26232-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default 'M/sec' unit is not useful if the result is small enough.
Adjust it dynamically according to the value.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-stat.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 459b8620a5d9..32d930eb754e 100644
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
1.7.9

