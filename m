Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0LFTzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:55:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:43511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab0LFTzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:55:10 -0500
Date: Mon, 6 Dec 2010 19:54:52 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <1291348298-21263-1-git-send-email-feng.tang@intel.com>
References: <1291348298-21263-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, earlyprintk: Move mrst early console to platform/ and fix a typo
Message-ID: <tip-991cfffa7c19aa648546aff666595af896e568ba@git.kernel.org>
Git-Commit-ID: 991cfffa7c19aa648546aff666595af896e568ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 19:54:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  991cfffa7c19aa648546aff666595af896e568ba
Gitweb:     http://git.kernel.org/tip/991cfffa7c19aa648546aff666595af896e568ba
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 3 Dec 2010 11:51:37 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 6 Dec 2010 20:52:04 +0100

x86, earlyprintk: Move mrst early console to platform/ and fix a typo

Move the code to arch/x86/platform/mrst/. Also fix a typo to use
the correct config option: ONFIG_EARLY_PRINTK_MRST

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: alan@linux.intel.com
LKML-Reference: <1291348298-21263-1-git-send-email-feng.tang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/Makefile                           |    1 -
 arch/x86/kernel/early_printk.c                     |    3 +--
 arch/x86/platform/mrst/Makefile                    |    1 +
 .../{kernel => platform/mrst}/early_printk_mrst.c  |    0
 4 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9e13763..f60153d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -84,7 +84,6 @@ obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 4572f25..cd28a35 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -240,7 +240,7 @@ static int __init setup_early_printk(char *buf)
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
 #endif
-#ifdef CONFIG_X86_MRST_EARLY_PRINTK
+#ifdef CONFIG_EARLY_PRINTK_MRST
 		if (!strncmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
@@ -250,7 +250,6 @@ static int __init setup_early_printk(char *buf)
 			hsu_early_console_init();
 			early_console_register(&early_hsu_console, keep);
 		}
-
 #endif
 		buf++;
 	}
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index 4d3e256..f61ccdd 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 obj-$(CONFIG_X86_MRST)		+= vrtc.o
+obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
diff --git a/arch/x86/kernel/early_printk_mrst.c b/arch/x86/platform/mrst/early_printk_mrst.c
similarity index 100%
rename from arch/x86/kernel/early_printk_mrst.c
rename to arch/x86/platform/mrst/early_printk_mrst.c
