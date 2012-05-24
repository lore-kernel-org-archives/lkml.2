Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2EXVGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:06:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2EXVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:06:29 -0400
Date: Thu, 24 May 2012 14:05:20 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-4a70d2d9909b43ed88043b98cabe2c7fbd563021@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <20120524151100.2549.66501.stgit@srivatsabhat.in.ibm.com>
References: <20120524151100.2549.66501.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smpboot, idle:
  Fix comment mismatch over idle_threads_init()
Git-Commit-ID: 4a70d2d9909b43ed88043b98cabe2c7fbd563021
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 14:05:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a70d2d9909b43ed88043b98cabe2c7fbd563021
Gitweb:     http://git.kernel.org/tip/4a70d2d9909b43ed88043b98cabe2c7fbd563021
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Thu, 24 May 2012 20:41:00 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 May 2012 22:58:08 +0200

smpboot, idle: Fix comment mismatch over idle_threads_init()

The comment over idle_threads_init() really talks about the functionality
of idle_init(). Move that comment to idle_init(), and add a suitable
comment over idle_threads_init().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: suresh.b.siddha@intel.com
Cc: venki@google.com
Cc: nikunj@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/20120524151100.2549.66501.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/smpboot.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 0f2162f..98f60c5 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -31,6 +31,12 @@ void __init idle_thread_set_boot_cpu(void)
 	per_cpu(idle_threads, smp_processor_id()) = current;
 }
 
+/**
+ * idle_init - Initialize the idle thread for a cpu
+ * @cpu:	The cpu for which the idle thread should be initialized
+ *
+ * Creates the thread if it does not exist.
+ */
 static inline void idle_init(unsigned int cpu)
 {
 	struct task_struct *tsk = per_cpu(idle_threads, cpu);
@@ -45,10 +51,7 @@ static inline void idle_init(unsigned int cpu)
 }
 
 /**
- * idle_thread_init - Initialize the idle thread for a cpu
- * @cpu:	The cpu for which the idle thread should be initialized
- *
- * Creates the thread if it does not exist.
+ * idle_threads_init - Initialize idle threads for all cpus
  */
 void __init idle_threads_init(void)
 {
