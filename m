Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2JJJLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:11:24 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:45431 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2JJJLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:11:18 -0400
Date: Wed, 10 Oct 2012 11:10:56 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.7 merge window #2
Message-ID: <20121010111056.173fca51@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12101009-4966-0000-0000-000003B9A179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The big thing in this pull request is the UAPI patch from David,
and worth mentioning is the page table dumper. The rest are small
improvements and bug fixes.

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/s390/include/asm

Heiko Carstens (10):
      s390/facilities: cleanup PFMF and HPAGE machine facility detection
      s390/mm: use pfmf instruction to initialize storage keys
      s390/mm: fix pmd_huge() usage for kernel mapping
      s390/mm,pageattr: add more page table walk sanity checks
      s390/mm,pageattr: remove superfluous EXPORT_SYMBOLs
      s390/mm: add page table dumper
      s390/mm: fix mapping of read-only kernel text section
      s390/mm: let kernel text section always begin at 1MB
      s390/vmalloc: have separate modules area
      s390/mm,vmem: fix vmem_add_mem()/vmem_remove_range()

Martin Schwidefsky (2):
      s390: add support to start the kernel in 64 bit mode.
      s390/entry: fix svc number for TIF_SYSCALL system call restart

Sebastian Ott (3):
      s390/dcssblk: cleanup device attribute usage
      s390/chsc: make headers usable
      s390/css_chars: remove superfluous ifdef

Wei Yongjun (1):
      s390/zcrypt: remove duplicated include from zcrypt_pcixcc.c

 arch/s390/Kconfig.debug                        |   12 +
 arch/s390/include/asm/Kbuild                   |   14 -
 arch/s390/include/asm/chpid.h                  |   19 +-
 arch/s390/include/asm/cmb.h                    |   51 +--
 arch/s390/include/asm/css_chars.h              |    3 -
 arch/s390/include/asm/debug.h                  |   28 +-
 arch/s390/include/asm/kvm_para.h               |   14 +-
 arch/s390/include/asm/mman.h                   |    6 +-
 arch/s390/include/asm/page.h                   |   14 +-
 arch/s390/include/asm/pgtable.h                |   30 +-
 arch/s390/include/asm/ptrace.h                 |  462 +----------------------
 arch/s390/include/asm/schid.h                  |   15 +-
 arch/s390/include/asm/setup.h                  |   21 +-
 arch/s390/include/asm/signal.h                 |  128 +------
 arch/s390/include/asm/termios.h                |   42 +--
 arch/s390/include/asm/types.h                  |   15 +-
 arch/s390/include/asm/unistd.h                 |  367 +-----------------
 arch/s390/include/uapi/asm/Kbuild              |   45 +++
 arch/s390/include/{ => uapi}/asm/auxvec.h      |    0
 arch/s390/include/{ => uapi}/asm/bitsperlong.h |    0
 arch/s390/include/{ => uapi}/asm/byteorder.h   |    0
 arch/s390/include/uapi/asm/chpid.h             |   22 ++
 arch/s390/include/{ => uapi}/asm/chsc.h        |   10 +-
 arch/s390/include/uapi/asm/cmb.h               |   53 +++
 arch/s390/include/{ => uapi}/asm/dasd.h        |    0
 arch/s390/include/uapi/asm/debug.h             |   34 ++
 arch/s390/include/{ => uapi}/asm/errno.h       |    0
 arch/s390/include/{ => uapi}/asm/fcntl.h       |    0
 arch/s390/include/{ => uapi}/asm/ioctl.h       |    0
 arch/s390/include/{ => uapi}/asm/ioctls.h      |    0
 arch/s390/include/{ => uapi}/asm/ipcbuf.h      |    0
 arch/s390/include/{ => uapi}/asm/kvm.h         |    0
 arch/s390/include/{ => uapi}/asm/kvm_virtio.h  |    0
 arch/s390/include/uapi/asm/mman.h              |    6 +
 arch/s390/include/{ => uapi}/asm/monwriter.h   |    0
 arch/s390/include/{ => uapi}/asm/msgbuf.h      |    0
 arch/s390/include/{ => uapi}/asm/param.h       |    0
 arch/s390/include/{ => uapi}/asm/poll.h        |    0
 arch/s390/include/{ => uapi}/asm/posix_types.h |    0
 arch/s390/include/uapi/asm/ptrace.h            |  472 ++++++++++++++++++++++++
 arch/s390/include/{ => uapi}/asm/qeth.h        |    0
 arch/s390/include/{ => uapi}/asm/resource.h    |    0
 arch/s390/include/uapi/asm/schid.h             |   16 +
 arch/s390/include/{ => uapi}/asm/sembuf.h      |    0
 arch/s390/include/uapi/asm/setup.h             |   13 +
 arch/s390/include/{ => uapi}/asm/shmbuf.h      |    0
 arch/s390/include/{ => uapi}/asm/sigcontext.h  |    0
 arch/s390/include/{ => uapi}/asm/siginfo.h     |    0
 arch/s390/include/uapi/asm/signal.h            |  135 +++++++
 arch/s390/include/{ => uapi}/asm/socket.h      |    0
 arch/s390/include/{ => uapi}/asm/sockios.h     |    0
 arch/s390/include/{ => uapi}/asm/stat.h        |    0
 arch/s390/include/{ => uapi}/asm/statfs.h      |    0
 arch/s390/include/{ => uapi}/asm/swab.h        |    0
 arch/s390/include/{ => uapi}/asm/tape390.h     |    0
 arch/s390/include/{ => uapi}/asm/termbits.h    |    0
 arch/s390/include/uapi/asm/termios.h           |   49 +++
 arch/s390/include/uapi/asm/types.h             |   22 ++
 arch/s390/include/{ => uapi}/asm/ucontext.h    |    0
 arch/s390/include/uapi/asm/unistd.h            |  374 +++++++++++++++++++
 arch/s390/include/{ => uapi}/asm/vtoc.h        |    0
 arch/s390/include/{ => uapi}/asm/zcrypt.h      |    0
 arch/s390/kernel/early.c                       |   17 +-
 arch/s390/kernel/entry64.S                     |    2 +-
 arch/s390/kernel/head.S                        |  101 +++--
 arch/s390/kernel/head31.S                      |    3 -
 arch/s390/kernel/head64.S                      |    3 -
 arch/s390/kernel/module.c                      |   11 +
 arch/s390/kernel/setup.c                       |   51 ++-
 arch/s390/mm/Makefile                          |    1 +
 arch/s390/mm/dump_pagetables.c                 |  226 ++++++++++++
 arch/s390/mm/pageattr.c                        |   40 +-
 arch/s390/mm/vmem.c                            |   45 ++-
 drivers/s390/block/dcssblk.c                   |   52 ++-
 drivers/s390/crypto/zcrypt_pcixcc.c            |    1 -
 75 files changed, 1755 insertions(+), 1290 deletions(-)
 rename arch/s390/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/s390/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/s390/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/s390/include/uapi/asm/chpid.h
 rename arch/s390/include/{ => uapi}/asm/chsc.h (92%)
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
 create mode 100644 arch/s390/mm/dump_pagetables.c

