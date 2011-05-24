Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1EXHeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:34:05 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:33193 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1EXHeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:34:01 -0400
Date: Tue, 24 May 2011 09:33:56 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the kernel formerly known as 2.6.40
Message-ID: <20110524093356.674c2281@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

There is one patch that touches non-s390 files, the page_test_dirty and
page_clear_dirty merge. These two primitives are only used by s390, the
patch is necessary to fix the handling of storage keys vs KVM.

Shortlist of the updates:

Heiko Carstens (15):
      [S390] Remove tape block device driver.
      [S390] get rid of unused variables
      [S390] dasd: fix return code handling
      [S390] monwriter: fix return code handling
      [S390] tape: remove unused/not handled return codes
      [S390] extmem: get rid of compile warning
      [S390] percpu: implement arch specific irqsafe_cpu_ops
      [S390] smp: add __noreturn attribute to cpu_die()
      [S390] pfault: cpu hotplug vs missing completion interrupts
      [S390] pfault: cleanup code
      [S390] sclp: remove unnecessary sendmask check
      [S390] Ignore sendmmsg system call note wired up warning
      [S390] oprofile: add missing irq stats counter
      [S390] oprofile: dont access lowcore
      [S390] cpu hotplug: fix external interrupt subclass mask handling

Holger Dengler (1):
      [S390] ap: skip device registration on type probe failure

Jan Glauber (4):
      [S390] qdio: prevent compile warning
      [S390] Remove unused includes in process.c
      [S390] s390,oprofile: fix alert counter increment
      [S390] s390,oprofile: fix compile error for !CONFIG_SMP

KOSAKI Motohiro (1):
      [S390] convert old cpumask API into new one

Martin Schwidefsky (5):
      [S390] Remove data execution protection
      [S390] merge page_test_dirty and page_clear_dirty
      [S390] refactor page table functions for better pgste support
      [S390] sclp: event buffer dissection
      [S390] get CPC image name

Peter Oberparleiter (1):
      [S390] vdso: disable gcov profiling

Sebastian Ott (2):
      [S390] cio: fix unreg race in set_online path
      [S390] chsc: process channel-path-availability information

 arch/s390/Kconfig                   |   11 -
 arch/s390/appldata/appldata_base.c  |    2 -
 arch/s390/include/asm/cmpxchg.h     |    1 -
 arch/s390/include/asm/elf.h         |   12 -
 arch/s390/include/asm/hugetlb.h     |   17 +-
 arch/s390/include/asm/irq.h         |    1 +
 arch/s390/include/asm/lowcore.h     |    4 +-
 arch/s390/include/asm/mmu.h         |    9 +-
 arch/s390/include/asm/mmu_context.h |    6 +-
 arch/s390/include/asm/page.h        |   60 +++-
 arch/s390/include/asm/percpu.h      |   68 ++++
 arch/s390/include/asm/pgalloc.h     |   57 +---
 arch/s390/include/asm/pgtable.h     |  609 ++++++++++++++++++-----------------
 arch/s390/include/asm/processor.h   |    1 +
 arch/s390/include/asm/tlbflush.h    |   13 +-
 arch/s390/include/asm/unistd.h      |    1 +
 arch/s390/kernel/asm-offsets.c      |    4 +-
 arch/s390/kernel/entry.S            |    1 +
 arch/s390/kernel/entry64.S          |    1 +
 arch/s390/kernel/irq.c              |    1 +
 arch/s390/kernel/process.c          |   19 +-
 arch/s390/kernel/setup.c            |   31 +--
 arch/s390/kernel/smp.c              |   30 +-
 arch/s390/kernel/time.c             |    4 +-
 arch/s390/kernel/topology.c         |   16 +-
 arch/s390/kernel/vdso32/Makefile    |    3 +
 arch/s390/kernel/vdso64/Makefile    |    3 +
 arch/s390/mm/extmem.c               |    6 +-
 arch/s390/mm/fault.c                |  187 ++++++-----
 arch/s390/mm/hugetlbpage.c          |   10 -
 arch/s390/mm/init.c                 |    3 +-
 arch/s390/mm/pageattr.c             |    2 +-
 arch/s390/mm/pgtable.c              |   68 +----
 arch/s390/mm/vmem.c                 |   14 +-
 arch/s390/oprofile/hwsampler.c      |   21 +-
 drivers/crypto/Kconfig              |    2 +
 drivers/s390/block/dasd_alias.c     |    4 -
 drivers/s390/block/dasd_eckd.c      |   11 +-
 drivers/s390/char/Kconfig           |   12 -
 drivers/s390/char/Makefile          |    3 +-
 drivers/s390/char/monwriter.c       |    4 +-
 drivers/s390/char/raw3270.c         |    2 -
 drivers/s390/char/sclp.h            |   24 ++
 drivers/s390/char/sclp_config.c     |   14 +-
 drivers/s390/char/sclp_ocf.c        |  145 +++++++++
 drivers/s390/char/sclp_sdias.c      |    3 -
 drivers/s390/char/sclp_tty.c        |  122 +++-----
 drivers/s390/char/tape_3590.c       |   11 +-
 drivers/s390/char/tape_block.c      |  444 -------------------------
 drivers/s390/char/tape_std.c        |    3 +-
 drivers/s390/cio/chsc.c             |   35 ++-
 drivers/s390/cio/device_fsm.c       |    8 +-
 drivers/s390/cio/device_ops.c       |    3 -
 drivers/s390/cio/qdio_main.c        |    2 +-
 drivers/s390/crypto/ap_bus.c        |    8 +-
 include/asm-generic/pgtable.h       |   12 +-
 include/linux/page-flags.h          |    2 +-
 mm/rmap.c                           |   11 +-
 58 files changed, 896 insertions(+), 1285 deletions(-)
 create mode 100644 drivers/s390/char/sclp_ocf.c
 delete mode 100644 drivers/s390/char/tape_block.c

