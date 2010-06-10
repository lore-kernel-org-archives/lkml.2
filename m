Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0FJAKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:10:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0FJAKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:10:47 -0400
Date: Thu, 10 Jun 2010 00:10:25 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <20100602182921.GA21557@aftab>
References: <20100602182921.GA21557@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD: Extend support to future families
Message-ID: <tip-12d8a961289644d265d8b3e88201878837c3b814@git.kernel.org>
Git-Commit-ID: 12d8a961289644d265d8b3e88201878837c3b814
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 00:10:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12d8a961289644d265d8b3e88201878837c3b814
Gitweb:     http://git.kernel.org/tip/12d8a961289644d265d8b3e88201878837c3b814
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 2 Jun 2010 20:29:21 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 Jun 2010 15:57:47 -0700

x86, AMD: Extend support to future families

Extend support to future families, and in particular:

* extend direct mapping split of Tseg SMM area.
* extend K8 flavored alternatives (NOPS).
* rep movs* prefix is fast in ucode.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100602182921.GA21557@aftab>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
