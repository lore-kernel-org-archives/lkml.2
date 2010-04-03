Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0DCB31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:29:27 -0400
Received: from sous-sol.org ([216.99.217.87]:45705 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755045Ab0DCB3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:29:02 -0400
Message-Id: <20100403012820.229410717@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 18:27:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: nhorman@tuxdriver.com, nhorman@redhat.com, vgoyal@redhat.com,
       hbabu@us.ibm.com, ebiederm@xmission.com,
       iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
Content-Disposition: inline; filename=crash-leave-iommu-enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This effectively reverts commit 61d047be99757fd9b0af900d7abce9a13a337488.

Disabling the IOMMU can potetially allow DMA transactions to
complete without being translated.  Leave it enabled, and allow
crash kernel to do the IOMMU reinitialization properly.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/crash.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,7 +27,6 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
-#include <asm/x86_init.h>
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -103,10 +102,5 @@ void native_machine_crash_shutdown(struc
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
-
-#ifdef CONFIG_X86_64
-	x86_platform.iommu_shutdown();
-#endif
-
 	crash_save_cpu(regs, safe_smp_processor_id());
 }

