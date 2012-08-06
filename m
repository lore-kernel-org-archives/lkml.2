Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2HFRBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:01:11 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57557 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab2HFRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:00:43 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v1 1/4] x86, CPU: Fixup tlb_flushall_shift formatting
Date: Mon,  6 Aug 2012 19:00:36 +0200
Message-Id: <1344272439-29080-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344272439-29080-1-git-send-email-bp@amd64.org>
References: <1344272439-29080-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The TLB characteristics appeared like this in dmesg:

[    0.065817] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.065817] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.065817] tlb_flushall_shift is 0xffffffff

where tlb_flushall_shift is actually -1 but dumped as a hex number.
However, the Kconfig option CONFIG_DEBUG_TLBFLUSH and the rest of the
code treats this as a signed decimal and states "If you set it to -1,
the code flushes the whole TLB unconditionally."

So, fix its formatting in accordance with the other references to it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kernel/cpu/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 46d8786d655e..d239977f361f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -474,7 +474,7 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 
 	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
 		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n"	     \
-		"tlb_flushall_shift is 0x%x\n",
+		"tlb_flushall_shift: %d\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
 		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
-- 
1.7.11.rc1

