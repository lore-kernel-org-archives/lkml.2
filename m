Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2HCQiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:38:05 -0400
Received: from osrc3.amd.com ([217.9.48.20]:47863 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab2HCQiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:38:03 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/4] x86, CPU: Extend TLB size detection for AMD
Date: Fri,  3 Aug 2012 18:37:47 +0200
Message-Id: <1344011869-21868-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344011869-21868-1-git-send-email-bp@amd64.org>
References: <1344011869-21868-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

TLB characteristics on AMD are in the extended CPUID level, leafs
0x8000000{5,6} so we need to check those before doing the detection.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d239977f361f..ebab0e77e691 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -940,7 +940,8 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	if (boot_cpu_data.cpuid_level >= 2)
+	if (boot_cpu_data.cpuid_level >= 2 ||
+	    boot_cpu_data.extended_cpuid_level >= 0x80000006)
 		cpu_detect_tlb(&boot_cpu_data);
 }
 
-- 
1.7.11.rc1

