Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0DGMtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:49:42 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:14514
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932539Ab0DGMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJN-01-9UD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 08/12] Revert "x86: disable IOMMUs on kernel crash"
Date: Wed, 7 Apr 2010 14:46:45 +0200
Message-ID: <1270644409-10123-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0054 (UTC) FILETIME=[67CA9D60:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

This effectively reverts commit 61d047be99757fd9b0af900d7abce9a13a337488.

Disabling the IOMMU can potetially allow DMA transactions to
complete without being translated.  Leave it enabled, and allow
crash kernel to do the IOMMU reinitialization properly.

Cc: stable@kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/crash.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a4849c1..ebd4c51 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,7 +27,6 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
-#include <asm/x86_init.h>
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -103,10 +102,5 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
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
-- 
1.7.0.4


