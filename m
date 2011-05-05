Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1EESoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:44:25 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33934 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab1EESoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:44:23 -0400
Date: Thu, 5 May 2011 20:44:20 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
In-Reply-To: <201105050824.34056.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg> <201105050824.34056.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Arnd Bergmann wrote:
> Did you check the macros in unistd to see if they match the
> actual table? I guess it would be a good time to comment out
> the ones that are not implemented in either of the two ABIs.

Like this?

warning: #warning syscall pselect6 not implemented
warning: #warning syscall ppoll not implemented
warning: #warning syscall recvmmsg not implemented

Do we need pselect6 and ppoll? I have vague memories not requiring it.
recvmmsg is a false positive, as we set __ARCH_WANT_SYS_SOCKETCALL.

>From 5739b340b334de21c6da4f65d5194957662a6dd0 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 May 2011 20:33:02 +0200
Subject: [PATCH] m68k: unistd - Comment out definitions for unimplemented syscalls

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unistd.h |   50 ++++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 29e1790..bddd1ca 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -22,7 +22,7 @@
 #define __NR_mknod		 14
 #define __NR_chmod		 15
 #define __NR_chown		 16
-#define __NR_break		 17
+/*#define __NR_break		 17*/
 #define __NR_oldstat		 18
 #define __NR_lseek		 19
 #define __NR_getpid		 20
@@ -36,11 +36,11 @@
 #define __NR_oldfstat		 28
 #define __NR_pause		 29
 #define __NR_utime		 30
-#define __NR_stty		 31
-#define __NR_gtty		 32
+/*#define __NR_stty		 31*/
+/*#define __NR_gtty		 32*/
 #define __NR_access		 33
 #define __NR_nice		 34
-#define __NR_ftime		 35
+/*#define __NR_ftime		 35*/
 #define __NR_sync		 36
 #define __NR_kill		 37
 #define __NR_rename		 38
@@ -49,7 +49,7 @@
 #define __NR_dup		 41
 #define __NR_pipe		 42
 #define __NR_times		 43
-#define __NR_prof		 44
+/*#define __NR_prof		 44*/
 #define __NR_brk		 45
 #define __NR_setgid		 46
 #define __NR_getgid		 47
@@ -58,13 +58,13 @@
 #define __NR_getegid		 50
 #define __NR_acct		 51
 #define __NR_umount2		 52
-#define __NR_lock		 53
+/*#define __NR_lock		 53*/
 #define __NR_ioctl		 54
 #define __NR_fcntl		 55
-#define __NR_mpx		 56
+/*#define __NR_mpx		 56*/
 #define __NR_setpgid		 57
-#define __NR_ulimit		 58
-#define __NR_oldolduname	 59
+/*#define __NR_ulimit		 58*/
+/*#define __NR_oldolduname	 59*/
 #define __NR_umask		 60
 #define __NR_chroot		 61
 #define __NR_ustat		 62
@@ -103,10 +103,10 @@
 #define __NR_fchown		 95
 #define __NR_getpriority	 96
 #define __NR_setpriority	 97
-#define __NR_profil		 98
+/*#define __NR_profil		 98*/
 #define __NR_statfs		 99
 #define __NR_fstatfs		100
-#define __NR_ioperm		101
+/*#define __NR_ioperm		101*/
 #define __NR_socketcall		102
 #define __NR_syslog		103
 #define __NR_setitimer		104
@@ -114,11 +114,11 @@
 #define __NR_stat		106
 #define __NR_lstat		107
 #define __NR_fstat		108
-#define __NR_olduname		109
-#define __NR_iopl		/* 110 */ not supported
+/*#define __NR_olduname		109*/
+/*#define __NR_iopl		110*/ /* not supported */
 #define __NR_vhangup		111
-#define __NR_idle		/* 112 */ Obsolete
-#define __NR_vm86		/* 113 */ not supported
+/*#define __NR_idle		112*/ /* Obsolete */
+/*#define __NR_vm86		113*/ /* not supported */
 #define __NR_wait4		114
 #define __NR_swapoff		115
 #define __NR_sysinfo		116
@@ -132,17 +132,17 @@
 #define __NR_adjtimex		124
 #define __NR_mprotect		125
 #define __NR_sigprocmask	126
-#define __NR_create_module	127
+/*#define __NR_create_module	127*/
 #define __NR_init_module	128
 #define __NR_delete_module	129
-#define __NR_get_kernel_syms	130
+/*#define __NR_get_kernel_syms	130*/
 #define __NR_quotactl		131
 #define __NR_getpgid		132
 #define __NR_fchdir		133
 #define __NR_bdflush		134
 #define __NR_sysfs		135
 #define __NR_personality	136
-#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
+/*#define __NR_afs_syscall	137*/ /* Syscall for Andrew File System */
 #define __NR_setfsuid		138
 #define __NR_setfsgid		139
 #define __NR__llseek		140
@@ -172,7 +172,7 @@
 #define __NR_setresuid		164
 #define __NR_getresuid		165
 #define __NR_getpagesize	166
-#define __NR_query_module	167
+/*#define __NR_query_module	167*/
 #define __NR_poll		168
 #define __NR_nfsservctl		169
 #define __NR_setresgid		170
@@ -193,8 +193,8 @@
 #define __NR_capset		185
 #define __NR_sigaltstack	186
 #define __NR_sendfile		187
-#define __NR_getpmsg		188	/* some people actually want streams */
-#define __NR_putpmsg		189	/* some people actually want streams */
+/*#define __NR_getpmsg		188*/	/* some people actually want streams */
+/*#define __NR_putpmsg		189*/	/* some people actually want streams */
 #define __NR_vfork		190
 #define __NR_ugetrlimit		191
 #define __NR_mmap2		192
@@ -223,6 +223,8 @@
 #define __NR_setfsuid32		215
 #define __NR_setfsgid32		216
 #define __NR_pivot_root		217
+/* 218*/
+/* 219*/
 #define __NR_getdents64		220
 #define __NR_gettid		221
 #define __NR_tkill		222
@@ -281,7 +283,7 @@
 #define __NR_mq_notify		275
 #define __NR_mq_getsetattr	276
 #define __NR_waitid		277
-#define __NR_vserver		278
+/*#define __NR_vserver		278*/
 #define __NR_add_key		279
 #define __NR_request_key	280
 #define __NR_keyctl		281
@@ -304,8 +306,8 @@
 #define __NR_readlinkat		298
 #define __NR_fchmodat		299
 #define __NR_faccessat		300
-#define __NR_pselect6		301
-#define __NR_ppoll		302
+/*#define __NR_pselect6		301*/
+/*#define __NR_ppoll		302*/
 #define __NR_unshare		303
 #define __NR_set_robust_list	304
 #define __NR_get_robust_list	305
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
