Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1AGJXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:23:36 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:51792 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1AGJXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:23:33 -0500
Date: Fri, 7 Jan 2011 10:23:29 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.38
Message-ID: <20110107102329.381c7d56@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
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

Felix Beck (6):
      [S390] zcrypt: Fix check to look for facility bits 2 & 65
      [S390] zcrypt: Introduce check for 4096 bit support.
      [S390] zcrypt: support for 4096 bit keys for cex3a
      [S390] zcrypt: support for 4096 bit keys for cex3c
      [S390] zcrypt: cope with cca restriction of cex3
      [S390] Handling of 4096 bit RSA keys in CRT format.

Gerald Schaefer (2):
      [S390] mutex: Introduce arch_mutex_cpu_relax()
      [S390] mutex: enable spinning mutex on s390

Heiko Carstens (22):
      [S390] time: move local_tick_enable()/disable() to timex.h
      [S390] time: let local_tick_enable/disable() reprogram the clock comparator
      [S390] irq: have detailed statistics for interrupt types
      [S390] dasd: add support for irq statistics
      [S390] 3215: add support for irq statistics
      [S390] 3270: add support for irq statistics
      [S390] tape: add support for irq statistics
      [S390] vmur: add support for irq statistics
      [S390] lcs: add support for irq statistics
      [S390] claw: add support for irq statistics
      [S390] ctc: add support for irq statistics
      [S390] pfault: delay register of pfault interrupt
      [S390] sclp: use register_external_interrupt()
      [S390] extint: get rid of early code plus cleanup
      [S390] nohz: optimize arch_needs_cpu()
      [S390] nmi: enable machine checks early
      [S390] smp: delay idle task creation
      [S390] smp/idle: call init_idle() before starting a new cpu
      [S390] perf: add DWARF register lookup for s390
      [S390] smp: remove cpu hotplug messages
      [S390] cpuinfo: use get_online_cpus() instead of preempt_disable()
      [S390] prevent unneccesary loops_per_jiffy recalculation

Holger Dengler (1):
      [S390] ap bus: add support for irq statistics

Jan Glauber (8):
      [S390] qdio: add qdio interrupts to interrupt statistics
      [S390] qdio: prevent race for shared indicators
      [S390] qdio: outbound tasklet scan threshold
      [S390] qdio: outbound queue full counter
      [S390] qdio: use proper QEBSM operand for SIGA-R and SIGA-S
      [S390] qdio: remove enhanced SIGA
      [S390] qdio: cleanup SIGA sync
      [S390] qeth: buffer count imbalance

Martin Schwidefsky (15):
      [S390] cleanup s390 Kconfig
      [S390] kprobes: single stepped breakpoint
      [S390] kprobes: single step cleanup
      [S390] kprobes: instruction swap
      [S390] kprobes: instruction fixup
      [S390] kprobes: activation and deactivation
      [S390] kprobes: insn slots
      [S390] kprobes: jprobe save and restore
      [S390] kprobes: restructure handler function
      [S390] kprobes: coding style
      [S390] add kprobes annotations
      [S390] current_thread_info optimization
      [S390] 31 bit entry.S update.
      [S390] ptrace cleanup
      [S390] cleanup ftrace backend functions

Michael Holzheu (1):
      [S390] hypfs: Move buffer allocation from open to read

Peter Oberparleiter (1):
      [S390] cio: fix ccwgroup unregistration race condition

Sebastian Ott (2):
      [S390] cio: obtain mdc value per channel path
      [S390] css: update subchannel descriptor

Stefan Haberland (3):
      [S390] dasd: Prevent deadlock during suspend/resume.
      [S390] dasd: Add support for raw ECKD access.
      [S390] dasd: Correct retry counter for terminated I/O.

Stefan Weinhuber (4):
      [S390] cio: reduce memory consumption of itcw structures
      [S390] dasd: add High Performance FICON multitrack support
      [S390] dasd: do path verification for paths added at runtime
      [S390] dasd: Improve handling of stolen DASD reservation

 arch/Kconfig                           |    3 +
 arch/s390/Kconfig                      |  131 ++++---
 arch/s390/Kconfig.debug                |    6 +-
 arch/s390/defconfig                    |  152 +++-----
 arch/s390/hypfs/Makefile               |    2 +-
 arch/s390/hypfs/hypfs.h                |   33 ++-
 arch/s390/hypfs/hypfs_dbfs.c           |  116 ++++++
 arch/s390/hypfs/hypfs_diag.c           |   82 +---
 arch/s390/hypfs/hypfs_vm.c             |   62 +--
 arch/s390/hypfs/inode.c                |   18 +-
 arch/s390/include/asm/ccwdev.h         |    2 +
 arch/s390/include/asm/cputime.h        |    2 +-
 arch/s390/include/asm/dasd.h           |    3 +
 arch/s390/include/asm/ftrace.h         |   11 +-
 arch/s390/include/asm/hardirq.h        |   16 -
 arch/s390/include/asm/irq.h            |   34 +-
 arch/s390/include/asm/kprobes.h        |   20 +-
 arch/s390/include/asm/mutex.h          |    2 +
 arch/s390/include/asm/processor.h      |    4 +-
 arch/s390/include/asm/ptrace.h         |   52 +++-
 arch/s390/include/asm/qdio.h           |    1 +
 arch/s390/include/asm/s390_ext.h       |   29 +-
 arch/s390/include/asm/smp.h            |    3 +-
 arch/s390/include/asm/system.h         |    4 +-
 arch/s390/include/asm/thread_info.h    |   10 +-
 arch/s390/include/asm/timex.h          |   20 +
 arch/s390/kernel/asm-offsets.c         |   14 +-
 arch/s390/kernel/compat_ptrace.h       |   53 +--
 arch/s390/kernel/entry.S               |  274 +++++++-------
 arch/s390/kernel/entry.h               |    2 +-
 arch/s390/kernel/entry64.S             |   73 ++--
 arch/s390/kernel/ftrace.c              |  238 ++++++------
 arch/s390/kernel/irq.c                 |   41 ++-
 arch/s390/kernel/kprobes.c             |  470 +++++++++++------------
 arch/s390/kernel/mcount.S              |   32 +--
 arch/s390/kernel/mcount64.S            |   29 +-
 arch/s390/kernel/nmi.c                 |    3 +-
 arch/s390/kernel/process.c             |   21 +-
 arch/s390/kernel/processor.c           |   20 +-
 arch/s390/kernel/ptrace.c              |  306 +++++++++------
 arch/s390/kernel/s390_ext.c            |  125 +++----
 arch/s390/kernel/signal.c              |    2 +-
 arch/s390/kernel/smp.c                 |   47 ++-
 arch/s390/kernel/time.c                |    6 +-
 arch/s390/kernel/traps.c               |   15 +-
 arch/s390/kernel/vtime.c               |    6 +-
 arch/s390/kvm/Kconfig                  |    7 +-
 arch/s390/lib/delay.c                  |    2 -
 arch/s390/mm/fault.c                   |   35 +-
 drivers/s390/block/Kconfig             |   24 +-
 drivers/s390/block/dasd.c              |  314 +++++++++++-----
 drivers/s390/block/dasd_3990_erp.c     |   16 +-
 drivers/s390/block/dasd_devmap.c       |  155 ++++++++-
 drivers/s390/block/dasd_diag.c         |    3 +
 drivers/s390/block/dasd_eckd.c         |  664 ++++++++++++++++++++++++++-----
 drivers/s390/block/dasd_eckd.h         |   17 +-
 drivers/s390/block/dasd_eer.c          |    1 +
 drivers/s390/block/dasd_erp.c          |    3 +-
 drivers/s390/block/dasd_fba.c          |   21 +-
 drivers/s390/block/dasd_int.h          |   35 ++-
 drivers/s390/char/Kconfig              |   69 ++--
 drivers/s390/char/con3215.c            |    2 +
 drivers/s390/char/raw3270.c            |    2 +
 drivers/s390/char/sclp.c               |   18 +-
 drivers/s390/char/sclp_config.c        |    1 +
 drivers/s390/char/tape_core.c          |    2 +
 drivers/s390/char/vmur.c               |    2 +
 drivers/s390/cio/ccwgroup.c            |   78 ++--
 drivers/s390/cio/chsc.c                |   19 +
 drivers/s390/cio/chsc.h                |   18 +
 drivers/s390/cio/css.c                 |    8 +
 drivers/s390/cio/device_ops.c          |   40 ++
 drivers/s390/cio/itcw.c                |   62 +++-
 drivers/s390/cio/qdio.h                |   31 +-
 drivers/s390/cio/qdio_debug.c          |    1 +
 drivers/s390/cio/qdio_main.c           |  177 ++++-----
 drivers/s390/cio/qdio_setup.c          |   20 +-
 drivers/s390/cio/qdio_thinint.c        |   56 +---
 drivers/s390/crypto/ap_bus.c           |   67 ++++-
 drivers/s390/crypto/ap_bus.h           |    2 +
 drivers/s390/crypto/zcrypt_api.c       |   12 +-
 drivers/s390/crypto/zcrypt_api.h       |    1 +
 drivers/s390/crypto/zcrypt_cex2a.c     |   82 ++++-
 drivers/s390/crypto/zcrypt_cex2a.h     |   25 ++
 drivers/s390/crypto/zcrypt_pcica.c     |    1 +
 drivers/s390/crypto/zcrypt_pcicc.c     |    1 +
 drivers/s390/crypto/zcrypt_pcixcc.c    |   17 +-
 drivers/s390/kvm/kvm_virtio.c          |    3 +
 drivers/s390/net/Kconfig               |   51 ++-
 drivers/s390/net/claw.c                |    2 +
 drivers/s390/net/ctcm_main.c           |    2 +
 drivers/s390/net/lcs.c                 |    2 +
 drivers/s390/net/qeth_core_main.c      |    4 +-
 drivers/s390/scsi/zfcp_qdio.c          |    2 +
 include/linux/mutex.h                  |    4 +
 kernel/mutex.c                         |    2 +-
 kernel/sched.c                         |    3 +-
 net/iucv/iucv.c                        |    2 +
 tools/perf/arch/s390/Makefile          |    4 +
 tools/perf/arch/s390/util/dwarf-regs.c |   22 +
 100 files changed, 3006 insertions(+), 1803 deletions(-)
 create mode 100644 arch/s390/hypfs/hypfs_dbfs.c
 create mode 100644 tools/perf/arch/s390/Makefile
 create mode 100644 tools/perf/arch/s390/util/dwarf-regs.c

