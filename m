Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab0FBS3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:29:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:38338 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0FBS3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:29:11 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L3EGO4-02-OMX-02
X-M-MSG: 
Date: Wed, 2 Jun 2010 20:29:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [PATCH] x86, AMD: Extend support to future families
Message-ID: <20100602182921.GA21557@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend support to future families, and in particular:

* extend direct mapping split of Tseg SMM area.
* extend K8 flavored alternatives (NOPS).
* rep movs* prefix is fast in ucode.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..12b9cff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -466,7 +466,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 
 	}
-	if (c->x86 == 0x10 || c->x86 == 0x11)
+	if (c->x86 >= 0x10)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
 	/* get apicid instead of initial apic id from cpuid */
@@ -529,7 +529,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			num_cache_leaves = 3;
 	}
 
-	if (c->x86 >= 0xf && c->x86 <= 0x11)
+	if (c->x86 >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_K8);
 
 	if (cpu_has_xmm2) {
@@ -546,7 +546,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		fam10h_check_enable_mmcfg();
 	}
 
-	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
+	if (c == &boot_cpu_data && c->x86 >= 0xf) {
 		unsigned long long tseg;
 
 		/*
-- 
1.6.4.4


-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

