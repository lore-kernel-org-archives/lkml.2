Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab2JSR2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:28:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45813 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758370Ab2JSR2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:28:03 -0400
Message-ID: <1350667679.2511.4.camel@dabdike>
Subject: [GIT PULL] parisc high code motion changes for 3.7-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 19 Oct 2012 10:27:59 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a couple of high code motion patches (all within arch/parisc)
I'd like to apply at -rc1 to avoid conflicts with anything else.  One
moves us on to the generated instead of included asm file model and the
other is a pull request from David Howells for UAPI disintegration.

The patches are here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git parisc-for-linus

The short changelog is:

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/parisc/include/asm

James Bottomley (1):
      asm: redo generic includes

The diffstat is:

 arch/parisc/include/asm/Kbuild                   |   9 +-
 arch/parisc/include/asm/auxvec.h                 |   4 -
 arch/parisc/include/asm/compat_signal.h          |   2 -
 arch/parisc/include/asm/cputime.h                |   6 -
 arch/parisc/include/asm/device.h                 |   7 -
 arch/parisc/include/asm/div64.h                  |   1 -
 arch/parisc/include/asm/emergency-restart.h      |   6 -
 arch/parisc/include/asm/hw_irq.h                 |   8 -
 arch/parisc/include/asm/irq_regs.h               |   1 -
 arch/parisc/include/asm/kdebug.h                 |   1 -
 arch/parisc/include/asm/kvm_para.h               |   1 -
 arch/parisc/include/asm/local.h                  |   1 -
 arch/parisc/include/asm/local64.h                |   1 -
 arch/parisc/include/asm/mutex.h                  |   9 -
 arch/parisc/include/asm/param.h                  |   1 -
 arch/parisc/include/asm/pdc.h                    | 423 +-----------
 arch/parisc/include/asm/percpu.h                 |   7 -
 arch/parisc/include/asm/poll.h                   |   1 -
 arch/parisc/include/asm/ptrace.h                 |  46 +-
 arch/parisc/include/asm/real.h                   |   5 -
 arch/parisc/include/asm/segment.h                |   6 -
 arch/parisc/include/asm/signal.h                 | 113 +--
 arch/parisc/include/asm/termios.h                |  41 +-
 arch/parisc/include/asm/topology.h               |   6 -
 arch/parisc/include/asm/unistd.h                 | 835 +---------------------
 arch/parisc/include/asm/user.h                   |   5 -
 arch/parisc/include/asm/vga.h                    |   6 -
 arch/parisc/include/asm/xor.h                    |   1 -
 arch/parisc/include/uapi/asm/Kbuild              |  28 +
 arch/parisc/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/parisc/include/{ => uapi}/asm/byteorder.h   |   0
 arch/parisc/include/{ => uapi}/asm/errno.h       |   0
 arch/parisc/include/{ => uapi}/asm/fcntl.h       |   0
 arch/parisc/include/{ => uapi}/asm/ioctl.h       |   0
 arch/parisc/include/{ => uapi}/asm/ioctls.h      |   0
 arch/parisc/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/mman.h        |   0
 arch/parisc/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/parisc/include/uapi/asm/pdc.h               | 427 ++++++++++++
 arch/parisc/include/{ => uapi}/asm/posix_types.h |   0
 arch/parisc/include/uapi/asm/ptrace.h            |  47 ++
 arch/parisc/include/{ => uapi}/asm/resource.h    |   0
 arch/parisc/include/{ => uapi}/asm/sembuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/setup.h       |   0
 arch/parisc/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/parisc/include/{ => uapi}/asm/siginfo.h     |   0
 arch/parisc/include/uapi/asm/signal.h            | 118 ++++
 arch/parisc/include/{ => uapi}/asm/socket.h      |   0
 arch/parisc/include/{ => uapi}/asm/sockios.h     |   0
 arch/parisc/include/{ => uapi}/asm/stat.h        |   0
 arch/parisc/include/{ => uapi}/asm/statfs.h      |   0
 arch/parisc/include/{ => uapi}/asm/swab.h        |   0
 arch/parisc/include/{ => uapi}/asm/termbits.h    |   0
 arch/parisc/include/uapi/asm/termios.h           |  43 ++
 arch/parisc/include/{ => uapi}/asm/types.h       |   0
 arch/parisc/include/uapi/asm/unistd.h            | 837 +++++++++++++++++++++++
 57 files changed, 1511 insertions(+), 1542 deletions(-)
 delete mode 100644 arch/parisc/include/asm/auxvec.h
 delete mode 100644 arch/parisc/include/asm/compat_signal.h
 delete mode 100644 arch/parisc/include/asm/cputime.h
 delete mode 100644 arch/parisc/include/asm/device.h
 delete mode 100644 arch/parisc/include/asm/div64.h
 delete mode 100644 arch/parisc/include/asm/emergency-restart.h
 delete mode 100644 arch/parisc/include/asm/hw_irq.h
 delete mode 100644 arch/parisc/include/asm/irq_regs.h
 delete mode 100644 arch/parisc/include/asm/kdebug.h
 delete mode 100644 arch/parisc/include/asm/kvm_para.h
 delete mode 100644 arch/parisc/include/asm/local.h
 delete mode 100644 arch/parisc/include/asm/local64.h
 delete mode 100644 arch/parisc/include/asm/mutex.h
 delete mode 100644 arch/parisc/include/asm/param.h
 delete mode 100644 arch/parisc/include/asm/percpu.h
 delete mode 100644 arch/parisc/include/asm/poll.h
 delete mode 100644 arch/parisc/include/asm/real.h
 delete mode 100644 arch/parisc/include/asm/segment.h
 delete mode 100644 arch/parisc/include/asm/topology.h
 delete mode 100644 arch/parisc/include/asm/user.h
 delete mode 100644 arch/parisc/include/asm/vga.h
 delete mode 100644 arch/parisc/include/asm/xor.h
 rename arch/parisc/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/errno.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/mman.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/pdc.h
 rename arch/parisc/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/ptrace.h
 rename arch/parisc/include/{ => uapi}/asm/resource.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/setup.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/signal.h
 rename arch/parisc/include/{ => uapi}/asm/socket.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/stat.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/swab.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/termios.h
 rename arch/parisc/include/{ => uapi}/asm/types.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/unistd.h

James


