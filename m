Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2LAA2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:28:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2LAA2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:28:35 -0500
Date: Fri, 30 Nov 2012 16:28:24 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-27f7c88afbdff536e65bbf1507ba63ce20eb0ba3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354240068-9821-9-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-9-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/smpboot.c: Early update ucode on AP
Git-Commit-ID: 27f7c88afbdff536e65bbf1507ba63ce20eb0ba3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:28:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f7c88afbdff536e65bbf1507ba63ce20eb0ba3
Gitweb:     http://git.kernel.org/tip/27f7c88afbdff536e65bbf1507ba63ce20eb0ba3
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 Nov 2012 17:47:46 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Nov 2012 15:18:16 -0800

x86/smpboot.c: Early update ucode on AP

This updates ucode on AP. At this point, BSP should store some valid ucode
patches in memory if it finds the ucode patches in initrd. AP searches the
stored ucode and uploads the ucode.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1354240068-9821-9-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..f616692 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -76,6 +76,7 @@
 #include <asm/i8259.h>
 
 #include <asm/realmode.h>
+#include <asm/microcode.h>
 
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
@@ -239,6 +240,12 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * most necessary things.
 	 */
 	cpu_init();
+	/*
+	 * Load microcode on this cpu if a valid microcode is available.
+	 * This is early microcode loading procedure.
+	 */
+	load_ucode_ap();
+
 	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
 	smp_callin();
