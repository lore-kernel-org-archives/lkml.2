Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1GHQDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:03:38 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:42413 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab1GHQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:03:37 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: Please submit platform trees for inclusion in arm-soc.git v3.1
Organization: Texas Instruments, Inc.
References: <201107012018.14619.arnd@arndb.de>
Date: Fri, 08 Jul 2011 09:03:32 -0700
In-Reply-To: <201107012018.14619.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 1 Jul 2011 20:18:14 +0200")
Message-ID: <87wrfsahez.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Arnd Bergmann <arnd@arndb.de> writes:

> Time is running out for the current cycle, so any changes that you
> want to see merged in linux-3.1 through the arm-soc tree should be
> submitted in form of pull-requests very soon.

[...]

It looks like your "remove rmk/for-next" commit may not have been
totally complete.

Trying to merge your master branch and Russell's current for-next branch
still results in conflicts in files that should only be touched in
Russell's branch (specifically, these seem related to changes in
Russell's 'suspend' branch that is included in his 'for-next' branch.)

Kevin


$ git checkout -b tmp/test v3.0-rc6
Switched to a new branch 'tmp/test'

$ git merge rmk/for-next
Updating fe0d422..b4584ba
Fast-forward
 Documentation/arm/SH-Mobile/zboot-rom-sdhi.txt    |   42 ++
 Documentation/arm/kernel_user_helpers.txt         |  267 +++++++++++
 Documentation/devicetree/bindings/arm/pmu.txt     |   21 +
 MAINTAINERS                                       |   10 +
 arch/arm/Kconfig                                  |   37 ++-
 arch/arm/boot/compressed/Makefile                 |   10 +-
 arch/arm/boot/compressed/head-shmobile.S          |   12 +-
 arch/arm/boot/compressed/mmcif-sh7372.c           |    2 +-
 arch/arm/boot/compressed/sdhi-sh7372.c            |   95 ++++
 arch/arm/boot/compressed/sdhi-shmobile.c          |  449 ++++++++++++++++++
 arch/arm/boot/compressed/sdhi-shmobile.h          |   11 +
 arch/arm/boot/compressed/vmlinux.lds.in           |   12 +-
 arch/arm/common/dmabounce.c                       |  193 ++++-----
 arch/arm/common/it8152.c                          |   16 +-
 arch/arm/common/sa1111.c                          |   60 ++--
 arch/arm/include/asm/dma-mapping.h                |   56 +--
 arch/arm/include/asm/entry-macro-multi.S          |   14 +-
 arch/arm/include/asm/mach/map.h                   |    2 +
 arch/arm/include/asm/memory.h                     |    7 +
 arch/arm/include/asm/pgalloc.h                    |    2 +-
 arch/arm/include/asm/pgtable.h                    |   23 +-
 arch/arm/include/asm/pmu.h                        |    2 +-
 arch/arm/include/asm/proc-fns.h                   |   14 +-
 arch/arm/include/asm/scatterlist.h                |    4 +
 arch/arm/include/asm/setup.h                      |    2 +-
 arch/arm/include/asm/suspend.h                    |   22 +
 arch/arm/include/asm/tcm.h                        |    2 +
 arch/arm/include/asm/tlb.h                        |    1 +
 arch/arm/kernel/entry-armv.S                      |  523 ++++++++-------------
 arch/arm/kernel/entry-header.S                    |   19 -
 arch/arm/kernel/hw_breakpoint.c                   |   12 +-
 arch/arm/kernel/perf_event.c                      |   10 +-
 arch/arm/kernel/pmu.c                             |   87 +++-
 arch/arm/kernel/setup.c                           |  101 ++--
 arch/arm/kernel/sleep.S                           |   84 ++--
 arch/arm/kernel/smp_scu.c                         |    2 +
 arch/arm/kernel/tcm.c                             |   68 +++-
 arch/arm/kernel/vmlinux.lds.S                     |  126 +++---
 arch/arm/mach-bcmring/include/mach/entry-macro.S  |    4 -
 arch/arm/mach-davinci/include/mach/entry-macro.S  |    3 -
 arch/arm/mach-ep93xx/core.c                       |    4 +-
 arch/arm/mach-exynos4/pm.c                        |    2 +-
 arch/arm/mach-exynos4/sleep.S                     |   22 -
 arch/arm/mach-h720x/include/mach/entry-macro.S    |    3 -
 arch/arm/mach-ixp4xx/common-pci.c                 |   12 +-
 arch/arm/mach-lpc32xx/include/mach/entry-macro.S  |    4 -
 arch/arm/mach-omap2/control.c                     |    7 +-
 arch/arm/mach-omap2/control.h                     |    6 +-
 arch/arm/mach-omap2/include/mach/entry-macro.S    |    3 -
 arch/arm/mach-omap2/pm.h                          |   22 +-
 arch/arm/mach-omap2/pm34xx.c                      |   86 ++--
 arch/arm/mach-omap2/sleep34xx.S                   |  518 ++++++++-------------
 arch/arm/mach-pnx4008/include/mach/entry-macro.S  |    5 -
 arch/arm/mach-pxa/include/mach/pm.h               |    4 +-
 arch/arm/mach-pxa/palmz72.c                       |    1 +
 arch/arm/mach-pxa/pm.c                            |    1 -
 arch/arm/mach-pxa/pxa25x.c                        |    3 +-
 arch/arm/mach-pxa/pxa27x.c                        |   11 +-
 arch/arm/mach-pxa/pxa3xx.c                        |   14 +-
 arch/arm/mach-pxa/sleep.S                         |   55 +--
 arch/arm/mach-pxa/zeus.c                          |    3 +-
 arch/arm/mach-realview/Kconfig                    |    1 +
 arch/arm/mach-s3c2412/pm.c                        |    6 +-
 arch/arm/mach-s3c2416/pm.c                        |    6 +-
 arch/arm/mach-s3c64xx/pm.c                        |    2 +-
 arch/arm/mach-s3c64xx/sleep.S                     |   23 -
 arch/arm/mach-s5pv210/pm.c                        |    2 +-
 arch/arm/mach-s5pv210/sleep.S                     |   21 -
 arch/arm/mach-sa1100/pm.c                         |    7 +-
 arch/arm/mach-sa1100/sleep.S                      |   19 +-
 arch/arm/mach-shark/include/mach/entry-macro.S    |   10 +-
 arch/arm/mach-shmobile/include/mach/sdhi-sh7372.h |   21 +
 arch/arm/mach-shmobile/include/mach/sdhi.h        |   16 +
 arch/arm/mach-vt8500/irq.c                        |   21 +-
 arch/arm/mm/abort-ev4.S                           |   17 +-
 arch/arm/mm/abort-ev4t.S                          |   17 +-
 arch/arm/mm/abort-ev5t.S                          |   19 +-
 arch/arm/mm/abort-ev5tj.S                         |   25 +-
 arch/arm/mm/abort-ev6.S                           |   25 +-
 arch/arm/mm/abort-ev7.S                           |   25 +-
 arch/arm/mm/abort-lv4t.S                          |  141 +++---
 arch/arm/mm/abort-macro.S                         |   34 +-
 arch/arm/mm/abort-nommu.S                         |   10 +-
 arch/arm/mm/alignment.c                           |    3 +
 arch/arm/mm/cache-l2x0.c                          |   19 +-
 arch/arm/mm/dma-mapping.c                         |  314 +++++++------
 arch/arm/mm/fault.c                               |    4 +
 arch/arm/mm/init.c                                |    8 +-
 arch/arm/mm/mm.h                                  |    2 +
 arch/arm/mm/mmu.c                                 |   29 +-
 arch/arm/mm/nommu.c                               |    4 +
 arch/arm/mm/pabort-legacy.S                       |   10 +-
 arch/arm/mm/pabort-v6.S                           |   10 +-
 arch/arm/mm/pabort-v7.S                           |   11 +-
 arch/arm/mm/proc-arm6_7.S                         |   90 ++--
 arch/arm/mm/proc-sa1100.S                         |    4 +-
 arch/arm/plat-mxc/include/mach/entry-macro.S      |    4 -
 arch/arm/plat-omap/sram.c                         |   15 +-
 arch/arm/plat-s3c24xx/sleep.S                     |   25 -
 arch/arm/plat-samsung/include/plat/pm.h           |    5 +-
 arch/arm/plat-samsung/pm.c                        |   11 +-
 drivers/mmc/host/mmci.c                           |    2 +
 drivers/mmc/host/mmci.h                           |    5 +-
 103 files changed, 2458 insertions(+), 1798 deletions(-)
 create mode 100644 Documentation/arm/SH-Mobile/zboot-rom-sdhi.txt
 create mode 100644 Documentation/arm/kernel_user_helpers.txt
 create mode 100644 Documentation/devicetree/bindings/arm/pmu.txt
 create mode 100644 arch/arm/boot/compressed/sdhi-sh7372.c
 create mode 100644 arch/arm/boot/compressed/sdhi-shmobile.c
 create mode 100644 arch/arm/boot/compressed/sdhi-shmobile.h
 create mode 100644 arch/arm/include/asm/suspend.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/sdhi-sh7372.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/sdhi.h

$ git merge arm-soc/master
Auto-merging arch/arm/Kconfig
Auto-merging arch/arm/include/asm/entry-macro-multi.S
CONFLICT (delete/modify): arch/arm/include/asm/suspend.h deleted in arm-soc/master and modified in HEAD. Version HEAD of arch/arm/include/asm/suspend.h left in tree.
Auto-merging arch/arm/kernel/setup.c
Auto-merging arch/arm/kernel/sleep.S
CONFLICT (content): Merge conflict in arch/arm/kernel/sleep.S
Auto-merging arch/arm/mach-exynos4/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos4/pm.c
Removing arch/arm/mach-mxs/gpio.h
Auto-merging arch/arm/mach-omap2/pm.h
Auto-merging arch/arm/mach-omap2/pm34xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/pm34xx.c
Auto-merging arch/arm/mach-omap2/sleep34xx.S
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/sleep34xx.S
Removing arch/arm/mach-omap2/timer-gp.c
Removing arch/arm/mach-omap2/timer-gp.h
Auto-merging arch/arm/mach-pxa/include/mach/pm.h
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/include/mach/pm.h
Auto-merging arch/arm/mach-pxa/pxa3xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/pxa3xx.c
Auto-merging arch/arm/mach-s3c2412/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c2412/pm.c
Auto-merging arch/arm/mach-s3c2416/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c2416/pm.c
Auto-merging arch/arm/mach-s3c64xx/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/pm.c
Auto-merging arch/arm/mach-sa1100/pm.c
CONFLICT (content): Merge conflict in arch/arm/mach-sa1100/pm.c
Removing arch/arm/plat-mxc/include/mach/iomux.h
Auto-merging arch/arm/plat-samsung/include/plat/pm.h
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/include/plat/pm.h
Auto-merging arch/arm/plat-samsung/pm.c
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/pm.c
Auto-merging drivers/gpio/gpio-mxc.c
Auto-merging drivers/gpio/gpio-mxs.c
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your merge.renamelimit variable to at least 3185 and retry the command.
Automatic merge failed; fix conflicts and then commit the result.

