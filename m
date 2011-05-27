Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1E0Rj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:39:28 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54167 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab1E0RjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:39:16 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-8a-4ddfe1859a9b
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 5/5] x86-64: Map the HPET NX
Date: Fri, 27 May 2011 13:38:42 -0400
Message-Id: <33a9173b25eb5b688b0b078cc002dbbd343ae73c.1306517576.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsUixG6notv68L6vwfeVGhZ9V46yW1zeNYfN
	YsulZlaLzZumMlv82PCY1YHV41bbH2aPnbPusntsWtXJ5vHu3Dl2j8+b5AJYo7hsUlJzMstS
	i/TtErgyZs6+zFbQKlTR+FWzgfEBfxcjJ4eEgInExLOtjBC2mMSFe+vZuhi5OIQE9jFKbLiy
	hxHC2cAosX5RI1TmGZPE8ZVPmEFa2ARUJDqWPmACsUUE4iQaZv9mBbGZBRwkbj8+AjZWWEBH
	4tTP22wgNouAqsTrn//YQWxegSCJE7uWs0KsVpC4cmUeC4jNKWAgcf3vDrAaIQF9ie8X17Hh
	Ep/AKLCAkWEVo2xKbpVubmJmTnFqsm5xcmJeXmqRrpFebmaJXmpK6SZGUGhySvLuYHx3UOkQ
	owAHoxIPr8XB+75CrIllxZW5hxglOZiURHn9HgCF+JLyUyozEosz4otKc1KLDzFKcDArifCa
	7AfK8aYkVlalFuXDpKQ5WJTEeWdKqvsKCaQnlqRmp6YWpBbBZGU4OJQkeAWAMSgkWJSanlqR
	lplTgpBm4uAEGc4DNNwTpIa3uCAxtzgzHSJ/ilGXo3HtjoOMQix5+XmpUuK8T0GuEwApyijN
	g5sDSymvGMWB3hLmPQ5SxQNMR3CTXgEtYQJaovP7LsiSkkSElFQDI3PSTPUfpqbam+88NZu7
	VPaPwBTdRxrqR9ufcRY5pRaeOfLVeM3tzUvt2cvcMvabuebavnqQsuSy99r7yy6fDLGys9vL
	bKtzlD/9y+XXQq17Yn+vaM3gT9j4RL9uz86re7++skrLrbzZO3njrZTGm6Wupt/fi3wv2HZK
	Mv84Y0Wuw8L21xZPzJRYijMSDbWYi4oTAW0zdREEAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the HPET mapping is a user-accessible syscall instruction
at a fixed address some of the time.  A sufficiently determined
hacker might be able to guess when.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/pgtable_types.h |    4 ++--
 arch/x86/kernel/hpet.c               |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 6a29aed6..013286a 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -107,8 +107,8 @@
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
+#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -130,8 +130,8 @@
 #define PAGE_KERNEL_LARGE_NOCACHE	__pgprot(__PAGE_KERNEL_LARGE_NOCACHE)
 #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 #define PAGE_KERNEL_VVAR		__pgprot(__PAGE_KERNEL_VVAR)
+#define PAGE_KERNEL_VVAR_NOCACHE	__pgprot(__PAGE_KERNEL_VVAR_NOCACHE)
 
 #define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
 #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index bfe8f72..bf71830 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -71,7 +71,7 @@ static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
 #ifdef CONFIG_X86_64
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
 #endif
 }
 
-- 
1.7.5.1

