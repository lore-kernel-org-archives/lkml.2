Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1EaOQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:16:55 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:47324 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab1EaOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:15:11 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-23-4de4f7f1ea05
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 05/10] x86-64: Map the HPET NX
Date: Tue, 31 May 2011 10:14:03 -0400
Message-Id: <3ad8e88fe9a91df8a4fbb26f3a1c21d59e35bae8.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsUixG6novvx+xNfgw8X1C3mrF/DZtF35Si7
	xZFr39ktZl3jtfi84R+bxYFfT9ks3l/dzmZxedccNosnzdcZLbZcama1+DBxA5vF5k1TmS0e
	9b1lt/ix4TGrA5/H99Y+Fo9jZw4zetxq+8PsMX/nR0aPnbPusntsXqHl8f/lETaPTas62Tze
	nTvH7nFixm8Wj+NnnD0+b5IL4InisklJzcksSy3St0vgyvj3ZwpbQatQxamT35gbGB/wdzFy
	ckgImEj0PutlhrDFJC7cW8/WxcjFISSwj1Hi+e8DjBDOBiDnw0Uo5xmTxIFLs5hAWtgEVCQ6
	lj4Asjk4RAT0Ja5+BqthFpjEInH472kWkBphAUOJV+dvg9WwCKhK3G5yATF5BYIkmh9ZQCxW
	kLhyZR5YNaeAgcT2q6sYQUqEgCYe/6CLQ3gCo8ACRoZVjLIpuVW6uYmZOcWpybrFyYl5ealF
	uiZ6uZkleqkppZsYQfHCKcm/g/HbQaVDjAIcjEo8vAkHH/sKsSaWFVfmHmKU5GBSEuWt+PbE
	V4gvKT+lMiOxOCO+qDQntfgQowQHs5II7zc+oBxvSmJlVWpRPkxKmoNFSZx3lqS6r5BAemJJ
	anZqakFqEUxWhoNDSYLXCJgWhASLUtNTK9Iyc0oQ0kwcnCDDeYCGF4Is5i0uSMwtzkyHyJ9i
	1OVoXLvjIKMQS15+XqqUOK8VyCABkKKM0jy4ObA094pRHOgtYV4FkCoeYIqEm/QKaAkT0JLe
	dw9BlpQkIqSkGhhzDp+ZeYjrWETFVpb8jcGzJ9lMcj0qcePQJYUZygHP5q/hlN75b2HAySkq
	Gxol+tKNXtz6+fSdQMYRhSlbDAVm3jiS//zs1EeSWv/ZJlhy9ZZ+vLlrIXv1NosJjF+sizcW
	lrN9a60/wKFZcuhow7Hg213mZ948s1t48NSkRye81snVPjOaeCehXomlOCPRUIu5qDgRABN6
	lt5OAwAA
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
index 6781765..e9f5605 100644
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

