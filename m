Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0ERHHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:07:21 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:41969 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0ERHHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:07:18 -0400
Date: Tue, 18 May 2010 09:07:16 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 2.6.35 merge window
Message-ID: <20100518090716.78a9884b@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Carsten Otte (1):
      [S390] virtualization aware cpu measurement

Christoph Egger (1):
      [S390] vdso: remove redundant check for CONFIG_64BIT

Heiko Carstens (4):
      [S390] vmcp: disallow modular build
      [S390] topology: expose core identifier
      [S390] user space fault: report fault before calling do_exit
      [S390] debug: enable exception-trace debug facility

Hendrik Brueckner (1):
      [S390] vdso: add missing vdso_install target

Jan Glauber (6):
      [S390] qdio: count number of qdio interrupts
      [S390] qdio: prevent starvation on PCI devices
      [S390] qdio: remove memset hack
      [S390] qdio: dont convert timestamps to microseconds
      [S390] qdio: set correct bit in dsci
      [S390] qdio: remove API wrappers

Julia Lawall (2):
      [S390] drivers/s390/char: Use kstrdup
      [S390] drivers/s390/char: Use kmemdup

Martin Schwidefsky (6):
      [S390] More cleanup for struct _lowcore
      [S390] cleanup sysc_work and io_work code
      [S390] improve irq tracing code in entry[64].S
      [S390] idle time accounting vs. machine checks
      [S390] add breaking event address for user space
      [S390] avoid default_llseek in s390 drivers

Michael Holzheu (1):
      [S390] s390_hypfs: Add new attributes

Stefan Haberland (2):
      [S390] dasd: add dynamic pav toleration
      [S390] dasd: remove uid from devmap

 arch/s390/Kconfig                   |    7 -
 arch/s390/Makefile                  |    6 +
 arch/s390/hypfs/hypfs.h             |    4 +
 arch/s390/hypfs/hypfs_diag.c        |  123 +++++++-
 arch/s390/hypfs/hypfs_vm.c          |   87 +++++-
 arch/s390/hypfs/inode.c             |   42 ++-
 arch/s390/include/asm/cputime.h     |    9 +-
 arch/s390/include/asm/lowcore.h     |   89 +++---
 arch/s390/include/asm/ptrace.h      |    3 +-
 arch/s390/include/asm/qdio.h        |    2 -
 arch/s390/include/asm/setup.h       |    5 +-
 arch/s390/include/asm/system.h      |    5 -
 arch/s390/include/asm/thread_info.h |    1 +
 arch/s390/include/asm/timex.h       |    8 +-
 arch/s390/include/asm/topology.h    |    2 +
 arch/s390/kernel/asm-offsets.c      |    6 +-
 arch/s390/kernel/debug.c            |    1 +
 arch/s390/kernel/early.c            |    4 +
 arch/s390/kernel/entry.S            |  324 ++++++++-----------
 arch/s390/kernel/entry64.S          |  617 +++++++++++++++++------------------
 arch/s390/kernel/head.S             |    4 +-
 arch/s390/kernel/nmi.c              |    3 +-
 arch/s390/kernel/processor.c        |   37 ++-
 arch/s390/kernel/ptrace.c           |   68 ++++
 arch/s390/kernel/s390_ext.c         |    3 +-
 arch/s390/kernel/setup.c            |   27 +--
 arch/s390/kernel/signal.c           |    2 +
 arch/s390/kernel/topology.c         |    7 +-
 arch/s390/kernel/traps.c            |   31 +-
 arch/s390/kernel/vdso.c             |    4 -
 arch/s390/kernel/vtime.c            |   15 +-
 arch/s390/kvm/Kconfig               |   11 +
 arch/s390/kvm/sie64a.S              |   77 ++++-
 arch/s390/mm/fault.c                |   32 +-
 drivers/s390/block/dasd.c           |   22 ++
 drivers/s390/block/dasd_3990_erp.c  |   20 ++
 drivers/s390/block/dasd_alias.c     |  125 +++++---
 drivers/s390/block/dasd_devmap.c    |  174 ++++------
 drivers/s390/block/dasd_eckd.c      |  116 ++++++-
 drivers/s390/block/dasd_eckd.h      |    2 +-
 drivers/s390/block/dasd_int.h       |   49 ++--
 drivers/s390/char/Kconfig           |    3 +-
 drivers/s390/char/fs3270.c          |    1 +
 drivers/s390/char/keyboard.c        |   21 +-
 drivers/s390/char/vmcp.c            |   38 +--
 drivers/s390/char/zcore.c           |    4 +-
 drivers/s390/cio/chsc_sch.c         |    1 +
 drivers/s390/cio/cio.c              |    3 +-
 drivers/s390/cio/css.c              |    8 +-
 drivers/s390/cio/qdio.h             |   15 +-
 drivers/s390/cio/qdio_main.c        |   67 +---
 drivers/s390/cio/qdio_setup.c       |    8 +-
 drivers/s390/cio/qdio_thinint.c     |    4 +-
 drivers/s390/crypto/zcrypt_api.c    |    2 +-
 drivers/s390/net/qeth_core_main.c   |   17 +-
 drivers/s390/scsi/zfcp_cfdc.c       |    1 +
 include/linux/elf.h                 |    1 +
 kernel/sysctl.c                     |    5 +-
 58 files changed, 1369 insertions(+), 1004 deletions(-)

