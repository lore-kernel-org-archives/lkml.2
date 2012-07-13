Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030839Ab2GMSEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:04:02 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:39207 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab2GMSEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:04:00 -0400
Subject: [PATCH] x86, amd: rename vmmu support capability
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 13 Jul 2012 20:02:55 +0200
Message-ID: <1342202575.2706.4.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

AMD has renamed nested page table technology to rapid virtualization indexing,
reflect this change in the kernel.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/scattered.c   |    2 +-
 arch/x86/kvm/svm.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f91e80f..a6fa778 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -185,7 +185,7 @@
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
-#define X86_FEATURE_NPT		(8*32+ 5) /* AMD Nested Page Table support */
+#define X86_FEATURE_RVI		(8*32+ 5) /* AMD Rapid Virtualization Indexing support */
 #define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
 #define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
 #define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index ee8e9ab..78ec9e6 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -41,7 +41,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
-		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
+		{ X86_FEATURE_RVI,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
 		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f75af40..6863898 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -900,7 +900,7 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_NPT))
+	if (!boot_cpu_has(X86_FEATURE_RVI))
 		npt_enabled = false;
 
 	if (npt_enabled && !npt) {
-- 
1.7.4.1



