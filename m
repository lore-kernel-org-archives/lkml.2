Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2DSXQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:16:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab2DSXQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:16:50 -0400
Date: Fri, 20 Apr 2012 01:16:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 5/6] keys: kill the dummy key_replace_session_keyring()
Message-ID: <20120419231600.GE15828@redhat.com>
References: <20120419231431.GA15820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419231431.GA15820@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previouse change key_replace_session_keyring() becomes
a nop. Remove the dummy definition in key.h and update the callers
in arch/*/kernel/signal.c.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/alpha/kernel/signal.c     |    2 --
 arch/arm/kernel/signal.c       |    2 --
 arch/avr32/kernel/signal.c     |    2 --
 arch/blackfin/kernel/signal.c  |    2 --
 arch/c6x/kernel/signal.c       |    2 --
 arch/cris/kernel/ptrace.c      |    2 --
 arch/frv/kernel/signal.c       |    2 --
 arch/h8300/kernel/signal.c     |    2 --
 arch/hexagon/kernel/signal.c   |    2 --
 arch/ia64/kernel/process.c     |    2 --
 arch/m32r/kernel/signal.c      |    2 --
 arch/mips/kernel/signal.c      |    2 --
 arch/mn10300/kernel/signal.c   |    2 --
 arch/openrisc/kernel/signal.c  |    2 --
 arch/parisc/kernel/signal.c    |    2 --
 arch/powerpc/kernel/signal.c   |    2 --
 arch/s390/kernel/signal.c      |    2 --
 arch/sh/kernel/signal_32.c     |    2 --
 arch/sh/kernel/signal_64.c     |    2 --
 arch/sparc/kernel/signal_32.c  |    2 --
 arch/sparc/kernel/signal_64.c  |    2 --
 arch/tile/kernel/process.c     |    2 --
 arch/unicore32/kernel/signal.c |    2 --
 arch/x86/kernel/signal.c       |    2 --
 include/linux/key.h            |    2 --
 25 files changed, 0 insertions(+), 50 deletions(-)

diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 35f2ef4..bb61c58 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -616,7 +616,5 @@ do_notify_resume(struct pt_regs *regs, struct switch_stack *sw,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 7cb532f..5c34754 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -782,7 +782,5 @@ do_notify_resume(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 	if (thread_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 64f886f..0d512c5 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -327,7 +327,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
 	if (ti->flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index d536f35..0af1a1b 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -347,8 +347,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs)
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
index 3b5a050..ee7beae 100644
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -361,7 +361,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags,
 	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index d114ad3..58d44ee 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -40,7 +40,5 @@ void do_notify_resume(int canrestart, struct pt_regs *regs,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index bab0129..151a3fd 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -583,8 +583,6 @@ asmlinkage void do_notify_resume(__u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(__frame);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 } /* end do_notify_resume() */
diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index af842c3..14c46e8 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -557,7 +557,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index ab5f5ad..f16152e 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -273,8 +273,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index ce74e14..99f34a8 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -199,8 +199,6 @@ do_notify_resume_user(sigset_t *unused, struct sigscratch *scr, long in_syscall)
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(&scr->pt);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 	/* copy user rbs to kernel rbs */
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index a08697f..d0a24f4 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -391,8 +391,6 @@ void do_notify_resume(struct pt_regs *regs, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 	clear_thread_flag(TIF_IRET);
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 185ca00..cebed39 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -669,8 +669,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, void *unused,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 690f4e9..909059e 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -575,7 +575,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(current_frame());
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index e970743..9ae6115 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -376,7 +376,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs)
 	if (current_thread_info()->flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 12c1ed3..c3102c4 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -647,7 +647,5 @@ void do_notify_resume(struct pt_regs *regs, long in_syscall)
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 651c596..bfc3ec1 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -193,8 +193,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index f7582b2..fbf2495 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -517,6 +517,4 @@ void do_notify_resume(struct pt_regs *regs)
 {
 	clear_thread_flag(TIF_NOTIFY_RESUME);
 	tracehook_notify_resume(regs);
-	if (current->replacement_session_keyring)
-		key_replace_session_keyring();
 }
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 5901fba..a6b74c3 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -633,7 +633,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned int save_r0,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 3c9a6f7..52bdfb0 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -737,7 +737,5 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned long thread_info
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 1e750e4..72bd0f7 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -603,8 +603,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0,
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 48b0f57..f2dcaab 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -618,8 +618,6 @@ void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0, unsigned long
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 2d5ef61..ff15527 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -584,8 +584,6 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 		return 1;
 	}
 	if (thread_info_flags & _TIF_SINGLESTEP) {
diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 911b549..b1e5cd5 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -470,8 +470,6 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 	if (thread_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 115eac4..d727de0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -831,8 +831,6 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
 		fire_user_return_notifiers();
diff --git a/include/linux/key.h b/include/linux/key.h
index 0c263d6..16cbdb0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -33,8 +33,6 @@ typedef uint32_t key_perm_t;
 
 struct key;
 
-#define key_replace_session_keyring()	do { } while (0)
-
 #ifdef CONFIG_KEYS
 
 #undef KEY_DEBUGGING
-- 
1.5.5.1


