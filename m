Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2DUEW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:22:57 -0400
Received: from void.printf.net ([89.145.121.20]:56152 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab2DUEW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:22:56 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.4-rc4
Date: Sat, 21 Apr 2012 00:23:08 -0400
Message-ID: <87zka5g1cj.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.4-rc4

to receive MMC fixes for 3.4-rc4.  There are no merge conflicts, and the
patches have been tested in linux-next.  Thanks.

The following changes since commit 3b422e9c2c020a1137349c614da7f9c9761a0922:

  Merge tag 'for-torvalds-20120418' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl (2012-04-20 12:28:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.4-rc4

for you to fetch changes up to 7c5709194096beea1ab6e6db46768d70a068efb0:

  mmc: core: Do not pre-claim host in suspend (2012-04-20 21:52:13 -0400)

----------------------------------------------------------------
MMC fixes for 3.4-rc4:
 The major fixes here are:
  * Build fix for omap_hsmmc with OF against 3.4-rc1.
  * Fix CONFIG_MMC_UNSAFE_RESUME semantics regression against 3.3,
    which broke hotplug card detection when UNSAFE_RESUME is set.
  * Fix a race condition in omap_hsmmc with runtime PM.
  * Fix two libertas SDIO-powered-resume regressions.
 Also small fixes for discard/sanitize, dw_mmc, cd-gpio and esdhc-imx.

----------------------------------------------------------------
Adrian Hunter (2):
      mmc: fixes for eMMC v4.5 discard operation
      mmc: fixes for eMMC v4.5 sanitize operation

Chris Ball (1):
      mmc: omap_hsmmc: build fix for CONFIG_OF=y and CONFIG_MMC_OMAP_HS=m

Chuanxiao Dong (1):
      mmc: remove MMC bus legacy suspend/resume method

Daniel Drake (1):
      mmc: sdhci: refine non-removable card checking for card detection

Eric Bénard (1):
      mmc: unbreak sdhci-esdhc-imx on i.MX25

H Hartley Sweeten (1):
      mmc: cd-gpio: Include header to pickup exported symbol prototypes

Jaehoon Chung (1):
      mmc: dw_mmc: prevent NULL dereference for dma_ops

Rajendra Nayak (1):
      mmc: omap_hsmmc: Get rid of of_have_populated_dt() usage

Seungwon Jeon (1):
      mmc: dw_mmc: Fix switch from DMA to PIO

Ulf Hansson (1):
      mmc: core: Do not pre-claim host in suspend

 drivers/mmc/card/block.c           |   56 ++++++++++++++++++++++---------
 drivers/mmc/card/queue.c           |    2 +-
 drivers/mmc/core/bus.c             |   24 ++++---------
 drivers/mmc/core/cd-gpio.c         |    1 +
 drivers/mmc/core/core.c            |   64 ++++++++++++++---------------------
 drivers/mmc/host/dw_mmc.c          |    7 +++-
 drivers/mmc/host/omap_hsmmc.c      |    6 ++--
 drivers/mmc/host/sdhci-esdhc-imx.c |    3 +-
 drivers/mmc/host/sdhci.c           |    2 +-
 include/linux/mmc/card.h           |    2 +-
 10 files changed, 86 insertions(+), 81 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
