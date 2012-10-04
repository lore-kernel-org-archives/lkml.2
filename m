Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab2JDTx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab2JDTvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:51:49 -0400
From: David Howells <dhowells@redhat.com>
To: benh@kernel.crashing.org
Cc: dhowells@redhat.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for powerpc
Date: Thu, 04 Oct 2012 20:51:41 +0100
Message-ID: <17407.1349380301@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the powerpc tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Note that there are some fixup patches which are at the base of the branch
aimed at you, plus all arches get the asm-generic branch merged in too.

The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-powerpc

for you to fetch changes up to d4b1059feb6486ae0800e936b9dd5fd4e05b9d0c:

  UAPI: (Scripted) Disintegrate arch/powerpc/include/asm (2012-10-04 18:21:17 +0100)

----------------------------------------------------------------
David Howells (6):
      UAPI: Fix the guards on various asm/unistd.h files
      UAPI: Split compound conditionals containing __KERNEL__ in Arm64
      Merge remote-tracking branch 'c6x/for-linux-next' into uapi-prep
      UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k)
      UAPI: (Scripted) Disintegrate include/asm-generic
      UAPI: (Scripted) Disintegrate arch/powerpc/include/asm

Mark Salter (2):
      c6x: make dsk6455 the default config
      c6x: remove c6x signal.h

 arch/arm64/include/asm/hwcap.h                    |   4 +-
 arch/arm64/include/asm/stat.h                     |   4 +-
 arch/arm64/include/asm/unistd.h                   |   8 +-
 arch/arm64/include/asm/unistd32.h                 |   4 -
 arch/c6x/Makefile                                 |   2 +
 arch/c6x/include/asm/Kbuild                       |   1 +
 arch/c6x/include/asm/signal.h                     |  17 -
 arch/c6x/include/asm/unistd.h                     |   4 -
 arch/hexagon/include/asm/unistd.h                 |   5 -
 arch/openrisc/include/asm/unistd.h                |   5 -
 arch/powerpc/include/asm/Kbuild                   |  35 -
 arch/powerpc/include/asm/bootx.h                  | 123 +--
 arch/powerpc/include/asm/cputable.h               |  35 +-
 arch/powerpc/include/asm/elf.h                    | 311 +-------
 arch/powerpc/include/asm/kvm_para.h               |  70 +-
 arch/powerpc/include/asm/mman.h                   |  27 +-
 arch/powerpc/include/asm/nvram.h                  |  55 +-
 arch/powerpc/include/asm/ptrace.h                 | 242 +-----
 arch/powerpc/include/asm/signal.h                 | 143 +---
 arch/powerpc/include/asm/spu_info.h               |  29 +-
 arch/powerpc/include/asm/swab.h                   |  15 +-
 arch/powerpc/include/asm/termios.h                |  69 +-
 arch/powerpc/include/asm/types.h                  |  30 +-
 arch/powerpc/include/asm/unistd.h                 | 374 +--------
 arch/powerpc/include/uapi/asm/Kbuild              |  41 +
 arch/powerpc/include/{ => uapi}/asm/auxvec.h      |   0
 arch/powerpc/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/powerpc/include/uapi/asm/bootx.h             | 132 ++++
 arch/powerpc/include/{ => uapi}/asm/byteorder.h   |   0
 arch/powerpc/include/uapi/asm/cputable.h          |  36 +
 arch/powerpc/include/uapi/asm/elf.h               | 307 ++++++++
 arch/powerpc/include/{ => uapi}/asm/errno.h       |   0
 arch/powerpc/include/{ => uapi}/asm/fcntl.h       |   0
 arch/powerpc/include/{ => uapi}/asm/ioctl.h       |   0
 arch/powerpc/include/{ => uapi}/asm/ioctls.h      |   0
 arch/powerpc/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/powerpc/include/{ => uapi}/asm/kvm.h         |   0
 arch/powerpc/include/uapi/asm/kvm_para.h          |  90 +++
 arch/powerpc/include/{ => uapi}/asm/linkage.h     |   0
 arch/powerpc/include/uapi/asm/mman.h              |  31 +
 arch/powerpc/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/powerpc/include/uapi/asm/nvram.h             |  62 ++
 arch/powerpc/include/{ => uapi}/asm/param.h       |   0
 arch/powerpc/include/{ => uapi}/asm/poll.h        |   0
 arch/powerpc/include/{ => uapi}/asm/posix_types.h |   0
 arch/powerpc/include/{ => uapi}/asm/ps3fb.h       |   0
 arch/powerpc/include/uapi/asm/ptrace.h            | 259 ++++++
 arch/powerpc/include/{ => uapi}/asm/resource.h    |   0
 arch/powerpc/include/{ => uapi}/asm/seccomp.h     |   0
 arch/powerpc/include/{ => uapi}/asm/sembuf.h      |   0
 arch/powerpc/include/{ => uapi}/asm/setup.h       |   0
 arch/powerpc/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/powerpc/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/powerpc/include/{ => uapi}/asm/siginfo.h     |   0
 arch/powerpc/include/uapi/asm/signal.h            | 145 ++++
 arch/powerpc/include/{ => uapi}/asm/socket.h      |   0
 arch/powerpc/include/{ => uapi}/asm/sockios.h     |   0
 arch/powerpc/include/uapi/asm/spu_info.h          |  53 ++
 arch/powerpc/include/{ => uapi}/asm/stat.h        |   0
 arch/powerpc/include/{ => uapi}/asm/statfs.h      |   0
 arch/powerpc/include/uapi/asm/swab.h              |  23 +
 arch/powerpc/include/{ => uapi}/asm/termbits.h    |   0
 arch/powerpc/include/uapi/asm/termios.h           |  76 ++
 arch/powerpc/include/uapi/asm/types.h             |  40 +
 arch/powerpc/include/{ => uapi}/asm/ucontext.h    |   0
 arch/powerpc/include/uapi/asm/unistd.h            | 380 +++++++++
 arch/score/include/asm/unistd.h                   |   5 -
 arch/tile/include/asm/unistd.h                    |   5 -
 arch/unicore32/include/asm/unistd.h               |   4 -
 include/asm-generic/Kbuild                        |  35 -
 include/asm-generic/bitsperlong.h                 |  13 +-
 include/asm-generic/int-l64.h                     |  26 +-
 include/asm-generic/int-ll64.h                    |  31 +-
 include/asm-generic/ioctl.h                       |  95 +--
 include/asm-generic/kvm_para.h                    |   5 +-
 include/asm-generic/param.h                       |  17 +-
 include/asm-generic/resource.h                    |  66 +-
 include/asm-generic/siginfo.h                     | 297 +------
 include/asm-generic/signal.h                      | 117 +--
 include/asm-generic/statfs.h                      |  81 +-
 include/asm-generic/termios.h                     |  49 +-
 include/asm-generic/unistd.h                      | 911 +---------------------
 include/linux/Kbuild                              |   9 +-
 include/uapi/asm-generic/Kbuild                   |  35 +
 include/{ => uapi}/asm-generic/auxvec.h           |   0
 include/uapi/asm-generic/bitsperlong.h            |  15 +
 include/{ => uapi}/asm-generic/errno-base.h       |   0
 include/{ => uapi}/asm-generic/errno.h            |   0
 include/{ => uapi}/asm-generic/fcntl.h            |   0
 include/uapi/asm-generic/int-l64.h                |  34 +
 include/uapi/asm-generic/int-ll64.h               |  39 +
 include/uapi/asm-generic/ioctl.h                  |  98 +++
 include/{ => uapi}/asm-generic/ioctls.h           |   0
 include/{ => uapi}/asm-generic/ipcbuf.h           |   0
 include/{ => uapi}/asm-generic/mman-common.h      |   0
 include/{ => uapi}/asm-generic/mman.h             |   0
 include/{ => uapi}/asm-generic/msgbuf.h           |   0
 include/uapi/asm-generic/param.h                  |  19 +
 include/{ => uapi}/asm-generic/poll.h             |   0
 include/{ => uapi}/asm-generic/posix_types.h      |   0
 include/uapi/asm-generic/resource.h               |  68 ++
 include/{ => uapi}/asm-generic/sembuf.h           |   0
 include/{ => uapi}/asm-generic/setup.h            |   0
 include/{ => uapi}/asm-generic/shmbuf.h           |   0
 include/{ => uapi}/asm-generic/shmparam.h         |   0
 include/uapi/asm-generic/siginfo.h                | 298 +++++++
 include/{ => uapi}/asm-generic/signal-defs.h      |   0
 include/uapi/asm-generic/signal.h                 | 123 +++
 include/{ => uapi}/asm-generic/socket.h           |   0
 include/{ => uapi}/asm-generic/sockios.h          |   0
 include/{ => uapi}/asm-generic/stat.h             |   0
 include/uapi/asm-generic/statfs.h                 |  83 ++
 include/{ => uapi}/asm-generic/swab.h             |   0
 include/{ => uapi}/asm-generic/termbits.h         |   0
 include/uapi/asm-generic/termios.h                |  50 ++
 include/{ => uapi}/asm-generic/types.h            |   0
 include/{ => uapi}/asm-generic/ucontext.h         |   0
 include/uapi/asm-generic/unistd.h                 | 902 +++++++++++++++++++++
 security/apparmor/Makefile                        |   2 +-
 119 files changed, 3498 insertions(+), 3321 deletions(-)
 delete mode 100644 arch/c6x/include/asm/signal.h
 rename arch/powerpc/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/bitsperlong.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/bootx.h
 rename arch/powerpc/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/cputable.h
 create mode 100644 arch/powerpc/include/uapi/asm/elf.h
 rename arch/powerpc/include/{ => uapi}/asm/errno.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/kvm.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/kvm_para.h
 rename arch/powerpc/include/{ => uapi}/asm/linkage.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/mman.h
 rename arch/powerpc/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/nvram.h
 rename arch/powerpc/include/{ => uapi}/asm/param.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/poll.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/posix_types.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/ps3fb.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/ptrace.h
 rename arch/powerpc/include/{ => uapi}/asm/resource.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/seccomp.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/setup.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/signal.h
 rename arch/powerpc/include/{ => uapi}/asm/socket.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/sockios.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/spu_info.h
 rename arch/powerpc/include/{ => uapi}/asm/stat.h (100%)
 rename arch/powerpc/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/swab.h
 rename arch/powerpc/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/termios.h
 create mode 100644 arch/powerpc/include/uapi/asm/types.h
 rename arch/powerpc/include/{ => uapi}/asm/ucontext.h (100%)
 create mode 100644 arch/powerpc/include/uapi/asm/unistd.h
 rename include/{ => uapi}/asm-generic/auxvec.h (100%)
 create mode 100644 include/uapi/asm-generic/bitsperlong.h
 rename include/{ => uapi}/asm-generic/errno-base.h (100%)
 rename include/{ => uapi}/asm-generic/errno.h (100%)
 rename include/{ => uapi}/asm-generic/fcntl.h (100%)
 create mode 100644 include/uapi/asm-generic/int-l64.h
 create mode 100644 include/uapi/asm-generic/int-ll64.h
 create mode 100644 include/uapi/asm-generic/ioctl.h
 rename include/{ => uapi}/asm-generic/ioctls.h (100%)
 rename include/{ => uapi}/asm-generic/ipcbuf.h (100%)
 create mode 100644 include/uapi/asm-generic/kvm_para.h
 rename include/{ => uapi}/asm-generic/mman-common.h (100%)
 rename include/{ => uapi}/asm-generic/mman.h (100%)
 rename include/{ => uapi}/asm-generic/msgbuf.h (100%)
 create mode 100644 include/uapi/asm-generic/param.h
 rename include/{ => uapi}/asm-generic/poll.h (100%)
 rename include/{ => uapi}/asm-generic/posix_types.h (100%)
 create mode 100644 include/uapi/asm-generic/resource.h
 rename include/{ => uapi}/asm-generic/sembuf.h (100%)
 rename include/{ => uapi}/asm-generic/setup.h (100%)
 rename include/{ => uapi}/asm-generic/shmbuf.h (100%)
 rename include/{ => uapi}/asm-generic/shmparam.h (100%)
 create mode 100644 include/uapi/asm-generic/siginfo.h
 rename include/{ => uapi}/asm-generic/signal-defs.h (100%)
 create mode 100644 include/uapi/asm-generic/signal.h
 rename include/{ => uapi}/asm-generic/socket.h (100%)
 rename include/{ => uapi}/asm-generic/sockios.h (100%)
 rename include/{ => uapi}/asm-generic/stat.h (100%)
 create mode 100644 include/uapi/asm-generic/statfs.h
 rename include/{ => uapi}/asm-generic/swab.h (100%)
 rename include/{ => uapi}/asm-generic/termbits.h (100%)
 create mode 100644 include/uapi/asm-generic/termios.h
 rename include/{ => uapi}/asm-generic/types.h (100%)
 rename include/{ => uapi}/asm-generic/ucontext.h (100%)
 create mode 100644 include/uapi/asm-generic/unistd.h
.
