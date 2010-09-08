Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0IHV2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:28:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:54327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0IHV2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:28:07 -0400
Date: Wed, 8 Sep 2010 21:27:47 GMT
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283778860-26843-2-git-send-email-andre.przywara@amd.com>
References: <1283778860-26843-2-git-send-email-andre.przywara@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit
Message-ID: <tip-7ef8aa72ab176e0288f363d1247079732c5d5792@git.kernel.org>
Git-Commit-ID: 7ef8aa72ab176e0288f363d1247079732c5d5792
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 21:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ef8aa72ab176e0288f363d1247079732c5d5792
Gitweb:     http://git.kernel.org/tip/7ef8aa72ab176e0288f363d1247079732c5d5792
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Mon, 6 Sep 2010 15:14:17 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 8 Sep 2010 13:32:55 -0700

x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

The AMD SSE5 feature set as-it has been replaced by some extensions
to the AVX instruction set. Thus the bit formerly advertised as SSE5
is re-used for one of these extensions (XOP).
Although this changes the /proc/cpuinfo output, it is not user visible, as
there are no CPUs (yet) having this feature.
To avoid confusion this should be added to the stable series, too.

Cc: stable@kernel.org [.32.x .34.x, .35.x]
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
LKML-Reference: <1283778860-26843-2-git-send-email-andre.przywara@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kvm/x86.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 781a50b..c9c73d8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -152,7 +152,7 @@
 #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
 #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
 #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a09c62..dd54779 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1996,7 +1996,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT */ | 0 /* WDT */;
 
 	/* all calls to cpuid_count() should be made on the same cpu */
