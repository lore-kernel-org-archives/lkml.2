Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2JIJQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:16:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab2JIJP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:57 -0400
From: David Howells <dhowells@redhat.com>
To: schwidefsky@de.ibm.com
Cc: dhowells@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for s390 [ver #2]
Date: Tue, 09 Oct 2012 10:15:52 +0100
Message-ID: <21182.1349774152@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the s390 tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-s390-20121009

for you to fetch changes up to 9807f75955ea7f1877981056755284481873115c:

  UAPI: (Scripted) Disintegrate arch/s390/include/asm (2012-10-09 09:47:31 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/s390/include/asm

 arch/s390/include/asm/Kbuild                   |  14 -
 arch/s390/include/asm/chpid.h                  |  17 +-
 arch/s390/include/asm/cmb.h                    |  51 +--
 arch/s390/include/asm/debug.h                  |  28 +-
 arch/s390/include/asm/kvm_para.h               |  14 +-
 arch/s390/include/asm/mman.h                   |   6 +-
 arch/s390/include/asm/ptrace.h                 | 462 +-----------------------
 arch/s390/include/asm/schid.h                  |  15 +-
 arch/s390/include/asm/setup.h                  |   7 +-
 arch/s390/include/asm/signal.h                 | 128 +------
 arch/s390/include/asm/termios.h                |  42 +--
 arch/s390/include/asm/types.h                  |  15 +-
 arch/s390/include/asm/unistd.h                 | 367 +------------------
 arch/s390/include/uapi/asm/Kbuild              |  45 +++
 arch/s390/include/{ => uapi}/asm/auxvec.h      |   0
 arch/s390/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/s390/include/{ => uapi}/asm/byteorder.h   |   0
 arch/s390/include/uapi/asm/chpid.h             |  22 ++
 arch/s390/include/{ => uapi}/asm/chsc.h        |   0
 arch/s390/include/uapi/asm/cmb.h               |  53 +++
 arch/s390/include/{ => uapi}/asm/dasd.h        |   0
 arch/s390/include/uapi/asm/debug.h             |  34 ++
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
 arch/s390/include/uapi/asm/ptrace.h            | 472 +++++++++++++++++++++++++
 arch/s390/include/{ => uapi}/asm/qeth.h        |   0
 arch/s390/include/{ => uapi}/asm/resource.h    |   0
 arch/s390/include/uapi/asm/schid.h             |  16 +
 arch/s390/include/{ => uapi}/asm/sembuf.h      |   0
 arch/s390/include/uapi/asm/setup.h             |  13 +
 arch/s390/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/s390/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/s390/include/{ => uapi}/asm/siginfo.h     |   0
 arch/s390/include/uapi/asm/signal.h            | 135 +++++++
 arch/s390/include/{ => uapi}/asm/socket.h      |   0
 arch/s390/include/{ => uapi}/asm/sockios.h     |   0
 arch/s390/include/{ => uapi}/asm/stat.h        |   0
 arch/s390/include/{ => uapi}/asm/statfs.h      |   0
 arch/s390/include/{ => uapi}/asm/swab.h        |   0
 arch/s390/include/{ => uapi}/asm/tape390.h     |   0
 arch/s390/include/{ => uapi}/asm/termbits.h    |   0
 arch/s390/include/uapi/asm/termios.h           |  49 +++
 arch/s390/include/uapi/asm/types.h             |  22 ++
 arch/s390/include/{ => uapi}/asm/ucontext.h    |   0
 arch/s390/include/uapi/asm/unistd.h            | 374 ++++++++++++++++++++
 arch/s390/include/{ => uapi}/asm/vtoc.h        |   0
 arch/s390/include/{ => uapi}/asm/zcrypt.h      |   0
 58 files changed, 1258 insertions(+), 1149 deletions(-)
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
.
