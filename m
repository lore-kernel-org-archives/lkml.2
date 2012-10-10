Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2JIW5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:57:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2JIW47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:56:59 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Oct 2012 04:25:44 +0200
From: Richard Weinberger <richard@nod.at>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>
Subject: [GIT PULL] UML changes for 3.7-rc1
Message-ID: <7368662a7657b4666ed666f4fae9fcef@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please issue the following pull request.

UML receives this time only cleanups.
The most outstanding change is the 'include "foo.h"' do 'include 
<foo.h>'
conversion done by Al Viro.
It touches many files, that's why the diffstat is rather big.

Thanks,
//richard

----
The following changes since commit 
a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git 
for-linus-37rc1

for you to fetch changes up to 
062d52672446014222942cae6934d97769b329f0:

  typo in UserModeLinux-HOWTO (2012-10-09 22:35:24 +0200)

----------------------------------------------------------------
Al Viro (4):
      um/x86: merge 32 and 64bit variants of checksum.h
      um/x86: merge 32 and 64 bit variants of ptrace.h
      um: move sysrq.h out of include/shared
      um: get rid of pointless include "..." where include <...> will 
do

Marco Stornelli (1):
      hostfs: drop vmtruncate

Richard Genoud (1):
      typo in UserModeLinux-HOWTO

Wei Yongjun (1):
      hppfs: fix the return value of get_inode()

 Documentation/virtual/uml/UserModeLinux-HOWTO.txt |   2 +-
 arch/um/drivers/chan_kern.c                       |   4 ++--
 arch/um/drivers/chan_user.c                       |   4 ++--
 arch/um/drivers/chan_user.h                       |   2 +-
 arch/um/drivers/cow_sys.h                         |   6 +++---
 arch/um/drivers/daemon.h                          |   2 +-
 arch/um/drivers/daemon_kern.c                     |   4 ++--
 arch/um/drivers/daemon_user.c                     |   6 +++---
 arch/um/drivers/fd.c                              |   4 ++--
 arch/um/drivers/harddog_user.c                    |   2 +-
 arch/um/drivers/hostaudio_kern.c                  |  18 
++++++++---------
 arch/um/drivers/line.c                            |  16 
+++++++--------
 arch/um/drivers/line.h                            |  12 ++++++------
 arch/um/drivers/mconsole.h                        |   2 +-
 arch/um/drivers/mconsole_kern.c                   |  10 +++++-----
 arch/um/drivers/mconsole_kern.h                   |   2 +-
 arch/um/drivers/mmapper_kern.c                    |   2 +-
 arch/um/drivers/net_kern.c                        |  10 +++++-----
 arch/um/drivers/net_user.c                        |   6 +++---
 arch/um/drivers/null.c                            |   2 +-
 arch/um/drivers/pcap_kern.c                       |   4 ++--
 arch/um/drivers/pcap_user.c                       |   4 ++--
 arch/um/drivers/pcap_user.h                       |   2 +-
 arch/um/drivers/port_kern.c                       |  20 
+++++++++----------
 arch/um/drivers/port_user.c                       |   4 ++--
 arch/um/drivers/pty.c                             |   4 ++--
 arch/um/drivers/random.c                          |   4 ++--
 arch/um/drivers/slip_common.c                     |   2 +-
 arch/um/drivers/slip_kern.c                       |   2 +-
 arch/um/drivers/slip_user.c                       |   6 +++---
 arch/um/drivers/slirp_kern.c                      |   6 +++---
 arch/um/drivers/slirp_user.c                      |   4 ++--
 arch/um/drivers/ssl.c                             |  22 
++++++++++-----------
 arch/um/drivers/stdio_console.c                   |  36 
+++++++++++++++++-----------------
 arch/um/drivers/tty.c                             |   4 ++--
 arch/um/drivers/ubd_kern.c                        |   8 ++++----
 arch/um/drivers/ubd_user.c                        |   2 +-
 arch/um/drivers/umcast.h                          |   2 +-
 arch/um/drivers/umcast_kern.c                     |   4 ++--
 arch/um/drivers/umcast_user.c                     |   4 ++--
 arch/um/drivers/vde_kern.c                        |   6 +++---
 arch/um/drivers/vde_user.c                        |   4 ++--
 arch/um/drivers/xterm.c                           |   4 ++--
 arch/um/drivers/xterm_kern.c                      |   4 ++--
 arch/um/include/asm/dma.h                         |   2 +-
 arch/um/include/asm/mmu.h                         |   2 +-
 arch/um/include/asm/page.h                        |   2 +-
 arch/um/include/asm/pgtable.h                     |   4 ++--
 arch/um/include/asm/processor-generic.h           |   6 +++---
 arch/um/include/asm/ptrace-generic.h              |   2 +-
 arch/um/include/asm/smp.h                         |   6 +++---
 arch/um/include/{shared => asm}/sysrq.h           |   0
 arch/um/include/shared/arch.h                     |   2 +-
 arch/um/include/shared/as-layout.h                |   2 +-
 arch/um/include/shared/irq_kern.h                 |   4 ++--
 arch/um/include/shared/irq_user.h                 |   2 +-
 arch/um/include/shared/kern_util.h                |   4 ++--
 arch/um/include/shared/longjmp.h                  |   4 ++--
 arch/um/include/shared/os.h                       |   6 +++---
 arch/um/include/shared/registers.h                |   4 ++--
 arch/um/include/shared/skas/skas.h                |   2 +-
 arch/um/include/shared/skas_ptrace.h              |   2 +-
 arch/um/kernel/asm-offsets.c                      |   2 +-
 arch/um/kernel/config.c.in                        |   2 +-
 arch/um/kernel/dyn.lds.S                          |   2 +-
 arch/um/kernel/early_printk.c                     |   2 +-
 arch/um/kernel/exec.c                             |   8 ++++----
 arch/um/kernel/gmon_syms.c                        |   2 +-
 arch/um/kernel/gprof_syms.c                       |   2 +-
 arch/um/kernel/initrd.c                           |  12 ++++++------
 arch/um/kernel/irq.c                              |  22 
++++++++++-----------
 arch/um/kernel/ksyms.c                            |   2 +-
 arch/um/kernel/mem.c                              |  12 ++++++------
 arch/um/kernel/process.c                          |   8 ++++----
 arch/um/kernel/reboot.c                           |  14 ++++++-------
 arch/um/kernel/sigio.c                            |   6 +++---
 arch/um/kernel/signal.c                           |   4 ++--
 arch/um/kernel/skas/clone.c                       |   8 ++++----
 arch/um/kernel/skas/mmu.c                         |  16 
+++++++--------
 arch/um/kernel/skas/process.c                     |  12 ++++++------
 arch/um/kernel/skas/syscall.c                     |  10 +++++-----
 arch/um/kernel/skas/uaccess.c                     |   4 ++--
 arch/um/kernel/smp.c                              |  30 
++++++++++++++--------------
 arch/um/kernel/syscall.c                          |  20 
+++++++++----------
 arch/um/kernel/sysrq.c                            |   2 +-
 arch/um/kernel/time.c                             |   4 ++--
 arch/um/kernel/tlb.c                              |   8 ++++----
 arch/um/kernel/trap.c                             |  10 +++++-----
 arch/um/kernel/um_arch.c                          |  14 ++++++-------
 arch/um/kernel/umid.c                             |   6 +++---
 arch/um/kernel/uml.lds.S                          |   2 +-
 arch/um/os-Linux/aio.c                            |   8 ++++----
 arch/um/os-Linux/drivers/etap.h                   |   2 +-
 arch/um/os-Linux/drivers/ethertap_kern.c          |   2 +-
 arch/um/os-Linux/drivers/ethertap_user.c          |   6 +++---
 arch/um/os-Linux/drivers/tuntap.h                 |   2 +-
 arch/um/os-Linux/drivers/tuntap_kern.c            |   2 +-
 arch/um/os-Linux/drivers/tuntap_user.c            |   4 ++--
 arch/um/os-Linux/elf_aux.c                        |   6 +++---
 arch/um/os-Linux/execvp.c                         |   4 ++--
 arch/um/os-Linux/file.c                           |   2 +-
 arch/um/os-Linux/helper.c                         |   6 +++---
 arch/um/os-Linux/irq.c                            |   6 +++---
 arch/um/os-Linux/main.c                           |  10 +++++-----
 arch/um/os-Linux/mem.c                            |   4 ++--
 arch/um/os-Linux/process.c                        |   8 ++++----
 arch/um/os-Linux/registers.c                      |   6 +++---
 arch/um/os-Linux/sigio.c                          |  10 +++++-----
 arch/um/os-Linux/signal.c                         |   8 ++++----
 arch/um/os-Linux/skas/mem.c                       |  20 
+++++++++----------
 arch/um/os-Linux/skas/process.c                   |  22 
++++++++++-----------
 arch/um/os-Linux/start_up.c                       |  14 ++++++-------
 arch/um/os-Linux/time.c                           |   4 ++--
 arch/um/os-Linux/tty.c                            |   4 ++--
 arch/um/os-Linux/umid.c                           |   4 ++--
 arch/um/os-Linux/user_syms.c                      |   4 ++--
 arch/um/os-Linux/util.c                           |   2 +-
 arch/um/sys-ppc/miscthings.c                      |   6 +++---
 arch/um/sys-ppc/ptrace.c                          |   2 +-
 arch/um/sys-ppc/ptrace_user.c                     |   2 +-
 arch/um/sys-ppc/shared/sysdep/ptrace.h            |   2 +-
 arch/um/sys-ppc/sigcontext.c                      |   2 +-
 arch/um/sys-ppc/sysrq.c                           |   4 ++--
 arch/x86/um/asm/checksum.h                        | 144 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/um/asm/checksum_32.h                     | 140 
----------------------------------------------------------------------------------------------------------------------------------
 arch/x86/um/asm/checksum_64.h                     | 125 
--------------------------------------------------------------------------------------------------------------------
 arch/x86/um/asm/elf.h                             |   2 +-
 arch/x86/um/asm/ptrace.h                          |  58 
++++++++++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/um/asm/ptrace_32.h                       |  28 
--------------------------
 arch/x86/um/asm/ptrace_64.h                       |  46 
-------------------------------------------
 arch/x86/um/bugs_32.c                             |   6 +++---
 arch/x86/um/bugs_64.c                             |   2 +-
 arch/x86/um/fault.c                               |   2 +-
 arch/x86/um/ldt.c                                 |  10 +++++-----
 arch/x86/um/mem_64.c                              |   6 +++---
 arch/x86/um/os-Linux/registers.c                  |   4 ++--
 arch/x86/um/os-Linux/task_size.c                  |   2 +-
 arch/x86/um/os-Linux/tls.c                        |   2 +-
 arch/x86/um/ptrace_32.c                           |   8 ++++----
 arch/x86/um/ptrace_user.c                         |   2 +-
 arch/x86/um/shared/sysdep/ptrace.h                |   2 +-
 arch/x86/um/shared/sysdep/stub.h                  |   4 ++--
 arch/x86/um/shared/sysdep/syscalls_32.h           |   4 ++--
 arch/x86/um/signal.c                              |   4 ++--
 arch/x86/um/stub_32.S                             |   2 +-
 arch/x86/um/stub_64.S                             |   2 +-
 arch/x86/um/stub_segv.c                           |   6 +++---
 arch/x86/um/sysrq_32.c                            |  12 ++++++------
 arch/x86/um/sysrq_64.c                            |   2 +-
 arch/x86/um/tls_32.c                              |  12 ++++++------
 arch/x86/um/tls_64.c                              |   2 +-
 fs/hostfs/hostfs.h                                |   2 +-
 fs/hostfs/hostfs_kern.c                           |  12 +++++++-----
 fs/hostfs/hostfs_user.c                           |   1 -
 fs/hppfs/hppfs.c                                  |   4 ++--
 155 files changed, 641 insertions(+), 785 deletions(-)
 rename arch/um/include/{shared => asm}/sysrq.h (100%)
 delete mode 100644 arch/x86/um/asm/ptrace_32.h
 delete mode 100644 arch/x86/um/asm/ptrace_64.h

