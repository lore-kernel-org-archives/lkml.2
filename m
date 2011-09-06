Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1IGGVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37671 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab1IGGUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:47 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 27/55] rcu: Allow rcutorture's stat_interval parameter to be changed at runtime
Date: Tue,  6 Sep 2011 11:00:21 -0700
Message-Id: <1315332049-2604-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-0000007117A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rcutorture is compiled directly into the kernel
(instead of separately as a module), it is necessary to specify
rcutorture.stat_interval as a kernel command-line parameter, otherwise,
the rcu_torture_stats kthread is never started.  However, when working
with the system after it has booted, it is convenient to be able to
change the time between statistic printing, particularly when logged
into the console.

This commit therefore allows the stat_interval parameter to be changed
at runtime.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 1194d6c..6648e00 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -73,7 +73,7 @@ module_param(nreaders, int, 0444);
 MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
 module_param(nfakewriters, int, 0444);
 MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-module_param(stat_interval, int, 0444);
+module_param(stat_interval, int, 0644);
 MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
 module_param(verbose, bool, 0444);
 MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
-- 
1.7.3.2

