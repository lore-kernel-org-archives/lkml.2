Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2JAN45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:56:57 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53213 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2JAN4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:56:49 -0400
Date: Mon, 1 Oct 2012 15:56:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.7 merge window
Message-ID: <20121001155630.1f3ebcbb@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12100113-3548-0000-0000-00000341EB6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the updates for the 3.7 merge window. The main new feature is
machine support for System zEC12 including transactional memory, runtime
instrumentation, support for scm block devices via eadm subchannels, and
support for CEX4 crypto cards. 
In addition there are some nice improvements: bpf jit compiler, arch
backend for cmpxchg_double, relative exception table entries, dasd
partition detection independent from the dasd driver ioctls, and
cpu cache information in /proc/cpuinfo and /sys/device/cpu.
And last but not least a series of cleanup patches from Heiko.

Cornelia Huck (1):
      s390/kvm: Improve Kconfig help text.

Gerald Schaefer (2):
      s390: enable large page support with CONFIG_DEBUG_PAGEALLOC
      s390/mm: implement __get_user_pages_fast()

Heiko Carstens (46):
      s390/bpf,jit: improve code generation
      s390/string: provide asm lib functions for memcpy and memcmp
      s390/cache: expose cpu cache topology via sysfs
      s390/cpu hotplug: use hotcpu_notifier() instead of register_cpu_notifier()
      s390/smp: fix smp_find_processor_id() argument mismatch
      s390/cpu hotplug: mask out CPU_TASKS_FROZEN in cu hotplug notifiers
      s390/kexec: move machine_crash_shutdown() to machine_kexec.c
      s390/cache: add cpu cache information to /proc/cpuinfo
      s390/processor: use ARRAY_SIZE instead of hard coded value
      s390/smp: avoid concurrent write to sigp status field
      s390/mm: change default addressing mode
      s390/mm: rename addressing_mode to s390_user_mode
      s390/mm: shorten addressing mode initialization
      s390/topology: remove sysinfo header include, add forward declaration instead
      s390/sysinfo: convert /proc/sysinfo to seqfile
      s390/sysinfo: add additional z196 fields to output
      s390/sysinfo,topology: fix cpu topology maximum nesting detection
      s390/smp,topology: add polarization member to pcpu struct
      s390/exceptions: switch to relative exception table entries
      s390/sysinfo,stsi: change return code handling
      s390/dasd: fix return value for non-existent ioctls
      s390/sclp: use -EOPNOTSUPP instead of -ENOSYS
      s390/etr,stp: use -EOPNOTSUPP instead of -ENOSYS
      s390/kexec: change return value of machine_kexec_prepare
      s390/appldata: change return value of appldata_asm
      s390/vmlogrdr: change return value from -ENOSYS to -EOPNOTSUPP
      s390/syscalls: wire up kcmp system call
      s390/ap_bus: add missing ifdef
      s390/tape: remove even more tape block leftovers
      s390/perf_events: compile only for CONFIG_64BIT
      s390/ipl,decrompressor: disable branch profiling
      s390/ptrace: add missing ifdef
      s390/process: add missing header include
      s390/crashdump: move fill_cpu_elf_notes() prototype to header file
      s390: add uninitialized_var() to suppress false positive compiler warnings
      s390/irq: use designated initializers for irq class array
      s390/kexec: remove CONFIG_KEXEC
      s390/percpu: implement this_cpu_xchg()
      s390/percpu: implement this_cpu_add_return()
      s390/cmpxchg,percpu: implement cmpxchg_double()
      s390/mm: mark free_initrd_mem() as __init
      s390/traps: move call to print_modules() out of show_regs()
      s390/bpf,jit: add support for BPF_S_ANC_ALU_XOR_X instruction
      s390/disassembler: fix decoding of risblg instruction
      s390/jump label,nss: let shared kernel support depend on !JUMP_LABEL
      s390: update defconfig

Holger Dengler (5):
      s390/ap: configuration information exploitation
      s390/ap: Add functiton facility information as AP device attribute.
      s390/zcrypt: Separate msgtype implementation from card modules.
      s390/zcrypt: Add support for CEX4 crypto card
      s390/zcryt: Handle AP configuration changes

Jan Glauber (3):
      s390/kconfig: split the s390 base menu
      s390: add support for runtime instrumentation
      s390/qdio: fix truncated debug output of hex values

Jean Delvare (1):
      s390/3270: drop unused spinlock from struct con3270

Martin Schwidefsky (2):
      s390/bpf,jit: BPF Just In Time compiler for s390
      s390: add support for transactional memory

Peter Senna Tschudin (1):
      drivers/s390/char/monreader.c: fix error return code

Sebastian Ott (12):
      s390/css: export css_sched_sch_todo
      s390: add eadm facility bits
      s390: add eadm related structures
      s390/chsc: implement store SCM information
      s390: add scm bus driver
      s390: add scm notification
      s390/cio: add eadm subchannel driver
      s390/eadm_sch: add support for irq statistics
      s390: add scm block driver
      s390/scm_block: force cluster writes
      s390/scm: remove superfluous lock
      s390/scm: reorder scm_remove

Stefan Haberland (1):
      s390/dasd: check count address during online setting

Stefan Weinhuber (1):
      s390/partitions: make partition detection independent from DASD ioctls

Wei Yongjun (1):
      s390/topology: use for_each_set_bit to simplify the code

 arch/s390/Kbuild                       |    1 +
 arch/s390/Kconfig                      |  418 ++++++++--------
 arch/s390/boot/compressed/Makefile     |    1 +
 arch/s390/boot/compressed/misc.c       |   45 +-
 arch/s390/defconfig                    |   14 +-
 arch/s390/include/asm/appldata.h       |    2 +-
 arch/s390/include/asm/chsc.h           |   28 --
 arch/s390/include/asm/cio.h            |   28 +-
 arch/s390/include/asm/cmpxchg.h        |   61 +++
 arch/s390/include/asm/cpu_mf.h         |    4 +
 arch/s390/include/asm/css_chars.h      |   39 ++
 arch/s390/include/asm/eadm.h           |  124 +++++
 arch/s390/include/asm/elf.h            |    3 +
 arch/s390/include/asm/etr.h            |    8 +-
 arch/s390/include/asm/irq.h            |    2 +
 arch/s390/include/asm/isc.h            |    1 +
 arch/s390/include/asm/lowcore.h        |    6 +-
 arch/s390/include/asm/mmu_context.h    |    2 +-
 arch/s390/include/asm/percpu.h         |   50 +-
 arch/s390/include/asm/processor.h      |   59 ++-
 arch/s390/include/asm/ptrace.h         |   12 +-
 arch/s390/include/asm/runtime_instr.h  |   98 ++++
 arch/s390/include/asm/scsw.h           |   38 +-
 arch/s390/include/asm/setup.h          |    5 +-
 arch/s390/include/asm/smp.h            |    4 +-
 arch/s390/include/asm/string.h         |    8 -
 arch/s390/include/asm/switch_to.h      |    2 +
 arch/s390/include/asm/sysinfo.h        |   39 +-
 arch/s390/include/asm/topology.h       |   20 +-
 arch/s390/include/asm/uaccess.h        |   15 +-
 arch/s390/include/asm/unistd.h         |    4 +-
 arch/s390/kernel/Makefile              |   12 +-
 arch/s390/kernel/asm-offsets.c         |    2 +
 arch/s390/kernel/cache.c               |  385 ++++++++++++++
 arch/s390/kernel/compat_wrapper.S      |   13 +
 arch/s390/kernel/crash.c               |   14 -
 arch/s390/kernel/crash_dump.c          |    3 +-
 arch/s390/kernel/dis.c                 |   58 ++-
 arch/s390/kernel/early.c               |   38 +-
 arch/s390/kernel/entry64.S             |   17 +-
 arch/s390/kernel/irq.c                 |   56 ++-
 arch/s390/kernel/kprobes.c             |    2 +-
 arch/s390/kernel/lgr.c                 |   29 +-
 arch/s390/kernel/machine_kexec.c       |    9 +-
 arch/s390/kernel/process.c             |    8 +
 arch/s390/kernel/processor.c           |    7 +-
 arch/s390/kernel/ptrace.c              |   70 +++
 arch/s390/kernel/runtime_instr.c       |  150 ++++++
 arch/s390/kernel/s390_ksyms.c          |    2 +
 arch/s390/kernel/setup.c               |   54 +-
 arch/s390/kernel/smp.c                 |   46 +-
 arch/s390/kernel/syscalls.S            |    2 +
 arch/s390/kernel/sysinfo.c             |  351 ++++++-------
 arch/s390/kernel/time.c                |    4 +-
 arch/s390/kernel/topology.c            |   27 +-
 arch/s390/kernel/traps.c               |   41 +-
 arch/s390/kernel/vdso.c                |    8 +-
 arch/s390/kernel/vtime.c               |    3 +-
 arch/s390/kvm/Kconfig                  |    2 +-
 arch/s390/kvm/priv.c                   |    4 +-
 arch/s390/lib/Makefile                 |    3 +-
 arch/s390/lib/mem32.S                  |   92 ++++
 arch/s390/lib/mem64.S                  |   88 ++++
 arch/s390/lib/string.c                 |   56 +--
 arch/s390/mm/Makefile                  |    2 +-
 arch/s390/mm/extable.c                 |   81 +++
 arch/s390/mm/fault.c                   |    7 +-
 arch/s390/mm/gup.c                     |   37 ++
 arch/s390/mm/init.c                    |    4 +-
 arch/s390/mm/pgtable.c                 |    6 +-
 arch/s390/mm/vmem.c                    |    2 +-
 arch/s390/net/Makefile                 |    4 +
 arch/s390/net/bpf_jit.S                |  130 +++++
 arch/s390/net/bpf_jit_comp.c           |  776 +++++++++++++++++++++++++++++
 block/partitions/ibm.c                 |  455 ++++++++++-------
 drivers/s390/block/Kconfig             |   18 +
 drivers/s390/block/Makefile            |    6 +
 drivers/s390/block/dasd_eckd.c         |   21 +-
 drivers/s390/block/dasd_ioctl.c        |    4 +-
 drivers/s390/block/scm_blk.c           |  445 +++++++++++++++++
 drivers/s390/block/scm_blk.h           |  117 +++++
 drivers/s390/block/scm_blk_cluster.c   |  228 +++++++++
 drivers/s390/block/scm_drv.c           |   81 +++
 drivers/s390/char/con3270.c            |    1 -
 drivers/s390/char/monreader.c          |    5 +-
 drivers/s390/char/sclp.c               |    2 +-
 drivers/s390/char/sclp_rw.c            |    2 +-
 drivers/s390/char/tape.h               |    1 -
 drivers/s390/char/tape_std.h           |    4 -
 drivers/s390/char/vmlogrdr.c           |    2 +-
 drivers/s390/cio/Makefile              |    2 +
 drivers/s390/cio/chsc.c                |   52 ++
 drivers/s390/cio/chsc.h                |   43 ++
 drivers/s390/cio/cio.c                 |    2 +-
 drivers/s390/cio/css.c                 |    1 +
 drivers/s390/cio/eadm_sch.c            |  401 +++++++++++++++
 drivers/s390/cio/eadm_sch.h            |   20 +
 drivers/s390/cio/orb.h                 |   24 +
 drivers/s390/cio/qdio_debug.h          |   38 +-
 drivers/s390/cio/scm.c                 |  317 ++++++++++++
 drivers/s390/crypto/Makefile           |    3 +-
 drivers/s390/crypto/ap_bus.c           |  209 ++++++--
 drivers/s390/crypto/ap_bus.h           |   35 +-
 drivers/s390/crypto/zcrypt_api.c       |  187 ++++++-
 drivers/s390/crypto/zcrypt_api.h       |   19 +-
 drivers/s390/crypto/zcrypt_cex2a.c     |  371 +-------------
 drivers/s390/crypto/zcrypt_cex4.c      |  149 ++++++
 drivers/s390/crypto/zcrypt_cex4.h      |   12 +
 drivers/s390/crypto/zcrypt_debug.h     |   59 +++
 drivers/s390/crypto/zcrypt_error.h     |   13 +
 drivers/s390/crypto/zcrypt_msgtype50.c |  531 ++++++++++++++++++++
 drivers/s390/crypto/zcrypt_msgtype50.h |   39 ++
 drivers/s390/crypto/zcrypt_msgtype6.c  |  856 ++++++++++++++++++++++++++++++++
 drivers/s390/crypto/zcrypt_msgtype6.h  |  169 +++++++
 drivers/s390/crypto/zcrypt_pcixcc.c    |  781 +----------------------------
 drivers/s390/crypto/zcrypt_pcixcc.h    |    3 +-
 drivers/s390/net/qeth_core_main.c      |   15 +-
 include/linux/elf.h                    |    1 +
 scripts/sortextable.c                  |   10 +-
 119 files changed, 7415 insertions(+), 2185 deletions(-)
 create mode 100644 arch/s390/include/asm/css_chars.h
 create mode 100644 arch/s390/include/asm/eadm.h
 create mode 100644 arch/s390/include/asm/runtime_instr.h
 create mode 100644 arch/s390/kernel/cache.c
 delete mode 100644 arch/s390/kernel/crash.c
 create mode 100644 arch/s390/kernel/runtime_instr.c
 create mode 100644 arch/s390/lib/mem32.S
 create mode 100644 arch/s390/lib/mem64.S
 create mode 100644 arch/s390/mm/extable.c
 create mode 100644 arch/s390/net/Makefile
 create mode 100644 arch/s390/net/bpf_jit.S
 create mode 100644 arch/s390/net/bpf_jit_comp.c
 create mode 100644 drivers/s390/block/scm_blk.c
 create mode 100644 drivers/s390/block/scm_blk.h
 create mode 100644 drivers/s390/block/scm_blk_cluster.c
 create mode 100644 drivers/s390/block/scm_drv.c
 create mode 100644 drivers/s390/cio/eadm_sch.c
 create mode 100644 drivers/s390/cio/eadm_sch.h
 create mode 100644 drivers/s390/cio/scm.c
 create mode 100644 drivers/s390/crypto/zcrypt_cex4.c
 create mode 100644 drivers/s390/crypto/zcrypt_cex4.h
 create mode 100644 drivers/s390/crypto/zcrypt_debug.h
 create mode 100644 drivers/s390/crypto/zcrypt_msgtype50.c
 create mode 100644 drivers/s390/crypto/zcrypt_msgtype50.h
 create mode 100644 drivers/s390/crypto/zcrypt_msgtype6.c
 create mode 100644 drivers/s390/crypto/zcrypt_msgtype6.h

