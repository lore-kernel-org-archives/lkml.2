Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2D1JFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:05:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2D1JFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:05:18 -0400
Date: Sat, 28 Apr 2012 02:04:13 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-38498a67aa2cf8c80754b8d304bfacc10bc582b5@git.kernel.org>
Cc: mingo@kernel.org, jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        schwidefsky@de.ibm.com, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        vapier@gentoo.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, richard@nod.at, lethal@linux-sh.org,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, jejb@parisc-linux.org,
        takata@linux-m32r.org, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        peterz@infradead.org, schwidefsky@de.ibm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, linux@arm.linux.org.uk, ralf@linux-mips.org,
        vapier@gentoo.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, richard@nod.at, lethal@linux-sh.org,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        benh@kernel.crashing.org, jejb@parisc-linux.org, mattst88@gmail.com,
        takata@linux-m32r.org, rkuo@codeaurora.org
In-Reply-To: <20120420124557.035417523@linutronix.de>
References: <20120420124557.035417523@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smp: Add generic smpboot facility
Git-Commit-ID: 38498a67aa2cf8c80754b8d304bfacc10bc582b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:04:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38498a67aa2cf8c80754b8d304bfacc10bc582b5
Gitweb:     http://git.kernel.org/tip/38498a67aa2cf8c80754b8d304bfacc10bc582b5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:09 +0200

smp: Add generic smpboot facility

Start a new file, which will hold SMP and CPU hotplug related generic
infrastructure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20120420124557.035417523@linutronix.de

---
 kernel/Makefile  |    1 +
 kernel/cpu.c     |    8 ++++++++
 kernel/smpboot.c |   14 ++++++++++++++
 kernel/smpboot.h |    6 ++++++
 4 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index cb41b95..6c07f30 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
+obj-$(CONFIG_SMP) += smpboot.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e711aef..e58b99a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -17,6 +17,8 @@
 #include <linux/gfp.h>
 #include <linux/suspend.h>
 
+#include "smpboot.h"
+
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
@@ -300,6 +302,11 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
+
+	ret = smpboot_prepare(cpu);
+	if (ret)
+		goto out;
+
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
@@ -320,6 +327,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 out_notify:
 	if (ret != 0)
 		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
+out:
 	cpu_hotplug_done();
 
 	return ret;
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
new file mode 100644
index 0000000..6dae6a3
--- /dev/null
+++ b/kernel/smpboot.c
@@ -0,0 +1,14 @@
+/*
+ * Common SMP CPU bringup/teardown functions
+ */
+#include <linux/init.h>
+
+#include "smpboot.h"
+
+/**
+ * smpboot_prepare - generic smpboot preparation
+ */
+int __cpuinit smpboot_prepare(unsigned int cpu)
+{
+	return 0;
+}
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
new file mode 100644
index 0000000..d88e771
--- /dev/null
+++ b/kernel/smpboot.h
@@ -0,0 +1,6 @@
+#ifndef SMPBOOT_H
+#define SMPBOOT_H
+
+int smpboot_prepare(unsigned int cpu);
+
+#endif
