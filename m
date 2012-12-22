Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2LVEdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:33:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36374 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2LVEdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:33:44 -0500
Subject: [GIT PULL] dmaengine updates
From: Vinod Koul <vkoul@infradead.org>
To: Linus <torvalds@linux-foundation.org>
Cc: vinod.koul@intel.com, Dan Williams <djbw@fb.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SsJjZpiOMEKpZk7Z0iX6"
Date: Fri, 21 Dec 2012 20:10:37 -0800
Message-ID: <1356149437.7077.2992.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SsJjZpiOMEKpZk7Z0iX6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the pull request for dmaengine. I just saw that you have declared r=
c1
couple of hours ago, so I missed the window narrowly... I can try to make a=
n
excuse that I am vacation and was traveling so this got delayed. And was
counting on your Christmas deadline :(

Please do consider merging this for rc2 as it brings in much awaited DT sup=
port for
dmaengine which lot of folks care about and have plans to work on it for ne=
xt
release. Along with this add few other odd fixes including ones on async_tx

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Akinobu Mita (4):
      dmaengine: use for_each_set_bit
      dma: amba-pl08x: use vchan_dma_desc_free_list
      dmatest: adjust invalid module parameters for number of source buffer=
s
      async_tx: use memchr_inv

Andy Shevchenko (4):
      dw_dmac: change dev_printk() to corresponding macros
      dw_dmac: don't call platform_get_drvdata twice
      dw_dmac: change dev_crit to dev_WARN in dwc_handle_error
      dw_dmac: introduce to_dw_desc() macro

Barry Song (2):
      dmaengine: sirf: enable the driver support new SiRFmarco SoC
      DMAEngine: add dmaengine_prep_interleaved_dma wrapper for interleaved=
 api

Bartlomiej Zolnierkiewicz (10):
      async_tx: add missing DMA unmap to async_memcpy()
      ioat: add missing DMA unmap to ioat_dma_self_test()
      mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
      carma-fpga: pass correct flags to ->device_prep_dma_memcpy()
      ioat3: add missing DMA unmap to ioat_xor_val_self_test()
      async_tx: fix build for async_memset
      dmaengine: remove dma_async_memcpy_pending() macro
      dmaengine: remove dma_async_memcpy_complete() macro
      dmaengine: add cpu_relax() to busy-loop in dma_sync_wait()
      async_tx: fix checking of dma_wait_for_async_tx() return value

Dave Jiang (2):
      ioat: Add alignment workaround for IVB platforms
      ioat: remove chanerr mask setting for IOAT v3.x

Guennadi Liakhovetski (1):
      dma: sh: Don't use ENODEV for failing slave lookup

Heikki Krogerus (2):
      dmaengine: dw_dmac: remove CLK dependency
      dmaengine: dw_dmac: amend description and indentation

Jean Delvare (1):
      dma: ipu: Drop unused spinlock

Joe Perches (1):
      dma: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Jon Hunter (4):
      dmaengine: add helper function to request a slave DMA channel
      of: Add generic device tree DMA helpers
      of: dma: fix potential deadlock when requesting a slave channel
      of: dma: fix protection of DMA controller data stored by DMA helpers

Jon Mason (1):
      dmatest: Fix NULL pointer dereference on ioat

Kees Cook (1):
      drivers/dma: remove CONFIG_EXPERIMENTAL

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Matt Porter (1):
      of: dma: fix typos in generic dma binding definition

Sachin Kamat (1):
      DMA: PL330: Use devm_* functions

Shiraz Hashim (1):
      dmaengine/dmatest: terminate transfers only in case of errors

Vinod Koul (5):
      of: dma- fix build break for !CONFIG_OF
      dmaengine: fix build failure due to missing semi-colon
      Merge branch 'topic/dmaengine_dt' into next
      dmaengine: fix !of_dma compilation warning
      Merge git://git.kernel.org/.../djbw/dmaengine.git/next

Viresh Kumar (3):
      dmaengine: dw_dmac: Update documentation style comments for dw_dma_pl=
atform_data
      dmaengine: dw_dmac: Enhance device tree support
      ARM: SPEAr13xx: Pass DW DMAC platform data from DT

Wei Yongjun (1):
      pch_dma: use module_pci_driver to simplify the code

 Documentation/devicetree/bindings/dma/dma.txt      |   81 ++++++
 Documentation/devicetree/bindings/dma/snps-dma.txt |   44 ++++
 arch/arm/boot/dts/spear1340.dtsi                   |   19 ++
 arch/arm/boot/dts/spear13xx.dtsi                   |   38 +++
 arch/arm/mach-spear13xx/include/mach/spear.h       |    2 -
 arch/arm/mach-spear13xx/spear1310.c                |    4 +-
 arch/arm/mach-spear13xx/spear1340.c                |   27 +--
 arch/arm/mach-spear13xx/spear13xx.c                |   54 +----
 crypto/async_tx/async_memcpy.c                     |    6 +
 crypto/async_tx/async_memset.c                     |    1 +
 crypto/async_tx/async_tx.c                         |    9 +-
 crypto/async_tx/async_xor.c                        |    4 +-
 drivers/dca/dca-core.c                             |    5 +
 drivers/dma/Kconfig                                |    7 +-
 drivers/dma/amba-pl08x.c                           |    8 +-
 drivers/dma/at_hdmac_regs.h                        |    8 +-
 drivers/dma/dmaengine.c                            |   21 ++-
 drivers/dma/dmatest.c                              |   22 ++-
 drivers/dma/dw_dmac.c                              |  167 +++++++++++--
 drivers/dma/dw_dmac_regs.h                         |    6 +
 drivers/dma/ioat/dma.c                             |   11 +-
 drivers/dma/ioat/dma_v3.c                          |  105 ++++++--
 drivers/dma/ioat/hw.h                              |   11 +
 drivers/dma/ioat/pci.c                             |   11 -
 drivers/dma/iop-adma.c                             |   45 ++--
 drivers/dma/ipu/ipu_irq.c                          |    1 -
 drivers/dma/mv_xor.c                               |   62 ++---
 drivers/dma/pch_dma.c                              |   13 +-
 drivers/dma/pl330.c                                |   37 +--
 drivers/dma/sh/shdma.c                             |    2 +-
 drivers/dma/sirf-dma.c                             |   25 ++-
 drivers/misc/carma/carma-fpga-program.c            |    2 +-
 drivers/misc/carma/carma-fpga.c                    |    6 +-
 drivers/mtd/nand/fsmc_nand.c                       |   22 +-
 drivers/of/Makefile                                |    2 +-
 drivers/of/dma.c                                   |  264 ++++++++++++++++=
++++
 include/linux/dmaengine.h                          |   43 ++--
 include/linux/dw_dmac.h                            |   45 ++--
 include/linux/of_dma.h                             |   74 ++++++
 net/ipv4/tcp.c                                     |    8 +-
 40 files changed, 995 insertions(+), 327 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/dma.txt
 create mode 100644 drivers/of/dma.c
 create mode 100644 include/linux/of_dma.h

--=20
Vinod Koul
Intel Corp.

--=-SsJjZpiOMEKpZk7Z0iX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJQ1TK1AAoJEHwUBw8lI4NHox8P/ipqlJCjJed7gC/LJfGYvNBS
N/bOCFmVZM7fak1ZKu40+eaffnSkueDPiDNwae/gAe4E/DR3+/DQg58xsgmF4TJv
t1uoPr3IOw9MVv853awawI7bTucpN3THNvt3JIIMJ+c8Ns6T32v998d0t+DJhQhC
porRjQgVjwnKajWKEI8eB6p6NDWGGRFMAYlEaph+nyaSHY77mb8SIKvszojVBkG+
ntEkoLtxkOrpuxgUWktSErzc8OGcfBBFnhIxp8chq+ObrrahNOWhVizHEqcdDbRJ
nmLgAsAik05cKlgmyRNKyX88k+YwPJSbuM5VtdNh79vFYClxpO2FEEnveAFauRtP
9b8aJn/QtuRMLWy4/gXJ8rHihJlpN3EXBnx7J3oM4i3dAkJPRIg6P5CXvivjXRF8
sSshbBpZQZyl1+WUvzNeHH0RSRqpodJ6VHzeaJtBlaMkatcQQzpMLcBPDegxZzhb
X1hXOY9TkKHqizAjcImftWZpN6589qTfiEBlwGN+eWIQS1YcbtBp8xKksReWxTKj
dG6oYl6t5vfD7RZEthNdaCUXw5/ufw2WtFsOxUWaF/e3mYDaDUWcYISg2I4OUPTF
Mbbw7zZsISrWl39YtV748lvU13MiN0i2Z90ES2WTw7+duk5YlWRUg3xyKrQJk7fv
5e0MBGhEOh/1qXAvCBcJ
=eMf6
-----END PGP SIGNATURE-----

--=-SsJjZpiOMEKpZk7Z0iX6--

