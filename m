Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab0JVT0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:26:33 -0400
Received: from kroah.org ([198.145.64.141]:33844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066Ab0JVSzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:27 2010
Message-Id: <20101022185227.373997042@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [001/103] x86, cpu: After uncapping CPUID, re-run CPU feature detection
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

commit d900329e20f4476db6461752accebcf7935a8055 upstream.

After uncapping the CPUID level, we need to also re-run the CPU
feature detection code.

This resolves kernel bugzilla 16322.

Reported-by: boris64 <bugzilla.kernel.org@boris64.net>
LKML-Reference: <tip-@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/cpu/cpu.h    |    1 +
 arch/x86/kernel/cpu/intel.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -537,7 +537,7 @@ void __cpuinit cpu_detect(struct cpuinfo
 	}
 }
 
-static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	u32 ebx;
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -33,5 +33,6 @@ extern const struct cpu_dev *const __x86
 			    *const __x86_cpu_dev_end[];
 
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void get_cpu_cap(struct cpuinfo_x86 *c);
 
 #endif
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -39,6 +39,7 @@ static void __cpuinit early_init_intel(s
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 			c->cpuid_level = cpuid_eax(0);
+			get_cpu_cap(c);
 		}
 	}
 


