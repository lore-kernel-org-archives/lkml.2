Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2LAAlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:41:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2LAAlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:41:05 -0500
Date: Fri, 30 Nov 2012 16:40:54 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-e3228cf4544355f73437a2b9c6916be9cbafc201@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354132230-21854-8-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-8-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal: Remove CONFIG_X86_POPAD_OK
Git-Commit-ID: e3228cf4544355f73437a2b9c6916be9cbafc201
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:40:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3228cf4544355f73437a2b9c6916be9cbafc201
Gitweb:     http://git.kernel.org/tip/e3228cf4544355f73437a2b9c6916be9cbafc201
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:29 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:23:03 -0800

x86, 386 removal: Remove CONFIG_X86_POPAD_OK

The check_popad() routine tested for a 386-specific bug, and never
actually did anything useful with it anyway other than print a
message.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-8-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig.cpu       |  4 ----
 arch/x86/kernel/cpu/bugs.c | 28 ----------------------------
 2 files changed, 32 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 159ee9c..423db71 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -325,10 +325,6 @@ config X86_INVD_BUG
 	def_bool y
 	depends on M486
 
-config X86_POPAD_OK
-	def_bool y
-	depends on X86_32
-
 config X86_ALIGNMENT_16
 	def_bool y
 	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0cd07cc..92dfec9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -107,33 +107,6 @@ static void __init check_hlt(void)
 }
 
 /*
- *	Most 386 processors have a bug where a POPAD can lock the
- *	machine even from user space.
- */
-
-static void __init check_popad(void)
-{
-#ifndef CONFIG_X86_POPAD_OK
-	int res, inp = (int) &res;
-
-	pr_info("Checking for popad bug... ");
-	__asm__ __volatile__(
-	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
-	  : "=&a" (res)
-	  : "d" (inp)
-	  : "ecx", "edi");
-	/*
-	 * If this fails, it means that any user program may lock the
-	 * CPU hard. Too bad.
-	 */
-	if (res != 12345678)
-		pr_cont("Buggy\n");
-	else
-		pr_cont("OK\n");
-#endif
-}
-
-/*
  * Check whether we are able to run this kernel safely on SMP.
  *
  * - i386 is no longer supported.
@@ -157,7 +130,6 @@ void __init check_bugs(void)
 #endif
 	check_config();
 	check_hlt();
-	check_popad();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
