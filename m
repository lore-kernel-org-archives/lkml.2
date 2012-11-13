Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2KMWBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:01:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2KMWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:00:57 -0500
Date: Tue, 13 Nov 2012 14:00:45 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-2e8458dfe4202df75543402c7343b8f94de4101e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121019090049.GF26718@alberich>
References: <20121019090049.GF26718@alberich>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo:
  Make use of CPUID 0x8000001d for cache information on AMD
Git-Commit-ID: 2e8458dfe4202df75543402c7343b8f94de4101e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 14:00:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e8458dfe4202df75543402c7343b8f94de4101e
Gitweb:     http://git.kernel.org/tip/2e8458dfe4202df75543402c7343b8f94de4101e
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 19 Oct 2012 11:00:49 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Nov 2012 11:22:30 -0800

x86, cacheinfo: Make use of CPUID 0x8000001d for cache information on AMD

Rely on CPUID 0x8000001d for cache information when AMD CPUID topology
extensions are available.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20121019090049.GF26718@alberich
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
