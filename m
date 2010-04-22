Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0DVUBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:01:00 -0400
Received: from kroah.org ([198.145.64.141]:59814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab0DVUAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:49 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:12 2010
Message-Id: <20100422195412.402236486@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [075/139] Revert "x86: disable IOMMUs on kernel crash"
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 8f9f55e83e939724490d7cde3833c4883c6d1310 upstream.

This effectively reverts commit 61d047be99757fd9b0af900d7abce9a13a337488.

Disabling the IOMMU can potetially allow DMA transactions to
complete without being translated.  Leave it enabled, and allow
crash kernel to do the IOMMU reinitialization properly.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


