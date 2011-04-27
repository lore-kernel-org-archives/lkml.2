Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab1D0QEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:04:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:47307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056Ab1D0QEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:04:47 -0400
Date: Wed, 27 Apr 2011 16:04:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n1eqio7hjpn0dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Fix printout vertical alignment
Git-Commit-ID: 9ceb1c3d1fe15c2f9b55eaa8978019ef0e0a06ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:04:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ceb1c3d1fe15c2f9b55eaa8978019ef0e0a06ac
Gitweb:     http://git.kernel.org/tip/9ceb1c3d1fe15c2f9b55eaa8978019ef0e0a06ac
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 28 Apr 2011 02:57:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Apr 2011 17:48:55 +0200

perf stat: Fix printout vertical alignment

Before:

 |
 | Performance counter stats for '/home/mingo/hackbench 20' (5 runs):
 |
 |        71,321,607 instructions:u           #    0.42  insns per cycle  ( +-  0.00% )
 |       168,040,009 cycles:u                 #    0.000 GHz                      ( +-  0.81% )
 |
 |        1.468002368  seconds time elapsed  ( +-  1.33% )
 |

After:

 |
 | Performance counter stats for '/home/mingo/hackbench 20' (5 runs):
 |
 |        71,321,607 instructions:u           #    0.42  insns per cycle          ( +-  0.00% )
 |       168,040,009 cycles:u                 #    0.000 GHz                      ( +-  0.81% )
 |
 |        1.468002368  seconds time elapsed  ( +-  1.33% )
 |

The last column (stddev noise) is properly aligned, vertically.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n1eqio7hjpn0dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6959fde..003caa8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -575,7 +575,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " #    %4.2f  insns per cycle", ratio);
+		fprintf(stderr, " #    %4.2f  insns per cycle        ", ratio);
 
 		total = avg_stats(&runtime_stalled_cycles_stats[cpu]);
 
