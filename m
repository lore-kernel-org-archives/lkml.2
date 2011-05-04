Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1EDMTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:19:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44997 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1EDMTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:19:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softirq: constify name array
Date: Wed,  4 May 2011 08:23:04 -0400
Message-Id: <1304511784-24205-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/interrupt.h |    2 +-
 kernel/softirq.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index bea0ac7..74a98ad 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -422,7 +422,7 @@ enum
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
-extern char *softirq_to_name[NR_SOFTIRQS];
+extern const char * const softirq_to_name[NR_SOFTIRQS];
 
 /* softirq mask and active fields moved to irq_cpustat_t in
  * asm/hardirq.h to get better cache usage.  KAO
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 174f976..9d744a7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -56,7 +56,7 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 
 DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
-char *softirq_to_name[NR_SOFTIRQS] = {
+const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER",	"RCU"
 };
-- 
1.7.5.rc3

