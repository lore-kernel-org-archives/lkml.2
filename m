Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2BFHa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:30:28 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57865 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2BFHa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:30:27 -0500
X-AuditID: 9c930179-b7bf0ae00000132b-28-4f2f818f4b7b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf stat: Align scaled output of cpu-clock
Date: Mon,  6 Feb 2012 16:44:45 +0900
Message-Id: <1328514285-26232-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328514285-26232-1-git-send-email-namhyung.kim@lge.com>
References: <1328514285-26232-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of cpu-clock event is controlled in nsec_printout(),
but its alignment was broken:

 Performance counter stats for 'sleep 1':

         6,038,774 instructions              #    0.00  insns per cycle
               180 faults                    #    0.007 K/sec                   [99.95%]
         1,282,201 branches                  #    0.053 M/sec                   [99.84%]
      24126.221811 cpu-clock                 [99.62%]
      24121.689540 task-clock                #   24.098 CPUs utilized           [99.52%]

       1.001001017 seconds time elapsed

This patch fixes this:

 Performance counter stats for 'sleep 1':

        13,540,843 instructions              #    0.00  insns per cycle
               180 faults                    #    0.007 K/sec                   [99.94%]
         2,875,386 branches                  #    0.119 M/sec                   [99.82%]
      24144.221137 cpu-clock                                                    [99.61%]
      24133.515366 task-clock                #   24.109 CPUs utilized           [99.52%]

       1.001020946 seconds time elapsed

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 32d930eb754e..d14b37ad7638 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -576,6 +576,8 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
 		fprintf(output, " # %8.3f CPUs utilized          ",
 			avg / avg_stats(&walltime_nsecs_stats));
+	else
+		fprintf(output, "                                   ");
 }
 
 /* used for get_ratio_color() */
-- 
1.7.9

