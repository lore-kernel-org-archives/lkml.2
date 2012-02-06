Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2BFWKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:10:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51233 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2BFWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/8] perf stat: Align scaled output of cpu-clock
Date: Mon,  6 Feb 2012 20:10:23 -0200
Message-Id: <1328566223-27218-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328566223-27218-1-git-send-email-acme@infradead.org>
References: <1328566223-27218-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328514285-26232-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 32d930eb..d14b37a 100644
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
1.7.9.123.g65da0

