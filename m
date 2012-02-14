Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab2BNEvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:51:20 -0500
Received: from void.printf.net ([89.145.121.20]:51885 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab2BNEvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:51:19 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.3-rc4
Date: Mon, 13 Feb 2012 23:51:04 -0500
Message-ID: <m24nuuj9vr.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive MMC fixes for 3.3-rc4.  I've signed an "mmc-fixes-for-3.3-rc4"
tag.  There are no merge conflicts, and the patches have been tested in
linux-next.  Thanks.

The following changes since commit 3ec1e88b33a3bdd852ce8e014052acec7a9da8b5:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2012-02-11 10:07:11 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to f9c2a0dc42a6938ff2a80e55ca2bbd1d5581c72e:

  mmc: dw_mmc: Fix PIO mode with support of highmem (2012-02-13 20:39:05 -0500)

----------------------------------------------------------------
MMC fixes for 3.3-rc4:
 * The most visible fix here is against a regression introduced in 3.3-rc1
   that ran cards in Ultra High Speed mode even when they failed to initialize
   in that mode, leading to lower-speed cards failing to mount.
 * A lockdep warning introduced in 3.3-rc1 is fixed.
 * Various other small driver fixes, most notably for a NULL dereference
   when using highmem with dw_mmc.

----------------------------------------------------------------
Adrian Hunter (1):
      mmc: sdhci-pci: set Medfield SDIO as non-removable

Girish K S (2):
      mmc: core: Fix low speed mmc card detection failure
      mmc: core: Fix PowerOff Notify suspend/resume

Guennadi Liakhovetski (2):
      mmc: tmio_mmc: fix card eject during IO with DMA
      mmc: sh_mmcif: fix late delayed work initialisation

Jaehoon Chung (1):
      mmc: core: add the capability for broken voltage

Jean-Christophe PLAGNIOL-VILLARD (1):
      mmc: of_mmc_spi: fix little endian support

Jerry Huang (2):
      mmc: esdhc: add PIO mode support
      mmc: esdhc: set the timeout to the max value

Jurgen Heeks (1):
      mmc: core: Fix comparison issue in mmc_compare_ext_csds

Ludovic Desroches (1):
      mmc: atmel-mci: save and restore sdioirq when soft reset is performed

Philip Rakity (1):
      mmc: core: UHS sdio card that fails should not exceed 50MHz

Rabin Vincent (1):
      mmc: block: Init ro_lock sysfs attr to fix lockdep warnings

Roy Zang (1):
      mmc: esdhc: fix errors when booting kernel on Freescale eSDHC version 2.3

Seungwon Jeon (1):
      mmc: dw_mmc: Fix PIO mode with support of highmem

Sujit Reddy Thumma (1):
      mmc: core: Ensure clocks are always enabled before host interaction

 drivers/mmc/card/block.c          |    1 +
 drivers/mmc/core/core.c           |   49 ++++++++++---
 drivers/mmc/core/host.h           |   21 ------
 drivers/mmc/core/mmc.c            |   26 +++++---
 drivers/mmc/core/sd.c             |   22 +++++-
 drivers/mmc/core/sdio.c           |    7 +-
 drivers/mmc/core/sdio_irq.c       |   10 ++-
 drivers/mmc/host/atmel-mci.c      |    3 +
 drivers/mmc/host/dw_mmc.c         |  144 +++++++++++++++++++------------------
 drivers/mmc/host/of_mmc_spi.c     |    4 +-
 drivers/mmc/host/sdhci-of-esdhc.c |   32 ++++++++
 drivers/mmc/host/sdhci-pci.c      |    2 +-
 drivers/mmc/host/sdhci-pltfm.c    |   10 +++-
 drivers/mmc/host/sh_mmcif.c       |   16 +++--
 drivers/mmc/host/tmio_mmc.h       |    7 ++-
 drivers/mmc/host/tmio_mmc_dma.c   |   12 +++
 drivers/mmc/host/tmio_mmc_pio.c   |    6 ++-
 include/linux/mmc/card.h          |    4 +
 include/linux/mmc/dw_mmc.h        |    6 +-
 include/linux/mmc/host.h          |   20 +++++
 20 files changed, 269 insertions(+), 133 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
