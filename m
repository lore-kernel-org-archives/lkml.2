Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab0IFNUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:20:03 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:51069 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0IFNUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:20:01 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L8BUAP-01-78N-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 3/4] x86: Fix allowed CPUID bits for KVM guests
Date: Mon, 6 Sep 2010 15:14:19 +0200
Message-ID: <1283778860-26843-4-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1283778860-26843-1-git-send-email-andre.przywara@amd.com>
References: <1283778860-26843-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD extensions to AVX (FMA4, XOP) work on the same YMM register set
as AVX, so they are safe for guests to use, as long as AVX itself
is allowed. Add F16C and AES on the way for the same reasons.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/kvm/x86.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd54779..6c2ecf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1991,13 +1991,14 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		0 /* Reserved */ | F(CX16) | 0 /* xTPR Update, PDCM */ |
 		0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
-		0 /* Reserved, AES */ | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX);
+		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
+		F(F16C);
 	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
 		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
-		0 /* SKINIT */ | 0 /* WDT */;
+		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
-- 
1.6.4


