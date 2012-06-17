Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab2FQSvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:51:51 -0400
Received: from void.printf.net ([89.145.121.20]:35246 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab2FQSvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:51:50 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.5-rc4
Date: Sun, 17 Jun 2012 14:51:44 -0400
Message-ID: <878vflojpb.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.5-rc4

to receive MMC fixes for 3.5-rc4.  There are no merge conflicts, and the
patches have been tested in linux-next.  Thanks.


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-fixes-for-3.5-rc4

for you to fetch changes up to a3e545e9ab26892641ecac7cee30ea4b4e87977e:

  mmc: mxs-mmc: Move of_match_table out of CONFIG_PM (2012-06-06 10:16:40 -0400)

----------------------------------------------------------------
MMC fixes for 3.5-rc4:

 - atmel-mci: Fixes for NULL timer and DMA burst/chunk size
 - dw_mmc: Fix DMA ordering, clkdiv calculation, NULL host->data
 - mxs_mmc: Compile fix for CONFIG_OF=y && CONFIG_PM=n
 - omap: Fix NULL deref in mmc_omap_remove_slot(), reg_shift initialization
 - sdhci-s3c: Fix boot regression by adding IRQF_ONESHOT flag
 - Small fixes to core/sd, core/sdio, sdhci

----------------------------------------------------------------
Chris Ball (1):
      mmc: sdhci: Use DBG() instead of pr_warning() on large timeout

Heiko Stübner (1):
      mmc: sdhci-s3c: pass IRQF ONESHOT to request threaded irq

Jaehoon Chung (1):
      mmc: core: return an error on suspend if mmc_deselect_cards fails

Ludovic Desroches (1):
      mmc: atmel-mci: fix data timeout issue

Marek Vasut (1):
      mmc: mxs-mmc: Move of_match_table out of CONFIG_PM

Nicolas Ferre (1):
      mmc: atmel-mci: fix burst/chunk size modification

Seungwon Jeon (4):
      mmc: dw_mmc: fix the transmission handling in IDMAC
      mmc: dw_mmc: fix the IDMAC sw reset
      mmc: dw_mmc: fix incorrect setting of host->data of NULL
      mmc: dw_mmc: correct the calculation for CLKDIV

Tony Lindgren (3):
      mmc: omap: Fix a section warning regression
      mmc: omap: Fix NULL pointer dereference if mmc_omap_new_slot() fails
      mmc: omap: Fix broken reg_shift initialization

Yong Ding (1):
      mmc: sdio: fix setting card data bus width as 4-bit

 drivers/mmc/core/mmc.c            |    2 +-
 drivers/mmc/core/sd.c             |    6 ++++--
 drivers/mmc/core/sdio.c           |    6 ++++++
 drivers/mmc/host/atmel-mci-regs.h |   14 ++++++++++++++
 drivers/mmc/host/atmel-mci.c      |   12 +++++++-----
 drivers/mmc/host/dw_mmc.c         |   36 ++++++++++++++++++------------------
 drivers/mmc/host/mxs-mmc.c        |    2 +-
 drivers/mmc/host/omap.c           |   18 ++++++++++--------
 drivers/mmc/host/sdhci-s3c.c      |    2 +-
 drivers/mmc/host/sdhci.c          |    4 ++--
 include/linux/mmc/sdio.h          |    2 ++
 11 files changed, 66 insertions(+), 38 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
