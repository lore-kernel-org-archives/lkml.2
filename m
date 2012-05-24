Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257Ab2EXUBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:01:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965811Ab2EXUBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:01:09 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 May 2012 14:00:48 -0600
X-Google-Sender-Auth: BtkH4ewirb7rW1kehhI9w6_4Oug
Message-ID: <CACxGe6vc0aWuRuiwBqd-bed45EN3VWB2p9PWYLi_yP5onrtGTw@mail.gmail.com>
Subject: [GIT PULL] spi changes for v3.5 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Description below; please pull.

Thanks,
g.

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/spi-for-linus

for you to fetch changes up to 1e8a52e18cfb381bc9cc1f0b720540364d2a6edd:

  spi: By default setup spi_masters with 1 chipselect and dynamics bus
number (2012-05-19 23:42:08 -0600)

----------------------------------------------------------------
SPI changes for v3.5 merge window

Bug fixes and new features for SPI device drivers.  Also move device
tree support code out of drivers/of and into drivers/spi/spi.c where
it makes more sense.

----------------------------------------------------------------
Arnd Bergmann (1):
      spi/topcliff: use correct __devexit_p annotation

Axel Lin (1):
      spi: use module_pci_driver

Barry Song (1):
      SPI: PRIMA2: use the newest APIs of PINCTRL to fix compiling errors

Benoit Cousson (1):
      spi/omap: Remove bus_num usage for instance index

Felipe Balbi (2):
      spi: omap2-mcspi: make it behave as a module
      spi: omap2-mcspi: convert to module_platform_driver

Grant Likely (4):
      Merge branch 'spi' of git://gitorious.org/linus-tree/linus-tree
into spi/next
      spi/devicetree: Move devicetree support code into spi directory
      Merge tag 'v3.4-rc6' into spi/next
      spi: By default setup spi_masters with 1 chipselect and dynamics
bus number

Hannu Heikkinen (1):
      spi/ep93xx: clean probe/remove routines

Herton Ronaldo Krzesinski (1):
      spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control

Shimoda, Yoshihiro (1):
      spi/rspi: add dmaengine support

Shubhrajyoti D (5):
      OMAP : SPI : use devm_* functions
      spi: omap2-mcspi: add support for pm_runtime autosuspend
      spi/omap2-mcspi: Trivial optimisation
      spi: Dont call prepare/unprepare transfer if not populated
      spi/omap2-mcspi: convert to the pump message infrastructure

Steven King (1):
      spi: refactor spi-coldfire-qspi to use SPI queue framework.

 drivers/of/Kconfig              |    6 -
 drivers/of/Makefile             |    1 -
 drivers/of/of_spi.c             |   99 -----------
 drivers/spi/spi-ath79.c         |    3 -
 drivers/spi/spi-coldfire-qspi.c |  255 ++++++++++++--------------
 drivers/spi/spi-dw-pci.c        |   13 +-
 drivers/spi/spi-ep93xx.c        |   37 ++--
 drivers/spi/spi-fsl-espi.c      |    1 -
 drivers/spi/spi-fsl-lib.c       |    2 +-
 drivers/spi/spi-fsl-spi.c       |    2 +-
 drivers/spi/spi-lm70llp.c       |    3 -
 drivers/spi/spi-mpc52xx.c       |    3 -
 drivers/spi/spi-omap2-mcspi.c   |  373 +++++++++++++++++----------------------
 drivers/spi/spi-ppc4xx.c        |    4 -
 drivers/spi/spi-pxa2xx-pci.c    |   12 +-
 drivers/spi/spi-rspi.c          |  320 ++++++++++++++++++++++++++++++++-
 drivers/spi/spi-sirf.c          |   20 +--
 drivers/spi/spi-topcliff-pch.c  |    3 +-
 drivers/spi/spi.c               |   98 +++++++++-
 include/linux/of_spi.h          |   23 ---
 include/linux/spi/rspi.h        |   31 ++++
 21 files changed, 736 insertions(+), 573 deletions(-)
 delete mode 100644 drivers/of/of_spi.c
 delete mode 100644 include/linux/of_spi.h
 create mode 100644 include/linux/spi/rspi.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
