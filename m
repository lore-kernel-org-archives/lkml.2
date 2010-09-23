Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0IWOBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:01:50 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:42847 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab0IWOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:01:48 -0400
Subject: [RFC][PATCH 06/10] taskstats: Add thread group ID to taskstats
 structure
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 16:01:39 +0200
Message-ID: <1285250499.1837.90.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Add thread group ID to taskstats structure

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The tgit is important for aggregating threads in user space. Therefore
we
add the tgid to the taskstats structure.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/taskstats.h |    1 +
 kernel/tsacct.c           |    1 +
 2 files changed, 2 insertions(+)

--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -167,6 +167,7 @@ struct taskstats {
 
 	/* Timestamp where data has been collected in ns since boot time */
 	__u64	time_ns;
+	__u32	ac_tgid;		/* Thread group ID */
 };
 
 
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -56,6 +56,7 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
 	stats->ac_pid	 = tsk->pid;
+	stats->ac_tgid	 = tsk->tgid;
 	rcu_read_lock();
 	tcred = __task_cred(tsk);
 	stats->ac_uid	 = tcred->uid;


