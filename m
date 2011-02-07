Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1BGPEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:04:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab1BGPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:04:07 -0500
Date: Mon, 7 Feb 2011 16:03:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20110207150347.GA18589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, nx: Mark the ACPI resume trampoline code as +x


 arch/x86/kernel/acpi/sleep.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 4d9ebba..68d1537 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -12,10 +12,8 @@
 #include <linux/cpumask.h>
 #include <asm/segment.h>
 #include <asm/desc.h>
-
-#ifdef CONFIG_X86_32
 #include <asm/pgtable.h>
-#endif
+#include <asm/cacheflush.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -149,6 +147,15 @@ void __init acpi_reserve_wakeup_memory(void)
 	memblock_x86_reserve_range(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
 }
 
+int __init acpi_configure_wakeup_memory(void)
+{
+	if (acpi_realmode)
+		set_memory_x(acpi_realmode, WAKEUP_SIZE >> PAGE_SHIFT);
+
+	return 0;
+}
+arch_initcall(acpi_configure_wakeup_memory);
+
 
 static int __init acpi_sleep_setup(char *str)
 {
