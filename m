Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1GVQEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:04:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50129 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1GVQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:04:52 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 22 Jul 2011 10:04:32 -0600
X-Google-Sender-Auth: M6XY29yKuxitpDA49RFRHeqB_Jg
Message-ID: <CACxGe6spaYdCAJC3HLSxSkYeFX+-NOgRh186A-XRQcn+CaUpoA@mail.gmail.com>
Subject: [GIT PULL] SPI changes for v3.1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another branch that looks a lot bigger than it is due to driver file
renames.  There are some arch/arm/ changes in here that are being
merged via spi/next because the spi driver changes depend on them.
Also, the ep93xx-dma changes will also appear in the ep93xx pull
request.  We put those changes into a separate branch so that it could
be pulled into both spi/next and the ep93xx branch.  If you prefer, I
can wait for that branch to get merged and resend this pull request so
that it doesn't show those changes.

g.

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 spi/next

Anatolij Gustschin (1):
      spi/bitbang: initialize bits_per_word as specified by spi message

Grant Likely (5):
      spi: reorganize drivers
      Merge remote-tracking branch 'origin' into spi/merge
      Merge branch 'ep93xx-dma' into spi/next
      gpio/tegra: Move Tegra gpio driver to drivers/gpio
      Merge branch 'spi/merge' into spi/next

Holger Brunck (1):
      spi/fsl_spi: fix CPM spi driver

Joe Perches (1):
      spi: Convert uses of struct resource * to resource_size(ptr)

Linus Walleij (2):
      spi/pl022: initialize burstsize from FIFO trigger level
      spi/pl022: strengthen FIFO watermark level checks

Liu, ShuoX (1):
      spi/dw: Add spi number into spi irq desc

Mika Westerberg (5):
      dmaengine: add ep93xx DMA support
      ep93xx: add dmaengine platform code
      ASoC: ep93xx: convert to use the DMA engine API
      ep93xx: remove the old M2P DMA code
      spi/ep93xx: add DMA support

Mike Frysinger (3):
      spi/bfin_spi: use structs for accessing hardware regs
      spi/bfin_spi: constify pin array
      spi/bfin_spi: uninline fat queue funcs

Peter Korsgaard (5):
      mach-jive: convert to spi_gpio
      mach-qt2410: convert to spi_gpio
      mach-gta2: remove unused spi-gpio.h include
      spi: remove obsolete spi-s3c24xx-gpio driver
      mach-s3c2410: remove unused spi-gpio.h file

Rabin Vincent (1):
      spi/pl022: support runtime PM

Shawn Guo (7):
      spi/imx: do not make copy of spi_imx_devtype_data
      spi/imx: use mx21 to name SPI_IMX_VER_0_0 function and macro
      spi/imx: do not use spi_imx2_3 to name SPI_IMX_VER_2_3 function and macro
      spi/imx: merge type SPI_IMX_VER_0_7 into SPI_IMX_VER_0_4
      spi/imx: use soc name in spi device type naming scheme
      spi/imx: copy gpio number passed by platform data into driver private data
      spi/imx: add device tree probe support

Stefan Schmidt (1):
      spi/pxa2xx: Remove unavailable ssp_type from documentation

Stephen Warren (1):
      spi/tegra: Use engineering names in DT compatible property

Tomoya MORINAGA (3):
      spi/topcliff_pch: support new device ML7213 IOH
      spi/topcliff_pch: DMA support
      spi/topcliff-pch: Support new device ML7223 IOH

 .../devicetree/bindings/spi/fsl-imx-cspi.txt       |   22 +
 .../devicetree/bindings/spi/spi_nvidia.txt         |    5 +
 Documentation/spi/ep93xx_spi                       |   10 +
 Documentation/spi/pxa2xx                           |    5 -
 arch/arm/mach-ep93xx/Makefile                      |    4 +-
 arch/arm/mach-ep93xx/core.c                        |    6 +-
 arch/arm/mach-ep93xx/dma-m2p.c                     |  411 ------
 arch/arm/mach-ep93xx/dma.c                         |  108 ++
 arch/arm/mach-ep93xx/include/mach/dma.h            |  190 +--
 arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h     |    2 +
 arch/arm/mach-imx/clock-imx25.c                    |    7 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c                |   11 +-
 arch/arm/mach-s3c2410/include/mach/spi-gpio.h      |   28 -
 arch/arm/mach-s3c2410/mach-qt2410.c                |   34 +-
 arch/arm/mach-s3c2412/mach-jive.c                  |   41 +-
 arch/arm/mach-s3c2440/mach-gta02.c                 |    1 -
 arch/arm/plat-mxc/devices/platform-spi_imx.c       |   12 +-
 drivers/dma/Kconfig                                |    7 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/ep93xx_dma.c                           | 1355 ++++++++++++++++++++
 drivers/spi/Kconfig                                |   48 +-
 drivers/spi/Makefile                               |  111 +-
 drivers/spi/atmel_spi.h                            |  167 ---
 drivers/spi/{spi_altera.c => spi-altera.c}         |    0
 drivers/spi/{ath79_spi.c => spi-ath79.c}           |    2 +-
 drivers/spi/{atmel_spi.c => spi-atmel.c}           |  155 +++-
 drivers/spi/{au1550_spi.c => spi-au1550.c}         |    2 +-
 drivers/spi/{spi_bfin_sport.c => spi-bfin-sport.c} |    0
 drivers/spi/{spi_bfin5xx.c => spi-bfin5xx.c}       |  218 ++--
 .../spi/{spi_bitbang_txrx.h => spi-bitbang-txrx.h} |    0
 drivers/spi/{spi_bitbang.c => spi-bitbang.c}       |    8 +-
 drivers/spi/{spi_butterfly.c => spi-butterfly.c}   |    4 +-
 .../spi/{coldfire_qspi.c => spi-coldfire-qspi.c}   |    0
 drivers/spi/{davinci_spi.c => spi-davinci.c}       |    0
 drivers/spi/{dw_spi_mid.c => spi-dw-mid.c}         |    4 +-
 drivers/spi/{dw_spi_mmio.c => spi-dw-mmio.c}       |    4 +-
 drivers/spi/{dw_spi_pci.c => spi-dw-pci.c}         |    4 +-
 drivers/spi/{dw_spi.c => spi-dw.c}                 |    8 +-
 drivers/spi/{dw_spi.h => spi-dw.h}                 |    1 +
 drivers/spi/{ep93xx_spi.c => spi-ep93xx.c}         |  303 +++++-
 drivers/spi/{spi_fsl_espi.c => spi-fsl-espi.c}     |    2 +-
 drivers/spi/{spi_fsl_lib.c => spi-fsl-lib.c}       |    2 +-
 drivers/spi/{spi_fsl_lib.h => spi-fsl-lib.h}       |    0
 drivers/spi/{spi_fsl_spi.c => spi-fsl-spi.c}       |   30 +-
 drivers/spi/{spi_gpio.c => spi-gpio.c}             |    6 +-
 drivers/spi/{spi_imx.c => spi-imx.c}               |  466 ++++----
 drivers/spi/{spi_lm70llp.c => spi-lm70llp.c}       |    4 +-
 .../spi/{mpc512x_psc_spi.c => spi-mpc512x-psc.c}   |    0
 .../spi/{mpc52xx_psc_spi.c => spi-mpc52xx-psc.c}   |    0
 drivers/spi/{mpc52xx_spi.c => spi-mpc52xx.c}       |    0
 drivers/spi/{spi_nuc900.c => spi-nuc900.c}         |    5 +-
 drivers/spi/{spi_oc_tiny.c => spi-oc-tiny.c}       |    0
 drivers/spi/{omap_spi_100k.c => spi-omap-100k.c}   |    0
 drivers/spi/{omap_uwire.c => spi-omap-uwire.c}     |    2 +-
 drivers/spi/{omap2_mcspi.c => spi-omap2-mcspi.c}   |   10 +-
 drivers/spi/{orion_spi.c => spi-orion.c}           |    8 +-
 drivers/spi/{amba-pl022.c => spi-pl022.c}          |  111 ++-
 drivers/spi/{spi_ppc4xx.c => spi-ppc4xx.c}         |    2 +-
 drivers/spi/{pxa2xx_spi_pci.c => spi-pxa2xx-pci.c} |    0
 drivers/spi/{pxa2xx_spi.c => spi-pxa2xx.c}         |    0
 .../spi/{spi_s3c24xx_fiq.S => spi-s3c24xx-fiq.S}   |    2 +-
 .../spi/{spi_s3c24xx_fiq.h => spi-s3c24xx-fiq.h}   |    0
 drivers/spi/{spi_s3c24xx.c => spi-s3c24xx.c}       |    5 +-
 drivers/spi/{spi_s3c64xx.c => spi-s3c64xx.c}       |    3 +-
 drivers/spi/{spi_sh_msiof.c => spi-sh-msiof.c}     |    0
 drivers/spi/{spi_sh_sci.c => spi-sh-sci.c}         |    2 +-
 drivers/spi/{spi_sh.c => spi-sh.c}                 |    0
 drivers/spi/{spi_stmp.c => spi-stmp.c}             |    0
 drivers/spi/{spi_tegra.c => spi-tegra.c}           |   20 +-
 drivers/spi/{ti-ssp-spi.c => spi-ti-ssp.c}         |    0
 drivers/spi/{tle62x0.c => spi-tle62x0.c}           |    2 +-
 .../spi/{spi_topcliff_pch.c => spi-topcliff-pch.c} | 1158 ++++++++++++------
 drivers/spi/{spi_txx9.c => spi-txx9.c}             |    2 +-
 drivers/spi/{xilinx_spi.c => spi-xilinx.c}         |    0
 drivers/spi/spi.c                                  |    2 +-
 drivers/spi/spi_s3c24xx_gpio.c                     |  201 ---
 drivers/spi/spidev.c                               |    2 +-
 sound/soc/ep93xx/ep93xx-ac97.c                     |    4 +-
 sound/soc/ep93xx/ep93xx-i2s.c                      |    4 +-
 sound/soc/ep93xx/ep93xx-pcm.c                      |  137 ++-
 80 files changed, 3494 insertions(+), 1997 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi_nvidia.txt
 delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
 create mode 100644 arch/arm/mach-ep93xx/dma.c
 delete mode 100644 arch/arm/mach-s3c2410/include/mach/spi-gpio.h
 create mode 100644 drivers/dma/ep93xx_dma.c
 delete mode 100644 drivers/spi/atmel_spi.h
 rename drivers/spi/{spi_altera.c => spi-altera.c} (100%)
 rename drivers/spi/{ath79_spi.c => spi-ath79.c} (99%)
 rename drivers/spi/{atmel_spi.c => spi-atmel.c} (85%)
 rename drivers/spi/{au1550_spi.c => spi-au1550.c} (99%)
 rename drivers/spi/{spi_bfin_sport.c => spi-bfin-sport.c} (100%)
 rename drivers/spi/{spi_bfin5xx.c => spi-bfin5xx.c} (88%)
 rename drivers/spi/{spi_bitbang_txrx.h => spi-bitbang-txrx.h} (100%)
 rename drivers/spi/{spi_bitbang.c => spi-bitbang.c} (98%)
 rename drivers/spi/{spi_butterfly.c => spi-butterfly.c} (99%)
 rename drivers/spi/{coldfire_qspi.c => spi-coldfire-qspi.c} (100%)
 rename drivers/spi/{davinci_spi.c => spi-davinci.c} (100%)
 rename drivers/spi/{dw_spi_mid.c => spi-dw-mid.c} (98%)
 rename drivers/spi/{dw_spi_mmio.c => spi-dw-mmio.c} (97%)
 rename drivers/spi/{dw_spi_pci.c => spi-dw-pci.c} (98%)
 rename drivers/spi/{dw_spi.c => spi-dw.c} (99%)
 rename drivers/spi/{dw_spi.h => spi-dw.h} (99%)
 rename drivers/spi/{ep93xx_spi.c => spi-ep93xx.c} (77%)
 rename drivers/spi/{spi_fsl_espi.c => spi-fsl-espi.c} (99%)
 rename drivers/spi/{spi_fsl_lib.c => spi-fsl-lib.c} (99%)
 rename drivers/spi/{spi_fsl_lib.h => spi-fsl-lib.h} (100%)
 rename drivers/spi/{spi_fsl_spi.c => spi-fsl-spi.c} (98%)
 rename drivers/spi/{spi_gpio.c => spi-gpio.c} (99%)
 rename drivers/spi/{spi_imx.c => spi-imx.c} (66%)
 rename drivers/spi/{spi_lm70llp.c => spi-lm70llp.c} (98%)
 rename drivers/spi/{mpc512x_psc_spi.c => spi-mpc512x-psc.c} (100%)
 rename drivers/spi/{mpc52xx_psc_spi.c => spi-mpc52xx-psc.c} (100%)
 rename drivers/spi/{mpc52xx_spi.c => spi-mpc52xx.c} (100%)
 rename drivers/spi/{spi_nuc900.c => spi-nuc900.c} (99%)
 rename drivers/spi/{spi_oc_tiny.c => spi-oc-tiny.c} (100%)
 rename drivers/spi/{omap_spi_100k.c => spi-omap-100k.c} (100%)
 rename drivers/spi/{omap_uwire.c => spi-omap-uwire.c} (99%)
 rename drivers/spi/{omap2_mcspi.c => spi-omap2-mcspi.c} (99%)
 rename drivers/spi/{orion_spi.c => spi-orion.c} (98%)
 rename drivers/spi/{amba-pl022.c => spi-pl022.c} (96%)
 rename drivers/spi/{spi_ppc4xx.c => spi-ppc4xx.c} (99%)
 rename drivers/spi/{pxa2xx_spi_pci.c => spi-pxa2xx-pci.c} (100%)
 rename drivers/spi/{pxa2xx_spi.c => spi-pxa2xx.c} (100%)
 rename drivers/spi/{spi_s3c24xx_fiq.S => spi-s3c24xx-fiq.S} (99%)
 rename drivers/spi/{spi_s3c24xx_fiq.h => spi-s3c24xx-fiq.h} (100%)
 rename drivers/spi/{spi_s3c24xx.c => spi-s3c24xx.c} (99%)
 rename drivers/spi/{spi_s3c64xx.c => spi-s3c64xx.c} (99%)
 rename drivers/spi/{spi_sh_msiof.c => spi-sh-msiof.c} (100%)
 rename drivers/spi/{spi_sh_sci.c => spi-sh-sci.c} (99%)
 rename drivers/spi/{spi_sh.c => spi-sh.c} (100%)
 rename drivers/spi/{spi_stmp.c => spi-stmp.c} (100%)
 rename drivers/spi/{spi_tegra.c => spi-tegra.c} (96%)
 rename drivers/spi/{ti-ssp-spi.c => spi-ti-ssp.c} (100%)
 rename drivers/spi/{tle62x0.c => spi-tle62x0.c} (99%)
 rename drivers/spi/{spi_topcliff_pch.c => spi-topcliff-pch.c} (53%)
 rename drivers/spi/{spi_txx9.c => spi-txx9.c} (99%)
 rename drivers/spi/{xilinx_spi.c => spi-xilinx.c} (100%)
 delete mode 100644 drivers/spi/spi_s3c24xx_gpio.c


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
