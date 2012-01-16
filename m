Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2APTL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:11:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2APTLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:11:52 -0500
Date: Mon, 16 Jan 2012 11:08:21 -0800
Message-Id: <201201161908.q0GJ8LmI007237@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/syscall for v3.3-rc1
Cc: David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Michal Marek <mmarek@suse.cz>,
        Richard Weinberger <richard@nod.at>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Jan 2012 11:08:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-syscall-for-linus

The head of this tree is 72142fd4109105c6bd21658966ca5e93c1684081.

H. Peter Anvin (19):
      kbuild: Add support for installing generated asm headers
      kbuild: Add support for an "archheaders" target
      x86-64, syscall: Adjust comment spacing and remove typo
      x86-64, ia32: Move compat_ni_syscall into C and its own file
      trace: Include <asm/asm-offsets.h> in trace_syscalls.c
      x86: Machine-readable syscall tables and scripts to process them
      checksyscalls: Use arch/x86/syscalls/syscall_32.tbl as source
      x86: Generate system call tables and unistd_*.h from tables
      x86: Simplify syscallhdr.sh
      x86, syscall: Re-fix typo in comment
      x86, syscall: Allow syscall offset to be symbolic
      kbuild, headers.sh: Don't make archheaders explicitly
      um: Run host archheaders, allow use of host generated headers
      um: Generate headers before generating user-offsets.s
      x86, um: Use the same style generated syscall tables as native
      x86, um: Mark system call tables readonly
      um: Use $(srctree) not $(KBUILD_SRC)
      x86, um: Fix typo in 32-bit system call modifications
      x86: Move <asm/asm-offsets.h> from trace_syscalls.c to asm/syscall.h

 Documentation/kbuild/makefiles.txt |   50 ++-
 Makefile                           |    9 +-
 arch/um/Makefile                   |    9 +-
 arch/x86/Makefile                  |    6 +
 arch/x86/ia32/Makefile             |    1 +
 arch/x86/ia32/ia32entry.S          |  359 ------------------
 arch/x86/ia32/nosyscall.c          |    7 +
 arch/x86/ia32/syscall_ia32.c       |   25 ++
 arch/x86/include/asm/Kbuild        |    5 +-
 arch/x86/include/asm/ia32_unistd.h |   13 +-
 arch/x86/include/asm/syscall.h     |    1 +
 arch/x86/include/asm/unistd.h      |   54 +++-
 arch/x86/include/asm/unistd_32.h   |  401 --------------------
 arch/x86/include/asm/unistd_64.h   |  732 ------------------------------------
 arch/x86/kernel/Makefile           |    3 +-
 arch/x86/kernel/asm-offsets_32.c   |    8 +
 arch/x86/kernel/asm-offsets_64.c   |   19 +-
 arch/x86/kernel/entry_32.S         |   37 +--
 arch/x86/kernel/syscall_32.c       |   25 ++
 arch/x86/kernel/syscall_64.c       |   20 +-
 arch/x86/kernel/syscall_table_32.S |  350 -----------------
 arch/x86/syscalls/Makefile         |   43 +++
 arch/x86/syscalls/syscall_32.tbl   |  357 ++++++++++++++++++
 arch/x86/syscalls/syscall_64.tbl   |  320 ++++++++++++++++
 arch/x86/syscalls/syscallhdr.sh    |   27 ++
 arch/x86/syscalls/syscalltbl.sh    |   15 +
 arch/x86/um/Makefile               |    3 +-
 arch/x86/um/sys_call_table_32.S    |   26 --
 arch/x86/um/sys_call_table_32.c    |   55 +++
 arch/x86/um/sys_call_table_64.c    |   33 +-
 arch/x86/um/user-offsets.c         |   15 +
 scripts/Makefile.headersinst       |   10 +-
 scripts/checksyscalls.sh           |   15 +-
 33 files changed, 1075 insertions(+), 1978 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index f47cdef..ab0a984 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -33,14 +33,15 @@ This document describes the Linux kernel Makefiles.
 
 	=== 6 Architecture Makefiles
 	   --- 6.1 Set variables to tweak the build to the architecture
-	   --- 6.2 Add prerequisites to archprepare:
-	   --- 6.3 List directories to visit when descending
-	   --- 6.4 Architecture-specific boot images
-	   --- 6.5 Building non-kbuild targets
-	   --- 6.6 Commands useful for building a boot image
-	   --- 6.7 Custom kbuild commands
-	   --- 6.8 Preprocessing linker scripts
-	   --- 6.9 Generic header files
+	   --- 6.2 Add prerequisites to archheaders:
+	   --- 6.3 Add prerequisites to archprepare:
+	   --- 6.4 List directories to visit when descending
+	   --- 6.5 Architecture-specific boot images
+	   --- 6.6 Building non-kbuild targets
+	   --- 6.7 Commands useful for building a boot image
+	   --- 6.8 Custom kbuild commands
+	   --- 6.9 Preprocessing linker scripts
+	   --- 6.10 Generic header files
 
 	=== 7 Kbuild syntax for exported headers
 		--- 7.1 header-y
@@ -252,7 +253,7 @@ more details, with real examples.
 	This will create a library lib.a based on delay.o. For kbuild to
 	actually recognize that there is a lib.a being built, the directory
 	shall be listed in libs-y.
-	See also "6.3 List directories to visit when descending".
+	See also "6.4 List directories to visit when descending".
 
 	Use of lib-y is normally restricted to lib/ and arch/*/lib.
 
@@ -974,7 +975,20 @@ When kbuild executes, the following steps are followed (roughly):
 	$(KBUILD_ARFLAGS) set by the top level Makefile to "D" (deterministic
 	mode) if this option is supported by $(AR).
 
---- 6.2 Add prerequisites to archprepare:
+--- 6.2 Add prerequisites to archheaders:
+
+	The archheaders: rule is used to generate header files that
+	may be installed into user space by "make header_install" or
+	"make headers_install_all".  In order to support
+	"make headers_install_all", this target has to be able to run
+	on an unconfigured tree, or a tree configured for another
+	architecture.
+
+	It is run before "make archprepare" when run on the
+	architecture itself.
+
+
+--- 6.3 Add prerequisites to archprepare:
 
 	The archprepare: rule is used to list prerequisites that need to be
 	built before starting to descend down in the subdirectories.
@@ -990,7 +1004,7 @@ When kbuild executes, the following steps are followed (roughly):
 	generating offset header files.
 
 
---- 6.3 List directories to visit when descending
+--- 6.4 List directories to visit when descending
 
 	An arch Makefile cooperates with the top Makefile to define variables
 	which specify how to build the vmlinux file.  Note that there is no
@@ -1019,7 +1033,7 @@ When kbuild executes, the following steps are followed (roughly):
 		drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/
 
 
---- 6.4 Architecture-specific boot images
+--- 6.5 Architecture-specific boot images
 
 	An arch Makefile specifies goals that take the vmlinux file, compress
 	it, wrap it in bootstrapping code, and copy the resulting files
@@ -1070,7 +1084,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	When "make" is executed without arguments, bzImage will be built.
 
---- 6.5 Building non-kbuild targets
+--- 6.6 Building non-kbuild targets
 
     extra-y
 
@@ -1090,7 +1104,7 @@ When kbuild executes, the following steps are followed (roughly):
 	shall be built, but shall not be linked as part of built-in.o.
 
 
---- 6.6 Commands useful for building a boot image
+--- 6.7 Commands useful for building a boot image
 
 	Kbuild provides a few macros that are useful when building a
 	boot image.
@@ -1112,7 +1126,7 @@ When kbuild executes, the following steps are followed (roughly):
 	always be built.
 	Assignments to $(targets) are without $(obj)/ prefix.
 	if_changed may be used in conjunction with custom commands as
-	defined in 6.7 "Custom kbuild commands".
+	defined in 6.8 "Custom kbuild commands".
 
 	Note: It is a typical mistake to forget the FORCE prerequisite.
 	Another common pitfall is that whitespace is sometimes
@@ -1171,7 +1185,7 @@ When kbuild executes, the following steps are followed (roughly):
 		$(obj)/%.dtb: $(src)/%.dts
 			$(call cmd,dtc)
 
---- 6.7 Custom kbuild commands
+--- 6.8 Custom kbuild commands
 
 	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
 	of a command is normally displayed.
@@ -1198,7 +1212,7 @@ When kbuild executes, the following steps are followed (roughly):
 	will be displayed with "make KBUILD_VERBOSE=0".
 
 
---- 6.8 Preprocessing linker scripts
+--- 6.9 Preprocessing linker scripts
 
 	When the vmlinux image is built, the linker script
 	arch/$(ARCH)/kernel/vmlinux.lds is used.
@@ -1228,7 +1242,7 @@ When kbuild executes, the following steps are followed (roughly):
 	The kbuild infrastructure for *lds file are used in several
 	architecture-specific files.
 
---- 6.9 Generic header files
+--- 6.10 Generic header files
 
 	The directory include/asm-generic contains the header files
 	that may be shared between individual architectures.
diff --git a/Makefile b/Makefile
index dab8610..e5e0e07 100644
--- a/Makefile
+++ b/Makefile
@@ -442,7 +442,7 @@ asm-generic:
 
 no-dot-config-targets := clean mrproper distclean \
 			 cscope gtags TAGS tags help %docs check% coccicheck \
-			 include/linux/version.h headers_% \
+			 include/linux/version.h headers_% archheaders \
 			 kernelversion %src-pkg
 
 config-targets := 0
@@ -979,7 +979,7 @@ prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
 	$(cmd_crmodverdir)
 
-archprepare: prepare1 scripts_basic
+archprepare: archheaders prepare1 scripts_basic
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
@@ -1046,8 +1046,11 @@ hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 # If we do an all arch process set dst to asm-$(hdr-arch)
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
+PHONY += archheaders
+archheaders:
+
 PHONY += __headers
-__headers: include/linux/version.h scripts_basic asm-generic FORCE
+__headers: include/linux/version.h scripts_basic asm-generic archheaders FORCE
 	$(Q)$(MAKE) $(build)=scripts build_unifdef
 
 PHONY += headers_install_all
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 7730af6..28688e6 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -64,7 +64,8 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 
-KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include
+KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include \
+		   -I$(HOST_DIR)/include/generated
 
 # -Derrno=kernel_errno - This turns all kernel references to errno into
 # kernel_errno to separate them from the libc errno.  This allows -fno-common
@@ -96,6 +97,10 @@ endef
 
 KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
 
+archheaders:
+	$(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
+		ARCH=$(SUBARCH) O='$(objtree)' archheaders
+
 archprepare: include/generated/user_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
@@ -135,7 +140,7 @@ archclean:
 
 # Generated files
 
-$(HOST_DIR)/um/user-offsets.s: FORCE
+$(HOST_DIR)/um/user-offsets.s: __headers FORCE
 	$(Q)$(MAKE) $(build)=$(HOST_DIR)/um $@
 
 define filechk_gen-asm-offsets
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b02e509..209ba12 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -118,6 +118,12 @@ KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
 ###
+# Syscall table generation
+
+archheaders:
+	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
+
+###
 # Kernel objects
 
 head-y := arch/x86/kernel/head_$(BITS).o
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 52d0ccf..455646e 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
+obj-$(CONFIG_IA32_EMULATION) += nosyscall.o syscall_ia32.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a6253ec..72f853a 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -27,8 +27,6 @@
 
 	.section .entry.text, "ax"
 
-#define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
-
 	.macro IA32_ARG_FIXUP noebp=0
 	movl	%edi,%r8d
 	.if \noebp
@@ -453,9 +451,6 @@ ia32_badsys:
 	movq $-ENOSYS,%rax
 	jmp ia32_sysret
 
-quiet_ni_syscall:
-	movq $-ENOSYS,%rax
-	ret
 	CFI_ENDPROC
 	
 	.macro PTREGSCALL label, func, arg
@@ -499,357 +494,3 @@ ENTRY(ia32_ptregs_common)
 	jmp  ia32_sysret	/* misbalances the return cache */
 	CFI_ENDPROC
 END(ia32_ptregs_common)
-
-	.section .rodata,"a"
-	.align 8
-ia32_sys_call_table:
-	.quad sys_restart_syscall
-	.quad sys_exit
-	.quad stub32_fork
-	.quad sys_read
-	.quad sys_write
-	.quad compat_sys_open		/* 5 */
-	.quad sys_close
-	.quad sys32_waitpid
-	.quad sys_creat
-	.quad sys_link
-	.quad sys_unlink		/* 10 */
-	.quad stub32_execve
-	.quad sys_chdir
-	.quad compat_sys_time
-	.quad sys_mknod
-	.quad sys_chmod		/* 15 */
-	.quad sys_lchown16
-	.quad quiet_ni_syscall			/* old break syscall holder */
-	.quad sys_stat
-	.quad sys32_lseek
-	.quad sys_getpid		/* 20 */
-	.quad compat_sys_mount	/* mount  */
-	.quad sys_oldumount	/* old_umount  */
-	.quad sys_setuid16
-	.quad sys_getuid16
-	.quad compat_sys_stime	/* stime */		/* 25 */
-	.quad compat_sys_ptrace	/* ptrace */
-	.quad sys_alarm
-	.quad sys_fstat	/* (old)fstat */
-	.quad sys_pause
-	.quad compat_sys_utime	/* 30 */
-	.quad quiet_ni_syscall	/* old stty syscall holder */
-	.quad quiet_ni_syscall	/* old gtty syscall holder */
-	.quad sys_access
-	.quad sys_nice	
-	.quad quiet_ni_syscall	/* 35 */	/* old ftime syscall holder */
-	.quad sys_sync
-	.quad sys32_kill
-	.quad sys_rename
-	.quad sys_mkdir
-	.quad sys_rmdir		/* 40 */
-	.quad sys_dup
-	.quad sys_pipe
-	.quad compat_sys_times
-	.quad quiet_ni_syscall			/* old prof syscall holder */
-	.quad sys_brk		/* 45 */
-	.quad sys_setgid16
-	.quad sys_getgid16
-	.quad sys_signal
-	.quad sys_geteuid16
-	.quad sys_getegid16	/* 50 */
-	.quad sys_acct
-	.quad sys_umount			/* new_umount */
-	.quad quiet_ni_syscall			/* old lock syscall holder */
-	.quad compat_sys_ioctl
-	.quad compat_sys_fcntl64		/* 55 */
-	.quad quiet_ni_syscall			/* old mpx syscall holder */
-	.quad sys_setpgid
-	.quad quiet_ni_syscall			/* old ulimit syscall holder */
-	.quad sys_olduname
-	.quad sys_umask		/* 60 */
-	.quad sys_chroot
-	.quad compat_sys_ustat
-	.quad sys_dup2
-	.quad sys_getppid
-	.quad sys_getpgrp		/* 65 */
-	.quad sys_setsid
-	.quad sys32_sigaction
-	.quad sys_sgetmask
-	.quad sys_ssetmask
-	.quad sys_setreuid16	/* 70 */
-	.quad sys_setregid16
-	.quad sys32_sigsuspend
-	.quad compat_sys_sigpending
-	.quad sys_sethostname
-	.quad compat_sys_setrlimit	/* 75 */
-	.quad compat_sys_old_getrlimit	/* old_getrlimit */
-	.quad compat_sys_getrusage
-	.quad compat_sys_gettimeofday
-	.quad compat_sys_settimeofday
-	.quad sys_getgroups16	/* 80 */
-	.quad sys_setgroups16
-	.quad compat_sys_old_select
-	.quad sys_symlink
-	.quad sys_lstat
-	.quad sys_readlink		/* 85 */
-	.quad sys_uselib
-	.quad sys_swapon
-	.quad sys_reboot
-	.quad compat_sys_old_readdir
-	.quad sys32_mmap		/* 90 */
-	.quad sys_munmap
-	.quad sys_truncate
-	.quad sys_ftruncate
-	.quad sys_fchmod
-	.quad sys_fchown16		/* 95 */
-	.quad sys_getpriority
-	.quad sys_setpriority
-	.quad quiet_ni_syscall			/* old profil syscall holder */
-	.quad compat_sys_statfs
-	.quad compat_sys_fstatfs		/* 100 */
-	.quad sys_ioperm
-	.quad compat_sys_socketcall
-	.quad sys_syslog
-	.quad compat_sys_setitimer
-	.quad compat_sys_getitimer	/* 105 */
-	.quad compat_sys_newstat
-	.quad compat_sys_newlstat
-	.quad compat_sys_newfstat
-	.quad sys_uname
-	.quad stub32_iopl		/* 110 */
-	.quad sys_vhangup
-	.quad quiet_ni_syscall	/* old "idle" system call */
-	.quad sys32_vm86_warning	/* vm86old */ 
-	.quad compat_sys_wait4
-	.quad sys_swapoff		/* 115 */
-	.quad compat_sys_sysinfo
-	.quad sys32_ipc
-	.quad sys_fsync
-	.quad stub32_sigreturn
-	.quad stub32_clone		/* 120 */
-	.quad sys_setdomainname
-	.quad sys_newuname
-	.quad sys_modify_ldt
-	.quad compat_sys_adjtimex
-	.quad sys32_mprotect		/* 125 */
-	.quad compat_sys_sigprocmask
-	.quad quiet_ni_syscall		/* create_module */
-	.quad sys_init_module
-	.quad sys_delete_module
-	.quad quiet_ni_syscall		/* 130  get_kernel_syms */
-	.quad sys32_quotactl
-	.quad sys_getpgid
-	.quad sys_fchdir
-	.quad quiet_ni_syscall	/* bdflush */
-	.quad sys_sysfs		/* 135 */
-	.quad sys_personality
-	.quad quiet_ni_syscall	/* for afs_syscall */
-	.quad sys_setfsuid16
-	.quad sys_setfsgid16
-	.quad sys_llseek		/* 140 */
-	.quad compat_sys_getdents
-	.quad compat_sys_select
-	.quad sys_flock
-	.quad sys_msync
-	.quad compat_sys_readv		/* 145 */
-	.quad compat_sys_writev
-	.quad sys_getsid
-	.quad sys_fdatasync
-	.quad compat_sys_sysctl	/* sysctl */
-	.quad sys_mlock		/* 150 */
-	.quad sys_munlock
-	.quad sys_mlockall
-	.quad sys_munlockall
-	.quad sys_sched_setparam
-	.quad sys_sched_getparam   /* 155 */
-	.quad sys_sched_setscheduler
-	.quad sys_sched_getscheduler
-	.quad sys_sched_yield
-	.quad sys_sched_get_priority_max
-	.quad sys_sched_get_priority_min  /* 160 */
-	.quad sys32_sched_rr_get_interval
-	.quad compat_sys_nanosleep
-	.quad sys_mremap
-	.quad sys_setresuid16
-	.quad sys_getresuid16	/* 165 */
-	.quad sys32_vm86_warning	/* vm86 */ 
-	.quad quiet_ni_syscall	/* query_module */
-	.quad sys_poll
-	.quad quiet_ni_syscall /* old nfsservctl */
-	.quad sys_setresgid16	/* 170 */
-	.quad sys_getresgid16
-	.quad sys_prctl
-	.quad stub32_rt_sigreturn
-	.quad sys32_rt_sigaction
-	.quad sys32_rt_sigprocmask	/* 175 */
-	.quad sys32_rt_sigpending
-	.quad compat_sys_rt_sigtimedwait
-	.quad sys32_rt_sigqueueinfo
-	.quad sys_rt_sigsuspend
-	.quad sys32_pread		/* 180 */
-	.quad sys32_pwrite
-	.quad sys_chown16
-	.quad sys_getcwd
-	.quad sys_capget
-	.quad sys_capset
-	.quad stub32_sigaltstack
-	.quad sys32_sendfile
-	.quad quiet_ni_syscall		/* streams1 */
-	.quad quiet_ni_syscall		/* streams2 */
-	.quad stub32_vfork            /* 190 */
-	.quad compat_sys_getrlimit
-	.quad sys_mmap_pgoff
-	.quad sys32_truncate64
-	.quad sys32_ftruncate64
-	.quad sys32_stat64		/* 195 */
-	.quad sys32_lstat64
-	.quad sys32_fstat64
-	.quad sys_lchown
-	.quad sys_getuid
-	.quad sys_getgid		/* 200 */
-	.quad sys_geteuid
-	.quad sys_getegid
-	.quad sys_setreuid
-	.quad sys_setregid
-	.quad sys_getgroups	/* 205 */
-	.quad sys_setgroups
-	.quad sys_fchown
-	.quad sys_setresuid
-	.quad sys_getresuid
-	.quad sys_setresgid	/* 210 */
-	.quad sys_getresgid
-	.quad sys_chown
-	.quad sys_setuid
-	.quad sys_setgid
-	.quad sys_setfsuid		/* 215 */
-	.quad sys_setfsgid
-	.quad sys_pivot_root
-	.quad sys_mincore
-	.quad sys_madvise
-	.quad compat_sys_getdents64	/* 220 getdents64 */
-	.quad compat_sys_fcntl64	
-	.quad quiet_ni_syscall		/* tux */
-	.quad quiet_ni_syscall    	/* security */
-	.quad sys_gettid	
-	.quad sys32_readahead	/* 225 */
-	.quad sys_setxattr
-	.quad sys_lsetxattr
-	.quad sys_fsetxattr
-	.quad sys_getxattr
-	.quad sys_lgetxattr	/* 230 */
-	.quad sys_fgetxattr
-	.quad sys_listxattr
-	.quad sys_llistxattr
-	.quad sys_flistxattr
-	.quad sys_removexattr	/* 235 */
-	.quad sys_lremovexattr
-	.quad sys_fremovexattr
-	.quad sys_tkill
-	.quad sys_sendfile64 
-	.quad compat_sys_futex		/* 240 */
-	.quad compat_sys_sched_setaffinity
-	.quad compat_sys_sched_getaffinity
-	.quad sys_set_thread_area
-	.quad sys_get_thread_area
-	.quad compat_sys_io_setup	/* 245 */
-	.quad sys_io_destroy
-	.quad compat_sys_io_getevents
-	.quad compat_sys_io_submit
-	.quad sys_io_cancel
-	.quad sys32_fadvise64		/* 250 */
-	.quad quiet_ni_syscall 	/* free_huge_pages */
-	.quad sys_exit_group
-	.quad sys32_lookup_dcookie
-	.quad sys_epoll_create
-	.quad sys_epoll_ctl		/* 255 */
-	.quad sys_epoll_wait
-	.quad sys_remap_file_pages
-	.quad sys_set_tid_address
-	.quad compat_sys_timer_create
-	.quad compat_sys_timer_settime	/* 260 */
-	.quad compat_sys_timer_gettime
-	.quad sys_timer_getoverrun
-	.quad sys_timer_delete
-	.quad compat_sys_clock_settime
-	.quad compat_sys_clock_gettime	/* 265 */
-	.quad compat_sys_clock_getres
-	.quad compat_sys_clock_nanosleep
-	.quad compat_sys_statfs64
-	.quad compat_sys_fstatfs64
-	.quad sys_tgkill		/* 270 */
-	.quad compat_sys_utimes
-	.quad sys32_fadvise64_64
-	.quad quiet_ni_syscall	/* sys_vserver */
-	.quad sys_mbind
-	.quad compat_sys_get_mempolicy	/* 275 */
-	.quad sys_set_mempolicy
-	.quad compat_sys_mq_open
-	.quad sys_mq_unlink
-	.quad compat_sys_mq_timedsend
-	.quad compat_sys_mq_timedreceive	/* 280 */
-	.quad compat_sys_mq_notify
-	.quad compat_sys_mq_getsetattr
-	.quad compat_sys_kexec_load	/* reserved for kexec */
-	.quad compat_sys_waitid
-	.quad quiet_ni_syscall		/* 285: sys_altroot */
-	.quad sys_add_key
-	.quad sys_request_key
-	.quad sys_keyctl
-	.quad sys_ioprio_set
-	.quad sys_ioprio_get		/* 290 */
-	.quad sys_inotify_init
-	.quad sys_inotify_add_watch
-	.quad sys_inotify_rm_watch
-	.quad sys_migrate_pages
-	.quad compat_sys_openat		/* 295 */
-	.quad sys_mkdirat
-	.quad sys_mknodat
-	.quad sys_fchownat
-	.quad compat_sys_futimesat
-	.quad sys32_fstatat		/* 300 */
-	.quad sys_unlinkat
-	.quad sys_renameat
-	.quad sys_linkat
-	.quad sys_symlinkat
-	.quad sys_readlinkat		/* 305 */
-	.quad sys_fchmodat
-	.quad sys_faccessat
-	.quad compat_sys_pselect6
-	.quad compat_sys_ppoll
-	.quad sys_unshare		/* 310 */
-	.quad compat_sys_set_robust_list
-	.quad compat_sys_get_robust_list
-	.quad sys_splice
-	.quad sys32_sync_file_range
-	.quad sys_tee			/* 315 */
-	.quad compat_sys_vmsplice
-	.quad compat_sys_move_pages
-	.quad sys_getcpu
-	.quad sys_epoll_pwait
-	.quad compat_sys_utimensat	/* 320 */
-	.quad compat_sys_signalfd
-	.quad sys_timerfd_create
-	.quad sys_eventfd
-	.quad sys32_fallocate
-	.quad compat_sys_timerfd_settime	/* 325 */
-	.quad compat_sys_timerfd_gettime
-	.quad compat_sys_signalfd4
-	.quad sys_eventfd2
-	.quad sys_epoll_create1
-	.quad sys_dup3				/* 330 */
-	.quad sys_pipe2
-	.quad sys_inotify_init1
-	.quad compat_sys_preadv
-	.quad compat_sys_pwritev
-	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
-	.quad sys_perf_event_open
-	.quad compat_sys_recvmmsg
-	.quad sys_fanotify_init
-	.quad sys32_fanotify_mark
-	.quad sys_prlimit64		/* 340 */
-	.quad sys_name_to_handle_at
-	.quad compat_sys_open_by_handle_at
-	.quad compat_sys_clock_adjtime
-	.quad sys_syncfs
-	.quad compat_sys_sendmmsg	/* 345 */
-	.quad sys_setns
-	.quad compat_sys_process_vm_readv
-	.quad compat_sys_process_vm_writev
-ia32_syscall_end:
diff --git a/arch/x86/ia32/nosyscall.c b/arch/x86/ia32/nosyscall.c
new file mode 100644
index 0000000..51ecd5b
--- /dev/null
+++ b/arch/x86/ia32/nosyscall.c
@@ -0,0 +1,7 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+
+long compat_ni_syscall(void)
+{
+	return -ENOSYS;
+}
diff --git a/arch/x86/ia32/syscall_ia32.c b/arch/x86/ia32/syscall_ia32.c
new file mode 100644
index 0000000..4754ba0
--- /dev/null
+++ b/arch/x86/ia32/syscall_ia32.c
@@ -0,0 +1,25 @@
+/* System call table for ia32 emulation. */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <linux/cache.h>
+#include <asm/asm-offsets.h>
+
+#define __SYSCALL_I386(nr, sym, compat) extern asmlinkage void compat(void) ;
+#include <asm/syscalls_32.h>
+#undef __SYSCALL_I386
+
+#define __SYSCALL_I386(nr, sym, compat) [nr] = compat,
+
+typedef void (*sys_call_ptr_t)(void);
+
+extern void compat_ni_syscall(void);
+
+const sys_call_ptr_t ia32_sys_call_table[__NR_ia32_syscall_max+1] = {
+	/*
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_ia32_syscall_max] = &compat_ni_syscall,
+#include <asm/syscalls_32.h>
+};
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 6fa90a8..b57e6a4 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -19,7 +19,8 @@ header-y += processor-flags.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
 header-y += ucontext.h
-header-y += unistd_32.h
-header-y += unistd_64.h
 header-y += vm86.h
 header-y += vsyscall.h
+
+genhdr-y += unistd_32.h
+genhdr-y += unistd_64.h
diff --git a/arch/x86/include/asm/ia32_unistd.h b/arch/x86/include/asm/ia32_unistd.h
index 976f6ec..b0d5716 100644
--- a/arch/x86/include/asm/ia32_unistd.h
+++ b/arch/x86/include/asm/ia32_unistd.h
@@ -2,17 +2,10 @@
 #define _ASM_X86_IA32_UNISTD_H
 
 /*
- * This file contains the system call numbers of the ia32 port,
+ * This file contains the system call numbers of the ia32 compat ABI,
  * this is for the kernel only.
- * Only add syscalls here where some part of the kernel needs to know
- * the number. This should be otherwise in sync with asm-x86/unistd_32.h. -AK
  */
-
-#define __NR_ia32_restart_syscall 0
-#define __NR_ia32_exit		  1
-#define __NR_ia32_read		  3
-#define __NR_ia32_write		  4
-#define __NR_ia32_sigreturn	119
-#define __NR_ia32_rt_sigreturn	173
+#define __SYSCALL_ia32_NR(x) (x)
+#include <asm/unistd_32_ia32.h>
 
 #endif /* _ASM_X86_IA32_UNISTD_H */
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index c4a348f..d962e56 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -15,6 +15,7 @@
 
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <asm/asm-offsets.h>	/* For NR_syscalls */
 
 extern const unsigned long sys_call_table[];
 
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 2a58ed3..b4a3db7 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,13 +1,59 @@
+#ifndef _ASM_X86_UNISTD_H
+#define _ASM_X86_UNISTD_H 1
+
 #ifdef __KERNEL__
 # ifdef CONFIG_X86_32
-#  include "unistd_32.h"
+
+#  include <asm/unistd_32.h>
+#  define __ARCH_WANT_IPC_PARSE_VERSION
+#  define __ARCH_WANT_STAT64
+#  define __ARCH_WANT_SYS_OLD_MMAP
+#  define __ARCH_WANT_SYS_OLD_SELECT
+
 # else
-#  include "unistd_64.h"
+
+#  include <asm/unistd_64.h>
+#  define __ARCH_WANT_COMPAT_SYS_TIME
+
 # endif
+
+# define __ARCH_WANT_OLD_READDIR
+# define __ARCH_WANT_OLD_STAT
+# define __ARCH_WANT_SYS_ALARM
+# define __ARCH_WANT_SYS_FADVISE64
+# define __ARCH_WANT_SYS_GETHOSTNAME
+# define __ARCH_WANT_SYS_GETPGRP
+# define __ARCH_WANT_SYS_LLSEEK
+# define __ARCH_WANT_SYS_NICE
+# define __ARCH_WANT_SYS_OLDUMOUNT
+# define __ARCH_WANT_SYS_OLD_GETRLIMIT
+# define __ARCH_WANT_SYS_OLD_UNAME
+# define __ARCH_WANT_SYS_PAUSE
+# define __ARCH_WANT_SYS_RT_SIGACTION
+# define __ARCH_WANT_SYS_RT_SIGSUSPEND
+# define __ARCH_WANT_SYS_SGETMASK
+# define __ARCH_WANT_SYS_SIGNAL
+# define __ARCH_WANT_SYS_SIGPENDING
+# define __ARCH_WANT_SYS_SIGPROCMASK
+# define __ARCH_WANT_SYS_SOCKETCALL
+# define __ARCH_WANT_SYS_TIME
+# define __ARCH_WANT_SYS_UTIME
+# define __ARCH_WANT_SYS_WAITPID
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+# define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+
 #else
 # ifdef __i386__
-#  include "unistd_32.h"
+#  include <asm/unistd_32.h>
 # else
-#  include "unistd_64.h"
+#  include <asm/unistd_64.h>
 # endif
 #endif
+
+#endif /* _ASM_X86_UNISTD_H */
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
deleted file mode 100644
index 599c77d..0000000
--- a/arch/x86/include/asm/unistd_32.h
+++ /dev/null
@@ -1,401 +0,0 @@
-#ifndef _ASM_X86_UNISTD_32_H
-#define _ASM_X86_UNISTD_32_H
-
-/*
- * This file contains the system call numbers.
- */
-
-#define __NR_restart_syscall      0
-#define __NR_exit		  1
-#define __NR_fork		  2
-#define __NR_read		  3
-#define __NR_write		  4
-#define __NR_open		  5
-#define __NR_close		  6
-#define __NR_waitpid		  7
-#define __NR_creat		  8
-#define __NR_link		  9
-#define __NR_unlink		 10
-#define __NR_execve		 11
-#define __NR_chdir		 12
-#define __NR_time		 13
-#define __NR_mknod		 14
-#define __NR_chmod		 15
-#define __NR_lchown		 16
-#define __NR_break		 17
-#define __NR_oldstat		 18
-#define __NR_lseek		 19
-#define __NR_getpid		 20
-#define __NR_mount		 21
-#define __NR_umount		 22
-#define __NR_setuid		 23
-#define __NR_getuid		 24
-#define __NR_stime		 25
-#define __NR_ptrace		 26
-#define __NR_alarm		 27
-#define __NR_oldfstat		 28
-#define __NR_pause		 29
-#define __NR_utime		 30
-#define __NR_stty		 31
-#define __NR_gtty		 32
-#define __NR_access		 33
-#define __NR_nice		 34
-#define __NR_ftime		 35
-#define __NR_sync		 36
-#define __NR_kill		 37
-#define __NR_rename		 38
-#define __NR_mkdir		 39
-#define __NR_rmdir		 40
-#define __NR_dup		 41
-#define __NR_pipe		 42
-#define __NR_times		 43
-#define __NR_prof		 44
-#define __NR_brk		 45
-#define __NR_setgid		 46
-#define __NR_getgid		 47
-#define __NR_signal		 48
-#define __NR_geteuid		 49
-#define __NR_getegid		 50
-#define __NR_acct		 51
-#define __NR_umount2		 52
-#define __NR_lock		 53
-#define __NR_ioctl		 54
-#define __NR_fcntl		 55
-#define __NR_mpx		 56
-#define __NR_setpgid		 57
-#define __NR_ulimit		 58
-#define __NR_oldolduname	 59
-#define __NR_umask		 60
-#define __NR_chroot		 61
-#define __NR_ustat		 62
-#define __NR_dup2		 63
-#define __NR_getppid		 64
-#define __NR_getpgrp		 65
-#define __NR_setsid		 66
-#define __NR_sigaction		 67
-#define __NR_sgetmask		 68
-#define __NR_ssetmask		 69
-#define __NR_setreuid		 70
-#define __NR_setregid		 71
-#define __NR_sigsuspend		 72
-#define __NR_sigpending		 73
-#define __NR_sethostname	 74
-#define __NR_setrlimit		 75
-#define __NR_getrlimit		 76   /* Back compatible 2Gig limited rlimit */
-#define __NR_getrusage		 77
-#define __NR_gettimeofday	 78
-#define __NR_settimeofday	 79
-#define __NR_getgroups		 80
-#define __NR_setgroups		 81
-#define __NR_select		 82
-#define __NR_symlink		 83
-#define __NR_oldlstat		 84
-#define __NR_readlink		 85
-#define __NR_uselib		 86
-#define __NR_swapon		 87
-#define __NR_reboot		 88
-#define __NR_readdir		 89
-#define __NR_mmap		 90
-#define __NR_munmap		 91
-#define __NR_truncate		 92
-#define __NR_ftruncate		 93
-#define __NR_fchmod		 94
-#define __NR_fchown		 95
-#define __NR_getpriority	 96
-#define __NR_setpriority	 97
-#define __NR_profil		 98
-#define __NR_statfs		 99
-#define __NR_fstatfs		100
-#define __NR_ioperm		101
-#define __NR_socketcall		102
-#define __NR_syslog		103
-#define __NR_setitimer		104
-#define __NR_getitimer		105
-#define __NR_stat		106
-#define __NR_lstat		107
-#define __NR_fstat		108
-#define __NR_olduname		109
-#define __NR_iopl		110
-#define __NR_vhangup		111
-#define __NR_idle		112
-#define __NR_vm86old		113
-#define __NR_wait4		114
-#define __NR_swapoff		115
-#define __NR_sysinfo		116
-#define __NR_ipc		117
-#define __NR_fsync		118
-#define __NR_sigreturn		119
-#define __NR_clone		120
-#define __NR_setdomainname	121
-#define __NR_uname		122
-#define __NR_modify_ldt		123
-#define __NR_adjtimex		124
-#define __NR_mprotect		125
-#define __NR_sigprocmask	126
-#define __NR_create_module	127
-#define __NR_init_module	128
-#define __NR_delete_module	129
-#define __NR_get_kernel_syms	130
-#define __NR_quotactl		131
-#define __NR_getpgid		132
-#define __NR_fchdir		133
-#define __NR_bdflush		134
-#define __NR_sysfs		135
-#define __NR_personality	136
-#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
-#define __NR_setfsuid		138
-#define __NR_setfsgid		139
-#define __NR__llseek		140
-#define __NR_getdents		141
-#define __NR__newselect		142
-#define __NR_flock		143
-#define __NR_msync		144
-#define __NR_readv		145
-#define __NR_writev		146
-#define __NR_getsid		147
-#define __NR_fdatasync		148
-#define __NR__sysctl		149
-#define __NR_mlock		150
-#define __NR_munlock		151
-#define __NR_mlockall		152
-#define __NR_munlockall		153
-#define __NR_sched_setparam		154
-#define __NR_sched_getparam		155
-#define __NR_sched_setscheduler		156
-#define __NR_sched_getscheduler		157
-#define __NR_sched_yield		158
-#define __NR_sched_get_priority_max	159
-#define __NR_sched_get_priority_min	160
-#define __NR_sched_rr_get_interval	161
-#define __NR_nanosleep		162
-#define __NR_mremap		163
-#define __NR_setresuid		164
-#define __NR_getresuid		165
-#define __NR_vm86		166
-#define __NR_query_module	167
-#define __NR_poll		168
-#define __NR_nfsservctl		169
-#define __NR_setresgid		170
-#define __NR_getresgid		171
-#define __NR_prctl              172
-#define __NR_rt_sigreturn	173
-#define __NR_rt_sigaction	174
-#define __NR_rt_sigprocmask	175
-#define __NR_rt_sigpending	176
-#define __NR_rt_sigtimedwait	177
-#define __NR_rt_sigqueueinfo	178
-#define __NR_rt_sigsuspend	179
-#define __NR_pread64		180
-#define __NR_pwrite64		181
-#define __NR_chown		182
-#define __NR_getcwd		183
-#define __NR_capget		184
-#define __NR_capset		185
-#define __NR_sigaltstack	186
-#define __NR_sendfile		187
-#define __NR_getpmsg		188	/* some people actually want streams */
-#define __NR_putpmsg		189	/* some people actually want streams */
-#define __NR_vfork		190
-#define __NR_ugetrlimit		191	/* SuS compliant getrlimit */
-#define __NR_mmap2		192
-#define __NR_truncate64		193
-#define __NR_ftruncate64	194
-#define __NR_stat64		195
-#define __NR_lstat64		196
-#define __NR_fstat64		197
-#define __NR_lchown32		198
-#define __NR_getuid32		199
-#define __NR_getgid32		200
-#define __NR_geteuid32		201
-#define __NR_getegid32		202
-#define __NR_setreuid32		203
-#define __NR_setregid32		204
-#define __NR_getgroups32	205
-#define __NR_setgroups32	206
-#define __NR_fchown32		207
-#define __NR_setresuid32	208
-#define __NR_getresuid32	209
-#define __NR_setresgid32	210
-#define __NR_getresgid32	211
-#define __NR_chown32		212
-#define __NR_setuid32		213
-#define __NR_setgid32		214
-#define __NR_setfsuid32		215
-#define __NR_setfsgid32		216
-#define __NR_pivot_root		217
-#define __NR_mincore		218
-#define __NR_madvise		219
-#define __NR_madvise1		219	/* delete when C lib stub is removed */
-#define __NR_getdents64		220
-#define __NR_fcntl64		221
-/* 223 is unused */
-#define __NR_gettid		224
-#define __NR_readahead		225
-#define __NR_setxattr		226
-#define __NR_lsetxattr		227
-#define __NR_fsetxattr		228
-#define __NR_getxattr		229
-#define __NR_lgetxattr		230
-#define __NR_fgetxattr		231
-#define __NR_listxattr		232
-#define __NR_llistxattr		233
-#define __NR_flistxattr		234
-#define __NR_removexattr	235
-#define __NR_lremovexattr	236
-#define __NR_fremovexattr	237
-#define __NR_tkill		238
-#define __NR_sendfile64		239
-#define __NR_futex		240
-#define __NR_sched_setaffinity	241
-#define __NR_sched_getaffinity	242
-#define __NR_set_thread_area	243
-#define __NR_get_thread_area	244
-#define __NR_io_setup		245
-#define __NR_io_destroy		246
-#define __NR_io_getevents	247
-#define __NR_io_submit		248
-#define __NR_io_cancel		249
-#define __NR_fadvise64		250
-/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
-#define __NR_exit_group		252
-#define __NR_lookup_dcookie	253
-#define __NR_epoll_create	254
-#define __NR_epoll_ctl		255
-#define __NR_epoll_wait		256
-#define __NR_remap_file_pages	257
-#define __NR_set_tid_address	258
-#define __NR_timer_create	259
-#define __NR_timer_settime	(__NR_timer_create+1)
-#define __NR_timer_gettime	(__NR_timer_create+2)
-#define __NR_timer_getoverrun	(__NR_timer_create+3)
-#define __NR_timer_delete	(__NR_timer_create+4)
-#define __NR_clock_settime	(__NR_timer_create+5)
-#define __NR_clock_gettime	(__NR_timer_create+6)
-#define __NR_clock_getres	(__NR_timer_create+7)
-#define __NR_clock_nanosleep	(__NR_timer_create+8)
-#define __NR_statfs64		268
-#define __NR_fstatfs64		269
-#define __NR_tgkill		270
-#define __NR_utimes		271
-#define __NR_fadvise64_64	272
-#define __NR_vserver		273
-#define __NR_mbind		274
-#define __NR_get_mempolicy	275
-#define __NR_set_mempolicy	276
-#define __NR_mq_open 		277
-#define __NR_mq_unlink		(__NR_mq_open+1)
-#define __NR_mq_timedsend	(__NR_mq_open+2)
-#define __NR_mq_timedreceive	(__NR_mq_open+3)
-#define __NR_mq_notify		(__NR_mq_open+4)
-#define __NR_mq_getsetattr	(__NR_mq_open+5)
-#define __NR_kexec_load		283
-#define __NR_waitid		284
-/* #define __NR_sys_setaltroot	285 */
-#define __NR_add_key		286
-#define __NR_request_key	287
-#define __NR_keyctl		288
-#define __NR_ioprio_set		289
-#define __NR_ioprio_get		290
-#define __NR_inotify_init	291
-#define __NR_inotify_add_watch	292
-#define __NR_inotify_rm_watch	293
-#define __NR_migrate_pages	294
-#define __NR_openat		295
-#define __NR_mkdirat		296
-#define __NR_mknodat		297
-#define __NR_fchownat		298
-#define __NR_futimesat		299
-#define __NR_fstatat64		300
-#define __NR_unlinkat		301
-#define __NR_renameat		302
-#define __NR_linkat		303
-#define __NR_symlinkat		304
-#define __NR_readlinkat		305
-#define __NR_fchmodat		306
-#define __NR_faccessat		307
-#define __NR_pselect6		308
-#define __NR_ppoll		309
-#define __NR_unshare		310
-#define __NR_set_robust_list	311
-#define __NR_get_robust_list	312
-#define __NR_splice		313
-#define __NR_sync_file_range	314
-#define __NR_tee		315
-#define __NR_vmsplice		316
-#define __NR_move_pages		317
-#define __NR_getcpu		318
-#define __NR_epoll_pwait	319
-#define __NR_utimensat		320
-#define __NR_signalfd		321
-#define __NR_timerfd_create	322
-#define __NR_eventfd		323
-#define __NR_fallocate		324
-#define __NR_timerfd_settime	325
-#define __NR_timerfd_gettime	326
-#define __NR_signalfd4		327
-#define __NR_eventfd2		328
-#define __NR_epoll_create1	329
-#define __NR_dup3		330
-#define __NR_pipe2		331
-#define __NR_inotify_init1	332
-#define __NR_preadv		333
-#define __NR_pwritev		334
-#define __NR_rt_tgsigqueueinfo	335
-#define __NR_perf_event_open	336
-#define __NR_recvmmsg		337
-#define __NR_fanotify_init	338
-#define __NR_fanotify_mark	339
-#define __NR_prlimit64		340
-#define __NR_name_to_handle_at	341
-#define __NR_open_by_handle_at  342
-#define __NR_clock_adjtime	343
-#define __NR_syncfs             344
-#define __NR_sendmmsg		345
-#define __NR_setns		346
-#define __NR_process_vm_readv	347
-#define __NR_process_vm_writev	348
-
-#ifdef __KERNEL__
-
-#define NR_syscalls 349
-
-#define __ARCH_WANT_IPC_PARSE_VERSION
-#define __ARCH_WANT_OLD_READDIR
-#define __ARCH_WANT_OLD_STAT
-#define __ARCH_WANT_STAT64
-#define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_GETHOSTNAME
-#define __ARCH_WANT_SYS_IPC
-#define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
-#define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
-#define __ARCH_WANT_SYS_NICE
-#define __ARCH_WANT_SYS_OLD_GETRLIMIT
-#define __ARCH_WANT_SYS_OLD_UNAME
-#define __ARCH_WANT_SYS_OLD_MMAP
-#define __ARCH_WANT_SYS_OLD_SELECT
-#define __ARCH_WANT_SYS_OLDUMOUNT
-#define __ARCH_WANT_SYS_SIGPENDING
-#define __ARCH_WANT_SYS_SIGPROCMASK
-#define __ARCH_WANT_SYS_RT_SIGACTION
-#define __ARCH_WANT_SYS_RT_SIGSUSPEND
-
-/*
- * "Conditional" syscalls
- *
- * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
- * but it doesn't work on all toolchains, so we just do it by hand
- */
-#ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
-#endif
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_X86_UNISTD_32_H */
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
deleted file mode 100644
index 0431f19..0000000
--- a/arch/x86/include/asm/unistd_64.h
+++ /dev/null
@@ -1,732 +0,0 @@
-#ifndef _ASM_X86_UNISTD_64_H
-#define _ASM_X86_UNISTD_64_H
-
-#ifndef __SYSCALL
-#define __SYSCALL(a, b)
-#endif
-
-/*
- * This file contains the system call numbers.
- *
- * Note: holes are not allowed.
- */
-
-/* at least 8 syscall per cacheline */
-#define __NR_read				0
-__SYSCALL(__NR_read, sys_read)
-#define __NR_write				1
-__SYSCALL(__NR_write, sys_write)
-#define __NR_open				2
-__SYSCALL(__NR_open, sys_open)
-#define __NR_close				3
-__SYSCALL(__NR_close, sys_close)
-#define __NR_stat				4
-__SYSCALL(__NR_stat, sys_newstat)
-#define __NR_fstat				5
-__SYSCALL(__NR_fstat, sys_newfstat)
-#define __NR_lstat				6
-__SYSCALL(__NR_lstat, sys_newlstat)
-#define __NR_poll				7
-__SYSCALL(__NR_poll, sys_poll)
-
-#define __NR_lseek				8
-__SYSCALL(__NR_lseek, sys_lseek)
-#define __NR_mmap				9
-__SYSCALL(__NR_mmap, sys_mmap)
-#define __NR_mprotect				10
-__SYSCALL(__NR_mprotect, sys_mprotect)
-#define __NR_munmap				11
-__SYSCALL(__NR_munmap, sys_munmap)
-#define __NR_brk				12
-__SYSCALL(__NR_brk, sys_brk)
-#define __NR_rt_sigaction			13
-__SYSCALL(__NR_rt_sigaction, sys_rt_sigaction)
-#define __NR_rt_sigprocmask			14
-__SYSCALL(__NR_rt_sigprocmask, sys_rt_sigprocmask)
-#define __NR_rt_sigreturn			15
-__SYSCALL(__NR_rt_sigreturn, stub_rt_sigreturn)
-
-#define __NR_ioctl				16
-__SYSCALL(__NR_ioctl, sys_ioctl)
-#define __NR_pread64				17
-__SYSCALL(__NR_pread64, sys_pread64)
-#define __NR_pwrite64				18
-__SYSCALL(__NR_pwrite64, sys_pwrite64)
-#define __NR_readv				19
-__SYSCALL(__NR_readv, sys_readv)
-#define __NR_writev				20
-__SYSCALL(__NR_writev, sys_writev)
-#define __NR_access				21
-__SYSCALL(__NR_access, sys_access)
-#define __NR_pipe				22
-__SYSCALL(__NR_pipe, sys_pipe)
-#define __NR_select				23
-__SYSCALL(__NR_select, sys_select)
-
-#define __NR_sched_yield			24
-__SYSCALL(__NR_sched_yield, sys_sched_yield)
-#define __NR_mremap				25
-__SYSCALL(__NR_mremap, sys_mremap)
-#define __NR_msync				26
-__SYSCALL(__NR_msync, sys_msync)
-#define __NR_mincore				27
-__SYSCALL(__NR_mincore, sys_mincore)
-#define __NR_madvise				28
-__SYSCALL(__NR_madvise, sys_madvise)
-#define __NR_shmget				29
-__SYSCALL(__NR_shmget, sys_shmget)
-#define __NR_shmat				30
-__SYSCALL(__NR_shmat, sys_shmat)
-#define __NR_shmctl				31
-__SYSCALL(__NR_shmctl, sys_shmctl)
-
-#define __NR_dup				32
-__SYSCALL(__NR_dup, sys_dup)
-#define __NR_dup2				33
-__SYSCALL(__NR_dup2, sys_dup2)
-#define __NR_pause				34
-__SYSCALL(__NR_pause, sys_pause)
-#define __NR_nanosleep				35
-__SYSCALL(__NR_nanosleep, sys_nanosleep)
-#define __NR_getitimer				36
-__SYSCALL(__NR_getitimer, sys_getitimer)
-#define __NR_alarm				37
-__SYSCALL(__NR_alarm, sys_alarm)
-#define __NR_setitimer				38
-__SYSCALL(__NR_setitimer, sys_setitimer)
-#define __NR_getpid				39
-__SYSCALL(__NR_getpid, sys_getpid)
-
-#define __NR_sendfile				40
-__SYSCALL(__NR_sendfile, sys_sendfile64)
-#define __NR_socket				41
-__SYSCALL(__NR_socket, sys_socket)
-#define __NR_connect				42
-__SYSCALL(__NR_connect, sys_connect)
-#define __NR_accept				43
-__SYSCALL(__NR_accept, sys_accept)
-#define __NR_sendto				44
-__SYSCALL(__NR_sendto, sys_sendto)
-#define __NR_recvfrom				45
-__SYSCALL(__NR_recvfrom, sys_recvfrom)
-#define __NR_sendmsg				46
-__SYSCALL(__NR_sendmsg, sys_sendmsg)
-#define __NR_recvmsg				47
-__SYSCALL(__NR_recvmsg, sys_recvmsg)
-
-#define __NR_shutdown				48
-__SYSCALL(__NR_shutdown, sys_shutdown)
-#define __NR_bind				49
-__SYSCALL(__NR_bind, sys_bind)
-#define __NR_listen				50
-__SYSCALL(__NR_listen, sys_listen)
-#define __NR_getsockname			51
-__SYSCALL(__NR_getsockname, sys_getsockname)
-#define __NR_getpeername			52
-__SYSCALL(__NR_getpeername, sys_getpeername)
-#define __NR_socketpair				53
-__SYSCALL(__NR_socketpair, sys_socketpair)
-#define __NR_setsockopt				54
-__SYSCALL(__NR_setsockopt, sys_setsockopt)
-#define __NR_getsockopt				55
-__SYSCALL(__NR_getsockopt, sys_getsockopt)
-
-#define __NR_clone				56
-__SYSCALL(__NR_clone, stub_clone)
-#define __NR_fork				57
-__SYSCALL(__NR_fork, stub_fork)
-#define __NR_vfork				58
-__SYSCALL(__NR_vfork, stub_vfork)
-#define __NR_execve				59
-__SYSCALL(__NR_execve, stub_execve)
-#define __NR_exit				60
-__SYSCALL(__NR_exit, sys_exit)
-#define __NR_wait4				61
-__SYSCALL(__NR_wait4, sys_wait4)
-#define __NR_kill				62
-__SYSCALL(__NR_kill, sys_kill)
-#define __NR_uname				63
-__SYSCALL(__NR_uname, sys_newuname)
-
-#define __NR_semget				64
-__SYSCALL(__NR_semget, sys_semget)
-#define __NR_semop				65
-__SYSCALL(__NR_semop, sys_semop)
-#define __NR_semctl				66
-__SYSCALL(__NR_semctl, sys_semctl)
-#define __NR_shmdt				67
-__SYSCALL(__NR_shmdt, sys_shmdt)
-#define __NR_msgget				68
-__SYSCALL(__NR_msgget, sys_msgget)
-#define __NR_msgsnd				69
-__SYSCALL(__NR_msgsnd, sys_msgsnd)
-#define __NR_msgrcv				70
-__SYSCALL(__NR_msgrcv, sys_msgrcv)
-#define __NR_msgctl				71
-__SYSCALL(__NR_msgctl, sys_msgctl)
-
-#define __NR_fcntl				72
-__SYSCALL(__NR_fcntl, sys_fcntl)
-#define __NR_flock				73
-__SYSCALL(__NR_flock, sys_flock)
-#define __NR_fsync				74
-__SYSCALL(__NR_fsync, sys_fsync)
-#define __NR_fdatasync				75
-__SYSCALL(__NR_fdatasync, sys_fdatasync)
-#define __NR_truncate				76
-__SYSCALL(__NR_truncate, sys_truncate)
-#define __NR_ftruncate				77
-__SYSCALL(__NR_ftruncate, sys_ftruncate)
-#define __NR_getdents				78
-__SYSCALL(__NR_getdents, sys_getdents)
-#define __NR_getcwd				79
-__SYSCALL(__NR_getcwd, sys_getcwd)
-
-#define __NR_chdir				80
-__SYSCALL(__NR_chdir, sys_chdir)
-#define __NR_fchdir				81
-__SYSCALL(__NR_fchdir, sys_fchdir)
-#define __NR_rename				82
-__SYSCALL(__NR_rename, sys_rename)
-#define __NR_mkdir				83
-__SYSCALL(__NR_mkdir, sys_mkdir)
-#define __NR_rmdir				84
-__SYSCALL(__NR_rmdir, sys_rmdir)
-#define __NR_creat				85
-__SYSCALL(__NR_creat, sys_creat)
-#define __NR_link				86
-__SYSCALL(__NR_link, sys_link)
-#define __NR_unlink				87
-__SYSCALL(__NR_unlink, sys_unlink)
-
-#define __NR_symlink				88
-__SYSCALL(__NR_symlink, sys_symlink)
-#define __NR_readlink				89
-__SYSCALL(__NR_readlink, sys_readlink)
-#define __NR_chmod				90
-__SYSCALL(__NR_chmod, sys_chmod)
-#define __NR_fchmod				91
-__SYSCALL(__NR_fchmod, sys_fchmod)
-#define __NR_chown				92
-__SYSCALL(__NR_chown, sys_chown)
-#define __NR_fchown				93
-__SYSCALL(__NR_fchown, sys_fchown)
-#define __NR_lchown				94
-__SYSCALL(__NR_lchown, sys_lchown)
-#define __NR_umask				95
-__SYSCALL(__NR_umask, sys_umask)
-
-#define __NR_gettimeofday			96
-__SYSCALL(__NR_gettimeofday, sys_gettimeofday)
-#define __NR_getrlimit				97
-__SYSCALL(__NR_getrlimit, sys_getrlimit)
-#define __NR_getrusage				98
-__SYSCALL(__NR_getrusage, sys_getrusage)
-#define __NR_sysinfo				99
-__SYSCALL(__NR_sysinfo, sys_sysinfo)
-#define __NR_times				100
-__SYSCALL(__NR_times, sys_times)
-#define __NR_ptrace				101
-__SYSCALL(__NR_ptrace, sys_ptrace)
-#define __NR_getuid				102
-__SYSCALL(__NR_getuid, sys_getuid)
-#define __NR_syslog				103
-__SYSCALL(__NR_syslog, sys_syslog)
-
-/* at the very end the stuff that never runs during the benchmarks */
-#define __NR_getgid				104
-__SYSCALL(__NR_getgid, sys_getgid)
-#define __NR_setuid				105
-__SYSCALL(__NR_setuid, sys_setuid)
-#define __NR_setgid				106
-__SYSCALL(__NR_setgid, sys_setgid)
-#define __NR_geteuid				107
-__SYSCALL(__NR_geteuid, sys_geteuid)
-#define __NR_getegid				108
-__SYSCALL(__NR_getegid, sys_getegid)
-#define __NR_setpgid				109
-__SYSCALL(__NR_setpgid, sys_setpgid)
-#define __NR_getppid				110
-__SYSCALL(__NR_getppid, sys_getppid)
-#define __NR_getpgrp				111
-__SYSCALL(__NR_getpgrp, sys_getpgrp)
-
-#define __NR_setsid				112
-__SYSCALL(__NR_setsid, sys_setsid)
-#define __NR_setreuid				113
-__SYSCALL(__NR_setreuid, sys_setreuid)
-#define __NR_setregid				114
-__SYSCALL(__NR_setregid, sys_setregid)
-#define __NR_getgroups				115
-__SYSCALL(__NR_getgroups, sys_getgroups)
-#define __NR_setgroups				116
-__SYSCALL(__NR_setgroups, sys_setgroups)
-#define __NR_setresuid				117
-__SYSCALL(__NR_setresuid, sys_setresuid)
-#define __NR_getresuid				118
-__SYSCALL(__NR_getresuid, sys_getresuid)
-#define __NR_setresgid				119
-__SYSCALL(__NR_setresgid, sys_setresgid)
-
-#define __NR_getresgid				120
-__SYSCALL(__NR_getresgid, sys_getresgid)
-#define __NR_getpgid				121
-__SYSCALL(__NR_getpgid, sys_getpgid)
-#define __NR_setfsuid				122
-__SYSCALL(__NR_setfsuid, sys_setfsuid)
-#define __NR_setfsgid				123
-__SYSCALL(__NR_setfsgid, sys_setfsgid)
-#define __NR_getsid				124
-__SYSCALL(__NR_getsid, sys_getsid)
-#define __NR_capget				125
-__SYSCALL(__NR_capget, sys_capget)
-#define __NR_capset				126
-__SYSCALL(__NR_capset, sys_capset)
-
-#define __NR_rt_sigpending			127
-__SYSCALL(__NR_rt_sigpending, sys_rt_sigpending)
-#define __NR_rt_sigtimedwait			128
-__SYSCALL(__NR_rt_sigtimedwait, sys_rt_sigtimedwait)
-#define __NR_rt_sigqueueinfo			129
-__SYSCALL(__NR_rt_sigqueueinfo, sys_rt_sigqueueinfo)
-#define __NR_rt_sigsuspend			130
-__SYSCALL(__NR_rt_sigsuspend, sys_rt_sigsuspend)
-#define __NR_sigaltstack			131
-__SYSCALL(__NR_sigaltstack, stub_sigaltstack)
-#define __NR_utime				132
-__SYSCALL(__NR_utime, sys_utime)
-#define __NR_mknod				133
-__SYSCALL(__NR_mknod, sys_mknod)
-
-/* Only needed for a.out */
-#define __NR_uselib				134
-__SYSCALL(__NR_uselib, sys_ni_syscall)
-#define __NR_personality			135
-__SYSCALL(__NR_personality, sys_personality)
-
-#define __NR_ustat				136
-__SYSCALL(__NR_ustat, sys_ustat)
-#define __NR_statfs				137
-__SYSCALL(__NR_statfs, sys_statfs)
-#define __NR_fstatfs				138
-__SYSCALL(__NR_fstatfs, sys_fstatfs)
-#define __NR_sysfs				139
-__SYSCALL(__NR_sysfs, sys_sysfs)
-
-#define __NR_getpriority			140
-__SYSCALL(__NR_getpriority, sys_getpriority)
-#define __NR_setpriority			141
-__SYSCALL(__NR_setpriority, sys_setpriority)
-#define __NR_sched_setparam			142
-__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
-#define __NR_sched_getparam			143
-__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
-#define __NR_sched_setscheduler			144
-__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
-#define __NR_sched_getscheduler			145
-__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
-#define __NR_sched_get_priority_max		146
-__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
-#define __NR_sched_get_priority_min		147
-__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
-#define __NR_sched_rr_get_interval		148
-__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval)
-
-#define __NR_mlock				149
-__SYSCALL(__NR_mlock, sys_mlock)
-#define __NR_munlock				150
-__SYSCALL(__NR_munlock, sys_munlock)
-#define __NR_mlockall				151
-__SYSCALL(__NR_mlockall, sys_mlockall)
-#define __NR_munlockall				152
-__SYSCALL(__NR_munlockall, sys_munlockall)
-
-#define __NR_vhangup				153
-__SYSCALL(__NR_vhangup, sys_vhangup)
-
-#define __NR_modify_ldt				154
-__SYSCALL(__NR_modify_ldt, sys_modify_ldt)
-
-#define __NR_pivot_root				155
-__SYSCALL(__NR_pivot_root, sys_pivot_root)
-
-#define __NR__sysctl				156
-__SYSCALL(__NR__sysctl, sys_sysctl)
-
-#define __NR_prctl				157
-__SYSCALL(__NR_prctl, sys_prctl)
-#define __NR_arch_prctl				158
-__SYSCALL(__NR_arch_prctl, sys_arch_prctl)
-
-#define __NR_adjtimex				159
-__SYSCALL(__NR_adjtimex, sys_adjtimex)
-
-#define __NR_setrlimit				160
-__SYSCALL(__NR_setrlimit, sys_setrlimit)
-
-#define __NR_chroot				161
-__SYSCALL(__NR_chroot, sys_chroot)
-
-#define __NR_sync				162
-__SYSCALL(__NR_sync, sys_sync)
-
-#define __NR_acct				163
-__SYSCALL(__NR_acct, sys_acct)
-
-#define __NR_settimeofday			164
-__SYSCALL(__NR_settimeofday, sys_settimeofday)
-
-#define __NR_mount				165
-__SYSCALL(__NR_mount, sys_mount)
-#define __NR_umount2				166
-__SYSCALL(__NR_umount2, sys_umount)
-
-#define __NR_swapon				167
-__SYSCALL(__NR_swapon, sys_swapon)
-#define __NR_swapoff				168
-__SYSCALL(__NR_swapoff, sys_swapoff)
-
-#define __NR_reboot				169
-__SYSCALL(__NR_reboot, sys_reboot)
-
-#define __NR_sethostname			170
-__SYSCALL(__NR_sethostname, sys_sethostname)
-#define __NR_setdomainname			171
-__SYSCALL(__NR_setdomainname, sys_setdomainname)
-
-#define __NR_iopl				172
-__SYSCALL(__NR_iopl, stub_iopl)
-#define __NR_ioperm				173
-__SYSCALL(__NR_ioperm, sys_ioperm)
-
-#define __NR_create_module			174
-__SYSCALL(__NR_create_module, sys_ni_syscall)
-#define __NR_init_module			175
-__SYSCALL(__NR_init_module, sys_init_module)
-#define __NR_delete_module			176
-__SYSCALL(__NR_delete_module, sys_delete_module)
-#define __NR_get_kernel_syms			177
-__SYSCALL(__NR_get_kernel_syms, sys_ni_syscall)
-#define __NR_query_module			178
-__SYSCALL(__NR_query_module, sys_ni_syscall)
-
-#define __NR_quotactl				179
-__SYSCALL(__NR_quotactl, sys_quotactl)
-
-#define __NR_nfsservctl				180
-__SYSCALL(__NR_nfsservctl, sys_ni_syscall)
-
-/* reserved for LiS/STREAMS */
-#define __NR_getpmsg				181
-__SYSCALL(__NR_getpmsg, sys_ni_syscall)
-#define __NR_putpmsg				182
-__SYSCALL(__NR_putpmsg, sys_ni_syscall)
-
-/* reserved for AFS */
-#define __NR_afs_syscall			183
-__SYSCALL(__NR_afs_syscall, sys_ni_syscall)
-
-/* reserved for tux */
-#define __NR_tuxcall				184
-__SYSCALL(__NR_tuxcall, sys_ni_syscall)
-
-#define __NR_security				185
-__SYSCALL(__NR_security, sys_ni_syscall)
-
-#define __NR_gettid				186
-__SYSCALL(__NR_gettid, sys_gettid)
-
-#define __NR_readahead				187
-__SYSCALL(__NR_readahead, sys_readahead)
-#define __NR_setxattr				188
-__SYSCALL(__NR_setxattr, sys_setxattr)
-#define __NR_lsetxattr				189
-__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
-#define __NR_fsetxattr				190
-__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
-#define __NR_getxattr				191
-__SYSCALL(__NR_getxattr, sys_getxattr)
-#define __NR_lgetxattr				192
-__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
-#define __NR_fgetxattr				193
-__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
-#define __NR_listxattr				194
-__SYSCALL(__NR_listxattr, sys_listxattr)
-#define __NR_llistxattr				195
-__SYSCALL(__NR_llistxattr, sys_llistxattr)
-#define __NR_flistxattr				196
-__SYSCALL(__NR_flistxattr, sys_flistxattr)
-#define __NR_removexattr			197
-__SYSCALL(__NR_removexattr, sys_removexattr)
-#define __NR_lremovexattr			198
-__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
-#define __NR_fremovexattr			199
-__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
-#define __NR_tkill				200
-__SYSCALL(__NR_tkill, sys_tkill)
-#define __NR_time				201
-__SYSCALL(__NR_time, sys_time)
-#define __NR_futex				202
-__SYSCALL(__NR_futex, sys_futex)
-#define __NR_sched_setaffinity			203
-__SYSCALL(__NR_sched_setaffinity, sys_sched_setaffinity)
-#define __NR_sched_getaffinity			204
-__SYSCALL(__NR_sched_getaffinity, sys_sched_getaffinity)
-#define __NR_set_thread_area			205
-__SYSCALL(__NR_set_thread_area, sys_ni_syscall)	/* use arch_prctl */
-#define __NR_io_setup				206
-__SYSCALL(__NR_io_setup, sys_io_setup)
-#define __NR_io_destroy				207
-__SYSCALL(__NR_io_destroy, sys_io_destroy)
-#define __NR_io_getevents			208
-__SYSCALL(__NR_io_getevents, sys_io_getevents)
-#define __NR_io_submit				209
-__SYSCALL(__NR_io_submit, sys_io_submit)
-#define __NR_io_cancel				210
-__SYSCALL(__NR_io_cancel, sys_io_cancel)
-#define __NR_get_thread_area			211
-__SYSCALL(__NR_get_thread_area, sys_ni_syscall)	/* use arch_prctl */
-#define __NR_lookup_dcookie			212
-__SYSCALL(__NR_lookup_dcookie, sys_lookup_dcookie)
-#define __NR_epoll_create			213
-__SYSCALL(__NR_epoll_create, sys_epoll_create)
-#define __NR_epoll_ctl_old			214
-__SYSCALL(__NR_epoll_ctl_old, sys_ni_syscall)
-#define __NR_epoll_wait_old			215
-__SYSCALL(__NR_epoll_wait_old, sys_ni_syscall)
-#define __NR_remap_file_pages			216
-__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
-#define __NR_getdents64				217
-__SYSCALL(__NR_getdents64, sys_getdents64)
-#define __NR_set_tid_address			218
-__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
-#define __NR_restart_syscall			219
-__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
-#define __NR_semtimedop				220
-__SYSCALL(__NR_semtimedop, sys_semtimedop)
-#define __NR_fadvise64				221
-__SYSCALL(__NR_fadvise64, sys_fadvise64)
-#define __NR_timer_create			222
-__SYSCALL(__NR_timer_create, sys_timer_create)
-#define __NR_timer_settime			223
-__SYSCALL(__NR_timer_settime, sys_timer_settime)
-#define __NR_timer_gettime			224
-__SYSCALL(__NR_timer_gettime, sys_timer_gettime)
-#define __NR_timer_getoverrun			225
-__SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
-#define __NR_timer_delete			226
-__SYSCALL(__NR_timer_delete, sys_timer_delete)
-#define __NR_clock_settime			227
-__SYSCALL(__NR_clock_settime, sys_clock_settime)
-#define __NR_clock_gettime			228
-__SYSCALL(__NR_clock_gettime, sys_clock_gettime)
-#define __NR_clock_getres			229
-__SYSCALL(__NR_clock_getres, sys_clock_getres)
-#define __NR_clock_nanosleep			230
-__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep)
-#define __NR_exit_group				231
-__SYSCALL(__NR_exit_group, sys_exit_group)
-#define __NR_epoll_wait				232
-__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
-#define __NR_epoll_ctl				233
-__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
-#define __NR_tgkill				234
-__SYSCALL(__NR_tgkill, sys_tgkill)
-#define __NR_utimes				235
-__SYSCALL(__NR_utimes, sys_utimes)
-#define __NR_vserver				236
-__SYSCALL(__NR_vserver, sys_ni_syscall)
-#define __NR_mbind				237
-__SYSCALL(__NR_mbind, sys_mbind)
-#define __NR_set_mempolicy			238
-__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
-#define __NR_get_mempolicy			239
-__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
-#define __NR_mq_open				240
-__SYSCALL(__NR_mq_open, sys_mq_open)
-#define __NR_mq_unlink				241
-__SYSCALL(__NR_mq_unlink, sys_mq_unlink)
-#define __NR_mq_timedsend			242
-__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend)
-#define __NR_mq_timedreceive			243
-__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive)
-#define __NR_mq_notify				244
-__SYSCALL(__NR_mq_notify, sys_mq_notify)
-#define __NR_mq_getsetattr			245
-__SYSCALL(__NR_mq_getsetattr, sys_mq_getsetattr)
-#define __NR_kexec_load				246
-__SYSCALL(__NR_kexec_load, sys_kexec_load)
-#define __NR_waitid				247
-__SYSCALL(__NR_waitid, sys_waitid)
-#define __NR_add_key				248
-__SYSCALL(__NR_add_key, sys_add_key)
-#define __NR_request_key			249
-__SYSCALL(__NR_request_key, sys_request_key)
-#define __NR_keyctl				250
-__SYSCALL(__NR_keyctl, sys_keyctl)
-#define __NR_ioprio_set				251
-__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
-#define __NR_ioprio_get				252
-__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
-#define __NR_inotify_init			253
-__SYSCALL(__NR_inotify_init, sys_inotify_init)
-#define __NR_inotify_add_watch			254
-__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
-#define __NR_inotify_rm_watch			255
-__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
-#define __NR_migrate_pages			256
-__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
-#define __NR_openat				257
-__SYSCALL(__NR_openat, sys_openat)
-#define __NR_mkdirat				258
-__SYSCALL(__NR_mkdirat, sys_mkdirat)
-#define __NR_mknodat				259
-__SYSCALL(__NR_mknodat, sys_mknodat)
-#define __NR_fchownat				260
-__SYSCALL(__NR_fchownat, sys_fchownat)
-#define __NR_futimesat				261
-__SYSCALL(__NR_futimesat, sys_futimesat)
-#define __NR_newfstatat				262
-__SYSCALL(__NR_newfstatat, sys_newfstatat)
-#define __NR_unlinkat				263
-__SYSCALL(__NR_unlinkat, sys_unlinkat)
-#define __NR_renameat				264
-__SYSCALL(__NR_renameat, sys_renameat)
-#define __NR_linkat				265
-__SYSCALL(__NR_linkat, sys_linkat)
-#define __NR_symlinkat				266
-__SYSCALL(__NR_symlinkat, sys_symlinkat)
-#define __NR_readlinkat				267
-__SYSCALL(__NR_readlinkat, sys_readlinkat)
-#define __NR_fchmodat				268
-__SYSCALL(__NR_fchmodat, sys_fchmodat)
-#define __NR_faccessat				269
-__SYSCALL(__NR_faccessat, sys_faccessat)
-#define __NR_pselect6				270
-__SYSCALL(__NR_pselect6, sys_pselect6)
-#define __NR_ppoll				271
-__SYSCALL(__NR_ppoll,	sys_ppoll)
-#define __NR_unshare				272
-__SYSCALL(__NR_unshare,	sys_unshare)
-#define __NR_set_robust_list			273
-__SYSCALL(__NR_set_robust_list, sys_set_robust_list)
-#define __NR_get_robust_list			274
-__SYSCALL(__NR_get_robust_list, sys_get_robust_list)
-#define __NR_splice				275
-__SYSCALL(__NR_splice, sys_splice)
-#define __NR_tee				276
-__SYSCALL(__NR_tee, sys_tee)
-#define __NR_sync_file_range			277
-__SYSCALL(__NR_sync_file_range, sys_sync_file_range)
-#define __NR_vmsplice				278
-__SYSCALL(__NR_vmsplice, sys_vmsplice)
-#define __NR_move_pages				279
-__SYSCALL(__NR_move_pages, sys_move_pages)
-#define __NR_utimensat				280
-__SYSCALL(__NR_utimensat, sys_utimensat)
-#define __NR_epoll_pwait			281
-__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
-#define __NR_signalfd				282
-__SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd_create			283
-__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
-#define __NR_eventfd				284
-__SYSCALL(__NR_eventfd, sys_eventfd)
-#define __NR_fallocate				285
-__SYSCALL(__NR_fallocate, sys_fallocate)
-#define __NR_timerfd_settime			286
-__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
-#define __NR_timerfd_gettime			287
-__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
-#define __NR_accept4				288
-__SYSCALL(__NR_accept4, sys_accept4)
-#define __NR_signalfd4				289
-__SYSCALL(__NR_signalfd4, sys_signalfd4)
-#define __NR_eventfd2				290
-__SYSCALL(__NR_eventfd2, sys_eventfd2)
-#define __NR_epoll_create1			291
-__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
-#define __NR_dup3				292
-__SYSCALL(__NR_dup3, sys_dup3)
-#define __NR_pipe2				293
-__SYSCALL(__NR_pipe2, sys_pipe2)
-#define __NR_inotify_init1			294
-__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-#define __NR_preadv				295
-__SYSCALL(__NR_preadv, sys_preadv)
-#define __NR_pwritev				296
-__SYSCALL(__NR_pwritev, sys_pwritev)
-#define __NR_rt_tgsigqueueinfo			297
-__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
-#define __NR_perf_event_open			298
-__SYSCALL(__NR_perf_event_open, sys_perf_event_open)
-#define __NR_recvmmsg				299
-__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
-#define __NR_fanotify_init			300
-__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
-#define __NR_fanotify_mark			301
-__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
-#define __NR_prlimit64				302
-__SYSCALL(__NR_prlimit64, sys_prlimit64)
-#define __NR_name_to_handle_at			303
-__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
-#define __NR_open_by_handle_at			304
-__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
-#define __NR_clock_adjtime			305
-__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
-#define __NR_syncfs                             306
-__SYSCALL(__NR_syncfs, sys_syncfs)
-#define __NR_sendmmsg				307
-__SYSCALL(__NR_sendmmsg, sys_sendmmsg)
-#define __NR_setns				308
-__SYSCALL(__NR_setns, sys_setns)
-#define __NR_getcpu				309
-__SYSCALL(__NR_getcpu, sys_getcpu)
-#define __NR_process_vm_readv			310
-__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
-#define __NR_process_vm_writev			311
-__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
-
-#ifndef __NO_STUBS
-#define __ARCH_WANT_OLD_READDIR
-#define __ARCH_WANT_OLD_STAT
-#define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_GETHOSTNAME
-#define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_SGETMASK
-#define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
-#define __ARCH_WANT_SYS_NICE
-#define __ARCH_WANT_SYS_OLD_GETRLIMIT
-#define __ARCH_WANT_SYS_OLD_UNAME
-#define __ARCH_WANT_SYS_OLDUMOUNT
-#define __ARCH_WANT_SYS_SIGPENDING
-#define __ARCH_WANT_SYS_SIGPROCMASK
-#define __ARCH_WANT_SYS_RT_SIGACTION
-#define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_COMPAT_SYS_TIME
-#endif	/* __NO_STUBS */
-
-#ifdef __KERNEL__
-
-#ifndef COMPILE_OFFSETS
-#include <asm/asm-offsets.h>
-#define NR_syscalls (__NR_syscall_max + 1)
-#endif
-
-/*
- * "Conditional" syscalls
- *
- * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
- * but it doesn't work on all toolchains, so we just do it by hand
- */
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
-#endif	/* __KERNEL__ */
-
-#endif /* _ASM_X86_UNISTD_64_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8baca3c..8c473d9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -25,7 +25,8 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-y			+= syscall_$(BITS).o
+obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 395a10e..85d98ab 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -3,6 +3,11 @@
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
 
+#define __SYSCALL_I386(nr, sym, compat) [nr] = 1,
+static char syscalls[] = {
+#include <asm/syscalls_32.h>
+};
+
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
 
@@ -76,4 +81,7 @@ void foo(void)
 	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
 	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
+	BLANK();
+	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+	DEFINE(NR_syscalls, sizeof(syscalls));
 }
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e72a119..834e897 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,11 +1,12 @@
 #include <asm/ia32.h>
 
-#define __NO_STUBS 1
-#undef __SYSCALL
-#undef _ASM_X86_UNISTD_64_H
-#define __SYSCALL(nr, sym) [nr] = 1,
-static char syscalls[] = {
-#include <asm/unistd.h>
+#define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+static char syscalls_64[] = {
+#include <asm/syscalls_64.h>
+};
+#define __SYSCALL_I386(nr, sym, compat) [nr] = 1,
+static char syscalls_ia32[] = {
+#include <asm/syscalls_32.h>
 };
 
 int main(void)
@@ -72,7 +73,11 @@ int main(void)
 	OFFSET(TSS_ist, tss_struct, x86_tss.ist);
 	BLANK();
 
-	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+	DEFINE(__NR_syscall_max, sizeof(syscalls_64) - 1);
+	DEFINE(NR_syscalls, sizeof(syscalls_64));
+
+	DEFINE(__NR_ia32_syscall_max, sizeof(syscalls_ia32) - 1);
+	DEFINE(IA32_NR_syscalls, sizeof(syscalls_ia32));
 
 	return 0;
 }
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f3f6f53..1ffcda2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -81,8 +81,6 @@
  * enough to patch inline, increasing performance.
  */
 
-#define nr_syscalls ((syscall_table_size)/4)
-
 #ifdef CONFIG_PREEMPT
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
@@ -423,7 +421,7 @@ sysenter_past_esp:
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz sysenter_audit
 sysenter_do_call:
-	cmpl $(nr_syscalls), %eax
+	cmpl $(NR_syscalls), %eax
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
@@ -504,7 +502,7 @@ ENTRY(system_call)
 					# system call tracing in operation / emulation
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz syscall_trace_entry
-	cmpl $(nr_syscalls), %eax
+	cmpl $(NR_syscalls), %eax
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
@@ -650,7 +648,7 @@ syscall_trace_entry:
 	movl %esp, %eax
 	call syscall_trace_enter
 	/* What it returned is what we'll actually use.  */
-	cmpl $(nr_syscalls), %eax
+	cmpl $(NR_syscalls), %eax
 	jnae syscall_call
 	jmp syscall_exit
 END(syscall_trace_entry)
@@ -690,29 +688,28 @@ END(syscall_badsys)
  * System calls that need a pt_regs pointer.
  */
 #define PTREGSCALL0(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ;  \
 	leal 4(%esp),%eax; \
-	jmp sys_##name;
+	jmp sys_##name; \
+ENDPROC(ptregs_##name)
 
 #define PTREGSCALL1(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ; \
 	leal 4(%esp),%edx; \
 	movl (PT_EBX+4)(%esp),%eax; \
-	jmp sys_##name;
+	jmp sys_##name; \
+ENDPROC(ptregs_##name)
 
 #define PTREGSCALL2(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ; \
 	leal 4(%esp),%ecx; \
 	movl (PT_ECX+4)(%esp),%edx; \
 	movl (PT_EBX+4)(%esp),%eax; \
-	jmp sys_##name;
+	jmp sys_##name; \
+ENDPROC(ptregs_##name)
 
 #define PTREGSCALL3(name) \
-	ALIGN; \
-ptregs_##name: \
+ENTRY(ptregs_##name) ; \
 	CFI_STARTPROC; \
 	leal 4(%esp),%eax; \
 	pushl_cfi %eax; \
@@ -737,8 +734,7 @@ PTREGSCALL2(vm86)
 PTREGSCALL1(vm86old)
 
 /* Clone is an oddball.  The 4th arg is in %edi */
-	ALIGN;
-ptregs_clone:
+ENTRY(ptregs_clone)
 	CFI_STARTPROC
 	leal 4(%esp),%eax
 	pushl_cfi %eax
@@ -1209,11 +1205,6 @@ return_to_handler:
 	jmp *%ecx
 #endif
 
-.section .rodata,"a"
-#include "syscall_table_32.S"
-
-syscall_table_size=(.-sys_call_table)
-
 /*
  * Some functions should be protected against kprobes
  */
diff --git a/arch/x86/kernel/syscall_32.c b/arch/x86/kernel/syscall_32.c
new file mode 100644
index 0000000..147fcd4
--- /dev/null
+++ b/arch/x86/kernel/syscall_32.c
@@ -0,0 +1,25 @@
+/* System call table for i386. */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <linux/cache.h>
+#include <asm/asm-offsets.h>
+
+#define __SYSCALL_I386(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_32.h>
+#undef __SYSCALL_I386
+
+#define __SYSCALL_I386(nr, sym, compat) [nr] = sym,
+
+typedef asmlinkage void (*sys_call_ptr_t)(void);
+
+extern asmlinkage void sys_ni_syscall(void);
+
+const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+	/*
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+#include <asm/syscalls_32.h>
+};
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index de87d60..7ac7943 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -5,15 +5,11 @@
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
 
-#define __NO_STUBS
+#define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_64.h>
+#undef __SYSCALL_64
 
-#define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_UNISTD_64_H
-#include <asm/unistd_64.h>
-
-#undef __SYSCALL
-#define __SYSCALL(nr, sym) [nr] = sym,
-#undef _ASM_X86_UNISTD_64_H
+#define __SYSCALL_64(nr, sym, compat) [nr] = sym,
 
 typedef void (*sys_call_ptr_t)(void);
 
@@ -21,9 +17,9 @@ extern void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
-	*Smells like a like a compiler bug -- it doesn't work
-	*when the & below is removed.
-	*/
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
 	[0 ... __NR_syscall_max] = &sys_ni_syscall,
-#include <asm/unistd_64.h>
+#include <asm/syscalls_64.h>
 };
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
deleted file mode 100644
index 9a0e312..0000000
--- a/arch/x86/kernel/syscall_table_32.S
+++ /dev/null
@@ -1,350 +0,0 @@
-ENTRY(sys_call_table)
-	.long sys_restart_syscall	/* 0 - old "setup()" system call, used for restarting */
-	.long sys_exit
-	.long ptregs_fork
-	.long sys_read
-	.long sys_write
-	.long sys_open		/* 5 */
-	.long sys_close
-	.long sys_waitpid
-	.long sys_creat
-	.long sys_link
-	.long sys_unlink	/* 10 */
-	.long ptregs_execve
-	.long sys_chdir
-	.long sys_time
-	.long sys_mknod
-	.long sys_chmod		/* 15 */
-	.long sys_lchown16
-	.long sys_ni_syscall	/* old break syscall holder */
-	.long sys_stat
-	.long sys_lseek
-	.long sys_getpid	/* 20 */
-	.long sys_mount
-	.long sys_oldumount
-	.long sys_setuid16
-	.long sys_getuid16
-	.long sys_stime		/* 25 */
-	.long sys_ptrace
-	.long sys_alarm
-	.long sys_fstat
-	.long sys_pause
-	.long sys_utime		/* 30 */
-	.long sys_ni_syscall	/* old stty syscall holder */
-	.long sys_ni_syscall	/* old gtty syscall holder */
-	.long sys_access
-	.long sys_nice
-	.long sys_ni_syscall	/* 35 - old ftime syscall holder */
-	.long sys_sync
-	.long sys_kill
-	.long sys_rename
-	.long sys_mkdir
-	.long sys_rmdir		/* 40 */
-	.long sys_dup
-	.long sys_pipe
-	.long sys_times
-	.long sys_ni_syscall	/* old prof syscall holder */
-	.long sys_brk		/* 45 */
-	.long sys_setgid16
-	.long sys_getgid16
-	.long sys_signal
-	.long sys_geteuid16
-	.long sys_getegid16	/* 50 */
-	.long sys_acct
-	.long sys_umount	/* recycled never used phys() */
-	.long sys_ni_syscall	/* old lock syscall holder */
-	.long sys_ioctl
-	.long sys_fcntl		/* 55 */
-	.long sys_ni_syscall	/* old mpx syscall holder */
-	.long sys_setpgid
-	.long sys_ni_syscall	/* old ulimit syscall holder */
-	.long sys_olduname
-	.long sys_umask		/* 60 */
-	.long sys_chroot
-	.long sys_ustat
-	.long sys_dup2
-	.long sys_getppid
-	.long sys_getpgrp	/* 65 */
-	.long sys_setsid
-	.long sys_sigaction
-	.long sys_sgetmask
-	.long sys_ssetmask
-	.long sys_setreuid16	/* 70 */
-	.long sys_setregid16
-	.long sys_sigsuspend
-	.long sys_sigpending
-	.long sys_sethostname
-	.long sys_setrlimit	/* 75 */
-	.long sys_old_getrlimit
-	.long sys_getrusage
-	.long sys_gettimeofday
-	.long sys_settimeofday
-	.long sys_getgroups16	/* 80 */
-	.long sys_setgroups16
-	.long sys_old_select
-	.long sys_symlink
-	.long sys_lstat
-	.long sys_readlink	/* 85 */
-	.long sys_uselib
-	.long sys_swapon
-	.long sys_reboot
-	.long sys_old_readdir
-	.long sys_old_mmap	/* 90 */
-	.long sys_munmap
-	.long sys_truncate
-	.long sys_ftruncate
-	.long sys_fchmod
-	.long sys_fchown16	/* 95 */
-	.long sys_getpriority
-	.long sys_setpriority
-	.long sys_ni_syscall	/* old profil syscall holder */
-	.long sys_statfs
-	.long sys_fstatfs	/* 100 */
-	.long sys_ioperm
-	.long sys_socketcall
-	.long sys_syslog
-	.long sys_setitimer
-	.long sys_getitimer	/* 105 */
-	.long sys_newstat
-	.long sys_newlstat
-	.long sys_newfstat
-	.long sys_uname
-	.long ptregs_iopl	/* 110 */
-	.long sys_vhangup
-	.long sys_ni_syscall	/* old "idle" system call */
-	.long ptregs_vm86old
-	.long sys_wait4
-	.long sys_swapoff	/* 115 */
-	.long sys_sysinfo
-	.long sys_ipc
-	.long sys_fsync
-	.long ptregs_sigreturn
-	.long ptregs_clone	/* 120 */
-	.long sys_setdomainname
-	.long sys_newuname
-	.long sys_modify_ldt
-	.long sys_adjtimex
-	.long sys_mprotect	/* 125 */
-	.long sys_sigprocmask
-	.long sys_ni_syscall	/* old "create_module" */
-	.long sys_init_module
-	.long sys_delete_module
-	.long sys_ni_syscall	/* 130:	old "get_kernel_syms" */
-	.long sys_quotactl
-	.long sys_getpgid
-	.long sys_fchdir
-	.long sys_bdflush
-	.long sys_sysfs		/* 135 */
-	.long sys_personality
-	.long sys_ni_syscall	/* reserved for afs_syscall */
-	.long sys_setfsuid16
-	.long sys_setfsgid16
-	.long sys_llseek	/* 140 */
-	.long sys_getdents
-	.long sys_select
-	.long sys_flock
-	.long sys_msync
-	.long sys_readv		/* 145 */
-	.long sys_writev
-	.long sys_getsid
-	.long sys_fdatasync
-	.long sys_sysctl
-	.long sys_mlock		/* 150 */
-	.long sys_munlock
-	.long sys_mlockall
-	.long sys_munlockall
-	.long sys_sched_setparam
-	.long sys_sched_getparam   /* 155 */
-	.long sys_sched_setscheduler
-	.long sys_sched_getscheduler
-	.long sys_sched_yield
-	.long sys_sched_get_priority_max
-	.long sys_sched_get_priority_min  /* 160 */
-	.long sys_sched_rr_get_interval
-	.long sys_nanosleep
-	.long sys_mremap
-	.long sys_setresuid16
-	.long sys_getresuid16	/* 165 */
-	.long ptregs_vm86
-	.long sys_ni_syscall	/* Old sys_query_module */
-	.long sys_poll
-	.long sys_ni_syscall	/* Old nfsservctl */
-	.long sys_setresgid16	/* 170 */
-	.long sys_getresgid16
-	.long sys_prctl
-	.long ptregs_rt_sigreturn
-	.long sys_rt_sigaction
-	.long sys_rt_sigprocmask	/* 175 */
-	.long sys_rt_sigpending
-	.long sys_rt_sigtimedwait
-	.long sys_rt_sigqueueinfo
-	.long sys_rt_sigsuspend
-	.long sys_pread64	/* 180 */
-	.long sys_pwrite64
-	.long sys_chown16
-	.long sys_getcwd
-	.long sys_capget
-	.long sys_capset	/* 185 */
-	.long ptregs_sigaltstack
-	.long sys_sendfile
-	.long sys_ni_syscall	/* reserved for streams1 */
-	.long sys_ni_syscall	/* reserved for streams2 */
-	.long ptregs_vfork	/* 190 */
-	.long sys_getrlimit
-	.long sys_mmap_pgoff
-	.long sys_truncate64
-	.long sys_ftruncate64
-	.long sys_stat64	/* 195 */
-	.long sys_lstat64
-	.long sys_fstat64
-	.long sys_lchown
-	.long sys_getuid
-	.long sys_getgid	/* 200 */
-	.long sys_geteuid
-	.long sys_getegid
-	.long sys_setreuid
-	.long sys_setregid
-	.long sys_getgroups	/* 205 */
-	.long sys_setgroups
-	.long sys_fchown
-	.long sys_setresuid
-	.long sys_getresuid
-	.long sys_setresgid	/* 210 */
-	.long sys_getresgid
-	.long sys_chown
-	.long sys_setuid
-	.long sys_setgid
-	.long sys_setfsuid	/* 215 */
-	.long sys_setfsgid
-	.long sys_pivot_root
-	.long sys_mincore
-	.long sys_madvise
-	.long sys_getdents64	/* 220 */
-	.long sys_fcntl64
-	.long sys_ni_syscall	/* reserved for TUX */
-	.long sys_ni_syscall
-	.long sys_gettid
-	.long sys_readahead	/* 225 */
-	.long sys_setxattr
-	.long sys_lsetxattr
-	.long sys_fsetxattr
-	.long sys_getxattr
-	.long sys_lgetxattr	/* 230 */
-	.long sys_fgetxattr
-	.long sys_listxattr
-	.long sys_llistxattr
-	.long sys_flistxattr
-	.long sys_removexattr	/* 235 */
-	.long sys_lremovexattr
-	.long sys_fremovexattr
-	.long sys_tkill
-	.long sys_sendfile64
-	.long sys_futex		/* 240 */
-	.long sys_sched_setaffinity
-	.long sys_sched_getaffinity
-	.long sys_set_thread_area
-	.long sys_get_thread_area
-	.long sys_io_setup	/* 245 */
-	.long sys_io_destroy
-	.long sys_io_getevents
-	.long sys_io_submit
-	.long sys_io_cancel
-	.long sys_fadvise64	/* 250 */
-	.long sys_ni_syscall
-	.long sys_exit_group
-	.long sys_lookup_dcookie
-	.long sys_epoll_create
-	.long sys_epoll_ctl	/* 255 */
-	.long sys_epoll_wait
- 	.long sys_remap_file_pages
- 	.long sys_set_tid_address
- 	.long sys_timer_create
- 	.long sys_timer_settime		/* 260 */
- 	.long sys_timer_gettime
- 	.long sys_timer_getoverrun
- 	.long sys_timer_delete
- 	.long sys_clock_settime
- 	.long sys_clock_gettime		/* 265 */
- 	.long sys_clock_getres
- 	.long sys_clock_nanosleep
-	.long sys_statfs64
-	.long sys_fstatfs64
-	.long sys_tgkill	/* 270 */
-	.long sys_utimes
- 	.long sys_fadvise64_64
-	.long sys_ni_syscall	/* sys_vserver */
-	.long sys_mbind
-	.long sys_get_mempolicy
-	.long sys_set_mempolicy
-	.long sys_mq_open
-	.long sys_mq_unlink
-	.long sys_mq_timedsend
-	.long sys_mq_timedreceive	/* 280 */
-	.long sys_mq_notify
-	.long sys_mq_getsetattr
-	.long sys_kexec_load
-	.long sys_waitid
-	.long sys_ni_syscall		/* 285 */ /* available */
-	.long sys_add_key
-	.long sys_request_key
-	.long sys_keyctl
-	.long sys_ioprio_set
-	.long sys_ioprio_get		/* 290 */
-	.long sys_inotify_init
-	.long sys_inotify_add_watch
-	.long sys_inotify_rm_watch
-	.long sys_migrate_pages
-	.long sys_openat		/* 295 */
-	.long sys_mkdirat
-	.long sys_mknodat
-	.long sys_fchownat
-	.long sys_futimesat
-	.long sys_fstatat64		/* 300 */
-	.long sys_unlinkat
-	.long sys_renameat
-	.long sys_linkat
-	.long sys_symlinkat
-	.long sys_readlinkat		/* 305 */
-	.long sys_fchmodat
-	.long sys_faccessat
-	.long sys_pselect6
-	.long sys_ppoll
-	.long sys_unshare		/* 310 */
-	.long sys_set_robust_list
-	.long sys_get_robust_list
-	.long sys_splice
-	.long sys_sync_file_range
-	.long sys_tee			/* 315 */
-	.long sys_vmsplice
-	.long sys_move_pages
-	.long sys_getcpu
-	.long sys_epoll_pwait
-	.long sys_utimensat		/* 320 */
-	.long sys_signalfd
-	.long sys_timerfd_create
-	.long sys_eventfd
-	.long sys_fallocate
-	.long sys_timerfd_settime	/* 325 */
-	.long sys_timerfd_gettime
-	.long sys_signalfd4
-	.long sys_eventfd2
-	.long sys_epoll_create1
-	.long sys_dup3			/* 330 */
-	.long sys_pipe2
-	.long sys_inotify_init1
-	.long sys_preadv
-	.long sys_pwritev
-	.long sys_rt_tgsigqueueinfo	/* 335 */
-	.long sys_perf_event_open
-	.long sys_recvmmsg
-	.long sys_fanotify_init
-	.long sys_fanotify_mark
-	.long sys_prlimit64		/* 340 */
-	.long sys_name_to_handle_at
-	.long sys_open_by_handle_at
-	.long sys_clock_adjtime
-	.long sys_syncfs
-	.long sys_sendmmsg		/* 345 */
-	.long sys_setns
-	.long sys_process_vm_readv
-	.long sys_process_vm_writev
diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
new file mode 100644
index 0000000..564b247
--- /dev/null
+++ b/arch/x86/syscalls/Makefile
@@ -0,0 +1,43 @@
+out := $(obj)/../include/generated/asm
+
+# Create output directory if not already present
+_dummy := $(shell [ -d '$(out)' ] || mkdir -p '$(out)')
+
+syscall32 := $(srctree)/$(src)/syscall_32.tbl
+syscall64 := $(srctree)/$(src)/syscall_64.tbl
+
+syshdr := $(srctree)/$(src)/syscallhdr.sh
+systbl := $(srctree)/$(src)/syscalltbl.sh
+
+quiet_cmd_syshdr = SYSHDR  $@
+      cmd_syshdr = $(CONFIG_SHELL) '$(syshdr)' $< $@ \
+		   $(syshdr_abi_$(basetarget)) $(syshdr_pfx_$(basetarget))
+quiet_cmd_systbl = SYSTBL  $@
+      cmd_systbl = $(CONFIG_SHELL) '$(systbl)' $< $@
+
+syshdr_abi_unistd_32 := i386
+$(out)/unistd_32.h: $(syscall32) $(syshdr)
+	$(call if_changed,syshdr)
+
+syshdr_abi_unistd_32_ia32 := i386
+syshdr_pfx_unistd_32_ia32 := ia32_
+$(out)/unistd_32_ia32.h: $(syscall32) $(syshdr)
+	$(call if_changed,syshdr)
+
+syshdr_abi_unistd_64 := 64
+$(out)/unistd_64.h: $(syscall64) $(syshdr)
+	$(call if_changed,syshdr)
+
+$(out)/syscalls_32.h: $(syscall32) $(systbl)
+	$(call if_changed,systbl)
+$(out)/syscalls_64.h: $(syscall64) $(systbl)
+	$(call if_changed,systbl)
+
+syshdr-y			+= unistd_32.h unistd_64.h
+syshdr-y			+= syscalls_32.h
+syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h
+syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
+
+targets	+= $(syshdr-y)
+
+all: $(addprefix $(out)/,$(targets))
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
new file mode 100644
index 0000000..ce98e28
--- /dev/null
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -0,0 +1,357 @@
+#
+# 32-bit system call numbers and entry vectors
+#
+# The format is:
+# <number> <abi> <name> <entry point> <compat entry point>
+#
+# The abi is always "i386" for this file.
+#
+0	i386	restart_syscall		sys_restart_syscall
+1	i386	exit			sys_exit
+2	i386	fork			ptregs_fork			stub32_fork
+3	i386	read			sys_read
+4	i386	write			sys_write
+5	i386	open			sys_open			compat_sys_open
+6	i386	close			sys_close
+7	i386	waitpid			sys_waitpid			sys32_waitpid
+8	i386	creat			sys_creat
+9	i386	link			sys_link
+10	i386	unlink			sys_unlink
+11	i386	execve			ptregs_execve			stub32_execve
+12	i386	chdir			sys_chdir
+13	i386	time			sys_time			compat_sys_time
+14	i386	mknod			sys_mknod
+15	i386	chmod			sys_chmod
+16	i386	lchown			sys_lchown16
+17	i386	break
+18	i386	oldstat			sys_stat
+19	i386	lseek			sys_lseek			sys32_lseek
+20	i386	getpid			sys_getpid
+21	i386	mount			sys_mount			compat_sys_mount
+22	i386	umount			sys_oldumount
+23	i386	setuid			sys_setuid16
+24	i386	getuid			sys_getuid16
+25	i386	stime			sys_stime			compat_sys_stime
+26	i386	ptrace			sys_ptrace			compat_sys_ptrace
+27	i386	alarm			sys_alarm
+28	i386	oldfstat		sys_fstat
+29	i386	pause			sys_pause
+30	i386	utime			sys_utime			compat_sys_utime
+31	i386	stty
+32	i386	gtty
+33	i386	access			sys_access
+34	i386	nice			sys_nice
+35	i386	ftime
+36	i386	sync			sys_sync
+37	i386	kill			sys_kill			sys32_kill
+38	i386	rename			sys_rename
+39	i386	mkdir			sys_mkdir
+40	i386	rmdir			sys_rmdir
+41	i386	dup			sys_dup
+42	i386	pipe			sys_pipe
+43	i386	times			sys_times			compat_sys_times
+44	i386	prof
+45	i386	brk			sys_brk
+46	i386	setgid			sys_setgid16
+47	i386	getgid			sys_getgid16
+48	i386	signal			sys_signal
+49	i386	geteuid			sys_geteuid16
+50	i386	getegid			sys_getegid16
+51	i386	acct			sys_acct
+52	i386	umount2			sys_umount
+53	i386	lock
+54	i386	ioctl			sys_ioctl			compat_sys_ioctl
+55	i386	fcntl			sys_fcntl			compat_sys_fcntl64
+56	i386	mpx
+57	i386	setpgid			sys_setpgid
+58	i386	ulimit
+59	i386	oldolduname		sys_olduname
+60	i386	umask			sys_umask
+61	i386	chroot			sys_chroot
+62	i386	ustat			sys_ustat			compat_sys_ustat
+63	i386	dup2			sys_dup2
+64	i386	getppid			sys_getppid
+65	i386	getpgrp			sys_getpgrp
+66	i386	setsid			sys_setsid
+67	i386	sigaction		sys_sigaction			sys32_sigaction
+68	i386	sgetmask		sys_sgetmask
+69	i386	ssetmask		sys_ssetmask
+70	i386	setreuid		sys_setreuid16
+71	i386	setregid		sys_setregid16
+72	i386	sigsuspend		sys_sigsuspend			sys32_sigsuspend
+73	i386	sigpending		sys_sigpending			compat_sys_sigpending
+74	i386	sethostname		sys_sethostname
+75	i386	setrlimit		sys_setrlimit			compat_sys_setrlimit
+76	i386	getrlimit		sys_old_getrlimit		compat_sys_old_getrlimit
+77	i386	getrusage		sys_getrusage			compat_sys_getrusage
+78	i386	gettimeofday		sys_gettimeofday		compat_sys_gettimeofday
+79	i386	settimeofday		sys_settimeofday		compat_sys_settimeofday
+80	i386	getgroups		sys_getgroups16
+81	i386	setgroups		sys_setgroups16
+82	i386	select			sys_old_select			compat_sys_old_select
+83	i386	symlink			sys_symlink
+84	i386	oldlstat		sys_lstat
+85	i386	readlink		sys_readlink
+86	i386	uselib			sys_uselib
+87	i386	swapon			sys_swapon
+88	i386	reboot			sys_reboot
+89	i386	readdir			sys_old_readdir			compat_sys_old_readdir
+90	i386	mmap			sys_old_mmap			sys32_mmap
+91	i386	munmap			sys_munmap
+92	i386	truncate		sys_truncate
+93	i386	ftruncate		sys_ftruncate
+94	i386	fchmod			sys_fchmod
+95	i386	fchown			sys_fchown16
+96	i386	getpriority		sys_getpriority
+97	i386	setpriority		sys_setpriority
+98	i386	profil
+99	i386	statfs			sys_statfs			compat_sys_statfs
+100	i386	fstatfs			sys_fstatfs			compat_sys_fstatfs
+101	i386	ioperm			sys_ioperm
+102	i386	socketcall		sys_socketcall			compat_sys_socketcall
+103	i386	syslog			sys_syslog
+104	i386	setitimer		sys_setitimer			compat_sys_setitimer
+105	i386	getitimer		sys_getitimer			compat_sys_getitimer
+106	i386	stat			sys_newstat			compat_sys_newstat
+107	i386	lstat			sys_newlstat			compat_sys_newlstat
+108	i386	fstat			sys_newfstat			compat_sys_newfstat
+109	i386	olduname		sys_uname
+110	i386	iopl			ptregs_iopl			stub32_iopl
+111	i386	vhangup			sys_vhangup
+112	i386	idle
+113	i386	vm86old			ptregs_vm86old			sys32_vm86_warning
+114	i386	wait4			sys_wait4			compat_sys_wait4
+115	i386	swapoff			sys_swapoff
+116	i386	sysinfo			sys_sysinfo			compat_sys_sysinfo
+117	i386	ipc			sys_ipc				sys32_ipc
+118	i386	fsync			sys_fsync
+119	i386	sigreturn		ptregs_sigreturn		stub32_sigreturn
+120	i386	clone			ptregs_clone			stub32_clone
+121	i386	setdomainname		sys_setdomainname
+122	i386	uname			sys_newuname
+123	i386	modify_ldt		sys_modify_ldt
+124	i386	adjtimex		sys_adjtimex			compat_sys_adjtimex
+125	i386	mprotect		sys_mprotect			sys32_mprotect
+126	i386	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
+127	i386	create_module
+128	i386	init_module		sys_init_module
+129	i386	delete_module		sys_delete_module
+130	i386	get_kernel_syms
+131	i386	quotactl		sys_quotactl			sys32_quotactl
+132	i386	getpgid			sys_getpgid
+133	i386	fchdir			sys_fchdir
+134	i386	bdflush			sys_bdflush
+135	i386	sysfs			sys_sysfs
+136	i386	personality		sys_personality
+137	i386	afs_syscall
+138	i386	setfsuid		sys_setfsuid16
+139	i386	setfsgid		sys_setfsgid16
+140	i386	_llseek			sys_llseek
+141	i386	getdents		sys_getdents			compat_sys_getdents
+142	i386	_newselect		sys_select			compat_sys_select
+143	i386	flock			sys_flock
+144	i386	msync			sys_msync
+145	i386	readv			sys_readv			compat_sys_readv
+146	i386	writev			sys_writev			compat_sys_writev
+147	i386	getsid			sys_getsid
+148	i386	fdatasync		sys_fdatasync
+149	i386	_sysctl			sys_sysctl			compat_sys_sysctl
+150	i386	mlock			sys_mlock
+151	i386	munlock			sys_munlock
+152	i386	mlockall		sys_mlockall
+153	i386	munlockall		sys_munlockall
+154	i386	sched_setparam		sys_sched_setparam
+155	i386	sched_getparam		sys_sched_getparam
+156	i386	sched_setscheduler	sys_sched_setscheduler
+157	i386	sched_getscheduler	sys_sched_getscheduler
+158	i386	sched_yield		sys_sched_yield
+159	i386	sched_get_priority_max	sys_sched_get_priority_max
+160	i386	sched_get_priority_min	sys_sched_get_priority_min
+161	i386	sched_rr_get_interval	sys_sched_rr_get_interval	sys32_sched_rr_get_interval
+162	i386	nanosleep		sys_nanosleep			compat_sys_nanosleep
+163	i386	mremap			sys_mremap
+164	i386	setresuid		sys_setresuid16
+165	i386	getresuid		sys_getresuid16
+166	i386	vm86			ptregs_vm86			sys32_vm86_warning
+167	i386	query_module
+168	i386	poll			sys_poll
+169	i386	nfsservctl
+170	i386	setresgid		sys_setresgid16
+171	i386	getresgid		sys_getresgid16
+172	i386	prctl			sys_prctl
+173	i386	rt_sigreturn		ptregs_rt_sigreturn		stub32_rt_sigreturn
+174	i386	rt_sigaction		sys_rt_sigaction		sys32_rt_sigaction
+175	i386	rt_sigprocmask		sys_rt_sigprocmask		sys32_rt_sigprocmask
+176	i386	rt_sigpending		sys_rt_sigpending		sys32_rt_sigpending
+177	i386	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
+178	i386	rt_sigqueueinfo		sys_rt_sigqueueinfo		sys32_rt_sigqueueinfo
+179	i386	rt_sigsuspend		sys_rt_sigsuspend
+180	i386	pread64			sys_pread64			sys32_pread
+181	i386	pwrite64		sys_pwrite64			sys32_pwrite
+182	i386	chown			sys_chown16
+183	i386	getcwd			sys_getcwd
+184	i386	capget			sys_capget
+185	i386	capset			sys_capset
+186	i386	sigaltstack		ptregs_sigaltstack		stub32_sigaltstack
+187	i386	sendfile		sys_sendfile			sys32_sendfile
+188	i386	getpmsg
+189	i386	putpmsg
+190	i386	vfork			ptregs_vfork			stub32_vfork
+191	i386	ugetrlimit		sys_getrlimit			compat_sys_getrlimit
+192	i386	mmap2			sys_mmap_pgoff
+193	i386	truncate64		sys_truncate64			sys32_truncate64
+194	i386	ftruncate64		sys_ftruncate64			sys32_ftruncate64
+195	i386	stat64			sys_stat64			sys32_stat64
+196	i386	lstat64			sys_lstat64			sys32_lstat64
+197	i386	fstat64			sys_fstat64			sys32_fstat64
+198	i386	lchown32		sys_lchown
+199	i386	getuid32		sys_getuid
+200	i386	getgid32		sys_getgid
+201	i386	geteuid32		sys_geteuid
+202	i386	getegid32		sys_getegid
+203	i386	setreuid32		sys_setreuid
+204	i386	setregid32		sys_setregid
+205	i386	getgroups32		sys_getgroups
+206	i386	setgroups32		sys_setgroups
+207	i386	fchown32		sys_fchown
+208	i386	setresuid32		sys_setresuid
+209	i386	getresuid32		sys_getresuid
+210	i386	setresgid32		sys_setresgid
+211	i386	getresgid32		sys_getresgid
+212	i386	chown32			sys_chown
+213	i386	setuid32		sys_setuid
+214	i386	setgid32		sys_setgid
+215	i386	setfsuid32		sys_setfsuid
+216	i386	setfsgid32		sys_setfsgid
+217	i386	pivot_root		sys_pivot_root
+218	i386	mincore			sys_mincore
+219	i386	madvise			sys_madvise
+220	i386	getdents64		sys_getdents64			compat_sys_getdents64
+221	i386	fcntl64			sys_fcntl64			compat_sys_fcntl64
+# 222 is unused
+# 223 is unused
+224	i386	gettid			sys_gettid
+225	i386	readahead		sys_readahead			sys32_readahead
+226	i386	setxattr		sys_setxattr
+227	i386	lsetxattr		sys_lsetxattr
+228	i386	fsetxattr		sys_fsetxattr
+229	i386	getxattr		sys_getxattr
+230	i386	lgetxattr		sys_lgetxattr
+231	i386	fgetxattr		sys_fgetxattr
+232	i386	listxattr		sys_listxattr
+233	i386	llistxattr		sys_llistxattr
+234	i386	flistxattr		sys_flistxattr
+235	i386	removexattr		sys_removexattr
+236	i386	lremovexattr		sys_lremovexattr
+237	i386	fremovexattr		sys_fremovexattr
+238	i386	tkill			sys_tkill
+239	i386	sendfile64		sys_sendfile64
+240	i386	futex			sys_futex			compat_sys_futex
+241	i386	sched_setaffinity	sys_sched_setaffinity		compat_sys_sched_setaffinity
+242	i386	sched_getaffinity	sys_sched_getaffinity		compat_sys_sched_getaffinity
+243	i386	set_thread_area		sys_set_thread_area
+244	i386	get_thread_area		sys_get_thread_area
+245	i386	io_setup		sys_io_setup			compat_sys_io_setup
+246	i386	io_destroy		sys_io_destroy
+247	i386	io_getevents		sys_io_getevents		compat_sys_io_getevents
+248	i386	io_submit		sys_io_submit			compat_sys_io_submit
+249	i386	io_cancel		sys_io_cancel
+250	i386	fadvise64		sys_fadvise64			sys32_fadvise64
+# 251 is available for reuse (was briefly sys_set_zone_reclaim)
+252	i386	exit_group		sys_exit_group
+253	i386	lookup_dcookie		sys_lookup_dcookie		sys32_lookup_dcookie
+254	i386	epoll_create		sys_epoll_create
+255	i386	epoll_ctl		sys_epoll_ctl
+256	i386	epoll_wait		sys_epoll_wait
+257	i386	remap_file_pages	sys_remap_file_pages
+258	i386	set_tid_address		sys_set_tid_address
+259	i386	timer_create		sys_timer_create		compat_sys_timer_create
+260	i386	timer_settime		sys_timer_settime		compat_sys_timer_settime
+261	i386	timer_gettime		sys_timer_gettime		compat_sys_timer_gettime
+262	i386	timer_getoverrun	sys_timer_getoverrun
+263	i386	timer_delete		sys_timer_delete
+264	i386	clock_settime		sys_clock_settime		compat_sys_clock_settime
+265	i386	clock_gettime		sys_clock_gettime		compat_sys_clock_gettime
+266	i386	clock_getres		sys_clock_getres		compat_sys_clock_getres
+267	i386	clock_nanosleep		sys_clock_nanosleep		compat_sys_clock_nanosleep
+268	i386	statfs64		sys_statfs64			compat_sys_statfs64
+269	i386	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
+270	i386	tgkill			sys_tgkill
+271	i386	utimes			sys_utimes			compat_sys_utimes
+272	i386	fadvise64_64		sys_fadvise64_64		sys32_fadvise64_64
+273	i386	vserver
+274	i386	mbind			sys_mbind
+275	i386	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
+276	i386	set_mempolicy		sys_set_mempolicy
+277	i386	mq_open			sys_mq_open			compat_sys_mq_open
+278	i386	mq_unlink		sys_mq_unlink
+279	i386	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
+280	i386	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
+281	i386	mq_notify		sys_mq_notify			compat_sys_mq_notify
+282	i386	mq_getsetaddr		sys_mq_getsetattr		compat_sys_mq_getsetattr
+283	i386	kexec_load		sys_kexec_load			compat_sys_kexec_load
+284	i386	waitid			sys_waitid			compat_sys_waitid
+# 285 sys_setaltroot
+286	i386	add_key			sys_add_key
+287	i386	request_key		sys_request_key
+288	i386	keyctl			sys_keyctl
+289	i386	ioprio_set		sys_ioprio_set
+290	i386	ioprio_get		sys_ioprio_get
+291	i386	inotify_init		sys_inotify_init
+292	i386	inotify_add_watch	sys_inotify_add_watch
+293	i386	inotify_rm_watch	sys_inotify_rm_watch
+294	i386	migrate_pages		sys_migrate_pages
+295	i386	openat			sys_openat			compat_sys_openat
+296	i386	mkdirat			sys_mkdirat
+297	i386	mknodat			sys_mknodat
+298	i386	fchownat		sys_fchownat
+299	i386	futimesat		sys_futimesat			compat_sys_futimesat
+300	i386	fstatat64		sys_fstatat64			sys32_fstatat
+301	i386	unlinkat		sys_unlinkat
+302	i386	renameat		sys_renameat
+303	i386	linkat			sys_linkat
+304	i386	symlinkat		sys_symlinkat
+305	i386	readlinkat		sys_readlinkat
+306	i386	fchmodat		sys_fchmodat
+307	i386	faccessat		sys_faccessat
+308	i386	pselect6		sys_pselect6			compat_sys_pselect6
+309	i386	ppoll			sys_ppoll			compat_sys_ppoll
+310	i386	unshare			sys_unshare
+311	i386	set_robust_list		sys_set_robust_list		compat_sys_set_robust_list
+312	i386	get_robust_list		sys_get_robust_list		compat_sys_get_robust_list
+313	i386	splice			sys_splice
+314	i386	sync_file_range		sys_sync_file_range		sys32_sync_file_range
+315	i386	tee			sys_tee
+316	i386	vmsplice		sys_vmsplice			compat_sys_vmsplice
+317	i386	move_pages		sys_move_pages			compat_sys_move_pages
+318	i386	getcpu			sys_getcpu
+319	i386	epoll_pwait		sys_epoll_pwait
+320	i386	utimensat		sys_utimensat			compat_sys_utimensat
+321	i386	signalfd		sys_signalfd			compat_sys_signalfd
+322	i386	timerfd_create		sys_timerfd_create
+323	i386	eventfd			sys_eventfd
+324	i386	fallocate		sys_fallocate			sys32_fallocate
+325	i386	timerfd_settime		sys_timerfd_settime		compat_sys_timerfd_settime
+326	i386	timerfd_gettime		sys_timerfd_gettime		compat_sys_timerfd_gettime
+327	i386	signalfd4		sys_signalfd4			compat_sys_signalfd4
+328	i386	eventfd2		sys_eventfd2
+329	i386	epoll_create1		sys_epoll_create1
+330	i386	dup3			sys_dup3
+331	i386	pipe2			sys_pipe2
+332	i386	inotify_init1		sys_inotify_init1
+333	i386	preadv			sys_preadv			compat_sys_preadv
+334	i386	pwritev			sys_pwritev			compat_sys_pwritev
+335	i386	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo		compat_sys_rt_tgsigqueueinfo
+336	i386	perf_event_open		sys_perf_event_open
+337	i386	recvmmsg		sys_recvmmsg			compat_sys_recvmmsg
+338	i386	fanotify_init		sys_fanotify_init
+339	i386	fanotify_mark		sys_fanotify_mark		sys32_fanotify_mark
+340	i386	prlimit64		sys_prlimit64
+341	i386	name_to_handle_at	sys_name_to_handle_at
+342	i386	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
+343	i386	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
+344	i386	syncfs			sys_syncfs
+345	i386	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
+346	i386	setns			sys_setns
+347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
+348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
new file mode 100644
index 0000000..b440a8f
--- /dev/null
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -0,0 +1,320 @@
+#
+# 64-bit system call numbers and entry vectors
+#
+# The format is:
+# <number> <abi> <name> <entry point>
+#
+# The abi is always "64" for this file (for now.)
+#
+0	64	read			sys_read
+1	64	write			sys_write
+2	64	open			sys_open
+3	64	close			sys_close
+4	64	stat			sys_newstat
+5	64	fstat			sys_newfstat
+6	64	lstat			sys_newlstat
+7	64	poll			sys_poll
+8	64	lseek			sys_lseek
+9	64	mmap			sys_mmap
+10	64	mprotect		sys_mprotect
+11	64	munmap			sys_munmap
+12	64	brk			sys_brk
+13	64	rt_sigaction		sys_rt_sigaction
+14	64	rt_sigprocmask		sys_rt_sigprocmask
+15	64	rt_sigreturn		stub_rt_sigreturn
+16	64	ioctl			sys_ioctl
+17	64	pread64			sys_pread64
+18	64	pwrite64		sys_pwrite64
+19	64	readv			sys_readv
+20	64	writev			sys_writev
+21	64	access			sys_access
+22	64	pipe			sys_pipe
+23	64	select			sys_select
+24	64	sched_yield		sys_sched_yield
+25	64	mremap			sys_mremap
+26	64	msync			sys_msync
+27	64	mincore			sys_mincore
+28	64	madvise			sys_madvise
+29	64	shmget			sys_shmget
+30	64	shmat			sys_shmat
+31	64	shmctl			sys_shmctl
+32	64	dup			sys_dup
+33	64	dup2			sys_dup2
+34	64	pause			sys_pause
+35	64	nanosleep		sys_nanosleep
+36	64	getitimer		sys_getitimer
+37	64	alarm			sys_alarm
+38	64	setitimer		sys_setitimer
+39	64	getpid			sys_getpid
+40	64	sendfile		sys_sendfile64
+41	64	socket			sys_socket
+42	64	connect			sys_connect
+43	64	accept			sys_accept
+44	64	sendto			sys_sendto
+45	64	recvfrom		sys_recvfrom
+46	64	sendmsg			sys_sendmsg
+47	64	recvmsg			sys_recvmsg
+48	64	shutdown		sys_shutdown
+49	64	bind			sys_bind
+50	64	listen			sys_listen
+51	64	getsockname		sys_getsockname
+52	64	getpeername		sys_getpeername
+53	64	socketpair		sys_socketpair
+54	64	setsockopt		sys_setsockopt
+55	64	getsockopt		sys_getsockopt
+56	64	clone			stub_clone
+57	64	fork			stub_fork
+58	64	vfork			stub_vfork
+59	64	execve			stub_execve
+60	64	exit			sys_exit
+61	64	wait4			sys_wait4
+62	64	kill			sys_kill
+63	64	uname			sys_newuname
+64	64	semget			sys_semget
+65	64	semop			sys_semop
+66	64	semctl			sys_semctl
+67	64	shmdt			sys_shmdt
+68	64	msgget			sys_msgget
+69	64	msgsnd			sys_msgsnd
+70	64	msgrcv			sys_msgrcv
+71	64	msgctl			sys_msgctl
+72	64	fcntl			sys_fcntl
+73	64	flock			sys_flock
+74	64	fsync			sys_fsync
+75	64	fdatasync		sys_fdatasync
+76	64	truncate		sys_truncate
+77	64	ftruncate		sys_ftruncate
+78	64	getdents		sys_getdents
+79	64	getcwd			sys_getcwd
+80	64	chdir			sys_chdir
+81	64	fchdir			sys_fchdir
+82	64	rename			sys_rename
+83	64	mkdir			sys_mkdir
+84	64	rmdir			sys_rmdir
+85	64	creat			sys_creat
+86	64	link			sys_link
+87	64	unlink			sys_unlink
+88	64	symlink			sys_symlink
+89	64	readlink		sys_readlink
+90	64	chmod			sys_chmod
+91	64	fchmod			sys_fchmod
+92	64	chown			sys_chown
+93	64	fchown			sys_fchown
+94	64	lchown			sys_lchown
+95	64	umask			sys_umask
+96	64	gettimeofday		sys_gettimeofday
+97	64	getrlimit		sys_getrlimit
+98	64	getrusage		sys_getrusage
+99	64	sysinfo			sys_sysinfo
+100	64	times			sys_times
+101	64	ptrace			sys_ptrace
+102	64	getuid			sys_getuid
+103	64	syslog			sys_syslog
+104	64	getgid			sys_getgid
+105	64	setuid			sys_setuid
+106	64	setgid			sys_setgid
+107	64	geteuid			sys_geteuid
+108	64	getegid			sys_getegid
+109	64	setpgid			sys_setpgid
+110	64	getppid			sys_getppid
+111	64	getpgrp			sys_getpgrp
+112	64	setsid			sys_setsid
+113	64	setreuid		sys_setreuid
+114	64	setregid		sys_setregid
+115	64	getgroups		sys_getgroups
+116	64	setgroups		sys_setgroups
+117	64	setresuid		sys_setresuid
+118	64	getresuid		sys_getresuid
+119	64	setresgid		sys_setresgid
+120	64	getresgid		sys_getresgid
+121	64	getpgid			sys_getpgid
+122	64	setfsuid		sys_setfsuid
+123	64	setfsgid		sys_setfsgid
+124	64	getsid			sys_getsid
+125	64	capget			sys_capget
+126	64	capset			sys_capset
+127	64	rt_sigpending		sys_rt_sigpending
+128	64	rt_sigtimedwait		sys_rt_sigtimedwait
+129	64	rt_sigqueueinfo		sys_rt_sigqueueinfo
+130	64	rt_sigsuspend		sys_rt_sigsuspend
+131	64	sigaltstack		stub_sigaltstack
+132	64	utime			sys_utime
+133	64	mknod			sys_mknod
+134	64	uselib
+135	64	personality		sys_personality
+136	64	ustat			sys_ustat
+137	64	statfs			sys_statfs
+138	64	fstatfs			sys_fstatfs
+139	64	sysfs			sys_sysfs
+140	64	getpriority		sys_getpriority
+141	64	setpriority		sys_setpriority
+142	64	sched_setparam		sys_sched_setparam
+143	64	sched_getparam		sys_sched_getparam
+144	64	sched_setscheduler	sys_sched_setscheduler
+145	64	sched_getscheduler	sys_sched_getscheduler
+146	64	sched_get_priority_max	sys_sched_get_priority_max
+147	64	sched_get_priority_min	sys_sched_get_priority_min
+148	64	sched_rr_get_interval	sys_sched_rr_get_interval
+149	64	mlock			sys_mlock
+150	64	munlock			sys_munlock
+151	64	mlockall		sys_mlockall
+152	64	munlockall		sys_munlockall
+153	64	vhangup			sys_vhangup
+154	64	modify_ldt		sys_modify_ldt
+155	64	pivot_root		sys_pivot_root
+156	64	_sysctl			sys_sysctl
+157	64	prctl			sys_prctl
+158	64	arch_prctl		sys_arch_prctl
+159	64	adjtimex		sys_adjtimex
+160	64	setrlimit		sys_setrlimit
+161	64	chroot			sys_chroot
+162	64	sync			sys_sync
+163	64	acct			sys_acct
+164	64	settimeofday		sys_settimeofday
+165	64	mount			sys_mount
+166	64	umount2			sys_umount
+167	64	swapon			sys_swapon
+168	64	swapoff			sys_swapoff
+169	64	reboot			sys_reboot
+170	64	sethostname		sys_sethostname
+171	64	setdomainname		sys_setdomainname
+172	64	iopl			stub_iopl
+173	64	ioperm			sys_ioperm
+174	64	create_module
+175	64	init_module		sys_init_module
+176	64	delete_module		sys_delete_module
+177	64	get_kernel_syms
+178	64	query_module
+179	64	quotactl		sys_quotactl
+180	64	nfsservctl
+181	64	getpmsg
+182	64	putpmsg
+183	64	afs_syscall
+184	64	tuxcall
+185	64	security
+186	64	gettid			sys_gettid
+187	64	readahead		sys_readahead
+188	64	setxattr		sys_setxattr
+189	64	lsetxattr		sys_lsetxattr
+190	64	fsetxattr		sys_fsetxattr
+191	64	getxattr		sys_getxattr
+192	64	lgetxattr		sys_lgetxattr
+193	64	fgetxattr		sys_fgetxattr
+194	64	listxattr		sys_listxattr
+195	64	llistxattr		sys_llistxattr
+196	64	flistxattr		sys_flistxattr
+197	64	removexattr		sys_removexattr
+198	64	lremovexattr		sys_lremovexattr
+199	64	fremovexattr		sys_fremovexattr
+200	64	tkill			sys_tkill
+201	64	time			sys_time
+202	64	futex			sys_futex
+203	64	sched_setaffinity	sys_sched_setaffinity
+204	64	sched_getaffinity	sys_sched_getaffinity
+205	64	set_thread_area
+206	64	io_setup		sys_io_setup
+207	64	io_destroy		sys_io_destroy
+208	64	io_getevents		sys_io_getevents
+209	64	io_submit		sys_io_submit
+210	64	io_cancel		sys_io_cancel
+211	64	get_thread_area
+212	64	lookup_dcookie		sys_lookup_dcookie
+213	64	epoll_create		sys_epoll_create
+214	64	epoll_ctl_old
+215	64	epoll_wait_old
+216	64	remap_file_pages	sys_remap_file_pages
+217	64	getdents64		sys_getdents64
+218	64	set_tid_address		sys_set_tid_address
+219	64	restart_syscall		sys_restart_syscall
+220	64	semtimedop		sys_semtimedop
+221	64	fadvise64		sys_fadvise64
+222	64	timer_create		sys_timer_create
+223	64	timer_settime		sys_timer_settime
+224	64	timer_gettime		sys_timer_gettime
+225	64	timer_getoverrun	sys_timer_getoverrun
+226	64	timer_delete		sys_timer_delete
+227	64	clock_settime		sys_clock_settime
+228	64	clock_gettime		sys_clock_gettime
+229	64	clock_getres		sys_clock_getres
+230	64	clock_nanosleep		sys_clock_nanosleep
+231	64	exit_group		sys_exit_group
+232	64	epoll_wait		sys_epoll_wait
+233	64	epoll_ctl		sys_epoll_ctl
+234	64	tgkill			sys_tgkill
+235	64	utimes			sys_utimes
+236	64	vserver
+237	64	mbind			sys_mbind
+238	64	set_mempolicy		sys_set_mempolicy
+239	64	get_mempolicy		sys_get_mempolicy
+240	64	mq_open			sys_mq_open
+241	64	mq_unlink		sys_mq_unlink
+242	64	mq_timedsend		sys_mq_timedsend
+243	64	mq_timedreceive		sys_mq_timedreceive
+244	64	mq_notify		sys_mq_notify
+245	64	mq_getsetattr		sys_mq_getsetattr
+246	64	kexec_load		sys_kexec_load
+247	64	waitid			sys_waitid
+248	64	add_key			sys_add_key
+249	64	request_key		sys_request_key
+250	64	keyctl			sys_keyctl
+251	64	ioprio_set		sys_ioprio_set
+252	64	ioprio_get		sys_ioprio_get
+253	64	inotify_init		sys_inotify_init
+254	64	inotify_add_watch	sys_inotify_add_watch
+255	64	inotify_rm_watch	sys_inotify_rm_watch
+256	64	migrate_pages		sys_migrate_pages
+257	64	openat			sys_openat
+258	64	mkdirat			sys_mkdirat
+259	64	mknodat			sys_mknodat
+260	64	fchownat		sys_fchownat
+261	64	futimesat		sys_futimesat
+262	64	newfstatat		sys_newfstatat
+263	64	unlinkat		sys_unlinkat
+264	64	renameat		sys_renameat
+265	64	linkat			sys_linkat
+266	64	symlinkat		sys_symlinkat
+267	64	readlinkat		sys_readlinkat
+268	64	fchmodat		sys_fchmodat
+269	64	faccessat		sys_faccessat
+270	64	pselect6		sys_pselect6
+271	64	ppoll			sys_ppoll
+272	64	unshare			sys_unshare
+273	64	set_robust_list		sys_set_robust_list
+274	64	get_robust_list		sys_get_robust_list
+275	64	splice			sys_splice
+276	64	tee			sys_tee
+277	64	sync_file_range		sys_sync_file_range
+278	64	vmsplice		sys_vmsplice
+279	64	move_pages		sys_move_pages
+280	64	utimensat		sys_utimensat
+281	64	epoll_pwait		sys_epoll_pwait
+282	64	signalfd		sys_signalfd
+283	64	timerfd_create		sys_timerfd_create
+284	64	eventfd			sys_eventfd
+285	64	fallocate		sys_fallocate
+286	64	timerfd_settime		sys_timerfd_settime
+287	64	timerfd_gettime		sys_timerfd_gettime
+288	64	accept4			sys_accept4
+289	64	signalfd4		sys_signalfd4
+290	64	eventfd2		sys_eventfd2
+291	64	epoll_create1		sys_epoll_create1
+292	64	dup3			sys_dup3
+293	64	pipe2			sys_pipe2
+294	64	inotify_init1		sys_inotify_init1
+295	64	preadv			sys_preadv
+296	64	pwritev			sys_pwritev
+297	64	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo
+298	64	perf_event_open		sys_perf_event_open
+299	64	recvmmsg		sys_recvmmsg
+300	64	fanotify_init		sys_fanotify_init
+301	64	fanotify_mark		sys_fanotify_mark
+302	64	prlimit64		sys_prlimit64
+303	64	name_to_handle_at	sys_name_to_handle_at
+304	64	open_by_handle_at	sys_open_by_handle_at
+305	64	clock_adjtime		sys_clock_adjtime
+306	64	syncfs			sys_syncfs
+307	64	sendmmsg		sys_sendmmsg
+308	64	setns			sys_setns
+309	64	getcpu			sys_getcpu
+310	64	process_vm_readv	sys_process_vm_readv
+311	64	process_vm_writev	sys_process_vm_writev
diff --git a/arch/x86/syscalls/syscallhdr.sh b/arch/x86/syscalls/syscallhdr.sh
new file mode 100644
index 0000000..31fd5f1
--- /dev/null
+++ b/arch/x86/syscalls/syscallhdr.sh
@@ -0,0 +1,27 @@
+#!/bin/sh
+
+in="$1"
+out="$2"
+my_abis=`echo "($3)" | tr ',' '|'`
+prefix="$4"
+offset="$5"
+
+fileguard=_ASM_X86_`basename "$out" | sed \
+    -e 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' \
+    -e 's/[^A-Z0-9_]/_/g' -e 's/__/_/g'`
+grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my_abis}" "$in" | sort -n | (
+    echo "#ifndef ${fileguard}"
+    echo "#define ${fileguard} 1"
+    echo ""
+
+    while read nr abi name entry ; do
+	if [ -z "$offset" ]; then
+	    echo "#define __NR_${prefix}${name} $nr"
+	else
+	    echo "#define __NR_${prefix}${name} ($offset + $nr)"
+        fi
+    done
+
+    echo ""
+    echo "#endif /* ${fileguard} */"
+) > "$out"
diff --git a/arch/x86/syscalls/syscalltbl.sh b/arch/x86/syscalls/syscalltbl.sh
new file mode 100644
index 0000000..0e7f8ec
--- /dev/null
+++ b/arch/x86/syscalls/syscalltbl.sh
@@ -0,0 +1,15 @@
+#!/bin/sh
+
+in="$1"
+out="$2"
+
+grep '^[0-9]' "$in" | sort -n | (
+    while read nr abi name entry compat; do
+	abi=`echo "$abi" | tr '[a-z]' '[A-Z]'`
+	if [ -n "$compat" ]; then
+	    echo "__SYSCALL_${abi}($nr, $entry, $compat)"
+	elif [ -n "$entry" ]; then
+	    echo "__SYSCALL_${abi}($nr, $entry, $entry)"
+	fi
+    done
+) > "$out"
diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index 8fb5840..5d065b2 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -37,7 +37,8 @@ subarch-$(CONFIG_MODULES) += ../kernel/module.o
 USER_OBJS := bugs_$(BITS).o ptrace_user.o fault.o
 
 extra-y += user-offsets.s
-$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
+$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS) \
+	-Iarch/x86/include/generated
 
 UNPROFILE_OBJS := stub_segv.o
 CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
diff --git a/arch/x86/um/sys_call_table_32.S b/arch/x86/um/sys_call_table_32.S
deleted file mode 100644
index a7ca80d..0000000
--- a/arch/x86/um/sys_call_table_32.S
+++ /dev/null
@@ -1,26 +0,0 @@
-#include <linux/linkage.h>
-/* Steal i386 syscall table for our purposes, but with some slight changes.*/
-
-#define sys_iopl sys_ni_syscall
-#define sys_ioperm sys_ni_syscall
-
-#define sys_vm86old sys_ni_syscall
-#define sys_vm86 sys_ni_syscall
-
-#define old_mmap sys_old_mmap
-
-#define ptregs_fork sys_fork
-#define ptregs_execve sys_execve
-#define ptregs_iopl sys_iopl
-#define ptregs_vm86old sys_vm86old
-#define ptregs_clone sys_clone
-#define ptregs_vm86 sys_vm86
-#define ptregs_sigaltstack sys_sigaltstack
-#define ptregs_vfork sys_vfork
-
-.section .rodata,"a"
-
-#include "../kernel/syscall_table_32.S"
-
-ENTRY(syscall_table_size)
-.long .-sys_call_table
diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
new file mode 100644
index 0000000..416bd40
--- /dev/null
+++ b/arch/x86/um/sys_call_table_32.c
@@ -0,0 +1,55 @@
+/*
+ * System call table for UML/i386, copied from arch/x86/kernel/syscall_*.c
+ * with some changes for UML.
+ */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <linux/cache.h>
+#include <generated/user_constants.h>
+
+#define __NO_STUBS
+
+/*
+ * Below you can see, in terms of #define's, the differences between the x86-64
+ * and the UML syscall table.
+ */
+
+/* Not going to be implemented by UML, since we have no hardware. */
+#define sys_iopl sys_ni_syscall
+#define sys_ioperm sys_ni_syscall
+
+#define sys_vm86old sys_ni_syscall
+#define sys_vm86 sys_ni_syscall
+
+#define old_mmap sys_old_mmap
+
+#define ptregs_fork sys_fork
+#define ptregs_execve sys_execve
+#define ptregs_iopl sys_iopl
+#define ptregs_vm86old sys_vm86old
+#define ptregs_clone sys_clone
+#define ptregs_vm86 sys_vm86
+#define ptregs_sigaltstack sys_sigaltstack
+#define ptregs_vfork sys_vfork
+
+#define __SYSCALL_I386(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_32.h>
+
+#undef __SYSCALL_I386
+#define __SYSCALL_I386(nr, sym, compat) [ nr ] = sym,
+
+typedef void (*sys_call_ptr_t)(void);
+
+extern void sys_ni_syscall(void);
+
+const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+	/*
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+#include <asm/syscalls_32.h>
+};
+
+int syscall_table_size = sizeof(sys_call_table);
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index 99522f7..fe626c3 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -1,11 +1,12 @@
 /*
- * System call table for UML/x86-64, copied from arch/x86_64/kernel/syscall.c
+ * System call table for UML/x86-64, copied from arch/x86/kernel/syscall_*.c
  * with some changes for UML.
  */
 
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
+#include <generated/user_constants.h>
 
 #define __NO_STUBS
 
@@ -34,31 +35,23 @@
 #define stub_sigaltstack sys_sigaltstack
 #define stub_rt_sigreturn sys_rt_sigreturn
 
-#define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_UNISTD_64_H
-#include "../../x86/include/asm/unistd_64.h"
+#define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
+#include <asm/syscalls_64.h>
 
-#undef __SYSCALL
-#define __SYSCALL(nr, sym) [ nr ] = sym,
-#undef _ASM_X86_UNISTD_64_H
+#undef __SYSCALL_64
+#define __SYSCALL_64(nr, sym, compat) [ nr ] = sym,
 
 typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-/*
- * We used to have a trick here which made sure that holes in the
- * x86_64 table were filled in with sys_ni_syscall, but a comment in
- * unistd_64.h says that holes aren't allowed, so the trick was
- * removed.
- * The trick looked like this
- *	[0 ... UM_NR_syscall_max] = &sys_ni_syscall
- * before including unistd_64.h - the later initializations overwrote
- * the sys_ni_syscall filler.
- */
-
-sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
-#include <asm/unistd_64.h>
+const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+	/*
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
+	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+#include <asm/syscalls_64.h>
 };
 
 int syscall_table_size = sizeof(sys_call_table);
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index ca49be8..5edf4f4 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -8,6 +8,18 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+#ifdef __i386__
+#define __SYSCALL_I386(nr, sym, compat) [nr] = 1,
+static char syscalls[] = {
+#include <asm/syscalls_32.h>
+};
+#else
+#define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+static char syscalls[] = {
+#include <asm/syscalls_64.h>
+};
+#endif
+
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
 
@@ -77,4 +89,7 @@ void foo(void)
 	DEFINE(UM_PROT_READ, PROT_READ);
 	DEFINE(UM_PROT_WRITE, PROT_WRITE);
 	DEFINE(UM_PROT_EXEC, PROT_EXEC);
+
+	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
+	DEFINE(NR_syscalls, sizeof(syscalls));
 }
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index a57f5bd..d3bae5e 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -4,12 +4,16 @@
 # header-y  - list files to be installed. They are preprocessed
 #             to remove __KERNEL__ section of the file
 # objhdr-y  - Same as header-y but for generated files
+# genhdr-y  - Same as objhdr-y but in a generated/ directory
 #
 # ==========================================================================
 
 # called may set destination dir (when installing to asm/)
 _dst := $(if $(dst),$(dst),$(obj))
 
+# generated header directory
+gen := $(if $(gen),$(gen),$(subst include/,include/generated/,$(obj)))
+
 kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
@@ -33,9 +37,10 @@ wrapper-files := $(filter $(header-y), $(generic-y))
 
 # all headers files for this dir
 header-y      := $(filter-out $(generic-y), $(header-y))
-all-files     := $(header-y) $(objhdr-y) $(wrapper-files)
+all-files     := $(header-y) $(objhdr-y) $(genhdr-y) $(wrapper-files)
 input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
-                 $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
+                 $(addprefix $(objtree)/$(obj)/,$(objhdr-y)) \
+                 $(addprefix $(objtree)/$(gen)/,$(genhdr-y))
 output-files  := $(addprefix $(install)/, $(all-files))
 
 # Work out what needs to be removed
@@ -52,6 +57,7 @@ quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
       cmd_install = \
         $(PERL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
         $(PERL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
+        $(PERL) $< $(objtree)/$(gen) $(install) $(SRCARCH) $(genhdr-y); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(install)/$$F;    \
         done;                                                           \
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 3ab316e..d24810f 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -198,11 +198,16 @@ EOF
 }
 
 syscall_list() {
-sed -n -e '/^\#define/ s/[^_]*__NR_\([^[:space:]]*\).*/\
-\#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
-\#warning syscall \1 not implemented\
-\#endif/p' $1
+    grep '^[0-9]' "$1" | sort -n | (
+	while read nr abi name entry ; do
+	    echo <<EOF
+#if !defined(__NR_${name}) && !defined(__IGNORE_${name})
+#warning syscall ${name} not implemented
+#endif
+EOF
+	done
+    )
 }
 
-(ignore_list && syscall_list $(dirname $0)/../arch/x86/include/asm/unistd_32.h) | \
+(ignore_list && syscall_list $(dirname $0)/../arch/x86/syscalls/syscall_32.tbl) | \
 $* -E -x c - > /dev/null
