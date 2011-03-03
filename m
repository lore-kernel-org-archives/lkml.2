Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab1CCR1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:27:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58366 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758596Ab1CCR1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:27:10 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18hX281Ox8hy82h749UXoL/skCdKfy7TZhhxt99Yk
	E7foJ5S6adA0mt
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: richard.cochran@omicron.at, johnstul@us.ibm.com, tglx@linutronix.de,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 1/3] remove __cpuinit from mwait_usable()
Date: Thu,  3 Mar 2011 18:26:12 +0100
Message-Id: <1299173174-348-2-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299173174-348-1-git-send-email-torbenh@gmx.de>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mwait_usable() is used by native_play_dead()
which is not __cpuinit.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/cpu.h |    2 +-
 arch/x86/kernel/process.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 6e6e755..4564c8e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
+int mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e764fc0..3c189e9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -506,7 +506,7 @@ static void poll_idle(void)
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
-- 
1.7.2.3

