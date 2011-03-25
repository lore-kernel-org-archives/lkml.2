Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1CYWqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:46:14 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:36571 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1CYWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:46:12 -0400
Date: Sat, 26 Mar 2011 08:44:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201103252244.p2PMixCg002806@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>
Subject: [git pull] merge m68k and m68knommu arch directories
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains only a single commit that merges the m68k and m68knommu
arch directories. Once commited there is no longer an arch/m68knommu
directory. This is a brute force merge, and there is still some more
fine-grained merging of files needed to really complete it. But this
is the first critical step we need to take to get this done.

Thanks
Greg



The following changes since commit d39dd11c3e6a7af5c20bfac40594db36cf270f42:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      m68k: merge m68k and m68knommu arch directories

 arch/m68k/Kconfig                                  |  456 +-------
 arch/m68k/Kconfig.debug                            |   34 +
 arch/m68k/Kconfig.mmu                              |  417 +++++++
 arch/{m68knommu/Kconfig => m68k/Kconfig.nommu}     |   94 --
 arch/m68k/Makefile                                 |  122 +--
 arch/m68k/Makefile_mm                              |  121 ++
 arch/{m68knommu/Makefile => m68k/Makefile_no}      |   16 +-
 .../{m68knommu => m68k}/configs/m5208evb_defconfig |    2 +
 .../{m68knommu => m68k}/configs/m5249evb_defconfig |    2 +
 arch/{m68knommu => m68k}/configs/m5272c3_defconfig |    2 +
 .../{m68knommu => m68k}/configs/m5275evb_defconfig |    2 +
 arch/{m68knommu => m68k}/configs/m5307c3_defconfig |    2 +
 arch/{m68knommu => m68k}/configs/m5407c3_defconfig |    2 +
 arch/m68k/kernel/Makefile                          |   18 +-
 arch/m68k/kernel/Makefile_mm                       |   17 +
 .../kernel/Makefile => m68k/kernel/Makefile_no}    |    0
 arch/m68k/kernel/asm-offsets.c                     |  101 +--
 .../asm-offsets.c => m68k/kernel/asm-offsets_mm.c} |   66 +-
 .../asm-offsets.c => m68k/kernel/asm-offsets_no.c} |    0
 arch/m68k/kernel/dma.c                             |  135 +---
 arch/m68k/kernel/dma_mm.c                          |  130 +++
 .../kernel/dma.c => m68k/kernel/dma_no.c}          |    0
 arch/m68k/kernel/entry.S                           |  756 +------------
 arch/m68k/kernel/entry_mm.S                        |  753 ++++++++++++
 .../kernel/entry.S => m68k/kernel/entry_no.S}      |    0
 arch/{m68knommu => m68k}/kernel/init_task.c        |    0
 arch/{m68knommu => m68k}/kernel/irq.c              |    0
 arch/m68k/kernel/m68k_ksyms.c                      |   21 +-
 arch/m68k/kernel/m68k_ksyms_mm.c                   |   16 +
 .../m68k_ksyms.c => m68k/kernel/m68k_ksyms_no.c}   |    0
 arch/m68k/kernel/module.c                          |  156 +---
 .../kernel/module.c => m68k/kernel/module_mm.c}    |   31 +-
 .../kernel/module.c => m68k/kernel/module_no.c}    |    0
 arch/m68k/kernel/process.c                         |  355 +------
 .../kernel/process.c => m68k/kernel/process_mm.c}  |  262 ++---
 .../kernel/process.c => m68k/kernel/process_no.c}  |    0
 arch/m68k/kernel/ptrace.c                          |  282 +-----
 arch/m68k/kernel/ptrace_mm.c                       |  277 +++++
 .../kernel/ptrace.c => m68k/kernel/ptrace_no.c}    |    0
 arch/m68k/kernel/setup.c                           |  534 +---------
 arch/m68k/kernel/setup_mm.c                        |  533 +++++++++
 .../kernel/setup.c => m68k/kernel/setup_no.c}      |    0
 arch/m68k/kernel/signal.c                          | 1018 +----------------
 .../kernel/signal.c => m68k/kernel/signal_mm.c}    |  432 ++++++--
 .../kernel/signal.c => m68k/kernel/signal_no.c}    |    0
 arch/m68k/kernel/sys_m68k.c                        |  551 +---------
 arch/m68k/kernel/sys_m68k_mm.c                     |  546 +++++++++
 .../sys_m68k.c => m68k/kernel/sys_m68k_no.c}       |    0
 arch/{m68knommu => m68k}/kernel/syscalltable.S     |    0
 arch/m68k/kernel/time.c                            |  119 +--
 arch/m68k/kernel/time_mm.c                         |  114 ++
 .../kernel/time.c => m68k/kernel/time_no.c}        |    0
 arch/m68k/kernel/traps.c                           | 1208 +-------------------
 arch/m68k/kernel/traps_mm.c                        | 1207 +++++++++++++++++++
 .../kernel/traps.c => m68k/kernel/traps_no.c}      |    0
 arch/m68k/kernel/vmlinux.lds.S                     |   11 +-
 arch/m68k/kernel/vmlinux.lds_mm.S                  |   10 +
 .../vmlinux.lds.S => m68k/kernel/vmlinux.lds_no.S} |    0
 arch/m68k/lib/Makefile                             |   11 +-
 arch/m68k/lib/Makefile_mm                          |    6 +
 .../lib/Makefile => m68k/lib/Makefile_no}          |    0
 arch/m68k/lib/checksum.c                           |  430 +-------
 arch/m68k/lib/checksum_mm.c                        |  425 +++++++
 .../lib/checksum.c => m68k/lib/checksum_no.c}      |    0
 arch/{m68knommu => m68k}/lib/delay.c               |    0
 arch/{m68knommu => m68k}/lib/divsi3.S              |    0
 arch/{m68knommu => m68k}/lib/memcpy.c              |    0
 arch/{m68knommu => m68k}/lib/memmove.c             |    0
 arch/{m68knommu => m68k}/lib/memset.c              |    0
 arch/{m68knommu => m68k}/lib/modsi3.S              |    0
 arch/m68k/lib/muldi3.c                             |   68 +-
 .../lib/ashrdi3.c => m68k/lib/muldi3_mm.c}         |   48 +-
 .../lib/muldi3.c => m68k/lib/muldi3_no.c}          |    0
 arch/{m68knommu => m68k}/lib/mulsi3.S              |    0
 arch/{m68knommu => m68k}/lib/udivsi3.S             |    0
 arch/{m68knommu => m68k}/lib/umodsi3.S             |    0
 arch/m68k/mm/Makefile                              |   13 +-
 arch/m68k/mm/Makefile_mm                           |    8 +
 .../{m68knommu/mm/Makefile => m68k/mm/Makefile_no} |    0
 arch/m68k/mm/init.c                                |  153 +---
 arch/m68k/mm/init_mm.c                             |  150 +++
 arch/{m68knommu/mm/init.c => m68k/mm/init_no.c}    |    0
 arch/m68k/mm/kmap.c                                |  368 +------
 arch/m68k/mm/kmap_mm.c                             |  367 ++++++
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
 arch/m68knommu/Kconfig.debug                       |   35 -
 arch/m68knommu/defconfig                           |   74 --
 arch/m68knommu/kernel/.gitignore                   |    1 -
 arch/m68knommu/lib/ashldi3.c                       |   62 -
 arch/m68knommu/lib/lshrdi3.c                       |   62 -
 170 files changed, 5813 insertions(+), 7399 deletions(-)
 create mode 100644 arch/m68k/Kconfig.mmu
 rename arch/{m68knommu/Kconfig => m68k/Kconfig.nommu} (93%)
 create mode 100644 arch/m68k/Makefile_mm
 rename arch/{m68knommu/Makefile => m68k/Makefile_no} (92%)
 rename arch/{m68knommu => m68k}/configs/m5208evb_defconfig (97%)
 rename arch/{m68knommu => m68k}/configs/m5249evb_defconfig (97%)
 rename arch/{m68knommu => m68k}/configs/m5272c3_defconfig (96%)
 rename arch/{m68knommu => m68k}/configs/m5275evb_defconfig (97%)
 rename arch/{m68knommu => m68k}/configs/m5307c3_defconfig (97%)
 rename arch/{m68knommu => m68k}/configs/m5407c3_defconfig (97%)
 create mode 100644 arch/m68k/kernel/Makefile_mm
 rename arch/{m68knommu/kernel/Makefile => m68k/kernel/Makefile_no} (100%)
 copy arch/{m68knommu/kernel/asm-offsets.c => m68k/kernel/asm-offsets_mm.c} (55%)
 rename arch/{m68knommu/kernel/asm-offsets.c => m68k/kernel/asm-offsets_no.c} (100%)
 create mode 100644 arch/m68k/kernel/dma_mm.c
 rename arch/{m68knommu/kernel/dma.c => m68k/kernel/dma_no.c} (100%)
 create mode 100644 arch/m68k/kernel/entry_mm.S
 rename arch/{m68knommu/kernel/entry.S => m68k/kernel/entry_no.S} (100%)
 rename arch/{m68knommu => m68k}/kernel/init_task.c (100%)
 rename arch/{m68knommu => m68k}/kernel/irq.c (100%)
 create mode 100644 arch/m68k/kernel/m68k_ksyms_mm.c
 rename arch/{m68knommu/kernel/m68k_ksyms.c => m68k/kernel/m68k_ksyms_no.c} (100%)
 copy arch/{m68knommu/kernel/module.c => m68k/kernel/module_mm.c} (81%)
 rename arch/{m68knommu/kernel/module.c => m68k/kernel/module_no.c} (100%)
 copy arch/{m68knommu/kernel/process.c => m68k/kernel/process_mm.c} (58%)
 rename arch/{m68knommu/kernel/process.c => m68k/kernel/process_no.c} (100%)
 create mode 100644 arch/m68k/kernel/ptrace_mm.c
 rename arch/{m68knommu/kernel/ptrace.c => m68k/kernel/ptrace_no.c} (100%)
 create mode 100644 arch/m68k/kernel/setup_mm.c
 rename arch/{m68knommu/kernel/setup.c => m68k/kernel/setup_no.c} (100%)
 copy arch/{m68knommu/kernel/signal.c => m68k/kernel/signal_mm.c} (63%)
 rename arch/{m68knommu/kernel/signal.c => m68k/kernel/signal_no.c} (100%)
 create mode 100644 arch/m68k/kernel/sys_m68k_mm.c
 rename arch/{m68knommu/kernel/sys_m68k.c => m68k/kernel/sys_m68k_no.c} (100%)
 rename arch/{m68knommu => m68k}/kernel/syscalltable.S (100%)
 create mode 100644 arch/m68k/kernel/time_mm.c
 rename arch/{m68knommu/kernel/time.c => m68k/kernel/time_no.c} (100%)
 create mode 100644 arch/m68k/kernel/traps_mm.c
 rename arch/{m68knommu/kernel/traps.c => m68k/kernel/traps_no.c} (100%)
 create mode 100644 arch/m68k/kernel/vmlinux.lds_mm.S
 rename arch/{m68knommu/kernel/vmlinux.lds.S => m68k/kernel/vmlinux.lds_no.S} (100%)
 create mode 100644 arch/m68k/lib/Makefile_mm
 rename arch/{m68knommu/lib/Makefile => m68k/lib/Makefile_no} (100%)
 create mode 100644 arch/m68k/lib/checksum_mm.c
 rename arch/{m68knommu/lib/checksum.c => m68k/lib/checksum_no.c} (100%)
 rename arch/{m68knommu => m68k}/lib/delay.c (100%)
 rename arch/{m68knommu => m68k}/lib/divsi3.S (100%)
 rename arch/{m68knommu => m68k}/lib/memcpy.c (100%)
 rename arch/{m68knommu => m68k}/lib/memmove.c (100%)
 rename arch/{m68knommu => m68k}/lib/memset.c (100%)
 rename arch/{m68knommu => m68k}/lib/modsi3.S (100%)
 rename arch/{m68knommu/lib/ashrdi3.c => m68k/lib/muldi3_mm.c} (60%)
 rename arch/{m68knommu/lib/muldi3.c => m68k/lib/muldi3_no.c} (100%)
 rename arch/{m68knommu => m68k}/lib/mulsi3.S (100%)
 rename arch/{m68knommu => m68k}/lib/udivsi3.S (100%)
 rename arch/{m68knommu => m68k}/lib/umodsi3.S (100%)
 create mode 100644 arch/m68k/mm/Makefile_mm
 rename arch/{m68knommu/mm/Makefile => m68k/mm/Makefile_no} (100%)
 create mode 100644 arch/m68k/mm/init_mm.c
 rename arch/{m68knommu/mm/init.c => m68k/mm/init_no.c} (100%)
 create mode 100644 arch/m68k/mm/kmap_mm.c
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
 delete mode 100644 arch/m68knommu/Kconfig.debug
 delete mode 100644 arch/m68knommu/defconfig
 delete mode 100644 arch/m68knommu/kernel/.gitignore
 delete mode 100644 arch/m68knommu/lib/ashldi3.c
 delete mode 100644 arch/m68knommu/lib/lshrdi3.c
