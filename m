Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1FFOf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:35:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab1FFOf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:35:57 -0400
Date: Mon, 6 Jun 2011 14:34:11 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-1593843e2ada6d6832d0de4d633aacd997dc3a45@git.kernel.org>
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
In-Reply-To: <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
References: <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
Git-Commit-ID: 1593843e2ada6d6832d0de4d633aacd997dc3a45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 14:34:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1593843e2ada6d6832d0de4d633aacd997dc3a45
Gitweb:     http://git.kernel.org/tip/1593843e2ada6d6832d0de4d633aacd997dc3a45
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 6 Jun 2011 12:13:40 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 12:13:40 +0200

x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS

Linus pointed out that the UNSAFE_VSYSCALL naming was inherently
bad: it suggests that there's something unsafe about enabling them,
while in reality they only have any security effect in the presence
of some *other* security hole.

So rename it to CONFIG_COMPAT_VSYSCALL and fix the documentation
and Kconfig text to correctly explain the purpose of this change.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/BANLkTimrhO8QfBqQsH_Q13ghRH2P%2BZP7AA@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/feature-removal-schedule.txt |    7 ++++---
 arch/x86/Kconfig                           |   17 ++++++++++-------
 arch/x86/kernel/vsyscall_64.c              |    8 ++++----
 arch/x86/kernel/vsyscall_emu_64.S          |    2 +-
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 94b4470..4282ab2 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -601,10 +601,11 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
 
-What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
+What:	CONFIG_COMPAT_VSYSCALLS (x86_64)
 When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
-Why:	Having user-executable code at a fixed address is a security problem.
-	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
+Why:	Having user-executable syscall invoking code at a fixed addresses makes
+	it easier for attackers to exploit security holes.
+	Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
 	make the time() function slower on glibc versions 2.13 and below.
 Who:	Andy Lutomirski <luto@mit.edu>
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79e5d8a..30041d8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1646,20 +1646,23 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
-config UNSAFE_VSYSCALLS
+config COMPAT_VSYSCALLS
 	def_bool y
-	prompt "Unsafe fast legacy vsyscalls"
+	prompt "Fixed address legacy vsyscalls"
 	depends on X86_64
 	---help---
 	  Legacy user code expects to be able to issue three syscalls
-	  by calling fixed addresses in kernel space.  If you say N,
-	  then the kernel traps and emulates these calls.  If you say
-	  Y, then there is actual executable code at a fixed address
-	  to implement time() efficiently.
+	  by calling a fixed addresses.  If you say N, then the kernel
+	  traps and emulates these calls.  If you say Y, then there is
+	  actual executable code at a fixed address to implement time()
+	  efficiently.
 
 	  On a system with recent enough glibc (probably 2.14 or
 	  newer) and no static binaries, you can say N without a
-	  performance penalty to improve security
+	  performance penalty to improve security: having no fixed
+	  address userspace-executable syscall invoking code makes
+	  it harder for both remote and local attackers to exploit
+	  security holes.
 
 	  If unsure, say Y.
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 285af7a..27d49b7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -116,7 +116,7 @@ static int al_to_vsyscall_nr(u8 al)
 	return -1;
 }
 
-#ifdef CONFIG_UNSAFE_VSYSCALLS
+#ifdef CONFIG_COMPAT_VSYSCALLS
 
 /* This will break when the xtime seconds get inaccurate, but that is
  * unlikely */
@@ -138,9 +138,9 @@ vtime(time_t *t)
 	return result;
 }
 
-#endif /* CONFIG_UNSAFE_VSYSCALLS */
+#endif /* CONFIG_COMPAT_VSYSCALLS */
 
-/* If CONFIG_UNSAFE_VSYSCALLS=y, then this is incorrect for vsyscall_nr == 1. */
+/* If CONFIG_COMPAT_VSYSCALLS=y, then this is incorrect for vsyscall_nr == 1. */
 static inline unsigned long vsyscall_intcc_addr(int vsyscall_nr)
 {
 	return VSYSCALL_START + 1024*vsyscall_nr + 2;
@@ -202,7 +202,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		break;
 
 	case 1:
-#ifdef CONFIG_UNSAFE_VSYSCALLS
+#ifdef CONFIG_COMPAT_VSYSCALLS
 		warn_bad_vsyscall(KERN_WARNING, regs, "bogus time() vsyscall "
 				  "emulation (exploit attempt?)");
 		goto sigsegv;
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index 7ebde61..2d53e26 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -25,7 +25,7 @@ ENTRY(vsyscall_0)
 	ret
 END(vsyscall_0)
 
-#ifndef CONFIG_UNSAFE_VSYSCALLS
+#ifndef CONFIG_COMPAT_VSYSCALLS
 .section .vsyscall_1, "a"
 ENTRY(vsyscall_1)
 	movb $0xce, %al
