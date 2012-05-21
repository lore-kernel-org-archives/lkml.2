Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2EUIHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:07:25 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:50194
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749Ab2EUIHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:07:20 -0400
X-SpamScore: 0
X-BigFish: VS0(zz4015Izz1202hzz8275dhz2ei87h2a8h668h839hd24he5bhe96h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] Blackfin changes for 3.5-rc1
Date: Mon, 21 May 2012 16:07:06 +0800
Message-ID: <1337587626-13656-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linus,

Please pull blackfin changes for 3.5-rc1.
The biggest change was added an new processor(bf60x series).

Bf60x series processor of blackfin can up to 1GHz with Hardware Support for HD Video Analytics,
it use the same blackfin ISA but with some changes on system buses, interrupt controller and
peripheral devices. 

Added dir arch/blackfin/mach-bf609/ and did some changes to the framework made
linux working fine on the reference board bf609-ezkit now.

Thanks,
-Bob

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
  Linus Torvalds (1):
        Linux 3.4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

Aaron Wu (1):
      blackfin: bf537-stamp: update board file for platform bfin_sport device

Bob Liu (10):
      blackfin: configs: add SMP support back to BF561-EZKIT-SMP_defconfig
      blackfin: asm: fix blackfin.h broken
      blackfin: add bf60x to current framework
      blackfin: cplb: add support for bf60x
      blackfin: bf60x: add l2 ecc irq handler
      blackfin: bf60x: fix compiling warning
      blackfin: mach-common: ints-priority: fix compile error
      blackfin: mach-bf609: add can_wakeup to ethernet device
      blackfin:mach-bf609: fix norflash for bf609-ezkit
      blackfin: bf60x: make clock changeable in kernel menuconfig

Mike Frysinger (2):
      Blackfin: fix unused clk var warning
      Blackfin: delete fork func

Scott Jiang (1):
      blackfin: add spi/sport3/ppi head file for bf60x

Sonic Zhang (16):
      blackfin: mach-bf609: add machine files
      blackfin: twi: move twi bit mask macro to twi head file
      blackfin: license: Change ADI BSD license
      blackfin: bf60x: bfin_uart: Add more LCR bits masks
      blackfin: GPIO: Implement more GPIO APIs
      blackfin: rotary: Add pm_wakeup flag to platform data structure.
      blackfin: remove redundant CONFIG_BF60x macro
      blackfin: bf60x: pm: Add a debug option to calculate kernel wakeup time.
      blackfin: bf60x: cleanup get clock code
      blackfin: bf60x: Rename the DDR controller macro
      blackfin: bf60x: anomaly: Add a temporary anomaly 0501001
      blackfin: twi: Move TWI peripheral pin request array to platform data
      blackfin: twi: Move TWI MMR access macro to twi head file
      blackfin: bf60x: twi: work around temporary anomaly 0501001
      blackfin: bf60x: add head file for crc controller
      blackfin: twi: include linux/i2c.h

Steven Miao (11):
      blackfin: bf60x: add clock support
      blackfin: mach-common: add sec support for bf60x
      blackfin: bf60x: enable gptimer clock source
      blackfin: bf60x: add power management support
      blackfin: bf60x: cleanup mem_map macro
      blackfin: SMP: pda: "next" field of blackfin_pda only used in SMP kernel
      bfin_dma: fix initcall return error in proc_dma_init()
      bfin_gpio: fix bf548-ezkit kernel fail to boot
      blackfin: bf60x: add wakeup source select
      blackfin: mach-bf609: pm: cleanup bfin_deepsleep
      blackfin: fix build after add bf60x mach/pm.h

 arch/blackfin/ADI_BSD.txt                          |   41 -
 arch/blackfin/Clear_BSD.txt                        |   33 +
 arch/blackfin/Kconfig                              |  184 +-
 arch/blackfin/Kconfig.debug                        |    7 +
 arch/blackfin/Makefile                             |    2 +
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig    |    4 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig        |  155 +
 arch/blackfin/include/asm/bfin-global.h            |    5 +
 arch/blackfin/include/asm/bfin6xx_spi.h            |  258 ++
 arch/blackfin/include/asm/bfin_crc.h               |  139 +
 arch/blackfin/include/asm/bfin_dma.h               |   84 +-
 arch/blackfin/include/asm/bfin_pfmon.h             |    2 +-
 arch/blackfin/include/asm/bfin_ppi.h               |  128 +
 arch/blackfin/include/asm/bfin_rotary.h            |    1 +
 arch/blackfin/include/asm/bfin_serial.h            |  182 +-
 arch/blackfin/include/asm/bfin_sport.h             |    1 +
 arch/blackfin/include/asm/bfin_sport3.h            |  107 +
 arch/blackfin/include/asm/bfin_twi.h               |  142 +
 arch/blackfin/include/asm/blackfin.h               |    8 +-
 arch/blackfin/include/asm/clkdev.h                 |   14 +
 arch/blackfin/include/asm/clocks.h                 |   23 +
 arch/blackfin/include/asm/cplb.h                   |    4 +
 arch/blackfin/include/asm/def_LPBlackfin.h         |    6 +-
 arch/blackfin/include/asm/dma.h                    |  137 +-
 arch/blackfin/include/asm/dpmc.h                   |  656 ++++
 arch/blackfin/include/asm/fixed_code.h             |   30 +-
 arch/blackfin/include/asm/gpio.h                   |   44 +
 arch/blackfin/include/asm/gptimers.h               |  104 +
 arch/blackfin/include/asm/irqflags.h               |    6 +-
 arch/blackfin/include/asm/page.h                   |    5 +-
 arch/blackfin/include/asm/pda.h                    |    2 +
 arch/blackfin/include/asm/pm.h                     |   31 +
 arch/blackfin/include/asm/unistd.h                 |    2 +-
 arch/blackfin/kernel/bfin_dma.c                    |  146 +-
 arch/blackfin/kernel/bfin_gpio.c                   |   28 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |    4 +-
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c          |    6 +
 arch/blackfin/kernel/debug-mmrs.c                  |    9 +-
 arch/blackfin/kernel/entry.S                       |   10 -
 arch/blackfin/kernel/gptimers.c                    |   85 +-
 arch/blackfin/kernel/process.c                     |    8 +-
 arch/blackfin/kernel/reboot.c                      |    6 +-
 arch/blackfin/kernel/setup.c                       |  132 +-
 arch/blackfin/kernel/shadow_console.c              |    6 +-
 arch/blackfin/kernel/time-ts.c                     |   27 +-
 arch/blackfin/lib/divsi3.S                         |    2 +-
 arch/blackfin/lib/memchr.S                         |    2 +-
 arch/blackfin/lib/memcmp.S                         |    2 +-
 arch/blackfin/lib/memcpy.S                         |    2 +-
 arch/blackfin/lib/memmove.S                        |    2 +-
 arch/blackfin/lib/memset.S                         |    2 +-
 arch/blackfin/lib/modsi3.S                         |    2 +-
 arch/blackfin/lib/muldi3.S                         |    2 +-
 arch/blackfin/lib/smulsi3_highpart.S               |    2 +-
 arch/blackfin/lib/strcmp.S                         |    2 +-
 arch/blackfin/lib/strcpy.S                         |    2 +-
 arch/blackfin/lib/strncmp.S                        |    2 +-
 arch/blackfin/lib/strncpy.S                        |    2 +-
 arch/blackfin/lib/udivsi3.S                        |    2 +-
 arch/blackfin/lib/umodsi3.S                        |    2 +-
 arch/blackfin/lib/umulsi3_highpart.S               |    2 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c            |    5 +
 arch/blackfin/mach-bf518/boards/tcm-bf518.c        |    5 +
 arch/blackfin/mach-bf518/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF512.h  |    2 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF514.h  |    2 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF516.h  |    2 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF518.h  |    2 +-
 arch/blackfin/mach-bf518/include/mach/defBF512.h   |   73 +-
 arch/blackfin/mach-bf518/include/mach/defBF514.h   |    2 +-
 arch/blackfin/mach-bf518/include/mach/defBF516.h   |    2 +-
 arch/blackfin/mach-bf518/include/mach/defBF518.h   |    2 +-
 arch/blackfin/mach-bf527/boards/ad7160eval.c       |    6 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    5 +
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    5 +
 arch/blackfin/mach-bf527/boards/ezkit.c            |    6 +
 arch/blackfin/mach-bf527/boards/tll6527m.c         |    5 +
 arch/blackfin/mach-bf527/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf527/include/mach/defBF522.h   |   73 +-
 arch/blackfin/mach-bf527/include/mach/defBF525.h   |    2 +-
 arch/blackfin/mach-bf527/include/mach/defBF527.h   |    2 +-
 arch/blackfin/mach-bf533/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |    5 +
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |    5 +
 arch/blackfin/mach-bf537/boards/dnp5370.c          |    5 +
 arch/blackfin/mach-bf537/boards/minotaur.c         |    5 +
 arch/blackfin/mach-bf537/boards/stamp.c            |   66 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |    5 +
 arch/blackfin/mach-bf537/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   71 +-
 arch/blackfin/mach-bf537/include/mach/defBF537.h   |    2 +-
 arch/blackfin/mach-bf538/boards/ezkit.c            |    8 +-
 arch/blackfin/mach-bf538/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf538/include/mach/defBF538.h   |   78 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |    2 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |   10 +
 arch/blackfin/mach-bf548/boards/ezkit.c            |   11 +
 arch/blackfin/mach-bf548/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf548/include/mach/defBF542.h   |    2 +-
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    2 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |    2 +-
 arch/blackfin/mach-bf548/include/mach/defBF548.h   |    2 +-
 arch/blackfin/mach-bf548/include/mach/defBF549.h   |    2 +-
 .../mach-bf548/include/mach/defBF54x_base.h        |  111 +-
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |    3 +-
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |    2 +-
 arch/blackfin/mach-bf609/Kconfig                   |   56 +
 arch/blackfin/mach-bf609/Makefile                  |    6 +
 arch/blackfin/mach-bf609/boards/Kconfig            |   12 +
 arch/blackfin/mach-bf609/boards/Makefile           |    5 +
 arch/blackfin/mach-bf609/boards/ezkit.c            | 1340 ++++++++
 arch/blackfin/mach-bf609/clock.c                   |  390 +++
 arch/blackfin/mach-bf609/dma.c                     |  202 ++
 arch/blackfin/mach-bf609/hibernate.S               |   65 +
 arch/blackfin/mach-bf609/include/mach/anomaly.h    |  130 +
 arch/blackfin/mach-bf609/include/mach/bf609.h      |   93 +
 .../blackfin/mach-bf609/include/mach/bfin_serial.h |   17 +
 arch/blackfin/mach-bf609/include/mach/blackfin.h   |   25 +
 arch/blackfin/mach-bf609/include/mach/cdefBF609.h  |   15 +
 .../mach-bf609/include/mach/cdefBF60x_base.h       | 3252 ++++++++++++++++++
 arch/blackfin/mach-bf609/include/mach/defBF609.h   |   15 +
 .../mach-bf609/include/mach/defBF60x_base.h        | 3587 ++++++++++++++++++++
 arch/blackfin/mach-bf609/include/mach/dma.h        |  116 +
 arch/blackfin/mach-bf609/include/mach/gpio.h       |  171 +
 arch/blackfin/mach-bf609/include/mach/irq.h        |  318 ++
 arch/blackfin/mach-bf609/include/mach/mem_map.h    |   86 +
 arch/blackfin/mach-bf609/include/mach/pll.h        |    1 +
 arch/blackfin/mach-bf609/include/mach/pm.h         |   21 +
 arch/blackfin/mach-bf609/include/mach/portmux.h    |  347 ++
 arch/blackfin/mach-bf609/pm.c                      |  362 ++
 arch/blackfin/mach-common/Makefile                 |    5 +-
 arch/blackfin/mach-common/clock.h                  |   27 +
 arch/blackfin/mach-common/clocks-init.c            |  153 +-
 arch/blackfin/mach-common/cpufreq.c                |   46 +-
 arch/blackfin/mach-common/dpmc_modes.S             |  606 +----
 arch/blackfin/mach-common/entry.S                  |    5 +-
 arch/blackfin/mach-common/head.S                   |    2 -
 arch/blackfin/mach-common/ints-priority.c          |  423 +++-
 arch/blackfin/mach-common/pm.c                     |   62 +-
 arch/blackfin/mm/init.c                            |   14 +-
 arch/blackfin/mm/sram-alloc.c                      |   36 +
 142 files changed, 14357 insertions(+), 1320 deletions(-)
 delete mode 100644 arch/blackfin/ADI_BSD.txt
 create mode 100644 arch/blackfin/Clear_BSD.txt
 create mode 100644 arch/blackfin/configs/BF609-EZKIT_defconfig
 create mode 100644 arch/blackfin/include/asm/bfin6xx_spi.h
 create mode 100644 arch/blackfin/include/asm/bfin_crc.h
 create mode 100644 arch/blackfin/include/asm/bfin_sport3.h
 create mode 100644 arch/blackfin/include/asm/clkdev.h
 create mode 100644 arch/blackfin/include/asm/pm.h
 create mode 100644 arch/blackfin/mach-bf609/Kconfig
 create mode 100644 arch/blackfin/mach-bf609/Makefile
 create mode 100644 arch/blackfin/mach-bf609/boards/Kconfig
 create mode 100644 arch/blackfin/mach-bf609/boards/Makefile
 create mode 100644 arch/blackfin/mach-bf609/boards/ezkit.c
 create mode 100644 arch/blackfin/mach-bf609/clock.c
 create mode 100644 arch/blackfin/mach-bf609/dma.c
 create mode 100644 arch/blackfin/mach-bf609/hibernate.S
 create mode 100644 arch/blackfin/mach-bf609/include/mach/anomaly.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/bf609.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/bfin_serial.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/blackfin.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/cdefBF609.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/cdefBF60x_base.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/defBF609.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/defBF60x_base.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/dma.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/gpio.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/irq.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/mem_map.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/pm.h
 create mode 100644 arch/blackfin/mach-bf609/include/mach/portmux.h
 create mode 100644 arch/blackfin/mach-bf609/pm.c
 create mode 100644 arch/blackfin/mach-common/clock.h

