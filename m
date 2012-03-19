Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894Ab2CSRuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:50:16 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:63586 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2CSRuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:50:08 -0400
Date: Mon, 19 Mar 2012 18:50:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Introduce the X32 binary format on x86, for v3.4
Message-ID: <20120319175002.GA21093@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-x32-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-x32-for-linus

   HEAD: 31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4 x32: Fix alignment fail in struct compat_siginfo

This tree introduces the X32 binary format and execution mode 
for x86: 32-bit data space binaries using 64-bit instructions 
and 64-bit kernel syscalls.

This allows applications whose working set fits into a 32 bits 
address space to make use of 64-bit instructions while using a 
32-bit address space with shorter pointers, more compressed data 
structures, etc.

out-of-topic modifications in x86-x32-for-linus:
------------------------------------------------
arch/alpha/include/asm/posix_types.h# cee1332: alpha: Use generic posix_types.h
arch/arm/include/asm/posix_types.h # e7ca2e1: arm: Use generic posix_types.h
arch/avr32/include/asm/posix_types.h# 0967504: avr32: Use generic posix_types.h
arch/cris/include/asm/posix_types.h# 4d6232b: cris: Use generic posix_types.h
arch/frv/include/asm/posix_types.h # 4fb16b5: frv: Use generic posix_types.h
arch/h8300/include/asm/posix_types.h# e16deba: h8300: Use generic posix_types.h
arch/ia64/include/asm/posix_types.h# f3ce4a0: ia64: Use generic posix_types.h
arch/m32r/include/asm/posix_types.h# 86d10ea: m32r: Use generic posix_types.h
arch/m68k/include/asm/posix_types.h# 08a655c: m68k: Use generic posix_types.h
arch/mips/include/asm/posix_types.h# 86fcd10: mips: Use generic posix_types.h
arch/mips/kernel/kspd.c            # 189017c: fs: Remove missed ->fds_bits from
arch/mn10300/include/asm/posix_types.h# e96d322: mn10300: Use generic posix_types.
arch/parisc/include/asm/posix_types.h# f4f0727: parisc: Use generic posix_types.h
arch/powerpc/include/asm/posix_types.h# fae89ee: powerpc: Use generic posix_types.
arch/powerpc/platforms/cell/spufs/coredump.c# 1dce27c: Wrap accesses to the fd_sets in s
arch/s390/include/asm/posix_types.h# 3b2a469: s390: Use generic posix_types.h
arch/sh/include/asm/posix_types_32.h# 81620bb: sh: Remove unnecessary posix_type
arch/sh/include/asm/posix_types_64.h# 81620bb: sh: Remove unnecessary posix_type
arch/sparc/include/asm/posix_types.h# 8c4c7a9: sparc: Use generic posix_types.h
arch/xtensa/include/asm/posix_types.h# 2759e65: xtensa: Use generic posix_types.h
drivers/char/lp.c                  # 9dd4cca: compat: Handle COMPAT_USE_64BIT_T
drivers/input/input-compat.c       # f930a7a: compat: Use COMPAT_USE_64BIT_TIME
drivers/input/input-compat.h       # f930a7a: compat: Use COMPAT_USE_64BIT_TIME
drivers/staging/android/binder.c   # 189017c: fs: Remove missed ->fds_bits from
                                   # 1dce27c: Wrap accesses to the fd_sets in s
fs/autofs4/dev-ioctl.c             # 1dce27c: Wrap accesses to the fd_sets in s
fs/binfmt_elf.c                    # 0953f65: elf: Allow core dump-related fiel
fs/compat.c                        # 4ee5c0d: compat: Create compat_sys_p{read,
fs/exec.c                          # 1fd36ad: Replace the fd_sets in struct fdt
                                   # 1dce27c: Wrap accesses to the fd_sets in s
fs/fcntl.c                         # 1dce27c: Wrap accesses to the fd_sets in s
fs/file.c                          # f044db4: fs: Fix close_on_exec pointer in 
                                   # 1fd36ad: Replace the fd_sets in struct fdt
                                   # 1dce27c: Wrap accesses to the fd_sets in s
fs/open.c                          # 1dce27c: Wrap accesses to the fd_sets in s
fs/proc/base.c                     # 1dce27c: Wrap accesses to the fd_sets in s
fs/select.c                        # 1fd36ad: Replace the fd_sets in struct fdt
include/asm-generic/posix_types.h  # afead38: posix_types: Introduce __kernel_[
                                   # 8b3d1cd: posix_types: Remove fd_set macros
                                   # 34e6f9e: posix_types: Make it possible to 
                                   # b4255ba: posix_types: Make __kernel_[ug]id
include/linux/Kbuild               # d8e5dde: sysinfo: Move struct sysinfo to a
include/linux/aio_abi.h            # ff88943: aio: Use __kernel_ulong_t to defi
include/linux/compat.h             # 6684ba2: compat: Add helper functions to r
                                   # 45e8778: compat: Introduce COMPAT_USE_64BI
include/linux/fdtable.h            # 1fd36ad: Replace the fd_sets in struct fdt
                                   # 1dce27c: Wrap accesses to the fd_sets in s
include/linux/kernel.h             # d8e5dde: sysinfo: Move struct sysinfo to a
include/linux/sysinfo.h            # 109a1f3: sysinfo: Use explicit types in <l
                                   # d8e5dde: sysinfo: Move struct sysinfo to a
include/linux/time.h               # cf42004: Delete the __FD_*() funcs for ope
                                   # 8b3d1cd: posix_types: Remove fd_set macros
kernel/compat.c                    # 6684ba2: compat: Add helper functions to r
kernel/exit.c                      # 1fd36ad: Replace the fd_sets in struct fdt
net/bluetooth/hci_sock.c           # da88cea: compat: Use COMPAT_USE_64BIT_TIME
net/compat.c                       # ee4fa23: compat: Use COMPAT_USE_64BIT_TIME
net/socket.c                       # 644595f: compat: Handle COMPAT_USE_64BIT_T
security/selinux/hooks.c           # 1fd36ad: Replace the fd_sets in struct fdt

 Thanks,

	Ingo

------------------>
Bobby Powers (3):
      fs: Fix close_on_exec pointer in alloc_fdtable
      x32: Make sure TS_COMPAT is cleared for x32 tasks
      x32: Only clear TIF_X32 flag once

David Howells (4):
      Wrap accesses to the fd_sets in struct fdtable
      Replace the fd_sets in struct fdtable with an array of unsigned longs
      Delete the __FD_*() funcs for operating on fd_set from linux/time.h
      fs: Remove missed ->fds_bits from cessation use of fd_set structs internally

H. J. Lu (10):
      compat: Introduce COMPAT_USE_64BIT_TIME
      compat: Use COMPAT_USE_64BIT_TIME in the input subsystem
      compat: Use COMPAT_USE_64BIT_TIME in the Bluetooth subsystem
      compat: Use COMPAT_USE_64BIT_TIME in net/compat.c
      compat: Create compat_sys_p{read,write}v64
      elf: Allow core dump-related fields to be overridden
      x86-64: Add prototype for old_rsp to a header file
      x32: Add struct ucontext_x32
      x32: Allow x32 to be configured
      x32: Add x32 VDSO support

H. Peter Anvin (52):
      posix_types: Make __kernel_[ug]id32_t default to unsigned int
      posix_types: Make it possible to override __kernel_fsid_t
      alpha: Use generic posix_types.h
      arm: Use generic posix_types.h
      avr32: Use generic posix_types.h
      cris: Use generic posix_types.h
      frv: Use generic posix_types.h
      h8300: Use generic posix_types.h
      ia64: Use generic posix_types.h
      m32r: Use generic posix_types.h
      m68k: Use generic posix_types.h
      mips: Use generic posix_types.h
      mn10300: Use generic posix_types.h
      parisc: Use generic posix_types.h
      powerpc: Use generic posix_types.h
      s390: Use generic posix_types.h
      sh: Remove unnecessary posix_types.h type overrides
      sparc: Use generic posix_types.h
      x86: Use generic posix_types.h
      xtensa: Use generic posix_types.h
      posix_types: Remove fd_set macros
      x86: Factor out TIF_IA32 from 32-bit address space
      x86-64: Use explicit sizes in sigcontext.h, prepare for x32
      sysinfo: Move struct sysinfo to a separate header file
      posix_types: Introduce __kernel_[u]long_t
      x32: Create posix_types_x32.h
      sysinfo: Use explicit types in <linux/sysinfo.h>
      compat: Add helper functions to read/write struct timeval, timespec
      compat: Handle COMPAT_USE_64BIT_TIME in the lp driver
      compat: Handle COMPAT_USE_64BIT_TIME in net/socket.c
      aio: Use __kernel_ulong_t to define aio_context_t
      x32: Add a thread flag for x32 processes
      x86-64, ia32: Drop sys32_rt_sigprocmask
      x32: Add x32 system calls to syscall/syscall_64.tbl
      x32: Generate <asm/unistd_x32.h>
      x32: Generate <asm/unistd_64_x32.h>
      x86: Move some signal-handling definitions to a common header
      x32: Export setup/restore_sigcontext from signal.c
      x32: Add rt_sigframe_x32
      x32: Handle the x32 system call flag
      x86: Add #ifdef CONFIG_COMPAT to <asm/sys_ia32.h>
      x32: Signal-related system calls
      x32: Handle process creation
      x32: If configured, add x32 system calls to system call tables
      x32: Fix coding style violations in the x32 VDSO code
      x32: Drop non-__vdso weak symbols from the x32 VDSO
      x32: Warn and disable rather than error if binutils too old
      x86, mtrr: Use explicit sizing and padding for the 64-bit ioctls
      x32: Provide separate is_ia32_task() and is_x32_task() predicates
      x32: Switch to a 64-bit clock_t
      x32: Fix stupid ia32/x32 inversion in the siginfo format
      x32: Fix alignment fail in struct compat_siginfo

H.J. Lu (1):
      x32: Add ptrace for x32

Ingo Molnar (1):
      x86/x32: Fix the binutils auto-detect


 Documentation/filesystems/files.txt          |    4 +-
 arch/alpha/include/asm/posix_types.h         |  113 +-----
 arch/arm/include/asm/posix_types.h           |   55 +--
 arch/avr32/include/asm/posix_types.h         |  107 +-----
 arch/cris/include/asm/posix_types.h          |   50 +--
 arch/frv/include/asm/posix_types.h           |   53 +--
 arch/h8300/include/asm/posix_types.h         |   49 +--
 arch/ia64/include/asm/posix_types.h          |  121 +------
 arch/m32r/include/asm/posix_types.h          |  108 +-----
 arch/m68k/include/asm/posix_types.h          |   53 +--
 arch/mips/include/asm/posix_types.h          |  121 +-----
 arch/mips/kernel/kspd.c                      |    2 +-
 arch/mn10300/include/asm/posix_types.h       |  111 +-----
 arch/parisc/include/asm/posix_types.h        |  119 +-----
 arch/powerpc/include/asm/posix_types.h       |  118 +-----
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 +-
 arch/s390/include/asm/posix_types.h          |   70 +---
 arch/sh/include/asm/posix_types_32.h         |    5 -
 arch/sh/include/asm/posix_types_64.h         |    4 -
 arch/sparc/include/asm/posix_types.h         |  133 +-----
 arch/x86/Kconfig                             |   21 +-
 arch/x86/Makefile                            |   16 +
 arch/x86/ia32/ia32_signal.c                  |   22 +-
 arch/x86/ia32/sys_ia32.c                     |   40 --
 arch/x86/include/asm/Kbuild                  |    2 +
 arch/x86/include/asm/compat.h                |   49 ++-
 arch/x86/include/asm/elf.h                   |   31 ++-
 arch/x86/include/asm/ia32.h                  |   18 +
 arch/x86/include/asm/mtrr.h                  |   28 +-
 arch/x86/include/asm/posix_types.h           |    4 +-
 arch/x86/include/asm/posix_types_32.h        |   75 +---
 arch/x86/include/asm/posix_types_64.h        |  106 +-----
 arch/x86/include/asm/posix_types_x32.h       |   19 +
 arch/x86/include/asm/processor.h             |   10 +-
 arch/x86/include/asm/ptrace.h                |    1 -
 arch/x86/include/asm/sigcontext.h            |   57 ++--
 arch/x86/include/asm/sigframe.h              |   13 +
 arch/x86/include/asm/sighandling.h           |   24 +
 arch/x86/include/asm/sys_ia32.h              |    7 +-
 arch/x86/include/asm/syscall.h               |    5 +-
 arch/x86/include/asm/thread_info.h           |    6 +-
 arch/x86/include/asm/unistd.h                |   15 +-
 arch/x86/kernel/asm-offsets_64.c             |    6 +
 arch/x86/kernel/cpu/mtrr/if.c                |   10 +-
 arch/x86/kernel/cpu/perf_event.c             |    4 +-
 arch/x86/kernel/entry_64.S                   |   44 ++
 arch/x86/kernel/process_64.c                 |   27 +-
 arch/x86/kernel/ptrace.c                     |   99 +++++
 arch/x86/kernel/signal.c                     |  138 ++++++-
 arch/x86/kernel/sys_x86_64.c                 |    6 +-
 arch/x86/kernel/syscall_64.c                 |    8 +
 arch/x86/oprofile/backtrace.c                |    2 +-
 arch/x86/syscalls/Makefile                   |   22 +-
 arch/x86/syscalls/syscall_32.tbl             |    2 +-
 arch/x86/syscalls/syscall_64.tbl             |  579 ++++++++++++++------------
 arch/x86/um/sys_call_table_64.c              |    3 +
 arch/x86/um/user-offsets.c                   |    2 +
 arch/x86/vdso/.gitignore                     |    2 +
 arch/x86/vdso/Makefile                       |   46 ++-
 arch/x86/vdso/vdso32-setup.c                 |    5 +
 arch/x86/vdso/vdsox32.S                      |   22 +
 arch/x86/vdso/vdsox32.lds.S                  |   28 ++
 arch/x86/vdso/vma.c                          |   78 +++-
 arch/xtensa/include/asm/posix_types.h        |   97 +----
 drivers/char/lp.c                            |    5 +-
 drivers/input/input-compat.c                 |    4 +-
 drivers/input/input-compat.h                 |    2 +-
 drivers/staging/android/binder.c             |   13 +-
 fs/autofs4/dev-ioctl.c                       |    2 +-
 fs/binfmt_elf.c                              |   24 +-
 fs/compat.c                                  |   26 +-
 fs/exec.c                                    |    8 +-
 fs/fcntl.c                                   |   18 +-
 fs/file.c                                    |   52 ++--
 fs/open.c                                    |    4 +-
 fs/proc/base.c                               |    2 +-
 fs/select.c                                  |    2 +-
 include/asm-generic/posix_types.h            |  109 +----
 include/linux/Kbuild                         |    1 +
 include/linux/aio_abi.h                      |    2 +-
 include/linux/compat.h                       |   20 +
 include/linux/fdtable.h                      |   46 ++-
 include/linux/kernel.h                       |   21 +-
 include/linux/sysinfo.h                      |   24 +
 include/linux/time.h                         |    1 +
 kernel/compat.c                              |   68 +++-
 kernel/exit.c                                |    2 +-
 net/bluetooth/hci_sock.c                     |    3 +-
 net/compat.c                                 |   65 ++--
 net/socket.c                                 |   18 +-
 security/selinux/hooks.c                     |    2 +-
 91 files changed, 1561 insertions(+), 2180 deletions(-)
 create mode 100644 arch/x86/include/asm/posix_types_x32.h
 create mode 100644 arch/x86/include/asm/sighandling.h
 create mode 100644 arch/x86/vdso/vdsox32.S
 create mode 100644 arch/x86/vdso/vdsox32.lds.S
 create mode 100644 include/linux/sysinfo.h

diff --git a/Documentation/filesystems/files.txt b/Documentation/filesystems/files.txt
index ac2facc..46dfc6b 100644
--- a/Documentation/filesystems/files.txt
+++ b/Documentation/filesystems/files.txt
@@ -113,8 +113,8 @@ the fdtable structure -
 	if (fd >= 0) {
 		/* locate_fd() may have expanded fdtable, load the ptr */
 		fdt = files_fdtable(files);
-		FD_SET(fd, fdt->open_fds);
-		FD_CLR(fd, fdt->close_on_exec);
+		__set_open_fd(fd, fdt);
+		__clear_close_on_exec(fd, fdt);
 		spin_unlock(&files->file_lock);
 	.....
 
diff --git a/arch/alpha/include/asm/posix_types.h b/arch/alpha/include/asm/posix_types.h
index db16741..24779fc 100644
--- a/arch/alpha/include/asm/posix_types.h
+++ b/arch/alpha/include/asm/posix_types.h
@@ -8,116 +8,13 @@
  */
 
 typedef unsigned int	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned int	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef long long	__kernel_loff_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_timer_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
-
-typedef unsigned int	__kernel_old_dev_t;
-
-#ifdef __KERNEL__
-
-#ifndef __GNUC__
-
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
-#define	__FD_ZERO(set)	\
-  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
-
-#else /* __GNUC__ */
-
-/* With GNU C, use inline functions instead so args are evaluated only once: */
+#define __kernel_ino_t __kernel_ino_t
 
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, const __kernel_fd_set *p)
-{ 
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		      case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-
-		      case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
-
-		      case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
+typedef unsigned int	__kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
 
-#endif /* __GNUC__ */
+typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
 
-#endif /* __KERNEL__ */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ALPHA_POSIX_TYPES_H */
diff --git a/arch/arm/include/asm/posix_types.h b/arch/arm/include/asm/posix_types.h
index 2446d23..efdf990 100644
--- a/arch/arm/include/asm/posix_types.h
+++ b/arch/arm/include/asm/posix_types.h
@@ -19,59 +19,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long		__kernel_ino_t;
 typedef unsigned short		__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short		__kernel_nlink_t;
-typedef long			__kernel_off_t;
-typedef int			__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short		__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short		__kernel_uid_t;
 typedef unsigned short		__kernel_gid_t;
-typedef unsigned int		__kernel_size_t;
-typedef int			__kernel_ssize_t;
-typedef int			__kernel_ptrdiff_t;
-typedef long			__kernel_time_t;
-typedef long			__kernel_suseconds_t;
-typedef long			__kernel_clock_t;
-typedef int			__kernel_timer_t;
-typedef int			__kernel_clockid_t;
-typedef int			__kernel_daddr_t;
-typedef char *			__kernel_caddr_t;
-typedef unsigned short		__kernel_uid16_t;
-typedef unsigned short		__kernel_gid16_t;
-typedef unsigned int		__kernel_uid32_t;
-typedef unsigned int		__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
-typedef unsigned short		__kernel_old_uid_t;
-typedef unsigned short		__kernel_old_gid_t;
 typedef unsigned short		__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long		__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define __FD_SET(fd, fdsetp) \
-		(((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] |= (1<<((fd) & 31)))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd, fdsetp) \
-		(((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] &= ~(1<<((fd) & 31)))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd, fdsetp) \
-		((((fd_set *)(fdsetp))->fds_bits[(fd) >> 5] & (1<<((fd) & 31))) != 0)
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) \
-		(memset (fdsetp, 0, sizeof (*(fd_set *)(fdsetp))))
-
-#endif
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/avr32/include/asm/posix_types.h b/arch/avr32/include/asm/posix_types.h
index fe0c0c0..74667bf 100644
--- a/arch/avr32/include/asm/posix_types.h
+++ b/arch/avr32/include/asm/posix_types.h
@@ -14,112 +14,27 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long   __kernel_ino_t;
 typedef unsigned short  __kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short  __kernel_nlink_t;
-typedef long            __kernel_off_t;
-typedef int             __kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short  __kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned long	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
-typedef long            __kernel_time_t;
-typedef long            __kernel_suseconds_t;
-typedef long            __kernel_clock_t;
-typedef int             __kernel_timer_t;
-typedef int             __kernel_clockid_t;
-typedef int             __kernel_daddr_t;
-typedef char *          __kernel_caddr_t;
-typedef unsigned short  __kernel_uid16_t;
-typedef unsigned short  __kernel_gid16_t;
-typedef unsigned int    __kernel_uid32_t;
-typedef unsigned int    __kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
 typedef unsigned short  __kernel_old_uid_t;
 typedef unsigned short  __kernel_old_gid_t;
-typedef unsigned short  __kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long       __kernel_loff_t;
-#endif
-
-typedef struct {
-    int     val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef  __FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-    unsigned long __tmp = __fd / __NFDBITS;
-    unsigned long __rem = __fd % __NFDBITS;
-    __fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef  __FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-    unsigned long __tmp = __fd / __NFDBITS;
-    unsigned long __rem = __fd % __NFDBITS;
-    __fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
+#define __kernel_old_uid_t __kernel_old_uid_t
 
+typedef unsigned short  __kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#undef  __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-    unsigned long __tmp = __fd / __NFDBITS;
-    unsigned long __rem = __fd % __NFDBITS;
-    return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef  __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-    unsigned long *__tmp = __p->fds_bits;
-    int __i;
-
-    if (__builtin_constant_p(__FDSET_LONGS)) {
-        switch (__FDSET_LONGS) {
-            case 16:
-                __tmp[ 0] = 0; __tmp[ 1] = 0;
-                __tmp[ 2] = 0; __tmp[ 3] = 0;
-                __tmp[ 4] = 0; __tmp[ 5] = 0;
-                __tmp[ 6] = 0; __tmp[ 7] = 0;
-                __tmp[ 8] = 0; __tmp[ 9] = 0;
-                __tmp[10] = 0; __tmp[11] = 0;
-                __tmp[12] = 0; __tmp[13] = 0;
-                __tmp[14] = 0; __tmp[15] = 0;
-                return;
-
-            case 8:
-                __tmp[ 0] = 0; __tmp[ 1] = 0;
-                __tmp[ 2] = 0; __tmp[ 3] = 0;
-                __tmp[ 4] = 0; __tmp[ 5] = 0;
-                __tmp[ 6] = 0; __tmp[ 7] = 0;
-                return;
-
-            case 4:
-                __tmp[ 0] = 0; __tmp[ 1] = 0;
-                __tmp[ 2] = 0; __tmp[ 3] = 0;
-                return;
-        }
-    }
-    __i = __FDSET_LONGS;
-    while (__i) {
-        __i--;
-        *__tmp = 0;
-        __tmp++;
-    }
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* __ASM_AVR32_POSIX_TYPES_H */
diff --git a/arch/cris/include/asm/posix_types.h b/arch/cris/include/asm/posix_types.h
index ce3fb25..72b3cd6 100644
--- a/arch/cris/include/asm/posix_types.h
+++ b/arch/cris/include/asm/posix_types.h
@@ -12,55 +12,25 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short  __kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
+#define __kernel_uid_t __kernel_uid_t
+
 typedef __SIZE_TYPE__	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long            __kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short  __kernel_uid16_t;
-typedef unsigned short  __kernel_gid16_t;
-typedef unsigned int    __kernel_uid32_t;
-typedef unsigned int    __kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
-typedef unsigned short  __kernel_old_uid_t;
-typedef unsigned short  __kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifdef __KERNEL__
-
-#undef	__FD_SET
-#define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp) clear_bit(fd, (void *)(fdsetp))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp) test_bit(fd, (void *)(fdsetp))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) memset((void *)(fdsetp), 0, __FDSET_LONGS << 2)
-
-#endif /* __KERNEL__ */
+#define __kernel_old_dev_t __kernel_old_dev_t
 
 #endif /* __ARCH_CRIS_POSIX_TYPES_H */
diff --git a/arch/frv/include/asm/posix_types.h b/arch/frv/include/asm/posix_types.h
index a9f1f5b..3f34cb4 100644
--- a/arch/frv/include/asm/posix_types.h
+++ b/arch/frv/include/asm/posix_types.h
@@ -7,56 +7,23 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
+#define __kernel_uid_t __kernel_uid_t
 
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
+typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
 
diff --git a/arch/h8300/include/asm/posix_types.h b/arch/h8300/include/asm/posix_types.h
index 6f833a1..bc4c34e 100644
--- a/arch/h8300/include/asm/posix_types.h
+++ b/arch/h8300/include/asm/posix_types.h
@@ -7,54 +7,23 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
 typedef unsigned short	__kernel_old_uid_t;
 typedef unsigned short	__kernel_old_gid_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/ia64/include/asm/posix_types.h b/arch/ia64/include/asm/posix_types.h
index 1788556..7323ab9 100644
--- a/arch/ia64/include/asm/posix_types.h
+++ b/arch/ia64/include/asm/posix_types.h
@@ -1,126 +1,11 @@
 #ifndef _ASM_IA64_POSIX_TYPES_H
 #define _ASM_IA64_POSIX_TYPES_H
 
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- *
- * Based on <asm-alpha/posix_types.h>.
- *
- * Modified 1998-2000, 2003
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
 typedef unsigned int	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef long long	__kernel_loff_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
-
-typedef unsigned int	__kernel_old_dev_t;
-
-# ifdef __KERNEL__
-
-#  ifndef __GNUC__
-
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
-#define	__FD_ZERO(set)	\
-  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
+#define __kernel_nlink_t __kernel_nlink_t
 
-#  else /* !__GNUC__ */
-
-/* With GNU C, use inline functions instead so args are evaluated only once: */
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, const __kernel_fd_set *p)
-{ 
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		      case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-
-		      case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
+typedef unsigned long	__kernel_sigset_t;	/* at least 32 bits */
 
-		      case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
+#include <asm-generic/posix_types.h>
 
-#  endif /* !__GNUC__ */
-# endif /* __KERNEL__ */
 #endif /* _ASM_IA64_POSIX_TYPES_H */
diff --git a/arch/m32r/include/asm/posix_types.h b/arch/m32r/include/asm/posix_types.h
index b309c58..0195850 100644
--- a/arch/m32r/include/asm/posix_types.h
+++ b/arch/m32r/include/asm/posix_types.h
@@ -7,112 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef	__FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-
-#undef	__FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef	__FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif  /* _ASM_M32R_POSIX_TYPES_H */
diff --git a/arch/m68k/include/asm/posix_types.h b/arch/m68k/include/asm/posix_types.h
index 98d0970..6373093 100644
--- a/arch/m68k/include/asm/posix_types.h
+++ b/arch/m68k/include/asm/posix_types.h
@@ -7,55 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
+#define __kernel_uid_t __kernel_uid_t
 
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
+typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/mips/include/asm/posix_types.h b/arch/mips/include/asm/posix_types.h
index c200102..e0308dc 100644
--- a/arch/mips/include/asm/posix_types.h
+++ b/arch/mips/include/asm/posix_types.h
@@ -17,128 +17,21 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-#if (_MIPS_SZLONG == 32)
-typedef unsigned long	__kernel_nlink_t;
-#endif
 #if (_MIPS_SZLONG == 64)
 typedef unsigned int	__kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
 #endif
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-#if (_MIPS_SZLONG == 32)
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-#endif
-#if (_MIPS_SZLONG == 64)
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-#endif
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef long		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
 
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-typedef __kernel_uid_t	__kernel_old_uid_t;
-typedef __kernel_gid_t	__kernel_old_gid_t;
-typedef unsigned int	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long      __kernel_loff_t;
-#endif
+typedef long		__kernel_daddr_t;
+#define __kernel_daddr_t __kernel_daddr_t
 
-typedef struct {
 #if (_MIPS_SZLONG == 32)
+typedef struct {
 	long	val[2];
-#endif
-#if (_MIPS_SZLONG == 64)
-	int	val[2];
-#endif
 } __kernel_fsid_t;
+#define __kernel_fsid_t __kernel_fsid_t
+#endif
 
-#if defined(__KERNEL__)
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_POSIX_TYPES_H */
diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index 29811f0..84d0639 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -326,7 +326,7 @@ static void sp_cleanup(void)
 		i = j * __NFDBITS;
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j++];
+		set = fdt->open_fds[j++];
 		while (set) {
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
diff --git a/arch/mn10300/include/asm/posix_types.h b/arch/mn10300/include/asm/posix_types.h
index 56ffbc1..ab50618 100644
--- a/arch/mn10300/include/asm/posix_types.h
+++ b/arch/mn10300/include/asm/posix_types.h
@@ -17,14 +17,19 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
+#define __kernel_uid_t __kernel_uid_t
+
 #if __GNUC__ == 4
 typedef unsigned int	__kernel_size_t;
 typedef signed int	__kernel_ssize_t;
@@ -33,105 +38,11 @@ typedef unsigned long	__kernel_size_t;
 typedef signed long	__kernel_ssize_t;
 #endif
 typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
-	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
-
-#undef	__FD_SET
-static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef	__FD_CLR
-static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-
-#undef	__FD_ISSET
-static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef	__FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_POSIX_TYPES_H */
diff --git a/arch/parisc/include/asm/posix_types.h b/arch/parisc/include/asm/posix_types.h
index 00da29a..5212b03 100644
--- a/arch/parisc/include/asm/posix_types.h
+++ b/arch/parisc/include/asm/posix_types.h
@@ -6,123 +6,22 @@
  * be a little careful about namespace pollution etc.  Also, we cannot
  * assume GCC is being used.
  */
-typedef unsigned long		__kernel_ino_t;
+
 typedef unsigned short		__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short		__kernel_nlink_t;
-typedef long			__kernel_off_t;
-typedef int			__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short		__kernel_ipc_pid_t;
-typedef unsigned int		__kernel_uid_t;
-typedef unsigned int		__kernel_gid_t;
-typedef int			__kernel_suseconds_t;
-typedef long			__kernel_clock_t;
-typedef int			__kernel_timer_t;
-typedef int			__kernel_clockid_t;
-typedef int			__kernel_daddr_t;
-/* Note these change from narrow to wide kernels */
-#ifdef CONFIG_64BIT
-typedef unsigned long		__kernel_size_t;
-typedef long			__kernel_ssize_t;
-typedef long			__kernel_ptrdiff_t;
-#else
-typedef unsigned int		__kernel_size_t;
-typedef int			__kernel_ssize_t;
-typedef int			__kernel_ptrdiff_t;
-#endif
-typedef long			__kernel_time_t;
-typedef char *			__kernel_caddr_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
 
-typedef unsigned short		__kernel_uid16_t;
-typedef unsigned short		__kernel_gid16_t;
-typedef unsigned int		__kernel_uid32_t;
-typedef unsigned int		__kernel_gid32_t;
+typedef int			__kernel_suseconds_t;
+#define __kernel_suseconds_t __kernel_suseconds_t
 
-#ifdef __GNUC__
-typedef long long		__kernel_loff_t;
 typedef long long		__kernel_off64_t;
 typedef unsigned long long	__kernel_ino64_t;
-#endif
-
-typedef unsigned int		__kernel_old_dev_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-/* compatibility stuff */
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-
-#if defined(__KERNEL__)
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{ 
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
 
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/powerpc/include/asm/posix_types.h b/arch/powerpc/include/asm/posix_types.h
index c4e396b..f139325 100644
--- a/arch/powerpc/include/asm/posix_types.h
+++ b/arch/powerpc/include/asm/posix_types.h
@@ -7,122 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef long		__kernel_suseconds_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-typedef unsigned int	__kernel_old_uid_t;
-typedef unsigned int	__kernel_old_gid_t;
-
 #ifdef __powerpc64__
-typedef unsigned long  	__kernel_nlink_t;
-typedef int             __kernel_ipc_pid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
 typedef unsigned long	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 #else
-typedef unsigned short	__kernel_nlink_t;
-typedef short		__kernel_ipc_pid_t;
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
-typedef unsigned int	__kernel_old_dev_t;
-#endif
-
-#ifdef __powerpc64__
-typedef long long	__kernel_loff_t;
-#else
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifndef __GNUC__
-
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	(((set)->fds_bits[__FDELT(d)] & __FDMASK(d)) != 0)
-#define	__FD_ZERO(set)	\
-  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
-
-#else /* __GNUC__ */
-
-#if defined(__KERNEL__)
-/* With GNU C, use inline functions instead so args are evaluated only once: */
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, __kernel_fd_set *p)
-{ 
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = (unsigned long *)p->fds_bits;
-	int i;
+typedef long		__kernel_ptrdiff_t;
+#define __kernel_size_t __kernel_size_t
 
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		      case 16:
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
+typedef unsigned short	__kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
 
-		      case 8:
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
+typedef short		__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+#endif
 
-		      case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
+#include <asm-generic/posix_types.h>
 
-#endif /* defined(__KERNEL__) */
-#endif /* __GNUC__ */
 #endif /* _ASM_POWERPC_POSIX_TYPES_H */
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 03c5fce..c2c5b07 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -122,7 +122,7 @@ static struct spu_context *coredump_next_context(int *fd)
 	struct spu_context *ctx = NULL;
 
 	for (; *fd < fdt->max_fds; (*fd)++) {
-		if (!FD_ISSET(*fd, fdt->open_fds))
+		if (!fd_is_open(*fd, fdt))
 			continue;
 
 		file = fcheck(*fd);
diff --git a/arch/s390/include/asm/posix_types.h b/arch/s390/include/asm/posix_types.h
index 8cc113f..edf8527 100644
--- a/arch/s390/include/asm/posix_types.h
+++ b/arch/s390/include/asm/posix_types.h
@@ -3,7 +3,6 @@
  *
  *  S390 version
  *
- *  Derived from "include/asm-i386/posix_types.h"
  */
 
 #ifndef __ARCH_S390_POSIX_TYPES_H
@@ -15,22 +14,11 @@
  * assume GCC is being used.
  */
 
-typedef long            __kernel_off_t;
-typedef int             __kernel_pid_t;
 typedef unsigned long   __kernel_size_t;
-typedef long            __kernel_time_t;
-typedef long            __kernel_suseconds_t;
-typedef long            __kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int             __kernel_daddr_t;
-typedef char *          __kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
+#define __kernel_size_t __kernel_size_t
 
-#ifdef __GNUC__
-typedef long long       __kernel_loff_t;
-#endif
+typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
 #ifndef __s390x__
 
@@ -42,11 +30,6 @@ typedef unsigned short  __kernel_uid_t;
 typedef unsigned short  __kernel_gid_t;
 typedef int             __kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
 
 #else /* __s390x__ */
 
@@ -59,49 +42,16 @@ typedef unsigned int    __kernel_gid_t;
 typedef long            __kernel_ssize_t;
 typedef long            __kernel_ptrdiff_t;
 typedef unsigned long   __kernel_sigset_t;      /* at least 32 bits */
-typedef __kernel_uid_t __kernel_old_uid_t;
-typedef __kernel_gid_t __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
-typedef unsigned short __kernel_old_dev_t;
 
 #endif /* __s390x__ */
 
-typedef struct {
-        int     val[2];
-} __kernel_fsid_t;
-
-
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, const __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (fdsetp->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-#undef  __FD_ZERO
-#define __FD_ZERO(fdsetp) \
-	((void) memset ((void *) (fdsetp), 0, sizeof (__kernel_fd_set)))
+#define __kernel_ino_t  __kernel_ino_t
+#define __kernel_mode_t __kernel_mode_t
+#define __kernel_nlink_t __kernel_nlink_t
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+#define __kernel_uid_t __kernel_uid_t
+#define __kernel_gid_t __kernel_gid_t
 
-#endif     /* __KERNEL__ */
+#include <asm-generic/posix_types.h>
 
 #endif
diff --git a/arch/sh/include/asm/posix_types_32.h b/arch/sh/include/asm/posix_types_32.h
index 6a9ceaa..abda584 100644
--- a/arch/sh/include/asm/posix_types_32.h
+++ b/arch/sh/include/asm/posix_types_32.h
@@ -12,11 +12,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_gid_t __kernel_gid_t
 
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
-
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
 typedef unsigned short	__kernel_old_gid_t;
diff --git a/arch/sh/include/asm/posix_types_64.h b/arch/sh/include/asm/posix_types_64.h
index 8cd1148..fcda07b 100644
--- a/arch/sh/include/asm/posix_types_64.h
+++ b/arch/sh/include/asm/posix_types_64.h
@@ -17,10 +17,6 @@ typedef int		__kernel_ssize_t;
 #define __kernel_ssize_t __kernel_ssize_t
 typedef int		__kernel_ptrdiff_t;
 #define __kernel_ptrdiff_t __kernel_ptrdiff_t
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
 
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
diff --git a/arch/sparc/include/asm/posix_types.h b/arch/sparc/include/asm/posix_types.h
index dbfc1a3..3070f25 100644
--- a/arch/sparc/include/asm/posix_types.h
+++ b/arch/sparc/include/asm/posix_types.h
@@ -9,35 +9,16 @@
 
 #if defined(__sparc__) && defined(__arch64__)
 /* sparc 64 bit */
-typedef unsigned long          __kernel_size_t;
-typedef long                   __kernel_ssize_t;
-typedef long                   __kernel_ptrdiff_t;
-typedef long                   __kernel_time_t;
-typedef long                   __kernel_clock_t;
-typedef int                    __kernel_pid_t;
-typedef int                    __kernel_ipc_pid_t;
-typedef unsigned int           __kernel_uid_t;
-typedef unsigned int           __kernel_gid_t;
-typedef unsigned long          __kernel_ino_t;
-typedef unsigned int           __kernel_mode_t;
 typedef unsigned int           __kernel_nlink_t;
-typedef int                    __kernel_daddr_t;
-typedef long                   __kernel_off_t;
-typedef char *                 __kernel_caddr_t;
-typedef unsigned short	       __kernel_uid16_t;
-typedef unsigned short	       __kernel_gid16_t;
-typedef int                    __kernel_clockid_t;
-typedef int                    __kernel_timer_t;
+#define __kernel_nlink_t __kernel_nlink_t
 
 typedef unsigned short 	       __kernel_old_uid_t;
 typedef unsigned short         __kernel_old_gid_t;
-typedef __kernel_uid_t	       __kernel_uid32_t;
-typedef __kernel_gid_t	       __kernel_gid32_t;
-
-typedef unsigned int	       __kernel_old_dev_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
 /* Note this piece of asymmetry from the v9 ABI.  */
 typedef int		       __kernel_suseconds_t;
+#define __kernel_suseconds_t __kernel_suseconds_t
 
 #else
 /* sparc 32 bit */
@@ -45,109 +26,29 @@ typedef int		       __kernel_suseconds_t;
 typedef unsigned int           __kernel_size_t;
 typedef int                    __kernel_ssize_t;
 typedef long int               __kernel_ptrdiff_t;
-typedef long                   __kernel_time_t;
-typedef long		       __kernel_suseconds_t;
-typedef long                   __kernel_clock_t;
-typedef int                    __kernel_pid_t;
+#define __kernel_size_t __kernel_size_t
+
 typedef unsigned short         __kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short         __kernel_uid_t;
 typedef unsigned short         __kernel_gid_t;
-typedef unsigned long          __kernel_ino_t;
+#define __kernel_uid_t __kernel_uid_t
+
 typedef unsigned short         __kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef short                  __kernel_nlink_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef long                   __kernel_daddr_t;
-typedef long                   __kernel_off_t;
-typedef char *                 __kernel_caddr_t;
-typedef unsigned short	       __kernel_uid16_t;
-typedef unsigned short	       __kernel_gid16_t;
-typedef unsigned int	       __kernel_uid32_t;
-typedef unsigned int	       __kernel_gid32_t;
-typedef unsigned short	       __kernel_old_uid_t;
-typedef unsigned short	       __kernel_old_gid_t;
+#define __kernel_daddr_t __kernel_daddr_t
+
 typedef unsigned short	       __kernel_old_dev_t;
-typedef int                    __kernel_clockid_t;
-typedef int                    __kernel_timer_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
 #endif /* defined(__sparc__) && defined(__arch64__) */
 
-#ifdef __GNUC__
-typedef long long              __kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant cases (8 or 32 longs,
- * for 256 and 1024-bit fd_sets respectively)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-			case 32:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			  tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			  tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			  tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			  tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			  tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			  return;
-			case 16:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			  tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			  return;
-			case 8:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  return;
-			case 4:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
+#include <asm-generic/posix_types.h>
 
-#endif /* __KERNEL__ */
 #endif /* __SPARC_POSIX_TYPES_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..e2b38b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2165,9 +2165,9 @@ config IA32_EMULATION
 	depends on X86_64
 	select COMPAT_BINFMT_ELF
 	---help---
-	  Include code to run 32-bit programs under a 64-bit kernel. You should
-	  likely turn this on, unless you're 100% sure that you don't have any
-	  32-bit programs left.
+	  Include code to run legacy 32-bit programs under a
+	  64-bit kernel. You should likely turn this on, unless you're
+	  100% sure that you don't have any 32-bit programs left.
 
 config IA32_AOUT
 	tristate "IA32 a.out support"
@@ -2175,9 +2175,22 @@ config IA32_AOUT
 	---help---
 	  Support old a.out binaries in the 32bit emulation.
 
+config X86_X32
+	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
+	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
+	---help---
+	  Include code to run binaries for the x32 native 32-bit ABI
+	  for 64-bit processors.  An x32 process gets access to the
+	  full 64-bit register file and wide data path while leaving
+	  pointers at 32 bits for smaller memory footprint.
+
+	  You will need a recent binutils (2.22 or later) with
+	  elf32_x86_64 support enabled to compile a kernel with this
+	  option set.
+
 config COMPAT
 	def_bool y
-	depends on IA32_EMULATION
+	depends on IA32_EMULATION || X86_X32
 
 config COMPAT_FOR_U64_ALIGNMENT
 	def_bool COMPAT
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba12..968dbe2 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -82,6 +82,22 @@ ifdef CONFIG_CC_STACKPROTECTOR
         endif
 endif
 
+ifdef CONFIG_X86_X32
+	x32_ld_ok := $(call try-run,\
+			/bin/echo -e '1: .quad 1b' | \
+			$(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" - && \
+			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
+			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)
+        ifeq ($(x32_ld_ok),y)
+                CONFIG_X86_X32_ABI := y
+                KBUILD_AFLAGS += -DCONFIG_X86_X32_ABI
+                KBUILD_CFLAGS += -DCONFIG_X86_X32_ABI
+        else
+                $(warning CONFIG_X86_X32 enabled but no binutils support)
+        endif
+endif
+export CONFIG_X86_X32_ABI
+
 # Don't unroll struct assignments with kmemcheck enabled
 ifeq ($(CONFIG_KMEMCHECK),y)
 	KBUILD_CFLAGS += $(call cc-option,-fno-builtin-memcpy)
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6557769..ef026aa 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -12,10 +12,8 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/kernel.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
-#include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
@@ -31,20 +29,15 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/sigframe.h>
+#include <asm/sighandling.h>
 #include <asm/sys_ia32.h>
 
-#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-
-#define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
-			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
-			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
-
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+#define FIX_EFLAGS	__FIX_EFLAGS
 
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
+	bool ia32 = is_ia32_task();
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;
@@ -74,8 +67,13 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			case __SI_FAULT >> 16:
 				break;
 			case __SI_CHLD >> 16:
-				put_user_ex(from->si_utime, &to->si_utime);
-				put_user_ex(from->si_stime, &to->si_stime);
+				if (ia32) {
+					put_user_ex(from->si_utime, &to->si_utime);
+					put_user_ex(from->si_stime, &to->si_stime);
+				} else {
+					put_user_ex(from->si_utime, &to->_sifields._sigchld_x32._utime);
+					put_user_ex(from->si_stime, &to->_sifields._sigchld_x32._stime);
+				}
 				put_user_ex(from->si_status, &to->si_status);
 				/* FALL THROUGH */
 			default:
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index f6f5c53..aec2202 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -287,46 +287,6 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
-				     compat_sigset_t __user *oset,
-				     unsigned int sigsetsize)
-{
-	sigset_t s;
-	compat_sigset_t s32;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	if (set) {
-		if (copy_from_user(&s32, set, sizeof(compat_sigset_t)))
-			return -EFAULT;
-		switch (_NSIG_WORDS) {
-		case 4: s.sig[3] = s32.sig[6] | (((long)s32.sig[7]) << 32);
-		case 3: s.sig[2] = s32.sig[4] | (((long)s32.sig[5]) << 32);
-		case 2: s.sig[1] = s32.sig[2] | (((long)s32.sig[3]) << 32);
-		case 1: s.sig[0] = s32.sig[0] | (((long)s32.sig[1]) << 32);
-		}
-	}
-	set_fs(KERNEL_DS);
-	ret = sys_rt_sigprocmask(how,
-				 set ? (sigset_t __user *)&s : NULL,
-				 oset ? (sigset_t __user *)&s : NULL,
-				 sigsetsize);
-	set_fs(old_fs);
-	if (ret)
-		return ret;
-	if (oset) {
-		switch (_NSIG_WORDS) {
-		case 4: s32.sig[7] = (s.sig[3] >> 32); s32.sig[6] = s.sig[3];
-		case 3: s32.sig[5] = (s.sig[2] >> 32); s32.sig[4] = s.sig[2];
-		case 2: s32.sig[3] = (s.sig[1] >> 32); s32.sig[2] = s.sig[1];
-		case 1: s32.sig[1] = (s.sig[0] >> 32); s32.sig[0] = s.sig[0];
-		}
-		if (copy_to_user(oset, &s32, sizeof(compat_sigset_t)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
 asmlinkage long sys32_alarm(unsigned int seconds)
 {
 	return alarm_setitimer(seconds);
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index b57e6a4..f9c0d3b 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -14,6 +14,7 @@ header-y += msr.h
 header-y += mtrr.h
 header-y += posix_types_32.h
 header-y += posix_types_64.h
+header-y += posix_types_x32.h
 header-y += prctl.h
 header-y += processor-flags.h
 header-y += ptrace-abi.h
@@ -24,3 +25,4 @@ header-y += vsyscall.h
 
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
+genhdr-y += unistd_x32.h
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 30d737e..355edc0 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -6,7 +6,9 @@
  */
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <asm/processor.h>
 #include <asm/user32.h>
+#include <asm/unistd.h>
 
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"i686\0\0"
@@ -186,7 +188,20 @@ struct compat_shmid64_ds {
 /*
  * The type of struct elf_prstatus.pr_reg in compatible core dumps.
  */
+#ifdef CONFIG_X86_X32_ABI
+typedef struct user_regs_struct compat_elf_gregset_t;
+
+#define PR_REG_SIZE(S) (test_thread_flag(TIF_IA32) ? 68 : 216)
+#define PRSTATUS_SIZE(S) (test_thread_flag(TIF_IA32) ? 144 : 296)
+#define SET_PR_FPVALID(S,V) \
+  do { *(int *) (((void *) &((S)->pr_reg)) + PR_REG_SIZE(0)) = (V); } \
+  while (0)
+
+#define COMPAT_USE_64BIT_TIME \
+	(!!(task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT))
+#else
 typedef struct user_regs_struct32 compat_elf_gregset_t;
+#endif
 
 /*
  * A pointer passed in from user mode. This should not
@@ -208,13 +223,39 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 
 static inline void __user *arch_compat_alloc_user_space(long len)
 {
-	struct pt_regs *regs = task_pt_regs(current);
-	return (void __user *)regs->sp - len;
+	compat_uptr_t sp;
+
+	if (test_thread_flag(TIF_IA32)) {
+		sp = task_pt_regs(current)->sp;
+	} else {
+		/* -128 for the x32 ABI redzone */
+		sp = percpu_read(old_rsp) - 128;
+	}
+
+	return (void __user *)round_down(sp - len, 16);
+}
+
+static inline bool is_ia32_task(void)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (current_thread_info()->status & TS_COMPAT)
+		return true;
+#endif
+	return false;
+}
+
+static inline bool is_x32_task(void)
+{
+#ifdef CONFIG_X86_X32_ABI
+	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
+		return true;
+#endif
+	return false;
 }
 
-static inline int is_compat_task(void)
+static inline bool is_compat_task(void)
 {
-	return current_thread_info()->status & TS_COMPAT;
+	return is_ia32_task() || is_x32_task();
 }
 
 #endif /* _ASM_X86_COMPAT_H */
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 5f962df..1e40634 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -156,7 +156,12 @@ do {						\
 #define elf_check_arch(x)			\
 	((x)->e_machine == EM_X86_64)
 
-#define compat_elf_check_arch(x)	elf_check_arch_ia32(x)
+#define compat_elf_check_arch(x)		\
+	(elf_check_arch_ia32(x) || (x)->e_machine == EM_X86_64)
+
+#if __USER32_DS != __USER_DS
+# error "The following code assumes __USER32_DS == __USER_DS"
+#endif
 
 static inline void elf_common_init(struct thread_struct *t,
 				   struct pt_regs *regs, const u16 ds)
@@ -179,8 +184,9 @@ static inline void elf_common_init(struct thread_struct *t,
 void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp);
 #define compat_start_thread start_thread_ia32
 
-void set_personality_ia32(void);
-#define COMPAT_SET_PERSONALITY(ex) set_personality_ia32()
+void set_personality_ia32(bool);
+#define COMPAT_SET_PERSONALITY(ex)			\
+	set_personality_ia32((ex).e_machine == EM_X86_64)
 
 #define COMPAT_ELF_PLATFORM			("i686")
 
@@ -287,7 +293,7 @@ do {									\
 #define VDSO_HIGH_BASE		0xffffe000U /* CONFIG_COMPAT_VDSO address */
 
 /* 1GB for 64bit, 8MB for 32bit */
-#define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
+#define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)
 
 #define ARCH_DLINFO							\
 do {									\
@@ -296,9 +302,20 @@ do {									\
 			    (unsigned long)current->mm->context.vdso);	\
 } while (0)
 
+#define ARCH_DLINFO_X32							\
+do {									\
+	if (vdso_enabled)						\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
+			    (unsigned long)current->mm->context.vdso);	\
+} while (0)
+
 #define AT_SYSINFO		32
 
-#define COMPAT_ARCH_DLINFO	ARCH_DLINFO_IA32(sysctl_vsyscall32)
+#define COMPAT_ARCH_DLINFO						\
+if (test_thread_flag(TIF_X32))						\
+	ARCH_DLINFO_X32;						\
+else									\
+	ARCH_DLINFO_IA32(sysctl_vsyscall32)
 
 #define COMPAT_ELF_ET_DYN_BASE	(TASK_UNMAPPED_BASE + 0x1000000)
 
@@ -314,6 +331,8 @@ struct linux_binprm;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
+extern int x32_setup_additional_pages(struct linux_binprm *bprm,
+				      int uses_interp);
 
 extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
 #define compat_arch_setup_additional_pages	syscall32_setup_pages
@@ -330,7 +349,7 @@ static inline int mmap_is_ia32(void)
 	return 1;
 #endif
 #ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
+	if (test_thread_flag(TIF_ADDR32))
 		return 1;
 #endif
 	return 0;
diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index 1f7e625..ee52760 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -43,6 +43,15 @@ struct ucontext_ia32 {
 	compat_sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
+struct ucontext_x32 {
+	unsigned int	  uc_flags;
+	unsigned int 	  uc_link;
+	stack_ia32_t	  uc_stack;
+	unsigned int	  uc__pad0;     /* needed for alignment */
+	struct sigcontext uc_mcontext;  /* the 64-bit sigcontext type */
+	compat_sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
 /* This matches struct stat64 in glibc2.2, hence the absolutely
  * insane amounts of padding around dev_t's.
  */
@@ -116,6 +125,15 @@ typedef struct compat_siginfo {
 			compat_clock_t _stime;
 		} _sigchld;
 
+		/* SIGCHLD (x32 version) */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_s64 _utime;
+			compat_s64 _stime;
+		} _sigchld_x32;
+
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
 		struct {
 			unsigned int _addr;	/* faulting insn/memory ref. */
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4365ffd..7e3f17f 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -29,18 +29,18 @@
 
 #define	MTRR_IOCTL_BASE	'M'
 
-struct mtrr_sentry {
-    unsigned long base;    /*  Base address     */
-    unsigned int size;    /*  Size of region   */
-    unsigned int type;     /*  Type of region   */
-};
-
 /* Warning: this structure has a different order from i386
    on x86-64. The 32bit emulation code takes care of that.
    But you need to use this for 64bit, otherwise your X server
    will break. */
 
 #ifdef __i386__
+struct mtrr_sentry {
+    unsigned long base;    /*  Base address     */
+    unsigned int size;    /*  Size of region   */
+    unsigned int type;     /*  Type of region   */
+};
+
 struct mtrr_gentry {
     unsigned int regnum;   /*  Register number  */
     unsigned long base;    /*  Base address     */
@@ -50,12 +50,20 @@ struct mtrr_gentry {
 
 #else /* __i386__ */
 
+struct mtrr_sentry {
+	__u64 base;		/*  Base address     */
+	__u32 size;		/*  Size of region   */
+	__u32 type;		/*  Type of region   */
+};
+
 struct mtrr_gentry {
-    unsigned long base;    /*  Base address     */
-    unsigned int size;    /*  Size of region   */
-    unsigned int regnum;   /*  Register number  */
-    unsigned int type;     /*  Type of region   */
+	__u64 base;		/*  Base address     */
+	__u32 size;		/*  Size of region   */
+	__u32 regnum;		/*  Register number  */
+	__u32 type;		/*  Type of region   */
+	__u32 _pad;		/*  Unused	     */
 };
+
 #endif /* !__i386__ */
 
 struct mtrr_var_range {
diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index bb7133d..3427b77 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -7,7 +7,9 @@
 #else
 # ifdef __i386__
 #  include "posix_types_32.h"
-# else
+# elif defined(__LP64__)
 #  include "posix_types_64.h"
+# else
+#  include "posix_types_x32.h"
 # endif
 #endif
diff --git a/arch/x86/include/asm/posix_types_32.h b/arch/x86/include/asm/posix_types_32.h
index f7d9adf..99f262e 100644
--- a/arch/x86/include/asm/posix_types_32.h
+++ b/arch/x86/include/asm/posix_types_32.h
@@ -7,79 +7,22 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
 typedef unsigned short	__kernel_mode_t;
+#define __kernel_mode_t __kernel_mode_t
+
 typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
+#define __kernel_nlink_t __kernel_nlink_t
+
 typedef unsigned short	__kernel_ipc_pid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_uid_t __kernel_uid_t
 
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define __FD_SET(fd,fdsetp)					\
-	asm volatile("btsl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int)(fd)))
-
-#undef	__FD_CLR
-#define __FD_CLR(fd,fdsetp)					\
-	asm volatile("btrl %1,%0":				\
-		     "+m" (*(__kernel_fd_set *)(fdsetp))	\
-		     : "r" ((int) (fd)))
-
-#undef	__FD_ISSET
-#define __FD_ISSET(fd,fdsetp)					\
-	(__extension__						\
-	 ({							\
-	 unsigned char __result;				\
-	 asm volatile("btl %1,%2 ; setb %0"			\
-		      : "=q" (__result)				\
-		      : "r" ((int)(fd)),			\
-			"m" (*(__kernel_fd_set *)(fdsetp)));	\
-	 __result;						\
-}))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp)					\
-do {								\
-	int __d0, __d1;						\
-	asm volatile("cld ; rep ; stosl"			\
-		     : "=m" (*(__kernel_fd_set *)(fdsetp)),	\
-		       "=&c" (__d0), "=&D" (__d1)		\
-		     : "a" (0), "1" (__FDSET_LONGS),		\
-		       "2" ((__kernel_fd_set *)(fdsetp))	\
-		     : "memory");				\
-} while (0)
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_32_H */
diff --git a/arch/x86/include/asm/posix_types_64.h b/arch/x86/include/asm/posix_types_64.h
index eb8d2d9..cba0c1e 100644
--- a/arch/x86/include/asm/posix_types_64.h
+++ b/arch/x86/include/asm/posix_types_64.h
@@ -7,113 +7,13 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef int		__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
 typedef unsigned short __kernel_old_uid_t;
 typedef unsigned short __kernel_old_gid_t;
-typedef __kernel_uid_t __kernel_uid32_t;
-typedef __kernel_gid_t __kernel_gid32_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
 
 typedef unsigned long	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant cases (8 or 32 longs,
- * for 256 and 1024-bit fd_sets respectively)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned long *tmp = p->fds_bits;
-	int i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 32:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			return;
-		case 16:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			return;
-		case 8:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			return;
-		case 4:
-			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
-
-#endif /* defined(__KERNEL__) */
+#include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_64_H */
diff --git a/arch/x86/include/asm/posix_types_x32.h b/arch/x86/include/asm/posix_types_x32.h
new file mode 100644
index 0000000..85f9bda
--- /dev/null
+++ b/arch/x86/include/asm/posix_types_x32.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_X86_POSIX_TYPES_X32_H
+#define _ASM_X86_POSIX_TYPES_X32_H
+
+/*
+ * This file is only used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ *
+ * These types should generally match the ones used by the 64-bit kernel,
+ *
+ */
+
+typedef long long __kernel_long_t;
+typedef unsigned long long __kernel_ulong_t;
+#define __kernel_long_t __kernel_long_t
+
+#include <asm/posix_types_64.h>
+
+#endif /* _ASM_X86_POSIX_TYPES_X32_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aa9088c..e34f951 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -924,9 +924,9 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 #define IA32_PAGE_OFFSET	((current->personality & ADDR_LIMIT_3GB) ? \
 					0xc0000000 : 0xFFFFe000)
 
-#define TASK_SIZE		(test_thread_flag(TIF_IA32) ? \
+#define TASK_SIZE		(test_thread_flag(TIF_ADDR32) ? \
 					IA32_PAGE_OFFSET : TASK_SIZE_MAX)
-#define TASK_SIZE_OF(child)	((test_tsk_thread_flag(child, TIF_IA32)) ? \
+#define TASK_SIZE_OF(child)	((test_tsk_thread_flag(child, TIF_ADDR32)) ? \
 					IA32_PAGE_OFFSET : TASK_SIZE_MAX)
 
 #define STACK_TOP		TASK_SIZE
@@ -948,6 +948,12 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
 extern unsigned long KSTK_ESP(struct task_struct *task);
+
+/*
+ * User space RSP while inside the SYSCALL fast path
+ */
+DECLARE_PER_CPU(unsigned long, old_rsp);
+
 #endif /* CONFIG_X86_64 */
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 3566454..dcfde52 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -145,7 +145,6 @@ extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 extern long syscall_trace_enter(struct pt_regs *);
 extern void syscall_trace_leave(struct pt_regs *);
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index 04459d2..4a08538 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -230,34 +230,37 @@ struct sigcontext {
  * User-space might still rely on the old definition:
  */
 struct sigcontext {
-	unsigned long r8;
-	unsigned long r9;
-	unsigned long r10;
-	unsigned long r11;
-	unsigned long r12;
-	unsigned long r13;
-	unsigned long r14;
-	unsigned long r15;
-	unsigned long rdi;
-	unsigned long rsi;
-	unsigned long rbp;
-	unsigned long rbx;
-	unsigned long rdx;
-	unsigned long rax;
-	unsigned long rcx;
-	unsigned long rsp;
-	unsigned long rip;
-	unsigned long eflags;		/* RFLAGS */
-	unsigned short cs;
-	unsigned short gs;
-	unsigned short fs;
-	unsigned short __pad0;
-	unsigned long err;
-	unsigned long trapno;
-	unsigned long oldmask;
-	unsigned long cr2;
+	__u64 r8;
+	__u64 r9;
+	__u64 r10;
+	__u64 r11;
+	__u64 r12;
+	__u64 r13;
+	__u64 r14;
+	__u64 r15;
+	__u64 rdi;
+	__u64 rsi;
+	__u64 rbp;
+	__u64 rbx;
+	__u64 rdx;
+	__u64 rax;
+	__u64 rcx;
+	__u64 rsp;
+	__u64 rip;
+	__u64 eflags;		/* RFLAGS */
+	__u16 cs;
+	__u16 gs;
+	__u16 fs;
+	__u16 __pad0;
+	__u64 err;
+	__u64 trapno;
+	__u64 oldmask;
+	__u64 cr2;
 	struct _fpstate __user *fpstate;	/* zero when no FPU context */
-	unsigned long reserved1[8];
+#ifndef __LP64__
+	__u32 __fpstate_pad;
+#endif
+	__u64 reserved1[8];
 };
 #endif /* !__KERNEL__ */
 
diff --git a/arch/x86/include/asm/sigframe.h b/arch/x86/include/asm/sigframe.h
index 4e0fe26..7c7c27c 100644
--- a/arch/x86/include/asm/sigframe.h
+++ b/arch/x86/include/asm/sigframe.h
@@ -59,12 +59,25 @@ struct rt_sigframe_ia32 {
 #endif /* defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION) */
 
 #ifdef CONFIG_X86_64
+
 struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
 	/* fp state follows here */
 };
+
+#ifdef CONFIG_X86_X32_ABI
+
+struct rt_sigframe_x32 {
+	u64 pretcode;
+	struct ucontext_x32 uc;
+	compat_siginfo_t info;
+	/* fp state follows here */
+};
+
+#endif /* CONFIG_X86_X32_ABI */
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* _ASM_X86_SIGFRAME_H */
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
new file mode 100644
index 0000000..ada93b3
--- /dev/null
+++ b/arch/x86/include/asm/sighandling.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_X86_SIGHANDLING_H
+#define _ASM_X86_SIGHANDLING_H
+
+#include <linux/compiler.h>
+#include <linux/ptrace.h>
+#include <linux/signal.h>
+
+#include <asm/processor-flags.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+		       unsigned long *pax);
+int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
+		     struct pt_regs *regs, unsigned long mask);
+
+#endif /* _ASM_X86_SIGHANDLING_H */
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index cb23852..3fda9db4 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -10,6 +10,8 @@
 #ifndef _ASM_X86_SYS_IA32_H
 #define _ASM_X86_SYS_IA32_H
 
+#ifdef CONFIG_COMPAT
+
 #include <linux/compiler.h>
 #include <linux/linkage.h>
 #include <linux/types.h>
@@ -36,8 +38,6 @@ asmlinkage long sys32_rt_sigaction(int, struct sigaction32 __user *,
 				   struct sigaction32 __user *, unsigned int);
 asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
 				struct old_sigaction32 __user *);
-asmlinkage long sys32_rt_sigprocmask(int, compat_sigset_t __user *,
-				     compat_sigset_t __user *, unsigned int);
 asmlinkage long sys32_alarm(unsigned int);
 
 asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
@@ -83,4 +83,7 @@ asmlinkage long sys32_ipc(u32, int, int, int, compat_uptr_t, u32);
 
 asmlinkage long sys32_fanotify_mark(int, unsigned int, u32, u32, int,
 				    const char __user *);
+
+#endif /* CONFIG_COMPAT */
+
 #endif /* _ASM_X86_SYS_IA32_H */
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d962e56..386b786 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <asm/asm-offsets.h>	/* For NR_syscalls */
+#include <asm/unistd.h>
 
 extern const unsigned long sys_call_table[];
 
@@ -26,13 +27,13 @@ extern const unsigned long sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax;
+	return regs->orig_ax & __SYSCALL_MASK;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax;
+	regs->ax = regs->orig_ax & __SYSCALL_MASK;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index bc817cd..912e935 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -86,7 +86,7 @@ struct thread_info {
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
-#define TIF_IA32		17	/* 32bit process */
+#define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_DEBUG		21	/* uses debug registers */
@@ -95,6 +95,8 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
+#define TIF_X32			30	/* 32-bit native x86-64 binary */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -116,6 +118,8 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_ADDR32		(1 << TIF_ADDR32)
+#define _TIF_X32		(1 << TIF_X32)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 21f77b8..37cdc9d 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,7 +1,17 @@
 #ifndef _ASM_X86_UNISTD_H
 #define _ASM_X86_UNISTD_H 1
 
+/* x32 syscall flag bit */
+#define __X32_SYSCALL_BIT	0x40000000
+
 #ifdef __KERNEL__
+
+# ifdef CONFIG_X86_X32_ABI
+#  define __SYSCALL_MASK (~(__X32_SYSCALL_BIT))
+# else
+#  define __SYSCALL_MASK (~0)
+# endif
+
 # ifdef CONFIG_X86_32
 
 #  include <asm/unistd_32.h>
@@ -14,6 +24,7 @@
 # else
 
 #  include <asm/unistd_64.h>
+#  include <asm/unistd_64_x32.h>
 #  define __ARCH_WANT_COMPAT_SYS_TIME
 
 # endif
@@ -52,8 +63,10 @@
 #else
 # ifdef __i386__
 #  include <asm/unistd_32.h>
-# else
+# elif defined(__LP64__)
 #  include <asm/unistd_64.h>
+# else
+#  include <asm/unistd_x32.h>
 # endif
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 834e897..1b4754f 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,6 +1,12 @@
 #include <asm/ia32.h>
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_COMMON(nr, sym, compat) [nr] = 1,
+#ifdef CONFIG_X86_X32_ABI
+# define __SYSCALL_X32(nr, sym, compat) [nr] = 1,
+#else
+# define __SYSCALL_X32(nr, sym, compat) /* nothing */
+#endif
 static char syscalls_64[] = {
 #include <asm/syscalls_64.h>
 };
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 7928963..a041e09 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -167,6 +167,7 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 {
 	int err = 0;
 	mtrr_type type;
+	unsigned long base;
 	unsigned long size;
 	struct mtrr_sentry sentry;
 	struct mtrr_gentry gentry;
@@ -267,14 +268,14 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #endif
 		if (gentry.regnum >= num_var_ranges)
 			return -EINVAL;
-		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);
+		mtrr_if->get(gentry.regnum, &base, &size, &type);
 
 		/* Hide entries that go above 4GB */
-		if (gentry.base + size - 1 >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT))
+		if (base + size - 1 >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT))
 		    || size >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT)))
 			gentry.base = gentry.size = gentry.type = 0;
 		else {
-			gentry.base <<= PAGE_SHIFT;
+			gentry.base = base << PAGE_SHIFT;
 			gentry.size = size << PAGE_SHIFT;
 			gentry.type = type;
 		}
@@ -321,11 +322,12 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #endif
 		if (gentry.regnum >= num_var_ranges)
 			return -EINVAL;
-		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);
+		mtrr_if->get(gentry.regnum, &base, &size, &type);
 		/* Hide entries that would overflow */
 		if (size != (__typeof__(gentry.size))size)
 			gentry.base = gentry.size = gentry.type = 0;
 		else {
+			gentry.base = base;
 			gentry.size = size;
 			gentry.type = type;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..63c0e05 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -28,7 +28,6 @@
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
-#include <asm/compat.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
 
@@ -1595,6 +1594,9 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_COMPAT
+
+#include <asm/compat.h>
+
 static inline int
 perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..9e036f0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -482,7 +482,12 @@ GLOBAL(system_call_after_swapgs)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
+#if __SYSCALL_MASK == ~0
 	cmpq $__NR_syscall_max,%rax
+#else
+	andl $__SYSCALL_MASK,%eax
+	cmpl $__NR_syscall_max,%eax
+#endif
 	ja badsys
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
@@ -596,7 +601,12 @@ tracesys:
 	 */
 	LOAD_ARGS ARGOFFSET, 1
 	RESTORE_REST
+#if __SYSCALL_MASK == ~0
 	cmpq $__NR_syscall_max,%rax
+#else
+	andl $__SYSCALL_MASK,%eax
+	cmpl $__NR_syscall_max,%eax
+#endif
 	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
@@ -736,6 +746,40 @@ ENTRY(stub_rt_sigreturn)
 	CFI_ENDPROC
 END(stub_rt_sigreturn)
 
+#ifdef CONFIG_X86_X32_ABI
+	PTREGSCALL stub_x32_sigaltstack, sys32_sigaltstack, %rdx
+
+ENTRY(stub_x32_rt_sigreturn)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	movq %rsp,%rdi
+	FIXUP_TOP_OF_STACK %r11
+	call sys32_x32_rt_sigreturn
+	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_rt_sigreturn)
+
+ENTRY(stub_x32_execve)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	movq %rsp, %rcx
+	call sys32_execve
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_execve)
+
+#endif
+
 /*
  * Build the entry stubs and pointer table with some assembler magic.
  * We pack 7 stubs into a single 32-byte chunk, which will fit in a
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..a465973 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -364,7 +364,9 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
 {
 	start_thread_common(regs, new_ip, new_sp,
-			    __USER32_CS, __USER32_DS, __USER32_DS);
+			    test_thread_flag(TIF_X32)
+			    ? __USER_CS : __USER32_CS,
+			    __USER_DS, __USER_DS);
 }
 #endif
 
@@ -508,6 +510,8 @@ void set_personality_64bit(void)
 
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
+	clear_thread_flag(TIF_ADDR32);
+	clear_thread_flag(TIF_X32);
 
 	/* Ensure the corresponding mm is not marked. */
 	if (current->mm)
@@ -520,20 +524,31 @@ void set_personality_64bit(void)
 	current->personality &= ~READ_IMPLIES_EXEC;
 }
 
-void set_personality_ia32(void)
+void set_personality_ia32(bool x32)
 {
 	/* inherit personality from parent */
 
 	/* Make sure to be in 32bit mode */
-	set_thread_flag(TIF_IA32);
-	current->personality |= force_personality32;
+	set_thread_flag(TIF_ADDR32);
 
 	/* Mark the associated mm as containing 32-bit tasks. */
 	if (current->mm)
 		current->mm->context.ia32_compat = 1;
 
-	/* Prepare the first "return" to user space */
-	current_thread_info()->status |= TS_COMPAT;
+	if (x32) {
+		clear_thread_flag(TIF_IA32);
+		set_thread_flag(TIF_X32);
+		current->personality &= ~READ_IMPLIES_EXEC;
+		/* is_compat_task() uses the presence of the x32
+		   syscall bit flag to determine compat status */
+		current_thread_info()->status &= ~TS_COMPAT;
+	} else {
+		set_thread_flag(TIF_IA32);
+		clear_thread_flag(TIF_X32);
+		current->personality |= force_personality32;
+		/* Prepare the first "return" to user space */
+		current_thread_info()->status |= TS_COMPAT;
+	}
 }
 
 unsigned long get_wchan(struct task_struct *p)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..93e7877a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1130,6 +1130,100 @@ static int genregs32_set(struct task_struct *target,
 	return ret;
 }
 
+#ifdef CONFIG_X86_X32_ABI
+static long x32_arch_ptrace(struct task_struct *child,
+			    compat_long_t request, compat_ulong_t caddr,
+			    compat_ulong_t cdata)
+{
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
+	void __user *datap = compat_ptr(data);
+	int ret;
+
+	switch (request) {
+	/* Read 32bits at location addr in the USER area.  Only allow
+	   to return the lower 32bits of segment and debug registers.  */
+	case PTRACE_PEEKUSR: {
+		u32 tmp;
+
+		ret = -EIO;
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user) ||
+		    addr < offsetof(struct user_regs_struct, cs))
+			break;
+
+		tmp = 0;  /* Default return condition */
+		if (addr < sizeof(struct user_regs_struct))
+			tmp = getreg(child, addr);
+		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
+			 addr <= offsetof(struct user, u_debugreg[7])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			tmp = ptrace_get_debugreg(child, addr / sizeof(data));
+		}
+		ret = put_user(tmp, (__u32 __user *)datap);
+		break;
+	}
+
+	/* Write the word at location addr in the USER area.  Only allow
+	   to update segment and debug registers with the upper 32bits
+	   zero-extended. */
+	case PTRACE_POKEUSR:
+		ret = -EIO;
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user) ||
+		    addr < offsetof(struct user_regs_struct, cs))
+			break;
+
+		if (addr < sizeof(struct user_regs_struct))
+			ret = putreg(child, addr, data);
+		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
+			 addr <= offsetof(struct user, u_debugreg[7])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			ret = ptrace_set_debugreg(child,
+						  addr / sizeof(data), data);
+		}
+		break;
+
+	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_GENERAL,
+					   0, sizeof(struct user_regs_struct),
+					   datap);
+
+	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_GENERAL,
+					     0, sizeof(struct user_regs_struct),
+					     datap);
+
+	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_FP,
+					   0, sizeof(struct user_i387_struct),
+					   datap);
+
+	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_FP,
+					     0, sizeof(struct user_i387_struct),
+					     datap);
+
+		/* normal 64bit interface to access TLS data.
+		   Works just like arch_prctl, except that the arguments
+		   are reversed. */
+	case PTRACE_ARCH_PRCTL:
+		return do_arch_prctl(child, data, addr);
+
+	default:
+		return compat_ptrace_request(child, request, addr, data);
+	}
+
+	return ret;
+}
+#endif
+
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			compat_ulong_t caddr, compat_ulong_t cdata)
 {
@@ -1139,6 +1233,11 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 	int ret;
 	__u32 val;
 
+#ifdef CONFIG_X86_X32_ABI
+	if (!is_ia32_task())
+		return x32_arch_ptrace(child, request, caddr, cdata);
+#endif
+
 	switch (request) {
 	case PTRACE_PEEKUSR:
 		ret = getreg32(child, addr, &val);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 46a01bd..c3846b6 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -10,10 +10,8 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/kernel.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
-#include <linux/ptrace.h>
 #include <linux/tracehook.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
@@ -26,10 +24,12 @@
 #include <asm/i387.h>
 #include <asm/vdso.h>
 #include <asm/mce.h>
+#include <asm/sighandling.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
+#include <asm/sys_ia32.h>
 #endif /* CONFIG_X86_64 */
 
 #include <asm/syscall.h>
@@ -37,13 +37,6 @@
 
 #include <asm/sigframe.h>
 
-#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-
-#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
-			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
-			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
-
 #ifdef CONFIG_X86_32
 # define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
 #else
@@ -68,9 +61,8 @@
 	regs->seg = GET_SEG(seg) | 3;			\
 } while (0)
 
-static int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
-		   unsigned long *pax)
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+		       unsigned long *pax)
 {
 	void __user *buf;
 	unsigned int tmpflags;
@@ -125,9 +117,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	return err;
 }
 
-static int
-setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
-		 struct pt_regs *regs, unsigned long mask)
+int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
+		     struct pt_regs *regs, unsigned long mask)
 {
 	int err = 0;
 
@@ -642,6 +633,16 @@ static int signr_convert(int sig)
 #define is_ia32	0
 #endif /* CONFIG_IA32_EMULATION */
 
+#ifdef CONFIG_X86_X32_ABI
+#define is_x32	test_thread_flag(TIF_X32)
+
+static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
+			      siginfo_t *info, compat_sigset_t *set,
+			      struct pt_regs *regs);
+#else /* !CONFIG_X86_X32_ABI */
+#define is_x32	0
+#endif /* CONFIG_X86_X32_ABI */
+
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		sigset_t *set, struct pt_regs *regs);
 int ia32_setup_frame(int sig, struct k_sigaction *ka,
@@ -666,8 +667,14 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
 		else
 			ret = ia32_setup_frame(usig, ka, set, regs);
-	} else
+#ifdef CONFIG_X86_X32_ABI
+	} else if (is_x32) {
+		ret = x32_setup_rt_frame(usig, ka, info,
+					 (compat_sigset_t *)set, regs);
+#endif
+	} else {
 		ret = __setup_rt_frame(sig, ka, info, set, regs);
+	}
 
 	if (ret) {
 		force_sigsegv(sig, current);
@@ -850,3 +857,102 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 
 	force_sig(SIGSEGV, me);
 }
+
+#ifdef CONFIG_X86_X32_ABI
+static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
+			      siginfo_t *info, compat_sigset_t *set,
+			      struct pt_regs *regs)
+{
+	struct rt_sigframe_x32 __user *frame;
+	void __user *restorer;
+	int err = 0;
+	void __user *fpstate = NULL;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		if (copy_siginfo_to_user32(&frame->info, info))
+			return -EFAULT;
+	}
+
+	put_user_try {
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		put_user_ex(0, &frame->uc.uc__pad0);
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+					regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		if (ka->sa.sa_flags & SA_RESTORER) {
+			restorer = ka->sa.sa_restorer;
+		} else {
+			/* could use a vstub here */
+			restorer = NULL;
+			err |= -EFAULT;
+		}
+		put_user_ex(restorer, &frame->pretcode);
+	} put_user_catch(err);
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->ip = (unsigned long) ka->sa.sa_handler;
+
+	/* We use the x32 calling convention here... */
+	regs->di = sig;
+	regs->si = (unsigned long) &frame->info;
+	regs->dx = (unsigned long) &frame->uc;
+
+	loadsegment(ds, __USER_DS);
+	loadsegment(es, __USER_DS);
+
+	regs->cs = __USER_CS;
+	regs->ss = __USER_DS;
+
+	return 0;
+}
+
+asmlinkage long sys32_x32_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe_x32 __user *frame;
+	sigset_t set;
+	unsigned long ax;
+	struct pt_regs tregs;
+
+	frame = (struct rt_sigframe_x32 __user *)(regs->sp - 8);
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	set_current_blocked(&set);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+		goto badframe;
+
+	tregs = *regs;
+	if (sys32_sigaltstack(&frame->uc.uc_stack, NULL, &tregs) == -EFAULT)
+		goto badframe;
+
+	return ax;
+
+badframe:
+	signal_fault(regs, frame, "x32 rt_sigreturn");
+	return 0;
+}
+#endif
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 0514890..f921df8 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -98,7 +98,7 @@ out:
 static void find_start_end(unsigned long flags, unsigned long *begin,
 			   unsigned long *end)
 {
-	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT)) {
+	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT)) {
 		unsigned long new_begin;
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
@@ -144,7 +144,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
-	if (((flags & MAP_32BIT) || test_thread_flag(TIF_IA32))
+	if (((flags & MAP_32BIT) || test_thread_flag(TIF_ADDR32))
 	    && len <= mm->cached_hole_size) {
 		mm->cached_hole_size = 0;
 		mm->free_area_cache = begin;
@@ -205,7 +205,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		return addr;
 
 	/* for MAP_32BIT mappings we force the legact mmap base */
-	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
+	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT))
 		goto bottomup;
 
 	/* requesting a specific address */
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 7ac7943..5c7f8c2 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -5,6 +5,14 @@
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
 
+#define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
+
+#ifdef CONFIG_X86_X32_ABI
+# define __SYSCALL_X32(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
+#else
+# define __SYSCALL_X32(nr, sym, compat) /* nothing */
+#endif
+
 #define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
 #include <asm/syscalls_64.h>
 #undef __SYSCALL_64
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index bff89df..d6aa6e8 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -67,7 +67,7 @@ x86_backtrace_32(struct pt_regs * const regs, unsigned int depth)
 {
 	struct stack_frame_ia32 *head;
 
-	/* User process is 32-bit */
+	/* User process is IA32 */
 	if (!current || !test_thread_flag(TIF_IA32))
 		return 0;
 
diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index 564b247..3236aeb 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -10,8 +10,10 @@ syshdr := $(srctree)/$(src)/syscallhdr.sh
 systbl := $(srctree)/$(src)/syscalltbl.sh
 
 quiet_cmd_syshdr = SYSHDR  $@
-      cmd_syshdr = $(CONFIG_SHELL) '$(syshdr)' $< $@ \
-		   $(syshdr_abi_$(basetarget)) $(syshdr_pfx_$(basetarget))
+      cmd_syshdr = $(CONFIG_SHELL) '$(syshdr)' '$<' '$@' \
+		   '$(syshdr_abi_$(basetarget))' \
+		   '$(syshdr_pfx_$(basetarget))' \
+		   '$(syshdr_offset_$(basetarget))'
 quiet_cmd_systbl = SYSTBL  $@
       cmd_systbl = $(CONFIG_SHELL) '$(systbl)' $< $@
 
@@ -24,18 +26,28 @@ syshdr_pfx_unistd_32_ia32 := ia32_
 $(out)/unistd_32_ia32.h: $(syscall32) $(syshdr)
 	$(call if_changed,syshdr)
 
-syshdr_abi_unistd_64 := 64
+syshdr_abi_unistd_x32 := common,x32
+syshdr_offset_unistd_x32 := __X32_SYSCALL_BIT
+$(out)/unistd_x32.h: $(syscall64) $(syshdr)
+	$(call if_changed,syshdr)
+
+syshdr_abi_unistd_64 := common,64
 $(out)/unistd_64.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)
 
+syshdr_abi_unistd_64_x32 := x32
+syshdr_pfx_unistd_64_x32 := x32_
+$(out)/unistd_64_x32.h: $(syscall64) $(syshdr)
+	$(call if_changed,syshdr)
+
 $(out)/syscalls_32.h: $(syscall32) $(systbl)
 	$(call if_changed,systbl)
 $(out)/syscalls_64.h: $(syscall64) $(systbl)
 	$(call if_changed,systbl)
 
-syshdr-y			+= unistd_32.h unistd_64.h
+syshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
 syshdr-y			+= syscalls_32.h
-syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h
+syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h unistd_64_x32.h
 syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
 
 targets	+= $(syshdr-y)
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index ce98e28..031cef8 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -181,7 +181,7 @@
 172	i386	prctl			sys_prctl
 173	i386	rt_sigreturn		ptregs_rt_sigreturn		stub32_rt_sigreturn
 174	i386	rt_sigaction		sys_rt_sigaction		sys32_rt_sigaction
-175	i386	rt_sigprocmask		sys_rt_sigprocmask		sys32_rt_sigprocmask
+175	i386	rt_sigprocmask		sys_rt_sigprocmask
 176	i386	rt_sigpending		sys_rt_sigpending		sys32_rt_sigpending
 177	i386	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
 178	i386	rt_sigqueueinfo		sys_rt_sigqueueinfo		sys32_rt_sigqueueinfo
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index b440a8f..dd29a9e 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -4,317 +4,350 @@
 # The format is:
 # <number> <abi> <name> <entry point>
 #
-# The abi is always "64" for this file (for now.)
+# The abi is "common", "64" or "x32" for this file.
 #
-0	64	read			sys_read
-1	64	write			sys_write
-2	64	open			sys_open
-3	64	close			sys_close
-4	64	stat			sys_newstat
-5	64	fstat			sys_newfstat
-6	64	lstat			sys_newlstat
-7	64	poll			sys_poll
-8	64	lseek			sys_lseek
-9	64	mmap			sys_mmap
-10	64	mprotect		sys_mprotect
-11	64	munmap			sys_munmap
-12	64	brk			sys_brk
+0	common	read			sys_read
+1	common	write			sys_write
+2	common	open			sys_open
+3	common	close			sys_close
+4	common	stat			sys_newstat
+5	common	fstat			sys_newfstat
+6	common	lstat			sys_newlstat
+7	common	poll			sys_poll
+8	common	lseek			sys_lseek
+9	common	mmap			sys_mmap
+10	common	mprotect		sys_mprotect
+11	common	munmap			sys_munmap
+12	common	brk			sys_brk
 13	64	rt_sigaction		sys_rt_sigaction
-14	64	rt_sigprocmask		sys_rt_sigprocmask
+14	common	rt_sigprocmask		sys_rt_sigprocmask
 15	64	rt_sigreturn		stub_rt_sigreturn
 16	64	ioctl			sys_ioctl
-17	64	pread64			sys_pread64
-18	64	pwrite64		sys_pwrite64
+17	common	pread64			sys_pread64
+18	common	pwrite64		sys_pwrite64
 19	64	readv			sys_readv
 20	64	writev			sys_writev
-21	64	access			sys_access
-22	64	pipe			sys_pipe
-23	64	select			sys_select
-24	64	sched_yield		sys_sched_yield
-25	64	mremap			sys_mremap
-26	64	msync			sys_msync
-27	64	mincore			sys_mincore
-28	64	madvise			sys_madvise
-29	64	shmget			sys_shmget
-30	64	shmat			sys_shmat
-31	64	shmctl			sys_shmctl
-32	64	dup			sys_dup
-33	64	dup2			sys_dup2
-34	64	pause			sys_pause
-35	64	nanosleep		sys_nanosleep
-36	64	getitimer		sys_getitimer
-37	64	alarm			sys_alarm
-38	64	setitimer		sys_setitimer
-39	64	getpid			sys_getpid
-40	64	sendfile		sys_sendfile64
-41	64	socket			sys_socket
-42	64	connect			sys_connect
-43	64	accept			sys_accept
-44	64	sendto			sys_sendto
+21	common	access			sys_access
+22	common	pipe			sys_pipe
+23	common	select			sys_select
+24	common	sched_yield		sys_sched_yield
+25	common	mremap			sys_mremap
+26	common	msync			sys_msync
+27	common	mincore			sys_mincore
+28	common	madvise			sys_madvise
+29	common	shmget			sys_shmget
+30	common	shmat			sys_shmat
+31	common	shmctl			sys_shmctl
+32	common	dup			sys_dup
+33	common	dup2			sys_dup2
+34	common	pause			sys_pause
+35	common	nanosleep		sys_nanosleep
+36	common	getitimer		sys_getitimer
+37	common	alarm			sys_alarm
+38	common	setitimer		sys_setitimer
+39	common	getpid			sys_getpid
+40	common	sendfile		sys_sendfile64
+41	common	socket			sys_socket
+42	common	connect			sys_connect
+43	common	accept			sys_accept
+44	common	sendto			sys_sendto
 45	64	recvfrom		sys_recvfrom
 46	64	sendmsg			sys_sendmsg
 47	64	recvmsg			sys_recvmsg
-48	64	shutdown		sys_shutdown
-49	64	bind			sys_bind
-50	64	listen			sys_listen
-51	64	getsockname		sys_getsockname
-52	64	getpeername		sys_getpeername
-53	64	socketpair		sys_socketpair
-54	64	setsockopt		sys_setsockopt
-55	64	getsockopt		sys_getsockopt
-56	64	clone			stub_clone
-57	64	fork			stub_fork
-58	64	vfork			stub_vfork
+48	common	shutdown		sys_shutdown
+49	common	bind			sys_bind
+50	common	listen			sys_listen
+51	common	getsockname		sys_getsockname
+52	common	getpeername		sys_getpeername
+53	common	socketpair		sys_socketpair
+54	common	setsockopt		sys_setsockopt
+55	common	getsockopt		sys_getsockopt
+56	common	clone			stub_clone
+57	common	fork			stub_fork
+58	common	vfork			stub_vfork
 59	64	execve			stub_execve
-60	64	exit			sys_exit
-61	64	wait4			sys_wait4
-62	64	kill			sys_kill
-63	64	uname			sys_newuname
-64	64	semget			sys_semget
-65	64	semop			sys_semop
-66	64	semctl			sys_semctl
-67	64	shmdt			sys_shmdt
-68	64	msgget			sys_msgget
-69	64	msgsnd			sys_msgsnd
-70	64	msgrcv			sys_msgrcv
-71	64	msgctl			sys_msgctl
-72	64	fcntl			sys_fcntl
-73	64	flock			sys_flock
-74	64	fsync			sys_fsync
-75	64	fdatasync		sys_fdatasync
-76	64	truncate		sys_truncate
-77	64	ftruncate		sys_ftruncate
-78	64	getdents		sys_getdents
-79	64	getcwd			sys_getcwd
-80	64	chdir			sys_chdir
-81	64	fchdir			sys_fchdir
-82	64	rename			sys_rename
-83	64	mkdir			sys_mkdir
-84	64	rmdir			sys_rmdir
-85	64	creat			sys_creat
-86	64	link			sys_link
-87	64	unlink			sys_unlink
-88	64	symlink			sys_symlink
-89	64	readlink		sys_readlink
-90	64	chmod			sys_chmod
-91	64	fchmod			sys_fchmod
-92	64	chown			sys_chown
-93	64	fchown			sys_fchown
-94	64	lchown			sys_lchown
-95	64	umask			sys_umask
-96	64	gettimeofday		sys_gettimeofday
-97	64	getrlimit		sys_getrlimit
-98	64	getrusage		sys_getrusage
-99	64	sysinfo			sys_sysinfo
-100	64	times			sys_times
+60	common	exit			sys_exit
+61	common	wait4			sys_wait4
+62	common	kill			sys_kill
+63	common	uname			sys_newuname
+64	common	semget			sys_semget
+65	common	semop			sys_semop
+66	common	semctl			sys_semctl
+67	common	shmdt			sys_shmdt
+68	common	msgget			sys_msgget
+69	common	msgsnd			sys_msgsnd
+70	common	msgrcv			sys_msgrcv
+71	common	msgctl			sys_msgctl
+72	common	fcntl			sys_fcntl
+73	common	flock			sys_flock
+74	common	fsync			sys_fsync
+75	common	fdatasync		sys_fdatasync
+76	common	truncate		sys_truncate
+77	common	ftruncate		sys_ftruncate
+78	common	getdents		sys_getdents
+79	common	getcwd			sys_getcwd
+80	common	chdir			sys_chdir
+81	common	fchdir			sys_fchdir
+82	common	rename			sys_rename
+83	common	mkdir			sys_mkdir
+84	common	rmdir			sys_rmdir
+85	common	creat			sys_creat
+86	common	link			sys_link
+87	common	unlink			sys_unlink
+88	common	symlink			sys_symlink
+89	common	readlink		sys_readlink
+90	common	chmod			sys_chmod
+91	common	fchmod			sys_fchmod
+92	common	chown			sys_chown
+93	common	fchown			sys_fchown
+94	common	lchown			sys_lchown
+95	common	umask			sys_umask
+96	common	gettimeofday		sys_gettimeofday
+97	common	getrlimit		sys_getrlimit
+98	common	getrusage		sys_getrusage
+99	common	sysinfo			sys_sysinfo
+100	common	times			sys_times
 101	64	ptrace			sys_ptrace
-102	64	getuid			sys_getuid
-103	64	syslog			sys_syslog
-104	64	getgid			sys_getgid
-105	64	setuid			sys_setuid
-106	64	setgid			sys_setgid
-107	64	geteuid			sys_geteuid
-108	64	getegid			sys_getegid
-109	64	setpgid			sys_setpgid
-110	64	getppid			sys_getppid
-111	64	getpgrp			sys_getpgrp
-112	64	setsid			sys_setsid
-113	64	setreuid		sys_setreuid
-114	64	setregid		sys_setregid
-115	64	getgroups		sys_getgroups
-116	64	setgroups		sys_setgroups
-117	64	setresuid		sys_setresuid
-118	64	getresuid		sys_getresuid
-119	64	setresgid		sys_setresgid
-120	64	getresgid		sys_getresgid
-121	64	getpgid			sys_getpgid
-122	64	setfsuid		sys_setfsuid
-123	64	setfsgid		sys_setfsgid
-124	64	getsid			sys_getsid
-125	64	capget			sys_capget
-126	64	capset			sys_capset
+102	common	getuid			sys_getuid
+103	common	syslog			sys_syslog
+104	common	getgid			sys_getgid
+105	common	setuid			sys_setuid
+106	common	setgid			sys_setgid
+107	common	geteuid			sys_geteuid
+108	common	getegid			sys_getegid
+109	common	setpgid			sys_setpgid
+110	common	getppid			sys_getppid
+111	common	getpgrp			sys_getpgrp
+112	common	setsid			sys_setsid
+113	common	setreuid		sys_setreuid
+114	common	setregid		sys_setregid
+115	common	getgroups		sys_getgroups
+116	common	setgroups		sys_setgroups
+117	common	setresuid		sys_setresuid
+118	common	getresuid		sys_getresuid
+119	common	setresgid		sys_setresgid
+120	common	getresgid		sys_getresgid
+121	common	getpgid			sys_getpgid
+122	common	setfsuid		sys_setfsuid
+123	common	setfsgid		sys_setfsgid
+124	common	getsid			sys_getsid
+125	common	capget			sys_capget
+126	common	capset			sys_capset
 127	64	rt_sigpending		sys_rt_sigpending
 128	64	rt_sigtimedwait		sys_rt_sigtimedwait
 129	64	rt_sigqueueinfo		sys_rt_sigqueueinfo
-130	64	rt_sigsuspend		sys_rt_sigsuspend
+130	common	rt_sigsuspend		sys_rt_sigsuspend
 131	64	sigaltstack		stub_sigaltstack
-132	64	utime			sys_utime
-133	64	mknod			sys_mknod
+132	common	utime			sys_utime
+133	common	mknod			sys_mknod
 134	64	uselib
-135	64	personality		sys_personality
-136	64	ustat			sys_ustat
-137	64	statfs			sys_statfs
-138	64	fstatfs			sys_fstatfs
-139	64	sysfs			sys_sysfs
-140	64	getpriority		sys_getpriority
-141	64	setpriority		sys_setpriority
-142	64	sched_setparam		sys_sched_setparam
-143	64	sched_getparam		sys_sched_getparam
-144	64	sched_setscheduler	sys_sched_setscheduler
-145	64	sched_getscheduler	sys_sched_getscheduler
-146	64	sched_get_priority_max	sys_sched_get_priority_max
-147	64	sched_get_priority_min	sys_sched_get_priority_min
-148	64	sched_rr_get_interval	sys_sched_rr_get_interval
-149	64	mlock			sys_mlock
-150	64	munlock			sys_munlock
-151	64	mlockall		sys_mlockall
-152	64	munlockall		sys_munlockall
-153	64	vhangup			sys_vhangup
-154	64	modify_ldt		sys_modify_ldt
-155	64	pivot_root		sys_pivot_root
+135	common	personality		sys_personality
+136	common	ustat			sys_ustat
+137	common	statfs			sys_statfs
+138	common	fstatfs			sys_fstatfs
+139	common	sysfs			sys_sysfs
+140	common	getpriority		sys_getpriority
+141	common	setpriority		sys_setpriority
+142	common	sched_setparam		sys_sched_setparam
+143	common	sched_getparam		sys_sched_getparam
+144	common	sched_setscheduler	sys_sched_setscheduler
+145	common	sched_getscheduler	sys_sched_getscheduler
+146	common	sched_get_priority_max	sys_sched_get_priority_max
+147	common	sched_get_priority_min	sys_sched_get_priority_min
+148	common	sched_rr_get_interval	sys_sched_rr_get_interval
+149	common	mlock			sys_mlock
+150	common	munlock			sys_munlock
+151	common	mlockall		sys_mlockall
+152	common	munlockall		sys_munlockall
+153	common	vhangup			sys_vhangup
+154	common	modify_ldt		sys_modify_ldt
+155	common	pivot_root		sys_pivot_root
 156	64	_sysctl			sys_sysctl
-157	64	prctl			sys_prctl
-158	64	arch_prctl		sys_arch_prctl
-159	64	adjtimex		sys_adjtimex
-160	64	setrlimit		sys_setrlimit
-161	64	chroot			sys_chroot
-162	64	sync			sys_sync
-163	64	acct			sys_acct
-164	64	settimeofday		sys_settimeofday
-165	64	mount			sys_mount
-166	64	umount2			sys_umount
-167	64	swapon			sys_swapon
-168	64	swapoff			sys_swapoff
-169	64	reboot			sys_reboot
-170	64	sethostname		sys_sethostname
-171	64	setdomainname		sys_setdomainname
-172	64	iopl			stub_iopl
-173	64	ioperm			sys_ioperm
+157	common	prctl			sys_prctl
+158	common	arch_prctl		sys_arch_prctl
+159	common	adjtimex		sys_adjtimex
+160	common	setrlimit		sys_setrlimit
+161	common	chroot			sys_chroot
+162	common	sync			sys_sync
+163	common	acct			sys_acct
+164	common	settimeofday		sys_settimeofday
+165	common	mount			sys_mount
+166	common	umount2			sys_umount
+167	common	swapon			sys_swapon
+168	common	swapoff			sys_swapoff
+169	common	reboot			sys_reboot
+170	common	sethostname		sys_sethostname
+171	common	setdomainname		sys_setdomainname
+172	common	iopl			stub_iopl
+173	common	ioperm			sys_ioperm
 174	64	create_module
-175	64	init_module		sys_init_module
-176	64	delete_module		sys_delete_module
+175	common	init_module		sys_init_module
+176	common	delete_module		sys_delete_module
 177	64	get_kernel_syms
 178	64	query_module
-179	64	quotactl		sys_quotactl
+179	common	quotactl		sys_quotactl
 180	64	nfsservctl
-181	64	getpmsg
-182	64	putpmsg
-183	64	afs_syscall
-184	64	tuxcall
-185	64	security
-186	64	gettid			sys_gettid
-187	64	readahead		sys_readahead
-188	64	setxattr		sys_setxattr
-189	64	lsetxattr		sys_lsetxattr
-190	64	fsetxattr		sys_fsetxattr
-191	64	getxattr		sys_getxattr
-192	64	lgetxattr		sys_lgetxattr
-193	64	fgetxattr		sys_fgetxattr
-194	64	listxattr		sys_listxattr
-195	64	llistxattr		sys_llistxattr
-196	64	flistxattr		sys_flistxattr
-197	64	removexattr		sys_removexattr
-198	64	lremovexattr		sys_lremovexattr
-199	64	fremovexattr		sys_fremovexattr
-200	64	tkill			sys_tkill
-201	64	time			sys_time
-202	64	futex			sys_futex
-203	64	sched_setaffinity	sys_sched_setaffinity
-204	64	sched_getaffinity	sys_sched_getaffinity
+181	common	getpmsg
+182	common	putpmsg
+183	common	afs_syscall
+184	common	tuxcall
+185	common	security
+186	common	gettid			sys_gettid
+187	common	readahead		sys_readahead
+188	common	setxattr		sys_setxattr
+189	common	lsetxattr		sys_lsetxattr
+190	common	fsetxattr		sys_fsetxattr
+191	common	getxattr		sys_getxattr
+192	common	lgetxattr		sys_lgetxattr
+193	common	fgetxattr		sys_fgetxattr
+194	common	listxattr		sys_listxattr
+195	common	llistxattr		sys_llistxattr
+196	common	flistxattr		sys_flistxattr
+197	common	removexattr		sys_removexattr
+198	common	lremovexattr		sys_lremovexattr
+199	common	fremovexattr		sys_fremovexattr
+200	common	tkill			sys_tkill
+201	common	time			sys_time
+202	common	futex			sys_futex
+203	common	sched_setaffinity	sys_sched_setaffinity
+204	common	sched_getaffinity	sys_sched_getaffinity
 205	64	set_thread_area
-206	64	io_setup		sys_io_setup
-207	64	io_destroy		sys_io_destroy
-208	64	io_getevents		sys_io_getevents
-209	64	io_submit		sys_io_submit
-210	64	io_cancel		sys_io_cancel
+206	common	io_setup		sys_io_setup
+207	common	io_destroy		sys_io_destroy
+208	common	io_getevents		sys_io_getevents
+209	common	io_submit		sys_io_submit
+210	common	io_cancel		sys_io_cancel
 211	64	get_thread_area
-212	64	lookup_dcookie		sys_lookup_dcookie
-213	64	epoll_create		sys_epoll_create
+212	common	lookup_dcookie		sys_lookup_dcookie
+213	common	epoll_create		sys_epoll_create
 214	64	epoll_ctl_old
 215	64	epoll_wait_old
-216	64	remap_file_pages	sys_remap_file_pages
-217	64	getdents64		sys_getdents64
-218	64	set_tid_address		sys_set_tid_address
-219	64	restart_syscall		sys_restart_syscall
-220	64	semtimedop		sys_semtimedop
-221	64	fadvise64		sys_fadvise64
+216	common	remap_file_pages	sys_remap_file_pages
+217	common	getdents64		sys_getdents64
+218	common	set_tid_address		sys_set_tid_address
+219	common	restart_syscall		sys_restart_syscall
+220	common	semtimedop		sys_semtimedop
+221	common	fadvise64		sys_fadvise64
 222	64	timer_create		sys_timer_create
-223	64	timer_settime		sys_timer_settime
-224	64	timer_gettime		sys_timer_gettime
-225	64	timer_getoverrun	sys_timer_getoverrun
-226	64	timer_delete		sys_timer_delete
-227	64	clock_settime		sys_clock_settime
-228	64	clock_gettime		sys_clock_gettime
-229	64	clock_getres		sys_clock_getres
-230	64	clock_nanosleep		sys_clock_nanosleep
-231	64	exit_group		sys_exit_group
-232	64	epoll_wait		sys_epoll_wait
-233	64	epoll_ctl		sys_epoll_ctl
-234	64	tgkill			sys_tgkill
-235	64	utimes			sys_utimes
+223	common	timer_settime		sys_timer_settime
+224	common	timer_gettime		sys_timer_gettime
+225	common	timer_getoverrun	sys_timer_getoverrun
+226	common	timer_delete		sys_timer_delete
+227	common	clock_settime		sys_clock_settime
+228	common	clock_gettime		sys_clock_gettime
+229	common	clock_getres		sys_clock_getres
+230	common	clock_nanosleep		sys_clock_nanosleep
+231	common	exit_group		sys_exit_group
+232	common	epoll_wait		sys_epoll_wait
+233	common	epoll_ctl		sys_epoll_ctl
+234	common	tgkill			sys_tgkill
+235	common	utimes			sys_utimes
 236	64	vserver
-237	64	mbind			sys_mbind
-238	64	set_mempolicy		sys_set_mempolicy
-239	64	get_mempolicy		sys_get_mempolicy
-240	64	mq_open			sys_mq_open
-241	64	mq_unlink		sys_mq_unlink
-242	64	mq_timedsend		sys_mq_timedsend
-243	64	mq_timedreceive		sys_mq_timedreceive
+237	common	mbind			sys_mbind
+238	common	set_mempolicy		sys_set_mempolicy
+239	common	get_mempolicy		sys_get_mempolicy
+240	common	mq_open			sys_mq_open
+241	common	mq_unlink		sys_mq_unlink
+242	common	mq_timedsend		sys_mq_timedsend
+243	common	mq_timedreceive		sys_mq_timedreceive
 244	64	mq_notify		sys_mq_notify
-245	64	mq_getsetattr		sys_mq_getsetattr
+245	common	mq_getsetattr		sys_mq_getsetattr
 246	64	kexec_load		sys_kexec_load
 247	64	waitid			sys_waitid
-248	64	add_key			sys_add_key
-249	64	request_key		sys_request_key
-250	64	keyctl			sys_keyctl
-251	64	ioprio_set		sys_ioprio_set
-252	64	ioprio_get		sys_ioprio_get
-253	64	inotify_init		sys_inotify_init
-254	64	inotify_add_watch	sys_inotify_add_watch
-255	64	inotify_rm_watch	sys_inotify_rm_watch
-256	64	migrate_pages		sys_migrate_pages
-257	64	openat			sys_openat
-258	64	mkdirat			sys_mkdirat
-259	64	mknodat			sys_mknodat
-260	64	fchownat		sys_fchownat
-261	64	futimesat		sys_futimesat
-262	64	newfstatat		sys_newfstatat
-263	64	unlinkat		sys_unlinkat
-264	64	renameat		sys_renameat
-265	64	linkat			sys_linkat
-266	64	symlinkat		sys_symlinkat
-267	64	readlinkat		sys_readlinkat
-268	64	fchmodat		sys_fchmodat
-269	64	faccessat		sys_faccessat
-270	64	pselect6		sys_pselect6
-271	64	ppoll			sys_ppoll
-272	64	unshare			sys_unshare
+248	common	add_key			sys_add_key
+249	common	request_key		sys_request_key
+250	common	keyctl			sys_keyctl
+251	common	ioprio_set		sys_ioprio_set
+252	common	ioprio_get		sys_ioprio_get
+253	common	inotify_init		sys_inotify_init
+254	common	inotify_add_watch	sys_inotify_add_watch
+255	common	inotify_rm_watch	sys_inotify_rm_watch
+256	common	migrate_pages		sys_migrate_pages
+257	common	openat			sys_openat
+258	common	mkdirat			sys_mkdirat
+259	common	mknodat			sys_mknodat
+260	common	fchownat		sys_fchownat
+261	common	futimesat		sys_futimesat
+262	common	newfstatat		sys_newfstatat
+263	common	unlinkat		sys_unlinkat
+264	common	renameat		sys_renameat
+265	common	linkat			sys_linkat
+266	common	symlinkat		sys_symlinkat
+267	common	readlinkat		sys_readlinkat
+268	common	fchmodat		sys_fchmodat
+269	common	faccessat		sys_faccessat
+270	common	pselect6		sys_pselect6
+271	common	ppoll			sys_ppoll
+272	common	unshare			sys_unshare
 273	64	set_robust_list		sys_set_robust_list
 274	64	get_robust_list		sys_get_robust_list
-275	64	splice			sys_splice
-276	64	tee			sys_tee
-277	64	sync_file_range		sys_sync_file_range
+275	common	splice			sys_splice
+276	common	tee			sys_tee
+277	common	sync_file_range		sys_sync_file_range
 278	64	vmsplice		sys_vmsplice
 279	64	move_pages		sys_move_pages
-280	64	utimensat		sys_utimensat
-281	64	epoll_pwait		sys_epoll_pwait
-282	64	signalfd		sys_signalfd
-283	64	timerfd_create		sys_timerfd_create
-284	64	eventfd			sys_eventfd
-285	64	fallocate		sys_fallocate
-286	64	timerfd_settime		sys_timerfd_settime
-287	64	timerfd_gettime		sys_timerfd_gettime
-288	64	accept4			sys_accept4
-289	64	signalfd4		sys_signalfd4
-290	64	eventfd2		sys_eventfd2
-291	64	epoll_create1		sys_epoll_create1
-292	64	dup3			sys_dup3
-293	64	pipe2			sys_pipe2
-294	64	inotify_init1		sys_inotify_init1
+280	common	utimensat		sys_utimensat
+281	common	epoll_pwait		sys_epoll_pwait
+282	common	signalfd		sys_signalfd
+283	common	timerfd_create		sys_timerfd_create
+284	common	eventfd			sys_eventfd
+285	common	fallocate		sys_fallocate
+286	common	timerfd_settime		sys_timerfd_settime
+287	common	timerfd_gettime		sys_timerfd_gettime
+288	common	accept4			sys_accept4
+289	common	signalfd4		sys_signalfd4
+290	common	eventfd2		sys_eventfd2
+291	common	epoll_create1		sys_epoll_create1
+292	common	dup3			sys_dup3
+293	common	pipe2			sys_pipe2
+294	common	inotify_init1		sys_inotify_init1
 295	64	preadv			sys_preadv
 296	64	pwritev			sys_pwritev
 297	64	rt_tgsigqueueinfo	sys_rt_tgsigqueueinfo
-298	64	perf_event_open		sys_perf_event_open
+298	common	perf_event_open		sys_perf_event_open
 299	64	recvmmsg		sys_recvmmsg
-300	64	fanotify_init		sys_fanotify_init
-301	64	fanotify_mark		sys_fanotify_mark
-302	64	prlimit64		sys_prlimit64
-303	64	name_to_handle_at	sys_name_to_handle_at
-304	64	open_by_handle_at	sys_open_by_handle_at
-305	64	clock_adjtime		sys_clock_adjtime
-306	64	syncfs			sys_syncfs
+300	common	fanotify_init		sys_fanotify_init
+301	common	fanotify_mark		sys_fanotify_mark
+302	common	prlimit64		sys_prlimit64
+303	common	name_to_handle_at	sys_name_to_handle_at
+304	common	open_by_handle_at	sys_open_by_handle_at
+305	common	clock_adjtime		sys_clock_adjtime
+306	common	syncfs			sys_syncfs
 307	64	sendmmsg		sys_sendmmsg
-308	64	setns			sys_setns
-309	64	getcpu			sys_getcpu
+308	common	setns			sys_setns
+309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+#
+# x32-specific system call numbers start at 512 to avoid cache impact
+# for native 64-bit operation.
+#
+512	x32	rt_sigaction		sys32_rt_sigaction
+513	x32	rt_sigreturn		stub_x32_rt_sigreturn
+514	x32	ioctl			compat_sys_ioctl
+515	x32	readv			compat_sys_readv
+516	x32	writev			compat_sys_writev
+517	x32	recvfrom		compat_sys_recvfrom
+518	x32	sendmsg			compat_sys_sendmsg
+519	x32	recvmsg			compat_sys_recvmsg
+520	x32	execve			stub_x32_execve
+521	x32	ptrace			compat_sys_ptrace
+522	x32	rt_sigpending		sys32_rt_sigpending
+523	x32	rt_sigtimedwait		compat_sys_rt_sigtimedwait
+524	x32	rt_sigqueueinfo		sys32_rt_sigqueueinfo
+525	x32	sigaltstack		stub_x32_sigaltstack
+526	x32	timer_create		compat_sys_timer_create
+527	x32	mq_notify		compat_sys_mq_notify
+528	x32	kexec_load		compat_sys_kexec_load
+529	x32	waitid			compat_sys_waitid
+530	x32	set_robust_list		compat_sys_set_robust_list
+531	x32	get_robust_list		compat_sys_get_robust_list
+532	x32	vmsplice		compat_sys_vmsplice
+533	x32	move_pages		compat_sys_move_pages
+534	x32	preadv			compat_sys_preadv64
+535	x32	pwritev			compat_sys_pwritev64
+536	x32	rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
+537	x32	recvmmsg		compat_sys_recvmmsg
+538	x32	sendmmsg		compat_sys_sendmmsg
+539	x32	process_vm_readv	compat_sys_process_vm_readv
+540	x32	process_vm_writev	compat_sys_process_vm_writev
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index fe626c3..9924776 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -35,6 +35,9 @@
 #define stub_sigaltstack sys_sigaltstack
 #define stub_rt_sigreturn sys_rt_sigreturn
 
+#define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
+#define __SYSCALL_X32(nr, sym, compat) /* Not supported */
+
 #define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
 #include <asm/syscalls_64.h>
 
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index 5edf4f4..ce7e360 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -15,6 +15,8 @@ static char syscalls[] = {
 };
 #else
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_COMMON(nr, sym, compat) [nr] = 1,
+#define __SYSCALL_X32(nr, sym, compat) /* Not supported */
 static char syscalls[] = {
 #include <asm/syscalls_64.h>
 };
diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index 60274d5..3282874 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1,5 +1,7 @@
 vdso.lds
 vdso-syms.lds
+vdsox32.lds
+vdsox32-syms.lds
 vdso32-syms.lds
 vdso32-syscall-syms.lds
 vdso32-sysenter-syms.lds
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 5d17950..fd14be1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -3,21 +3,29 @@
 #
 
 VDSO64-$(CONFIG_X86_64)		:= y
+VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
 
 vdso-install-$(VDSO64-y)	+= vdso.so
+vdso-install-$(VDSOX32-y)	+= vdsox32.so
 vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
+vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
+
+# Filter out x32 objects.
+vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
+
 # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
+obj-$(VDSOX32-y)		+= vdsox32.o
 obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
 
-vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
+vobjs := $(foreach F,$(vobj64s),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
@@ -73,6 +81,42 @@ $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 	$(call if_changed,vdsosym)
 
 #
+# X32 processes use x32 vDSO to access 64bit kernel data.
+#
+# Build x32 vDSO image:
+# 1. Compile x32 vDSO as 64bit.
+# 2. Convert object files to x32.
+# 3. Build x32 VDSO image with x32 objects, which contains 64bit codes
+# so that it can reach 64bit address space with 64bit pointers.
+#
+
+targets += vdsox32-syms.lds
+obj-$(VDSOX32-y)		+= vdsox32-syms.lds
+
+CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
+VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
+			   -Wl,-soname=linux-vdso.so.1 \
+			   -Wl,-z,max-page-size=4096 \
+			   -Wl,-z,common-page-size=4096
+
+vobjx32s-y := $(vobj64s:.o=-x32.o)
+vobjx32s := $(foreach F,$(vobjx32s-y),$(obj)/$F)
+
+# Convert 64bit object file to x32 for x32 vDSO.
+quiet_cmd_x32 = X32     $@
+      cmd_x32 = $(OBJCOPY) -O elf32-x86-64 $< $@
+
+$(obj)/%-x32.o: $(obj)/%.o FORCE
+	$(call if_changed,x32)
+
+targets += vdsox32.so vdsox32.so.dbg vdsox32.lds $(vobjx32s-y)
+
+$(obj)/vdsox32.o: $(src)/vdsox32.S $(obj)/vdsox32.so
+
+$(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
+	$(call if_changed,vdso)
+
+#
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
 obj-$(VDSO32-y)			+= vdso32-syms.lds
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 468d591..10f9f59 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -317,6 +317,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	int ret = 0;
 	bool compat;
 
+#ifdef CONFIG_X86_X32_ABI
+	if (test_thread_flag(TIF_X32))
+		return x32_setup_additional_pages(bprm, uses_interp);
+#endif
+
 	if (vdso_enabled == VDSO_DISABLED)
 		return 0;
 
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
new file mode 100644
index 0000000..d6b9a7f
--- /dev/null
+++ b/arch/x86/vdso/vdsox32.S
@@ -0,0 +1,22 @@
+#include <asm/page_types.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+__PAGE_ALIGNED_DATA
+
+	.globl vdsox32_start, vdsox32_end
+	.align PAGE_SIZE
+vdsox32_start:
+	.incbin "arch/x86/vdso/vdsox32.so"
+vdsox32_end:
+	.align PAGE_SIZE /* extra data here leaks to userspace. */
+
+.previous
+
+	.globl vdsox32_pages
+	.bss
+	.align 8
+	.type vdsox32_pages, @object
+vdsox32_pages:
+	.zero (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
+	.size vdsox32_pages, .-vdsox32_pages
diff --git a/arch/x86/vdso/vdsox32.lds.S b/arch/x86/vdso/vdsox32.lds.S
new file mode 100644
index 0000000..62272aa
--- /dev/null
+++ b/arch/x86/vdso/vdsox32.lds.S
@@ -0,0 +1,28 @@
+/*
+ * Linker script for x32 vDSO.
+ * We #include the file to define the layout details.
+ * Here we only choose the prelinked virtual address.
+ *
+ * This file defines the version script giving the user-exported symbols in
+ * the DSO.  We can define local symbols here called VDSO* to make their
+ * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ */
+
+#define VDSO_PRELINK 0
+#include "vdso-layout.lds.S"
+
+/*
+ * This controls what userland symbols we export from the vDSO.
+ */
+VERSION {
+	LINUX_2.6 {
+	global:
+		__vdso_clock_gettime;
+		__vdso_gettimeofday;
+		__vdso_getcpu;
+		__vdso_time;
+	local: *;
+	};
+}
+
+VDSOX32_PRELINK = VDSO_PRELINK;
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 153407c..d7dce1d 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -24,7 +24,44 @@ extern unsigned short vdso_sync_cpuid;
 extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
-static void __init patch_vdso(void *vdso, size_t len)
+#ifdef CONFIG_X86_X32_ABI
+extern char vdsox32_start[], vdsox32_end[];
+extern struct page *vdsox32_pages[];
+static unsigned vdsox32_size;
+
+static void __init patch_vdsox32(void *vdso, size_t len)
+{
+	Elf32_Ehdr *hdr = vdso;
+	Elf32_Shdr *sechdrs, *alt_sec = 0;
+	char *secstrings;
+	void *alt_data;
+	int i;
+
+	BUG_ON(len < sizeof(Elf32_Ehdr));
+	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
+
+	sechdrs = (void *)hdr + hdr->e_shoff;
+	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		Elf32_Shdr *shdr = &sechdrs[i];
+		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
+			alt_sec = shdr;
+			goto found;
+		}
+	}
+
+	/* If we get here, it's probably a bug. */
+	pr_warning("patch_vdsox32: .altinstructions not found\n");
+	return;  /* nothing to patch */
+
+found:
+	alt_data = (void *)hdr + alt_sec->sh_offset;
+	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
+}
+#endif
+
+static void __init patch_vdso64(void *vdso, size_t len)
 {
 	Elf64_Ehdr *hdr = vdso;
 	Elf64_Shdr *sechdrs, *alt_sec = 0;
@@ -47,7 +84,7 @@ static void __init patch_vdso(void *vdso, size_t len)
 	}
 
 	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdso: .altinstructions not found\n");
+	pr_warning("patch_vdso64: .altinstructions not found\n");
 	return;  /* nothing to patch */
 
 found:
@@ -60,12 +97,20 @@ static int __init init_vdso(void)
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
 
-	patch_vdso(vdso_start, vdso_end - vdso_start);
+	patch_vdso64(vdso_start, vdso_end - vdso_start);
 
 	vdso_size = npages << PAGE_SHIFT;
 	for (i = 0; i < npages; i++)
 		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
+#ifdef CONFIG_X86_X32_ABI
+	patch_vdsox32(vdsox32_start, vdsox32_end - vdsox32_start);
+	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
+	vdsox32_size = npages << PAGE_SHIFT;
+	for (i = 0; i < npages; i++)
+		vdsox32_pages[i] = virt_to_page(vdsox32_start + i*PAGE_SIZE);
+#endif
+
 	return 0;
 }
 subsys_initcall(init_vdso);
@@ -103,7 +148,10 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 
 /* Setup a VMA at program startup for the vsyscall page.
    Not called for compat tasks */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+static int setup_additional_pages(struct linux_binprm *bprm,
+				  int uses_interp,
+				  struct page **pages,
+				  unsigned size)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
@@ -113,8 +161,8 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		return 0;
 
 	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, vdso_size);
-	addr = get_unmapped_area(NULL, addr, vdso_size, 0, 0);
+	addr = vdso_addr(mm->start_stack, size);
+	addr = get_unmapped_area(NULL, addr, size, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
@@ -122,11 +170,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	current->mm->context.vdso = (void *)addr;
 
-	ret = install_special_mapping(mm, addr, vdso_size,
+	ret = install_special_mapping(mm, addr, size,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 				      VM_ALWAYSDUMP,
-				      vdso_pages);
+				      pages);
 	if (ret) {
 		current->mm->context.vdso = NULL;
 		goto up_fail;
@@ -137,6 +185,20 @@ up_fail:
 	return ret;
 }
 
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	return setup_additional_pages(bprm, uses_interp, vdso_pages,
+				      vdso_size);
+}
+
+#ifdef CONFIG_X86_X32_ABI
+int x32_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+{
+	return setup_additional_pages(bprm, uses_interp, vdsox32_pages,
+				      vdsox32_size);
+}
+#endif
+
 static __init int vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
diff --git a/arch/xtensa/include/asm/posix_types.h b/arch/xtensa/include/asm/posix_types.h
index 6b2190c..6e96be0 100644
--- a/arch/xtensa/include/asm/posix_types.h
+++ b/arch/xtensa/include/asm/posix_types.h
@@ -19,104 +19,21 @@
  * assume GCC is being used.
  */
 
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned long	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
 typedef unsigned short	__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
+#define __kernel_ipc_pid_t __kernel_ipc_pid_t
+
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef long		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
+#define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_old_uid_t;
 typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifndef __GNUC__
-
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-#define	__FD_ZERO(set)	\
-  ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
-
-#else /* __GNUC__ */
+#define __kernel_old_uid_t __kernel_old_uid_t
 
-#if defined(__KERNEL__)
-/* With GNU C, use inline functions instead so args are evaluated only once: */
-
-#undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] |= (1UL<<_rem);
-}
-
-#undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	fdsetp->fds_bits[_tmp] &= ~(1UL<<_rem);
-}
-
-#undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, __kernel_fd_set *p)
-{
-	unsigned long _tmp = fd / __NFDBITS;
-	unsigned long _rem = fd % __NFDBITS;
-	return (p->fds_bits[_tmp] & (1UL<<_rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
-{
-	unsigned int *tmp = (unsigned int *)p->fds_bits;
-	int i;
+typedef unsigned short	__kernel_old_dev_t;
+#define __kernel_old_dev_t __kernel_old_dev_t
 
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-			case 8:
-				tmp[0] = 0; tmp[1] = 0; tmp[2] = 0; tmp[3] = 0;
-				tmp[4] = 0; tmp[5] = 0; tmp[6] = 0; tmp[7] = 0;
-				return;
-		}
-	}
-	i = __FDSET_LONGS;
-	while (i) {
-		i--;
-		*tmp = 0;
-		tmp++;
-	}
-}
+#include <asm-generic/posix_types.h>
 
-#endif /* defined(__KERNEL__) */
-#endif /* __GNUC__ */
 #endif /* _XTENSA_POSIX_TYPES_H */
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index f434856..a270971 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -706,16 +706,13 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 {
 	unsigned int minor;
 	struct timeval par_timeout;
-	struct compat_timeval __user *tc;
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
 	mutex_lock(&lp_mutex);
 	switch (cmd) {
 	case LPSETTIMEOUT:
-		tc = compat_ptr(arg);
-		if (get_user(par_timeout.tv_sec, &tc->tv_sec) ||
-		    get_user(par_timeout.tv_usec, &tc->tv_usec)) {
+		if (compat_get_timeval(&par_timeout, compat_ptr(arg))) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/drivers/input/input-compat.c b/drivers/input/input-compat.c
index e46a867..64ca711 100644
--- a/drivers/input/input-compat.c
+++ b/drivers/input/input-compat.c
@@ -17,7 +17,7 @@
 int input_event_from_user(const char __user *buffer,
 			  struct input_event *event)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
 		struct input_event_compat compat_event;
 
 		if (copy_from_user(&compat_event, buffer,
@@ -41,7 +41,7 @@ int input_event_from_user(const char __user *buffer,
 int input_event_to_user(char __user *buffer,
 			const struct input_event *event)
 {
-	if (INPUT_COMPAT_TEST) {
+	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
 		struct input_event_compat compat_event;
 
 		compat_event.time.tv_sec = event->time.tv_sec;
diff --git a/drivers/input/input-compat.h b/drivers/input/input-compat.h
index 22be27b..148f66f 100644
--- a/drivers/input/input-compat.h
+++ b/drivers/input/input-compat.h
@@ -67,7 +67,7 @@ struct ff_effect_compat {
 
 static inline size_t input_event_size(void)
 {
-	return INPUT_COMPAT_TEST ?
+	return (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) ?
 		sizeof(struct input_event_compat) : sizeof(struct input_event);
 }
 
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7491801..9446f01 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -379,8 +379,7 @@ int task_get_unused_fd_flags(struct binder_proc *proc, int flags)
 
 repeat:
 	fdt = files_fdtable(files);
-	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
-				files->next_fd);
+	fd = find_next_zero_bit(fdt->open_fds, fdt->max_fds, files->next_fd);
 
 	/*
 	 * N.B. For clone tasks sharing a files structure, this test
@@ -408,11 +407,11 @@ repeat:
 		goto repeat;
 	}
 
-	FD_SET(fd, fdt->open_fds);
+	__set_open_fd(fd, fdt);
 	if (flags & O_CLOEXEC)
-		FD_SET(fd, fdt->close_on_exec);
+		__set_close_on_exec(fd, fdt);
 	else
-		FD_CLR(fd, fdt->close_on_exec);
+		__clear_close_on_exec(fd, fdt);
 	files->next_fd = fd + 1;
 #if 1
 	/* Sanity check */
@@ -453,7 +452,7 @@ static void task_fd_install(
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
-	__FD_CLR(fd, fdt->open_fds);
+	__clear_open_fd(fd, fdt);
 	if (fd < files->next_fd)
 		files->next_fd = fd;
 }
@@ -479,7 +478,7 @@ static long task_close_fd(struct binder_proc *proc, unsigned int fd)
 	if (!filp)
 		goto out_unlock;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
-	FD_CLR(fd, fdt->close_on_exec);
+	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 	retval = filp_close(filp, files);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 76741d8..3dfd615 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -230,7 +230,7 @@ static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
 	fdt = files_fdtable(files);
 	BUG_ON(fdt->fd[fd] != NULL);
 	rcu_assign_pointer(fdt->fd[fd], file);
-	FD_SET(fd, fdt->close_on_exec);
+	__set_close_on_exec(fd, fdt);
 	spin_unlock(&files->file_lock);
 }
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bcb884e..43ba478 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1390,6 +1390,22 @@ static void do_thread_regset_writeback(struct task_struct *task,
 		regset->writeback(task, regset, 1);
 }
 
+#ifndef PR_REG_SIZE
+#define PR_REG_SIZE(S) sizeof(S)
+#endif
+
+#ifndef PRSTATUS_SIZE
+#define PRSTATUS_SIZE(S) sizeof(S)
+#endif
+
+#ifndef PR_REG_PTR
+#define PR_REG_PTR(S) (&((S)->pr_reg))
+#endif
+
+#ifndef SET_PR_FPVALID
+#define SET_PR_FPVALID(S, V) ((S)->pr_fpvalid = (V))
+#endif
+
 static int fill_thread_core_info(struct elf_thread_core_info *t,
 				 const struct user_regset_view *view,
 				 long signr, size_t *total)
@@ -1404,11 +1420,11 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 	 */
 	fill_prstatus(&t->prstatus, t->task, signr);
 	(void) view->regsets[0].get(t->task, &view->regsets[0],
-				    0, sizeof(t->prstatus.pr_reg),
-				    &t->prstatus.pr_reg, NULL);
+				    0, PR_REG_SIZE(t->prstatus.pr_reg),
+				    PR_REG_PTR(&t->prstatus), NULL);
 
 	fill_note(&t->notes[0], "CORE", NT_PRSTATUS,
-		  sizeof(t->prstatus), &t->prstatus);
+		  PRSTATUS_SIZE(t->prstatus), &t->prstatus);
 	*total += notesize(&t->notes[0]);
 
 	do_thread_regset_writeback(t->task, &view->regsets[0]);
@@ -1438,7 +1454,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 						  regset->core_note_type,
 						  size, data);
 				else {
-					t->prstatus.pr_fpvalid = 1;
+					SET_PR_FPVALID(&t->prstatus, 1);
 					fill_note(&t->notes[i], "CORE",
 						  NT_PRFPREG, size, data);
 				}
diff --git a/fs/compat.c b/fs/compat.c
index fa9d721..83d751c 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1177,10 +1177,9 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 }
 
 asmlinkage ssize_t
-compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
-		  unsigned long vlen, u32 pos_low, u32 pos_high)
+compat_sys_preadv64(unsigned long fd, const struct compat_iovec __user *vec,
+		    unsigned long vlen, loff_t pos)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
@@ -1197,6 +1196,14 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
+		  unsigned long vlen, u32 pos_low, u32 pos_high)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	return compat_sys_preadv64(fd, vec, vlen, pos);
+}
+
 static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
 			    unsigned long vlen, loff_t *pos)
@@ -1236,10 +1243,9 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 }
 
 asmlinkage ssize_t
-compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
-		   unsigned long vlen, u32 pos_low, u32 pos_high)
+compat_sys_pwritev64(unsigned long fd, const struct compat_iovec __user *vec,
+		     unsigned long vlen, loff_t pos)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
@@ -1256,6 +1262,14 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
+		   unsigned long vlen, u32 pos_low, u32 pos_high)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	return compat_sys_pwritev64(fd, vec, vlen, pos);
+}
+
 asmlinkage long
 compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
 		    unsigned int nr_segs, unsigned int flags)
diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..cfd5e30 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1026,10 +1026,10 @@ static void flush_old_files(struct files_struct * files)
 		fdt = files_fdtable(files);
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->close_on_exec->fds_bits[j];
+		set = fdt->close_on_exec[j];
 		if (!set)
 			continue;
-		fdt->close_on_exec->fds_bits[j] = 0;
+		fdt->close_on_exec[j] = 0;
 		spin_unlock(&files->file_lock);
 		for ( ; set ; i++,set >>= 1) {
 			if (set & 1) {
@@ -2078,8 +2078,8 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	fd_install(0, rp);
 	spin_lock(&cf->file_lock);
 	fdt = files_fdtable(cf);
-	FD_SET(0, fdt->open_fds);
-	FD_CLR(0, fdt->close_on_exec);
+	__set_open_fd(0, fdt);
+	__clear_close_on_exec(0, fdt);
 	spin_unlock(&cf->file_lock);
 
 	/* and disallow core files too */
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22764c7..75e7c1f 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -32,20 +32,20 @@ void set_close_on_exec(unsigned int fd, int flag)
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (flag)
-		FD_SET(fd, fdt->close_on_exec);
+		__set_close_on_exec(fd, fdt);
 	else
-		FD_CLR(fd, fdt->close_on_exec);
+		__clear_close_on_exec(fd, fdt);
 	spin_unlock(&files->file_lock);
 }
 
-static int get_close_on_exec(unsigned int fd)
+static bool get_close_on_exec(unsigned int fd)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
-	int res;
+	bool res;
 	rcu_read_lock();
 	fdt = files_fdtable(files);
-	res = FD_ISSET(fd, fdt->close_on_exec);
+	res = close_on_exec(fd, fdt);
 	rcu_read_unlock();
 	return res;
 }
@@ -90,15 +90,15 @@ SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 	err = -EBUSY;
 	fdt = files_fdtable(files);
 	tofree = fdt->fd[newfd];
-	if (!tofree && FD_ISSET(newfd, fdt->open_fds))
+	if (!tofree && fd_is_open(newfd, fdt))
 		goto out_unlock;
 	get_file(file);
 	rcu_assign_pointer(fdt->fd[newfd], file);
-	FD_SET(newfd, fdt->open_fds);
+	__set_open_fd(newfd, fdt);
 	if (flags & O_CLOEXEC)
-		FD_SET(newfd, fdt->close_on_exec);
+		__set_close_on_exec(newfd, fdt);
 	else
-		FD_CLR(newfd, fdt->close_on_exec);
+		__clear_close_on_exec(newfd, fdt);
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
diff --git a/fs/file.c b/fs/file.c
index 4c6992d..171f6b4 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -40,7 +40,7 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static void *alloc_fdmem(unsigned int size)
+static void *alloc_fdmem(size_t size)
 {
 	/*
 	 * Very large allocations can stress page reclaim, so fall back to
@@ -142,7 +142,7 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 static struct fdtable * alloc_fdtable(unsigned int nr)
 {
 	struct fdtable *fdt;
-	char *data;
+	void *data;
 
 	/*
 	 * Figure out how many fds we actually want to support in this fdtable.
@@ -172,14 +172,15 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	data = alloc_fdmem(nr * sizeof(struct file *));
 	if (!data)
 		goto out_fdt;
-	fdt->fd = (struct file **)data;
-	data = alloc_fdmem(max_t(unsigned int,
+	fdt->fd = data;
+
+	data = alloc_fdmem(max_t(size_t,
 				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
 	if (!data)
 		goto out_arr;
-	fdt->open_fds = (fd_set *)data;
+	fdt->open_fds = data;
 	data += nr / BITS_PER_BYTE;
-	fdt->close_on_exec = (fd_set *)data;
+	fdt->close_on_exec = data;
 	fdt->next = NULL;
 
 	return fdt;
@@ -275,11 +276,11 @@ static int count_open_files(struct fdtable *fdt)
 	int i;
 
 	/* Find the last open fd */
-	for (i = size/(8*sizeof(long)); i > 0; ) {
-		if (fdt->open_fds->fds_bits[--i])
+	for (i = size / BITS_PER_LONG; i > 0; ) {
+		if (fdt->open_fds[--i])
 			break;
 	}
-	i = (i+1) * 8 * sizeof(long);
+	i = (i + 1) * BITS_PER_LONG;
 	return i;
 }
 
@@ -306,8 +307,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	newf->next_fd = 0;
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
-	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
-	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
+	new_fdt->close_on_exec = newf->close_on_exec_init;
+	new_fdt->open_fds = newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
 	new_fdt->next = NULL;
 
@@ -350,10 +351,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	old_fds = old_fdt->fd;
 	new_fds = new_fdt->fd;
 
-	memcpy(new_fdt->open_fds->fds_bits,
-		old_fdt->open_fds->fds_bits, open_files/8);
-	memcpy(new_fdt->close_on_exec->fds_bits,
-		old_fdt->close_on_exec->fds_bits, open_files/8);
+	memcpy(new_fdt->open_fds, old_fdt->open_fds, open_files / 8);
+	memcpy(new_fdt->close_on_exec, old_fdt->close_on_exec, open_files / 8);
 
 	for (i = open_files; i != 0; i--) {
 		struct file *f = *old_fds++;
@@ -366,7 +365,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 			 * is partway through open().  So make sure that this
 			 * fd is available to the new process.
 			 */
-			FD_CLR(open_files - i, new_fdt->open_fds);
+			__clear_open_fd(open_files - i, new_fdt);
 		}
 		rcu_assign_pointer(*new_fds++, f);
 	}
@@ -379,11 +378,11 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	memset(new_fds, 0, size);
 
 	if (new_fdt->max_fds > open_files) {
-		int left = (new_fdt->max_fds-open_files)/8;
-		int start = open_files / (8 * sizeof(unsigned long));
+		int left = (new_fdt->max_fds - open_files) / 8;
+		int start = open_files / BITS_PER_LONG;
 
-		memset(&new_fdt->open_fds->fds_bits[start], 0, left);
-		memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
+		memset(&new_fdt->open_fds[start], 0, left);
+		memset(&new_fdt->close_on_exec[start], 0, left);
 	}
 
 	rcu_assign_pointer(newf->fdt, new_fdt);
@@ -419,8 +418,8 @@ struct files_struct init_files = {
 	.fdtab		= {
 		.max_fds	= NR_OPEN_DEFAULT,
 		.fd		= &init_files.fd_array[0],
-		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
-		.open_fds	= (fd_set *)&init_files.open_fds_init,
+		.close_on_exec	= init_files.close_on_exec_init,
+		.open_fds	= init_files.open_fds_init,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
@@ -443,8 +442,7 @@ repeat:
 		fd = files->next_fd;
 
 	if (fd < fdt->max_fds)
-		fd = find_next_zero_bit(fdt->open_fds->fds_bits,
-					   fdt->max_fds, fd);
+		fd = find_next_zero_bit(fdt->open_fds, fdt->max_fds, fd);
 
 	error = expand_files(files, fd);
 	if (error < 0)
@@ -460,11 +458,11 @@ repeat:
 	if (start <= files->next_fd)
 		files->next_fd = fd + 1;
 
-	FD_SET(fd, fdt->open_fds);
+	__set_open_fd(fd, fdt);
 	if (flags & O_CLOEXEC)
-		FD_SET(fd, fdt->close_on_exec);
+		__set_close_on_exec(fd, fdt);
 	else
-		FD_CLR(fd, fdt->close_on_exec);
+		__clear_close_on_exec(fd, fdt);
 	error = fd;
 #if 1
 	/* Sanity check */
diff --git a/fs/open.c b/fs/open.c
index 77becc0..5720854 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -836,7 +836,7 @@ EXPORT_SYMBOL(dentry_open);
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
-	__FD_CLR(fd, fdt->open_fds);
+	__clear_open_fd(fd, fdt);
 	if (fd < files->next_fd)
 		files->next_fd = fd;
 }
@@ -1080,7 +1080,7 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 	if (!filp)
 		goto out_unlock;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
-	FD_CLR(fd, fdt->close_on_exec);
+	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 	retval = filp_close(filp, files);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..db6ab4b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1754,7 +1754,7 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 
 			fdt = files_fdtable(files);
 			f_flags = file->f_flags & ~O_CLOEXEC;
-			if (FD_ISSET(fd, fdt->close_on_exec))
+			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
 
 			if (path) {
diff --git a/fs/select.c b/fs/select.c
index d33418f..2e7fbe8 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -348,7 +348,7 @@ static int max_select_fd(unsigned long n, fd_set_bits *fds)
 	set = ~(~0UL << (n & (__NFDBITS-1)));
 	n /= __NFDBITS;
 	fdt = files_fdtable(current->files);
-	open_fds = fdt->open_fds->fds_bits+n;
+	open_fds = fdt->open_fds + n;
 	max = 0;
 	if (set) {
 		set &= BITS(fds, n);
diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index 3dab008..91d44bd 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -10,8 +10,13 @@
  * architectures, so that you can override them.
  */
 
+#ifndef __kernel_long_t
+typedef long		__kernel_long_t;
+typedef unsigned long	__kernel_ulong_t;
+#endif
+
 #ifndef __kernel_ino_t
-typedef unsigned long	__kernel_ino_t;
+typedef __kernel_ulong_t __kernel_ino_t;
 #endif
 
 #ifndef __kernel_mode_t
@@ -19,7 +24,7 @@ typedef unsigned int	__kernel_mode_t;
 #endif
 
 #ifndef __kernel_nlink_t
-typedef unsigned long	__kernel_nlink_t;
+typedef __kernel_ulong_t __kernel_nlink_t;
 #endif
 
 #ifndef __kernel_pid_t
@@ -36,7 +41,7 @@ typedef unsigned int	__kernel_gid_t;
 #endif
 
 #ifndef __kernel_suseconds_t
-typedef long		__kernel_suseconds_t;
+typedef __kernel_long_t		__kernel_suseconds_t;
 #endif
 
 #ifndef __kernel_daddr_t
@@ -44,8 +49,8 @@ typedef int		__kernel_daddr_t;
 #endif
 
 #ifndef __kernel_uid32_t
-typedef __kernel_uid_t	__kernel_uid32_t;
-typedef __kernel_gid_t	__kernel_gid32_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
 #endif
 
 #ifndef __kernel_old_uid_t
@@ -67,99 +72,29 @@ typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
 #else
-typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
-typedef long		__kernel_ptrdiff_t;
+typedef __kernel_ulong_t __kernel_size_t;
+typedef __kernel_long_t	__kernel_ssize_t;
+typedef __kernel_long_t	__kernel_ptrdiff_t;
 #endif
 #endif
 
+#ifndef __kernel_fsid_t
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+#endif
+
 /*
  * anything below here should be completely generic
  */
-typedef long		__kernel_off_t;
+typedef __kernel_long_t	__kernel_off_t;
 typedef long long	__kernel_loff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_clock_t;
+typedef __kernel_long_t	__kernel_time_t;
+typedef __kernel_long_t	__kernel_clock_t;
 typedef int		__kernel_timer_t;
 typedef int		__kernel_clockid_t;
 typedef char *		__kernel_caddr_t;
 typedef unsigned short	__kernel_uid16_t;
 typedef unsigned short	__kernel_gid16_t;
 
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#ifdef __KERNEL__
-
-#undef __FD_SET
-static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
-}
-
-#undef __FD_CLR
-static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	__fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
-}
-
-#undef __FD_ISSET
-static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
-{
-	unsigned long __tmp = __fd / __NFDBITS;
-	unsigned long __rem = __fd % __NFDBITS;
-	return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
-}
-
-/*
- * This will unroll the loop for the normal constant case (8 ints,
- * for a 256-bit fd_set)
- */
-#undef __FD_ZERO
-static inline void __FD_ZERO(__kernel_fd_set *__p)
-{
-	unsigned long *__tmp = __p->fds_bits;
-	int __i;
-
-	if (__builtin_constant_p(__FDSET_LONGS)) {
-		switch (__FDSET_LONGS) {
-		case 16:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			__tmp[ 8] = 0; __tmp[ 9] = 0;
-			__tmp[10] = 0; __tmp[11] = 0;
-			__tmp[12] = 0; __tmp[13] = 0;
-			__tmp[14] = 0; __tmp[15] = 0;
-			return;
-
-		case 8:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			__tmp[ 4] = 0; __tmp[ 5] = 0;
-			__tmp[ 6] = 0; __tmp[ 7] = 0;
-			return;
-
-		case 4:
-			__tmp[ 0] = 0; __tmp[ 1] = 0;
-			__tmp[ 2] = 0; __tmp[ 3] = 0;
-			return;
-		}
-	}
-	__i = __FDSET_LONGS;
-	while (__i) {
-		__i--;
-		*__tmp = 0;
-		__tmp++;
-	}
-}
-
-#endif /* __KERNEL__ */
-
 #endif /* __ASM_GENERIC_POSIX_TYPES_H */
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index c94e717..8446086 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -355,6 +355,7 @@ header-y += suspend_ioctls.h
 header-y += swab.h
 header-y += synclink.h
 header-y += sysctl.h
+header-y += sysinfo.h
 header-y += taskstats.h
 header-y += tcp.h
 header-y += telephony.h
diff --git a/include/linux/aio_abi.h b/include/linux/aio_abi.h
index 2c87316..86fa7a7 100644
--- a/include/linux/aio_abi.h
+++ b/include/linux/aio_abi.h
@@ -30,7 +30,7 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
-typedef unsigned long	aio_context_t;
+typedef __kernel_ulong_t aio_context_t;
 
 enum {
 	IOCB_CMD_PREAD = 0,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 41c9f65..a82e452 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -19,6 +19,10 @@
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
+#ifndef COMPAT_USE_64BIT_TIME
+#define COMPAT_USE_64BIT_TIME 0
+#endif
+
 #define compat_jiffies_to_clock_t(x)	\
 		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
 
@@ -83,10 +87,26 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
+/*
+ * These functions operate strictly on struct compat_time*
+ */
 extern int get_compat_timespec(struct timespec *,
 			       const struct compat_timespec __user *);
 extern int put_compat_timespec(const struct timespec *,
 			       struct compat_timespec __user *);
+extern int get_compat_timeval(struct timeval *,
+			      const struct compat_timeval __user *);
+extern int put_compat_timeval(const struct timeval *,
+			      struct compat_timeval __user *);
+/*
+ * These functions operate on 32- or 64-bit specs depending on
+ * COMPAT_USE_64BIT_TIME, hence the void user pointer arguments and the
+ * naming as compat_get/put_ rather than get/put_compat_.
+ */
+extern int compat_get_timespec(struct timespec *, const void __user *);
+extern int compat_put_timespec(const struct timespec *, void __user *);
+extern int compat_get_timeval(struct timeval *, const void __user *);
+extern int compat_put_timeval(const struct timeval *, void __user *);
 
 struct compat_iovec {
 	compat_uptr_t	iov_base;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 82163c4..158a41e 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -21,23 +21,45 @@
  */
 #define NR_OPEN_DEFAULT BITS_PER_LONG
 
-/*
- * The embedded_fd_set is a small fd_set,
- * suitable for most tasks (which open <= BITS_PER_LONG files)
- */
-struct embedded_fd_set {
-	unsigned long fds_bits[1];
-};
-
 struct fdtable {
 	unsigned int max_fds;
 	struct file __rcu **fd;      /* current fd array */
-	fd_set *close_on_exec;
-	fd_set *open_fds;
+	unsigned long *close_on_exec;
+	unsigned long *open_fds;
 	struct rcu_head rcu;
 	struct fdtable *next;
 };
 
+static inline void __set_close_on_exec(int fd, struct fdtable *fdt)
+{
+	__set_bit(fd, fdt->close_on_exec);
+}
+
+static inline void __clear_close_on_exec(int fd, struct fdtable *fdt)
+{
+	__clear_bit(fd, fdt->close_on_exec);
+}
+
+static inline bool close_on_exec(int fd, const struct fdtable *fdt)
+{
+	return test_bit(fd, fdt->close_on_exec);
+}
+
+static inline void __set_open_fd(int fd, struct fdtable *fdt)
+{
+	__set_bit(fd, fdt->open_fds);
+}
+
+static inline void __clear_open_fd(int fd, struct fdtable *fdt)
+{
+	__clear_bit(fd, fdt->open_fds);
+}
+
+static inline bool fd_is_open(int fd, const struct fdtable *fdt)
+{
+	return test_bit(fd, fdt->open_fds);
+}
+
 /*
  * Open file table structure
  */
@@ -53,8 +75,8 @@ struct files_struct {
    */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	int next_fd;
-	struct embedded_fd_set close_on_exec_init;
-	struct embedded_fd_set open_fds_init;
+	unsigned long close_on_exec_init[1];
+	unsigned long open_fds_init[1];
 	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
 };
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..dc6a50f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
+#include <linux/sysinfo.h>
+
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
@@ -745,27 +747,8 @@ extern int __build_bug_on_failed;
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
-struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
 #endif /* __KERNEL__ */
 
-#define SI_LOAD_SHIFT	16
-struct sysinfo {
-	long uptime;			/* Seconds since boot */
-	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
-	unsigned long totalram;		/* Total usable main memory size */
-	unsigned long freeram;		/* Available memory size */
-	unsigned long sharedram;	/* Amount of shared memory */
-	unsigned long bufferram;	/* Memory used by buffers */
-	unsigned long totalswap;	/* Total swap space size */
-	unsigned long freeswap;		/* swap space still available */
-	unsigned short procs;		/* Number of current processes */
-	unsigned short pad;		/* explicit padding for m68k */
-	unsigned long totalhigh;	/* Total high memory size */
-	unsigned long freehigh;		/* Available high memory size */
-	unsigned int mem_unit;		/* Memory unit size in bytes */
-	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
-};
-
 #endif
diff --git a/include/linux/sysinfo.h b/include/linux/sysinfo.h
new file mode 100644
index 0000000..934335a
--- /dev/null
+++ b/include/linux/sysinfo.h
@@ -0,0 +1,24 @@
+#ifndef _LINUX_SYSINFO_H
+#define _LINUX_SYSINFO_H
+
+#include <linux/types.h>
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	__kernel_long_t uptime;		/* Seconds since boot */
+	__kernel_ulong_t loads[3];	/* 1, 5, and 15 minute load averages */
+	__kernel_ulong_t totalram;	/* Total usable main memory size */
+	__kernel_ulong_t freeram;	/* Available memory size */
+	__kernel_ulong_t sharedram;	/* Amount of shared memory */
+	__kernel_ulong_t bufferram;	/* Memory used by buffers */
+	__kernel_ulong_t totalswap;	/* Total swap space size */
+	__kernel_ulong_t freeswap;	/* swap space still available */
+	__u16 procs;		   	/* Number of current processes */
+	__u16 pad;		   	/* Explicit padding for m68k */
+	__kernel_ulong_t totalhigh;	/* Total high memory size */
+	__kernel_ulong_t freehigh;	/* Available high memory size */
+	__u32 mem_unit;			/* Memory unit size in bytes */
+	char _f[20-2*sizeof(__kernel_ulong_t)-sizeof(__u32)];	/* Padding: libc5 uses this.. */
+};
+
+#endif /* _LINUX_SYSINFO_H */
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..9f43487 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -256,6 +256,7 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
diff --git a/kernel/compat.c b/kernel/compat.c
index f346ced..74ff849 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -31,11 +31,10 @@
 #include <asm/uaccess.h>
 
 /*
- * Note that the native side is already converted to a timespec, because
- * that's what we want anyway.
+ * Get/set struct timeval with struct timespec on the native side
  */
-static int compat_get_timeval(struct timespec *o,
-		struct compat_timeval __user *i)
+static int compat_get_timeval_convert(struct timespec *o,
+				      struct compat_timeval __user *i)
 {
 	long usec;
 
@@ -46,8 +45,8 @@ static int compat_get_timeval(struct timespec *o,
 	return 0;
 }
 
-static int compat_put_timeval(struct compat_timeval __user *o,
-		struct timeval *i)
+static int compat_put_timeval_convert(struct compat_timeval __user *o,
+				      struct timeval *i)
 {
 	return (put_user(i->tv_sec, &o->tv_sec) ||
 		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
@@ -117,7 +116,7 @@ asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 	if (tv) {
 		struct timeval ktv;
 		do_gettimeofday(&ktv);
-		if (compat_put_timeval(tv, &ktv))
+		if (compat_put_timeval_convert(tv, &ktv))
 			return -EFAULT;
 	}
 	if (tz) {
@@ -135,7 +134,7 @@ asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
 	struct timezone ktz;
 
 	if (tv) {
-		if (compat_get_timeval(&kts, tv))
+		if (compat_get_timeval_convert(&kts, tv))
 			return -EFAULT;
 	}
 	if (tz) {
@@ -146,12 +145,29 @@ asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
 	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
 }
 
+int get_compat_timeval(struct timeval *tv, const struct compat_timeval __user *ctv)
+{
+	return (!access_ok(VERIFY_READ, ctv, sizeof(*ctv)) ||
+			__get_user(tv->tv_sec, &ctv->tv_sec) ||
+			__get_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(get_compat_timeval);
+
+int put_compat_timeval(const struct timeval *tv, struct compat_timeval __user *ctv)
+{
+	return (!access_ok(VERIFY_WRITE, ctv, sizeof(*ctv)) ||
+			__put_user(tv->tv_sec, &ctv->tv_sec) ||
+			__put_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(put_compat_timeval);
+
 int get_compat_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
 {
 	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
 			__get_user(ts->tv_sec, &cts->tv_sec) ||
 			__get_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
+EXPORT_SYMBOL_GPL(get_compat_timespec);
 
 int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user *cts)
 {
@@ -161,6 +177,42 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
 }
 EXPORT_SYMBOL_GPL(put_compat_timespec);
 
+int compat_get_timeval(struct timeval *tv, const void __user *utv)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return copy_from_user(tv, utv, sizeof *tv) ? -EFAULT : 0;
+	else
+		return get_compat_timeval(tv, utv);
+}
+EXPORT_SYMBOL_GPL(compat_get_timeval);
+
+int compat_put_timeval(const struct timeval *tv, void __user *utv)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return copy_to_user(utv, tv, sizeof *tv) ? -EFAULT : 0;
+	else
+		return put_compat_timeval(tv, utv);
+}
+EXPORT_SYMBOL_GPL(compat_put_timeval);
+
+int compat_get_timespec(struct timespec *ts, const void __user *uts)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return copy_from_user(ts, uts, sizeof *ts) ? -EFAULT : 0;
+	else
+		return get_compat_timespec(ts, uts);
+}
+EXPORT_SYMBOL_GPL(compat_get_timespec);
+
+int compat_put_timespec(const struct timespec *ts, void __user *uts)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return copy_to_user(uts, ts, sizeof *ts) ? -EFAULT : 0;
+	else
+		return put_compat_timespec(ts, uts);
+}
+EXPORT_SYMBOL_GPL(compat_put_timespec);
+
 static long compat_nanosleep_restart(struct restart_block *restart)
 {
 	struct compat_timespec __user *rmtp;
diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..4db0200 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -473,7 +473,7 @@ static void close_files(struct files_struct * files)
 		i = j * __NFDBITS;
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j++];
+		set = fdt->open_fds[j++];
 		while (set) {
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 0dcc962..b2eb2b9 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -418,7 +418,8 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
 		data = &tv;
 		len = sizeof(tv);
 #ifdef CONFIG_COMPAT
-		if (msg->msg_flags & MSG_CMSG_COMPAT) {
+		if (!COMPAT_USE_64BIT_TIME &&
+		    (msg->msg_flags & MSG_CMSG_COMPAT)) {
 			ctv.tv_sec = tv.tv_sec;
 			ctv.tv_usec = tv.tv_usec;
 			data = &ctv;
diff --git a/net/compat.c b/net/compat.c
index 6def90e..73bf0e0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -219,8 +219,6 @@ Efault:
 
 int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *data)
 {
-	struct compat_timeval ctv;
-	struct compat_timespec cts[3];
 	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
 	struct compat_cmsghdr cmhdr;
 	int cmlen;
@@ -230,24 +228,28 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 		return 0; /* XXX: return error? check spec. */
 	}
 
-	if (level == SOL_SOCKET && type == SCM_TIMESTAMP) {
-		struct timeval *tv = (struct timeval *)data;
-		ctv.tv_sec = tv->tv_sec;
-		ctv.tv_usec = tv->tv_usec;
-		data = &ctv;
-		len = sizeof(ctv);
-	}
-	if (level == SOL_SOCKET &&
-	    (type == SCM_TIMESTAMPNS || type == SCM_TIMESTAMPING)) {
-		int count = type == SCM_TIMESTAMPNS ? 1 : 3;
-		int i;
-		struct timespec *ts = (struct timespec *)data;
-		for (i = 0; i < count; i++) {
-			cts[i].tv_sec = ts[i].tv_sec;
-			cts[i].tv_nsec = ts[i].tv_nsec;
+	if (!COMPAT_USE_64BIT_TIME) {
+		struct compat_timeval ctv;
+		struct compat_timespec cts[3];
+		if (level == SOL_SOCKET && type == SCM_TIMESTAMP) {
+			struct timeval *tv = (struct timeval *)data;
+			ctv.tv_sec = tv->tv_sec;
+			ctv.tv_usec = tv->tv_usec;
+			data = &ctv;
+			len = sizeof(ctv);
+		}
+		if (level == SOL_SOCKET &&
+		    (type == SCM_TIMESTAMPNS || type == SCM_TIMESTAMPING)) {
+			int count = type == SCM_TIMESTAMPNS ? 1 : 3;
+			int i;
+			struct timespec *ts = (struct timespec *)data;
+			for (i = 0; i < count; i++) {
+				cts[i].tv_sec = ts[i].tv_sec;
+				cts[i].tv_nsec = ts[i].tv_nsec;
+			}
+			data = &cts;
+			len = sizeof(cts[0]) * count;
 		}
-		data = &cts;
-		len = sizeof(cts[0]) * count;
 	}
 
 	cmlen = CMSG_COMPAT_LEN(len);
@@ -454,11 +456,15 @@ static int compat_sock_getsockopt(struct socket *sock, int level, int optname,
 
 int compat_sock_get_timestamp(struct sock *sk, struct timeval __user *userstamp)
 {
-	struct compat_timeval __user *ctv =
-			(struct compat_timeval __user *) userstamp;
-	int err = -ENOENT;
+	struct compat_timeval __user *ctv;
+	int err;
 	struct timeval tv;
 
+	if (COMPAT_USE_64BIT_TIME)
+		return sock_get_timestamp(sk, userstamp);
+
+	ctv = (struct compat_timeval __user *) userstamp;
+	err = -ENOENT;
 	if (!sock_flag(sk, SOCK_TIMESTAMP))
 		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
 	tv = ktime_to_timeval(sk->sk_stamp);
@@ -478,11 +484,15 @@ EXPORT_SYMBOL(compat_sock_get_timestamp);
 
 int compat_sock_get_timestampns(struct sock *sk, struct timespec __user *userstamp)
 {
-	struct compat_timespec __user *ctv =
-			(struct compat_timespec __user *) userstamp;
-	int err = -ENOENT;
+	struct compat_timespec __user *ctv;
+	int err;
 	struct timespec ts;
 
+	if (COMPAT_USE_64BIT_TIME)
+		return sock_get_timestampns (sk, userstamp);
+
+	ctv = (struct compat_timespec __user *) userstamp;
+	err = -ENOENT;
 	if (!sock_flag(sk, SOCK_TIMESTAMP))
 		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
 	ts = ktime_to_timespec(sk->sk_stamp);
@@ -767,6 +777,11 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	int datagrams;
 	struct timespec ktspec;
 
+	if (COMPAT_USE_64BIT_TIME)
+		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
+				      flags | MSG_CMSG_COMPAT,
+				      (struct timespec *) timeout);
+
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
diff --git a/net/socket.c b/net/socket.c
index 28a96af..5325d4c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2600,7 +2600,7 @@ void socket_seq_show(struct seq_file *seq)
 
 #ifdef CONFIG_COMPAT
 static int do_siocgstamp(struct net *net, struct socket *sock,
-			 unsigned int cmd, struct compat_timeval __user *up)
+			 unsigned int cmd, void __user *up)
 {
 	mm_segment_t old_fs = get_fs();
 	struct timeval ktv;
@@ -2609,15 +2609,14 @@ static int do_siocgstamp(struct net *net, struct socket *sock,
 	set_fs(KERNEL_DS);
 	err = sock_do_ioctl(net, sock, cmd, (unsigned long)&ktv);
 	set_fs(old_fs);
-	if (!err) {
-		err = put_user(ktv.tv_sec, &up->tv_sec);
-		err |= __put_user(ktv.tv_usec, &up->tv_usec);
-	}
+	if (!err)
+		err = compat_put_timeval(up, &ktv);
+
 	return err;
 }
 
 static int do_siocgstampns(struct net *net, struct socket *sock,
-			 unsigned int cmd, struct compat_timespec __user *up)
+			   unsigned int cmd, void __user *up)
 {
 	mm_segment_t old_fs = get_fs();
 	struct timespec kts;
@@ -2626,10 +2625,9 @@ static int do_siocgstampns(struct net *net, struct socket *sock,
 	set_fs(KERNEL_DS);
 	err = sock_do_ioctl(net, sock, cmd, (unsigned long)&kts);
 	set_fs(old_fs);
-	if (!err) {
-		err = put_user(kts.tv_sec, &up->tv_sec);
-		err |= __put_user(kts.tv_nsec, &up->tv_nsec);
-	}
+	if (!err)
+		err = compat_put_timespec(up, &kts);
+
 	return err;
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6a3683e..421c990 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2145,7 +2145,7 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 		fdt = files_fdtable(files);
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j];
+		set = fdt->open_fds[j];
 		if (!set)
 			continue;
 		spin_unlock(&files->file_lock);
