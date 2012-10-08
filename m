Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2JHPU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:20:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2JHPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:20:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] asm-generic changes for 3.7
Date: Mon, 8 Oct 2012 15:20:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210081520.09942.arnd@arndb.de>
X-Provags-ID: V02:K0:iNwgfWTiiY75ijsqvLrkENfcUUnsq4ejpTSgtX27ou7
 SRRiv9DouMW9l8qMQ3bnMQKJ0yw2F5tzg8Zou/nvu3Ha+gQKfh
 kBW5hh64t2GQrLijcYf3RcafGrpKeJU17MBEpgthaOVsrEOHal
 IIjOWaG1u8pG+Cngw4NCT07mobBEN1mygMSSFMwXZY8Aik3o5Q
 314iHMP3Sni0TnQRKrRScSk2KV59hcoSla/LhV4bYxIPx6xaMx
 axXQ1/sdFuZbncRQJoSgK241qHpZ+U9ReCEhUoBvGj4RlgVgcX
 vcMCevuuylvmZTYbBwFTVVXwGjDsIa8XEkFf2T+OwD5o4m22CY
 KXrI118nm/7ij2x/U/kA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f3dfd599af993385b40fc7a1c947afc12729bc4d:

  UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k) (2012-10-04 18:16:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git tags/asm-generic

for you to fetch changes up to c37d6154c0b9163c27e53cc1d0be3867b4abd760:

  Merge branch 'disintegrate-asm-generic' of git://git.infradead.org/users/dhowells/linux-headers into asm-generic (2012-10-04 22:57:51 +0200)

----------------------------------------------------------------

This has three changes for asm-generic that did not really fit into any
other branch as normal asm-generic changes do. One is a fix for a
build warning, the other two are more interesting:

* A patch from Mark Brown to allow using the common clock infrastructure
on all architectures, so we can use the clock API in architecture
independent device drivers.

* The UAPI split patches from David Howells for the asm-generic files.
There are other architecture specific series that are going through
the arch maintainer tree and that depend on this one.

There may be a few small merge conflicts between Mark's patch and
the following arch header file split patches. In each case the solution
will be to keep the new "generic-y += clkdev.h" line, even if it
ends up being the only line in the Kbuild file.

----------------------------------------------------------------
Arnd Bergmann (2):
      asm-generic: xor: mark static functions as __maybe_unused
      Merge branch 'disintegrate-asm-generic' of git://git.infradead.org/users/dhowells/linux-headers into asm-generic

David Howells (1):
      UAPI: (Scripted) Disintegrate include/asm-generic

Mark Brown (1):
      asm-generic: Add default clkdev.h

 arch/alpha/include/asm/Kbuild                |    2 +
 arch/avr32/include/asm/Kbuild                |    2 +
 arch/cris/include/asm/Kbuild                 |    2 +
 arch/frv/include/asm/Kbuild                  |    1 +
 arch/h8300/include/asm/Kbuild                |    2 +
 arch/hexagon/include/asm/Kbuild              |    1 +
 arch/ia64/include/asm/Kbuild                 |    1 +
 arch/m32r/include/asm/Kbuild                 |    2 +
 arch/m68k/include/asm/Kbuild                 |    1 +
 arch/microblaze/include/asm/Kbuild           |    1 +
 arch/mn10300/include/asm/Kbuild              |    2 +
 arch/openrisc/include/asm/Kbuild             |    1 +
 arch/parisc/include/asm/Kbuild               |    1 +
 arch/powerpc/include/asm/Kbuild              |    1 +
 arch/s390/include/asm/Kbuild                 |    2 +
 arch/score/include/asm/Kbuild                |    2 +
 arch/sparc/include/asm/Kbuild                |    1 +
 arch/tile/include/asm/Kbuild                 |    1 +
 arch/um/include/asm/Kbuild                   |    2 +-
 arch/unicore32/include/asm/Kbuild            |    1 +
 arch/x86/include/asm/Kbuild                  |    6 +
 arch/xtensa/include/asm/Kbuild               |    2 +
 include/asm-generic/Kbuild                   |   35 -
 include/asm-generic/bitsperlong.h            |   13 +-
 include/asm-generic/clkdev.h                 |   28 +
 include/asm-generic/int-l64.h                |   26 +-
 include/asm-generic/int-ll64.h               |   31 +-
 include/asm-generic/ioctl.h                  |   95 +--
 include/asm-generic/kvm_para.h               |    5 +-
 include/asm-generic/param.h                  |   17 +-
 include/asm-generic/resource.h               |   66 +-
 include/asm-generic/siginfo.h                |  297 +--------
 include/asm-generic/signal.h                 |  117 +---
 include/asm-generic/statfs.h                 |   81 +--
 include/asm-generic/termios.h                |   49 +-
 include/asm-generic/unistd.h                 |  907 +-------------------------
 include/asm-generic/xor.h                    |    4 +-
 include/uapi/asm-generic/Kbuild              |   35 +
 include/{ => uapi}/asm-generic/auxvec.h      |    0
 include/uapi/asm-generic/bitsperlong.h       |   15 +
 include/{ => uapi}/asm-generic/errno-base.h  |    0
 include/{ => uapi}/asm-generic/errno.h       |    0
 include/{ => uapi}/asm-generic/fcntl.h       |    0
 include/uapi/asm-generic/int-l64.h           |   34 +
 include/uapi/asm-generic/int-ll64.h          |   39 ++
 include/uapi/asm-generic/ioctl.h             |   98 +++
 include/{ => uapi}/asm-generic/ioctls.h      |    0
 include/{ => uapi}/asm-generic/ipcbuf.h      |    0
 include/{ => uapi}/asm-generic/mman-common.h |    0
 include/{ => uapi}/asm-generic/mman.h        |    0
 include/{ => uapi}/asm-generic/msgbuf.h      |    0
 include/uapi/asm-generic/param.h             |   19 +
 include/{ => uapi}/asm-generic/poll.h        |    0
 include/{ => uapi}/asm-generic/posix_types.h |    0
 include/uapi/asm-generic/resource.h          |   68 ++
 include/{ => uapi}/asm-generic/sembuf.h      |    0
 include/{ => uapi}/asm-generic/setup.h       |    0
 include/{ => uapi}/asm-generic/shmbuf.h      |    0
 include/{ => uapi}/asm-generic/shmparam.h    |    0
 include/uapi/asm-generic/siginfo.h           |  298 +++++++++
 include/{ => uapi}/asm-generic/signal-defs.h |    0
 include/uapi/asm-generic/signal.h            |  123 ++++
 include/{ => uapi}/asm-generic/socket.h      |    0
 include/{ => uapi}/asm-generic/sockios.h     |    0
 include/{ => uapi}/asm-generic/stat.h        |    0
 include/uapi/asm-generic/statfs.h            |   83 +++
 include/{ => uapi}/asm-generic/swab.h        |    0
 include/{ => uapi}/asm-generic/termbits.h    |    0
 include/uapi/asm-generic/termios.h           |   50 ++
 include/{ => uapi}/asm-generic/types.h       |    0
 include/{ => uapi}/asm-generic/ucontext.h    |    0
 include/uapi/asm-generic/unistd.h            |  902 +++++++++++++++++++++++++
 security/apparmor/Makefile                   |    2 +-
 73 files changed, 1844 insertions(+), 1730 deletions(-)
 create mode 100644 include/asm-generic/clkdev.h
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
