Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1E3Dtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:40 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62360 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab1E3Dtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:39 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-25-4de313c98ee2
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 05/10] x86-64: Map the HPET NX
Date: Sun, 29 May 2011 23:48:42 -0400
Message-Id: <2a4f8df32c6a464cbc112cd501c7f81d558676a1.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsUixCmqrHtS+LGvwdktyhZz1q9hs+i7cpTd
	YtY1XovPG/6xWRz49ZTN4v3V7WwWl3fNYbN40nyd0WLLpWZWiw8TN7BZbN40ldniUd9bdosf
	Gx6zOvB6fG/tY/E4duYwo8ettj/MHjtn3WX32LxCy+P/yyNsHptWdbJ5vDt3jt3jxIzfLB7H
	zzh7fN4kF8AdxWWTkpqTWZZapG+XwJUxc/ZltoJWoYrGr5oNjA/4uxg5OCQETCQeT2DtYuQE
	MsUkLtxbz9bFyMUhJLCPUWLmlWZGCGcDo8TRG71sIFVCAs+YJE7cyQax2QRUJDqWPmACGSQi
	oC9x9TNYPbPAc2aJBw93gU0VFjCUOHqpjwnEZhFQldjTN58ZxOYVCJI4fPcZO8RmBYkrV+ax
	gNicAgYSJ+/cY4HYpS8x79ZbNlziExgFFjAyrGKUTcmt0s1NzMwpTk3WLU5OzMtLLdI11svN
	LNFLTSndxAiODkm+HYxfDyodYhTgYFTi4bUoeuQrxJpYVlyZe4hRkoNJSZT3keBjXyG+pPyU
	yozE4oz4otKc1OJDjBIczEoivOq/gMp5UxIrq1KL8mFS0hwsSuK8MyXVfYUE0hNLUrNTUwtS
	i2CyMhwcShK8YcAkICRYlJqeWpGWmVOCkGbi4AQZzgM0XB9kMW9xQWJucWY6RP4Uoy5H49od
	BxmFWPLy81KlxHltQAYJgBRllObBzYEltVeM4kBvCfNeEQKq4gEmRLhJr4CWMAEt6X33EGRJ
	SSJCSqqBMau5XOXj66P3QpnzGL/dq+6SENWfHOHtYT/Ldt0qy0OpxyZ+WrLKf+6bmwyPubYu
	FXztcc35RPKaLW2stdfvBnZt6pipoFtfxnBS+/y6qpZlk1LP687JmSSt+bTVbCP/4dZd+1Ns
	dU9O45kkd2yzgs/XiLUvGFytWNtW6C/907N7v6fC4pmldkosxRmJhlrMRcWJAB+GwxpFAwAA
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

