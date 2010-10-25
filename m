Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0JYOVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:21:35 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:37348 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0JYOVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:21:34 -0400
Date: Mon, 25 Oct 2010 16:21:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.37
Message-ID: <20101025162131.27deb1e1@mschwide.boeblingen.de.ibm.com>
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

Andy Shevchenko (1):
      [S390] cio: remove custom implementation of hex_to_bin()

Christian Borntraeger (2):
      [S390] kvm: Fix badness at include/asm/mmu_context.h:83
      [S390] kvm: Enable z196 instruction facilities

Christof Schmitt (1):
      [S390] set ARCH_HAS_SG_CHAIN for s390

FUJITA Tomonori (1):
      [S390] enable ARCH_DMA_ADDR_T_64BIT with 64BIT

Heiko Carstens (13):
      [S390] standardize Kbuild rules
      [S390] cpu hotplug/idle: move cpu_die call to enabled context
      [S390] sysinfo: display capacity adjustment indicator
      [S390] Add config option for z196 code generation.
      [S390] switch_to: dont restore/save access & fpu regs for kernel threads
      [S390] switch_to: get rid of prev == next check
      [S390] cmm: fix crash on case conversion
      [S390] pgtable: move pte_mkhuge() from hugetlb.h to pgtable.h
      [S390] smp: use correct cpu address in print_cpu_info()
      [S390] topology: change default
      [S390] topology: clean up facility detection
      [S390] topology: move topology sysinfo code
      [S390] topology: export cpu topology via proc/sysinfo

Hendrik Brueckner (1):
      [S390] hvc_iucv: do not call iucv_unregister if iucv_register failed

Joe Perches (1):
      [S390] drivers/s390/char: Use static const char arrays

Martin Schwidefsky (12):
      [S390] zero page cache synonyms
      [S390] lockless get_user_pages_fast()
      [S390] store indication fault optimization
      [S390] add support for nonquiescing sske
      [S390] add z196 instructions to kernel disassembler
      [S390] fix SIGBUS handling
      [S390] cleanup lowcore access from program checks
      [S390] cleanup lowcore access from external interrupts
      [S390] correct alignment of cpuid structure
      [S390] cleanup system call parameter setup
      [S390] remove ieee_instruction_pointer from thread_struct
      [S390] cleanup facility list handling

Peter Oberparleiter (1):
      [S390] cio: fix I/O cancel function

Sebastian Ott (11):
      [S390] css: fix sparse warning
      [S390] cio: fix memleak in resume path
      [S390] cio: add lock to struct channel_path
      [S390] chsc: initialization fixes
      [S390] chsc: consolidate memory allocations
      [S390] chsc: use the global page to determine the chp desriptor
      [S390] cio: update descriptor in chsc_chp_vary
      [S390] css: update descriptor after hibernate
      [S390] css: update subchannel description after hibernate
      [S390] cio: notify drivers of channel path events
      [S390] dasd: fix use after free in dbf

Stefan Haberland (2):
      [S390] dasd fix dump_sense_dbf
      [S390] dasd: ignore unsolicited interrupts for DIAG

Stefan Weinhuber (2):
      [S390] dasd: let recovery cqr inherit flags from failed cqr
      [S390] dasd: fix unsolicited interrupt recognition

 Documentation/kernel-parameters.txt |    2 +-
 arch/s390/Kbuild                    |    6 +
 arch/s390/Kconfig                   |   12 ++
 arch/s390/Makefile                  |    5 +-
 arch/s390/crypto/crypt_s390.h       |    2 +-
 arch/s390/include/asm/ccwdev.h      |   12 ++
 arch/s390/include/asm/cpu.h         |    2 +-
 arch/s390/include/asm/hugetlb.h     |   26 ---
 arch/s390/include/asm/lowcore.h     |   11 +-
 arch/s390/include/asm/page.h        |    8 +-
 arch/s390/include/asm/pgalloc.h     |    4 +
 arch/s390/include/asm/pgtable.h     |   60 +++++++-
 arch/s390/include/asm/processor.h   |    2 -
 arch/s390/include/asm/ptrace.h      |    3 +-
 arch/s390/include/asm/s390_ext.h    |    2 +-
 arch/s390/include/asm/scatterlist.h |    2 +
 arch/s390/include/asm/setup.h       |    3 +
 arch/s390/include/asm/syscall.h     |    4 -
 arch/s390/include/asm/sysinfo.h     |   40 +++++-
 arch/s390/include/asm/system.h      |   51 +++----
 arch/s390/include/asm/tlb.h         |   13 +-
 arch/s390/include/asm/topology.h    |    2 +
 arch/s390/kernel/asm-offsets.c      |    3 +-
 arch/s390/kernel/compat_ptrace.h    |    3 +-
 arch/s390/kernel/dis.c              |  145 ++++++++++++++++--
 arch/s390/kernel/early.c            |   45 ++++--
 arch/s390/kernel/entry.S            |   44 ++----
 arch/s390/kernel/entry.h            |    4 +-
 arch/s390/kernel/entry64.S          |   45 ++----
 arch/s390/kernel/head.S             |    8 +-
 arch/s390/kernel/process.c          |   10 +-
 arch/s390/kernel/processor.c        |    2 +-
 arch/s390/kernel/s390_ext.c         |    9 +-
 arch/s390/kernel/setup.c            |   22 +--
 arch/s390/kernel/smp.c              |    5 +-
 arch/s390/kernel/sysinfo.c          |   41 +++++-
 arch/s390/kernel/time.c             |   17 +-
 arch/s390/kernel/topology.c         |  101 ++++---------
 arch/s390/kernel/traps.c            |  173 +++++++++------------
 arch/s390/kernel/vdso.c             |    6 +-
 arch/s390/kernel/vtime.c            |    3 +-
 arch/s390/kvm/kvm-s390.c            |    4 +-
 arch/s390/kvm/priv.c                |    4 +-
 arch/s390/mm/Makefile               |    2 +-
 arch/s390/mm/cmm.c                  |    7 +-
 arch/s390/mm/fault.c                |   77 ++++++----
 arch/s390/mm/gup.c                  |  225 +++++++++++++++++++++++++++
 arch/s390/mm/hugetlbpage.c          |    2 +-
 arch/s390/mm/init.c                 |   52 ++++++-
 arch/s390/mm/pgtable.c              |  173 +++++++++++++++++++--
 drivers/char/hvc_iucv.c             |    4 +-
 drivers/s390/block/dasd.c           |   24 +++-
 drivers/s390/block/dasd_3990_erp.c  |    3 +
 drivers/s390/block/dasd_diag.c      |   19 +--
 drivers/s390/block/dasd_diag.h      |    4 -
 drivers/s390/block/dasd_eckd.c      |   68 ++++-----
 drivers/s390/block/dasd_proc.c      |    1 -
 drivers/s390/char/sclp.c            |   14 +-
 drivers/s390/char/vmlogrdr.c        |    4 +-
 drivers/s390/cio/blacklist.c        |   10 +-
 drivers/s390/cio/chp.c              |   41 +++--
 drivers/s390/cio/chp.h              |   12 ++-
 drivers/s390/cio/chsc.c             |  291 ++++++++++++++++-------------------
 drivers/s390/cio/chsc.h             |   28 +++-
 drivers/s390/cio/chsc_sch.c         |   12 +-
 drivers/s390/cio/css.c              |   50 +++----
 drivers/s390/cio/device.c           |   18 ++-
 drivers/s390/cio/device_fsm.c       |   41 +++++-
 drivers/s390/cio/device_pgid.c      |   23 ++-
 drivers/s390/cio/io_sch.h           |    7 +-
 drivers/s390/crypto/ap_bus.c        |    9 +-
 drivers/s390/kvm/kvm_virtio.c       |    9 +-
 include/asm-generic/pgtable.h       |    2 +-
 include/linux/page-flags.h          |    2 +-
 mm/rmap.c                           |    4 +-
 net/iucv/iucv.c                     |    3 +-
 76 files changed, 1440 insertions(+), 767 deletions(-)
 create mode 100644 arch/s390/Kbuild
 create mode 100644 arch/s390/mm/gup.c

