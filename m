Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0IFNXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:23:23 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:10456 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0IFNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:23:14 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8BUAP-02-1H6-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 4/4] x86, kvm: add new AMD SVM feature bits
Date: Mon, 6 Sep 2010 15:14:20 +0200
Message-ID: <1283778860-26843-5-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1283778860-26843-1-git-send-email-andre.przywara@amd.com>
References: <1283778860-26843-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently updated CPUID specification names new SVM feature bits.
Add them to the list of reported features.

Signed-off-by: Andre Przywara <andre.przywara@amd,com>
---
 arch/x86/include/asm/cpufeature.h |    7 +++++++
 arch/x86/kernel/cpu/scattered.c   |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 341835d..bffeab7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -183,6 +183,13 @@
 #define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
 #define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
 #define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
+#define X86_FEATURE_TSCRATEMSR  (8*32+ 9) /* "tsc_scale" AMD TSC scaling support */
+#define X86_FEATURE_VMCBCLEAN   (8*32+10) /* "vmcb_clean" AMD VMCB clean bits support */
+#define X86_FEATURE_FLUSHBYASID (8*32+11) /* AMD flush-by-ASID support */
+#define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support */
+#define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept */
+#define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
+
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 34b4dad..2c77931 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -43,6 +43,12 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
 		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ X86_FEATURE_TSCRATEMSR,	CR_EDX, 4, 0x8000000a, 0 },
+		{ X86_FEATURE_VMCBCLEAN,	CR_EDX, 5, 0x8000000a, 0 },
+		{ X86_FEATURE_FLUSHBYASID,	CR_EDX, 6, 0x8000000a, 0 },
+		{ X86_FEATURE_DECODEASSISTS,	CR_EDX, 7, 0x8000000a, 0 },
+		{ X86_FEATURE_PAUSEFILTER,	CR_EDX,10, 0x8000000a, 0 },
+		{ X86_FEATURE_PFTHRESHOLD,	CR_EDX,12, 0x8000000a, 0 },
 		{ 0, 0, 0, 0, 0 }
 	};
 
-- 
1.6.4


