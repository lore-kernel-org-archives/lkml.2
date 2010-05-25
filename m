Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0EYHHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:07:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36023 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab0EYHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:07:01 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 May 2010 01:06:40 -0600
X-Google-Sender-Auth: fHGTviSeljAahO3Net77BEAD33o
Message-ID: <AANLkTilXIID_fppCc0UOczdxlr3Tas8Xw0pYcEMx5PJl@mail.gmail.com>
Subject: [git pull] spi driver changes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the SPI device driver changes for .35, plus a bug fix to the
xilinx driver related to the OF changes.

Thanks,
g.

The following changes since commit 7e125f7b9cbfce4101191b8076d606c517a73066:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Anatolij Gustschin (2):
      powerpc/mpc5121: move PSC FIFO memory init to platform code
      spi/mpc5121: Add SPI master driver for MPC5121 PSC

Grant Likely (2):
      Merge remote branch 'origin' into secretlab/next-spi
      spi/xilinx: Fix compile error

Grzegorz Sygieda (1):
      spi/pl022: fix stop queue procedure

Joakim Tjernlund (3):
      spi/spi_mpc8xxx: fix potential memory corruption.
      spi/spi_mpc8xxx: Fix QE mode Litte Endian
      spi/spi_mpc8xxx: Do not use map_tx_dma to unmap rx_dma

Linus Walleij (2):
      spi/pl022: fix up differences between ARM and ST versions
      spi/pl022: add support for the PL023 derivate

Mika Westerberg (1):
      spi/ep93xx: implemented driver for Cirrus EP93xx SPI controller

Prarit Bhargava (1):
      Documentation/spi/* compile warning fix

Roman Tereshonkov (2):
      spi/omap2_mcspi: change default DMA_MIN_BYTES value to 160
      spi/omap2_mcspi: add turbo mode support

Scott Ellis (1):
      spi/omap2_mcspi: Check params before dereference or use

Thomas Koeller (1):
      spi/davinci: Fix clock prescale factor computation

hartleys (1):
      spi: move bitbang txrx utility functions to private header

 Documentation/spi/ep93xx_spi                   |   95 +++
 Documentation/spi/spidev_fdx.c                 |    4 +-
 arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |   27 +
 arch/powerpc/include/asm/mpc52xx_psc.h         |    1 +
 arch/powerpc/platforms/512x/mpc512x_shared.c   |   78 ++
 drivers/serial/mpc52xx_uart.c                  |   69 --
 drivers/spi/Kconfig                            |   17 +
 drivers/spi/Makefile                           |    2 +
 drivers/spi/amba-pl022.c                       |  250 +++++--
 drivers/spi/davinci_spi.c                      |   12 +-
 drivers/spi/ep93xx_spi.c                       |  938 ++++++++++++++++++++++++
 drivers/spi/mpc512x_psc_spi.c                  |  576 +++++++++++++++
 drivers/spi/omap2_mcspi.c                      |  153 +++-
 drivers/spi/spi_bitbang_txrx.h                 |   93 +++
 drivers/spi/spi_butterfly.c                    |    3 +-
 drivers/spi/spi_gpio.c                         |    3 +-
 drivers/spi/spi_lm70llp.c                      |    3 +-
 drivers/spi/spi_mpc8xxx.c                      |  110 ++-
 drivers/spi/spi_s3c24xx_gpio.c                 |    3 +-
 drivers/spi/spi_sh_sci.c                       |    3 +-
 drivers/spi/xilinx_spi_of.c                    |    8 +-
 include/linux/amba/pl022.h                     |   32 +-
 include/linux/spi/spi_bitbang.h                |  101 ---
 23 files changed, 2262 insertions(+), 319 deletions(-)
 create mode 100644 Documentation/spi/ep93xx_spi
 create mode 100644 arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h
 create mode 100644 drivers/spi/ep93xx_spi.c
 create mode 100644 drivers/spi/mpc512x_psc_spi.c
 create mode 100644 drivers/spi/spi_bitbang_txrx.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
