Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2H3RBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:01:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2H3RBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:01:13 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=H10fWt6LTZgA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=HQP-ijWzaQ8Ki2nxAKMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: [ANNOUNCE] 3.2.28-rt42
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Aug 2012 13:00:44 -0400
Message-ID: <1346346044.3198.3.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.28-rt42 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 76992f6057bf6cf0005c93228a7e433ac2e780cc


Or to build 3.2.28-rt42 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.28.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.28-rt42.patch.xz


You can also build from 3.2.28-rt41 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.28-rt41-rt42.patch.xz



Enjoy,

-- Steve


Changes from 3.2.28-rt41:

---

Frank Rowand (1):
      fix printk flush of messages

Steven Rostedt (1):
      Linux 3.2.28-rt42

----
 kernel/printk.c |    2 +-
 localversion-rt |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
diff --git a/kernel/printk.c b/kernel/printk.c
index 9eabbbb..66e83e5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -836,7 +836,7 @@ static int console_trylock_for_printk(unsigned int cpu, unsigned long flags)
 	int retval = 0, wake = 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count()) || sysrq_in_progress;
+		(preempt_count() <= 1)) || sysrq_in_progress;
 #else
 	int lock = 1;
 #endif
diff --git a/localversion-rt b/localversion-rt
index 629e0b4..8bdfb9a 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt41
+-rt42


