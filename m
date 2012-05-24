Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2EXPL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:11:58 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33624 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933124Ab2EXPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:11:55 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/2] smpboot,
 idle: Fix comment mismatch over idle_threads_init()
To: tglx@linutronix.de
Cc: suresh.b.siddha@intel.com, venki@google.com, nikunj@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 20:41:00 +0530
Message-ID: <20120524151100.2549.66501.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120524151055.2549.64309.stgit@srivatsabhat.in.ibm.com>
References: <20120524151055.2549.64309.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12052415-3864-0000-0000-0000030A7480
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment over idle_threads_init() really talks about the functionality
of idle_init(). Move that comment to idle_init(), and add a suitable
comment over idle_threads_init().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
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

