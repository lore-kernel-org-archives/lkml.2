Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2JDU3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab2JDU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:28:57 -0400
From: David Howells <dhowells@redhat.com>
To: schwidefsky@de.ibm.com
Cc: dhowells@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for s390
Date: Thu, 04 Oct 2012 20:51:44 +0100
Message-ID: <17416.1349380304@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the s390 tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Note that there are some fixup patches which are at the base of the branch
aimed at you, plus all arches get the asm-generic branch merged in too.

The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-s390

for you to fetch changes up to e06141872cc97d8b8cafc1d02d325f7e0f752ce4:

  UAPI: (Scripted) Disintegrate arch/s390/include/asm (2012-10-04 18:21:21 +0100)

----------------------------------------------------------------
David Howells (6):
      UAPI: Fix the guards on various asm/unistd.h files
      UAPI: Split compound conditionals containing __KERNEL__ in Arm64
      Merge remote-tracking branch 'c6x/for-linux-next' into uapi-prep
      UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k)
      UAPI: (Scripted) Disintegrate include/asm-generic
      UAPI: (Scripted) Disintegrate arch/s390/include/asm

Mark Salter (2):
      c6x: make dsk6455 the default config
      c6x: remove c6x signal.h

 arch/arm64/include/asm/hwcap.h                 |   4 +-
 arch/arm64/include/asm/stat.h                  |   4 +-
 arch/arm64/include/asm/unistd.h                |   8 +-
 arch/arm64/include/asm/unistd32.h              |   4 -
 arch/c6x/Makefile                              |   2 +
 arch/c6x/include/asm/Kbuild                    |   1 +
 arch/c6x/include/asm/signal.h                  |  17 -
 arch/c6x/include/asm/unistd.h                  |   4 -
 arch/hexagon/include/asm/unistd.h              |   5 -
 arch/openrisc/include/asm/unistd.h             |   5 -
 arch/s390/include/asm/Kbuild                   |  15 -
 arch/s390/include/asm/chpid.h                  |  17 +-
 arch/s390/include/asm/cmb.h                    |  51 +-
 arch/s390/include/asm/debug.h                  |  28 +-
 arch/s390/include/asm/kvm_para.h               |  14 +-
 arch/s390/include/asm/mman.h                   |   6 +-
 arch/s390/include/asm/ptrace.h                 | 462 +------------
 arch/s390/include/asm/schid.h                  |  15 +-
 arch/s390/include/asm/setup.h                  |   7 +-
 arch/s390/include/asm/signal.h                 | 128 +---
 arch/s390/include/asm/termios.h                |  42 +-
 arch/s390/include/asm/types.h                  |  15 +-
 arch/s390/include/asm/unistd.h                 | 367 +---------
 arch/s390/include/uapi/asm/Kbuild              |  45 ++
 arch/s390/include/{ => uapi}/asm/auxvec.h      |   0
 arch/s390/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/s390/include/{ => uapi}/asm/byteorder.h   |   0
 arch/s390/include/uapi/asm/chpid.h             |  22 +
 arch/s390/include/{ => uapi}/asm/chsc.h        |   0
 arch/s390/include/uapi/asm/cmb.h               |  53 ++
 arch/s390/include/{ => uapi}/asm/dasd.h        |   0
 arch/s390/include/uapi/asm/debug.h             |  34 +
 arch/s390/include/{ => uapi}/asm/errno.h       |   0
 arch/s390/include/{ => uapi}/asm/fcntl.h       |   0
 arch/s390/include/{ => uapi}/asm/ioctl.h       |   0
 arch/s390/include/{ => uapi}/asm/ioctls.h      |   0
 arch/s390/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/s390/include/{ => uapi}/asm/kvm.h         |   0
 arch/s390/include/{ => uapi}/asm/kvm_virtio.h  |   0
 arch/s390/include/uapi/asm/mman.h              |   6 +
 arch/s390/include/{ => uapi}/asm/monwriter.h   |   0
 arch/s390/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/s390/include/{ => uapi}/asm/param.h       |   0
 arch/s390/include/{ => uapi}/asm/poll.h        |   0
 arch/s390/include/{ => uapi}/asm/posix_types.h |   0
 arch/s390/include/uapi/asm/ptrace.h            | 472 +++++++++++++
 arch/s390/include/{ => uapi}/asm/qeth.h        |   0
 arch/s390/include/{ => uapi}/asm/resource.h    |   0
 arch/s390/include/uapi/asm/schid.h             |  16 +
 arch/s390/include/{ => uapi}/asm/sembuf.h      |   0
 arch/s390/include/uapi/asm/setup.h             |  13 +
 arch/s390/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/s390/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/s390/include/{ => uapi}/asm/siginfo.h     |   0
 arch/s390/include/uapi/asm/signal.h            | 135 ++++
 arch/s390/include/{ => uapi}/asm/socket.h      |   0
 arch/s390/include/{ => uapi}/asm/sockios.h     |   0
 arch/s390/include/{ => uapi}/asm/stat.h        |   0
 arch/s390/include/{ => uapi}/asm/statfs.h      |   0
 arch/s390/include/{ => uapi}/asm/swab.h        |   0
 arch/s390/include/{ => uapi}/asm/tape390.h     |   0
 arch/s390/include/{ => uapi}/asm/termbits.h    |   0
 arch/s390/include/uapi/asm/termios.h           |  49 ++
 arch/s390/include/uapi/asm/types.h             |  22 +
 arch/s390/include/{ => uapi}/asm/ucontext.h    |   0
 arch/s390/include/uapi/asm/unistd.h            | 374 ++++++++++
 arch/s390/include/{ => uapi}/asm/vtoc.h        |   0
 arch/s390/include/{ => uapi}/asm/zcrypt.h      |   0
 arch/score/include/asm/unistd.h                |   5 -
 arch/tile/include/asm/unistd.h                 |   5 -
 arch/unicore32/include/asm/unistd.h            |   4 -
 include/asm-generic/Kbuild                     |  35 -
 include/asm-generic/bitsperlong.h              |  13 +-
 include/asm-generic/int-l64.h                  |  26 +-
 include/asm-generic/int-ll64.h                 |  31 +-
 include/asm-generic/ioctl.h                    |  95 +--
 include/asm-generic/kvm_para.h                 |   5 +-
 include/asm-generic/param.h                    |  17 +-
 include/asm-generic/resource.h                 |  66 +-
 include/asm-generic/siginfo.h                  | 297 +-------
 include/asm-generic/signal.h                   | 117 +---
 include/asm-generic/statfs.h                   |  81 +--
 include/asm-generic/termios.h                  |  49 +-
 include/asm-generic/unistd.h                   | 911 +------------------------
 include/linux/Kbuild                           |   9 +-
 include/uapi/asm-generic/Kbuild                |  35 +
 include/{ => uapi}/asm-generic/auxvec.h        |   0
 include/uapi/asm-generic/bitsperlong.h         |  15 +
 include/{ => uapi}/asm-generic/errno-base.h    |   0
 include/{ => uapi}/asm-generic/errno.h         |   0
 include/{ => uapi}/asm-generic/fcntl.h         |   0
 include/uapi/asm-generic/int-l64.h             |  34 +
 include/uapi/asm-generic/int-ll64.h            |  39 ++
 include/uapi/asm-generic/ioctl.h               |  98 +++
 include/{ => uapi}/asm-generic/ioctls.h        |   0
 include/{ => uapi}/asm-generic/ipcbuf.h        |   0
 include/{ => uapi}/asm-generic/mman-common.h   |   0
 include/{ => uapi}/asm-generic/mman.h          |   0
 include/{ => uapi}/asm-generic/msgbuf.h        |   0
 include/uapi/asm-generic/param.h               |  19 +
 include/{ => uapi}/asm-generic/poll.h          |   0
 include/{ => uapi}/asm-generic/posix_types.h   |   0
 include/uapi/asm-generic/resource.h            |  68 ++
 include/{ => uapi}/asm-generic/sembuf.h        |   0
 include/{ => uapi}/asm-generic/setup.h         |   0
 include/{ => uapi}/asm-generic/shmbuf.h        |   0
 include/{ => uapi}/asm-generic/shmparam.h      |   0
 include/uapi/asm-generic/siginfo.h             | 298 ++++++++
 include/{ => uapi}/asm-generic/signal-defs.h   |   0
 include/uapi/asm-generic/signal.h              | 123 ++++
 include/{ => uapi}/asm-generic/socket.h        |   0
 include/{ => uapi}/asm-generic/sockios.h       |   0
 include/{ => uapi}/asm-generic/stat.h          |   0
 include/uapi/asm-generic/statfs.h              |  83 +++
 include/{ => uapi}/asm-generic/swab.h          |   0
 include/{ => uapi}/asm-generic/termbits.h      |   0
 include/uapi/asm-generic/termios.h             |  50 ++
 include/{ => uapi}/asm-generic/types.h         |   0
 include/{ => uapi}/asm-generic/ucontext.h      |   0
 include/uapi/asm-generic/unistd.h              | 902 ++++++++++++++++++++++++
 security/apparmor/Makefile                     |   2 +-
 121 files changed, 3051 insertions(+), 2943 deletions(-)
 delete mode 100644 arch/c6x/include/asm/signal.h
 rename arch/s390/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/s390/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/s390/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/chpid.h
 rename arch/s390/include/{ => uapi}/asm/chsc.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/cmb.h
 rename arch/s390/include/{ => uapi}/asm/dasd.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/debug.h
 rename arch/s390/include/{ => uapi}/asm/errno.h (100%)
 rename arch/s390/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/s390/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/s390/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/s390/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/s390/include/{ => uapi}/asm/kvm.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/kvm_para.h
 rename arch/s390/include/{ => uapi}/asm/kvm_virtio.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/mman.h
 rename arch/s390/include/{ => uapi}/asm/monwriter.h (100%)
 rename arch/s390/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/s390/include/{ => uapi}/asm/param.h (100%)
 rename arch/s390/include/{ => uapi}/asm/poll.h (100%)
 rename arch/s390/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/ptrace.h
 rename arch/s390/include/{ => uapi}/asm/qeth.h (100%)
 rename arch/s390/include/{ => uapi}/asm/resource.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/schid.h
 rename arch/s390/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/setup.h
 rename arch/s390/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/s390/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/s390/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/signal.h
 rename arch/s390/include/{ => uapi}/asm/socket.h (100%)
 rename arch/s390/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/s390/include/{ => uapi}/asm/stat.h (100%)
 rename arch/s390/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/s390/include/{ => uapi}/asm/swab.h (100%)
 rename arch/s390/include/{ => uapi}/asm/tape390.h (100%)
 rename arch/s390/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/termios.h
 create mode 100644 arch/s390/include/uapi/asm/types.h
 rename arch/s390/include/{ => uapi}/asm/ucontext.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/unistd.h
 rename arch/s390/include/{ => uapi}/asm/vtoc.h (100%)
 rename arch/s390/include/{ => uapi}/asm/zcrypt.h (100%)
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
