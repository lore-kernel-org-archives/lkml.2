Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2H3SZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:25:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2H3SZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:25:07 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=_ox6tvxmq8gA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=D3aU2I4SVa85xYqhKykA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: [ANNOUNCE] 3.0.41-rt62
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Aug 2012 14:24:57 -0400
Message-ID: <1346351097.3198.5.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.41-rt62 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 27770766f5425b466d3a61025350f9829840e5e9


Or to build 3.0.41-rt62 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.41.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.41-rt62.patch.xz


You can also build from 3.0.41-rt61 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.41-rt61-rt62.patch.xz



Enjoy,

-- Steve


Changes from 3.0.41-rt61:

---

Frank Rowand (1):
      fix printk flush of messages

Steven Rostedt (1):
      Linux 3.0.41-rt62

----
 kernel/printk.c |    2 +-
 localversion-rt |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
diff --git a/kernel/printk.c b/kernel/printk.c
index 60f4290..f2c459f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -835,7 +835,7 @@ static int console_trylock_for_printk(unsigned int cpu, unsigned long flags)
 {
 #ifdef CONFIG_PREEMPT_RT_FULL
 	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count()) || sysrq_in_progress;
+		(preempt_count() <= 1)) || sysrq_in_progress;
 #else
 	int lock = 1;
 #endif
diff --git a/localversion-rt b/localversion-rt
index 9b7de93..40d81d8 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt61
+-rt62


