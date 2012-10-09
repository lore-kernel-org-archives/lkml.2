Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2JIDuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:50:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:22310 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2JIDt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:49:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,557,1344236400"; 
   d="asc'?scan'208";a="202155451"
Subject: [GIT PULL] slave-dmaengine updates for 3.7
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: Dan Williams <djbw@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aapAVqJMeV6F7lZSo5nj"
Date: Tue, 09 Oct 2012 09:11:03 +0530
Message-ID: <1349754063.1648.5252.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aapAVqJMeV6F7lZSo5nj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the slave-dmaengine update for 3.7

This time we have Andy updates on dw_dmac which is attempting to make
this IP block available as PCI and platform device though not fully
complete this time.
We also have TI EDMA moving the dma driver to use dmaengine APIs, also
have a new driver for mmp-tdma, along with bunch of small updates.

Now for your excitement the merge is little unusual here, while merging
the auto merge on linux-next picks wrong choice for pl330
(drivers/dma/pl330.c) and this causes build failure. The correct
resolution is in linux-next. (DMA: PL330: Fix build error)
I didn't back merge your tree this time as you are better than me so no
point in doing that for me :)


The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee=
:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Andy Shevchenko (9):
      dw_dmac: use devm_* functions to simplify code
      dw_dmac: utilize slave_id to pass request line
      dw_dmac: mark dwc_dump_chan_regs as inline
      dw_dmac: fill optional encoded parameters in register structure
      dw_dmac: get number of channels from hardware if possible
      dw_dmac: autoconfigure block_size or use platform data
      dw_dmac: autoconfigure data_width or get it via platform data
      dw_dmac: introduce software emulation of LLP transfers
      dw_dmac: fix a regression in dwc_prep_dma_memcpy

Dave Jiang (1):
      ioat: Adding Ivy Bridge IOATDMA PCI device IDs

Fabio Estevam (1):
      dma: imx-dma: Fix kernel crash due to missing clock conversion

Inderpal Singh (3):
      DMA: PL330: Remove controller clock enable/disable
      DMA: PL330: Remove redundant runtime_suspend/resume functions
      DMA: PL330: return ENOMEM instead of 0 from pl330_alloc_chan_resource=
s

Julia Lawall (2):
      drivers/dma/sirf-dma.c: fix usage of devm functions
      drivers/dma/amba-pl08x.c: fix error return code

Laxman Dewangan (2):
      dma: tegra: enable/disable dma clock
      dma: tegra: fix interrupt name issue with apb dma.

Marek Vasut (1):
      mxs/dma: Enlarge the CCW descriptor area to 4 pages

Matt Porter (3):
      dmaengine: add TI EDMA DMA engine driver
      mmc: davinci_mmc: convert to DMA engine API
      spi: spi-davinci: convert to DMA engine API

Tushar Behera (2):
      ARM: EXYNOS: Set the capability of pdm0 and pdm1 as DMA_PRIVATE
      DMA: PL330: Set the capability of pdm0 and pdm1 as DMA_PRIVATE

Ulf Hansson (1):
      dma/ste_dma40: Fixup clock usage during probe

Vinod Koul (3):
      Merge branch 'for-3.7' into next
      Merge branch 'fixes_for-3.6' into next
      spi: davici - make davinci select edma

Wei Yongjun (2):
      dma: tegra: use list_move_tail instead of list_del/list_add_tail
      dmaengine: use kmem_cache_zalloc instead of kmem_cache_alloc/memset

Zhangfei Gao (2):
      dmaengine: mmp-pdma support
      dmaengine: mmp_tdma: add dt support

 arch/arm/mach-exynos/dma.c            |    2 +
 arch/arm/mach-spear13xx/spear13xx.c   |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c   |    3 +
 drivers/dma/Kconfig                   |   17 +
 drivers/dma/Makefile                  |    2 +
 drivers/dma/amba-pl08x.c              |    2 +
 drivers/dma/dw_dmac.c                 |  258 +++++++---
 drivers/dma/dw_dmac_regs.h            |   48 ++-
 drivers/dma/edma.c                    |  671 +++++++++++++++++++++++++
 drivers/dma/imx-dma.c                 |   36 +-
 drivers/dma/ioat/dma_v2.c             |    3 +-
 drivers/dma/ioat/pci.c                |   22 +
 drivers/dma/mmp_pdma.c                |  875 +++++++++++++++++++++++++++++=
++++
 drivers/dma/mmp_tdma.c                |   51 ++-
 drivers/dma/mxs-dma.c                 |   14 +-
 drivers/dma/pl330.c                   |   76 +---
 drivers/dma/sirf-dma.c                |   23 +-
 drivers/dma/ste_dma40.c               |   14 +-
 drivers/dma/tegra20-apb-dma.c         |   30 +-
 drivers/mmc/host/davinci_mmc.c        |  271 +++-------
 drivers/spi/Kconfig                   |    1 +
 drivers/spi/spi-davinci.c             |  292 +++++------
 include/linux/dw_dmac.h               |    7 +
 include/linux/edma.h                  |   29 ++
 include/linux/platform_data/mmp_dma.h |   19 +
 25 files changed, 2208 insertions(+), 561 deletions(-)
 create mode 100644 drivers/dma/edma.c
 create mode 100644 drivers/dma/mmp_pdma.c
 create mode 100644 include/linux/edma.h
 create mode 100644 include/linux/platform_data/mmp_dma.h

--=20
~Vinod

--=-aapAVqJMeV6F7lZSo5nj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJQc5zHAAoJEHwUBw8lI4NHvYcQAIM+BEKyS2yOzMO2dds+gv7f
vsbJgshOkIf4JLe0mUX9LeJ51uWnxECG6gQeky1IF5VLsm8kizPOYxbmGud6/RWh
MwKbyHQM5vauXKOVEHMNAgSB6sMfSKH7heqJnkTpvDuJFZDJ4AS1T4jr/cdDJUmq
K4wpsbymWyNVXk/2b7v2HoNDWR66b0ZlLi+zJQJSkuI/3b6g+74yL8cTV80yf7Uo
HUwCpjyjdgI/NdRbVgXSL5XLuLCI2mjKowQXAInW5MWsfgjZSUZodDFN3ZhwIHxS
LKotH0y5A/08Ecbyd8WagVwkCDljpZKpGOvv1MyrTX1mJDoovnkKDicPpozKROAm
pP6bT000GNLeUpXeJXzFoF6UPb7/qmpqFq+mdtP03i6sO2NfoYS7w2JO6/1nZQOT
988Da391K2QhzMvgBzOOl78tecaIy5nYDBksejLc/WSY3MY/xbila++MZ0RTQov7
87nuJbdU3IkBmeG+ZgIcePh3woRVcydJCH7Oxlw/ulRbDzycWcyXkCbq/OHUXtzX
k1RIvyyHml/8IjEpIthZPYDqP083vXh8ObeetRGAA6y/XBve3TqL1d3YokCgwBD2
aiMhmma6kCHseJS5Jny/FHEbIfkRqMTNHYO+kSCxz25WeB9eF/ZjcPCCTUIm87g9
GQju8kBi+jAlkopRdX3S
=OqYh
-----END PGP SIGNATURE-----

--=-aapAVqJMeV6F7lZSo5nj--

