Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0JYRIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:08:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38255 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab0JYRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:08:22 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: [GIT PULL] davinci updates for 2.6.37
Organization: Deep Root Systems, LLC
Date: Mon, 25 Oct 2010 18:08:15 +0100
Message-ID: <87sjzukxog.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull davinci platform updates for 2.6.37:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

Note that I also merged Russell King's devel branch (which you already
merged) in order to fixup some final conflicts.  diffstat/shortlog
follows for just the davinci specific parts.

Thanks,

Kevin



 MAINTAINERS                                     |    4 +-
 arch/arm/configs/da8xx_omapl_defconfig          |    3 +
 arch/arm/mach-davinci/Kconfig                   |   76 +-
 arch/arm/mach-davinci/Makefile                  |    4 +-
 arch/arm/mach-davinci/aemif.c                   |  133 +++
 arch/arm/mach-davinci/board-da830-evm.c         |   24 +-
 arch/arm/mach-davinci/board-da850-evm.c         |   92 ++-
 arch/arm/mach-davinci/board-dm365-evm.c         |   11 +-
 arch/arm/mach-davinci/board-dm644x-evm.c        |   20 +-
 arch/arm/mach-davinci/board-dm646x-evm.c        |   21 +-
 arch/arm/mach-davinci/board-mityomapl138.c      |  424 +++++++
 arch/arm/mach-davinci/board-neuros-osd2.c       |    7 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c     |   64 ++
 arch/arm/mach-davinci/board-sffsdr.c            |    7 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c     |   56 +
 arch/arm/mach-davinci/clock.c                   |   75 ++-
 arch/arm/mach-davinci/clock.h                   |    5 +
 arch/arm/mach-davinci/cpufreq.c                 |   28 +-
 arch/arm/mach-davinci/da850.c                   |   76 +-
 arch/arm/mach-davinci/devices-da8xx.c           |   70 ++-
 arch/arm/mach-davinci/devices-tnetv107x.c       |   50 +
 arch/arm/mach-davinci/devices.c                 |    2 +-
 arch/arm/mach-davinci/dm365.c                   |   23 +-
 arch/arm/mach-davinci/dm644x.c                  |   23 +-
 arch/arm/mach-davinci/dm646x.c                  |   22 +-
 arch/arm/mach-davinci/dma.c                     |    8 +-
 arch/arm/mach-davinci/include/mach/aemif.h      |   36 +
 arch/arm/mach-davinci/include/mach/da8xx.h      |    7 +-
 arch/arm/mach-davinci/include/mach/dm365.h      |    2 +-
 arch/arm/mach-davinci/include/mach/dm644x.h     |    2 +-
 arch/arm/mach-davinci/include/mach/dm646x.h     |    2 +-
 arch/arm/mach-davinci/include/mach/nand.h       |    6 +-
 arch/arm/mach-davinci/include/mach/psc.h        |    1 +
 arch/arm/mach-davinci/include/mach/tnetv107x.h  |    3 +
 arch/arm/mach-davinci/include/mach/uncompress.h |    2 +
 arch/arm/mach-davinci/tnetv107x.c               |   11 +-
 arch/arm/mach-omap2/board-am3517evm.c           |   31 +-
 drivers/input/keyboard/Kconfig                  |    9 +
 drivers/input/keyboard/Makefile                 |    1 +
 drivers/input/keyboard/tnetv107x-keypad.c       |  340 ++++++
 drivers/input/touchscreen/Kconfig               |    9 +
 drivers/input/touchscreen/Makefile              |    1 +
 drivers/input/touchscreen/tnetv107x-ts.c        |  396 +++++++
 drivers/mtd/nand/davinci_nand.c                 |   61 +-
 drivers/net/Kconfig                             |   21 +
 drivers/net/Makefile                            |    2 +
 drivers/net/davinci_cpdma.c                     |  965 ++++++++++++++++
 drivers/net/davinci_cpdma.h                     |  108 ++
 drivers/net/davinci_emac.c                      | 1338 +++--------------------
 drivers/net/davinci_mdio.c                      |  475 ++++++++
 include/linux/davinci_emac.h                    |   16 +-
 51 files changed, 3814 insertions(+), 1359 deletions(-)

Cyril Chemparathy (17):
      Davinci: tnetv107x: retain psc reg base after init
      davinci: add idcode for tnetv107x rev 1.1/1.2
      net: davinci_emac: separate out davinci mdio
      davinci: add mdio platform devices
      omap: add mdio platform devices
      net: davinci_emac: switch to new mdio
      davinci: cleanup mdio arch code and switch to phy_id
      omap: cleanup unused davinci mdio arch code
      net: davinci_emac: cleanup unused mdio emac code
      net: davinci_emac: separate out cpdma code
      net: davinci_emac: switch to new cpdma layer
      net: davinci_emac: cleanup unused cpdma code
      input: add driver for tnetv107x on-chip keypad controller
      davinci: add tnetv107x keypad platform device
      davinci: add keypad config for tnetv107x evm board
      input: add driver for tnetv107x touchscreen controller
      davinci: add tnetv107x touchscreen platform device

Juha Kuikka (3):
      DA850: Add LPSC id for MMCSD1 peripheral
      DA850: Split MMCSD clock into two to support both MMCSD peripherals
      DA850: Add MMCSD1 resources, platform device and convenience registration function

Kevin Hilman (1):
      davinci: clock: make 'disable unused clocks' printk debug only

Kulikov Vasiliy (1):
      arm: mach-davinci: check irq2ctlr() result

Michael Williamson (5):
      davinci: Add machine checks to DA8XX serial console init routines
      davinci: Add CONFIG_REGULATOR_DUMMY to DA8XX defconfig file.
      davinci: Initial support for MityDSP-L138/MityARM-1808
      davinci: Add I2C0 devices to MityDSP-L138/MityARM-1808 platform
      davinci: MityDSP-L138/MityARM-1808 read MAC address from I2C Prom

Nicolas Kaiser (1):
      arm/davinci: remove duplicated include

Sekhar Nori (17):
      davinci: da850 evm: sparse cleanup: make file local variables static
      MAINTAINERS: Add Kevin's e-mail in entry for TI DaVinci
      davinci: cpufreq: bailout on regulator errors
      davinci: clean up inconsistent usage of spaces in Kconfig
      davinci: introduce support for AM1x ARM9 microprocessors
      davinci: am18x/da850/omap-l138: use 'NOM' voltage defined in datasheet as min voltage
      davinci: dm365: disable pulldowns for all MMC/SD1 pins.
      davinci: clock: add support for setting sysclk rate
      davinci: cpufreq: add support for keeping an additional clock constant
      davinci: am18x/da850/omap-l138: keep async clock constant with cpufreq
      davinci: dm365 evm: use EDMAQ_3 as the audio DMA queue
      davinci: add support for aemif timing configuration
      nand: davinci: add support for timing configuration
      davinci: dm644x evm: setup NAND flash timing
      davinci: am18x/da850/omap-l138 evm: setup NAND flash timing
      davinci: dm6467t evm: setup NAND flash timing
      davinci: mityomapl138: make file local data static

Sergei Shtylyov (2):
      DA850: move NAND/NOR pin lists to the board file
      DA850: move MII/RMII pin lists to the board file

Sudhakar Rajashekhara (1):
      davinci: am17x/da830/omap-l137 evm: setup NAND flash timing

Victor Rodriguez (1):
      davinci: Initial support for Omapl138-Hawkboard



