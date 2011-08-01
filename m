Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1HAKpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:45:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:4379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1HAKpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,299,1309762800"; 
   d="scan'208";a="2966492"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Date: Mon, 1 Aug 2011 16:13:12 +0530
Subject: [GIT PULL] slave-dmaengine updates
Thread-Topic: [GIT PULL] slave-dmaengine updates
Thread-Index: AcxQN8+qVTFAuh0OTRCHRXVp9EKqgg==
Message-ID: <438BB0150E931F4B9CE701519A4463010871FA60B6@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p71AjL8V024936

Hi Linus,

Here is the slave-dmaengine updates which include general updates to few drivers and 
start of the consolidation of arm dma drivers into generic dma controllers
This also had dma-slave documentation updated by Russell

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:
  
are available in the git repository at:
  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Alexander Stein (1):
      pch_dma: Fix channel locking

Axel Lin (3):
      dmaengine: imx-sdma: return proper error if kzalloc fails
      dma: mxs-dma: fix unterminated platform_device_id table
      dma: intel_mid_dma: remove redundant pci_set_drvdata calls

Dong Aisheng (1):
      ARM: mxs-dma: reset after disable channel

Grant Likely (1):
      Merge remote-tracking branch 'origin' into spi/merge

Guennadi Liakhovetski (1):
      dmaengine: failure to get a specific DMA channel is not critical

H Hartley Sweeten (4):
      dma: ipu_idmac.c: use resource_size in ioremap
      dma: at_hdmac.c: use resource_size
      dma/ep93xx_dma.c: local symbols should be static
      dma: mv_xor: use resource_size()

Linus Walleij (2):
      dmaengine/ste_dma40: use AMBA PrimeCell helper macros
      dmaengine/coh901318: fix slave submission semantics

Mika Westerberg (5):
      dmaengine: add ep93xx DMA support
      ep93xx: add dmaengine platform code
      ASoC: ep93xx: convert to use the DMA engine API
      ep93xx: remove the old M2P DMA code
      spi/ep93xx: add DMA support 

Per Forlin (2):
      dmaengine/ste_dma40: add a separate queue for pending requests
      dmaengine: remove ste_dma40 from issue_pending TODO

Rabin Vincent (1):
      dmaengine/ste_dma40: allow memory buswidth/burst to be configured

Rob Herring (1):
      dmaengine: pl330: make platform data optional

Robert Marklund (1):
      dmaengine/ste_dma40: make the cyclic alloc NOWAIT

Russell King - ARM Linux (10):
      DMA: PL08x: remove unused constants
      DMA: PL08x: select LLI bus only once per LLI setup
      DMA: PL08x: clean up LLI debugging
      DMA: PL08x: separately store source/destination slave address
      DMA: PL08x: separately store source/destination cctl
      DMA: PL08x: constify plchan->cd and plat->slave_channels
      DMA: PL08x: cleanup selection of buswidth
      DMA: PL08x: avoid recalculating cctl at each prepare
      DMA: PL08x: cleanup selection of burst size
      Improve slave/cyclic DMA engine documentation

Shawn Guo (1):
      dmaengine: mxs-dma: skip request_irq for NO_IRQ

Tomoya MORINAGA (2):
      pch_dma: fix DMA issue(ch8-ch11)
      pch_dma: Fix CTL register access issue

Vinod Koul (3):
      Merge remote branch 'gpio/ep93xx-dma' into next
      dmaengine: pl08x: handle the rest of enums in pl08x_width
      Merge branch 'next' into for-linus-3.0

om prakash (1):
      dmaengine/ste_dma40: fix missing kernel-doc

 Documentation/dmaengine.txt                    |  234 +++--
 Documentation/spi/ep93xx_spi                   |   10 +
 arch/arm/mach-ep93xx/Makefile                  |    4 +-
 arch/arm/mach-ep93xx/core.c                    |    6 +-
 arch/arm/mach-ep93xx/dma-m2p.c                 |  411 -------
 arch/arm/mach-ep93xx/dma.c                     |  108 ++
 arch/arm/mach-ep93xx/include/mach/dma.h        |  190 ++---
 arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
 drivers/dma/Kconfig                            |    7 +
 drivers/dma/Makefile                           |    1 +
 drivers/dma/TODO                               |    1 -
 drivers/dma/amba-pl08x.c                       |  246 +++---
 drivers/dma/at_hdmac.c                         |    4 +-
 drivers/dma/coh901318.c                        |   19 +-
 drivers/dma/dmaengine.c                        |    4 +-
 drivers/dma/ep93xx_dma.c                       | 1355
++++++++++++++++++++++++
 drivers/dma/imx-sdma.c                         |    4 +-
 drivers/dma/intel_mid_dma.c                    |    2 -
 drivers/dma/ipu/ipu_idmac.c                    |    6 +-
 drivers/dma/mv_xor.c                           |    4 +-
 drivers/dma/mxs-dma.c                          |   13 +-
 drivers/dma/pch_dma.c                          |  127 ++-
 drivers/dma/pl330.c                            |   64 +-
 drivers/dma/ste_dma40.c                        |  270 +++--
 drivers/dma/ste_dma40_ll.h                     |    3 -
 drivers/spi/ep93xx_spi.c                       |  303 +++++-
 include/linux/amba/pl08x.h                     |    9 +-
 sound/soc/ep93xx/ep93xx-ac97.c                 |    4 +-
 sound/soc/ep93xx/ep93xx-i2s.c                  |    4 +-
 sound/soc/ep93xx/ep93xx-pcm.c                  |  137 ++--
 30 files changed, 2541 insertions(+), 1011 deletions(-)
 delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
 create mode 100644 arch/arm/mach-ep93xx/dma.c
 create mode 100644 drivers/dma/ep93xx_dma.c

-- 
~Vinod
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
