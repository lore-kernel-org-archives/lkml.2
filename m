Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2LSUsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:48:30 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:59542 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2LSUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:48:21 -0500
X-Greylist: delayed 1483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 15:48:21 EST
Message-ID: <50D22244.6070005@zankel.net>
Date: Wed, 19 Dec 2012 21:23:32 +0100
From: czankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] xtensa patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Would be great if you could pull the Xtensa tree. It contains support of 
device trees, many fixes, and code clean-ups.

Thanks,
-Chris


The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

   Merge branch 'i2c-embedded/for-next' of 
git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


   https://github.com/czankel/xtensa-linux.git tags/xtensa-20121218

for you to fetch changes up to 055d4db1e1ef6f983c3565110fbe6737087e9103:

   xtensa: don't try to build DTB when OF is disabled (2012-12-18 
21:10:26 -0800)

----------------------------------------------------------------
Xtensa patchset for v3.8-rc0

----------------------------------------------------------------
Chris Zankel (4):
       xtensa: add config option to disable linker relaxation
       xtensa: provide proper assembler function boundaries with ENDPROC()
       xtensa: clean up files to make them code-style compliant
       xtensa: set the correct ethernet address for xtfpga

Max Filippov (26):
       xtensa: make DoubleExceptionVector literals fit the gap
       xtensa: ISS: add BASE_BAUD definition to serial.h
       xtensa: provide DMA_ERROR_CODE definition
       xtensa: fix build warning for arch/xtensa/mm/tlb.c
       xtensa: properly fix missing compiler barrier in simcall
       xtensa: fix CPU cache flags formatting
       xtensa: display s32c1i feature flag in cpuinfo
       xtensa: save and restore scompare1 SR on kernel entry
       xtensa: initialize atomctl SR
       xtensa: add trap_set_handler function
       xtensa: add s32c1i sanity check
       xtensa: add s32c1i-based atomic ops implementations
       xtensa: add s32c1i-based bitops implementations
       xtensa: add s32c1i-based spinlock implementations
       xtensa: fix mb and wmb definitions
       xtensa: clean up boot make rules
       xtensa: add U-Boot image support (uImage).
       xtensa: add IRQ domains support
       xtensa: add device trees support
       xtensa: add support for the XTFPGA boards
       xtensa: add XTFPGA DTS
       xtensa: reset all timers on initialization
       xtensa: initialize CPENABLE SR when core has one
       xtensa: fix RASID SR initialization
       xtensa: provide endianness macro for sparse
       xtensa: don't try to build DTB when OF is disabled

Nicolas Kaiser (1):
       xtensa: unbalanced parentheses

Wanlong Gao (1):
       xtensa:fix the incompatible pointer type warning in time.c

Wei Yongjun (1):
       Use for_each_compatible_node() macro.

  Documentation/xtensa/atomctl.txt                   |   44 +++
  arch/xtensa/Kconfig                                |   21 ++
  arch/xtensa/Kconfig.debug                          |   22 +-
  arch/xtensa/Makefile                               |   20 +-
  arch/xtensa/boot/Makefile                          |   25 +-
  arch/xtensa/boot/boot-elf/Makefile                 |   26 +-
  arch/xtensa/boot/boot-redboot/Makefile             |   26 +-
  arch/xtensa/boot/boot-uboot/Makefile               |   14 +
  arch/xtensa/boot/dts/lx60.dts                      |   11 +
  arch/xtensa/boot/dts/ml605.dts                     |   11 +
  arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi         |   26 ++
  arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi          |   18 ++
  arch/xtensa/boot/dts/xtfpga.dtsi                   |   56 ++++
  arch/xtensa/include/asm/atomic.h                   |  271 
++++++++++++------
  arch/xtensa/include/asm/barrier.h                  |    6 +-
  arch/xtensa/include/asm/bitops.h                   |  127 ++++++++-
  arch/xtensa/include/asm/bootparam.h                |   20 +-
  arch/xtensa/include/asm/cacheasm.h                 |    1 -
  arch/xtensa/include/asm/cacheflush.h               |    3 +-
  arch/xtensa/include/asm/checksum.h                 |   19 +-
  arch/xtensa/include/asm/cmpxchg.h                  |   74 +++--
  arch/xtensa/include/asm/current.h                  |    2 +-
  arch/xtensa/include/asm/delay.h                    |    7 +-
  arch/xtensa/include/asm/dma-mapping.h              |    6 +-
  arch/xtensa/include/asm/elf.h                      |   10 +-
  arch/xtensa/include/asm/highmem.h                  |    1 -
  arch/xtensa/include/asm/initialize_mmu.h           |   55 ++++
  arch/xtensa/include/asm/mmu_context.h              |    2 +-
  arch/xtensa/include/asm/nommu_context.h            |    2 +-
  arch/xtensa/include/asm/page.h                     |   20 +-
  arch/xtensa/include/asm/pci-bridge.h               |    2 +-
  arch/xtensa/include/asm/pci.h                      |    2 +-
  arch/xtensa/include/asm/pgalloc.h                  |    2 +-
  arch/xtensa/include/asm/pgtable.h                  |    8 +-
  arch/xtensa/include/asm/platform.h                 |    1 -
  arch/xtensa/include/asm/processor.h                |   10 +-
  arch/xtensa/include/asm/prom.h                     |    6 +
  arch/xtensa/include/asm/ptrace.h                   |    4 +-
  arch/xtensa/include/asm/regs.h                     |    5 +-
  arch/xtensa/include/asm/spinlock.h                 |  188 +++++++++++-
  arch/xtensa/include/asm/syscall.h                  |   11 +-
  arch/xtensa/include/asm/traps.h                    |   23 ++
  arch/xtensa/include/asm/uaccess.h                  |   43 +--
  arch/xtensa/kernel/Makefile                        |    8 +-
  arch/xtensa/kernel/align.S                         |    4 +-
  arch/xtensa/kernel/asm-offsets.c                   |    5 +-
  arch/xtensa/kernel/coprocessor.S                   |   25 +-
  arch/xtensa/kernel/entry.S                         |   67 ++++-
  arch/xtensa/kernel/head.S                          |   21 +-
  arch/xtensa/kernel/irq.c                           |  132 ++++++---
  arch/xtensa/kernel/module.c                        |    2 +-
  arch/xtensa/kernel/platform.c                      |    1 -
  arch/xtensa/kernel/process.c                       |    2 +-
  arch/xtensa/kernel/ptrace.c                        |    3 +-
  arch/xtensa/kernel/setup.c                         |  279 
+++++++++++++++---
  arch/xtensa/kernel/signal.c                        |    8 +-
  arch/xtensa/kernel/syscall.c                       |    1 -
  arch/xtensa/kernel/time.c                          |    7 +-
  arch/xtensa/kernel/traps.c                         |   18 +-
  arch/xtensa/kernel/vectors.S                       |   67 +++--
  arch/xtensa/lib/checksum.S                         |   15 +-
  arch/xtensa/lib/memcopy.S                          |    6 +-
  arch/xtensa/lib/pci-auto.c                         |    9 +-
  arch/xtensa/lib/strncpy_user.S                     |    4 +-
  arch/xtensa/lib/strnlen_user.S                     |    1 -
  arch/xtensa/lib/usercopy.S                         |    1 -
  arch/xtensa/mm/cache.c                             |   27 +-
  arch/xtensa/mm/fault.c                             |    1 -
  arch/xtensa/mm/init.c                              |   16 +-
  arch/xtensa/mm/misc.S                              |   51 +++-
  arch/xtensa/mm/mmu.c                               |    2 +-
  arch/xtensa/mm/tlb.c                               |    9 +-
  .../xtensa/platforms/iss/include/platform/serial.h |   15 +
  .../platforms/iss/include/platform/simcall.h       |    7 +-
  arch/xtensa/platforms/xtfpga/Makefile              |    9 +
  .../platforms/xtfpga/include/platform/hardware.h   |   69 +++++
  .../xtensa/platforms/xtfpga/include/platform/lcd.h |   20 ++
  .../platforms/xtfpga/include/platform/serial.h     |   18 ++
  arch/xtensa/platforms/xtfpga/lcd.c                 |   76 +++++
  arch/xtensa/platforms/xtfpga/setup.c               |  301 
++++++++++++++++++++
  arch/xtensa/variants/s6000/gpio.c                  |    4 +-
  81 files changed, 2140 insertions(+), 422 deletions(-)
  create mode 100644 Documentation/xtensa/atomctl.txt
  create mode 100644 arch/xtensa/boot/boot-uboot/Makefile
  create mode 100644 arch/xtensa/boot/dts/lx60.dts
  create mode 100644 arch/xtensa/boot/dts/ml605.dts
  create mode 100644 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
  create mode 100644 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
  create mode 100644 arch/xtensa/boot/dts/xtfpga.dtsi
  create mode 100644 arch/xtensa/include/asm/initialize_mmu.h
  create mode 100644 arch/xtensa/include/asm/prom.h
  create mode 100644 arch/xtensa/include/asm/traps.h
  create mode 100644 arch/xtensa/platforms/xtfpga/Makefile
  create mode 100644 
arch/xtensa/platforms/xtfpga/include/platform/hardware.h
  create mode 100644 arch/xtensa/platforms/xtfpga/include/platform/lcd.h
  create mode 100644 arch/xtensa/platforms/xtfpga/include/platform/serial.h
  create mode 100644 arch/xtensa/platforms/xtfpga/lcd.c
  create mode 100644 arch/xtensa/platforms/xtfpga/setup.c
