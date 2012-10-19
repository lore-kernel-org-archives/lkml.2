Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2JSI6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:58:24 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:30989
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757365Ab2JSI6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:58:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839h93fhd25hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MC4U8Y-02-3D6-02
X-M-MSG: 
Date: Fri, 19 Oct 2012 10:58:13 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] x86: Add cpu_has_topoext
Message-ID: <20121019085813.GD26718@alberich>
References: <20121019085519.GC26718@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20121019085519.GC26718@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce cpu_has_topoext to check for AMD's CPUID topology extensions
support. It indicates support for
CPUID Fn8000_001D_EAX_x[N:0]-CPUID Fn8000_001E_EDX

See AMD's CPUID Specification, Publication # 25481
(as of Rev. 2.34 September 2010)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 +-
 arch/x86/kernel/smpboot.c         |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 16cae42..c13a1f4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -309,6 +309,7 @@ extern const char * const x86_power_flags[32];
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
-- 
1.7.8.6


