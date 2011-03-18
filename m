Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1CRQS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:18:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38439 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1CRQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:18:52 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 Mar 2011 10:18:31 -0600
X-Google-Sender-Auth: FmDnt5cuidelV0Oh3CTJtL-NNew
Message-ID: <AANLkTikPiwRgm0DX9CzJacMxsfhPjTU-ksZjw9m2dkEO@mail.gmail.com>
Subject: [git pull] spi and gpio patches for 2.6.39
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Bernhard Walle <walle@corscience.de>, Dirk Eibach <eibach@gdsys.de>,
        Esben Haabendal <eha@doredevelopment.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Michael Williamson <michael.williamson@criticallink.com>,
        Peter Korsgaard <jacmet@gmail.com>, Thomas Chou <thomas@wytron.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the SPI and GPIO changes I've got queued up for 2.6.39

g.

The following changes since commit 08351fc6a75731226e1112fc7254542bd3a2912e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
(2011-03-17 19:34:12 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/next

Axel Lin (2):
      gpio: add MODULE_DEVICE_TABLE to pch_gpio and ml_ioh_gpio
      gpio: Use __devexit at necessary places

Bernhard Walle (1):
      spi/spidev: Add 32 bit compat ioctl()

Bob Liu (1):
      spi/bfin_spi: support for multiples of 8bits with hardware CS

Dirk Eibach (1):
      gpio/pca953x: Fix wrong pointer type

Esben Haabendal (1):
      of_mmc_spi: add card detect irq support

Geert Uytterhoeven (1):
      spi/rtc-{ds1390,ds3234,m41t94}: Use spi_get_drvdata() for SPI devices

Grant Likely (4):
      Merge commit 'v2.6.38-rc4' into spi/next
      Merge branch 'devicetree/next' into spi/next
      Merge commit 'v2.6.38-rc8' into spi/next
      Merge remote-tracking branch 'origin' into spi/next

Guennadi Liakhovetski (2):
      spi/spi_sh_msiof: cosmetic clean-up
      spi/spi_sh_msiof: consolidate data in 8-bit mode into 32-bit words

Hannu Heikkinen (1):
      spi/omap_mcspi: Off-by-one error in finding the right divisor

Jiri Slaby (1):
      spi/dw_spi: Fix missing header

Linus Walleij (4):
      spi/pl022: use dmaengine helper macros
      spi/pl022: disable core voltage when idle
      spi/pl022: minor kerneldoc updates
      spi/pl022: rid dangling labels

Michael Jones (1):
      spi/omap_mcspi: catch xfers of non-multiple SPI word size

Michael Williamson (2):
      spi/davinci: Use correct length parameter to dma_map_single calls
      spi/davinci: Support DMA transfers larger than 65535 words

Nikanth Karthikesan (1):
      gpio/cs5535-gpio: Fix section mismatch

Peter Korsgaard (1):
      gpio/mcp23s08: support mcp23s17 variant

Sascha Hauer (2):
      spi/bitbang: check for setup_transfer during initialization
      spi/imx: select master mode for all channels

Sonic Zhang (1):
      spi/bfin_spi: return immediately after skipping to next transfer

Thomas Chou (2):
      spi: add OpenCores tiny SPI driver
      spi: New driver for Altera SPI

Thomas Gleixner (6):
      gpio/sx150x: Do not access I2C from mask/unmask functions
      gpio; Make Intel chipset gpio drivers depend on x86
      gpio/langwell: Fix broken irq_eoi change.
      gpio/langwell: Convert irq name space
      gpio/langwell: Simplify demux loop
      gpio/langwell: Clear edge bit before handling

Virupax Sadashivpetimath (1):
      spi/pl022: remove dangling status check

Yoshihiro Shimoda (1):
      spi: add support for SuperH SPI

 .../devicetree/bindings/mmc/mmc-spi-slot.txt       |    9 +-
 .../devicetree/bindings/spi/spi_altera.txt         |    4 +
 .../devicetree/bindings/spi/spi_oc_tiny.txt        |   12 +
 drivers/gpio/74x164.c                              |    2 +-
 drivers/gpio/Kconfig                               |   12 +-
 drivers/gpio/cs5535-gpio.c                         |    6 +-
 drivers/gpio/langwell_gpio.c                       |   43 +-
 drivers/gpio/mc33880.c                             |    2 +-
 drivers/gpio/mcp23s08.c                            |  191 +++++--
 drivers/gpio/pca953x.c                             |   13 +-
 drivers/gpio/sx150x.c                              |   54 ++-
 drivers/mmc/host/of_mmc_spi.c                      |   26 +-
 drivers/rtc/rtc-ds1390.c                           |    2 +-
 drivers/rtc/rtc-ds3234.c                           |    2 +-
 drivers/rtc/rtc-m41t94.c                           |    2 +-
 drivers/spi/Kconfig                                |   19 +
 drivers/spi/Makefile                               |    3 +
 drivers/spi/amba-pl022.c                           |   73 ++--
 drivers/spi/davinci_spi.c                          |   43 ++-
 drivers/spi/omap2_mcspi.c                          |   38 +-
 drivers/spi/spi_altera.c                           |  339 ++++++++++++
 drivers/spi/spi_bfin5xx.c                          |  104 +++--
 drivers/spi/spi_bitbang.c                          |   13 +-
 drivers/spi/spi_imx.c                              |   12 +-
 drivers/spi/spi_oc_tiny.c                          |  425 +++++++++++++++
 drivers/spi/spi_sh.c                               |  543 ++++++++++++++++++++
 drivers/spi/spi_sh_msiof.c                         |  127 ++++--
 drivers/spi/spidev.c                               |   12 +
 include/linux/spi/dw_spi.h                         |    1 +
 include/linux/spi/mcp23s08.h                       |   15 +-
 include/linux/spi/spi_oc_tiny.h                    |   20 +
 31 files changed, 1911 insertions(+), 256 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi_altera.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi_oc_tiny.txt
 create mode 100644 drivers/spi/spi_altera.c
 create mode 100644 drivers/spi/spi_oc_tiny.c
 create mode 100644 drivers/spi/spi_sh.c
 create mode 100644 include/linux/spi/spi_oc_tiny.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
