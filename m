Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2DFTft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:35:49 -0400
Received: from void.printf.net ([89.145.121.20]:47891 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab2DFTfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:35:48 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.4-rc2
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Fri, 06 Apr 2012 15:35:34 -0400
Message-ID: <87mx6o3b7d.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive MMC fixes for 3.4-rc2.  I've signed an "mmc-fixes-for-3.4-rc2"
tag.  There are no merge conflicts, and the patches have been tested in
linux-next.  Thanks.

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to 3bdc9ba892d6a294d16e9e6e0c4041926aa3d58c:

  mmc: use really long write timeout to deal with crappy cards (2012-04-05 20:32:34 -0400)

----------------------------------------------------------------
MMC fixes for 3.4-rc2:
 The major fixes here are:
  * Disable use of MSI in sdhci-pci, which caused multiple chipsets to
    stop working in 3.4-rc1.  I'll wait to turn this on again until we
    have a chipset whitelist for it.
  * Fix a libertas SDIO powered-resume regression introduced in 3.3;
    thanks to Neil Brown and Rafael Wysocki for this fix.
  * Fix module reloading on omap_hsmmc.
  * Stop trusting the spec/card's specified maximum data timeout length,
    and use three seconds instead.  Previously we used 300ms.

 Also cleanups and fixes for s3c, atmel, sh_mmcif and omap_hsmmc.

----------------------------------------------------------------
Al Cooper (1):
      mmc: Prevent 1.8V switch for SD hosts that don't support UHS modes.

Alf Høgemark (1):
      mmc: sdhci-dove: Fix compile error by including module.h

Balaji T K (3):
      mmc: omap_hsmmc: use runtime put sync in probe error patch
      mmc: omap_hsmmc: context save after enabling runtime pm
      mmc: omap_hsmmc: fix module re-insertion

Chris Ball (2):
      Revert "mmc: sdhci-pci: add quirks for broken MSI on O2Micro controllers"
      Revert "mmc: sdhci-pci: Add MSI support"

Felipe Balbi (3):
      mmc: omap_hsmmc: trivial cleanups
      mmc: omap_hsmmc: make it behave well as a module
      mmc: omap_hsmmc: convert to module_platform_driver

Julia Lawall (1):
      mmc: sdhci-s3c: use devm_ functions

Ludovic Desroches (3):
      mmc: atmel-mci: correct data timeout computation
      mmc: atmel-mci: r/w proof capability only available since v2xx
      mmc: atmel-mci: add support for odd clock dividers

Manuel Lauss (1):
      mmc: sdhci-pci: add quirks for broken MSI on O2Micro controllers

Mark Brown (2):
      mmc: sdhci-s3c: Use CONFIG_PM_SLEEP to ifdef system suspend
      mmc: sdhci-s3c: Enable runtime power management

Paul Walmsley (1):
      mmc: use really long write timeout to deal with crappy cards

Rafael J. Wysocki (1):
      mmc: sdio: Use empty system suspend/resume callbacks at the bus level

Simon Horman (3):
      mmc: sh_mmcif: double clock speed
      mmc: sh_mmcif: mmc->f_max should be half of the bus clock
      mmc: sh_mmcif: Simplify calculation of mmc->f_min

Subhash Jadavani (2):
      mmc: bus: print bus speed mode of UHS-I card
      mmc: core: fix power class selection

Thomas Abraham (3):
      mmc: sdhci-s3c: Remove usage of clk_type member in platform data
      mmc: sdhci-s3c: derive transfer width host cap from max_width in platdata
      mmc: sdhci-s3c: Keep a copy of platform data and use it

Ulf Hansson (1):
      mmc: block: Remove use of mmc_blk_set_blksize

 drivers/mmc/card/block.c          |   27 +------
 drivers/mmc/core/bus.c            |   17 +++-
 drivers/mmc/core/core.c           |   10 ++-
 drivers/mmc/core/mmc.c            |   30 ++++---
 drivers/mmc/core/sdio_bus.c       |   12 ++-
 drivers/mmc/host/atmel-mci-regs.h |    1 +
 drivers/mmc/host/atmel-mci.c      |   55 ++++++++----
 drivers/mmc/host/omap_hsmmc.c     |  181 ++++++++++++++++---------------------
 drivers/mmc/host/sdhci-dove.c     |    1 +
 drivers/mmc/host/sdhci-pci.c      |    6 --
 drivers/mmc/host/sdhci-s3c.c      |  159 +++++++++++++++++++++++++-------
 drivers/mmc/host/sdhci.c          |    5 +-
 drivers/mmc/host/sh_mmcif.c       |   13 +--
 13 files changed, 299 insertions(+), 218 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
