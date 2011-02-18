Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1BRMqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:46:47 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45535 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1BRMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:46:43 -0500
Message-ID: <4D5E6A36.80803@linux.vnet.ibm.com>
Date: Fri, 18 Feb 2011 18:16:46 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/2 v3.0]sched: Removing unused fields from /proc/schedstat
References: <4D3F3595.4020607@linux.vnet.ibm.com> <4D5E6970.1000105@linux.vnet.ibm.com>
In-Reply-To: <4D5E6970.1000105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Date: Fri, 18 Feb 2011 16:31:12 +0530
Subject: [PATCH 1/2 v3.0] sched: Updating the fields of /proc/schedstat

This patch removes the unused statistics from /proc/schedstat.
Also updates the request queue structure fields.

Signed-off-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
---
 include/linux/sched.h |   11 -----------
 kernel/sched_debug.c  |    1 -
 kernel/sched_stats.h  |   13 +++++--------
 3 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 23e9c27..a1691c7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -954,20 +954,9 @@ struct sched_domain {
 	unsigned int alb_failed;
 	unsigned int alb_pushed;
 
-	/* SD_BALANCE_EXEC stats */
-	unsigned int sbe_count;
-	unsigned int sbe_balanced;
-	unsigned int sbe_pushed;
-
-	/* SD_BALANCE_FORK stats */
-	unsigned int sbf_count;
-	unsigned int sbf_balanced;
-	unsigned int sbf_pushed;
-
 	/* try_to_wake_up() stats */
 	unsigned int ttwu_wake_remote;
 	unsigned int ttwu_move_affine;
-	unsigned int ttwu_move_balance;
 #endif
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 7bacd83..726b306 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -286,7 +286,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 	P(yld_count);
 
-	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 48ddf43..8869ed9 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -4,7 +4,7 @@
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 15
+#define SCHEDSTAT_VERSION 16
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
@@ -26,9 +26,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    "cpu%d %u %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
@@ -57,12 +57,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 				    sd->lb_nobusyg[itype]);
 			}
 			seq_printf(seq,
-				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
+				   " %u %u %u %u %u\n",
 			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
-			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
-			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
-			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
-			    sd->ttwu_move_balance);
+			    sd->ttwu_wake_remote, sd->ttwu_move_affine);
 		}
 		preempt_enable();
 #endif
