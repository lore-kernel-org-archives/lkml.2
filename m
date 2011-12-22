Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1LVRzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:55:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1LVRzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:55:21 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org
Subject: [PATCH] X86: Introduce HW-Pstate scattered cpuid feature
Date: Thu, 22 Dec 2011 18:55:16 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <4EF27517.6010609@zytor.com> <20111222001441.GB10955@alboin.amr.corp.intel.com>
In-Reply-To: <20111222001441.GB10955@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112221855.17243.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 22, 2011 01:14:41 AM Andi Kleen wrote:
> > So this should be:
> > 
> > 1. added to the scattered CPUID features list;
> > 2. artificially set in the AMD-specific initialization code for the
> > older CPUs.
> 
> Not sure (2) is correct. As far as I understand it's actually different
> mechanisms, just implemented by the same driver.
> 
> Keeping the list for old CPUs is not a big issue anyways.
> 
> Agreed with (1)

This would be the hw-pstate feature patch to avoid
mainting families for autoloading, etc.

It should be in powernow-k8 then:
        /* IO-Based switching */
        { X86_VENDOR_AMD, 0xf, },
        /* Future models support MSR based switching and a cpuid bit for it */
        { X86_VENDOR_AMD, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_HW_PSTATE },

Something does not work and I need to re-test and dig.
I'll embed this one into the others from Andi and will resend the next days.

    Thomas

---
X86: Introduce HW-Pstate scattered cpuid feature

It is rather similar to CPB (boot capability) feature
and exists since fam10h (can be looked up in AMD's BKDG).

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/scattered.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f3444f7..7a1003d 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -176,6 +176,7 @@
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
 #define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index c7f64e6..addf9e8 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -40,6 +40,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
+		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
 		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
