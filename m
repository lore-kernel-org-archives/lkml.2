Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2EESwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:52:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2EESv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:51:59 -0400
Date: Sat, 5 May 2012 11:49:24 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-a4a2eb490e38aaff61eafcb8cde6725ad1be22ab@git.kernel.org>
Cc: mingo@kernel.org, jesper.nilsson@axis.com, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, chris@zankel.net, hskinnemoen@gmail.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, monstr@monstr.eu,
        vapier@gentoo.org, heiko.carstens@de.ibm.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        richard@nod.at, lethal@linux-sh.org, msalter@redhat.com,
        davem@davemloft.net, liqin.chen@sunplusct.com, dhowells@redhat.com,
        benh@kernel.crashing.org, geert@linux-m68k.org, mattst88@gmail.com,
        jejb@parisc-linux.org, takata@linux-m32r.org, jonas@southpole.se,
        ysato@users.sourceforge.jp, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, jesper.nilsson@axis.com, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, chris@zankel.net, hskinnemoen@gmail.com,
        monstr@monstr.eu, linux@arm.linux.org.uk, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, vapier@gentoo.org, tglx@linutronix.de,
        gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org, hpa@zytor.com,
        richard@nod.at, lethal@linux-sh.org, msalter@redhat.com,
        davem@davemloft.net, liqin.chen@sunplusct.com, geert@linux-m68k.org,
        benh@kernel.crashing.org, dhowells@redhat.com, jejb@parisc-linux.org,
        mattst88@gmail.com, jonas@southpole.se, takata@linux-m32r.org,
        ysato@users.sourceforge.jp, rkuo@codeaurora.org
In-Reply-To: <20120503085034.092585287@linutronix.de>
References: <20120503085034.092585287@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] init_task: Create generic init_task instance
Git-Commit-ID: a4a2eb490e38aaff61eafcb8cde6725ad1be22ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:49:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4a2eb490e38aaff61eafcb8cde6725ad1be22ab
Gitweb:     http://git.kernel.org/tip/a4a2eb490e38aaff61eafcb8cde6725ad1be22ab
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:21 +0200

init_task: Create generic init_task instance

All archs define init_task in the same way (except ia64, but there is
no particular reason why ia64 cannot use the common version). Create a
generic instance so all archs can be converted over.

The config switch is temporary and will be removed when all archs are
converted over.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Link: http://lkml.kernel.org/r/20120503085034.092585287@linutronix.de
---
 arch/Kconfig                            |    3 +++
 init/Makefile                           |    1 +
 {arch/alpha/kernel => init}/init_task.c |   17 ++++++++++++-----
 kernel/sched/Makefile                   |    2 --
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4f0d0f7..2dd8fdd 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -148,6 +148,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config HAVE_GENERIC_INIT_TASK
+       bool
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
diff --git a/init/Makefile b/init/Makefile
index 0bf677a..c55eac9 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -9,6 +9,7 @@ else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
+obj-$(CONFIG_HAVE_GENERIC_INIT_TASK) += init_task.o
 
 mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
diff --git a/arch/alpha/kernel/init_task.c b/init/init_task.c
similarity index 73%
copy from arch/alpha/kernel/init_task.c
copy to init/init_task.c
index 6f80ca4..8b2f399 100644
--- a/arch/alpha/kernel/init_task.c
+++ b/init/init_task.c
@@ -1,17 +1,24 @@
-#include <linux/mm.h>
-#include <linux/module.h>
+#include <linux/init_task.h>
+#include <linux/export.h>
+#include <linux/mqueue.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/init_task.h>
 #include <linux/fs.h>
-#include <linux/mqueue.h>
-#include <asm/uaccess.h>
+#include <linux/mm.h>
 
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+
+/* Initial task structure */
 struct task_struct init_task = INIT_TASK(init_task);
 EXPORT_SYMBOL(init_task);
 
+/*
+ * Initial thread structure. Alignment of this is handled by a special
+ * linker map entry.
+ */
 union thread_union init_thread_union __init_task_data =
 	{ INIT_THREAD_INFO(init_task) };
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 9a7dd35..173ea52 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -16,5 +16,3 @@ obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
-
-
