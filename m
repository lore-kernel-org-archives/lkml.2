Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0ITOFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:05:42 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57135 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab0ITOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:05:41 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2cKzz1202hzz8275bh15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L91TSU-02-9FQ-02
X-M-MSG: 
Date: Mon, 20 Sep 2010 16:05:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [PATCH 1/2] x86, cpuid: Unbreak CPB CPUID feature
Message-ID: <20100920140521.GA4823@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5958f1d5d722df7a9e5d129676614a8e5219bacd added mistakenly the CPB bit to
the common scattered CPUID features. Move it to AMD-only code where it
belongs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c       |    5 +++++
 arch/x86/kernel/cpu/scattered.c |    1 -
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..7c7b798 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -565,6 +565,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	if (c->extended_cpuid_level >= 0x80000007) {
+		if (cpuid_edx(0x80000007) & BIT(9))
+			set_cpu_cap(c, X86_FEATURE_CPB);
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 34b4dad..fd5654a 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -38,7 +38,6 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
-		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

