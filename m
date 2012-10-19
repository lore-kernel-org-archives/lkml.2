Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2JSSxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:53:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45946 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2JSSxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:53:09 -0400
Message-ID: <5081A192.9030009@zankel.net>
Date: Fri, 19 Oct 2012 11:53:06 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] xtensa patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the changes from the Xtensa repository. They are 
all limited to the xtensa subtree and include some important changes 
(adding long missing system calls for newer libc versions and other 
fixes) and the UAPI changes.

Thanks,
-Chris


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

   Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

   https://github.com/czankel/xtensa-linux.git tags/xtensa-next-20121018

for you to fetch changes up to 7216cabfff5149670445cd65d415ed5db21314b4:

   xtensa: add missing system calls to the syscall table (2012-10-19 
10:46:44 -0700)

----------------------------------------------------------------
Xtensa patchset for 3.7-rc2

----------------------------------------------------------------
Chris Zankel (3):
       xtensa: fix memmove(), bcopy(), and memcpy().
       xtensa: minor compiler warning fix
       xtensa: add missing system calls to the syscall table

David Howells (1):
       UAPI: (Scripted) Disintegrate arch/xtensa/include/asm

Marc Gauthier (2):
       xtensa: copy_thread with CLONE_VM must not copy live parent AR 
windows
       xtensa: fix missing return in do_page_fault for SIGBUS case

Max Filippov (6):
       xtensa: ISS: fix specific simcalls
       xtensa: ISS: fix rs_put_char
       xtensa: fix boot parameters parsing
       xtensa: reorganize SR referencing
       xtensa: fix unaligned usermode access
       xtensa: Use Kbuild infrastructure to handle asm-generic headers

  arch/xtensa/boot/boot-redboot/bootstrap.S          |    8 +-
  arch/xtensa/include/asm/Kbuild                     |   28 +-
  arch/xtensa/include/asm/atomic.h                   |   12 +-
  arch/xtensa/include/asm/bitsperlong.h              |    1 -
  arch/xtensa/include/asm/bug.h                      |   18 -
  arch/xtensa/include/asm/cacheflush.h               |    2 +-
  arch/xtensa/include/asm/cmpxchg.h                  |    4 +-
  arch/xtensa/include/asm/coprocessor.h              |    5 +-
  arch/xtensa/include/asm/cputime.h                  |    6 -
  arch/xtensa/include/asm/delay.h                    |    2 +-
  arch/xtensa/include/asm/device.h                   |    7 -
  arch/xtensa/include/asm/div64.h                    |   16 -
  arch/xtensa/include/asm/emergency-restart.h        |    6 -
  arch/xtensa/include/asm/errno.h                    |   16 -
  arch/xtensa/include/asm/fcntl.h                    |    1 -
  arch/xtensa/include/asm/futex.h                    |    1 -
  arch/xtensa/include/asm/hardirq.h                  |   16 -
  arch/xtensa/include/asm/ioctl.h                    |    1 -
  arch/xtensa/include/asm/irq_regs.h                 |    1 -
  arch/xtensa/include/asm/irqflags.h                 |    4 +-
  arch/xtensa/include/asm/kdebug.h                   |    1 -
  arch/xtensa/include/asm/kmap_types.h               |    6 -
  arch/xtensa/include/asm/kvm_para.h                 |    1 -
  arch/xtensa/include/asm/local.h                    |   16 -
  arch/xtensa/include/asm/local64.h                  |    1 -
  arch/xtensa/include/asm/mmu_context.h              |    4 +-
  arch/xtensa/include/asm/param.h                    |   20 +-
  arch/xtensa/include/asm/percpu.h                   |   16 -
  arch/xtensa/include/asm/ptrace.h                   |   66 +-
  arch/xtensa/include/asm/regs.h                     |   55 +-
  arch/xtensa/include/asm/resource.h                 |   16 -
  arch/xtensa/include/asm/scatterlist.h              |   16 -
  arch/xtensa/include/asm/sections.h                 |   16 -
  arch/xtensa/include/asm/siginfo.h                  |   16 -
  arch/xtensa/include/asm/signal.h                   |  134 +---
  arch/xtensa/include/asm/statfs.h                   |   17 -
  arch/xtensa/include/asm/termios.h                  |  105 ---
  arch/xtensa/include/asm/timex.h                    |    8 +-
  arch/xtensa/include/asm/tlbflush.h                 |    8 +-
  arch/xtensa/include/asm/topology.h                 |   16 -
  arch/xtensa/include/asm/types.h                    |   15 +-
  arch/xtensa/include/asm/unistd.h                   |  702 
+-----------------
  arch/xtensa/include/asm/xor.h                      |   16 -
  arch/xtensa/include/uapi/asm/Kbuild                |   22 +
  arch/xtensa/include/{ => uapi}/asm/auxvec.h        |    0
  arch/xtensa/include/{ => uapi}/asm/byteorder.h     |    0
  arch/xtensa/include/{ => uapi}/asm/ioctls.h        |    0
  arch/xtensa/include/{ => uapi}/asm/ipcbuf.h        |    0
  arch/xtensa/include/{ => uapi}/asm/mman.h          |    0
  arch/xtensa/include/{ => uapi}/asm/msgbuf.h        |    0
  arch/xtensa/include/uapi/asm/param.h               |   30 +
  arch/xtensa/include/{ => uapi}/asm/poll.h          |    0
  arch/xtensa/include/{ => uapi}/asm/posix_types.h   |    0
  arch/xtensa/include/uapi/asm/ptrace.h              |   77 ++
  arch/xtensa/include/{ => uapi}/asm/sembuf.h        |    0
  arch/xtensa/include/{ => uapi}/asm/setup.h         |    0
  arch/xtensa/include/{ => uapi}/asm/shmbuf.h        |    0
  arch/xtensa/include/{ => uapi}/asm/sigcontext.h    |    0
  arch/xtensa/include/uapi/asm/signal.h              |  148 ++++
  arch/xtensa/include/{ => uapi}/asm/socket.h        |    0
  arch/xtensa/include/{ => uapi}/asm/sockios.h       |    0
  arch/xtensa/include/{ => uapi}/asm/stat.h          |    0
  arch/xtensa/include/{ => uapi}/asm/swab.h          |    0
  arch/xtensa/include/{ => uapi}/asm/termbits.h      |    0
  arch/xtensa/include/uapi/asm/types.h               |   28 +
  arch/xtensa/include/uapi/asm/unistd.h              |  762 
++++++++++++++++++++
  arch/xtensa/kernel/align.S                         |   38 +-
  arch/xtensa/kernel/coprocessor.S                   |   20 +-
  arch/xtensa/kernel/entry.S                         |  254 +++----
  arch/xtensa/kernel/head.S                          |   36 +-
  arch/xtensa/kernel/irq.c                           |    6 +-
  arch/xtensa/kernel/process.c                       |   29 +-
  arch/xtensa/kernel/setup.c                         |    4 +-
  arch/xtensa/kernel/syscall.c                       |    1 -
  arch/xtensa/kernel/traps.c                         |   22 +-
  arch/xtensa/kernel/vectors.S                       |   44 +-
  arch/xtensa/lib/memcopy.S                          |  309 +++++++-
  arch/xtensa/mm/fault.c                             |    3 +-
  arch/xtensa/platforms/iss/console.c                |    9 +-
  .../platforms/iss/include/platform/simcall.h       |    9 +-
  arch/xtensa/platforms/iss/setup.c                  |   10 +-
  arch/xtensa/platforms/xt2000/setup.c               |   10 +-
  82 files changed, 1677 insertions(+), 1620 deletions(-)
  delete mode 100644 arch/xtensa/include/asm/bitsperlong.h
  delete mode 100644 arch/xtensa/include/asm/bug.h
  delete mode 100644 arch/xtensa/include/asm/cputime.h
  delete mode 100644 arch/xtensa/include/asm/device.h
  delete mode 100644 arch/xtensa/include/asm/div64.h
  delete mode 100644 arch/xtensa/include/asm/emergency-restart.h
  delete mode 100644 arch/xtensa/include/asm/errno.h
  delete mode 100644 arch/xtensa/include/asm/fcntl.h
  delete mode 100644 arch/xtensa/include/asm/futex.h
  delete mode 100644 arch/xtensa/include/asm/hardirq.h
  delete mode 100644 arch/xtensa/include/asm/ioctl.h
  delete mode 100644 arch/xtensa/include/asm/irq_regs.h
  delete mode 100644 arch/xtensa/include/asm/kdebug.h
  delete mode 100644 arch/xtensa/include/asm/kmap_types.h
  delete mode 100644 arch/xtensa/include/asm/kvm_para.h
  delete mode 100644 arch/xtensa/include/asm/local.h
  delete mode 100644 arch/xtensa/include/asm/local64.h
  delete mode 100644 arch/xtensa/include/asm/percpu.h
  delete mode 100644 arch/xtensa/include/asm/resource.h
  delete mode 100644 arch/xtensa/include/asm/scatterlist.h
  delete mode 100644 arch/xtensa/include/asm/sections.h
  delete mode 100644 arch/xtensa/include/asm/siginfo.h
  delete mode 100644 arch/xtensa/include/asm/statfs.h
  delete mode 100644 arch/xtensa/include/asm/termios.h
  delete mode 100644 arch/xtensa/include/asm/topology.h
  delete mode 100644 arch/xtensa/include/asm/xor.h
  rename arch/xtensa/include/{ => uapi}/asm/auxvec.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/byteorder.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/ioctls.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/ipcbuf.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/mman.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/msgbuf.h (100%)
  create mode 100644 arch/xtensa/include/uapi/asm/param.h
  rename arch/xtensa/include/{ => uapi}/asm/poll.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/posix_types.h (100%)
  create mode 100644 arch/xtensa/include/uapi/asm/ptrace.h
  rename arch/xtensa/include/{ => uapi}/asm/sembuf.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/setup.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/shmbuf.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/sigcontext.h (100%)
  create mode 100644 arch/xtensa/include/uapi/asm/signal.h
  rename arch/xtensa/include/{ => uapi}/asm/socket.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/sockios.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/stat.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/swab.h (100%)
  rename arch/xtensa/include/{ => uapi}/asm/termbits.h (100%)
  create mode 100644 arch/xtensa/include/uapi/asm/types.h
  create mode 100644 arch/xtensa/include/uapi/asm/unistd.h

