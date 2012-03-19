Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162270Ab2CSRAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:00:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50779 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964905Ab2CSRAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:00:37 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Mar 2012 17:00:15 +0000
X-Google-Sender-Auth: 9nzGFCim_yAe87jt8F7Bx2L-KAA
Message-ID: <CACxGe6u=B-pvdaBMxH3gvCOTgw0De055NSUnNxAYGncPq3bc=w@mail.gmail.com>
Subject: [GIT PULL] spi drivers and bug fixes for v3.4
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Normal driver stuff here.  None of it is exciting or high priority.
Please pull.

Cheers,
g.

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/spi-for-linus

for you to fetch changes up to 87bf5ab82884c829366914aaa813cc8b07b9fe58:

  spi/fsl-espi: Make sure pm is within 2..32 (2012-03-15 15:14:24 -0600)

----------------------------------------------------------------
SPI changes for v3.4.

Mostly a bunch of new drivers and driver bug fixes; but this also
includes a few patches that create a core message queue infrastructure
for the spi subsystem instead of making each driver open code it.

----------------------------------------------------------------
Axel Lin (2):
      spi: Convert to DEFINE_PCI_DEVICE_TABLE
      spi/imx: simplify error handling to free gpios

Benoit Cousson (1):
      spi/omap: Add DT support to McSPI driver

Chris Blair (1):
      spi/pl022: Add high priority message pump support

Dan Carpenter (1):
      spi: release lock on error path in spi_pump_messages()

Danny Kukawka (1):
      spi-topcliff-pch: fix -Wuninitialized warning

Florian Fainelli (1):
      spi: add Broadcom BCM63xx SPI controller driver

Grant Likely (1):
      Merge branch 'spi/s3c64xx' of git://git.kernel.org/.../broonie/misc

Guennadi Liakhovetski (1):
      spi: remove redundant variable assignment

Kuninori Morimoto (5):
      spi: Add SuperH HSPI prototype driver
      spi: s3c64xx: remove unnecessary callback msg->complete
      spi: sh-hspi: convert to using core message queue
      spi: sh-hspi: control spi clock more correctly
      spi: sh-hspi: modify write/read method

Kyoungil Kim (1):
      spi: Compatibility with direction which is used in samsung DMA operation

Linus Walleij (1):
      spi: create a message queueing infrastructure

Mark Brown (6):
      spi/s3c64xx: Log error interrupts
      spi/s3c64xx: Convert to dev_pm_ops
      spi/s3c64xx: Implement runtime PM support
      spi/s3c64xx: Convert to using core message queue
      spi: Mark spi_register_board_info() __devinit
      spi: s3c64xx: Fix build

Sebastian Andrzej Siewior (2):
      spi/fsl-espi: make the clock computation easier to read
      spi/fsl-espi: Make sure pm is within 2..32

Shimoda, Yoshihiro (2):
      spi/spi-sh: add IORESOURCE_MEM_TYPE_MASK decoding for access size
      spi: add support for Renesas RSPI

Shubhrajyoti D (1):
      spi: Trivial warning fix

Tobias Klauser (1):
      spi/nuc900: Remove unnecessary memset of struct nuc900_spi

Tomoya MORINAGA (4):
      spi-topcliff-pch: Modify pci-bus number dynamically to get DMA device info
      spi-topcliff-pch: Fix issue for transmitting over 4KByte
      spi-topcliff-pch: supports a spi mode setup and bit order setup
by IO control
      spi-topcliff-pch: add recovery processing in case wait-event timeout

Uwe Kleine-König (2):
      spi/doc: spi_master_put must be followed up by kfree
      spi: controller drivers don't need to depend on SPI_MASTER explicitly

Zhiwu Song (1):
      SPI: add CSR SiRFprimaII SPI controller driver

 Documentation/devicetree/bindings/spi/omap-spi.txt |   20 +
 Documentation/spi/spi-summary                      |   58 ++-
 drivers/spi/Kconfig                                |   36 +-
 drivers/spi/Makefile                               |    4 +
 drivers/spi/spi-bcm63xx.c                          |  486 ++++++++++++++
 drivers/spi/spi-dw-pci.c                           |    2 +-
 drivers/spi/spi-fsl-espi.c                         |   14 +-
 drivers/spi/spi-imx.c                              |   11 +-
 drivers/spi/spi-nuc900.c                           |    2 -
 drivers/spi/spi-omap2-mcspi.c                      |   56 ++-
 drivers/spi/spi-pl022.c                            |  286 ++-------
 drivers/spi/spi-pxa2xx-pci.c                       |    2 +-
 drivers/spi/spi-rspi.c                             |  521 +++++++++++++++
 drivers/spi/spi-s3c64xx.c                          |  232 ++++----
 drivers/spi/spi-sh-hspi.c                          |  331 ++++++++++
 drivers/spi/spi-sh.c                               |   25 +-
 drivers/spi/spi-sirf.c                             |  687 ++++++++++++++++++++
 drivers/spi/spi-topcliff-pch.c                     |  113 +++-
 drivers/spi/spi.c                                  |  347 ++++++++++-
 include/linux/amba/pl022.h                         |    3 +
 include/linux/spi/sh_hspi.h                        |   23 +
 include/linux/spi/spi.h                            |   53 ++-
 22 files changed, 2890 insertions(+), 422 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/omap-spi.txt
 create mode 100644 drivers/spi/spi-bcm63xx.c
 create mode 100644 drivers/spi/spi-rspi.c
 create mode 100644 drivers/spi/spi-sh-hspi.c
 create mode 100644 drivers/spi/spi-sirf.c
 create mode 100644 include/linux/spi/sh_hspi.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
