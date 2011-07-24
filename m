Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1GXI5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 04:57:07 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41399 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1GXI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:57 -0400
Date: Sun, 24 Jul 2011 10:56:40 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.0+
Message-ID: <20110724105640.04563326@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

I rebased the branch today to avoid a merge conflict with git commit
a288eecce5253cc1565d400a52b9b476a157e040.

The branch contains the following updates:

Carsten Otte (3):
      [S390] use gmap address spaces for kvm guest images
      [S390] Use gmap translation for accessing guest memory
      [S390] remove kvm mmu reload on s390

Christian Borntraeger (1):
      [S390] kvm: handle tprot intercepts

Christian Ehrhardt (1):
      [S390] kvm: make sigp emerg smp capable

Holger Dengler (1):
      [S390] ap: toleration support for ap device type 10

Jan Glauber (4):
      [S390] qdio: clear shared DSCI before scheduling the queue handler
      [S390] fix s390 assembler code alignments
      [S390] race safe external interrupt registration
      [S390] disable cpu measurement alerts on a dying cpu

Martin Schwidefsky (9):
      [S390] kconfig: remove tape interface support comment
      [S390] reference bit testing for unmapped pages
      [S390] move sie code to entry.S
      [S390] kvm guest address space mapping
      [S390] cleanup program check handler prototypes
      [S390] remove tape block docu
      [S390] iucv cr0 enablement bit
      [S390] initial cr0 bits
      [S390] use siginfo for sigtrap signals

Stefan Weinhuber (1):
      [S390] dasd: add enhanced DASD statistics interface

Steven Rostedt (1):
      [S390] irqs: Do not trace arch_local_{*,irq_*} functions

 Documentation/s390/TAPE              |  122 -----
 arch/s390/boot/compressed/head31.S   |    4 +-
 arch/s390/boot/compressed/head64.S   |    4 +-
 arch/s390/include/asm/irqflags.h     |   16 +-
 arch/s390/include/asm/kvm_host.h     |   12 +-
 arch/s390/include/asm/linkage.h      |    5 +-
 arch/s390/include/asm/lowcore.h      |    2 +-
 arch/s390/include/asm/mmu.h          |    4 +-
 arch/s390/include/asm/pgalloc.h      |    7 +-
 arch/s390/include/asm/pgtable.h      |   42 ++
 arch/s390/include/asm/processor.h    |    1 +
 arch/s390/include/asm/thread_info.h  |    2 +
 arch/s390/include/asm/tlbflush.h     |    2 +-
 arch/s390/kernel/asm-offsets.c       |    2 +-
 arch/s390/kernel/base.S              |   25 +-
 arch/s390/kernel/compat_wrapper.S    |  836 ++++++++++++----------------------
 arch/s390/kernel/entry.S             |   32 +-
 arch/s390/kernel/entry.h             |    7 +-
 arch/s390/kernel/entry64.S           |  111 ++++--
 arch/s390/kernel/head.S              |    7 +-
 arch/s390/kernel/head31.S            |   13 +-
 arch/s390/kernel/head64.S            |   13 +-
 arch/s390/kernel/irq.c               |   83 ++--
 arch/s390/kernel/mcount.S            |   16 +-
 arch/s390/kernel/mcount64.S          |   16 +-
 arch/s390/kernel/reipl.S             |    5 +-
 arch/s390/kernel/reipl64.S           |    5 +-
 arch/s390/kernel/relocate_kernel.S   |    6 +-
 arch/s390/kernel/relocate_kernel64.S |    6 +-
 arch/s390/kernel/s390_ksyms.c        |    4 +
 arch/s390/kernel/sclp.S              |    5 +-
 arch/s390/kernel/smp.c               |    3 +-
 arch/s390/kernel/switch_cpu.S        |    8 +-
 arch/s390/kernel/switch_cpu64.S      |    8 +-
 arch/s390/kernel/swsusp_asm64.S      |    8 +-
 arch/s390/kernel/traps.c             |   36 +-
 arch/s390/kvm/Makefile               |    2 +-
 arch/s390/kvm/gaccess.h              |  243 +++++++---
 arch/s390/kvm/intercept.c            |   35 ++-
 arch/s390/kvm/interrupt.c            |    4 +
 arch/s390/kvm/kvm-s390.c             |   48 +-
 arch/s390/kvm/kvm-s390.h             |   28 +--
 arch/s390/kvm/priv.c                 |   49 ++
 arch/s390/kvm/sie64a.S               |   98 ----
 arch/s390/kvm/sigp.c                 |    6 +-
 arch/s390/lib/qrnnd.S                |    5 +-
 arch/s390/mm/fault.c                 |   18 +-
 arch/s390/mm/hugetlbpage.c           |    2 +-
 arch/s390/mm/pgtable.c               |  421 ++++++++++++++++-
 arch/s390/mm/vmem.c                  |    8 +-
 drivers/s390/block/dasd.c            |  576 +++++++++++++++++++++--
 drivers/s390/block/dasd_int.h        |   57 ++-
 drivers/s390/block/dasd_ioctl.c      |   38 ++-
 drivers/s390/block/dasd_proc.c       |  106 +++--
 drivers/s390/char/Kconfig            |    3 -
 drivers/s390/cio/qdio_thinint.c      |   15 +-
 drivers/s390/crypto/ap_bus.c         |   96 +++-
 drivers/s390/crypto/ap_bus.h         |   22 +-
 mm/rmap.c                            |    6 +-
 net/iucv/iucv.c                      |    7 +-
 60 files changed, 2091 insertions(+), 1280 deletions(-)
 delete mode 100644 Documentation/s390/TAPE
 delete mode 100644 arch/s390/kvm/sie64a.S


