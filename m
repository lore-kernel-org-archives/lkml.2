Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2HGDIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:08:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab2HGDIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:08:15 -0400
Date: Mon, 6 Aug 2012 20:07:57 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-a9ad773e0dd833651f0831020a0ea0265c29f2ea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com, borislav.petkov@amd.com
In-Reply-To: <1344272439-29080-2-git-send-email-bp@amd64.org>
References: <1344272439-29080-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, cpu: Fixup tlb_flushall_shift formatting
Git-Commit-ID: a9ad773e0dd833651f0831020a0ea0265c29f2ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 06 Aug 2012 20:08:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9ad773e0dd833651f0831020a0ea0265c29f2ea
Gitweb:     http://git.kernel.org/tip/a9ad773e0dd833651f0831020a0ea0265c29f2ea
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 6 Aug 2012 19:00:36 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 6 Aug 2012 19:18:09 -0700

x86, cpu: Fixup tlb_flushall_shift formatting

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
Link: http://lkml.kernel.org/r/1344272439-29080-2-git-send-email-bp@amd64.org
Acked-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 46d8786..d239977 100644
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
