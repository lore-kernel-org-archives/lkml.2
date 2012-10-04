Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2JDTvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300Ab2JDTvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:51:16 -0400
From: David Howells <dhowells@redhat.com>
To: linux@arm.linux.org.uk
Cc: dhowells@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for arm
Date: Thu, 04 Oct 2012 20:51:01 +0100
Message-ID: <17343.1349380261@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the arm tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Note that there are some fixup patches which are at the base of the branch
aimed at you, plus all arches get the asm-generic branch merged in too.

The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-arm

for you to fetch changes up to 4d192d7a0633e8eb4952996dc12af3832968e43a:

  UAPI: (Scripted) Disintegrate arch/arm/include/asm (2012-10-04 18:20:22 +0100)

----------------------------------------------------------------
David Howells (6):
      UAPI: Fix the guards on various asm/unistd.h files
      UAPI: Split compound conditionals containing __KERNEL__ in Arm64
      Merge remote-tracking branch 'c6x/for-linux-next' into uapi-prep
      UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k)
      UAPI: (Scripted) Disintegrate include/asm-generic
      UAPI: (Scripted) Disintegrate arch/arm/include/asm

Mark Salter (2):
      c6x: make dsk6455 the default config
      c6x: remove c6x signal.h

 arch/arm/include/asm/Kbuild                   |   2 -
 arch/arm/include/asm/hwcap.h                  |  27 +-
 arch/arm/include/asm/param.h                  |  17 +-
 arch/arm/include/asm/ptrace.h                 | 126 +---
 arch/arm/include/asm/setup.h                  | 172 +----
 arch/arm/include/asm/signal.h                 | 127 +---
 arch/arm/include/asm/swab.h                   |  37 +-
 arch/arm/include/asm/termios.h                |  44 +-
 arch/arm/include/asm/types.h                  |   6 +-
 arch/arm/include/asm/unistd.h                 | 433 +-----------
 arch/arm/include/uapi/asm/Kbuild              |  26 +
 arch/arm/include/{ => uapi}/asm/a.out.h       |   0
 arch/arm/include/{ => uapi}/asm/byteorder.h   |   0
 arch/arm/include/{ => uapi}/asm/fcntl.h       |   0
 arch/arm/include/uapi/asm/hwcap.h             |  29 +
 arch/arm/include/{ => uapi}/asm/ioctls.h      |   0
 arch/arm/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/arm/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/arm/include/{ => uapi}/asm/mman.h        |   0
 arch/arm/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/arm/include/uapi/asm/param.h             |  26 +
 arch/arm/include/{ => uapi}/asm/posix_types.h |   0
 arch/arm/include/uapi/asm/ptrace.h            | 137 ++++
 arch/arm/include/{ => uapi}/asm/sembuf.h      |   0
 arch/arm/include/uapi/asm/setup.h             | 187 ++++++
 arch/arm/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/arm/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/arm/include/uapi/asm/signal.h            | 127 ++++
 arch/arm/include/{ => uapi}/asm/socket.h      |   0
 arch/arm/include/{ => uapi}/asm/sockios.h     |   0
 arch/arm/include/{ => uapi}/asm/stat.h        |   0
 arch/arm/include/{ => uapi}/asm/statfs.h      |   0
 arch/arm/include/uapi/asm/swab.h              |  53 ++
 arch/arm/include/{ => uapi}/asm/termbits.h    |   0
 arch/arm/include/uapi/asm/termios.h           |  44 ++
 arch/arm/include/uapi/asm/types.h             |   1 +
 arch/arm/include/uapi/asm/unistd.h            | 445 +++++++++++++
 arch/arm64/include/asm/hwcap.h                |   4 +-
 arch/arm64/include/asm/stat.h                 |   4 +-
 arch/arm64/include/asm/unistd.h               |   8 +-
 arch/arm64/include/asm/unistd32.h             |   4 -
 arch/c6x/Makefile                             |   2 +
 arch/c6x/include/asm/Kbuild                   |   1 +
 arch/c6x/include/asm/signal.h                 |  17 -
 arch/c6x/include/asm/unistd.h                 |   4 -
 arch/hexagon/include/asm/unistd.h             |   5 -
 arch/openrisc/include/asm/unistd.h            |   5 -
 arch/score/include/asm/unistd.h               |   5 -
 arch/tile/include/asm/unistd.h                |   5 -
 arch/unicore32/include/asm/unistd.h           |   4 -
 include/asm-generic/Kbuild                    |  35 -
 include/asm-generic/bitsperlong.h             |  13 +-
 include/asm-generic/int-l64.h                 |  26 +-
 include/asm-generic/int-ll64.h                |  31 +-
 include/asm-generic/ioctl.h                   |  95 +--
 include/asm-generic/kvm_para.h                |   5 +-
 include/asm-generic/param.h                   |  17 +-
 include/asm-generic/resource.h                |  66 +-
 include/asm-generic/siginfo.h                 | 297 +--------
 include/asm-generic/signal.h                  | 117 +---
 include/asm-generic/statfs.h                  |  81 +--
 include/asm-generic/termios.h                 |  49 +-
 include/asm-generic/unistd.h                  | 911 +-------------------------
 include/linux/Kbuild                          |   9 +-
 include/uapi/asm-generic/Kbuild               |  35 +
 include/{ => uapi}/asm-generic/auxvec.h       |   0
 include/uapi/asm-generic/bitsperlong.h        |  15 +
 include/{ => uapi}/asm-generic/errno-base.h   |   0
 include/{ => uapi}/asm-generic/errno.h        |   0
 include/{ => uapi}/asm-generic/fcntl.h        |   0
 include/uapi/asm-generic/int-l64.h            |  34 +
 include/uapi/asm-generic/int-ll64.h           |  39 ++
 include/uapi/asm-generic/ioctl.h              |  98 +++
 include/{ => uapi}/asm-generic/ioctls.h       |   0
 include/{ => uapi}/asm-generic/ipcbuf.h       |   0
 include/{ => uapi}/asm-generic/mman-common.h  |   0
 include/{ => uapi}/asm-generic/mman.h         |   0
 include/{ => uapi}/asm-generic/msgbuf.h       |   0
 include/uapi/asm-generic/param.h              |  19 +
 include/{ => uapi}/asm-generic/poll.h         |   0
 include/{ => uapi}/asm-generic/posix_types.h  |   0
 include/uapi/asm-generic/resource.h           |  68 ++
 include/{ => uapi}/asm-generic/sembuf.h       |   0
 include/{ => uapi}/asm-generic/setup.h        |   0
 include/{ => uapi}/asm-generic/shmbuf.h       |   0
 include/{ => uapi}/asm-generic/shmparam.h     |   0
 include/uapi/asm-generic/siginfo.h            | 298 +++++++++
 include/{ => uapi}/asm-generic/signal-defs.h  |   0
 include/uapi/asm-generic/signal.h             | 123 ++++
 include/{ => uapi}/asm-generic/socket.h       |   0
 include/{ => uapi}/asm-generic/sockios.h      |   0
 include/{ => uapi}/asm-generic/stat.h         |   0
 include/uapi/asm-generic/statfs.h             |  83 +++
 include/{ => uapi}/asm-generic/swab.h         |   0
 include/{ => uapi}/asm-generic/termbits.h     |   0
 include/uapi/asm-generic/termios.h            |  50 ++
 include/{ => uapi}/asm-generic/types.h        |   0
 include/{ => uapi}/asm-generic/ucontext.h     |   0
 include/uapi/asm-generic/unistd.h             | 902 +++++++++++++++++++++++++
 security/apparmor/Makefile                    |   2 +-
 100 files changed, 2878 insertions(+), 2774 deletions(-)
 rename arch/arm/include/{ => uapi}/asm/a.out.h (100%)
 rename arch/arm/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/arm/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/hwcap.h
 rename arch/arm/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/arm/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/arm/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/arm/include/{ => uapi}/asm/mman.h (100%)
 rename arch/arm/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/param.h
 rename arch/arm/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/ptrace.h
 rename arch/arm/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/setup.h
 rename arch/arm/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/arm/include/{ => uapi}/asm/sigcontext.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/signal.h
 rename arch/arm/include/{ => uapi}/asm/socket.h (100%)
 rename arch/arm/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/arm/include/{ => uapi}/asm/stat.h (100%)
 rename arch/arm/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/swab.h
 rename arch/arm/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/termios.h
 create mode 100644 arch/arm/include/uapi/asm/types.h
 create mode 100644 arch/arm/include/uapi/asm/unistd.h
 delete mode 100644 arch/c6x/include/asm/signal.h
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
