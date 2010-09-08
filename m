Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0IHV2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:28:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:54357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab0IHV2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:28:48 -0400
Date: Wed, 8 Sep 2010 21:28:28 GMT
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        avi@redhat.com
In-Reply-To: <1283778860-26843-4-git-send-email-andre.przywara@amd.com>
References: <1283778860-26843-4-git-send-email-andre.przywara@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Fix allowed CPUID bits for KVM guests
Message-ID: <tip-6d886fd042634c0d3312bace63a5d0c541b721dc@git.kernel.org>
Git-Commit-ID: 6d886fd042634c0d3312bace63a5d0c541b721dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 21:28:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d886fd042634c0d3312bace63a5d0c541b721dc
Gitweb:     http://git.kernel.org/tip/6d886fd042634c0d3312bace63a5d0c541b721dc
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Mon, 6 Sep 2010 15:14:19 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 8 Sep 2010 13:34:15 -0700

x86, cpu: Fix allowed CPUID bits for KVM guests

The AMD extensions to AVX (FMA4, XOP) work on the same YMM register set
as AVX, so they are safe for guests to use, as long as AVX itself
is allowed. Add F16C and AES on the way for the same reasons.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
LKML-Reference: <1283778860-26843-4-git-send-email-andre.przywara@amd.com>
Acked-by: Avi Kivity <avi@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
