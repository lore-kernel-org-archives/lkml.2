Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0KSV6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:33 -0500
Received: from kroah.org ([198.145.64.141]:44998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932580Ab0KSV63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:29 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:40 2010
Message-Id: <20101119215640.067218264@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andre Przywara <andre.przywara@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [16/82] x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andre Przywara <andre.przywara@amd.com>

commit 7ef8aa72ab176e0288f363d1247079732c5d5792 upstream.

The AMD SSE5 feature set as-it has been replaced by some extensions
to the AVX instruction set. Thus the bit formerly advertised as SSE5
is re-used for one of these extensions (XOP).
Although this changes the /proc/cpuinfo output, it is not user visible, as
there are no CPUs (yet) having this feature.
To avoid confusion this should be added to the stable series, too.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
LKML-Reference: <1283778860-26843-2-git-send-email-andre.przywara@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kvm/x86.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -150,7 +150,7 @@
 #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
 #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
 #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1912,7 +1912,7 @@ static void do_cpuid_ent(struct kvm_cpui
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT */ | 0 /* WDT */;
 
 	/* all calls to cpuid_count() should be made on the same cpu */


