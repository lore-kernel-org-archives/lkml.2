Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab1CaHhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:37:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35594 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1CaHhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:37:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bitmap, irq: Add smp_affinity_list interface to /proc/irq
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Travis <travis@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110329181346.d2e1fb3c.akpm@linux-foundation.org>
References: <4D9281B8.1090904@sgi.com> <20110329181346.d2e1fb3c.akpm@linux-foundation.org>
Message-Id: <20110331163916.2C6D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 31 Mar 2011 16:37:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [If it was up to me, I'd eliminate the bitmask interfaces and just keep the
> > list interfaces.  That's the stupid interface that's not needed, and far more
> > shortsighted.]
> 
> Agree.
> 
> It's not impossible to remove those interfaces.  My preferred approach
> is to add a once-per-boot warning printk if anyone uses the old
> interface and to remove the thing altogether in three or five years.
> 
> That reminds me.  It's been like ten years.  Someone please delete sys_bdflush().

This?

But to be honest, this long diffstat seems tell me the worth is doubious. ;-)


---
 arch/alpha/kernel/systbls.S            |    2 +-
 arch/arm/kernel/calls.S                |    2 +-
 arch/avr32/kernel/syscall_table.S      |    2 +-
 arch/blackfin/mach-common/entry.S      |    2 +-
 arch/cris/arch-v10/kernel/entry.S      |    2 +-
 arch/cris/arch-v32/kernel/entry.S      |    2 +-
 arch/frv/kernel/entry.S                |    2 +-
 arch/h8300/kernel/syscalls.S           |    2 +-
 arch/ia64/kernel/entry.S               |    2 +-
 arch/m32r/kernel/syscall_table.S       |    2 +-
 arch/m68k/kernel/entry_mm.S            |    2 +-
 arch/m68k/kernel/syscalltable.S        |    2 +-
 arch/microblaze/kernel/syscall_table.S |    2 +-
 arch/mips/kernel/scall32-o32.S         |    2 +-
 arch/mips/kernel/scall64-o32.S         |    2 +-
 arch/mn10300/kernel/entry.S            |    2 +-
 arch/parisc/kernel/syscall_table.S     |    2 +-
 arch/powerpc/include/asm/systbl.h      |    2 +-
 arch/s390/kernel/compat_wrapper.S      |    6 ------
 arch/s390/kernel/syscalls.S            |    2 +-
 arch/sh/kernel/syscalls_32.S           |    2 +-
 arch/sh/kernel/syscalls_64.S           |    2 +-
 arch/sparc/kernel/sys32.S              |    1 -
 arch/sparc/kernel/systbls_32.S         |    2 +-
 arch/sparc/kernel/systbls_64.S         |    4 ++--
 arch/x86/kernel/syscall_table_32.S     |    2 +-
 arch/xtensa/include/asm/unistd.h       |    2 +-
 fs/buffer.c                            |   27 ---------------------------
 include/asm-generic/unistd.h           |    2 +-
 include/linux/capability.h             |    1 -
 include/linux/syscalls.h               |    1 -
 kernel/sys_ni.c                        |    1 -
 32 files changed, 27 insertions(+), 64 deletions(-)

diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index a6a1de9..6165de6 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -318,7 +318,7 @@ sys_call_table:
 	.quad alpha_ni_syscall
 	.quad alpha_ni_syscall
 /* linux-specific system calls start at 300 */
-	.quad sys_bdflush			/* 300 */
+	.quad sys_ni_syscall			/* 300: old sys_bdflush	*/
 	.quad sys_sethae
 	.quad sys_mount
 	.quad sys_old_adjtimex
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 5c26ecc..1786738 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -143,7 +143,7 @@
 		CALL(sys_quotactl)
 		CALL(sys_getpgid)
 		CALL(sys_fchdir)
-		CALL(sys_bdflush)
+		CALL(sys_ni_syscall)
 /* 135 */	CALL(sys_sysfs)
 		CALL(sys_personality)
 		CALL(sys_ni_syscall)		/* reserved for afs_syscall */
diff --git a/arch/avr32/kernel/syscall_table.S b/arch/avr32/kernel/syscall_table.S
index e76bad1..cdea078 100644
--- a/arch/avr32/kernel/syscall_table.S
+++ b/arch/avr32/kernel/syscall_table.S
@@ -132,7 +132,7 @@ sys_call_table:
 	.long	sys_delete_module
 	.long	sys_quotactl
 	.long	sys_getpgid
-	.long	sys_bdflush
+	.long	sys_ni_syscall		/* was sys_bdflush */
 	.long	sys_sysfs		/* 120 */
 	.long	sys_personality
 	.long	sys_ni_syscall		/* reserved for afs_syscall */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 46ab457..23a0a0e 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1508,7 +1508,7 @@ ENTRY(_sys_call_table)
 	.long _sys_quotactl
 	.long _sys_getpgid
 	.long _sys_fchdir
-	.long _sys_bdflush
+	.long _sys_ni_syscall	/* old sys_bdflush */
 	.long _sys_ni_syscall	/* 135 */ /* sys_sysfs */
 	.long _sys_personality
 	.long _sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 0d6420d..aa2d3d6 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -736,7 +736,7 @@ sys_call_table:
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index 0ecb50b..90e0cc2 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -679,7 +679,7 @@ sys_call_table:
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 63d579b..8932e28 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1323,7 +1323,7 @@ sys_call_table:
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/h8300/kernel/syscalls.S b/arch/h8300/kernel/syscalls.S
index faefaff..e09bed8 100644
--- a/arch/h8300/kernel/syscalls.S
+++ b/arch/h8300/kernel/syscalls.S
@@ -148,7 +148,7 @@ SYMBOL_NAME_LABEL(sys_call_table)
 	.long SYMBOL_NAME(sys_quotactl)
 	.long SYMBOL_NAME(sys_getpgid)
 	.long SYMBOL_NAME(sys_fchdir)
-	.long SYMBOL_NAME(sys_bdflush)
+	.long SYMBOL_NAME(sys_ni_syscall)	/* was sys_bdflush */
 	.long SYMBOL_NAME(sys_sysfs)		/* 135 */
 	.long SYMBOL_NAME(sys_personality)
 	.long SYMBOL_NAME(sys_ni_syscall)	/* for afs_syscall */
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 6de2e23..df46ffb 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1583,7 +1583,7 @@ sys_call_table:
 	data8 sys_ni_syscall			// 1135		/* was: sys_get_kernel_syms */
 	data8 sys_ni_syscall					/* was: sys_query_module */
 	data8 sys_quotactl
-	data8 sys_bdflush
+	data8 sys_ni_syscall					/* was: sys_bdflush */
 	data8 sys_sysfs
 	data8 sys_personality			// 1140
 	data8 sys_ni_syscall		// sys_afs_syscall
diff --git a/arch/m32r/kernel/syscall_table.S b/arch/m32r/kernel/syscall_table.S
index 60536e2..8b197b9 100644
--- a/arch/m32r/kernel/syscall_table.S
+++ b/arch/m32r/kernel/syscall_table.S
@@ -133,7 +133,7 @@ ENTRY(sys_call_table)
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall		/* sys_bdflush syscall holder */
 	.long sys_sysfs			/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall		/* afs_syscall syscall holder */
diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index 1559dea..49b280e 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -544,7 +544,7 @@ sys_call_table:
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall		/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall				/* for afs_syscall */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 79b1ed1..88be6af 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -152,7 +152,7 @@ ENTRY(sys_call_table)
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index e88a930..b25b3e0 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -138,7 +138,7 @@ ENTRY(sys_call_table)
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall		/* old "sys_bdflush" */
 	.long sys_sysfs			/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall		/* reserved for afs_syscall */
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 7f5468b..ee7393d 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -370,7 +370,7 @@ einval:	li	v0, -ENOSYS
 	sys	sys_quotactl		4
 	sys	sys_getpgid		1
 	sys	sys_fchdir		1
-	sys	sys_bdflush		2
+	sys	sys_ni_syscall		0
 	sys	sys_sysfs		3	/* 4135 */
 	sys	sys_personality		1
 	sys	sys_ni_syscall		0	/* for afs_syscall */
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 049a9c8..bcf4038 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -338,7 +338,7 @@ sys_call_table:
 	PTR	sys_quotactl
 	PTR	sys_getpgid
 	PTR	sys_fchdir
-	PTR	sys_bdflush
+	PTR	sys_ni_syscall
 	PTR	sys_sysfs			/* 4135 */
 	PTR	sys_32_personality
 	PTR	sys_ni_syscall	 		/* for afs_syscall */
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index fb93ad7..fdaabc7 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -554,7 +554,7 @@ ENTRY(sys_call_table)
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* reserved for afs_syscall */
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index 74867df..4b82982 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -214,7 +214,7 @@
 	ENTRY_SAME(quotactl)
 	ENTRY_SAME(getpgid)
 	ENTRY_SAME(fchdir)
-	ENTRY_SAME(bdflush)
+	ENTRY_SAME(ni_syscall)
 	ENTRY_SAME(sysfs)		/* 135 */
 	ENTRY_OURS(personality)
 	ENTRY_SAME(ni_syscall)	/* for afs_syscall */
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index aa0f1eb..22c5d25 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -137,7 +137,7 @@ SYSCALL(ni_syscall)
 SYSCALL(quotactl)
 COMPAT_SYS_SPU(getpgid)
 SYSCALL_SPU(fchdir)
-SYSCALL_SPU(bdflush)
+SYSCALL_SPU(ni_syscall)
 COMPAT_SYS(sysfs)
 SYSX_SPU(ppc64_personality,ppc64_personality,sys_personality)
 SYSCALL(ni_syscall)
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 1dc96ea..eecb1dd 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -599,12 +599,6 @@ sys32_fchdir_wrapper:
 	llgfr	%r2,%r2			# unsigned int
 	jg	sys_fchdir		# branch to system call
 
-	.globl	sys32_bdflush_wrapper
-sys32_bdflush_wrapper:
-	lgfr	%r2,%r2			# int
-	lgfr	%r3,%r3			# long
-	jg	sys_bdflush		# branch to system call
-
 	.globl	sys32_sysfs_wrapper
 sys32_sysfs_wrapper:
 	lgfr	%r2,%r2			# int
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 9c65fd4..04d7ae5 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -142,7 +142,7 @@ NI_SYSCALL							/* 130: old get_kernel_syms */
 SYSCALL(sys_quotactl,sys_quotactl,sys32_quotactl_wrapper)
 SYSCALL(sys_getpgid,sys_getpgid,sys32_getpgid_wrapper)
 SYSCALL(sys_fchdir,sys_fchdir,sys32_fchdir_wrapper)
-SYSCALL(sys_bdflush,sys_bdflush,sys32_bdflush_wrapper)
+NI_SYSCALL
 SYSCALL(sys_sysfs,sys_sysfs,sys32_sysfs_wrapper)		/* 135 */
 SYSCALL(sys_personality,sys_s390_personality,sys32_personality_wrapper)
 NI_SYSCALL							/* for afs_syscall */
diff --git a/arch/sh/kernel/syscalls_32.S b/arch/sh/kernel/syscalls_32.S
index 030966a..14d0b63 100644
--- a/arch/sh/kernel/syscalls_32.S
+++ b/arch/sh/kernel/syscalls_32.S
@@ -150,7 +150,7 @@ ENTRY(sys_call_table)
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/sh/kernel/syscalls_64.S b/arch/sh/kernel/syscalls_64.S
index ca0a614..06d7298 100644
--- a/arch/sh/kernel/syscalls_64.S
+++ b/arch/sh/kernel/syscalls_64.S
@@ -154,7 +154,7 @@ sys_call_table:
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall		/* old "sys_bdflush" */
 	.long sys_sysfs			/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* for afs_syscall */
diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index 44e5faf..256f7b2 100644
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -79,7 +79,6 @@ SIGN3(sys32_epoll_wait, sys_epoll_wait, %o0, %o2, %o3)
 SIGN1(sys32_readahead, compat_sys_readahead, %o0)
 SIGN2(sys32_fadvise64, compat_sys_fadvise64, %o0, %o4)
 SIGN2(sys32_fadvise64_64, compat_sys_fadvise64_64, %o0, %o5)
-SIGN2(sys32_bdflush, sys_bdflush, %o0, %o1)
 SIGN1(sys32_mlockall, sys_mlockall, %o0)
 SIGN1(sys32_nfsservctl, compat_sys_nfsservctl, %o0)
 SIGN1(sys32_clock_nanosleep, compat_sys_clock_nanosleep, %o1)
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index 4b86eaf..224dab6 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -61,7 +61,7 @@ sys_call_table:
 /*210*/	.long sys_fadvise64_64, sys_tgkill, sys_waitpid, sys_swapoff, sys_sysinfo
 /*215*/	.long sys_ipc, sys_sigreturn, sys_clone, sys_ioprio_get, sys_adjtimex
 /*220*/	.long sys_sigprocmask, sys_ni_syscall, sys_delete_module, sys_ni_syscall, sys_getpgid
-/*225*/	.long sys_bdflush, sys_sysfs, sys_nis_syscall, sys_setfsuid16, sys_setfsgid16
+/*225*/	.long sys_ni_syscall, sys_sysfs, sys_nis_syscall, sys_setfsuid16, sys_setfsgid16
 /*230*/	.long sys_select, sys_time, sys_splice, sys_stime, sys_statfs64
 					  /* "We are the Knights of the Forest of Ni!!" */
 /*235*/	.long sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys_mlockall
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 0331baf..72e9a9b 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -63,7 +63,7 @@ sys_call_table32:
 /*210*/	.word sys32_fadvise64_64, sys32_tgkill, sys32_waitpid, sys_swapoff, compat_sys_sysinfo
 	.word compat_sys_ipc, sys32_sigreturn, sys_clone, sys32_ioprio_get, compat_sys_adjtimex
 /*220*/	.word sys32_sigprocmask, sys_ni_syscall, sys32_delete_module, sys_ni_syscall, sys32_getpgid
-	.word sys32_bdflush, sys32_sysfs, sys_nis_syscall, sys_setfsuid16, sys_setfsgid16
+	.word sys_ni_syscall, sys32_sysfs, sys_nis_syscall, sys_setfsuid16, sys_setfsgid16
 /*230*/	.word sys32_select, compat_sys_time, sys32_splice, compat_sys_stime, compat_sys_statfs64
 	.word compat_sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys32_mlockall
 /*240*/	.word sys_munlockall, sys32_sched_setparam, sys32_sched_getparam, sys32_sched_setscheduler, sys32_sched_getscheduler
@@ -139,7 +139,7 @@ sys_call_table:
 /*210*/	.word sys_fadvise64_64, sys_tgkill, sys_waitpid, sys_swapoff, sys_sysinfo
 	.word sys_sparc_ipc, sys_nis_syscall, sys_clone, sys_ioprio_get, sys_adjtimex
 /*220*/	.word sys_nis_syscall, sys_ni_syscall, sys_delete_module, sys_ni_syscall, sys_getpgid
-	.word sys_bdflush, sys_sysfs, sys_nis_syscall, sys_setfsuid, sys_setfsgid
+	.word sys_ni_syscall, sys_sysfs, sys_nis_syscall, sys_setfsuid, sys_setfsgid
 /*230*/	.word sys_select, sys_nis_syscall, sys_splice, sys_stime, sys_statfs64
 	.word sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys_mlockall
 /*240*/	.word sys_munlockall, sys_sched_setparam, sys_sched_getparam, sys_sched_setscheduler, sys_sched_getscheduler
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index abce34d..de0ced0 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -133,7 +133,7 @@ ENTRY(sys_call_table)
 	.long sys_quotactl
 	.long sys_getpgid
 	.long sys_fchdir
-	.long sys_bdflush
+	.long sys_ni_syscall	/* old "sys_bdflush" */
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
 	.long sys_ni_syscall	/* reserved for afs_syscall */
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index 528042c..788adab 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -459,7 +459,7 @@ __SYSCALL(205, sys_nfsservctl, 3)
 #define __NR__sysctl 				206
 __SYSCALL(206, sys_sysctl, 1)
 #define __NR_bdflush 				207
-__SYSCALL(207, sys_bdflush, 2)
+__SYSCALL(207, sys_ni_syscall,0)
 #define __NR_uname 				208
 __SYSCALL(208, sys_newuname, 1)
 #define __NR_sysinfo 				209
diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..9c7b1e5 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3127,33 +3127,6 @@ out:
 EXPORT_SYMBOL(try_to_free_buffers);
 
 /*
- * There are no bdflush tunables left.  But distributions are
- * still running obsolete flush daemons, so we terminate them here.
- *
- * Use of bdflush() is deprecated and will be removed in a future kernel.
- * The `flush-X' kernel threads fully replace bdflush daemons and this call.
- */
-SYSCALL_DEFINE2(bdflush, int, func, long, data)
-{
-	static int msg_count;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (msg_count < 5) {
-		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the obsolete bdflush"
-			" system call\n", current->comm);
-		printk(KERN_INFO "Fix your initscripts?\n");
-	}
-
-	if (func == 1)
-		do_exit(0);
-	return 0;
-}
-
-/*
  * Buffer-head allocation
  */
 static struct kmem_cache *bh_cachep;
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 07c40d5..cf5c1d2 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -800,7 +800,7 @@ __SYSCALL(__NR_recv, sys_recv)
 #define __NR_send 1074
 __SYSCALL(__NR_send, sys_send)
 #define __NR_bdflush 1075
-__SYSCALL(__NR_bdflush, sys_bdflush)
+__SYSCALL(__NR_bdflush, sys_ni_syscall)
 #define __NR_umount 1076
 __SYSCALL(__NR_umount, sys_oldumount)
 #define __ARCH_WANT_SYS_OLDUMOUNT
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 16ee8b4..ea485a6 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -248,7 +248,6 @@ struct cpu_vfs_cap_data {
 /* Allow examination and configuration of disk quotas */
 /* Allow setting the domainname */
 /* Allow setting the hostname */
-/* Allow calling bdflush() */
 /* Allow mount() and umount(), setting up new smb connection */
 /* Allow some autofs root ioctls */
 /* Allow nfsservctl */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 83ecc17..88372fe 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -391,7 +391,6 @@ asmlinkage long sys_pause(void);
 asmlinkage long sys_sync(void);
 asmlinkage long sys_fsync(unsigned int fd);
 asmlinkage long sys_fdatasync(unsigned int fd);
-asmlinkage long sys_bdflush(int func, long data);
 asmlinkage long sys_mount(char __user *dev_name, char __user *dir_name,
 				char __user *type, unsigned long flags,
 				void __user *data);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 25cc41c..6c67e4d 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -163,7 +163,6 @@ cond_syscall(compat_sys_move_pages);
 cond_syscall(compat_sys_migrate_pages);
 
 /* block-layer dependent */
-cond_syscall(sys_bdflush);
 cond_syscall(sys_ioprio_set);
 cond_syscall(sys_ioprio_get);
 
-- 
1.7.1





