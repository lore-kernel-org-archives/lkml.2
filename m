Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2BGTju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:39:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:39:49 -0500
Date: Tue, 7 Feb 2012 11:39:23 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9dac6a29e0ce0cd9dec497baa123e216b00b525d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1328514285-26232-2-git-send-email-namhyung.kim@lge.com>
References: <1328514285-26232-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Align scaled output of cpu-clock
Git-Commit-ID: 9dac6a29e0ce0cd9dec497baa123e216b00b525d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:39:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9dac6a29e0ce0cd9dec497baa123e216b00b525d
Gitweb:     http://git.kernel.org/tip/9dac6a29e0ce0cd9dec497baa123e216b00b525d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 6 Feb 2012 16:44:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Feb 2012 19:17:39 -0200

perf stat: Align scaled output of cpu-clock

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
index 32d930e..d14b37a 100644
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
