Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2KMV7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:59:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2KMV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:59:00 -0500
Date: Tue, 13 Nov 2012 13:58:45 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-193f3fcb3ab769bab4a2b9fa181eef3e5699a352@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121019085813.GD26718@alberich>
References: <20121019085813.GD26718@alberich>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Add cpu_has_topoext
Git-Commit-ID: 193f3fcb3ab769bab4a2b9fa181eef3e5699a352
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 13:58:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  193f3fcb3ab769bab4a2b9fa181eef3e5699a352
Gitweb:     http://git.kernel.org/tip/193f3fcb3ab769bab4a2b9fa181eef3e5699a352
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 19 Oct 2012 10:58:13 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Nov 2012 11:22:28 -0800

x86: Add cpu_has_topoext

Introduce cpu_has_topoext to check for AMD's CPUID topology extensions
support. It indicates support for
CPUID Fn8000_001D_EAX_x[N:0]-CPUID Fn8000_001E_EDX

See AMD's CPUID Specification, Publication # 25481
(as of Rev. 2.34 September 2010)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20121019085813.GD26718@alberich
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 +-
 arch/x86/kernel/smpboot.c         |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..c22a492 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -311,6 +311,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
+#define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..64e9ad4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -304,7 +304,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 	int cpu = smp_processor_id();
 
 	/* get information required for multi-node processors */
-	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+	if (cpu_has_topoext) {
 		u32 eax, ebx, ecx, edx;
 
 		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..732bf5c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -313,7 +313,7 @@ do {									\
 
 static bool __cpuinit match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+	if (cpu_has_topoext) {
 		int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
 		if (c->phys_proc_id == o->phys_proc_id &&
