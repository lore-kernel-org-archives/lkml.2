Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1ABHYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:36123 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1ABHYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 159/260] x86, cpu: After uncapping CPUID, re-run CPU feature detection
Date: Sun,  2 Jan 2011 02:17:35 -0500
Message-Id: <1293952756-15010-160-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:04.0759 (UTC) FILETIME=[E55ECC70:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@linux.intel.com>

commit d900329e20f4476db6461752accebcf7935a8055 upstream.

After uncapping the CPUID level, we need to also re-run the CPU
feature detection code.

This resolves kernel bugzilla 16322.

Reported-by: boris64 <bugzilla.kernel.org@boris64.net>
LKML-Reference: <tip-@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/cpu/cpu.h    |    1 +
 arch/x86/kernel/cpu/intel.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..c4329af 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -537,7 +537,7 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	u32 ebx;
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 3624e8a..f668bb1 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -33,5 +33,6 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void get_cpu_cap(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1366c7c..e546d54 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -40,6 +40,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 			c->cpuid_level = cpuid_eax(0);
+			get_cpu_cap(c);
 		}
 	}
 
-- 
1.7.3.3

