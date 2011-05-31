Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1EaNRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:17:19 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:59893 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab1EaNRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:17:16 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-dd-4de4ea51079c
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
Subject: [PATCH v3 06/10] x86-64: Remove vsyscall number 3 (venosys)
Date: Tue, 31 May 2011 09:16:00 -0400
Message-Id: <07002dbeb9f330619666b1c6bb54fa62cd2ee96e.1306847455.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsUixG6nrhv46omvwd0HPBZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZWy4PoG9YA9nxfpXk9kaGF+zdzFy
	ckgImEjcX3aZGcIWk7hwbz0biC0ksI9R4sZ9li5GLiB7A6PExAs3mSCcZ0wSTe0bwarYBFQk
	OpY+AEpwcIgI6Etc/cwIUsMsMIlF4vDf0ywgNcICLhIdf2eBbWMRUJXY0/ULbBuvQJDEw53X
	GSE2K0hcuTIPrJ5TwECieeUaqCv0Je4/ucKMS3wCo8ACRoZVjLIpuVW6uYmZOcWpybrFyYl5
	ealFusZ6uZkleqkppZsYQVHDKcm3g/HrQaVDjAIcjEo8vPEHH/sKsSaWFVfmHmKU5GBSEuWV
	efnEV4gvKT+lMiOxOCO+qDQntfgQowQHs5II7zc+oBxvSmJlVWpRPkxKmoNFSZx3pqS6r5BA
	emJJanZqakFqEUxWhoNDSYJ3BshQwaLU9NSKtMycEoQ0EwcnyHAeoOGhIDW8xQWJucWZ6RD5
	U4y6HI1rdxxkFGLJy89LlRLnzQIpEgApyijNg5sDS3avGMWB3hLm7Qep4gEmSrhJr4CWMAEt
	6X33EGRJSSJCSqqBsd7G1CnI3mmmos7myX9i3k6aKej44M+jC4Iq7Ru4ij9qXX2rOPFeQa9N
	yos93cvktN9vXvumLcjt4OPppVOnaRfpRkrm3io43u3A8DnqxgID5SmzL570CdCsU7y+QOBu
	sYlGlp/25rCbD2RC7kbf3u3mXhrWYNQxO36ytVlpHXto/8yM8ANTlViKMxINtZiLihMBpWep
	0FEDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It just segfaults since April 2008 (a4928cff), so I'm pretty sure
that nothing uses it.  And having an empty section makes the linker
script a bit fragile.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |    4 ----
 arch/x86/kernel/vsyscall_64.c |    3 ---
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3c1ec1c..1583238 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -182,10 +182,6 @@ SECTIONS
 		*(.vsyscall_2)
 	}
 
-	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
-	}
-
 	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3e8dac7..2907197 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -209,9 +209,6 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	return 0;
 }
 
-static long __vsyscall(3) venosys_1(void)
-{
-	return -ENOSYS;
 }
 
 /* Assume __initcall executes before all user space. Hopefully kmod
-- 
1.7.5.1

