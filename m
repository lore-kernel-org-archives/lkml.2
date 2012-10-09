Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2JIJSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:18:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab2JIJQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:16:03 -0400
From: David Howells <dhowells@redhat.com>
To: davem@davemloft.net
Cc: dhowells@redhat.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for sparc [ver #2]
Date: Tue, 09 Oct 2012 10:16:00 +0100
Message-ID: <21204.1349774160@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the sparc tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Now that the fixups and the asm-generic chunk have been merged, I've
regenerated the patches to get rid of those dependencies and to take account of
any changes made so far in the merge window.  If you have already pulled the
older version of the branch aimed at you, then please feel free to ignore this
request.

The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-sparc-20121009

for you to fetch changes up to 5457982641fb3f5fb08ce22a853dd5474645c66d:

  UAPI: (Scripted) Disintegrate arch/sparc/include/asm (2012-10-09 09:47:43 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/sparc/include/asm

 arch/sparc/include/asm/Kbuild                   |  16 -
 arch/sparc/include/asm/fbio.h                   | 260 +--------------
 arch/sparc/include/asm/ioctls.h                 | 129 +-------
 arch/sparc/include/asm/mman.h                   |  25 +-
 arch/sparc/include/asm/psr.h                    |  36 +-
 arch/sparc/include/asm/ptrace.h                 | 347 +------------------
 arch/sparc/include/asm/setup.h                  |  10 +-
 arch/sparc/include/asm/sigcontext.h             |   4 +-
 arch/sparc/include/asm/siginfo.h                |  23 +-
 arch/sparc/include/asm/signal.h                 | 185 +----------
 arch/sparc/include/asm/termbits.h               | 260 +--------------
 arch/sparc/include/asm/termios.h                |  41 +--
 arch/sparc/include/asm/traps.h                  | 111 +------
 arch/sparc/include/asm/unistd.h                 | 412 +----------------------
 arch/sparc/include/uapi/asm/Kbuild              |  46 +++
 arch/sparc/include/{ => uapi}/asm/apc.h         |   0
 arch/sparc/include/{ => uapi}/asm/asi.h         |   0
 arch/sparc/include/{ => uapi}/asm/auxvec.h      |   0
 arch/sparc/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/sparc/include/{ => uapi}/asm/byteorder.h   |   0
 arch/sparc/include/{ => uapi}/asm/display7seg.h |   0
 arch/sparc/include/{ => uapi}/asm/envctrl.h     |   0
 arch/sparc/include/{ => uapi}/asm/errno.h       |   0
 arch/sparc/include/uapi/asm/fbio.h              | 259 +++++++++++++++
 arch/sparc/include/{ => uapi}/asm/fcntl.h       |   0
 arch/sparc/include/{ => uapi}/asm/ioctl.h       |   0
 arch/sparc/include/uapi/asm/ioctls.h            | 131 ++++++++
 arch/sparc/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/sparc/include/{ => uapi}/asm/jsflash.h     |   0
 arch/sparc/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/sparc/include/uapi/asm/mman.h              |  27 ++
 arch/sparc/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/sparc/include/{ => uapi}/asm/openpromio.h  |   0
 arch/sparc/include/{ => uapi}/asm/param.h       |   0
 arch/sparc/include/{ => uapi}/asm/perfctr.h     |   0
 arch/sparc/include/{ => uapi}/asm/poll.h        |   0
 arch/sparc/include/{ => uapi}/asm/posix_types.h |   0
 arch/sparc/include/uapi/asm/psr.h               |  47 +++
 arch/sparc/include/{ => uapi}/asm/psrcompat.h   |   0
 arch/sparc/include/{ => uapi}/asm/pstate.h      |   0
 arch/sparc/include/uapi/asm/ptrace.h            | 352 ++++++++++++++++++++
 arch/sparc/include/{ => uapi}/asm/resource.h    |   0
 arch/sparc/include/{ => uapi}/asm/sembuf.h      |   0
 arch/sparc/include/uapi/asm/setup.h             |  15 +
 arch/sparc/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/sparc/include/uapi/asm/siginfo.h           |  25 ++
 arch/sparc/include/uapi/asm/signal.h            | 185 +++++++++++
 arch/sparc/include/{ => uapi}/asm/socket.h      |   0
 arch/sparc/include/{ => uapi}/asm/sockios.h     |   0
 arch/sparc/include/{ => uapi}/asm/stat.h        |   0
 arch/sparc/include/{ => uapi}/asm/statfs.h      |   0
 arch/sparc/include/{ => uapi}/asm/swab.h        |   0
 arch/sparc/include/uapi/asm/termbits.h          | 263 +++++++++++++++
 arch/sparc/include/uapi/asm/termios.h           |  43 +++
 arch/sparc/include/uapi/asm/traps.h             | 120 +++++++
 arch/sparc/include/{ => uapi}/asm/types.h       |   0
 arch/sparc/include/{ => uapi}/asm/uctx.h        |   0
 arch/sparc/include/uapi/asm/unistd.h            | 422 ++++++++++++++++++++++++
 arch/sparc/include/{ => uapi}/asm/utrap.h       |   0
 arch/sparc/include/{ => uapi}/asm/watchdog.h    |   0
 60 files changed, 1951 insertions(+), 1843 deletions(-)
 rename arch/sparc/include/{ => uapi}/asm/apc.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/asi.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/display7seg.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/envctrl.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/errno.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/fbio.h
 rename arch/sparc/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/ioctl.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/ioctls.h
 rename arch/sparc/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/jsflash.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/kvm_para.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/mman.h
 rename arch/sparc/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/openpromio.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/param.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/perfctr.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/poll.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/psr.h
 rename arch/sparc/include/{ => uapi}/asm/psrcompat.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/pstate.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/ptrace.h
 rename arch/sparc/include/{ => uapi}/asm/resource.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/setup.h
 rename arch/sparc/include/{ => uapi}/asm/shmbuf.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/sigcontext.h
 create mode 100644 arch/sparc/include/uapi/asm/siginfo.h
 create mode 100644 arch/sparc/include/uapi/asm/signal.h
 rename arch/sparc/include/{ => uapi}/asm/socket.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/stat.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/swab.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/termbits.h
 create mode 100644 arch/sparc/include/uapi/asm/termios.h
 create mode 100644 arch/sparc/include/uapi/asm/traps.h
 rename arch/sparc/include/{ => uapi}/asm/types.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/uctx.h (100%)
 create mode 100644 arch/sparc/include/uapi/asm/unistd.h
 rename arch/sparc/include/{ => uapi}/asm/utrap.h (100%)
 rename arch/sparc/include/{ => uapi}/asm/watchdog.h (100%)
.
