Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935392Ab0HFU5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:57:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38493 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab0HFU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:57:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Fri,  6 Aug 2010 16:57:46 -0400
Message-Id: <1281128266-6335-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1281112206-31808-1-git-send-email-vapier@gentoo.org>
References: <1281112206-31808-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fc1caf6eafb30ea185720e29f7f5eccca61ecd60:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-08-05 16:02:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Christian Dietrich (1):
      Blackfin: remove CONFIG_MEM_GENERIC_BOARD

Michael Hennerich (7):
      Blackfin: fix DMA/cache bug when resuming from suspend to RAM
      Blackfin: make sure mmiowb inserts a write barrier with SSYNC
      Blackfin: BF51x/BF52x: support GPIO Hysteresis/Schmitt Trigger options
      Blackfin: remove useless and outdated documentation
      Blackfin: document SPI CS limitations with CPHA=0
      Blackfin: portmux: fix peripheral map overflow when requesting pins
      Blackfin: dpmc: punt unnecessary RTC_ISTAT clearing

Mike Frysinger (24):
      Blackfin: punt NFC MMR bits
      Blackfin: new dynamic bfin read/write mmr helpers
      Blackfin: stub fpregs dumping
      Blackfin: use common EXCEPTION_TABLE() in vmlinux.lds
      Blackfin: move MPU anomaly check to common location
      Blackfin: merge anomalies 475 and 220 to follow official lists
      Blackfin: update anomaly lists to latest public info
      Blackfin: allow cache funcs to be in L1 for IFLUSH Anomaly 05000491
      Blackfin: gpio: unify & clean up reserved map handling
      Blackfin: BF54x: add ifdef protection to gpio header
      Blackfin: BF51x: fix typo in HWAIT pin define
      Blackfin: fix typo in hweight asm
      Blackfin: add a GPIO_DEFAULT_BOOT_SPI_CS
      Blackfin: BF51x: fix handling of PH8 (the "internal" SPI0SEL4 pin)
      Blackfin: gpio/portmux: clean up whitespace corruption
      Blackfin: add support for LZO compressed kernels
      Blackfin: add support for dynamic ftrace
      Blackfin: add EVT_OVERRIDE/IPRIO core MMR helpers
      Blackfin: TWI: clean up the MMR names
      Blackfin: BF54x: tweak DMAC MMR naming to match other ports
      Blackfin: unify SDH/RSI bitmasks
      Blackfin: unify rotary encoder bitmasks
      Blackfin: update defconfigs
      Blackfin: gpio: add a debounce stub

 Documentation/blackfin/00-INDEX                    |   11 +-
 Documentation/blackfin/Filesystems                 |  169 ---------------
 Documentation/blackfin/bfin-spi-notes.txt          |   14 ++
 Documentation/blackfin/cachefeatures.txt           |   55 -----
 arch/blackfin/Kconfig                              |   20 ++-
 arch/blackfin/Makefile                             |    3 +-
 arch/blackfin/boot/Makefile                        |   11 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig       |  163 +++++++++------
 arch/blackfin/configs/BF526-EZBRD_defconfig        |  129 +++++++++---
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     |  149 ++++++++++----
 arch/blackfin/configs/BF527-EZKIT_defconfig        |  139 +++++++++---
 arch/blackfin/configs/BF533-EZKIT_defconfig        |   93 +++++++--
 arch/blackfin/configs/BF533-STAMP_defconfig        |  131 ++++++++----
 arch/blackfin/configs/BF537-STAMP_defconfig        |  141 +++++++++----
 arch/blackfin/configs/BF538-EZKIT_defconfig        |  121 ++++++++---
 arch/blackfin/configs/BF548-EZKIT_defconfig        |  156 ++++++++++----
 arch/blackfin/configs/BF561-ACVILON_defconfig      |    1 -
 arch/blackfin/configs/BF561-EZKIT_defconfig        |   85 +++++++-
 arch/blackfin/configs/CM-BF527_defconfig           |    1 -
 arch/blackfin/configs/CM-BF533_defconfig           |    1 -
 arch/blackfin/configs/CM-BF537E_defconfig          |    1 -
 arch/blackfin/configs/CM-BF537U_defconfig          |    1 -
 arch/blackfin/configs/CM-BF548_defconfig           |    1 -
 arch/blackfin/configs/CM-BF561_defconfig           |    1 -
 arch/blackfin/configs/PNAV-10_defconfig            |  123 ++++++++---
 arch/blackfin/configs/TCM-BF518_defconfig          |    1 -
 arch/blackfin/configs/TCM-BF537_defconfig          |    1 -
 arch/blackfin/include/asm/bfin_rotary.h            |   74 +++++++-
 arch/blackfin/include/asm/bfin_sdh.h               |  119 ++++++++++-
 arch/blackfin/include/asm/bitops.h                 |    2 +-
 arch/blackfin/include/asm/cdef_LPBlackfin.h        |    8 +-
 arch/blackfin/include/asm/def_LPBlackfin.h         |   18 ++
 arch/blackfin/include/asm/dma.h                    |    1 +
 arch/blackfin/include/asm/elf.h                    |    1 +
 arch/blackfin/include/asm/ftrace.h                 |   16 ++
 arch/blackfin/include/asm/gpio.h                   |  111 +++++-----
 arch/blackfin/include/asm/io.h                     |    8 +-
 arch/blackfin/include/asm/mem_init.h               |   18 --
 arch/blackfin/include/asm/portmux.h                |   10 +-
 arch/blackfin/kernel/Makefile                      |    1 +
 arch/blackfin/kernel/bfin_dma_5xx.c                |   19 ++-
 arch/blackfin/kernel/bfin_gpio.c                   |  111 +++++-----
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |    4 -
 arch/blackfin/kernel/ftrace-entry.S                |   85 +++++++-
 arch/blackfin/kernel/ftrace.c                      |   86 ++++++++-
 arch/blackfin/kernel/setup.c                       |    7 +
 arch/blackfin/kernel/vmlinux.lds.S                 |    7 +-
 arch/blackfin/mach-bf518/Kconfig                   |   61 ++++++
 arch/blackfin/mach-bf518/include/mach/anomaly.h    |   21 ++-
 arch/blackfin/mach-bf518/include/mach/bf518.h      |  105 +++++++++
 arch/blackfin/mach-bf518/include/mach/defBF514.h   |  135 ------------
 .../mach-bf518/include/mach/defBF51x_base.h        |  144 ++-----------
 arch/blackfin/mach-bf518/include/mach/gpio.h       |   83 ++++----
 arch/blackfin/mach-bf518/include/mach/portmux.h    |    7 +-
 arch/blackfin/mach-bf527/Kconfig                   |   66 ++++++
 arch/blackfin/mach-bf527/include/mach/anomaly.h    |   22 ++-
 arch/blackfin/mach-bf527/include/mach/bf527.h      |  120 +++++++++++
 .../mach-bf527/include/mach/defBF52x_base.h        |  225 ++------------------
 arch/blackfin/mach-bf527/include/mach/gpio.h       |   96 ++++----
 arch/blackfin/mach-bf527/include/mach/portmux.h    |    3 +-
 arch/blackfin/mach-bf533/include/mach/anomaly.h    |   10 +-
 arch/blackfin/mach-bf533/include/mach/gpio.h       |   32 ++--
 arch/blackfin/mach-bf533/include/mach/portmux.h    |    3 +-
 arch/blackfin/mach-bf537/include/mach/anomaly.h    |   11 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   36 ++--
 arch/blackfin/mach-bf537/include/mach/gpio.h       |   96 ++++----
 arch/blackfin/mach-bf537/include/mach/portmux.h    |    7 +-
 arch/blackfin/mach-bf538/include/mach/anomaly.h    |   16 +-
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  |   64 ------
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |   14 +-
 arch/blackfin/mach-bf538/include/mach/gpio.h       |  108 +++++-----
 arch/blackfin/mach-bf538/include/mach/portmux.h    |    1 +
 arch/blackfin/mach-bf548/include/mach/anomaly.h    |   16 +-
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   16 +-
 arch/blackfin/mach-bf548/include/mach/defBF542.h   |  130 -----------
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    6 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |  136 +------------
 .../mach-bf548/include/mach/defBF54x_base.h        |  152 +-------------
 arch/blackfin/mach-bf548/include/mach/gpio.h       |   10 +
 arch/blackfin/mach-bf548/include/mach/portmux.h    |    3 +-
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |   13 +-
 arch/blackfin/mach-bf561/include/mach/gpio.h       |   96 ++++----
 arch/blackfin/mach-bf561/include/mach/portmux.h    |    3 +-
 arch/blackfin/mach-common/arch_checks.c            |   16 +-
 arch/blackfin/mach-common/cache.S                  |   15 +-
 arch/blackfin/mach-common/dpmc_modes.S             |   24 --
 arch/blackfin/mach-common/pm.c                     |   17 +-
 87 files changed, 2477 insertions(+), 2090 deletions(-)
 delete mode 100644 Documentation/blackfin/Filesystems
 create mode 100644 Documentation/blackfin/bfin-spi-notes.txt
 delete mode 100644 Documentation/blackfin/cachefeatures.txt
