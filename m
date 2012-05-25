Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2EYDMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 23:12:18 -0400
Received: from void.printf.net ([89.145.121.20]:53391 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab2EYDMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 23:12:16 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.5-rc1
Date: Thu, 24 May 2012 23:12:01 -0400
Message-ID: <87bold6jjy.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.5-rc1

to receive the MMC merge for 3.5.  The patches have been tested in
linux-next, and there's currently one trivial merge conflict in
Documentation/feature-removal-schedule.txt.  Thanks.


The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.5-rc1

for you to fetch changes up to 0caaa9539adcff38ce12e99f0ab25645e7eb3eea:

  mmc: at91-mci: this driver is now deprecated (2012-05-17 14:33:48 -0400)

----------------------------------------------------------------
MMC highlights for 3.5:

Drivers:
 - at91-mci: This driver will be replaced by atmel-mci in 3.7.
 - atmel-mci: Add support for old at91-mci hardware.
 - dw_mmc: Allow multiple controllers; this previously caused corruption.
 - imxmmc: Remove this driver, replaced by mxcmmc.
 - mmci: Add device tree support.
 - omap: Allow multiple controllers.
 - omap_hsmmc: Auto CMD12, DDR support.
 - tegra: Support SD 3.0 spec.

----------------------------------------------------------------
Balaji T K (2):
      mmc: omap_hsmmc: Enable Auto CMD12
      mmc: omap_hsmmc: add DDR support

Chuanxiao Dong (1):
      mmc: core: check PM_SLEEP for mmc_bus_suspend/resume callbacks

Guennadi Liakhovetski (1):
      mmc: cd-gpio: protect against NULL context in mmc_cd_gpio_free()

Jan Luebbe (1):
      mmc: davinci_mmc: set MODULE_ALIAS to allow autoloading

Kyoungil Kim (1):
      mmc: dw_mmc: Fixed sdio interrupt mask bit setting bug

Lee Jones (4):
      mmc: mmci: Enable Device Tree support for ux500 variants
      mmc: mmci: Add required documentation for Device Tree bindings
      mmc: mmci: Use correct GPIO binding for IRQ requests
      mmc: mmci: Fix compiler error when CONFIG_OF is not set

Ludovic Desroches (5):
      mmc: atmel-mci: the r/w proof capability lack was not well managed
      mmc: atmel-mci: change the state machine for compatibility with old IP
      mmc: atmel-mci: add support for version lower than v2xx
      mmc: atmel-mci: add debug logs
      mmc: at91-mci: this driver is now deprecated

Mark Brown (1):
      mmc: sdhci: Log what timeout was set if the timeout is too large

Ming Lei (1):
      mmc: omap_hsmmc: pass IRQF_ONESHOT to request_threaded_irq

Nicolas Pitre (1):
      mmc: sdio: avoid spurious calls to interrupt handlers

Pavan Kunapuli (1):
      mmc: tegra: support SDHCI SPEC 300

Philippe De Swert (2):
      mmc: card: Avoid null pointer dereference
      mmc: core: Remove dead code

Rajendra Nayak (1):
      mmc: omap_hsmmc: Cleanup use of cpu_is_* for debounce_clock

Russell King (1):
      mmc: omap_hsmmc: release correct resource

Sascha Hauer (1):
      mmc: remove imxmmc driver

Saugata Das (1):
      mmc: block: Allow disabling 512B sector size emulation

Seungwon Jeon (2):
      mmc: core: fix the decision of HS200/DDR card-type
      mmc: core: fix the signaling 1.8V for HS200

Subhash Jadavani (1):
      mmc: core: skip card initialization if power class selection fails

Thomas Abraham (1):
      mmc: dw_mmc: make multiple instances of dw_mci_card_workqueue

Ulf Hansson (1):
      mmc: core: Prevent eMMC VCC supply to be cut from late init

Venkatraman S (6):
      mmc: omap_hsmmc: use spinlock IRQ safe variant
      mmc: queue: rename mmc_request function
      mmc: queue: remove redundant memsets
      mmc: omap: convert to per instance workqueue
      mmc: omap: make it behave well as a module
      mmc: omap: convert to module_platform_driver

Viresh Kumar (2):
      mmc: sdhci-spear: No need to check 'pdev == NULL' in probe
      mmc: sdhci-spear: Use devm_* derivatives

 Documentation/devicetree/bindings/mmc/mmci.txt |   19 +
 Documentation/feature-removal-schedule.txt     |   11 +
 drivers/mmc/card/block.c                       |   22 +-
 drivers/mmc/card/queue.c                       |    6 +-
 drivers/mmc/core/bus.c                         |    2 +
 drivers/mmc/core/cd-gpio.c                     |    3 +
 drivers/mmc/core/core.c                        |   18 +-
 drivers/mmc/core/mmc.c                         |  119 +--
 drivers/mmc/core/sdio.c                        |    2 +-
 drivers/mmc/core/sdio_irq.c                    |   11 +-
 drivers/mmc/host/Kconfig                       |   17 +-
 drivers/mmc/host/Makefile                      |    1 -
 drivers/mmc/host/atmel-mci.c                   |  469 +++++++---
 drivers/mmc/host/davinci_mmc.c                 |    1 +
 drivers/mmc/host/dw_mmc.c                      |   18 +-
 drivers/mmc/host/imxmmc.c                      | 1169 ------------------------
 drivers/mmc/host/imxmmc.h                      |   64 --
 drivers/mmc/host/mmci.c                        |   65 +-
 drivers/mmc/host/omap.c                        |   48 +-
 drivers/mmc/host/omap_hsmmc.c                  |   84 +-
 drivers/mmc/host/sdhci-spear.c                 |   82 +-
 drivers/mmc/host/sdhci-tegra.c                 |   26 +
 drivers/mmc/host/sdhci.c                       |    4 +-
 include/linux/mmc/card.h                       |    4 +
 include/linux/mmc/dw_mmc.h                     |    1 +
 include/linux/mmc/host.h                       |    2 +
 include/linux/mmc/mmc.h                        |   60 --
 27 files changed, 667 insertions(+), 1661 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/mmci.txt
 delete mode 100644 drivers/mmc/host/imxmmc.c
 delete mode 100644 drivers/mmc/host/imxmmc.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
