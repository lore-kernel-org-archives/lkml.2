Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2EYIaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:30:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:10069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab2EYIaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157143481"
Subject: [GIT PULL] slave-dmaengine updates for 3.5
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 13:53:25 +0530
Message-ID: <1337934205.1580.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here is the slave-dmaengine update for 3.5 merge cycle.

Nothing exciting this time, odd fixes in bunch of drivers.


The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:
  Linus Torvalds (1):
        Linux 3.4-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Davide Ciminaghi (1):
      dmaengine/amba-pl08x : reset phychan_hold on terminate all

Huang Shijie (1):
      dma: imx-sdma: keep the callbacks invoked in the tasklet

Kuninori Morimoto (1):
      dmaengine: Fixup dmaengine_prep_slave_single() to be actually useful

Lars-Peter Clausen (2):
      dmaengine: Use sg_dma_address instead of sg_phys
      dmaengine: Use dma_sg_len(sg) instead of sg->length

Linus Walleij (4):
      dma/ste_dma40: explicitly include regulator consumer header
      dma/ste_dma40: fix erroneous comparison
      dma/amba-pl08x: check for terminal count status only
      dma/amba-pl08x: add support for the Nomadik variant

Narayanan G (1):
      dma40: Improve the logic of stopping logical chan

Nicolas Ferre (4):
      dmaengine: at_hdmac: remove clear-on-read in atc_dostart()
      dmaengine: at_hdmac: remove some at_dma_slave comments
      dmaengine: at_hdmac: remove ATC_DEFAULT_CTRLA constant
      dmaengine: at_hdmac: take maxburst from slave configuration

Olof Johansson (1):
      dma: pl330: fix a couple of compilation warnings

Richard Zhao (1):
      dma: imx-sdma: make channel0 operations atomic

Sachin Kamat (1):
      DMA: PL330: Remove duplicate header file inclusion

Shawn Guo (1):
      dma: mxs-dma: enable channel in device_issue_pending call

Vinod Koul (6):
      dmaengine: imx-dma: dont complete descriptor for cyclic dma
      Merge branch 'fixes' into next
      dmaengine: pl330: dont complete descriptor for cyclic dma
      Merge branch 'fixes' into next
      dmaengine: fix cyclic dma usage
      Merge branch 'fixes' into next

Viresh Kumar (2):
      dmaengine: dw_dmac: Add clk_{un}prepare() support
      dmaengine: dw_dma: add Device Tree probing capability

 Documentation/devicetree/bindings/dma/snps-dma.txt |   17 +
 arch/arm/include/asm/hardware/pl080.h              |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |    1 -
 arch/arm/mach-at91/include/mach/at_hdmac.h         |   26 --
 drivers/dma/amba-pl08x.c                           |   53 +++-
 drivers/dma/at_hdmac.c                             |   23 +-
 drivers/dma/at_hdmac_regs.h                        |   21 ++-
 drivers/dma/coh901318.c                            |    2 +-
 drivers/dma/coh901318_lli.c                        |    4 +-
 drivers/dma/dw_dmac.c                              |   26 +-
 drivers/dma/ep93xx_dma.c                           |    4 +-
 drivers/dma/imx-dma.c                              |   21 +-
 drivers/dma/imx-sdma.c                             |   68 +++--
 drivers/dma/intel_mid_dma.c                        |    8 +-
 drivers/dma/mxs-dma.c                              |   16 +-
 drivers/dma/pch_dma.c                              |    2 +-
 drivers/dma/pl330.c                                |   29 +-
 drivers/dma/ste_dma40.c                            |  325 ++++++++++++--------
 drivers/dma/ste_dma40_ll.h                         |    2 -
 drivers/mmc/host/mxs-mmc.c                         |    3 +
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    1 +
 include/linux/amba/pl08x.h                         |    3 +
 include/linux/dmaengine.h                          |    6 +-
 23 files changed, 407 insertions(+), 256 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/snps-dma.txt


-- 
~Vinod

