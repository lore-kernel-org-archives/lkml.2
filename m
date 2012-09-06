Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab2IFB4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:56:18 -0400
Received: from void.printf.net ([89.145.121.20]:46840 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab2IFB4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:56:17 -0400
From: Chris Ball <cjb@laptop.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.6-rc5
Date: Wed, 05 Sep 2012 21:56:06 -0400
Message-ID: <87k3w7gbih.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.6-rc5

to receive MMC fixes for 3.6-rc5.  There are no merge conflicts, and the
patches have been tested in linux-next.  Thanks.


The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.6-rc5

for you to fetch changes up to 75b53aee2f4fe6375c6007226bf68d75b5c4a929:

  mmc: omap: fix broken PIO mode (2012-09-04 13:58:11 -0400)

----------------------------------------------------------------
MMC fixes for 3.6-rc5:
 - a firmware bug on several Samsung MoviNAND eMMC models causes
   permanent corruption on the device when secure erase and secure trim
   requests are made, so we disable those requests on these eMMC devices.
 - atmel-mci: fix a hang with some SD cards by waiting for not-busy flag.
 - dw_mmc: low-power mode breaks SDIO interrupts; fix PIO error handling;
   fix handling of error interrupts.
 - mxs-mmc: fix deadlocks; fix compile error due to dma.h arch change.
 - omap: fix broken PIO mode causing memory corruption.
 - sdhci-esdhc: fix card detection.

----------------------------------------------------------------
Doug Anderson (1):
      mmc: dw_mmc: Disable low power mode if SDIO interrupts are used

Ian Chen (1):
      mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corruption.

Lauri Hintsala (2):
      mmc: mxs-mmc: fix deadlock in SDIO IRQ case
      mmc: mxs-mmc: fix deadlock caused by recursion loop

Ludovic Desroches (1):
      mmc: atmel-mci: not busy flag has also to be used for read operations

Paul Walmsley (1):
      mmc: omap: fix broken PIO mode

Seungwon Jeon (3):
      mmc: dw_mmc: amend using error interrupt status
      mmc: dw_mmc: correct mishandling error interrupt
      mmc: dw_mmc: fix error handling in PIO mode

Shawn Guo (1):
      mmc: sdhci-esdhc: break out early if clock is 0

Sonic Zhang (1):
      mmc: bfin_sdh: fix dma_desc_array build error

 drivers/mmc/card/block.c       | 26 ++++++++++++-
 drivers/mmc/host/atmel-mci.c   |  6 ++-
 drivers/mmc/host/bfin_sdh.c    |  7 ----
 drivers/mmc/host/dw_mmc.c      | 85 +++++++++++++++++++++++-------------------
 drivers/mmc/host/mxs-mmc.c     | 14 +++----
 drivers/mmc/host/omap.c        | 14 +++++--
 drivers/mmc/host/sdhci-esdhc.h |  6 +--
 include/linux/mmc/card.h       |  1 +
 8 files changed, 98 insertions(+), 61 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
