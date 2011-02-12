Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab1BLBco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:32:44 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57143 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab1BLBcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:32:43 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UniCore32 ISA support for linux-2.6
Date: Sat, 12 Feb 2011 09:32:33 +0800
Message-ID: <026101cbca54$b95489e0$2bfd9da0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvKVLfw5AeE3QQHRiq+V1yG637sBQ==
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
---

 MAINTAINERS                                   |   14 +
 arch/unicore32/.gitignore                     |   21 +
 arch/unicore32/Kconfig                        |  248 ++++++++
 arch/unicore32/Kconfig.debug                  |   68 ++
 arch/unicore32/Kconfig.puv3                   |  125 ++++
 arch/unicore32/Makefile                       |   97 +++
 arch/unicore32/boot/Makefile                  |   47 ++
 arch/unicore32/boot/compressed/Makefile       |   68 ++
 arch/unicore32/boot/compressed/head.S         |  204 ++++++
 arch/unicore32/boot/compressed/misc.c         |  126 ++++
 arch/unicore32/boot/compressed/piggy.S.in     |    6 +
 arch/unicore32/boot/compressed/vmlinux.lds.in |   61 ++
 arch/unicore32/configs/debug_defconfig        |  210 +++++++
 arch/unicore32/configs/nb0916_defconfig       |  202 ++++++
 arch/unicore32/include/asm/Kbuild             |    2 +
 arch/unicore32/include/asm/assembler.h        |  131 ++++
 arch/unicore32/include/asm/bitops.h           |   47 ++
 arch/unicore32/include/asm/byteorder.h        |   24 +
 arch/unicore32/include/asm/cache.h            |   27 +
 arch/unicore32/include/asm/cacheflush.h       |  211 +++++++
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
 arch/unicore32/include/asm/gpio.h             |  103 +++
 arch/unicore32/include/asm/hwcap.h            |   32 +
 arch/unicore32/include/asm/io.h               |   52 ++
 arch/unicore32/include/asm/irq.h              |  107 ++++
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
 arch/unicore32/include/asm/pgtable.h          |  317 ++++++++++
 arch/unicore32/include/asm/processor.h        |   92 +++
 arch/unicore32/include/asm/ptrace.h           |  133 ++++
 arch/unicore32/include/asm/sigcontext.h       |   29 +
 arch/unicore32/include/asm/stacktrace.h       |   31 +
 arch/unicore32/include/asm/string.h           |   38 ++
 arch/unicore32/include/asm/suspend.h          |   30 +
 arch/unicore32/include/asm/system.h           |  161 +++++
 arch/unicore32/include/asm/thread_info.h      |  154 +++++
 arch/unicore32/include/asm/timex.h            |   34 +
 arch/unicore32/include/asm/tlb.h              |   98 +++
 arch/unicore32/include/asm/tlbflush.h         |  195 ++++++
 arch/unicore32/include/asm/traps.h            |   21 +
 arch/unicore32/include/asm/uaccess.h          |   47 ++
 arch/unicore32/include/asm/unistd.h           |   18 +
 arch/unicore32/include/mach/PKUnity.h         |  104 ++++
 arch/unicore32/include/mach/bitfield.h        |   24 +
 arch/unicore32/include/mach/dma.h             |   41 ++
 arch/unicore32/include/mach/hardware.h        |   45 ++
 arch/unicore32/include/mach/map.h             |   20 +
 arch/unicore32/include/mach/memory.h          |   58 ++
 arch/unicore32/include/mach/ocd.h             |   36 ++
 arch/unicore32/include/mach/pm.h              |   43 ++
 arch/unicore32/include/mach/regs-ac97.h       |   32 +
 arch/unicore32/include/mach/regs-dmac.h       |   81 +++
 arch/unicore32/include/mach/regs-gpio.h       |   70 +++
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
 arch/unicore32/kernel/Makefile                |   34 +
 arch/unicore32/kernel/asm-offsets.c           |  112 ++++
 arch/unicore32/kernel/clock.c                 |  388 ++++++++++++
 arch/unicore32/kernel/cpu-ucv2.c              |   93 +++
 arch/unicore32/kernel/debug-macro.S           |   89 +++
 arch/unicore32/kernel/debug.S                 |   85 +++
 arch/unicore32/kernel/dma.c                   |  180 ++++++
 arch/unicore32/kernel/early_printk.c          |   59 ++
 arch/unicore32/kernel/elf.c                   |   38 ++
 arch/unicore32/kernel/entry.S                 |  824 +++++++++++++++++++++++++
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
 arch/unicore32/kernel/puv3-core.c             |  270 ++++++++
 arch/unicore32/kernel/puv3-nb0916.c           |  175 ++++++
 arch/unicore32/kernel/puv3-smw0919.c          |  115 ++++
 arch/unicore32/kernel/pwm.c                   |  263 ++++++++
 arch/unicore32/kernel/rtc.c                   |  380 ++++++++++++
 arch/unicore32/kernel/setup.c                 |  360 +++++++++++
 arch/unicore32/kernel/setup.h                 |   30 +
 arch/unicore32/kernel/signal.c                |  494 +++++++++++++++
 arch/unicore32/kernel/sleep.S                 |  202 ++++++
 arch/unicore32/kernel/stacktrace.c            |  131 ++++
 arch/unicore32/kernel/sys.c                   |  126 ++++
 arch/unicore32/kernel/time.c                  |  148 +++++
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
 arch/unicore32/mm/alignment.c                 |  523 ++++++++++++++++
 arch/unicore32/mm/cache-ucv2.S                |  212 +++++++
 arch/unicore32/mm/dma-swiotlb.c               |   34 +
 arch/unicore32/mm/extable.c                   |   24 +
 arch/unicore32/mm/fault.c                     |  479 ++++++++++++++
 arch/unicore32/mm/flush.c                     |   98 +++
 arch/unicore32/mm/init.c                      |  517 ++++++++++++++++
 arch/unicore32/mm/iomap.c                     |   56 ++
 arch/unicore32/mm/ioremap.c                   |  261 ++++++++
 arch/unicore32/mm/mm.h                        |   39 ++
 arch/unicore32/mm/mmu.c                       |  533 ++++++++++++++++
 arch/unicore32/mm/pgd.c                       |  102 +++
 arch/unicore32/mm/proc-macros.S               |  145 +++++
 arch/unicore32/mm/proc-syms.c                 |   23 +
 arch/unicore32/mm/proc-ucv2.S                 |  134 ++++
 arch/unicore32/mm/tlb-ucv2.S                  |   89 +++
 drivers/input/serio/i8042-unicore32io.h       |   70 +++
 drivers/input/serio/i8042.h                   |    2 +
 drivers/pci/Makefile                          |    1 +
 include/asm-generic/ftrace.h                  |   16 +
 include/asm-generic/sizes.h                   |   47 ++
 include/asm-generic/uaccess.h                 |    8 +-
 159 files changed, 18754 insertions(+), 3 deletions(-)


