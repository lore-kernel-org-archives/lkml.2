Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2KINob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:44:31 -0500
Received: from void.printf.net ([89.145.121.20]:55191 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab2KINo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:44:26 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.7-rc5
Date: Fri, 09 Nov 2012 08:44:19 -0500
Message-ID: <87fw4ic2mk.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.7-rc5

to receive MMC fixes for 3.7-rc5.  There are no merge conflicts, and the
patches have been tested in linux-next.  Thanks.


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.7-rc5

for you to fetch changes up to 0aa55c2367f082876f92660312214cd20c6a024b:

  mmc: sdhci-s3c: fix the card detection in runtime-pm (2012-11-07 15:40:52 -0500)

----------------------------------------------------------------
MMC fixes for 3.7-rc5:
 - sdhci: fix a NULL dereference at resume-time, seen on OLPC XO-4
 - sdhci: fix against 3.7-rc1 for UHS modes without a vqmmc regulator
 - sdhci-of-esdhc: disable CMD23 on boards where it's broken
 - sdhci-s3c: fix against 3.7-rc1 for card detection with runtime PM
 - dw_mmc, omap_hsmmc: fix potential NULL derefs, compiler warnings

----------------------------------------------------------------
Adrian Hunter (1):
      mmc: sdhci-pci: fix 'Invalid iomem size' error message condition

Arnd Bergmann (2):
      mmc: dw_mmc: fix modular build for exynos back-end
      mmc: dw_mmc: constify dw_mci_idmac_ops in exynos back-end

Balaji T K (2):
      mmc: omap_hsmmc: fix host reference after mmc_free_host
      mmc: omap_hsmmc: fix NULL pointer dereference for dt boot

Chris Ball (1):
      mmc: sdhci: fix NULL dereference in sdhci_request() tuning

Fabio Estevam (1):
      mmc: mxcmmc: Fix MODULE_ALIAS

Guennadi Liakhovetski (1):
      mmc: sh_mmcif: fix use after free

James Hogan (1):
      mmc: dw_mmc: fix multiple drv_data NULL dereferences

Jerry Huang (1):
      mmc: sdhci-of-esdhc: disable CMD23 for some Freescale SoCs

Kevin Liu (1):
      mmc: sdhci: fix IS_ERR() checking of regulator_get()

Russell King - ARM Linux (1):
      mmc: fix sdhci-dove probe/removal

Seungwon Jeon (3):
      mmc: dw_mmc: convert the variable type of irq
      mmc: dw_mmc: remove _dev_info compile warning
      mmc: sdhci-s3c: fix the card detection in runtime-pm

Thomas Abraham (1):
      mmc: sdhci-s3c: use clk_prepare_enable and clk_disable_unprepare

Yuvaraj CD (1):
      mmc: dw_mmc: enable controller interrupt before calling mmc_start_host

 drivers/mmc/host/dw_mmc-exynos.c  |  8 ++---
 drivers/mmc/host/dw_mmc-pltfm.c   |  6 ++--
 drivers/mmc/host/dw_mmc-pltfm.h   |  2 +-
 drivers/mmc/host/dw_mmc.c         | 62 +++++++++++++++++++++------------------
 drivers/mmc/host/mxcmmc.c         |  2 +-
 drivers/mmc/host/omap_hsmmc.c     | 19 +++++++-----
 drivers/mmc/host/sdhci-dove.c     | 38 ++++++++++++------------
 drivers/mmc/host/sdhci-of-esdhc.c | 11 +++++++
 drivers/mmc/host/sdhci-pci.c      |  2 +-
 drivers/mmc/host/sdhci-pltfm.c    |  7 +++++
 drivers/mmc/host/sdhci-s3c.c      | 30 ++++++++++---------
 drivers/mmc/host/sdhci.c          | 44 +++++++++++++++++----------
 drivers/mmc/host/sdhci.h          |  1 +
 drivers/mmc/host/sh_mmcif.c       |  2 +-
 include/linux/mmc/dw_mmc.h        |  6 ++--
 include/linux/mmc/sdhci.h         |  1 +
 16 files changed, 144 insertions(+), 97 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
