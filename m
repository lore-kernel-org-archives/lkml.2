Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0LIJ3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:29:11 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:60077 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0LIJ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:28:49 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 000/211] unicore32 architecture support
Date: Thu, 9 Dec 2010 17:28:41 +0800
Message-ID: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXgll4Q1Gzfr+0Ro2FZPwtQcdE+w==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

These patches add support for UniCore-32 ISA in linux kernel.
UniCore ISA is defined and developed by Micro-Processor R&D Center of
Peking University, and over the years, the CPUs and SoCs using UniCore ISA
have been successfully applied in a variety of products in China.

---

 arch/unicore32/.gitignore                     |   68 +
 arch/unicore32/Kconfig                        |  275 ++++
 arch/unicore32/Kconfig.debug                  |   86 +
 arch/unicore32/Makefile                       |  151 ++
 arch/unicore32/boot/Makefile                  |   47 +
 arch/unicore32/boot/compressed/Makefile       |   71 +
 arch/unicore32/boot/compressed/head.S         |  203 +++
 arch/unicore32/boot/compressed/misc.c         |  143 ++
 arch/unicore32/boot/compressed/piggy.S.in     |    6 +
 arch/unicore32/boot/compressed/vmlinux.lds.in |   61 +
 arch/unicore32/configs/debug_defconfig        |  208 +++
 arch/unicore32/configs/nb0916_defconfig       |  203 +++
 arch/unicore32/include/asm/Kbuild             |    4 +
 arch/unicore32/include/asm/assembler.h        |  193 +++
 arch/unicore32/include/asm/auxvec.h           |    4 +
 arch/unicore32/include/asm/bitops.h           |   47 +
 arch/unicore32/include/asm/byteorder.h        |   24 +
 arch/unicore32/include/asm/cache.h            |   27 +
 arch/unicore32/include/asm/cacheflush.h       |  212 +++
 arch/unicore32/include/asm/checksum.h         |  142 ++
 arch/unicore32/include/asm/cpu-single.h       |   45 +
 arch/unicore32/include/asm/cputype.h          |   33 +
 arch/unicore32/include/asm/delay.h            |   52 +
 arch/unicore32/include/asm/div64.h            |  230 +++
 arch/unicore32/include/asm/dma-mapping.h      |  298 ++++
 arch/unicore32/include/asm/dma.h              |   23 +
 arch/unicore32/include/asm/elf.h              |   95 ++
 arch/unicore32/include/asm/fpstate.h          |   41 +
 arch/unicore32/include/asm/ftrace.h           |    4 +
 arch/unicore32/include/asm/futex.h            |  131 ++
 arch/unicore32/include/asm/gpio.h             |  103 ++
 arch/unicore32/include/asm/hwcap.h            |   32 +
 arch/unicore32/include/asm/io.h               |   83 +
 arch/unicore32/include/asm/irq.h              |  107 ++
 arch/unicore32/include/asm/irqflags.h         |  103 ++
 arch/unicore32/include/asm/linkage.h          |   22 +
 arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
 arch/unicore32/include/asm/mach/bitfield.h    |   24 +
 arch/unicore32/include/asm/mach/debug-macro.S |  138 ++
 arch/unicore32/include/asm/mach/dma.h         |   41 +
 arch/unicore32/include/asm/mach/hardware.h    |   45 +
 arch/unicore32/include/asm/mach/map.h         |   20 +
 arch/unicore32/include/asm/mach/memory.h      |   51 +
 arch/unicore32/include/asm/mach/ocd.h         |   36 +
 arch/unicore32/include/asm/mach/pm.h          |   32 +
 arch/unicore32/include/asm/mach/regs-ac97.h   |   26 +
 arch/unicore32/include/asm/mach/regs-dmac.h   |   41 +
 arch/unicore32/include/asm/mach/regs-gpio.h   |   45 +
 arch/unicore32/include/asm/mach/regs-i2c.h    |   38 +
 arch/unicore32/include/asm/mach/regs-intc.h   |   10 +
 arch/unicore32/include/asm/mach/regs-nand.h   |   28 +
 arch/unicore32/include/asm/mach/regs-ost.h    |   29 +
 arch/unicore32/include/asm/mach/regs-pci.h    |   81 +
 arch/unicore32/include/asm/mach/regs-pm.h     |   63 +
 arch/unicore32/include/asm/mach/regs-ps2.h    |    8 +
 arch/unicore32/include/asm/mach/regs-resetc.h |   13 +
 arch/unicore32/include/asm/mach/regs-rtc.h    |   13 +
 arch/unicore32/include/asm/mach/regs-sdc.h    |   57 +
 arch/unicore32/include/asm/mach/regs-spi.h    |   32 +
 arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
 arch/unicore32/include/asm/mach/regs-umal.h   |  133 ++
 arch/unicore32/include/asm/mach/regs-unigfx.h |   86 +
 arch/unicore32/include/asm/mach/uncompress.h  |   34 +
 arch/unicore32/include/asm/memblock.h         |   20 +
 arch/unicore32/include/asm/memory.h           |  123 ++
 arch/unicore32/include/asm/mmu.h              |   17 +
 arch/unicore32/include/asm/mmu_context.h      |   87 ++
 arch/unicore32/include/asm/mutex.h            |   20 +
 arch/unicore32/include/asm/page.h             |   82 +
 arch/unicore32/include/asm/pci.h              |   46 +
 arch/unicore32/include/asm/pgalloc.h          |  114 ++
 arch/unicore32/include/asm/pgtable-hwdef.h    |   54 +
 arch/unicore32/include/asm/pgtable.h          |  333 ++++
 arch/unicore32/include/asm/processor.h        |   92 ++
 arch/unicore32/include/asm/ptrace.h           |  188 +++
 arch/unicore32/include/asm/setup.h            |   51 +
 arch/unicore32/include/asm/sigcontext.h       |   61 +
 arch/unicore32/include/asm/sizes.h            |   47 +
 arch/unicore32/include/asm/stacktrace.h       |   31 +
 arch/unicore32/include/asm/stat.h             |   71 +
 arch/unicore32/include/asm/string.h           |   52 +
 arch/unicore32/include/asm/suspend.h          |   30 +
 arch/unicore32/include/asm/swab.h             |   28 +
 arch/unicore32/include/asm/system.h           |  174 +++
 arch/unicore32/include/asm/thread_info.h      |  152 ++
 arch/unicore32/include/asm/timex.h            |   34 +
 arch/unicore32/include/asm/tlb.h              |   98 ++
 arch/unicore32/include/asm/tlbflush.h         |  192 +++
 arch/unicore32/include/asm/traps.h            |   32 +
 arch/unicore32/include/asm/uaccess.h          |  405 +++++
 arch/unicore32/include/asm/uc-f64.h           |   60 +
 arch/unicore32/include/asm/unistd.h           |  450 ++++++
 arch/unicore32/include/asm/user.h             |   85 +
 arch/unicore32/kernel/Makefile                |   36 +
 arch/unicore32/kernel/asm-offsets.c           |  110 ++
 arch/unicore32/kernel/calls.S                 |  390 +++++
 arch/unicore32/kernel/clock.c                 |  398 +++++
 arch/unicore32/kernel/cpu-ucv2.c              |  100 ++
 arch/unicore32/kernel/debug.S                 |   85 +
 arch/unicore32/kernel/early_printk.c          |   59 +
 arch/unicore32/kernel/elf.c                   |   38 +
 arch/unicore32/kernel/entry-common.S          |  339 ++++
 arch/unicore32/kernel/entry-header.S          |  144 ++
 arch/unicore32/kernel/entry-unicore.S         |  627 ++++++++
 arch/unicore32/kernel/head.S                  |  261 ++++
 arch/unicore32/kernel/hibernate.c             |  167 ++
 arch/unicore32/kernel/hibernate.h             |    9 +
 arch/unicore32/kernel/hibernate_asm.S         |  124 ++
 arch/unicore32/kernel/init_task.c             |   44 +
 arch/unicore32/kernel/irq.c                   |  434 ++++++
 arch/unicore32/kernel/ksyms.c                 |   87 ++
 arch/unicore32/kernel/module.c                |  152 ++
 arch/unicore32/kernel/pci.c                   |  395 +++++
 arch/unicore32/kernel/pm.c                    |  130 ++
 arch/unicore32/kernel/process.c               |  399 +++++
 arch/unicore32/kernel/ptrace.c                |  577 +++++++
 arch/unicore32/kernel/ptrace.h                |   53 +
 arch/unicore32/kernel/puv3-core.c             |  266 ++++
 arch/unicore32/kernel/puv3-nb0916.c           |  180 +++
 arch/unicore32/kernel/puv3-smw0919.c          |  119 ++
 arch/unicore32/kernel/setup.c                 |  369 +++++
 arch/unicore32/kernel/setup.h                 |   27 +
 arch/unicore32/kernel/signal.c                |  569 +++++++
 arch/unicore32/kernel/signal.h                |   16 +
 arch/unicore32/kernel/sleep.S                 |  210 +++
 arch/unicore32/kernel/stacktrace.c            |  131 ++
 arch/unicore32/kernel/sys_unicore.c           |  131 ++
 arch/unicore32/kernel/time.c                  |  159 ++
 arch/unicore32/kernel/traps.c                 |  514 +++++++
 arch/unicore32/kernel/vmlinux.lds.S           |  121 ++
 arch/unicore32/lib/Makefile                   |   16 +
 arch/unicore32/lib/backtrace.S                |  163 ++
 arch/unicore32/lib/clear_user.S               |   59 +
 arch/unicore32/lib/copy_from_user.S           |  107 ++
 arch/unicore32/lib/copy_page.S                |   39 +
 arch/unicore32/lib/copy_template.S            |  214 +++
 arch/unicore32/lib/copy_to_user.S             |   97 ++
 arch/unicore32/lib/csumipv6.S                 |   36 +
 arch/unicore32/lib/csumpartial.S              |  126 ++
 arch/unicore32/lib/csumpartialcopy.S          |   61 +
 arch/unicore32/lib/csumpartialcopygeneric.S   |  335 ++++
 arch/unicore32/lib/csumpartialcopyuser.S      |   92 ++
 arch/unicore32/lib/delay.S                    |   51 +
 arch/unicore32/lib/div64.S                    |  152 ++
 arch/unicore32/lib/findbit.S                  |   98 ++
 arch/unicore32/lib/getuser.S                  |   65 +
 arch/unicore32/lib/io-readsb.S                |  130 ++
 arch/unicore32/lib/io-readsl.S                |   83 +
 arch/unicore32/lib/io-readsw.S                |  110 ++
 arch/unicore32/lib/io-writesb.S               |   90 ++
 arch/unicore32/lib/io-writesl.S               |   69 +
 arch/unicore32/lib/io-writesw.S               |   87 ++
 arch/unicore32/lib/putuser.S                  |   73 +
 arch/unicore32/lib/sha1.S                     |  200 +++
 arch/unicore32/lib/strncpy_from_user.S        |   45 +
 arch/unicore32/lib/strnlen_user.S             |   42 +
 arch/unicore32/mm/Kconfig                     |   43 +
 arch/unicore32/mm/Makefile                    |   14 +
 arch/unicore32/mm/alignment.c                 |  563 +++++++
 arch/unicore32/mm/cache-ucv2.S                |  236 +++
 arch/unicore32/mm/dma-mapping.c               |  301 ++++
 arch/unicore32/mm/extable.c                   |   24 +
 arch/unicore32/mm/fault-unicore.c             |   65 +
 arch/unicore32/mm/fault.c                     |  524 +++++++
 arch/unicore32/mm/fault.h                     |   14 +
 arch/unicore32/mm/flush.c                     |   98 ++
 arch/unicore32/mm/init.c                      |  527 +++++++
 arch/unicore32/mm/iomap.c                     |   56 +
 arch/unicore32/mm/ioremap.c                   |  261 ++++
 arch/unicore32/mm/mm.h                        |   39 +
 arch/unicore32/mm/mmu.c                       |  494 ++++++
 arch/unicore32/mm/pgd.c                       |  102 ++
 arch/unicore32/mm/proc-macros.S               |  150 ++
 arch/unicore32/mm/proc-syms.c                 |   28 +
 arch/unicore32/mm/proc-ucv2.S                 |  134 ++
 arch/unicore32/mm/tlb-ucv2.S                  |   89 ++
 arch/unicore32/uc-f64/Makefile                |   13 +
 arch/unicore32/uc-f64/entry.S                 |   32 +
 arch/unicore32/uc-f64/f64_double_cmp.h        |  245 +++
 arch/unicore32/uc-f64/f64_single_cmp.h        |  245 +++
 arch/unicore32/uc-f64/f64double.c             |  750 +++++++++
 arch/unicore32/uc-f64/f64hw.S                 |  154 ++
 arch/unicore32/uc-f64/f64instr.h              |  101 ++
 arch/unicore32/uc-f64/f64module.c             |  181 +++
 arch/unicore32/uc-f64/f64single.c             |  763 +++++++++
 arch/unicore32/uc-f64/f64sint.c               |   94 ++
 arch/unicore32/uc-f64/uc-f64.h                |  340 ++++
 drivers/input/keyboard/Kconfig                |   11 +
 drivers/input/keyboard/atkbd.c                |    4 +
 drivers/input/mouse/psmouse-base.c            |   41 +
 drivers/input/serio/i8042.h                   |    2 +
 drivers/pci/Makefile                          |    1 +
 drivers/staging/puv3/Kconfig                  |  142 ++
 drivers/staging/puv3/Makefile                 |   27 +
 drivers/staging/puv3/i8042-ucio.h             |   96 ++
 drivers/staging/puv3/nb0916-atkbd.h           |   27 +
 drivers/staging/puv3/puv3_ac97.c              |  383 +++++
 drivers/staging/puv3/puv3_dma.c               |  187 +++
 drivers/staging/puv3/puv3_gpio.c              |  129 ++
 drivers/staging/puv3/puv3_i2c.c               |  325 ++++
 drivers/staging/puv3/puv3_pcm.c               |  448 ++++++
 drivers/staging/puv3/puv3_pcm.h               |   33 +
 drivers/staging/puv3/puv3_pwm.c               |  271 ++++
 drivers/staging/puv3/puv3_rtc.c               |  388 +++++
 drivers/staging/puv3/puv3_umal.c              | 2053
+++++++++++++++++++++++++
 drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
 firmware/Makefile                             |    2 +-
 include/linux/fb.h                            |    2 +
 include/linux/serial_core.h                   |    3 +
 init/Kconfig                                  |    2 +-
 lib/Kconfig.debug                             |    2 +-
 211 files changed, 30875 insertions(+), 3 deletions(-)

Guan Xuetao

