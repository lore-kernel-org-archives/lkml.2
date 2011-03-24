Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1CXRwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:52:00 -0400
Received: from flusers.ccur.com ([173.221.59.2]:49941 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756627Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:03 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/24] jrcu: reorganize statistics
Message-ID: <20110324174803.GA18907@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: re-organize statistics and their display.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -588,20 +588,26 @@ static int rcu_debugfs_show(struct seq_f
 	else
 		seq_printf(m, "%14s: daemon priority\n", "none, no daemon");
 #endif
-	seq_printf(m, "%14u: #passes seen\n",
+
+	seq_printf(m, "\n");
+	seq_printf(m, "%14u: #passes\n",
 		rcu_stats.npasses);
-	seq_printf(m, "%14u: #batches seen\n",
+	seq_printf(m, "%14u: #passes resulting in end-of-batch\n",
 		rcu_stats.nbatches);
-	seq_printf(m, "%14u: #barriers seen\n",
+	seq_printf(m, "%14u: #passes not resulting in end-of-batch\n",
+		rcu_stats.npasses - rcu_stats.nbatches);
+	seq_printf(m, "%14u: #msecs since last end-of-batch\n",
+		msecs);
+	seq_printf(m, "%14u: #passes forced (0 is best)\n",
+		rcu_stats.nforced);
+
+	seq_printf(m, "\n");
+	seq_printf(m, "%14u: #barriers\n",
 		atomic_read(&rcu_stats.nbarriers));
 	seq_printf(m, "%14llu: #callbacks invoked\n",
 		rcu_stats.ninvoked);
 	seq_printf(m, "%14u: #callbacks left to invoke\n",
 		atomic_read(&rcu_stats.nleft));
-	seq_printf(m, "%14u: #msecs since last end-of-batch\n",
-		msecs);
-	seq_printf(m, "%14u: #passes forced (0 is best)\n",
-		rcu_stats.nforced);
 	seq_printf(m, "\n");
 
 	for_each_online_cpu(cpu)
