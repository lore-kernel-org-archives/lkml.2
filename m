Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1CVEp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 00:45:26 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:40184 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1CVEpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 00:45:20 -0400
From: <gerg@snapgear.com>
To: <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <linux-kernel@vger.kernel.org>
CC: Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 1/1] m68k: merge m68k and m68knommu arch directories
Date: Tue, 22 Mar 2011 14:43:05 +1000
Message-ID: <1300768985-902-2-git-send-email-gerg@snapgear.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1300768985-902-1-git-send-email-gerg@snapgear.com>
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Ungerer <gerg@uclinux.org>

There is a lot of common code that could be shared between the m68k
and m68knommu arch branches. It makes sense to merge the two branches
into a single directory structure so that we can more easily share
that common code.

This is a brute force merge, based on a script from Stephen King
<sfking@fdwdc.com>, which was originally written by Arnd Bergmann
<arnd@arndb.de>.

> The script was inspired by the script Sam Ravnborg used to merge the
> includes from m68knommu. For those files common to both arches but
> differing in content, the m68k version of the file is renamed to
> <file>_mm.<ext> and the m68knommu version of the file is moved into the
> corresponding m68k directory and renamed <file>_no.<ext> and a small
> wrapper file <file>.<ext> is used to select between the two version. Files
> that are common to both but don't differ are removed from the m68knommu
> tree and files and directories that are unique to the m68knommu tree are
> moved to the m68k tree. Finally, the arch/m68knommu tree is removed.
>
> To select between the the versions of the files, the wrapper uses
>
> #ifdef CONFIG_MMU
> #include <file>_mm.<ext>
> #else
> #include <file>_no.<ext>
> #endif

On top of this file merge I have done a simplistic merge of m68k and
m68knommu Kconfig, which primarily attempts to keep existing options and
menus in place. Other than a handful of options being moved it produces
identical .config outputs on m68k and m68knommu targets I tested it on.

With this in place there is now quite a bit of scope for merge cleanups
in future patches.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/Kconfig                                  |  886 ++++----------
 arch/{m68knommu => m68k}/Kconfig.debug             |    4 +
 arch/m68k/{Kconfig => Kconfig.mmu}                 |  221 ----
 arch/{m68knommu/Kconfig => m68k/Kconfig.nommu}     |   94 --
 arch/m68k/Makefile                                 |  128 +--
 arch/m68k/{Makefile => Makefile_mm}                |    0
 arch/{m68knommu/Makefile => m68k/Makefile_no}      |   14 +-
 .../{m68knommu => m68k}/configs/m5208evb_defconfig |    1 +
 .../{m68knommu => m68k}/configs/m5249evb_defconfig |    1 +
 arch/{m68knommu => m68k}/configs/m5272c3_defconfig |    1 +
 .../{m68knommu => m68k}/configs/m5275evb_defconfig |    1 +
 arch/{m68knommu => m68k}/configs/m5307c3_defconfig |    1 +
 arch/{m68knommu => m68k}/configs/m5407c3_defconfig |    1 +
 arch/m68k/kernel/Makefile                          |   18 +-
 arch/m68k/kernel/Makefile_mm                       |   17 +
 .../kernel/Makefile => m68k/kernel/Makefile_no}    |    0
 arch/m68k/kernel/asm-offsets.c                     |  105 +--
 .../kernel/{asm-offsets.c => asm-offsets_mm.c}     |    0
 .../asm-offsets.c => m68k/kernel/asm-offsets_no.c} |    0
 arch/m68k/kernel/dma.c                             |  135 +---
 arch/m68k/kernel/{dma.c => dma_mm.c}               |    0
 .../kernel/dma.c => m68k/kernel/dma_no.c}          |    0
 arch/m68k/kernel/entry.S                           |  758 +------------
 arch/m68k/kernel/{entry.S => entry_mm.S}           |    0
 .../kernel/entry.S => m68k/kernel/entry_no.S}      |    0
 arch/{m68knommu => m68k}/kernel/init_task.c        |    0
 arch/{m68knommu => m68k}/kernel/irq.c              |    0
 arch/m68k/kernel/m68k_ksyms.c                      |   21 +-
 arch/m68k/kernel/{m68k_ksyms.c => m68k_ksyms_mm.c} |    0
 .../m68k_ksyms.c => m68k/kernel/m68k_ksyms_no.c}   |    0
 arch/m68k/kernel/module.c                          |  160 +---
 arch/m68k/kernel/{module.c => module_mm.c}         |    0
 .../kernel/module.c => m68k/kernel/module_no.c}    |    0
 arch/m68k/kernel/process.c                         |  359 +------
 arch/m68k/kernel/{process.c => process_mm.c}       |    0
 .../kernel/process.c => m68k/kernel/process_no.c}  |    0
 arch/m68k/kernel/ptrace.c                          |  282 +-----
 arch/m68k/kernel/{ptrace.c => ptrace_mm.c}         |    0
 .../kernel/ptrace.c => m68k/kernel/ptrace_no.c}    |    0
 arch/m68k/kernel/setup.c                           |  538 +---------
 arch/m68k/kernel/{setup.c => setup_mm.c}           |    0
 .../kernel/setup.c => m68k/kernel/setup_no.c}      |    0
 arch/m68k/kernel/signal.c                          | 1022 +----------------
 arch/m68k/kernel/{signal.c => signal_mm.c}         |    0
 .../kernel/signal.c => m68k/kernel/signal_no.c}    |    0
 arch/m68k/kernel/sys_m68k.c                        |  551 +---------
 arch/m68k/kernel/{sys_m68k.c => sys_m68k_mm.c}     |    0
 .../sys_m68k.c => m68k/kernel/sys_m68k_no.c}       |    0
 arch/{m68knommu => m68k}/kernel/syscalltable.S     |    0
 arch/m68k/kernel/time.c                            |  119 +--
 arch/m68k/kernel/{time.c => time_mm.c}             |    0
 .../kernel/time.c => m68k/kernel/time_no.c}        |    0
 arch/m68k/kernel/traps.c                           | 1212 +-------------------
 arch/m68k/kernel/{traps.c => traps_mm.c}           |    0
 .../kernel/traps.c => m68k/kernel/traps_no.c}      |    0
 arch/m68k/kernel/vmlinux.lds.S                     |   11 +-
 arch/m68k/kernel/vmlinux.lds_mm.S                  |   10 +
 .../vmlinux.lds.S => m68k/kernel/vmlinux.lds_no.S} |    0
 arch/m68k/lib/Makefile                             |   11 +-
 arch/m68k/lib/Makefile_mm                          |    6 +
 .../lib/Makefile => m68k/lib/Makefile_no}          |    0
 arch/m68k/lib/checksum.c                           |  430 +-------
 arch/m68k/lib/{checksum.c => checksum_mm.c}        |    0
 .../lib/checksum.c => m68k/lib/checksum_no.c}      |    0
 arch/{m68knommu => m68k}/lib/delay.c               |    0
 arch/{m68knommu => m68k}/lib/divsi3.S              |    0
 arch/{m68knommu => m68k}/lib/memcpy.c              |    0
 arch/{m68knommu => m68k}/lib/memmove.c             |    0
 arch/{m68knommu => m68k}/lib/memset.c              |    0
 arch/{m68knommu => m68k}/lib/modsi3.S              |    0
 arch/m68k/lib/muldi3.c                             |   68 +-
 arch/m68k/lib/{muldi3.c => muldi3_mm.c}            |    0
 .../lib/muldi3.c => m68k/lib/muldi3_no.c}          |    0
 arch/{m68knommu => m68k}/lib/mulsi3.S              |    0
 arch/{m68knommu => m68k}/lib/udivsi3.S             |    0
 arch/{m68knommu => m68k}/lib/umodsi3.S             |    0
 arch/m68k/mm/Makefile                              |   13 +-
 arch/m68k/mm/Makefile_mm                           |    8 +
 .../{m68knommu/mm/Makefile => m68k/mm/Makefile_no} |    0
 arch/m68k/mm/init.c                                |  155 +---
 arch/m68k/mm/{init.c => init_mm.c}                 |    0
 arch/{m68knommu/mm/init.c => m68k/mm/init_no.c}    |    0
 arch/m68k/mm/kmap.c                                |  372 +------
 arch/m68k/mm/{kmap.c => kmap_mm.c}                 |    0
 arch/{m68knommu/mm/kmap.c => m68k/mm/kmap_no.c}    |    0
 arch/{m68knommu => m68k}/platform/5206/Makefile    |    0
 arch/{m68knommu => m68k}/platform/5206/config.c    |    0
 arch/{m68knommu => m68k}/platform/5206/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5206e/Makefile   |    0
 arch/{m68knommu => m68k}/platform/5206e/config.c   |    0
 arch/{m68knommu => m68k}/platform/5206e/gpio.c     |    0
 arch/{m68knommu => m68k}/platform/520x/Makefile    |    0
 arch/{m68knommu => m68k}/platform/520x/config.c    |    0
 arch/{m68knommu => m68k}/platform/520x/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/523x/Makefile    |    0
 arch/{m68knommu => m68k}/platform/523x/config.c    |    0
 arch/{m68knommu => m68k}/platform/523x/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5249/Makefile    |    0
 arch/{m68knommu => m68k}/platform/5249/config.c    |    0
 arch/{m68knommu => m68k}/platform/5249/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5249/intc2.c     |    0
 arch/{m68knommu => m68k}/platform/5272/Makefile    |    0
 arch/{m68knommu => m68k}/platform/5272/config.c    |    0
 arch/{m68knommu => m68k}/platform/5272/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5272/intc.c      |    0
 arch/{m68knommu => m68k}/platform/527x/Makefile    |    0
 arch/{m68knommu => m68k}/platform/527x/config.c    |    0
 arch/{m68knommu => m68k}/platform/527x/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/528x/Makefile    |    0
 arch/{m68knommu => m68k}/platform/528x/config.c    |    0
 arch/{m68knommu => m68k}/platform/528x/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5307/Makefile    |    0
 arch/{m68knommu => m68k}/platform/5307/config.c    |    0
 arch/{m68knommu => m68k}/platform/5307/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5307/nettel.c    |    0
 arch/{m68knommu => m68k}/platform/532x/Makefile    |    0
 arch/{m68knommu => m68k}/platform/532x/config.c    |    0
 arch/{m68knommu => m68k}/platform/532x/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/5407/Makefile    |    0
 arch/{m68knommu => m68k}/platform/5407/config.c    |    0
 arch/{m68knommu => m68k}/platform/5407/gpio.c      |    0
 arch/{m68knommu => m68k}/platform/54xx/Makefile    |    0
 arch/{m68knommu => m68k}/platform/54xx/config.c    |    0
 arch/{m68knommu => m68k}/platform/54xx/firebee.c   |    0
 arch/{m68knommu => m68k}/platform/68328/Makefile   |    0
 arch/{m68knommu => m68k}/platform/68328/bootlogo.h |    0
 .../{m68knommu => m68k}/platform/68328/bootlogo.pl |    0
 arch/{m68knommu => m68k}/platform/68328/config.c   |    0
 arch/{m68knommu => m68k}/platform/68328/entry.S    |    0
 arch/{m68knommu => m68k}/platform/68328/head-de2.S |    0
 .../platform/68328/head-pilot.S                    |    0
 arch/{m68knommu => m68k}/platform/68328/head-ram.S |    0
 arch/{m68knommu => m68k}/platform/68328/head-rom.S |    0
 arch/{m68knommu => m68k}/platform/68328/ints.c     |    0
 arch/{m68knommu => m68k}/platform/68328/romvec.S   |    0
 arch/{m68knommu => m68k}/platform/68328/timers.c   |    0
 arch/{m68knommu => m68k}/platform/68360/Makefile   |    0
 arch/{m68knommu => m68k}/platform/68360/commproc.c |    0
 arch/{m68knommu => m68k}/platform/68360/config.c   |    0
 arch/{m68knommu => m68k}/platform/68360/entry.S    |    0
 arch/{m68knommu => m68k}/platform/68360/head-ram.S |    0
 arch/{m68knommu => m68k}/platform/68360/head-rom.S |    0
 arch/{m68knommu => m68k}/platform/68360/ints.c     |    0
 arch/{m68knommu => m68k}/platform/68EZ328/Makefile |    0
 .../platform/68EZ328/bootlogo.h                    |    0
 arch/{m68knommu => m68k}/platform/68EZ328/config.c |    0
 arch/{m68knommu => m68k}/platform/68VZ328/Makefile |    0
 arch/{m68knommu => m68k}/platform/68VZ328/config.c |    0
 arch/{m68knommu => m68k}/platform/Makefile         |    0
 .../{m68knommu => m68k}/platform/coldfire/Makefile |    0
 arch/{m68knommu => m68k}/platform/coldfire/cache.c |    0
 arch/{m68knommu => m68k}/platform/coldfire/clk.c   |    0
 arch/{m68knommu => m68k}/platform/coldfire/dma.c   |    0
 .../platform/coldfire/dma_timer.c                  |    0
 arch/{m68knommu => m68k}/platform/coldfire/entry.S |    0
 arch/{m68knommu => m68k}/platform/coldfire/gpio.c  |    0
 arch/{m68knommu => m68k}/platform/coldfire/head.S  |    0
 .../{m68knommu => m68k}/platform/coldfire/intc-2.c |    0
 .../platform/coldfire/intc-simr.c                  |    0
 arch/{m68knommu => m68k}/platform/coldfire/intc.c  |    0
 .../{m68knommu => m68k}/platform/coldfire/pinmux.c |    0
 arch/{m68knommu => m68k}/platform/coldfire/pit.c   |    0
 .../platform/coldfire/sltimers.c                   |    0
 .../{m68knommu => m68k}/platform/coldfire/timers.c |    0
 .../platform/coldfire/vectors.c                    |    0
 arch/m68knommu/defconfig                           |   74 --
 arch/m68knommu/kernel/.gitignore                   |    1 -
 arch/m68knommu/lib/ashldi3.c                       |   62 -
 arch/m68knommu/lib/ashrdi3.c                       |   63 -
 arch/m68knommu/lib/lshrdi3.c                       |   62 -
 170 files changed, 407 insertions(+), 7589 deletions(-)
 rewrite arch/m68k/Kconfig (72%)
 rename arch/{m68knommu => m68k}/Kconfig.debug (97%)
 rename arch/m68k/{Kconfig => Kconfig.mmu} (72%)
 rename arch/{m68knommu/Kconfig => m68k/Kconfig.nommu} (93%)
 rewrite arch/m68k/Makefile (99%)
 rename arch/m68k/{Makefile => Makefile_mm} (100%)
 rename arch/{m68knommu/Makefile => m68k/Makefile_no} (93%)
 rename arch/{m68knommu => m68k}/configs/m5208evb_defconfig (98%)
 rename arch/{m68knommu => m68k}/configs/m5249evb_defconfig (98%)
 rename arch/{m68knommu => m68k}/configs/m5272c3_defconfig (98%)
 rename arch/{m68knommu => m68k}/configs/m5275evb_defconfig (98%)
 rename arch/{m68knommu => m68k}/configs/m5307c3_defconfig (98%)
 rename arch/{m68knommu => m68k}/configs/m5407c3_defconfig (98%)
 create mode 100644 arch/m68k/kernel/Makefile_mm
 rename arch/{m68knommu/kernel/Makefile => m68k/kernel/Makefile_no} (100%)
 rewrite arch/m68k/kernel/asm-offsets.c (99%)
 rename arch/m68k/kernel/{asm-offsets.c => asm-offsets_mm.c} (100%)
 rename arch/{m68knommu/kernel/asm-offsets.c => m68k/kernel/asm-offsets_no.c} (100%)
 rewrite arch/m68k/kernel/dma.c (100%)
 rename arch/m68k/kernel/{dma.c => dma_mm.c} (100%)
 rename arch/{m68knommu/kernel/dma.c => m68k/kernel/dma_no.c} (100%)
 rewrite arch/m68k/kernel/entry.S (99%)
 rename arch/m68k/kernel/{entry.S => entry_mm.S} (100%)
 rename arch/{m68knommu/kernel/entry.S => m68k/kernel/entry_no.S} (100%)
 rename arch/{m68knommu => m68k}/kernel/init_task.c (100%)
 rename arch/{m68knommu => m68k}/kernel/irq.c (100%)
 rewrite arch/m68k/kernel/m68k_ksyms.c (100%)
 rename arch/m68k/kernel/{m68k_ksyms.c => m68k_ksyms_mm.c} (100%)
 rename arch/{m68knommu/kernel/m68k_ksyms.c => m68k/kernel/m68k_ksyms_no.c} (100%)
 rewrite arch/m68k/kernel/module.c (99%)
 rename arch/m68k/kernel/{module.c => module_mm.c} (100%)
 rename arch/{m68knommu/kernel/module.c => m68k/kernel/module_no.c} (100%)
 rewrite arch/m68k/kernel/process.c (99%)
 rename arch/m68k/kernel/{process.c => process_mm.c} (100%)
 rename arch/{m68knommu/kernel/process.c => m68k/kernel/process_no.c} (100%)
 rewrite arch/m68k/kernel/ptrace.c (100%)
 rename arch/m68k/kernel/{ptrace.c => ptrace_mm.c} (100%)
 rename arch/{m68knommu/kernel/ptrace.c => m68k/kernel/ptrace_no.c} (100%)
 rewrite arch/m68k/kernel/setup.c (99%)
 rename arch/m68k/kernel/{setup.c => setup_mm.c} (100%)
 rename arch/{m68knommu/kernel/setup.c => m68k/kernel/setup_no.c} (100%)
 rewrite arch/m68k/kernel/signal.c (99%)
 rename arch/m68k/kernel/{signal.c => signal_mm.c} (100%)
 rename arch/{m68knommu/kernel/signal.c => m68k/kernel/signal_no.c} (100%)
 rewrite arch/m68k/kernel/sys_m68k.c (100%)
 rename arch/m68k/kernel/{sys_m68k.c => sys_m68k_mm.c} (100%)
 rename arch/{m68knommu/kernel/sys_m68k.c => m68k/kernel/sys_m68k_no.c} (100%)
 rename arch/{m68knommu => m68k}/kernel/syscalltable.S (100%)
 rewrite arch/m68k/kernel/time.c (100%)
 rename arch/m68k/kernel/{time.c => time_mm.c} (100%)
 rename arch/{m68knommu/kernel/time.c => m68k/kernel/time_no.c} (100%)
 rewrite arch/m68k/kernel/traps.c (99%)
 rename arch/m68k/kernel/{traps.c => traps_mm.c} (100%)
 rename arch/{m68knommu/kernel/traps.c => m68k/kernel/traps_no.c} (100%)
 create mode 100644 arch/m68k/kernel/vmlinux.lds_mm.S
 rename arch/{m68knommu/kernel/vmlinux.lds.S => m68k/kernel/vmlinux.lds_no.S} (100%)
 create mode 100644 arch/m68k/lib/Makefile_mm
 rename arch/{m68knommu/lib/Makefile => m68k/lib/Makefile_no} (100%)
 rewrite arch/m68k/lib/checksum.c (100%)
 rename arch/m68k/lib/{checksum.c => checksum_mm.c} (100%)
 rename arch/{m68knommu/lib/checksum.c => m68k/lib/checksum_no.c} (100%)
 rename arch/{m68knommu => m68k}/lib/delay.c (100%)
 rename arch/{m68knommu => m68k}/lib/divsi3.S (100%)
 rename arch/{m68knommu => m68k}/lib/memcpy.c (100%)
 rename arch/{m68knommu => m68k}/lib/memmove.c (100%)
 rename arch/{m68knommu => m68k}/lib/memset.c (100%)
 rename arch/{m68knommu => m68k}/lib/modsi3.S (100%)
 rewrite arch/m68k/lib/muldi3.c (100%)
 rename arch/m68k/lib/{muldi3.c => muldi3_mm.c} (100%)
 rename arch/{m68knommu/lib/muldi3.c => m68k/lib/muldi3_no.c} (100%)
 rename arch/{m68knommu => m68k}/lib/mulsi3.S (100%)
 rename arch/{m68knommu => m68k}/lib/udivsi3.S (100%)
 rename arch/{m68knommu => m68k}/lib/umodsi3.S (100%)
 create mode 100644 arch/m68k/mm/Makefile_mm
 rename arch/{m68knommu/mm/Makefile => m68k/mm/Makefile_no} (100%)
 rewrite arch/m68k/mm/init.c (99%)
 rename arch/m68k/mm/{init.c => init_mm.c} (100%)
 rename arch/{m68knommu/mm/init.c => m68k/mm/init_no.c} (100%)
 rewrite arch/m68k/mm/kmap.c (99%)
 rename arch/m68k/mm/{kmap.c => kmap_mm.c} (100%)
 rename arch/{m68knommu/mm/kmap.c => m68k/mm/kmap_no.c} (100%)
 rename arch/{m68knommu => m68k}/platform/5206/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/5206/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/5206/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5206e/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/5206e/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/5206e/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/520x/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/520x/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/520x/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/523x/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/523x/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/523x/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5249/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/5249/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/5249/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5249/intc2.c (100%)
 rename arch/{m68knommu => m68k}/platform/5272/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/5272/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/5272/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5272/intc.c (100%)
 rename arch/{m68knommu => m68k}/platform/527x/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/527x/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/527x/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/528x/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/528x/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/528x/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5307/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/5307/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/5307/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5307/nettel.c (100%)
 rename arch/{m68knommu => m68k}/platform/532x/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/532x/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/532x/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/5407/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/5407/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/5407/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/54xx/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/54xx/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/54xx/firebee.c (100%)
 rename arch/{m68knommu => m68k}/platform/68328/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/68328/bootlogo.h (100%)
 rename arch/{m68knommu => m68k}/platform/68328/bootlogo.pl (100%)
 rename arch/{m68knommu => m68k}/platform/68328/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/68328/entry.S (100%)
 rename arch/{m68knommu => m68k}/platform/68328/head-de2.S (100%)
 rename arch/{m68knommu => m68k}/platform/68328/head-pilot.S (100%)
 rename arch/{m68knommu => m68k}/platform/68328/head-ram.S (100%)
 rename arch/{m68knommu => m68k}/platform/68328/head-rom.S (100%)
 rename arch/{m68knommu => m68k}/platform/68328/ints.c (100%)
 rename arch/{m68knommu => m68k}/platform/68328/romvec.S (100%)
 rename arch/{m68knommu => m68k}/platform/68328/timers.c (100%)
 rename arch/{m68knommu => m68k}/platform/68360/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/68360/commproc.c (100%)
 rename arch/{m68knommu => m68k}/platform/68360/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/68360/entry.S (100%)
 rename arch/{m68knommu => m68k}/platform/68360/head-ram.S (100%)
 rename arch/{m68knommu => m68k}/platform/68360/head-rom.S (100%)
 rename arch/{m68knommu => m68k}/platform/68360/ints.c (100%)
 rename arch/{m68knommu => m68k}/platform/68EZ328/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/68EZ328/bootlogo.h (100%)
 rename arch/{m68knommu => m68k}/platform/68EZ328/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/68VZ328/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/68VZ328/config.c (100%)
 rename arch/{m68knommu => m68k}/platform/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/Makefile (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/cache.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/clk.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/dma.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/dma_timer.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/entry.S (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/gpio.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/head.S (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/intc-2.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/intc-simr.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/intc.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/pinmux.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/pit.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/sltimers.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/timers.c (100%)
 rename arch/{m68knommu => m68k}/platform/coldfire/vectors.c (100%)
 delete mode 100644 arch/m68knommu/defconfig
 delete mode 100644 arch/m68knommu/kernel/.gitignore
 delete mode 100644 arch/m68knommu/lib/ashldi3.c
 delete mode 100644 arch/m68knommu/lib/ashrdi3.c
 delete mode 100644 arch/m68knommu/lib/lshrdi3.c

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
dissimilarity index 72%
index 525174d..6e056d3 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -1,638 +1,248 @@
-config M68K
-	bool
-	default y
-	select HAVE_AOUT
-	select HAVE_IDE
-	select GENERIC_ATOMIC64
-
-config MMU
-	bool
-	default y
-
-config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
-
-config RWSEM_XCHGADD_ALGORITHM
-	bool
-
-config ARCH_HAS_ILOG2_U32
-	bool
-
-config ARCH_HAS_ILOG2_U64
-	bool
-
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
-
-config TIME_LOW_RES
-	bool
-	default y
-
-config GENERIC_IOMAP
-	bool
-	default y
-
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	depends on BROKEN && (Q40 || SUN3X)
-	default y
-
-config NO_IOPORT
-	def_bool y
-
-config NO_DMA
-	def_bool SUN3
-
-config HZ
-	int
-	default 100
-
-config ARCH_USES_GETTIMEOFFSET
-	def_bool y
-
-source "init/Kconfig"
-
-source "kernel/Kconfig.freezer"
-
-menu "Platform dependent setup"
-
-config EISA
-	bool
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-config MCA
-	bool
-	help
-	  MicroChannel Architecture is found in some IBM PS/2 machines and
-	  laptops.  It is a bus system similar to PCI or ISA. See
-	  <file:Documentation/mca.txt> (and especially the web page given
-	  there) before attempting to build an MCA bus kernel.
-
-config PCMCIA
-	tristate
-	---help---
-	  Say Y here if you want to attach PCMCIA- or PC-cards to your Linux
-	  computer.  These are credit-card size devices such as network cards,
-	  modems or hard drives often used with laptops computers.  There are
-	  actually two varieties of these cards: the older 16 bit PCMCIA cards
-	  and the newer 32 bit CardBus cards.  If you want to use CardBus
-	  cards, you need to say Y here and also to "CardBus support" below.
-
-	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
-	  for location).  Please also read the PCMCIA-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  To compile this driver as modules, choose M here: the
-	  modules will be called pcmcia_core and ds.
-
-config AMIGA
-	bool "Amiga support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the Amiga series of computers. If
-	  you plan to use this kernel on an Amiga, say Y here and browse the
-	  material available in <file:Documentation/m68k>; otherwise say N.
-
-config ATARI
-	bool "Atari support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the 68000-based Atari series of
-	  computers (including the TT, Falcon and Medusa). If you plan to use
-	  this kernel on an Atari, say Y here and browse the material
-	  available in <file:Documentation/m68k>; otherwise say N.
-
-config MAC
-	bool "Macintosh support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the Apple Macintosh series of
-	  computers (yes, there is experimental support now, at least for part
-	  of the series).
-
-	  Say N unless you're willing to code the remaining necessary support.
-	  ;)
-
-config NUBUS
-	bool
-	depends on MAC
-	default y
-
-config M68K_L2_CACHE
-	bool
-	depends on MAC
-	default y
-
-config APOLLO
-	bool "Apollo support"
-	select MMU_MOTOROLA if MMU
-	help
-	  Say Y here if you want to run Linux on an MC680x0-based Apollo
-	  Domain workstation such as the DN3500.
-
-config VME
-	bool "VME (Motorola and BVM) support"
-	select MMU_MOTOROLA if MMU
-	help
-	  Say Y here if you want to build a kernel for a 680x0 based VME
-	  board.  Boards currently supported include Motorola boards MVME147,
-	  MVME162, MVME166, MVME167, MVME172, and MVME177.  BVME4000 and
-	  BVME6000 boards from BVM Ltd are also supported.
-
-config MVME147
-	bool "MVME147 support"
-	depends on VME
-	help
-	  Say Y to include support for early Motorola VME boards.  This will
-	  build a kernel which can run on MVME147 single-board computers.  If
-	  you select this option you will have to select the appropriate
-	  drivers for SCSI, Ethernet and serial ports later on.
-
-config MVME16x
-	bool "MVME162, 166 and 167 support"
-	depends on VME
-	help
-	  Say Y to include support for Motorola VME boards.  This will build a
-	  kernel which can run on MVME162, MVME166, MVME167, MVME172, and
-	  MVME177 boards.  If you select this option you will have to select
-	  the appropriate drivers for SCSI, Ethernet and serial ports later
-	  on.
-
-config BVME6000
-	bool "BVME4000 and BVME6000 support"
-	depends on VME
-	help
-	  Say Y to include support for VME boards from BVM Ltd.  This will
-	  build a kernel which can run on BVME4000 and BVME6000 boards.  If
-	  you select this option you will have to select the appropriate
-	  drivers for SCSI, Ethernet and serial ports later on.
-
-config HP300
-	bool "HP9000/300 and HP9000/400 support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the HP9000/300 and HP9000/400 series
-	  of workstations. Support for these machines is still somewhat
-	  experimental. If you plan to try to use the kernel on such a machine
-	  say Y here.
-	  Everybody else says N.
-
-config DIO
-	bool "DIO bus support"
-	depends on HP300
-	default y
-	help
-	  Say Y here to enable support for the "DIO" expansion bus used in
-	  HP300 machines. If you are using such a system you almost certainly
-	  want this.
-
-config SUN3X
-	bool "Sun3x support"
-	select MMU_MOTOROLA if MMU
-	select M68030
-	help
-	  This option enables support for the Sun 3x series of workstations.
-	  Be warned that this support is very experimental.
-	  Note that Sun 3x kernels are not compatible with Sun 3 hardware.
-	  General Linux information on the Sun 3x series (now discontinued)
-	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
-
-	  If you don't want to compile a kernel for a Sun 3x, say N.
-
-config Q40
-	bool "Q40/Q60 support"
-	select MMU_MOTOROLA if MMU
-	help
-	  The Q40 is a Motorola 68040-based successor to the Sinclair QL
-	  manufactured in Germany.  There is an official Q40 home page at
-	  <http://www.q40.de/>.  This option enables support for the Q40 and
-	  Q60. Select your CPU below.  For 68LC060 don't forget to enable FPU
-	  emulation.
-
-config SUN3
-	bool "Sun3 support"
-	depends on !MMU_MOTOROLA
-	select MMU_SUN3 if MMU
-	select M68020
-	help
-	  This option enables support for the Sun 3 series of workstations
-	  (3/50, 3/60, 3/1xx, 3/2xx systems). Enabling this option requires
-	  that all other hardware types must be disabled, as Sun 3 kernels
-	  are incompatible with all other m68k targets (including Sun 3x!).
-
-	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
-
-config NATFEAT
-	bool "ARAnyM emulator support"
-	depends on ATARI
-	help
-	  This option enables support for ARAnyM native features, such as
-	  access to a disk image as /dev/hda.
-
-config NFBLOCK
-	tristate "NatFeat block device support"
-	depends on BLOCK && NATFEAT
-	help
-	  Say Y to include support for the ARAnyM NatFeat block device
-	  which allows direct access to the hard drives without using
-	  the hardware emulation.
-
-config NFCON
-	tristate "NatFeat console driver"
-	depends on NATFEAT
-	help
-	  Say Y to include support for the ARAnyM NatFeat console driver
-	  which allows the console output to be redirected to the stderr
-	  output of ARAnyM.
-
-config NFETH
-	tristate "NatFeat Ethernet support"
-	depends on NET_ETHERNET && NATFEAT
-	help
-	  Say Y to include support for the ARAnyM NatFeat network device
-	  which will emulate a regular ethernet device while presenting an
-	  ethertap device to the host system.
-
-comment "Processor type"
-
-config M68020
-	bool "68020 support"
-	help
-	  If you anticipate running this kernel on a computer with a MC68020
-	  processor, say Y. Otherwise, say N. Note that the 68020 requires a
-	  68851 MMU (Memory Management Unit) to run Linux/m68k, except on the
-	  Sun 3, which provides its own version.
-
-config M68030
-	bool "68030 support"
-	depends on !MMU_SUN3
-	help
-	  If you anticipate running this kernel on a computer with a MC68030
-	  processor, say Y. Otherwise, say N. Note that a MC68EC030 will not
-	  work, as it does not include an MMU (Memory Management Unit).
-
-config M68040
-	bool "68040 support"
-	depends on !MMU_SUN3
-	help
-	  If you anticipate running this kernel on a computer with a MC68LC040
-	  or MC68040 processor, say Y. Otherwise, say N. Note that an
-	  MC68EC040 will not work, as it does not include an MMU (Memory
-	  Management Unit).
-
-config M68060
-	bool "68060 support"
-	depends on !MMU_SUN3
-	help
-	  If you anticipate running this kernel on a computer with a MC68060
-	  processor, say Y. Otherwise, say N.
-
-config MMU_MOTOROLA
-	bool
-
-config MMU_SUN3
-	bool
-	depends on MMU && !MMU_MOTOROLA
-
-config M68KFPU_EMU
-	bool "Math emulation support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  At some point in the future, this will cause floating-point math
-	  instructions to be emulated by the kernel on machines that lack a
-	  floating-point math coprocessor.  Thrill-seekers and chronically
-	  sleep-deprived psychotic hacker types can say Y now, everyone else
-	  should probably wait a while.
-
-config M68KFPU_EMU_EXTRAPREC
-	bool "Math emulation extra precision"
-	depends on M68KFPU_EMU
-	help
-	  The fpu uses normally a few bit more during calculations for
-	  correct rounding, the emulator can (often) do the same but this
-	  extra calculation can cost quite some time, so you can disable
-	  it here. The emulator will then "only" calculate with a 64 bit
-	  mantissa and round slightly incorrect, what is more than enough
-	  for normal usage.
-
-config M68KFPU_EMU_ONLY
-	bool "Math emulation only kernel"
-	depends on M68KFPU_EMU
-	help
-	  This option prevents any floating-point instructions from being
-	  compiled into the kernel, thereby the kernel doesn't save any
-	  floating point context anymore during task switches, so this
-	  kernel will only be usable on machines without a floating-point
-	  math coprocessor. This makes the kernel a bit faster as no tests
-	  needs to be executed whether a floating-point instruction in the
-	  kernel should be executed or not.
-
-config ADVANCED
-	bool "Advanced configuration options"
-	---help---
-	  This gives you access to some advanced options for the CPU. The
-	  defaults should be fine for most users, but these options may make
-	  it possible for you to improve performance somewhat if you know what
-	  you are doing.
-
-	  Note that the answer to this question won't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about these options.
-
-	  Most users should say N to this question.
-
-config RMW_INSNS
-	bool "Use read-modify-write instructions"
-	depends on ADVANCED
-	---help---
-	  This allows to use certain instructions that work with indivisible
-	  read-modify-write bus cycles. While this is faster than the
-	  workaround of disabling interrupts, it can conflict with DMA
-	  ( = direct memory access) on many Amiga systems, and it is also said
-	  to destabilize other machines. It is very likely that this will
-	  cause serious problems on any Amiga or Atari Medusa if set. The only
-	  configuration where it should work are 68030-based Ataris, where it
-	  apparently improves performance. But you've been warned! Unless you
-	  really know what you are doing, say N. Try Y only if you're quite
-	  adventurous.
-
-config SINGLE_MEMORY_CHUNK
-	bool "Use one physical chunk of memory only" if ADVANCED && !SUN3
-	default y if SUN3
-	select NEED_MULTIPLE_NODES
-	help
-	  Ignore all but the first contiguous chunk of physical memory for VM
-	  purposes.  This will save a few bytes kernel size and may speed up
-	  some operations.  Say N if not sure.
-
-config 060_WRITETHROUGH
-	bool "Use write-through caching for 68060 supervisor accesses"
-	depends on ADVANCED && M68060
-	---help---
-	  The 68060 generally uses copyback caching of recently accessed data.
-	  Copyback caching means that memory writes will be held in an on-chip
-	  cache and only written back to memory some time later.  Saying Y
-	  here will force supervisor (kernel) accesses to use writethrough
-	  caching.  Writethrough caching means that data is written to memory
-	  straight away, so that cache and memory data always agree.
-	  Writethrough caching is less efficient, but is needed for some
-	  drivers on 68060 based systems where the 68060 bus snooping signal
-	  is hardwired on.  The 53c710 SCSI driver is known to suffer from
-	  this problem.
-
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool !SINGLE_MEMORY_CHUNK
-
-config NODES_SHIFT
-	int
-	default "3"
-	depends on !SINGLE_MEMORY_CHUNK
-
-source "mm/Kconfig"
-
-endmenu
-
-menu "General setup"
-
-source "fs/Kconfig.binfmt"
-
-config ZORRO
-	bool "Amiga Zorro (AutoConfig) bus support"
-	depends on AMIGA
-	help
-	  This enables support for the Zorro bus in the Amiga. If you have
-	  expansion cards in your Amiga that conform to the Amiga
-	  AutoConfig(tm) specification, say Y, otherwise N. Note that even
-	  expansion cards that do not fit in the Zorro slots but fit in e.g.
-	  the CPU slot may fall in this category, so you have to say Y to let
-	  Linux use these.
-
-config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support (EXPERIMENTAL)"
-	depends on AMIGA && EXPERIMENTAL
-	help
-	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
-	  600. If you intend to use pcmcia cards say Y; otherwise say N.
-
-config STRAM_PROC
-	bool "ST-RAM statistics in /proc"
-	depends on ATARI
-	help
-	  Say Y here to report ST-RAM usage statistics in /proc/stram.
-
-config HEARTBEAT
-	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
-	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
-	help
-	  Use the power-on LED on your machine as a load meter.  The exact
-	  behavior is platform-dependent, but normally the flash frequency is
-	  a hyperbolic function of the 5-minute load average.
-
-# We have a dedicated heartbeat LED. :-)
-config PROC_HARDWARE
-	bool "/proc/hardware support"
-	help
-	  Say Y here to support the /proc/hardware file, which gives you
-	  access to information about the machine you're running on,
-	  including the model, CPU, MMU, clock speed, BogoMIPS rating,
-	  and memory size.
-
-config ISA
-	bool
-	depends on Q40 || AMIGA_PCMCIA
-	default y
-	help
-	  Find out whether you have ISA slots on your motherboard.  ISA is the
-	  name of a bus system, i.e. the way the CPU talks to the other stuff
-	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
-	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
-	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
-
-config GENERIC_ISA_DMA
-	bool
-	depends on Q40 || AMIGA_PCMCIA
-	default y
-
-config ZONE_DMA
-	bool
-	default y
-
-source "drivers/pci/Kconfig"
-
-source "drivers/zorro/Kconfig"
-
-endmenu
-
-source "net/Kconfig"
-
-source "drivers/Kconfig"
-
-menu "Character devices"
-
-config ATARI_MFPSER
-	tristate "Atari MFP serial support"
-	depends on ATARI
-	---help---
-	  If you like to use the MFP serial ports ("Modem1", "Serial1") under
-	  Linux, say Y. The driver equally supports all kinds of MFP serial
-	  ports and automatically detects whether Serial1 is available.
-
-	  To compile this driver as a module, choose M here.
-
-	  Note for Falcon users: You also have an MFP port, it's just not
-	  wired to the outside... But you could use the port under Linux.
-
-config ATARI_MIDI
-	tristate "Atari MIDI serial support"
-	depends on ATARI
-	help
-	  If you want to use your Atari's MIDI port in Linux, say Y.
-
-	  To compile this driver as a module, choose M here.
-
-config ATARI_DSP56K
-	tristate "Atari DSP56k support (EXPERIMENTAL)"
-	depends on ATARI && EXPERIMENTAL
-	help
-	  If you want to be able to use the DSP56001 in Falcons, say Y. This
-	  driver is still experimental, and if you don't know what it is, or
-	  if you don't have this processor, just say N.
-
-	  To compile this driver as a module, choose M here.
-
-config AMIGA_BUILTIN_SERIAL
-	tristate "Amiga builtin serial support"
-	depends on AMIGA
-	help
-	  If you want to use your Amiga's built-in serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config MULTIFACE_III_TTY
-	tristate "Multiface Card III serial support"
-	depends on AMIGA
-	help
-	  If you want to use a Multiface III card's serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config GVPIOEXT
-	tristate "GVP IO-Extender support"
-	depends on PARPORT=n && ZORRO
-	help
-	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
-	  Otherwise, say N.
-
-config GVPIOEXT_LP
-	tristate "GVP IO-Extender parallel printer support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable driving a printer from the parallel port on your
-	  GVP IO-Extender card, N otherwise.
-
-config GVPIOEXT_PLIP
-	tristate "GVP IO-Extender PLIP support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable doing IP over the parallel port on your GVP
-	  IO-Extender card, N otherwise.
-
-config MAC_HID
-	bool
-	depends on INPUT_ADBHID
-	default y
-
-config HPDCA
-	tristate "HP DCA serial support"
-	depends on DIO && SERIAL_8250
-	help
-	  If you want to use the internal "DCA" serial ports on an HP300
-	  machine, say Y here.
-
-config HPAPCI
-	tristate "HP APCI serial support"
-	depends on HP300 && SERIAL_8250 && EXPERIMENTAL
-	help
-	  If you want to use the internal "APCI" serial ports on an HP400
-	  machine, say Y here.
-
-config MVME147_SCC
-	bool "SCC support for MVME147 serial ports"
-	depends on MVME147 && BROKEN
-	help
-	  This is the driver for the serial ports on the Motorola MVME147
-	  boards.  Everyone using one of these boards should say Y here.
-
-config MVME162_SCC
-	bool "SCC support for MVME162 serial ports"
-	depends on MVME16x && BROKEN
-	help
-	  This is the driver for the serial ports on the Motorola MVME162 and
-	  172 boards.  Everyone using one of these boards should say Y here.
-
-config BVME6000_SCC
-	bool "SCC support for BVME6000 serial ports"
-	depends on BVME6000 && BROKEN
-	help
-	  This is the driver for the serial ports on the BVME4000 and BVME6000
-	  boards from BVM Ltd.  Everyone using one of these boards should say
-	  Y here.
-
-config DN_SERIAL
-	bool "Support for DN serial port (dummy)"
-	depends on APOLLO
-
-config SERIAL_CONSOLE
-	bool "Support for serial port console"
-	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
-	---help---
-	  If you say Y here, it will be possible to use a serial port as the
-	  system console (the system console is the device which receives all
-	  kernel messages and warnings and which allows logins in single user
-	  mode). This could be useful if some terminal or printer is connected
-	  to that serial port.
-
-	  Even if you say Y here, the currently visible virtual console
-	  (/dev/tty0) will still be used as the system console by default, but
-	  you can alter that using a kernel command line option such as
-	  "console=ttyS1". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
-
-	  If you don't have a VGA card installed and you say Y here, the
-	  kernel will automatically use the first serial line, /dev/ttyS0, as
-	  system console.
-
-	  If unsure, say N.
-
-endmenu
-
-source "fs/Kconfig"
-
-source "arch/m68k/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
+config M68K
+	bool
+	default y
+	select HAVE_IDE
+	select HAVE_AOUT if MMU
+	select GENERIC_ATOMIC64 if MMU
+	select HAVE_GENERIC_HARDIRQS if !MMU
+	select GENERIC_HARDIRQS_NO_DEPRECATED if !MMU
+
+config RWSEM_GENERIC_SPINLOCK
+	bool
+	default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config ARCH_HAS_ILOG2_U32
+	bool
+
+config ARCH_HAS_ILOG2_U64
+	bool
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config GENERIC_CALIBRATE_DELAY
+	bool
+	default y
+
+config TIME_LOW_RES
+	bool
+	default y
+
+config NO_IOPORT
+	def_bool y
+
+config NO_DMA
+	def_bool (MMU && SUN3) || (!MMU && !COLDFIRE)
+
+config ZONE_DMA
+	bool
+	default y
+config HZ
+	int
+	default 1000 if CLEOPATRA
+	default 100
+
+source "init/Kconfig"
+
+source "kernel/Kconfig.freezer"
+
+config MMU
+	bool "MMU-based Paged Memory Management Support"
+	default y
+	help
+	  Select if you want MMU-based virtualised addressing space
+	  support by paged memory management. If unsure, say 'Y'.
+
+menu "Platform dependent setup"
+
+if MMU
+source arch/m68k/Kconfig.mmu
+endif
+if !MMU
+source arch/m68k/Kconfig.nommu
+endif
+
+source "mm/Kconfig"
+
+endmenu
+
+menu "Executable file formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+if !MMU
+menu "Power management options"
+
+config PM
+        bool "Power Management support"
+        help
+          Support processor power management modes
+
+endmenu
+endif
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+if MMU
+
+menu "Character devices"
+
+config ATARI_MFPSER
+	tristate "Atari MFP serial support"
+	depends on ATARI
+	---help---
+	  If you like to use the MFP serial ports ("Modem1", "Serial1") under
+	  Linux, say Y. The driver equally supports all kinds of MFP serial
+	  ports and automatically detects whether Serial1 is available.
+
+	  To compile this driver as a module, choose M here.
+
+	  Note for Falcon users: You also have an MFP port, it's just not
+	  wired to the outside... But you could use the port under Linux.
+
+config ATARI_MIDI
+	tristate "Atari MIDI serial support"
+	depends on ATARI
+	help
+	  If you want to use your Atari's MIDI port in Linux, say Y.
+
+	  To compile this driver as a module, choose M here.
+
+config ATARI_DSP56K
+	tristate "Atari DSP56k support (EXPERIMENTAL)"
+	depends on ATARI && EXPERIMENTAL
+	help
+	  If you want to be able to use the DSP56001 in Falcons, say Y. This
+	  driver is still experimental, and if you don't know what it is, or
+	  if you don't have this processor, just say N.
+
+	  To compile this driver as a module, choose M here.
+
+config AMIGA_BUILTIN_SERIAL
+	tristate "Amiga builtin serial support"
+	depends on AMIGA
+	help
+	  If you want to use your Amiga's built-in serial port in Linux,
+	  answer Y.
+
+	  To compile this driver as a module, choose M here.
+
+config MULTIFACE_III_TTY
+	tristate "Multiface Card III serial support"
+	depends on AMIGA
+	help
+	  If you want to use a Multiface III card's serial port in Linux,
+	  answer Y.
+
+	  To compile this driver as a module, choose M here.
+
+config GVPIOEXT
+	tristate "GVP IO-Extender support"
+	depends on PARPORT=n && ZORRO
+	help
+	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
+	  Otherwise, say N.
+
+config GVPIOEXT_LP
+	tristate "GVP IO-Extender parallel printer support"
+	depends on GVPIOEXT
+	help
+	  Say Y to enable driving a printer from the parallel port on your
+	  GVP IO-Extender card, N otherwise.
+
+config GVPIOEXT_PLIP
+	tristate "GVP IO-Extender PLIP support"
+	depends on GVPIOEXT
+	help
+	  Say Y to enable doing IP over the parallel port on your GVP
+	  IO-Extender card, N otherwise.
+
+config MAC_HID
+	bool
+	depends on INPUT_ADBHID
+	default y
+
+config HPDCA
+	tristate "HP DCA serial support"
+	depends on DIO && SERIAL_8250
+	help
+	  If you want to use the internal "DCA" serial ports on an HP300
+	  machine, say Y here.
+
+config HPAPCI
+	tristate "HP APCI serial support"
+	depends on HP300 && SERIAL_8250 && EXPERIMENTAL
+	help
+	  If you want to use the internal "APCI" serial ports on an HP400
+	  machine, say Y here.
+
+config MVME147_SCC
+	bool "SCC support for MVME147 serial ports"
+	depends on MVME147 && BROKEN
+	help
+	  This is the driver for the serial ports on the Motorola MVME147
+	  boards.  Everyone using one of these boards should say Y here.
+
+config MVME162_SCC
+	bool "SCC support for MVME162 serial ports"
+	depends on MVME16x && BROKEN
+	help
+	  This is the driver for the serial ports on the Motorola MVME162 and
+	  172 boards.  Everyone using one of these boards should say Y here.
+
+config BVME6000_SCC
+	bool "SCC support for BVME6000 serial ports"
+	depends on BVME6000 && BROKEN
+	help
+	  This is the driver for the serial ports on the BVME4000 and BVME6000
+	  boards from BVM Ltd.  Everyone using one of these boards should say
+	  Y here.
+
+config DN_SERIAL
+	bool "Support for DN serial port (dummy)"
+	depends on APOLLO
+
+config SERIAL_CONSOLE
+	bool "Support for serial port console"
+	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
+	---help---
+	  If you say Y here, it will be possible to use a serial port as the
+	  system console (the system console is the device which receives all
+	  kernel messages and warnings and which allows logins in single user
+	  mode). This could be useful if some terminal or printer is connected
+	  to that serial port.
+
+	  Even if you say Y here, the currently visible virtual console
+	  (/dev/tty0) will still be used as the system console by default, but
+	  you can alter that using a kernel command line option such as
+	  "console=ttyS1". (Try "man bootparam" or see the documentation of
+	  your boot loader (lilo or loadlin) about how to pass options to the
+	  kernel at boot time.)
+
+	  If you don't have a VGA card installed and you say Y here, the
+	  kernel will automatically use the first serial line, /dev/ttyS0, as
+	  system console.
+
+	  If unsure, say N.
+
+endmenu
+
+endif
+
+source "fs/Kconfig"
+
+source "arch/m68k/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/m68knommu/Kconfig.debug b/arch/m68k/Kconfig.debug
similarity index 97%
rename from arch/m68knommu/Kconfig.debug
rename to arch/m68k/Kconfig.debug
index ed6d9a8..2bdb1b0 100644
--- a/arch/m68knommu/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -2,6 +2,8 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
+if !MMU
+
 config FULLDEBUG
 	bool "Full Symbolic/Source Debugging support"
 	help
@@ -32,4 +34,6 @@ config BDM_DISABLE
 	help
 	  Disable the ColdFire CPU's BDM signals.
 
+endif
+
 endmenu
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig.mmu
similarity index 72%
rename from arch/m68k/Kconfig
rename to arch/m68k/Kconfig.mmu
index 525174d..16539b1 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig.mmu
@@ -1,39 +1,3 @@
-config M68K
-	bool
-	default y
-	select HAVE_AOUT
-	select HAVE_IDE
-	select GENERIC_ATOMIC64
-
-config MMU
-	bool
-	default y
-
-config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
-
-config RWSEM_XCHGADD_ALGORITHM
-	bool
-
-config ARCH_HAS_ILOG2_U32
-	bool
-
-config ARCH_HAS_ILOG2_U64
-	bool
-
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
-
-config TIME_LOW_RES
-	bool
-	default y
-
 config GENERIC_IOMAP
 	bool
 	default y
@@ -43,25 +7,9 @@ config ARCH_MAY_HAVE_PC_FDC
 	depends on BROKEN && (Q40 || SUN3X)
 	default y
 
-config NO_IOPORT
-	def_bool y
-
-config NO_DMA
-	def_bool SUN3
-
-config HZ
-	int
-	default 100
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
-source "init/Kconfig"
-
-source "kernel/Kconfig.freezer"
-
-menu "Platform dependent setup"
-
 config EISA
 	bool
 	---help---
@@ -406,14 +354,6 @@ config NODES_SHIFT
 	default "3"
 	depends on !SINGLE_MEMORY_CHUNK
 
-source "mm/Kconfig"
-
-endmenu
-
-menu "General setup"
-
-source "fs/Kconfig.binfmt"
-
 config ZORRO
 	bool "Amiga Zorro (AutoConfig) bus support"
 	depends on AMIGA
@@ -471,168 +411,7 @@ config GENERIC_ISA_DMA
 	depends on Q40 || AMIGA_PCMCIA
 	default y
 
-config ZONE_DMA
-	bool
-	default y
-
 source "drivers/pci/Kconfig"
 
 source "drivers/zorro/Kconfig"
 
-endmenu
-
-source "net/Kconfig"
-
-source "drivers/Kconfig"
-
-menu "Character devices"
-
-config ATARI_MFPSER
-	tristate "Atari MFP serial support"
-	depends on ATARI
-	---help---
-	  If you like to use the MFP serial ports ("Modem1", "Serial1") under
-	  Linux, say Y. The driver equally supports all kinds of MFP serial
-	  ports and automatically detects whether Serial1 is available.
-
-	  To compile this driver as a module, choose M here.
-
-	  Note for Falcon users: You also have an MFP port, it's just not
-	  wired to the outside... But you could use the port under Linux.
-
-config ATARI_MIDI
-	tristate "Atari MIDI serial support"
-	depends on ATARI
-	help
-	  If you want to use your Atari's MIDI port in Linux, say Y.
-
-	  To compile this driver as a module, choose M here.
-
-config ATARI_DSP56K
-	tristate "Atari DSP56k support (EXPERIMENTAL)"
-	depends on ATARI && EXPERIMENTAL
-	help
-	  If you want to be able to use the DSP56001 in Falcons, say Y. This
-	  driver is still experimental, and if you don't know what it is, or
-	  if you don't have this processor, just say N.
-
-	  To compile this driver as a module, choose M here.
-
-config AMIGA_BUILTIN_SERIAL
-	tristate "Amiga builtin serial support"
-	depends on AMIGA
-	help
-	  If you want to use your Amiga's built-in serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config MULTIFACE_III_TTY
-	tristate "Multiface Card III serial support"
-	depends on AMIGA
-	help
-	  If you want to use a Multiface III card's serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
-config GVPIOEXT
-	tristate "GVP IO-Extender support"
-	depends on PARPORT=n && ZORRO
-	help
-	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
-	  Otherwise, say N.
-
-config GVPIOEXT_LP
-	tristate "GVP IO-Extender parallel printer support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable driving a printer from the parallel port on your
-	  GVP IO-Extender card, N otherwise.
-
-config GVPIOEXT_PLIP
-	tristate "GVP IO-Extender PLIP support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable doing IP over the parallel port on your GVP
-	  IO-Extender card, N otherwise.
-
-config MAC_HID
-	bool
-	depends on INPUT_ADBHID
-	default y
-
-config HPDCA
-	tristate "HP DCA serial support"
-	depends on DIO && SERIAL_8250
-	help
-	  If you want to use the internal "DCA" serial ports on an HP300
-	  machine, say Y here.
-
-config HPAPCI
-	tristate "HP APCI serial support"
-	depends on HP300 && SERIAL_8250 && EXPERIMENTAL
-	help
-	  If you want to use the internal "APCI" serial ports on an HP400
-	  machine, say Y here.
-
-config MVME147_SCC
-	bool "SCC support for MVME147 serial ports"
-	depends on MVME147 && BROKEN
-	help
-	  This is the driver for the serial ports on the Motorola MVME147
-	  boards.  Everyone using one of these boards should say Y here.
-
-config MVME162_SCC
-	bool "SCC support for MVME162 serial ports"
-	depends on MVME16x && BROKEN
-	help
-	  This is the driver for the serial ports on the Motorola MVME162 and
-	  172 boards.  Everyone using one of these boards should say Y here.
-
-config BVME6000_SCC
-	bool "SCC support for BVME6000 serial ports"
-	depends on BVME6000 && BROKEN
-	help
-	  This is the driver for the serial ports on the BVME4000 and BVME6000
-	  boards from BVM Ltd.  Everyone using one of these boards should say
-	  Y here.
-
-config DN_SERIAL
-	bool "Support for DN serial port (dummy)"
-	depends on APOLLO
-
-config SERIAL_CONSOLE
-	bool "Support for serial port console"
-	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
-	---help---
-	  If you say Y here, it will be possible to use a serial port as the
-	  system console (the system console is the device which receives all
-	  kernel messages and warnings and which allows logins in single user
-	  mode). This could be useful if some terminal or printer is connected
-	  to that serial port.
-
-	  Even if you say Y here, the currently visible virtual console
-	  (/dev/tty0) will still be used as the system console by default, but
-	  you can alter that using a kernel command line option such as
-	  "console=ttyS1". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
-
-	  If you don't have a VGA card installed and you say Y here, the
-	  kernel will automatically use the first serial line, /dev/ttyS0, as
-	  system console.
-
-	  If unsure, say N.
-
-endmenu
-
-source "fs/Kconfig"
-
-source "arch/m68k/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
diff --git a/arch/m68knommu/Kconfig b/arch/m68k/Kconfig.nommu
similarity index 93%
rename from arch/m68knommu/Kconfig
rename to arch/m68k/Kconfig.nommu
index b5424cf..273bcca 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68k/Kconfig.nommu
@@ -1,43 +1,7 @@
-config M68K
-	bool
-	default y
-	select HAVE_IDE
-	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
-
-config MMU
-	bool
-	default n
-
-config NO_DMA
-	bool
-	depends on !COLDFIRE
-	default y
-
 config FPU
 	bool
 	default n
 
-config ZONE_DMA
-	bool
-	default y
-
-config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
-
-config RWSEM_XCHGADD_ALGORITHM
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U32
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U64
-	bool
-	default n
-
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
@@ -46,29 +10,14 @@ config GENERIC_GPIO
 	bool
 	default n
 
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
 
-config TIME_LOW_RES
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default n
 
-config NO_IOPORT
-	def_bool y
-
 config COLDFIRE_SW_A7
 	bool
 	default n
@@ -85,12 +34,6 @@ config HAVE_MBAR
 config HAVE_IPSBAR
 	bool
 
-source "init/Kconfig"
-
-source "kernel/Kconfig.freezer"
-
-menu "Processor type and features"
-
 choice
 	prompt "CPU"
 	default M68EZ328
@@ -630,11 +573,6 @@ config 4KSTACKS
 	  running more threads on a system and also reduces the pressure
 	  on the VM subsystem for higher order allocations.
 
-config HZ
-	int
-	default 1000 if CLEOPATRA
-	default 100
-
 comment "RAM configuration"
 
 config RAMBASE
@@ -803,10 +741,6 @@ endif
 
 source "kernel/time/Kconfig"
 
-source "mm/Kconfig"
-
-endmenu
-
 config ISA_DMA_API
 	bool
 	depends on !M5272
@@ -814,31 +748,3 @@ config ISA_DMA_API
 
 source "drivers/pcmcia/Kconfig"
 
-menu "Executable file formats"
-
-source "fs/Kconfig.binfmt"
-
-endmenu
-
-menu "Power management options"
-
-config PM
-	bool "Power Management support"
-	help
-	  Support processor power management modes
-
-endmenu
-
-source "net/Kconfig"
-
-source "drivers/Kconfig"
-
-source "fs/Kconfig"
-
-source "arch/m68knommu/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
diff --git a/arch/m68knommu/Makefile b/arch/m68k/Makefile_no
similarity index 93%
rename from arch/m68knommu/Makefile
rename to arch/m68k/Makefile_no
index 589613f..c2a6e9d 100644
--- a/arch/m68knommu/Makefile
+++ b/arch/m68k/Makefile_no
@@ -1,5 +1,5 @@
 #
-# arch/m68knommu/Makefile
+# arch/m68k/Makefile
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -82,7 +82,7 @@ cpuclass-$(CONFIG_M68360)	:= 68360
 CPUCLASS := $(cpuclass-y)
 
 ifneq ($(CPUCLASS),$(PLATFORM))
-CLASSDIR := arch/m68knommu/platform/$(cpuclass-y)/
+CLASSDIR := arch/m68k/platform/$(cpuclass-y)/
 endif
 
 export PLATFORM BOARD MODEL CPUCLASS
@@ -114,13 +114,13 @@ KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += -D__linux__
 KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 
-head-y := arch/m68knommu/platform/$(cpuclass-y)/head.o
+head-y := arch/m68k/platform/$(cpuclass-y)/head.o
 
-core-y	+= arch/m68knommu/kernel/ \
-	   arch/m68knommu/mm/ \
+core-y	+= arch/m68k/kernel/ \
+	   arch/m68k/mm/ \
 	   $(CLASSDIR) \
-	   arch/m68knommu/platform/$(PLATFORM)/
-libs-y	+= arch/m68knommu/lib/
+	   arch/m68k/platform/$(PLATFORM)/
+libs-y	+= arch/m68k/lib/
 
 archclean:
 
diff --git a/arch/m68knommu/configs/m5208evb_defconfig b/arch/m68k/configs/m5208evb_defconfig
similarity index 98%
rename from arch/m68knommu/configs/m5208evb_defconfig
rename to arch/m68k/configs/m5208evb_defconfig
index 2f5655c..7a5967f 100644
--- a/arch/m68knommu/configs/m5208evb_defconfig
+++ b/arch/m68k/configs/m5208evb_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_MMU is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m68knommu/configs/m5249evb_defconfig b/arch/m68k/configs/m5249evb_defconfig
similarity index 98%
rename from arch/m68knommu/configs/m5249evb_defconfig
rename to arch/m68k/configs/m5249evb_defconfig
index 16df72b..fc4e033 100644
--- a/arch/m68knommu/configs/m5249evb_defconfig
+++ b/arch/m68k/configs/m5249evb_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_MMU is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m68knommu/configs/m5272c3_defconfig b/arch/m68k/configs/m5272c3_defconfig
similarity index 98%
rename from arch/m68knommu/configs/m5272c3_defconfig
rename to arch/m68k/configs/m5272c3_defconfig
index 4e6ea50..3b5591d 100644
--- a/arch/m68knommu/configs/m5272c3_defconfig
+++ b/arch/m68k/configs/m5272c3_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_MMU is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m68knommu/configs/m5275evb_defconfig b/arch/m68k/configs/m5275evb_defconfig
similarity index 98%
rename from arch/m68knommu/configs/m5275evb_defconfig
rename to arch/m68k/configs/m5275evb_defconfig
index f3dd741..fe1a30e 100644
--- a/arch/m68knommu/configs/m5275evb_defconfig
+++ b/arch/m68k/configs/m5275evb_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_MMU is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m68knommu/configs/m5307c3_defconfig b/arch/m68k/configs/m5307c3_defconfig
similarity index 98%
rename from arch/m68knommu/configs/m5307c3_defconfig
rename to arch/m68k/configs/m5307c3_defconfig
index bce0a20..342ab94 100644
--- a/arch/m68knommu/configs/m5307c3_defconfig
+++ b/arch/m68k/configs/m5307c3_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_MMU is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m68knommu/configs/m5407c3_defconfig b/arch/m68k/configs/m5407c3_defconfig
similarity index 98%
rename from arch/m68knommu/configs/m5407c3_defconfig
rename to arch/m68k/configs/m5407c3_defconfig
index 618cc32..b38aa6e 100644
--- a/arch/m68knommu/configs/m5407c3_defconfig
+++ b/arch/m68k/configs/m5407c3_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_MMU is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
1.7.0.4

