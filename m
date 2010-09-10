Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0IJXTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:19:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35247 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0IJXTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DydxPc4d/UDY1opkskMaiJcIUQZWGzjtAnFty2MpycPpw4c4ndhKz2RsBMd6AZtccz
         RuFGheSb8IfHweVGhEw2G3N8ulnrzst57m3lQauYd0EcwgKfMo37l9tWxNK1my+3qfgJ
         z62wyPWStwtIdKfBYlh8S2KN4PI1nd8NMF2C8=
From: wellsk40@gmail.com
To: linus.walleij@stericsson.com, spi-devel-general@lists.sourceforge.net
Cc: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org,
        grant.likely@secretlab.ca, Lukasz.Baj@tieto.com,
        quentinyang05@gmail.com
Subject: amba_pl022 spi->mode fix/cleanup patches
Date: Fri, 10 Sep 2010 09:19:34 -0700
Message-Id: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series updates drivers and platforms that depend on the
amba_pl022 driver and use the pl022_config_chip structure for
setting up the SPI mode and data transfer width.

The SPI configuration (CPOL/CPHA mode, bit send order, data bits per
word, and loopback mode) were previously setup as part of board
specific data in the pl022_config_chip structure. This has been
changed to now use the .mode field in spi_board_info structure (or
drivers that setup the mode). The SPI transfer's data width is now
configured from spi->bits_per_word.

The SPI driver changes have been previously submitted to the SPI ML.
This patch series need to be layered on that patch series.

These changes add or fix the .mode field in the plats/boards that use the
driver (u300, ux500, lpc32xx). The patches also move the data width
from the board specific area to the driver for mfd/ab8500. As the
fields in the pl022_config_chip structure are no longer needed, they
are removed in the last patch.

These changes have been tested on the phy3250 platform (lpc32xx). I
was able to test the ab8500 driver to some degree, but I only have a
standard pl022. I am unable to test u300 and ux500 changes, but the
u300 changes compiled fine.

[PATCH 1/5] mfd/ab8500: Setup SPI transfer for 24 bits
[PATCH 2/5] ARM: LPC32XX: Add missing SPI mode and remove unused fields
[PATCH 3/5] ARM: U300: spi->mode and spi_bits_per_words updates
[PATCH 4/5] ARM: Ux500: Change SPI mode and remove unused fields
[PATCH 5/5] spi: amba_pl022: Remove unused fields from pl022_config_chip
