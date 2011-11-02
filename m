Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1KBOKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:10:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60757 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab1KBOKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:10:31 -0400
Message-ID: <4EB14F51.1050004@nod.at>
Date: Wed, 02 Nov 2011 15:10:25 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UML changes for 3.2
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus, Andrew,

[Andrew, I hope it's okay for you when I send this changes as pull-request
directly to Linus. 90 patches per mail are too just much...]

Please pull from git://github.com/richardweinberger/linux.git for-linus

Most changes are from Al, he did a massive cleanup and started with
merging the i386 and x86_64 subarchs.
The x86 specific UML code is now in arch/x86/um.

The tag "for-linus" is with my new PGP key signed.
ID: E0E1469A Richard Weinberger (kernel.org) <richard@nod.at>
Fingerprint: 7625 C1C6 7A6E 035F A1FC  5E4B F99E 2237 E0E1 469A
Currently it's only signed by Christoph Hellwig.

Thanks,
//richard

The following changes since commit
c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://github.com/richardweinberger/linux.git for-linus

Al Viro (84):
      um: use subarch-obj instead of copying...
      um: switch {rt_,}sigreturn() to set_current_blocked()
      um: don't rely on sc.fpstate not having been reassigned prior to
rt_sigreturn()
      um: make copy_sc() static
      um: series of __get_user() is costly in sigframe handling
      um: switch to -idirafter, get saner kern_constants.h out of that
      um: kill skas_ptregs.h
      um: take user_constants.h to include/generated
      um: -include user.h for USER_OBJ, trim includes
      um: kill a couple of useless includes of kern_constants.h
      um: get rid of kern_constants.h
      um: trim unused junk from user.h
      um: get rid of sysdep/checksum.h
      um: take vm-flags.h to sys-*/asm
      um: Get rid of UPT_SET/UPT_REG macros
      um: get rid of sysdep/sc.h
      um: get rid of unused macros in ptrace_user.h
      um: merge arch/um/sys-{i386,x86_64}/asm
      um: merge arch/um/sys-{i386,x86_64}/shared
      um: merge arch/um/sys-{i386,x86_64}
      um: kill dead code around uaccess
      um: merge hard_handler() instances, switch to use of SA_SIGINFO
      um: merge arch/um/os-Linux/sys-{i386,x86_64}
      um: kill includes of sysdep/sigcontext.h from stuff built with
kernel headers
      um: switch stub_segv_handler to SA_SIGINFO variant, get rid of
magic crap in there
      um: don't bother blocking SIGARLM and SIGUSR1
      um: simplify set_handler()
      um: fill the handlers array at build time
      um: take system.h out of shared/sysdep
      um: take userland definition of barrier() to user.h
      um: start switching the references to host mcontext_t to its
userland type
      um: finish conversion to mcontext_t
      um: shared/process.h is empty now; kill it
      um: sysdep/barrier.h is not used for anything
      um: merge skas_ptrace.h 32/64bit variants
      um: merge kernel_offsets_*.h
      um: arch_hweight.h is needed only on uml-x86
      um: trim detritus from Makefile-i386
      um: merge Makefile-{i386,x86_64}
      um: take arch/um/sys-x86 to arch/x86/um
      um: bury unused macros around ptrace.h
      um: make load_initrd() static, kill shared/initrd.h
      um: trim kern.h
      um: don't include kern.h unless it's needed
      um: shared/syscall.h is not even included
      um: kill shared/task.h and HOST_TASK_REGS
      um: make flush_tlb_kernel_range_common() static
      um: kill shared/tlb.h
      um: kill shared/mem_kern.h
      um: take register_winch_irq() into the caller of is_skas_winch()
      um: take chan_*.h and line.h to arch/um/drivers
      um: take mconsole*.h to arch/um/drivers
      um: kill um_uaccess.h
      um: kill useless include of user.h
      um: take um_mmu.h to asm/mmu.h, clean asm/mmu_context.h a bit
      um: merge tls_{32,64}.h
      um: merge host_ldt_{32,64}.h
      um: move asm/desc.h into arch/x86/um/asm
      um: merge os-Linux/tls.c into arch/x86/um/os-Linux/tls.c
      um: sanitize paths in sys_call_table* includes
      um: merge HOST_... of registers common on i386 and amd64
      um: increase stack growth cushion in pagefault
      um: no need to play with save_sp in signal frame setup anymore
      um: merge signal_{32,64}.c
      um: take ldt.h to arch/x86/um/asm/mm_context.h
      um: take ubd_user.h to its users...
      um: asm/apic.h is there only to shadow the x86 one...
      um: required-features.h is there only to shadow x86 one...
      um: irq_vectors.h just shadows x86 one
      um: page_offset.h is never used
      um: fix gcov build breakage
      um: unify KSTK_...
      um: unify ptrace_user.h
      um: kill useless argument of free_chan() and free_one_chan()
      um: a couple of missing dependencies...
      um: clean Kconfig up a bit
      um: switch to generic-y
      um: hw_irq.h can go generic as well
      um: asm/pda.h is not needed anymore
      um: segment.h is x86-only and needed only there
      um: generic ftrace.h will do...
      um: kill system-um.h
      um: distribute exports to where exported stuff is defined
      um: switch to use of drivers/Kconfig

Dave Jones (1):
      um: Fix kmalloc argument order in um/vdso/vma.c

Jonathan Neuschäfer (2):
      UserModeLinux-HOWTO.txt: remove ^H characters
      UserModeLinux-HOWTO.txt: fix a typo

Richard Weinberger (3):
      um: merge delay_{32,64}.c
      um: we need sys/user.h only on i386
      um: fix ubd cow size

 Documentation/virtual/uml/UserModeLinux-HOWTO.txt  |  532
++++++++++----------
 arch/um/Kconfig.char                               |  114 +-----
 arch/um/Kconfig.rest                               |   23 +-
 arch/um/Kconfig.um                                 |    6 +
 arch/um/Makefile                                   |   49 +-
 arch/um/Makefile-x86_64                            |   26 -
 .../{include/shared/chan_kern.h => drivers/chan.h} |    6 +-
 arch/um/drivers/chan_kern.c                        |   12 +-
 arch/um/drivers/chan_user.c                        |    9 +-
 arch/um/{include/shared => drivers}/chan_user.h    |    0
 arch/um/drivers/cow_sys.h                          |    1 -
 arch/um/drivers/daemon_user.c                      |    1 -
 arch/um/drivers/fd.c                               |    2 -
 arch/um/drivers/harddog_user.c                     |    1 -
 arch/um/drivers/line.c                             |    2 +-
 arch/um/{include/shared => drivers}/line.h         |    0
 arch/um/{include/shared => drivers}/mconsole.h     |    0
 .../um/{include/shared => drivers}/mconsole_kern.h |    0
 arch/um/drivers/mconsole_user.c                    |    2 -
 arch/um/drivers/net_user.c                         |    2 -
 arch/um/drivers/pcap_user.c                        |    2 -
 arch/um/drivers/port_user.c                        |    2 -
 arch/um/drivers/pty.c                              |    2 -
 arch/um/drivers/slip_user.c                        |    2 -
 arch/um/drivers/slirp_user.c                       |    2 -
 arch/um/drivers/ssl.c                              |    4 +-
 arch/um/drivers/stdio_console.c                    |    3 +-
 arch/um/drivers/tty.c                              |    2 -
 arch/um/drivers/ubd_kern.c                         |   33 ++-
 arch/um/drivers/ubd_user.c                         |    1 -
 arch/um/{include/shared => drivers}/ubd_user.h     |    0
 arch/um/drivers/umcast_user.c                      |    2 -
 arch/um/drivers/vde_user.c                         |    2 -
 arch/um/drivers/xterm.c                            |    2 -
 arch/um/include/asm/Kbuild                         |    3 +
 arch/um/include/asm/bug.h                          |    6 -
 arch/um/include/asm/checksum.h                     |    6 -
 arch/um/include/asm/cputime.h                      |    6 -
 arch/um/include/asm/device.h                       |    7 -
 arch/um/include/asm/emergency-restart.h            |    6 -
 arch/um/include/asm/ftrace.h                       |    1 -
 arch/um/include/asm/futex.h                        |    6 -
 arch/um/include/asm/hardirq.h                      |    1 -
 arch/um/include/asm/hw_irq.h                       |    7 -
 arch/um/include/asm/irq_regs.h                     |    1 -
 arch/um/include/asm/irqflags.h                     |   38 ++-
 arch/um/include/asm/kdebug.h                       |    1 -
 arch/um/include/asm/mmu.h                          |   22 +-
 arch/um/include/asm/mmu_context.h                  |    7 +-
 arch/um/include/asm/page.h                         |    2 +-
 arch/um/include/asm/page_offset.h                  |    1 -
 arch/um/include/asm/pda.h                          |   21 -
 arch/um/include/asm/percpu.h                       |    6 -
 arch/um/include/asm/ptrace-generic.h               |    7 -
 arch/um/include/asm/sections.h                     |    7 -
 arch/um/include/asm/system.h                       |   47 --
 arch/um/include/asm/topology.h                     |    6 -
 arch/um/include/asm/uaccess.h                      |   89 +++-
 arch/um/include/asm/xor.h                          |    6 -
 arch/um/include/shared/as-layout.h                 |    2 +-
 arch/um/include/shared/common-offsets.h            |    1 -
 arch/um/include/shared/initrd.h                    |   12 -
 arch/um/include/shared/kern.h                      |   18 -
 arch/um/include/shared/kern_util.h                 |    1 -
 arch/um/include/shared/ldt.h                       |   37 --
 arch/um/include/shared/mem_kern.h                  |   20 -
 arch/um/include/shared/os.h                        |   13 +-
 arch/um/include/shared/process.h                   |   17 -
 arch/um/include/shared/ptrace_user.h               |    3 +-
 arch/um/include/shared/skas_ptregs.h               |    6 -
 arch/um/include/shared/syscall.h                   |   12 -
 arch/um/include/shared/task.h                      |    9 -
 arch/um/include/shared/tlb.h                       |   15 -
 arch/um/include/shared/um_malloc.h                 |    2 +-
 arch/um/include/shared/um_mmu.h                    |   24 -
 arch/um/include/shared/um_uaccess.h                |   97 ----
 arch/um/include/shared/user.h                      |    7 +-
 arch/um/kernel/Makefile                            |    2 +-
 arch/um/kernel/exec.c                              |   18 +-
 arch/um/kernel/gmon_syms.c                         |   15 -
 arch/um/kernel/initrd.c                            |    4 +-
 arch/um/kernel/irq.c                               |    1 +
 arch/um/kernel/ksyms.c                             |   38 +--
 arch/um/kernel/mem.c                               |    2 +
 arch/um/kernel/physmem.c                           |   21 +-
 arch/um/kernel/process.c                           |    4 +-
 arch/um/kernel/signal.c                            |    1 -
 arch/um/kernel/skas/clone.c                        |    1 -
 arch/um/kernel/skas/uaccess.c                      |    6 +
 arch/um/kernel/tlb.c                               |    5 +-
 arch/um/kernel/trap.c                              |    3 +-
 arch/um/kernel/uaccess.c                           |   33 --
 arch/um/kernel/um_arch.c                           |    2 +
 arch/um/os-Linux/Makefile                          |    6 +-
 arch/um/os-Linux/aio.c                             |    2 -
 arch/um/os-Linux/drivers/ethertap_user.c           |    2 -
 arch/um/os-Linux/drivers/tuntap_user.c             |    2 -
 arch/um/os-Linux/elf_aux.c                         |    1 -
 arch/um/os-Linux/file.c                            |    2 -
 arch/um/os-Linux/helper.c                          |    2 -
 arch/um/os-Linux/internal.h                        |    1 +
 arch/um/os-Linux/irq.c                             |    3 -
 arch/um/os-Linux/main.c                            |    1 -
 arch/um/os-Linux/mem.c                             |    2 -
 arch/um/os-Linux/process.c                         |   23 +-
 arch/um/os-Linux/sigio.c                           |    3 -
 arch/um/os-Linux/signal.c                          |   72 ++--
 arch/um/os-Linux/skas/mem.c                        |    2 -
 arch/um/os-Linux/skas/process.c                    |   21 +-
 arch/um/os-Linux/start_up.c                        |   10 +-
 arch/um/os-Linux/sys-i386/signal.c                 |   13 -
 arch/um/os-Linux/sys-x86_64/Makefile               |   10 -
 arch/um/os-Linux/sys-x86_64/registers.c            |   52 --
 arch/um/os-Linux/sys-x86_64/signal.c               |   16 -
 arch/um/os-Linux/sys-x86_64/task_size.c            |    5 -
 arch/um/os-Linux/time.c                            |    4 +-
 arch/um/os-Linux/tls.c                             |   35 --
 arch/um/os-Linux/tty.c                             |    2 -
 arch/um/os-Linux/uaccess.c                         |   32 --
 arch/um/os-Linux/umid.c                            |    2 -
 arch/um/os-Linux/util.c                            |    2 -
 arch/um/scripts/Makefile.rules                     |    7 +-
 arch/um/sys-i386/Makefile                          |   24 -
 arch/um/sys-i386/asm/elf.h                         |  125 -----
 arch/um/sys-i386/asm/module.h                      |   13 -
 arch/um/sys-i386/atomic64_cx8_32.S                 |  225 ---------
 arch/um/sys-i386/bug.c                             |   21 -
 arch/um/sys-i386/ksyms.c                           |    5 -
 arch/um/sys-i386/shared/sysdep/barrier.h           |    9 -
 arch/um/sys-i386/shared/sysdep/host_ldt.h          |   34 --
 arch/um/sys-i386/shared/sysdep/ptrace_user.h       |   50 --
 arch/um/sys-i386/shared/sysdep/sc.h                |   44 --
 arch/um/sys-i386/shared/sysdep/sigcontext.h        |   26 -
 arch/um/sys-i386/shared/sysdep/vm-flags.h          |   14 -
 arch/um/sys-i386/stub_segv.c                       |   17 -
 arch/um/sys-i386/user-offsets.c                    |   53 --
 arch/um/sys-x86_64/Makefile                        |   27 -
 arch/um/sys-x86_64/asm/archparam.h                 |   16 -
 arch/um/sys-x86_64/asm/module.h                    |   20 -
 arch/um/sys-x86_64/delay.c                         |   60 ---
 arch/um/sys-x86_64/fault.c                         |   28 -
 arch/um/sys-x86_64/ptrace_user.c                   |   22 -
 arch/um/sys-x86_64/shared/sysdep/barrier.h         |    7 -
 arch/um/sys-x86_64/shared/sysdep/host_ldt.h        |   38 --
 arch/um/sys-x86_64/shared/sysdep/kernel-offsets.h  |   23 -
 arch/um/sys-x86_64/shared/sysdep/ptrace_user.h     |   77 ---
 arch/um/sys-x86_64/shared/sysdep/sc.h              |   45 --
 arch/um/sys-x86_64/shared/sysdep/sigcontext.h      |   27 -
 arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h     |   22 -
 arch/um/sys-x86_64/shared/sysdep/system.h          |  132 -----
 arch/um/sys-x86_64/shared/sysdep/tls.h             |   29 --
 arch/um/sys-x86_64/signal.c                        |  290 -----------
 arch/{um/Makefile-i386 => x86/Makefile.um}         |   37 +-
 arch/{um/Kconfig.x86 => x86/um/Kconfig}            |    0
 arch/x86/um/Makefile                               |   45 ++
 arch/{um/include => x86/um}/asm/apic.h             |    0
 arch/{um/include => x86/um}/asm/arch_hweight.h     |    0
 arch/{um/sys-i386 => x86/um}/asm/archparam.h       |    8 +-
 arch/x86/um/asm/checksum.h                         |   10 +
 .../sysdep/checksum.h => x86/um/asm/checksum_32.h} |    2 +-
 .../sysdep/checksum.h => x86/um/asm/checksum_64.h} |    0
 arch/{um/include => x86/um}/asm/desc.h             |    0
 arch/{um/sys-x86_64 => x86/um}/asm/elf.h           |  145 +++++-
 arch/{um/include => x86/um}/asm/irq_vectors.h      |    0
 arch/x86/um/asm/mm_context.h                       |   72 +++
 arch/x86/um/asm/module.h                           |   23 +
 arch/x86/um/asm/processor.h                        |   22 +
 .../asm/processor.h => x86/um/asm/processor_32.h}  |   18 +-
 .../asm/processor.h => x86/um/asm/processor_64.h}  |   11 -
 arch/x86/um/asm/ptrace.h                           |    5 +
 .../asm/ptrace.h => x86/um/asm/ptrace_32.h}        |    0
 .../asm/ptrace.h => x86/um/asm/ptrace_64.h}        |    2 +-
 .../{um/include => x86/um}/asm/required-features.h |    0
 arch/{um/include => x86/um}/asm/segment.h          |    0
 .../sys-i386/shared/sysdep => x86/um/asm}/system.h |    3 +
 .../shared/sysdep => x86/um/asm}/vm-flags.h        |   14 +-
 arch/{um/sys-x86_64 => x86/um}/bug.c               |    0
 arch/{um/sys-i386/bugs.c => x86/um/bugs_32.c}      |    6 +-
 arch/{um/sys-x86_64/bugs.c => x86/um/bugs_64.c}    |    0
 .../sys-i386/checksum.S => x86/um/checksum_32.S}   |    0
 arch/{um/sys-i386 => x86/um}/delay.c               |    0
 arch/{um/sys-i386 => x86/um}/elfcore.c             |    0
 arch/{um/sys-i386 => x86/um}/fault.c               |    0
 arch/{um/sys-x86_64 => x86/um}/ksyms.c             |    2 +
 arch/{um/sys-i386 => x86/um}/ldt.c                 |   36 +-
 arch/{um/sys-i386/mem.c => x86/um/mem_32.c}        |    0
 arch/{um/sys-x86_64/mem.c => x86/um/mem_64.c}      |    0
 .../os-Linux/sys-i386 => x86/um/os-Linux}/Makefile |    5 +-
 arch/x86/um/os-Linux/mcontext.c                    |   31 ++
 .../sys-x86_64 => x86/um/os-Linux}/prctl.c         |    0
 .../sys-i386 => x86/um/os-Linux}/registers.c       |   62 ++-
 .../sys-i386 => x86/um/os-Linux}/task_size.c       |   13 +-
 .../os-Linux/sys-i386 => x86/um/os-Linux}/tls.c    |   35 ++-
 arch/{um/sys-i386/ptrace.c => x86/um/ptrace_32.c}  |   69 +++-
 .../{um/sys-x86_64/ptrace.c => x86/um/ptrace_64.c} |  103 ++++-
 arch/{um/sys-i386 => x86/um}/ptrace_user.c         |    2 +-
 arch/{um/sys-i386/setjmp.S => x86/um/setjmp_32.S}  |    0
 .../{um/sys-x86_64/setjmp.S => x86/um/setjmp_64.S} |    0
 arch/x86/um/shared/sysdep/archsetjmp.h             |    5 +
 .../um/shared/sysdep/archsetjmp_32.h}              |    0
 .../um/shared/sysdep/archsetjmp_64.h}              |    0
 arch/x86/um/shared/sysdep/faultinfo.h              |    5 +
 .../um/shared/sysdep/faultinfo_32.h}               |    6 +
 .../um/shared/sysdep/faultinfo_64.h}               |    6 +
 .../um}/shared/sysdep/kernel-offsets.h             |    0
 arch/x86/um/shared/sysdep/mcontext.h               |   31 ++
 arch/x86/um/shared/sysdep/ptrace.h                 |    5 +
 .../ptrace.h => x86/um/shared/sysdep/ptrace_32.h}  |   75 +---
 .../ptrace.h => x86/um/shared/sysdep/ptrace_64.h}  |  103 +----
 arch/x86/um/shared/sysdep/ptrace_user.h            |   27 +
 .../um}/shared/sysdep/skas_ptrace.h                |    4 +-
 arch/x86/um/shared/sysdep/stub.h                   |   14 +
 .../stub.h => x86/um/shared/sysdep/stub_32.h}      |    8 -
 .../stub.h => x86/um/shared/sysdep/stub_64.h}      |    8 -
 arch/x86/um/shared/sysdep/syscalls.h               |    5 +
 .../um/shared/sysdep/syscalls_32.h}                |    0
 .../um/shared/sysdep/syscalls_64.h}                |    1 -
 arch/{um/sys-i386 => x86/um}/shared/sysdep/tls.h   |    9 +-
 arch/{um/sys-i386 => x86/um}/signal.c              |  304 ++++++++----
 arch/{um/sys-i386/stub.S => x86/um/stub_32.S}      |    0
 arch/{um/sys-x86_64/stub.S => x86/um/stub_64.S}    |    0
 arch/{um/sys-x86_64 => x86/um}/stub_segv.c         |   11 +-
 .../um/sys_call_table_32.S}                        |    4 +-
 .../syscall_table.c => x86/um/sys_call_table_64.c} |    3 +-
 .../sys-i386/syscalls.c => x86/um/syscalls_32.c}   |    0
 .../sys-x86_64/syscalls.c => x86/um/syscalls_64.c} |    0
 arch/{um/sys-i386/sysrq.c => x86/um/sysrq_32.c}    |    0
 arch/{um/sys-x86_64/sysrq.c => x86/um/sysrq_64.c}  |    2 +-
 arch/{um/sys-i386/tls.c => x86/um/tls_32.c}        |    0
 arch/{um/sys-x86_64/tls.c => x86/um/tls_64.c}      |    0
 arch/{um/sys-x86_64 => x86/um}/user-offsets.c      |   51 ++-
 arch/{um/sys-x86_64 => x86/um}/vdso/Makefile       |    4 +-
 arch/{um/sys-x86_64 => x86/um}/vdso/checkundef.sh  |    0
 arch/{um/sys-x86_64 => x86/um}/vdso/um_vdso.c      |    0
 .../sys-x86_64 => x86/um}/vdso/vdso-layout.lds.S   |    0
 arch/{um/sys-x86_64 => x86/um}/vdso/vdso-note.S    |    0
 arch/{um/sys-x86_64 => x86/um}/vdso/vdso.S         |    2 +-
 arch/{um/sys-x86_64 => x86/um}/vdso/vdso.lds.S     |    0
 arch/{um/sys-x86_64 => x86/um}/vdso/vma.c          |    2 +-
 drivers/char/Kconfig                               |    6 +-
 drivers/char/hw_random/Kconfig                     |   15 +
 drivers/char/ttyprintk.c                           |    2 +-
 drivers/input/Kconfig                              |    2 +-
 drivers/isdn/Kconfig                               |    2 +-
 drivers/net/wireless/ath/Kconfig                   |    2 +-
 drivers/net/wireless/rtlwifi/Kconfig               |    4 +-
 drivers/power/Kconfig                              |    1 +
 drivers/rtc/Kconfig                                |    2 +-
 drivers/tty/Kconfig                                |    2 +-
 drivers/watchdog/Kconfig                           |    6 +-
 fs/hostfs/hostfs_user.c                            |    1 -
 security/integrity/ima/Kconfig                     |    2 +-
 sound/Kconfig                                      |    2 +-
 253 files changed, 1666 insertions(+), 3326 deletions(-)
 delete mode 100644 arch/um/Makefile-x86_64
 rename arch/um/{include/shared/chan_kern.h => drivers/chan.h} (95%)
 rename arch/um/{include/shared => drivers}/chan_user.h (100%)
 rename arch/um/{include/shared => drivers}/line.h (100%)
 rename arch/um/{include/shared => drivers}/mconsole.h (100%)
 rename arch/um/{include/shared => drivers}/mconsole_kern.h (100%)
 rename arch/um/{include/shared => drivers}/ubd_user.h (100%)
 create mode 100644 arch/um/include/asm/Kbuild
 delete mode 100644 arch/um/include/asm/bug.h
 delete mode 100644 arch/um/include/asm/checksum.h
 delete mode 100644 arch/um/include/asm/cputime.h
 delete mode 100644 arch/um/include/asm/device.h
 delete mode 100644 arch/um/include/asm/emergency-restart.h
 delete mode 100644 arch/um/include/asm/ftrace.h
 delete mode 100644 arch/um/include/asm/futex.h
 delete mode 100644 arch/um/include/asm/hardirq.h
 delete mode 100644 arch/um/include/asm/hw_irq.h
 delete mode 100644 arch/um/include/asm/irq_regs.h
 delete mode 100644 arch/um/include/asm/kdebug.h
 delete mode 100644 arch/um/include/asm/page_offset.h
 delete mode 100644 arch/um/include/asm/pda.h
 delete mode 100644 arch/um/include/asm/percpu.h
 delete mode 100644 arch/um/include/asm/sections.h
 delete mode 100644 arch/um/include/asm/system.h
 delete mode 100644 arch/um/include/asm/topology.h
 delete mode 100644 arch/um/include/asm/xor.h
 delete mode 100644 arch/um/include/shared/initrd.h
 delete mode 100644 arch/um/include/shared/ldt.h
 delete mode 100644 arch/um/include/shared/mem_kern.h
 delete mode 100644 arch/um/include/shared/process.h
 delete mode 100644 arch/um/include/shared/skas_ptregs.h
 delete mode 100644 arch/um/include/shared/syscall.h
 delete mode 100644 arch/um/include/shared/task.h
 delete mode 100644 arch/um/include/shared/tlb.h
 delete mode 100644 arch/um/include/shared/um_mmu.h
 delete mode 100644 arch/um/include/shared/um_uaccess.h
 delete mode 100644 arch/um/kernel/uaccess.c
 create mode 100644 arch/um/os-Linux/internal.h
 delete mode 100644 arch/um/os-Linux/sys-i386/signal.c
 delete mode 100644 arch/um/os-Linux/sys-x86_64/Makefile
 delete mode 100644 arch/um/os-Linux/sys-x86_64/registers.c
 delete mode 100644 arch/um/os-Linux/sys-x86_64/signal.c
 delete mode 100644 arch/um/os-Linux/sys-x86_64/task_size.c
 delete mode 100644 arch/um/os-Linux/tls.c
 delete mode 100644 arch/um/os-Linux/uaccess.c
 delete mode 100644 arch/um/sys-i386/Makefile
 delete mode 100644 arch/um/sys-i386/asm/elf.h
 delete mode 100644 arch/um/sys-i386/asm/module.h
 delete mode 100644 arch/um/sys-i386/atomic64_cx8_32.S
 delete mode 100644 arch/um/sys-i386/bug.c
 delete mode 100644 arch/um/sys-i386/ksyms.c
 delete mode 100644 arch/um/sys-i386/shared/sysdep/barrier.h
 delete mode 100644 arch/um/sys-i386/shared/sysdep/host_ldt.h
 delete mode 100644 arch/um/sys-i386/shared/sysdep/ptrace_user.h
 delete mode 100644 arch/um/sys-i386/shared/sysdep/sc.h
 delete mode 100644 arch/um/sys-i386/shared/sysdep/sigcontext.h
 delete mode 100644 arch/um/sys-i386/shared/sysdep/vm-flags.h
 delete mode 100644 arch/um/sys-i386/stub_segv.c
 delete mode 100644 arch/um/sys-i386/user-offsets.c
 delete mode 100644 arch/um/sys-x86_64/Makefile
 delete mode 100644 arch/um/sys-x86_64/asm/archparam.h
 delete mode 100644 arch/um/sys-x86_64/asm/module.h
 delete mode 100644 arch/um/sys-x86_64/delay.c
 delete mode 100644 arch/um/sys-x86_64/fault.c
 delete mode 100644 arch/um/sys-x86_64/ptrace_user.c
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/barrier.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/host_ldt.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/kernel-offsets.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/sc.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/sigcontext.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/system.h
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/tls.h
 delete mode 100644 arch/um/sys-x86_64/signal.c
 rename arch/{um/Makefile-i386 => x86/Makefile.um} (64%)
 rename arch/{um/Kconfig.x86 => x86/um/Kconfig} (100%)
 create mode 100644 arch/x86/um/Makefile
 rename arch/{um/include => x86/um}/asm/apic.h (100%)
 rename arch/{um/include => x86/um}/asm/arch_hweight.h (100%)
 rename arch/{um/sys-i386 => x86/um}/asm/archparam.h (62%)
 create mode 100644 arch/x86/um/asm/checksum.h
 rename arch/{um/sys-i386/shared/sysdep/checksum.h =>
x86/um/asm/checksum_32.h} (99%)
 rename arch/{um/sys-x86_64/shared/sysdep/checksum.h =>
x86/um/asm/checksum_64.h} (100%)
 rename arch/{um/include => x86/um}/asm/desc.h (100%)
 rename arch/{um/sys-x86_64 => x86/um}/asm/elf.h (59%)
 rename arch/{um/include => x86/um}/asm/irq_vectors.h (100%)
 create mode 100644 arch/x86/um/asm/mm_context.h
 create mode 100644 arch/x86/um/asm/module.h
 create mode 100644 arch/x86/um/asm/processor.h
 rename arch/{um/sys-i386/asm/processor.h =>
x86/um/asm/processor_32.h} (78%)
 rename arch/{um/sys-x86_64/asm/processor.h =>
x86/um/asm/processor_64.h} (77%)
 create mode 100644 arch/x86/um/asm/ptrace.h
 rename arch/{um/sys-i386/asm/ptrace.h => x86/um/asm/ptrace_32.h} (100%)
 rename arch/{um/sys-x86_64/asm/ptrace.h => x86/um/asm/ptrace_64.h} (98%)
 rename arch/{um/include => x86/um}/asm/required-features.h (100%)
 rename arch/{um/include => x86/um}/asm/segment.h (100%)
 rename arch/{um/sys-i386/shared/sysdep => x86/um/asm}/system.h (96%)
 rename arch/{um/sys-x86_64/shared/sysdep => x86/um/asm}/vm-flags.h (58%)
 rename arch/{um/sys-x86_64 => x86/um}/bug.c (100%)
 rename arch/{um/sys-i386/bugs.c => x86/um/bugs_32.c} (94%)
 rename arch/{um/sys-x86_64/bugs.c => x86/um/bugs_64.c} (100%)
 rename arch/{um/sys-i386/checksum.S => x86/um/checksum_32.S} (100%)
 rename arch/{um/sys-i386 => x86/um}/delay.c (100%)
 rename arch/{um/sys-i386 => x86/um}/elfcore.c (100%)
 rename arch/{um/sys-i386 => x86/um}/fault.c (100%)
 rename arch/{um/sys-x86_64 => x86/um}/ksyms.c (90%)
 rename arch/{um/sys-i386 => x86/um}/ldt.c (92%)
 rename arch/{um/sys-i386/mem.c => x86/um/mem_32.c} (100%)
 rename arch/{um/sys-x86_64/mem.c => x86/um/mem_64.c} (100%)
 rename arch/{um/os-Linux/sys-i386 => x86/um/os-Linux}/Makefile (61%)
 create mode 100644 arch/x86/um/os-Linux/mcontext.c
 rename arch/{um/os-Linux/sys-x86_64 => x86/um/os-Linux}/prctl.c (100%)
 rename arch/{um/os-Linux/sys-i386 => x86/um/os-Linux}/registers.c (79%)
 rename arch/{um/os-Linux/sys-i386 => x86/um/os-Linux}/task_size.c (95%)
 rename arch/{um/os-Linux/sys-i386 => x86/um/os-Linux}/tls.c (53%)
 rename arch/{um/sys-i386/ptrace.c => x86/um/ptrace_32.c} (83%)
 rename arch/{um/sys-x86_64/ptrace.c => x86/um/ptrace_64.c} (72%)
 rename arch/{um/sys-i386 => x86/um}/ptrace_user.c (94%)
 rename arch/{um/sys-i386/setjmp.S => x86/um/setjmp_32.S} (100%)
 rename arch/{um/sys-x86_64/setjmp.S => x86/um/setjmp_64.S} (100%)
 create mode 100644 arch/x86/um/shared/sysdep/archsetjmp.h
 rename arch/{um/sys-i386/shared/sysdep/archsetjmp.h =>
x86/um/shared/sysdep/archsetjmp_32.h} (100%)
 rename arch/{um/sys-x86_64/shared/sysdep/archsetjmp.h =>
x86/um/shared/sysdep/archsetjmp_64.h} (100%)
 create mode 100644 arch/x86/um/shared/sysdep/faultinfo.h
 rename arch/{um/sys-i386/shared/sysdep/faultinfo.h =>
x86/um/shared/sysdep/faultinfo_32.h} (80%)
 rename arch/{um/sys-x86_64/shared/sysdep/faultinfo.h =>
x86/um/shared/sysdep/faultinfo_64.h} (84%)
 rename arch/{um/sys-i386 => x86/um}/shared/sysdep/kernel-offsets.h (100%)
 create mode 100644 arch/x86/um/shared/sysdep/mcontext.h
 create mode 100644 arch/x86/um/shared/sysdep/ptrace.h
 rename arch/{um/sys-i386/shared/sysdep/ptrace.h =>
x86/um/shared/sysdep/ptrace_32.h} (56%)
 rename arch/{um/sys-x86_64/shared/sysdep/ptrace.h =>
x86/um/shared/sysdep/ptrace_64.h} (53%)
 create mode 100644 arch/x86/um/shared/sysdep/ptrace_user.h
 rename arch/{um/sys-i386 => x86/um}/shared/sysdep/skas_ptrace.h (80%)
 create mode 100644 arch/x86/um/shared/sysdep/stub.h
 rename arch/{um/sys-i386/shared/sysdep/stub.h =>
x86/um/shared/sysdep/stub_32.h} (90%)
 rename arch/{um/sys-x86_64/shared/sysdep/stub.h =>
x86/um/shared/sysdep/stub_64.h} (91%)
 create mode 100644 arch/x86/um/shared/sysdep/syscalls.h
 rename arch/{um/sys-i386/shared/sysdep/syscalls.h =>
x86/um/shared/sysdep/syscalls_32.h} (100%)
 rename arch/{um/sys-x86_64/shared/sysdep/syscalls.h =>
x86/um/shared/sysdep/syscalls_64.h} (96%)
 rename arch/{um/sys-i386 => x86/um}/shared/sysdep/tls.h (79%)
 rename arch/{um/sys-i386 => x86/um}/signal.c (70%)
 rename arch/{um/sys-i386/stub.S => x86/um/stub_32.S} (100%)
 rename arch/{um/sys-x86_64/stub.S => x86/um/stub_64.S} (100%)
 rename arch/{um/sys-x86_64 => x86/um}/stub_segv.c (53%)
 rename arch/{um/sys-i386/sys_call_table.S =>
x86/um/sys_call_table_32.S} (82%)
 rename arch/{um/sys-x86_64/syscall_table.c =>
x86/um/sys_call_table_64.c} (95%)
 rename arch/{um/sys-i386/syscalls.c => x86/um/syscalls_32.c} (100%)
 rename arch/{um/sys-x86_64/syscalls.c => x86/um/syscalls_64.c} (100%)
 rename arch/{um/sys-i386/sysrq.c => x86/um/sysrq_32.c} (100%)
 rename arch/{um/sys-x86_64/sysrq.c => x86/um/sysrq_64.c} (95%)
 rename arch/{um/sys-i386/tls.c => x86/um/tls_32.c} (100%)
 rename arch/{um/sys-x86_64/tls.c => x86/um/tls_64.c} (100%)
 rename arch/{um/sys-x86_64 => x86/um}/user-offsets.c (54%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/Makefile (94%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/checkundef.sh (100%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/um_vdso.c (100%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/vdso-layout.lds.S (100%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/vdso-note.S (100%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/vdso.S (69%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/vdso.lds.S (100%)
 rename arch/{um/sys-x86_64 => x86/um}/vdso/vma.c (96%)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOsU9RAAoJEPmeIjfg4Uaab1cP/2UdjoMG6uy55UkH+B/9xgH9
EIReqgQCQHnrHNFIJJVH/Ii+DRbqB9VdmNi0gBZnkyembgqFl4TzfKSst9lxq+4d
qj/fhWmwNJ9ryu6EkJxLNg2F3YhHIpihBYPlYIony8Paq+kdVA256uZPmyB9RsQ/
DHnKrGmk7K2m1tcWEpNgh+Mu/TxELvJxf1wwpsEpGnfIzuPQ6s6UFdegF3aeNqQw
4jyx4ECqrwCBmS75jgZlFuZtLTXwjlo4KmfFaz+hSTu6ewMkh5e4KxjARBXErZDE
+CVg4wuUe042Na+cKK8bt9IsbMuFp9OfN2ImjKulH+ur98VHkpQvtzSYJoigQvTH
b+LXArpH1jILCceqDPOYwMp0UCkjCTED9cT+2g4QpYSpvXqvhcfSTS9C7pRmqD3y
bhD1Lh8Gvz2r0SHM7Blw2WiNZPLb/eRod2N9wdArF0Fp8Y21SoQCfnlFYxsDWjK4
rDAYxFaRPd91jJSzWazlJLnkYbx6wDWvDIhAAmOYgHwlHWKuTeqkKAyCbB7HLNdp
sUHGrrMtXJXQCz/qRApkVpOOYQuc3ZhimEisoZ+h+lEJTqtHMyzXuSSrbPa/IDAG
PRzrk47/+Izv919H+YupAcqW3I/DM5VMG+bHtNSnvWCzYA2DGJiB84TKicpALvxD
CqfFLOaDTawBwtH8Qt1/
=M0EH
-----END PGP SIGNATURE-----
