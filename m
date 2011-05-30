Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1E3Dts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:48 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:61386 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982Ab1E3Dtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:43 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-9b-4de313d97238
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
Subject: [PATCH v2 06/10] x86-64: Remove vsyscall number 3 (venosys)
Date: Sun, 29 May 2011 23:48:43 -0400
Message-Id: <907b5b70ed731ff5d40c65a2377c73ac2858223c.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsUixG6nontT+LGvwbMlBhZz1q9hs+i7cpTd
	YtY1XovPG/6xWRz49ZTN4v3V7WwWl3fNYbN40nyd0WLLpWZWiw8TN7BZbN40ldniUd9bdosf
	Gx6zOvB6fG/tY/E4duYwo8ettj/MHjtn3WX32LxCy+P/yyNsHptWdbJ5vDt3jt3jxIzfLB7H
	zzh7fN4kF8AdxWWTkpqTWZZapG+XwJVx7NBt1oJbnBWrLl5mb2Bs4+hi5OSQEDCRWHj3LQuE
	LSZx4d56ti5GLg4hgX2MEjcXvgFLCAlsYJTo2lgGkXjGJDHtwj2wBJuAikTH0gdMXYwcHCIC
	+hJXPzOC1DALPGeWePBwFytIjbCAi8Suj6/BbBYBVYlVx1vAbF6BIIl/744zQmxWkLhyZR7Y
	TE4BA4mTd+5BLdaXmHfrLRsu8QmMAgsYGVYxyqbkVunmJmbmFKcm6xYnJ+blpRbpmujlZpbo
	paaUbmIERQinJP8Oxm8HlQ4xCnAwKvHwWhY98hViTSwrrsw9xCjJwaQkyvtI8LGvEF9Sfkpl
	RmJxRnxRaU5q8SFGCQ5mJRFe9V9A5bwpiZVVqUX5MClpDhYlcd5Zkuq+QgLpiSWp2ampBalF
	MFkZDg4lCd4wYCIQEixKTU+tSMvMKUFIM3FwggznARquD7KYt7ggMbc4Mx0if4pRl6Nx7Y6D
	jEIsefl5qVLivDYggwRAijJK8+DmwBLbK0ZxoLeEea8IAVXxAJMi3KRXQEuYgJb0vnsIsqQk
	ESEl1cAo9sn0xcKH6zpzPXdy1HSdPuh7o6N+U3lF7pOgg3Ou6VVbfpqX+OFX6t8Hst0Mz/9o
	Z5yTY9sj81j47MWWS7UhuSlu/w+tDZ4jfeuG/KVFG43P+58t4bkbr/c51so8743tZcv2wHlp
	bQytDml653+sKS44ctfXdsX194FnJgpbc/Q3LFG7lV2mxFKckWioxVxUnAgA6bxh5UcDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It just segfaults since April 2008 (a4928cff), so I'm pretty sure
that nothing uses it.  And having an empty section makes the linker
script a bit fragile.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |    4 ----
 arch/x86/kernel/vsyscall_64.c |    5 -----
 2 files changed, 0 insertions(+), 9 deletions(-)

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
index 53d2237..71fa506 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -232,11 +232,6 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	return 0;
 }
 
-static long __vsyscall(3) venosys_1(void)
-{
-	return -ENOSYS;
-}
-
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
 	long ret;
-- 
1.7.5.1

