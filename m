Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab1CRXns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:43:48 -0400
Received: from void.printf.net ([89.145.121.20]:35292 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672Ab1CRXnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:43:42 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: MMC updates for 2.6.39-rc1
Date: Fri, 18 Mar 2011 19:40:38 -0400
Message-ID: <m3wrjwt2tl.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus 

to receive the MMC merge for 2.6.39-rc1.  There are currently no merge
conflicts, and the patches have been tested in linux-next.  Thanks.

Highlights are:
Core:
 * A new per-device quirks mechanism, based on PCI quirks
 * Export eMMC4.4 enhanced area details to sysfs
 * New mmc_test tests for large sequential I/O performance
Drivers:
 * New mxs-mmc driver supporting Freescale i.MX23/28 SoCs.
 * Support for Ricoh e823 SDHCI controllers.
 * DesignWare MMC: add 8-bit width, DDR mode, clock gating support
 * SuperH controllers: add clock gating support


The following changes since commit cfd80652467717ca7346857d6d8c94503d74f3a3:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Adrian Hunter (3):
      mmc: mmc_test: make performance test area size about 4MiB
      mmc: mmc_test: add tests to measure random I/O operations per second
      mmc: mmc_test: add tests to measure large sequential I/O performance

Chris Ball (4):
      mmc: sdhci-pci: Remove set-but-unused variable.
      mmc: cb710: Return err value in cb710_wait_while_busy()
      mmc: via-sdmmc: Remove set-but-unused variable.
      mmc: dw_mmc: Remove set-but-unused variable.

Chuanxiao Dong (1):
      mmc: export eMMC4.4 enhanced area details to sysfs

Fabio Estevam (1):
      mmc: mmc_mxc: Allow selection only for the correct platforms

Guennadi Liakhovetski (2):
      mmc: sh_mmcif: support aggressive clock gating
      mmc: tmio: fix address in kunmap_atomic() calls

Jaehoon Chung (6):
      mmc: dw_mmc: modify quirks bit-shift control
      mmc: dw_mmc: support 8-bit buswidth
      mmc: dw_mmc: support DDR mode
      mmc: dw_mmc: add quirks for unreliable card detect, and capabilities
      mmc: dw_mmc: fix suspend/resume operation
      mmc: dw_mmc: support mmc power control with regulator

Kyungmin Park (1):
      mmc: sdhci-s3c: Auto CMD12 support

Linus Walleij (12):
      mmc: atmel-mci: map DMA sglist on the DMA engine
      mmc: atmel-mci: conform to DMA-API
      mmc: atmel-mci: use dmaengine helper functions
      mmc: sh_mmcif: map DMA buffers on the DMA engine device
      mmc: sh_mmcif: unmap with the proper sglen
      mmc: sh_mmcif: rename and retype activity variable
      mmc: sh_mmcif: use dmaengine helpers, drop submit check
      mmc: tmio_mmc: map DMA buffers on the DMA engine device
      mmc: tmio_mmc: unmap with the proper sglen
      mmc: tmio_mmc: drop dma_sglen state variable
      mmc: tmio_mmc: use dmaengine helpers, drop submit check
      mmc: msm_sdcc: remove needless cache flush after dma_unmap_sg()

Manoj Iyer (1):
      mmc: sdhci: Add Ricoh e823 PCI ID

Marc-André Hébert (1):
      mmc: Fix the block device read only flag

Mark Brown (1):
      mmc: Ensure prototypes for SD API are visible in sd.c

Pawel Moll (1):
      mmc: mmc_test: Only warn about not waiting for busy if it's supported

Philip Rakity (2):
      mmc: core: comment on why sdio_reset is done at init time
      mmc: check if mmc cards < 2GB do sector addressing

Pierre Tardy (4):
      mmc: put the led blinking code after clock ungating
      mmc: add per device quirk placeholder
      mmc: add MMC_QUIRK_BROKEN_CLK_GATING
      mmc: remove BROKEN_CLK_GATING quirk for wl1271

Sascha Hauer (1):
      mmc: mxcmmc: use dmaengine API

Shawn Guo (1):
      mmc: mxs-mmc: add mmc host driver for i.MX23/28

Simon Horman (1):
      mmc: tmio_mmc: Improve readability of the output of pr_debug_status()

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Ulf Hansson (2):
      mmc: core: export function mmc_do_release_host()
      mmc: core: reset card voltage after power off

Will Newton (3):
      mmc: dw_mmc: Run card detect tasklet during slot initialisation.
      mmc: dw_mmc: Enable low-power mode for the card clock.
      mmc: Improve MMC_TEST config text.

Wolfram Sang (4):
      mmc: sdhci-tegra: free irq on error and remove
      mmc: sdhci-esdhc-imx: add write protect on custom GPIO on mx25/35
      mmc: sdhci-esdhc: broken card detection is not a default quirk
      mmc: sdhci-esdhc-imx: add card detect on custom GPIO for mx25/35

 Documentation/ABI/testing/sysfs-devices-mmc |   21 +
 arch/arm/mach-mxs/include/mach/mmc.h        |   18 +
 arch/arm/plat-mxc/include/mach/esdhc.h      |   12 +-
 drivers/mmc/card/Kconfig                    |    3 +-
 drivers/mmc/card/block.c                    |    1 +
 drivers/mmc/card/mmc_test.c                 |  271 ++++++++-
 drivers/mmc/core/Makefile                   |    3 +-
 drivers/mmc/core/core.c                     |   26 +-
 drivers/mmc/core/core.h                     |    2 +
 drivers/mmc/core/host.c                     |    5 +-
 drivers/mmc/core/mmc.c                      |   86 +++-
 drivers/mmc/core/quirks.c                   |   84 +++
 drivers/mmc/core/sd.c                       |    1 +
 drivers/mmc/core/sdio.c                     |    9 +
 drivers/mmc/host/Kconfig                    |   11 +-
 drivers/mmc/host/Makefile                   |    1 +
 drivers/mmc/host/atmel-mci.c                |   19 +-
 drivers/mmc/host/cb710-mmc.c                |    2 +-
 drivers/mmc/host/dw_mmc.c                   |   83 +++-
 drivers/mmc/host/dw_mmc.h                   |    2 +-
 drivers/mmc/host/msm_sdcc.c                 |    8 -
 drivers/mmc/host/mxcmmc.c                   |  183 ++++---
 drivers/mmc/host/mxs-mmc.c                  |  874 +++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-esdhc-imx.c          |  134 ++++-
 drivers/mmc/host/sdhci-esdhc.h              |    1 -
 drivers/mmc/host/sdhci-of-esdhc.c           |    3 +-
 drivers/mmc/host/sdhci-pci.c                |   12 +-
 drivers/mmc/host/sdhci-s3c.c                |    3 +
 drivers/mmc/host/sdhci-tegra.c              |    6 +-
 drivers/mmc/host/sh_mmcif.c                 |   62 +-
 drivers/mmc/host/tmio_mmc.c                 |   96 ++--
 drivers/mmc/host/via-sdmmc.c                |    3 -
 include/linux/mmc/card.h                    |    6 +
 include/linux/mmc/core.h                    |    1 +
 include/linux/mmc/dw_mmc.h                  |   15 +-
 include/linux/mmc/mmc.h                     |    3 +
 36 files changed, 1811 insertions(+), 259 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-mmc
 create mode 100644 arch/arm/mach-mxs/include/mach/mmc.h
 create mode 100644 drivers/mmc/core/quirks.c
 create mode 100644 drivers/mmc/host/mxs-mmc.c

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
