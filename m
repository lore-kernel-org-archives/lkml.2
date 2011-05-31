Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1EaNQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:16:55 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:63737 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab1EaNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:16:53 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-a8-4de4ea04fb2f
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
Subject: [PATCH v3 05/10] x86-64: Map the HPET NX
Date: Tue, 31 May 2011 09:15:59 -0400
Message-Id: <751f0c7373a987339e4315afb3bc1b269f1f61c2.1306847455.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsUixCmqrMvy6omvwbuZPBZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZcycfZmtoFWoovGrZgPjA/4uRk4O
	CQETic+9E9khbDGJC/fWs3UxcnEICexjlHg87RwLhLOBUeLdp4dQmWdMEuu/XWIBaWETUJHo
	WPqAqYuRg0NEQF/i6mdGkBpmgUksEof/nmYBiQsLGEos3p0EUs4ioCrx6s1esG28AkESJ27u
	ZoLYrCBx5co8sJGcAgYSzSvXsIHYQkAj7z+5woxLfAKjwAJGhlWMsim5Vbq5iZk5xanJusXJ
	iXl5qUW6Rnq5mSV6qSmlmxjBMSPJu4Px3UGlQ4wCHIxKPLys+x/7CrEmlhVX5h5ilORgUhLl
	Pfvyia8QX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd5vfEA53pTEyqrUonyYlDQHi5I470xJdV8h
	gfTEktTs1NSC1CKYrAwHh5IE7wyQoYJFqempFWmZOSUIaSYOTpDhPEDDT4LU8BYXJOYWZ6ZD
	5E8x6nI0rt1xkFGIJS8/L1VKnHchSJEASFFGaR7cHFiqe8UoDvSWMG8/SBUPME3CTXoFtIQJ
	aEnvu4cgS0oSEVJSDYxbGnx1OVcvfzR/m/+PoIDaHZckO+wWsbjujxepenmpey6jSoPrHUW5
	b60H9aN2hjsz/v3c+GhvzconqlMaF4rm5Ogw3T5yecWuVzuS/qo1LeY+xKL6fpl1XeLpx60e
	Aq3a1S+X7/91yr3s6mnLeQt+9CxgZ9uWtidqm5Iz56RvHtM8rD594GdQYinOSDTUYi4qTgQA
	ACzwRFADAAA=
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

