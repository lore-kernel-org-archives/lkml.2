Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0KKRIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:08:21 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:58689 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab0KKRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:18 -0500
Message-Id: <20101111170814.601425734@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:55 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][PATCH v2 3/7] taskstats: Add thread group ID to taskstats structure
References: <20101111170352.732381138@linux.vnet.ibm.com>
Content-Disposition: inline; filename=03-taskstats-top-add-tgid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The tgid is important for aggregating threads in user space. Therefore we
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

