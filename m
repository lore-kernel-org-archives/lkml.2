Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2JSJA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:00:56 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:38847
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908Ab2JSJAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:00:54 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839h93fhd25hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MC4UD9-02-3HJ-02
X-M-MSG: 
Date: Fri, 19 Oct 2012 11:00:49 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86, cacheinfo: Make use of CPUID 0x8000001d for cache
 information on AMD
Message-ID: <20121019090049.GF26718@alberich>
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


Rely on CPUID 0x8000001d for cache information when AMD CPUID topology
extensions are available.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 8ce7a83..cd2e1cc 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -538,7 +538,11 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	unsigned		edx;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		amd_cpuid4(index, &eax, &ebx, &ecx);
+		if (cpu_has_topoext)
+			cpuid_count(0x8000001d, index, &eax.full,
+				    &ebx.full, &ecx.full, &edx);
+		else
+			amd_cpuid4(index, &eax, &ebx, &ecx);
 		amd_init_l3_cache(this_leaf, index);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
-- 
1.7.8.6


