Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1AVNwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:52:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34954 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1AVNwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=FvK0Whor5QgSJCxmGDtgOzNDWVs95dwy4eebiDKG7MV2Kr62wgJucOLGCtGJ6S3LV3
         zuPNepwloPo+B+N/O4pOdDol1sIkOqXRA27v7EhUCKR9Fe1NXVd4nVPEXrNqJV+hvB4L
         epKURFWnTlgFZ8/8LAAiXp4duJs6x1p6fC3q8=
MIME-Version: 1.0
Date: Sat, 22 Jan 2011 21:52:11 +0800
Message-ID: <AANLkTimKUV=RQezzME9qUUQjUjnHt9Qe79hOpK-cFC3i@mail.gmail.com>
Subject: Request (2nd) for unicore32 architecture codes to merge into linux-next
From: Xuetao Guan <epip.guan@gmail.com>
To: dmitry.torokhov@gmail.com, sfr@canb.auug.org.au, arnd@arndb.de,
        gregkh@suse.de, dtor@mail.ru, jbarnes@virtuousgeek.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

I want to merge unicore32 repo into linux-next tree, the position is
(unicore32 branch):
  git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git

Changes from previous version:
 1. remove drivers/staging files for advice from Paul and Liqin, only
remaining Kconfig
 by renaming it to arch/unicore32/Kconfig.puv3.
 2. modify i8042 driver by help from Dmitry.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
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
 arch/unicore32/include/asm/ptrace.h           |  176 ++++++
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
 arch/unicore32/kernel/ptrace.c                |  598 ++++++++++++++++++
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
 159 files changed, 19246 insertions(+), 3 deletions(-)
