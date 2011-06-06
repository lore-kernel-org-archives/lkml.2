Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1FFIeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:34:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947Ab1FFIeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:34:12 -0400
Date: Mon, 6 Jun 2011 08:33:33 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-bb5fe2f78eadf5a52d8dcbf9a57728fd107af97b@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
In-Reply-To: <4a4abcf47ecadc269f2391a313576fe6d06acef7.1307292171.git.luto@mit.edu>
References: <4a4abcf47ecadc269f2391a313576fe6d06acef7.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Remove vsyscall number 3 (venosys)
Git-Commit-ID: bb5fe2f78eadf5a52d8dcbf9a57728fd107af97b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:33:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb5fe2f78eadf5a52d8dcbf9a57728fd107af97b
Gitweb:     http://git.kernel.org/tip/bb5fe2f78eadf5a52d8dcbf9a57728fd107af97b
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Sun, 5 Jun 2011 13:50:22 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 09:43:14 +0200

x86-64: Remove vsyscall number 3 (venosys)

It just segfaults since April 2008 (a4928cff), so I'm pretty
sure that nothing uses it.  And having an empty section makes
the linker script a bit fragile.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/4a4abcf47ecadc269f2391a313576fe6d06acef7.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |    4 ----
 arch/x86/kernel/vsyscall_64.c |    5 -----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 98b378d..4f90082 100644
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
index 9b2f3f5..70a5f6e 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -209,11 +209,6 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	return 0;
 }
 
-static long __vsyscall(3) venosys_1(void)
-{
-	return -ENOSYS;
-}
-
 /* Assume __initcall executes before all user space. Hopefully kmod
    doesn't violate that. We'll find out if it does. */
 static void __cpuinit vsyscall_set_cpu(int cpu)
