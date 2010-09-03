Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0ICIGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:06:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40359 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0ICIG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:06:29 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L85VMH-01-HXJ-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 3/4] x86: Fix allowed CPUID bits for KVM guests
Date: Fri, 3 Sep 2010 10:03:07 +0200
Message-ID: <1283500988-32409-4-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1283500988-32409-1-git-send-email-andre.przywara@amd.com>
References: <1283500988-32409-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD extension to AVX (FMA4, XOP) work on the same YMM register set
as AVX, so they are safe for guests to use, as long as AVX itself
is allowed.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a09c62..eb89e7b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1996,8 +1996,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
-		0 /* SKINIT */ | 0 /* WDT */;
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
+		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
-- 
1.6.4


