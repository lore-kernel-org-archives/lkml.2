Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1JaQF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:05:28 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:45158 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1JaQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:05:26 -0400
Date: Mon, 31 Oct 2011 17:05:19 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.2
Message-ID: <20111031170519.728e799f@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
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

Carsten Otte (4):
      [S390] load user asce on sie_fault
      [S390] fix possible deadlock in gmap_map_segment
      [S390] fix list corruption in gmap reverse mapping
      [S390] take mmap_sem when walking guest page table

Christian Borntraeger (1):
      [S390] kvm: Handle diagnose 0x10 (release pages)

Heiko Carstens (2):
      [S390] zcore: add missing module.h include
      [S390] irqstats: split IPI interrupt accounting

Hendrik Brueckner (1):
      [S390] defconfig: switch on CONFIG_DEVTMPFS

Jan Glauber (8):
      [S390] use ENTRY macro for sys_setns_wrapper
      [S390] Introduce get_clock_fast()
      [S390] qdio: add timestamp for last queue scan time
      [S390] qdio: EQBS retry after CCQ 96
      [S390] qdio: reset outbound SBAL error states
      [S390] qdio: remove multicast polling
      [S390] add missing __tlb_flush_global() for !CONFIG_SMP
      [S390] qdio: prevent dsci access without adapter interrupts

Martin Schwidefsky (18):
      [S390] avoid warning in show_cpuinfo
      [S390] user per registers vs. ptrace single stepping
      [S390] memory leak with RCU_TABLE_FREE
      [S390] lowcore cleanup
      [S390] signal race with restarting system calls
      [S390] addressing mode limits and psw address wrapping
      [S390] add TIF_SYSCALL thread flag
      [S390] cleanup psw related bits and pieces
      [S390] allow all addressing modes
      [S390] smp: external call vs. emergency signal
      [S390] sparse: fix access past end of array warnings
      [S390] sparse: fix sparse static warnings
      [S390] sparse: fix sparse ANSI-C warnings
      [S390] sparse: fix sparse warnings about missing prototypes
      [S390] sparse: fix sparse warnings in math-emu
      [S390] sparse: fix sparse warnings with __user pointers
      [S390] sparse: fix sparse NULL pointer warnings
      [S390] sparse: fix sparse symbol shadow warning

Michael Holzheu (10):
      [S390] kdump: Add KEXEC_CRASH_CONTROL_MEMORY_LIMIT
      [S390] kdump: Add size to elfcorehdr kernel parameter
      [S390] Force PSW restart on online CPU
      [S390] Add real memory access functions
      [S390] kdump backend code
      [S390] kdump: Initialize vmcoreinfo note at startup
      [S390] Export vmcoreinfo note
      [S390] kdump: Add infrastructure for unmapping crashkernel memory
      [S390] Add architecture code for unmapping crashkernel memory
      [S390] Remove error checking from copy_oldmem_page()

Peter Oberparleiter (1):
      [S390] fix mismatch in summation of I/O IRQ statistics

Sebastian Ott (5):
      [S390] topology: fix alloc_masks annotation
      [S390] cio: add message for timeouts on internal I/O
      [S390] ccwgroup: move attributes to attribute group
      [S390] ccwgroup: cleanup
      [S390] chsc_sch: add support for irq statistics

Stefan Haberland (3):
      [S390] dasd: wait for terminated request
      [S390] dasd: re-initialize read_conf buffer for retries
      [S390] dasd: prevent path verification before resume

Tejun Heo (1):
      [S390] fix _TIF_SINGLE_STEP definition

 Documentation/kernel-parameters.txt |    6 +-
 arch/s390/Kconfig                   |   10 +
 arch/s390/boot/compressed/misc.c    |    2 +-
 arch/s390/defconfig                 |    2 +-
 arch/s390/include/asm/ccwdev.h      |    3 +
 arch/s390/include/asm/compat.h      |   13 +-
 arch/s390/include/asm/ipl.h         |    1 +
 arch/s390/include/asm/irq.h         |    6 +-
 arch/s390/include/asm/kexec.h       |    6 +
 arch/s390/include/asm/kvm_host.h    |    1 +
 arch/s390/include/asm/lowcore.h     |   10 +-
 arch/s390/include/asm/page.h        |    1 +
 arch/s390/include/asm/pgtable.h     |    2 +
 arch/s390/include/asm/processor.h   |   48 +++--
 arch/s390/include/asm/ptrace.h      |   29 +--
 arch/s390/include/asm/reset.h       |    2 +-
 arch/s390/include/asm/setup.h       |   13 +
 arch/s390/include/asm/sfp-util.h    |    2 +-
 arch/s390/include/asm/smp.h         |    5 +
 arch/s390/include/asm/spinlock.h    |    2 +
 arch/s390/include/asm/syscall.h     |    6 +-
 arch/s390/include/asm/system.h      |   10 +-
 arch/s390/include/asm/thread_info.h |    7 +-
 arch/s390/include/asm/timex.h       |   11 +
 arch/s390/include/asm/tlbflush.h    |    1 +
 arch/s390/kernel/Makefile           |    1 +
 arch/s390/kernel/asm-offsets.c      |    4 +-
 arch/s390/kernel/base.S             |    6 +
 arch/s390/kernel/compat_linux.c     |   32 +--
 arch/s390/kernel/compat_signal.c    |   71 +++----
 arch/s390/kernel/compat_wrapper.S   |    3 +-
 arch/s390/kernel/crash_dump.c       |  426 +++++++++++++++++++++++++++++++++++
 arch/s390/kernel/early.c            |    2 +-
 arch/s390/kernel/entry.S            |   84 +++----
 arch/s390/kernel/entry.h            |   13 +-
 arch/s390/kernel/entry64.S          |   86 +++----
 arch/s390/kernel/head.S             |   22 ++
 arch/s390/kernel/head31.S           |    2 +-
 arch/s390/kernel/head64.S           |    2 +-
 arch/s390/kernel/head_kdump.S       |  119 ++++++++++
 arch/s390/kernel/ipl.c              |   26 ++-
 arch/s390/kernel/irq.c              |    6 +-
 arch/s390/kernel/kprobes.c          |    2 +-
 arch/s390/kernel/machine_kexec.c    |  192 +++++++++++++++-
 arch/s390/kernel/mem_detect.c       |   69 ++++++
 arch/s390/kernel/process.c          |    4 +-
 arch/s390/kernel/processor.c        |    2 +-
 arch/s390/kernel/ptrace.c           |  124 +++++++----
 arch/s390/kernel/reipl.S            |    6 +
 arch/s390/kernel/reipl64.S          |    9 +-
 arch/s390/kernel/setup.c            |  275 ++++++++++++++++++++---
 arch/s390/kernel/signal.c           |  128 ++++++-----
 arch/s390/kernel/smp.c              |   73 ++++++-
 arch/s390/kernel/suspend.c          |    1 +
 arch/s390/kernel/sysinfo.c          |    2 +-
 arch/s390/kernel/time.c             |    1 +
 arch/s390/kernel/topology.c         |    4 +-
 arch/s390/kernel/traps.c            |    5 +-
 arch/s390/kernel/vtime.c            |   11 +-
 arch/s390/kvm/diag.c                |   32 +++-
 arch/s390/kvm/kvm-s390.c            |    1 +
 arch/s390/lib/delay.c               |    3 +-
 arch/s390/lib/uaccess_pt.c          |    6 +-
 arch/s390/mm/fault.c                |    6 +-
 arch/s390/mm/maccess.c              |   56 +++++
 arch/s390/mm/mmap.c                 |    1 +
 arch/s390/mm/pageattr.c             |    1 +
 arch/s390/mm/pgtable.c              |   83 +++++++-
 arch/s390/mm/vmem.c                 |    6 +
 arch/s390/oprofile/hwsampler.c      |    8 +-
 drivers/s390/block/dasd.c           |   19 ++-
 drivers/s390/block/dasd_eckd.c      |   45 ++++-
 drivers/s390/block/dasd_fba.c       |    1 +
 drivers/s390/block/dasd_int.h       |    2 +
 drivers/s390/char/con3215.c         |    3 +-
 drivers/s390/char/raw3270.c         |    3 +-
 drivers/s390/char/sclp_cmd.c        |    4 +-
 drivers/s390/char/sclp_quiesce.c    |    3 +-
 drivers/s390/char/tape_34xx.c       |    1 +
 drivers/s390/char/tape_3590.c       |    1 +
 drivers/s390/char/tape_core.c       |    2 -
 drivers/s390/char/vmur.c            |    3 +-
 drivers/s390/char/zcore.c           |   21 +--
 drivers/s390/cio/ccwgroup.c         |  333 +++++++++++----------------
 drivers/s390/cio/ccwreq.c           |   23 ++-
 drivers/s390/cio/chsc_sch.c         |    5 +-
 drivers/s390/cio/cio.c              |   19 ++-
 drivers/s390/cio/css.h              |    2 +
 drivers/s390/cio/device.c           |   13 +
 drivers/s390/cio/device.h           |   13 +-
 drivers/s390/cio/io_sch.h           |    2 +
 drivers/s390/cio/qdio.h             |   40 +---
 drivers/s390/cio/qdio_debug.c       |   10 +-
 drivers/s390/cio/qdio_main.c        |  102 ++++-----
 drivers/s390/cio/qdio_thinint.c     |   52 ++++-
 drivers/s390/kvm/kvm_virtio.c       |    8 +-
 drivers/s390/net/claw.c             |    3 +-
 drivers/s390/net/ctcm_main.c        |    3 +-
 drivers/s390/net/ctcm_sysfs.c       |    2 +-
 drivers/s390/net/lcs.c              |    5 +-
 drivers/s390/net/qeth_l3_main.c     |    2 +-
 include/linux/crash_dump.h          |    1 +
 include/linux/elf.h                 |    1 +
 include/linux/kexec.h               |   10 +
 kernel/crash_dump.c                 |   11 +
 kernel/kexec.c                      |   41 +++-
 kernel/sysctl.c                     |    8 -
 107 files changed, 2236 insertions(+), 796 deletions(-)
 create mode 100644 arch/s390/kernel/crash_dump.c
 create mode 100644 arch/s390/kernel/head_kdump.S

