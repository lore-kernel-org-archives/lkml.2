Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1CQBbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:31:18 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:38199 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab1CQBbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:31:09 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: [GIT PULL] UniCore32 ISA support for linux-2.6
Date: Thu, 17 Mar 2011 09:30:23 +0800
Message-ID: <000301cbe442$e393cd80$aabb6880$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvkQly+twAfIKzPS6qZJaxCcaG34A==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
  Could you please pull from:
    git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git for_linus
  to add unicore32 support for linux-2.6.

UniCore32 ISA is defined and developed by Micro-Processor R&D Center of
Peking University, and over the years, the CPUs and SoCs using UniCore32
ISA have been successfully applied in a variety of products in China.

  Thanks & regards,

Guan Xuetao


GuanXuetao (40):
  asm-generic: fix inX/outX functions for architectures that have PCI
  asm-generic headers: add sizes.h
  asm-generic headers: add ftrace.h
  asm-generic headers: add arch-specific __strnlen_user calling in
    uaccess.h
  unicore32 core architecture: build infrastructure
  unicore32 core architecture: generic elf and ksyms stuff
  unicore32 core architecture: processor and system headers
  unicore32 core architecture: low level entry and setup codes
  unicore32 core architecture: process/thread related codes
  unicore32 core architecture: mm related: generic codes
  unicore32 core architecture: mm related: fault handling
  unicore32 core architecture: mm related: consistent device DMA
    handling
  unicore32 core architecture: timer and time handling
  unicore32 core architecture: interrupts ang gpio handling
  unicore32 core architecture: signals handling
  unicore32 additional architecture files: pm related files
  unicore32 additional architecture files: float point handling
  unicore32 additional architecture files: ptrace handling
  unicore32 additional architecture files: low-level lib: ocd debug
  unicore32 additional architecture files: low-level lib: uaccess
  unicore32 additional architecture files: low-level lib: misc
  unicore32 additional architecture files: boot process
  unicore32 machine related files: core files
  unicore32 machine related files: hardware registers
  unicore32 machine related files: pci bus handling
  unicore32 machine related files: ps2 driver
  unicore32: ADD MAINTAINER for unicore32 architecture
  unicore32 time.c: change calculate method for clock_event_device
  unicore32: remove unused lines in arch/unicore32/include/asm/irq.h
  unicore32: modify function names and parameters for irq_chips
  unicore32: rename PKUNITY_IOSPACE_BASE to PKUNITY_MMIO_BASE
  unicore32 i8042: adjust io funcs of i8042-unicore32io.h
  unicore32 upgrade to v2.6.38-rc5: add one more paramter for
    pte_alloc_map call
  unicore32 i8042 upgrade and bugfix: adjust resource request region
    type
  unicore32 io: redefine __REG(x) and re-use readl/writel funcs
  unicore32 machine related files: add i2c bus drivers for pkunity-v3
    soc
  unicore32 machine related: add frame buffer driver for pkunity-v3 soc
  unicore32: replace unicore32-specific iomap functions with generic
    lib implementation
  unicore32: modify io_p2v and io_v2p macros, and adjust
    PKUNITY_mmio_BASEs
  unicore32: rewrite arch-specific tlb.h to use asm-generic version

 MAINTAINERS                                   |   16 +
 arch/unicore32/.gitignore                     |   21 +
 arch/unicore32/Kconfig                        |  275 ++++++++
 arch/unicore32/Kconfig.debug                  |   68 ++
 arch/unicore32/Makefile                       |   95 +++
 arch/unicore32/boot/Makefile                  |   47 ++
 arch/unicore32/boot/compressed/Makefile       |   68 ++
 arch/unicore32/boot/compressed/head.S         |  204 ++++++
 arch/unicore32/boot/compressed/misc.c         |  126 ++++
 arch/unicore32/boot/compressed/piggy.S.in     |    6 +
 arch/unicore32/boot/compressed/vmlinux.lds.in |   61 ++
 arch/unicore32/configs/debug_defconfig        |  215 +++++++
 arch/unicore32/include/asm/Kbuild             |    2 +
 arch/unicore32/include/asm/assembler.h        |  131 ++++
 arch/unicore32/include/asm/bitops.h           |   47 ++
 arch/unicore32/include/asm/byteorder.h        |   24 +
 arch/unicore32/include/asm/cache.h            |   27 +
 arch/unicore32/include/asm/cacheflush.h       |  211 ++++++
 arch/unicore32/include/asm/checksum.h         |   41 ++
 arch/unicore32/include/asm/cpu-single.h       |   45 ++
 arch/unicore32/include/asm/cputype.h          |   33 +
 arch/unicore32/include/asm/delay.h            |   52 ++
 arch/unicore32/include/asm/dma-mapping.h      |  124 ++++
 arch/unicore32/include/asm/dma.h              |   23 +
 arch/unicore32/include/asm/elf.h              |   94 +++
 arch/unicore32/include/asm/fpstate.h          |   26 +
 arch/unicore32/include/asm/fpu-ucf64.h        |   53 ++
 arch/unicore32/include/asm/futex.h            |  143 +++++
 arch/unicore32/include/asm/gpio.h             |  104 +++
 arch/unicore32/include/asm/hwcap.h            |   32 +
 arch/unicore32/include/asm/io.h               |   55 ++
 arch/unicore32/include/asm/irq.h              |  105 +++
 arch/unicore32/include/asm/irqflags.h         |   53 ++
 arch/unicore32/include/asm/linkage.h          |   22 +
 arch/unicore32/include/asm/memblock.h         |   46 ++
 arch/unicore32/include/asm/memory.h           |  123 ++++
 arch/unicore32/include/asm/mmu.h              |   17 +
 arch/unicore32/include/asm/mmu_context.h      |   87 +++
 arch/unicore32/include/asm/mutex.h            |   20 +
 arch/unicore32/include/asm/page.h             |   80 +++
 arch/unicore32/include/asm/pci.h              |   46 ++
 arch/unicore32/include/asm/pgalloc.h          |  110 ++++
 arch/unicore32/include/asm/pgtable-hwdef.h    |   55 ++
 arch/unicore32/include/asm/pgtable.h          |  317 +++++++++
 arch/unicore32/include/asm/processor.h        |   92 +++
 arch/unicore32/include/asm/ptrace.h           |  133 ++++
 arch/unicore32/include/asm/sigcontext.h       |   29 +
 arch/unicore32/include/asm/stacktrace.h       |   31 +
 arch/unicore32/include/asm/string.h           |   38 ++
 arch/unicore32/include/asm/suspend.h          |   30 +
 arch/unicore32/include/asm/system.h           |  161 +++++
 arch/unicore32/include/asm/thread_info.h      |  154 +++++
 arch/unicore32/include/asm/timex.h            |   34 +
 arch/unicore32/include/asm/tlb.h              |   28 +
 arch/unicore32/include/asm/tlbflush.h         |  195 ++++++
 arch/unicore32/include/asm/traps.h            |   21 +
 arch/unicore32/include/asm/uaccess.h          |   47 ++
 arch/unicore32/include/asm/unistd.h           |   18 +
 arch/unicore32/include/mach/PKUnity.h         |  108 ++++
 arch/unicore32/include/mach/bitfield.h        |   24 +
 arch/unicore32/include/mach/dma.h             |   48 ++
 arch/unicore32/include/mach/hardware.h        |   38 ++
 arch/unicore32/include/mach/map.h             |   20 +
 arch/unicore32/include/mach/memory.h          |   58 ++
 arch/unicore32/include/mach/ocd.h             |   36 +
 arch/unicore32/include/mach/pm.h              |   43 ++
 arch/unicore32/include/mach/regs-ac97.h       |   32 +
 arch/unicore32/include/mach/regs-dmac.h       |   81 +++
 arch/unicore32/include/mach/regs-gpio.h       |   70 ++
 arch/unicore32/include/mach/regs-i2c.h        |   63 ++
 arch/unicore32/include/mach/regs-intc.h       |   28 +
 arch/unicore32/include/mach/regs-nand.h       |   79 +++
 arch/unicore32/include/mach/regs-ost.h        |   92 +++
 arch/unicore32/include/mach/regs-pci.h        |   94 +++
 arch/unicore32/include/mach/regs-pm.h         |  126 ++++
 arch/unicore32/include/mach/regs-ps2.h        |   20 +
 arch/unicore32/include/mach/regs-resetc.h     |   34 +
 arch/unicore32/include/mach/regs-rtc.h        |   37 ++
 arch/unicore32/include/mach/regs-sdc.h        |  156 +++++
 arch/unicore32/include/mach/regs-spi.h        |   98 +++
 arch/unicore32/include/mach/regs-uart.h       |    3 +
 arch/unicore32/include/mach/regs-umal.h       |  229 +++++++
 arch/unicore32/include/mach/regs-unigfx.h     |  200 ++++++
 arch/unicore32/include/mach/uncompress.h      |   34 +
 arch/unicore32/kernel/Makefile                |   33 +
 arch/unicore32/kernel/asm-offsets.c           |  112 ++++
 arch/unicore32/kernel/clock.c                 |  390 ++++++++++++
 arch/unicore32/kernel/cpu-ucv2.c              |   93 +++
 arch/unicore32/kernel/debug-macro.S           |   89 +++
 arch/unicore32/kernel/debug.S                 |   85 +++
 arch/unicore32/kernel/dma.c                   |  183 ++++++
 arch/unicore32/kernel/early_printk.c          |   59 ++
 arch/unicore32/kernel/elf.c                   |   38 ++
 arch/unicore32/kernel/entry.S                 |  824 ++++++++++++++++++++++++
 arch/unicore32/kernel/fpu-ucf64.c             |  126 ++++
 arch/unicore32/kernel/gpio.c                  |  122 ++++
 arch/unicore32/kernel/head.S                  |  252 ++++++++
 arch/unicore32/kernel/hibernate.c             |  160 +++++
 arch/unicore32/kernel/hibernate_asm.S         |  117 ++++
 arch/unicore32/kernel/init_task.c             |   44 ++
 arch/unicore32/kernel/irq.c                   |  426 +++++++++++++
 arch/unicore32/kernel/ksyms.c                 |   99 +++
 arch/unicore32/kernel/ksyms.h                 |   15 +
 arch/unicore32/kernel/module.c                |  152 +++++
 arch/unicore32/kernel/pci.c                   |  404 ++++++++++++
 arch/unicore32/kernel/pm.c                    |  123 ++++
 arch/unicore32/kernel/process.c               |  389 ++++++++++++
 arch/unicore32/kernel/ptrace.c                |  149 +++++
 arch/unicore32/kernel/puv3-core.c             |  285 +++++++++
 arch/unicore32/kernel/puv3-nb0916.c           |  145 +++++
 arch/unicore32/kernel/pwm.c                   |  263 ++++++++
 arch/unicore32/kernel/rtc.c                   |  380 +++++++++++
 arch/unicore32/kernel/setup.c                 |  360 +++++++++++
 arch/unicore32/kernel/setup.h                 |   30 +
 arch/unicore32/kernel/signal.c                |  494 +++++++++++++++
 arch/unicore32/kernel/sleep.S                 |  202 ++++++
 arch/unicore32/kernel/stacktrace.c            |  131 ++++
 arch/unicore32/kernel/sys.c                   |  126 ++++
 arch/unicore32/kernel/time.c                  |  143 +++++
 arch/unicore32/kernel/traps.c                 |  333 ++++++++++
 arch/unicore32/kernel/vmlinux.lds.S           |   61 ++
 arch/unicore32/lib/Makefile                   |   27 +
 arch/unicore32/lib/backtrace.S                |  163 +++++
 arch/unicore32/lib/clear_user.S               |   57 ++
 arch/unicore32/lib/copy_from_user.S           |  108 ++++
 arch/unicore32/lib/copy_page.S                |   39 ++
 arch/unicore32/lib/copy_template.S            |  214 +++++++
 arch/unicore32/lib/copy_to_user.S             |   96 +++
 arch/unicore32/lib/delay.S                    |   51 ++
 arch/unicore32/lib/findbit.S                  |   98 +++
 arch/unicore32/lib/strncpy_from_user.S        |   45 ++
 arch/unicore32/lib/strnlen_user.S             |   42 ++
 arch/unicore32/mm/Kconfig                     |   50 ++
 arch/unicore32/mm/Makefile                    |   15 +
 arch/unicore32/mm/alignment.c                 |  523 +++++++++++++++
 arch/unicore32/mm/cache-ucv2.S                |  212 ++++++
 arch/unicore32/mm/dma-swiotlb.c               |   34 +
 arch/unicore32/mm/extable.c                   |   24 +
 arch/unicore32/mm/fault.c                     |  479 ++++++++++++++
 arch/unicore32/mm/flush.c                     |   98 +++
 arch/unicore32/mm/init.c                      |  517 +++++++++++++++
 arch/unicore32/mm/ioremap.c                   |  261 ++++++++
 arch/unicore32/mm/mm.h                        |   39 ++
 arch/unicore32/mm/mmu.c                       |  533 ++++++++++++++++
 arch/unicore32/mm/pgd.c                       |  102 +++
 arch/unicore32/mm/proc-macros.S               |  145 +++++
 arch/unicore32/mm/proc-syms.c                 |   23 +
 arch/unicore32/mm/proc-ucv2.S                 |  134 ++++
 arch/unicore32/mm/tlb-ucv2.S                  |   89 +++
 drivers/i2c/busses/Kconfig                    |   11 +
 drivers/i2c/busses/Makefile                   |    1 +
 drivers/i2c/busses/i2c-puv3.c                 |  306 +++++++++
 drivers/input/serio/i8042-unicore32io.h       |   73 +++
 drivers/input/serio/i8042.h                   |    2 +
 drivers/pci/Makefile                          |    1 +
 drivers/video/Kconfig                         |   11 +
 drivers/video/Makefile                        |    1 +
 drivers/video/fb-puv3.c                       |  846 +++++++++++++++++++++++++
 include/asm-generic/ftrace.h                  |   16 +
 include/asm-generic/io.h                      |   33 +-
 include/asm-generic/sizes.h                   |   47 ++
 include/asm-generic/uaccess.h                 |    8 +-
 include/linux/fb.h                            |    2 +
 163 files changed, 19408 insertions(+), 17 deletions(-)
 create mode 100644 arch/unicore32/.gitignore
 create mode 100644 arch/unicore32/Kconfig
 create mode 100644 arch/unicore32/Kconfig.debug
 create mode 100644 arch/unicore32/Makefile
 create mode 100644 arch/unicore32/boot/Makefile
 create mode 100644 arch/unicore32/boot/compressed/Makefile
 create mode 100644 arch/unicore32/boot/compressed/head.S
 create mode 100644 arch/unicore32/boot/compressed/misc.c
 create mode 100644 arch/unicore32/boot/compressed/piggy.S.in
 create mode 100644 arch/unicore32/boot/compressed/vmlinux.lds.in
 create mode 100644 arch/unicore32/configs/debug_defconfig
 create mode 100644 arch/unicore32/include/asm/Kbuild
 create mode 100644 arch/unicore32/include/asm/assembler.h
 create mode 100644 arch/unicore32/include/asm/bitops.h
 create mode 100644 arch/unicore32/include/asm/byteorder.h
 create mode 100644 arch/unicore32/include/asm/cache.h
 create mode 100644 arch/unicore32/include/asm/cacheflush.h
 create mode 100644 arch/unicore32/include/asm/checksum.h
 create mode 100644 arch/unicore32/include/asm/cpu-single.h
 create mode 100644 arch/unicore32/include/asm/cputype.h
 create mode 100644 arch/unicore32/include/asm/delay.h
 create mode 100644 arch/unicore32/include/asm/dma-mapping.h
 create mode 100644 arch/unicore32/include/asm/dma.h
 create mode 100644 arch/unicore32/include/asm/elf.h
 create mode 100644 arch/unicore32/include/asm/fpstate.h
 create mode 100644 arch/unicore32/include/asm/fpu-ucf64.h
 create mode 100644 arch/unicore32/include/asm/futex.h
 create mode 100644 arch/unicore32/include/asm/gpio.h
 create mode 100644 arch/unicore32/include/asm/hwcap.h
 create mode 100644 arch/unicore32/include/asm/io.h
 create mode 100644 arch/unicore32/include/asm/irq.h
 create mode 100644 arch/unicore32/include/asm/irqflags.h
 create mode 100644 arch/unicore32/include/asm/linkage.h
 create mode 100644 arch/unicore32/include/asm/memblock.h
 create mode 100644 arch/unicore32/include/asm/memory.h
 create mode 100644 arch/unicore32/include/asm/mmu.h
 create mode 100644 arch/unicore32/include/asm/mmu_context.h
 create mode 100644 arch/unicore32/include/asm/mutex.h
 create mode 100644 arch/unicore32/include/asm/page.h
 create mode 100644 arch/unicore32/include/asm/pci.h
 create mode 100644 arch/unicore32/include/asm/pgalloc.h
 create mode 100644 arch/unicore32/include/asm/pgtable-hwdef.h
 create mode 100644 arch/unicore32/include/asm/pgtable.h
 create mode 100644 arch/unicore32/include/asm/processor.h
 create mode 100644 arch/unicore32/include/asm/ptrace.h
 create mode 100644 arch/unicore32/include/asm/sigcontext.h
 create mode 100644 arch/unicore32/include/asm/stacktrace.h
 create mode 100644 arch/unicore32/include/asm/string.h
 create mode 100644 arch/unicore32/include/asm/suspend.h
 create mode 100644 arch/unicore32/include/asm/system.h
 create mode 100644 arch/unicore32/include/asm/thread_info.h
 create mode 100644 arch/unicore32/include/asm/timex.h
 create mode 100644 arch/unicore32/include/asm/tlb.h
 create mode 100644 arch/unicore32/include/asm/tlbflush.h
 create mode 100644 arch/unicore32/include/asm/traps.h
 create mode 100644 arch/unicore32/include/asm/uaccess.h
 create mode 100644 arch/unicore32/include/asm/unistd.h
 create mode 100644 arch/unicore32/include/mach/PKUnity.h
 create mode 100644 arch/unicore32/include/mach/bitfield.h
 create mode 100644 arch/unicore32/include/mach/dma.h
 create mode 100644 arch/unicore32/include/mach/hardware.h
 create mode 100644 arch/unicore32/include/mach/map.h
 create mode 100644 arch/unicore32/include/mach/memory.h
 create mode 100644 arch/unicore32/include/mach/ocd.h
 create mode 100644 arch/unicore32/include/mach/pm.h
 create mode 100644 arch/unicore32/include/mach/regs-ac97.h
 create mode 100644 arch/unicore32/include/mach/regs-dmac.h
 create mode 100644 arch/unicore32/include/mach/regs-gpio.h
 create mode 100644 arch/unicore32/include/mach/regs-i2c.h
 create mode 100644 arch/unicore32/include/mach/regs-intc.h
 create mode 100644 arch/unicore32/include/mach/regs-nand.h
 create mode 100644 arch/unicore32/include/mach/regs-ost.h
 create mode 100644 arch/unicore32/include/mach/regs-pci.h
 create mode 100644 arch/unicore32/include/mach/regs-pm.h
 create mode 100644 arch/unicore32/include/mach/regs-ps2.h
 create mode 100644 arch/unicore32/include/mach/regs-resetc.h
 create mode 100644 arch/unicore32/include/mach/regs-rtc.h
 create mode 100644 arch/unicore32/include/mach/regs-sdc.h
 create mode 100644 arch/unicore32/include/mach/regs-spi.h
 create mode 100644 arch/unicore32/include/mach/regs-uart.h
 create mode 100644 arch/unicore32/include/mach/regs-umal.h
 create mode 100644 arch/unicore32/include/mach/regs-unigfx.h
 create mode 100644 arch/unicore32/include/mach/uncompress.h
 create mode 100644 arch/unicore32/kernel/Makefile
 create mode 100644 arch/unicore32/kernel/asm-offsets.c
 create mode 100644 arch/unicore32/kernel/clock.c
 create mode 100644 arch/unicore32/kernel/cpu-ucv2.c
 create mode 100644 arch/unicore32/kernel/debug-macro.S
 create mode 100644 arch/unicore32/kernel/debug.S
 create mode 100644 arch/unicore32/kernel/dma.c
 create mode 100644 arch/unicore32/kernel/early_printk.c
 create mode 100644 arch/unicore32/kernel/elf.c
 create mode 100644 arch/unicore32/kernel/entry.S
 create mode 100644 arch/unicore32/kernel/fpu-ucf64.c
 create mode 100644 arch/unicore32/kernel/gpio.c
 create mode 100644 arch/unicore32/kernel/head.S
 create mode 100644 arch/unicore32/kernel/hibernate.c
 create mode 100644 arch/unicore32/kernel/hibernate_asm.S
 create mode 100644 arch/unicore32/kernel/init_task.c
 create mode 100644 arch/unicore32/kernel/irq.c
 create mode 100644 arch/unicore32/kernel/ksyms.c
 create mode 100644 arch/unicore32/kernel/ksyms.h
 create mode 100644 arch/unicore32/kernel/module.c
 create mode 100644 arch/unicore32/kernel/pci.c
 create mode 100644 arch/unicore32/kernel/pm.c
 create mode 100644 arch/unicore32/kernel/process.c
 create mode 100644 arch/unicore32/kernel/ptrace.c
 create mode 100644 arch/unicore32/kernel/puv3-core.c
 create mode 100644 arch/unicore32/kernel/puv3-nb0916.c
 create mode 100644 arch/unicore32/kernel/pwm.c
 create mode 100644 arch/unicore32/kernel/rtc.c
 create mode 100644 arch/unicore32/kernel/setup.c
 create mode 100644 arch/unicore32/kernel/setup.h
 create mode 100644 arch/unicore32/kernel/signal.c
 create mode 100644 arch/unicore32/kernel/sleep.S
 create mode 100644 arch/unicore32/kernel/stacktrace.c
 create mode 100644 arch/unicore32/kernel/sys.c
 create mode 100644 arch/unicore32/kernel/time.c
 create mode 100644 arch/unicore32/kernel/traps.c
 create mode 100644 arch/unicore32/kernel/vmlinux.lds.S
 create mode 100644 arch/unicore32/lib/Makefile
 create mode 100644 arch/unicore32/lib/backtrace.S
 create mode 100644 arch/unicore32/lib/clear_user.S
 create mode 100644 arch/unicore32/lib/copy_from_user.S
 create mode 100644 arch/unicore32/lib/copy_page.S
 create mode 100644 arch/unicore32/lib/copy_template.S
 create mode 100644 arch/unicore32/lib/copy_to_user.S
 create mode 100644 arch/unicore32/lib/delay.S
 create mode 100644 arch/unicore32/lib/findbit.S
 create mode 100644 arch/unicore32/lib/strncpy_from_user.S
 create mode 100644 arch/unicore32/lib/strnlen_user.S
 create mode 100644 arch/unicore32/mm/Kconfig
 create mode 100644 arch/unicore32/mm/Makefile
 create mode 100644 arch/unicore32/mm/alignment.c
 create mode 100644 arch/unicore32/mm/cache-ucv2.S
 create mode 100644 arch/unicore32/mm/dma-swiotlb.c
 create mode 100644 arch/unicore32/mm/extable.c
 create mode 100644 arch/unicore32/mm/fault.c
 create mode 100644 arch/unicore32/mm/flush.c
 create mode 100644 arch/unicore32/mm/init.c
 create mode 100644 arch/unicore32/mm/ioremap.c
 create mode 100644 arch/unicore32/mm/mm.h
 create mode 100644 arch/unicore32/mm/mmu.c
 create mode 100644 arch/unicore32/mm/pgd.c
 create mode 100644 arch/unicore32/mm/proc-macros.S
 create mode 100644 arch/unicore32/mm/proc-syms.c
 create mode 100644 arch/unicore32/mm/proc-ucv2.S
 create mode 100644 arch/unicore32/mm/tlb-ucv2.S
 create mode 100644 drivers/i2c/busses/i2c-puv3.c
 create mode 100644 drivers/input/serio/i8042-unicore32io.h
 create mode 100644 drivers/video/fb-puv3.c
 create mode 100644 include/asm-generic/ftrace.h
 create mode 100644 include/asm-generic/sizes.h

