Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0IMF27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 01:28:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32825 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0IMF25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 01:28:57 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 12 Sep 2010 23:28:33 -0600
X-Google-Sender-Auth: zZmAw25txSnOHx_AN4twBaA0jbs
Message-ID: <AANLkTik6ntBGd=qVEkN=asARVJs41ww8pR5Wr6Z1n1Lc@mail.gmail.com>
Subject: [git pull] spi and OF fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        spi-devel-general@lists.sourceforge.net,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Feng Tang <feng.tang@intel.com>, Jassi Brar <jassi.brar@samsung.com>,
        Julia Lawall <julia@diku.dk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Michal Simek <monstr@monstr.eu>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a double handfull of SPI and OF (ll_temac, gpiolib, 52xx_uart).
 Should be nothing eyebrow raising here.

g.

The following changes since commit be6200aac985e0a3db56ec636763a32f3e32e7f1:
  Linus Torvalds (1):
        Merge branch 'kvm-updates/2.6.36' of
git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Anton Vorontsov (1):
      gpiolib: Add 'struct gpio_chip' forward declaration for !GPIOLIB case

David Lamparter (1):
      spi: free children in spi_unregister_master, not siblings

Feng Tang (1):
      spi/dw_spi: clean the cs_control code

Jassi Brar (2):
      spi/s3c64xx: Fix compilation warning
      spi/s3c64xx: Fix incorrect reuse of 'val' local variable.

Julia Lawall (1):
      powerpc/5200: mpc52xx_uart.c: Add of_node_put to avoid memory leak

Linus Walleij (2):
      spi/pl022: fix APB pclk power regression on U300
      spi/pl022: move probe call to subsys_initcall()

Mark Brown (5):
      spi/spi_s3c64xx: Make probe more robust against missing board config
      spi/spi_s3c64xx: Staticise non-exported functions
      spi/spi_s3c64xx: Move to subsys_initcall()
      spi/spi_s3c64xx: Increase dead reckoning time in wait_for_xfer()
      spi/spi_s3c64xx: Warn if PIO transfers time out

Michal Simek (1):
      of: Fix missing includes - ll_temac

Yong Wang (1):
      spi/dw_spi: Allow interrupt sharing

 drivers/net/ll_temac_main.c   |    1 +
 drivers/net/ll_temac_mdio.c   |    1 +
 drivers/serial/mpc52xx_uart.c |    1 +
 drivers/spi/amba-pl022.c      |   16 +++++++++-------
 drivers/spi/dw_spi.c          |   24 +++++++++++-------------
 drivers/spi/spi.c             |    9 +++------
 drivers/spi/spi_s3c64xx.c     |   37 +++++++++++++++++++++++++------------
 include/linux/gpio.h          |    1 +
 include/linux/spi/dw_spi.h    |    2 ++
 9 files changed, 54 insertions(+), 38 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
