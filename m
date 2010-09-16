Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0IPDOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 23:14:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60996 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0IPDOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 23:14:40 -0400
Date: Wed, 15 Sep 2010 21:14:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: wellsk40@gmail.com
Cc: linus.walleij@stericsson.com, spi-devel-general@lists.sourceforge.net,
        sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org,
        Lukasz.Baj@tieto.com, quentinyang05@gmail.com
Subject: Re: amba_pl022 spi->mode fix/cleanup patches
Message-ID: <20100916031436.GA7542@angua.secretlab.ca>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 09:19:34AM -0700, wellsk40@gmail.com wrote:
> This patch series updates drivers and platforms that depend on the
> amba_pl022 driver and use the pl022_config_chip structure for
> setting up the SPI mode and data transfer width.
> 
> The SPI configuration (CPOL/CPHA mode, bit send order, data bits per
> word, and loopback mode) were previously setup as part of board
> specific data in the pl022_config_chip structure. This has been
> changed to now use the .mode field in spi_board_info structure (or
> drivers that setup the mode). The SPI transfer's data width is now
> configured from spi->bits_per_word.
> 
> The SPI driver changes have been previously submitted to the SPI ML.
> This patch series need to be layered on that patch series.
> 
> These changes add or fix the .mode field in the plats/boards that use the
> driver (u300, ux500, lpc32xx). The patches also move the data width
> from the board specific area to the driver for mfd/ab8500. As the
> fields in the pl022_config_chip structure are no longer needed, they
> are removed in the last patch.
> 
> These changes have been tested on the phy3250 platform (lpc32xx). I
> was able to test the ab8500 driver to some degree, but I only have a
> standard pl022. I am unable to test u300 and ux500 changes, but the
> u300 changes compiled fine.
> 
> [PATCH 1/5] mfd/ab8500: Setup SPI transfer for 24 bits
> [PATCH 2/5] ARM: LPC32XX: Add missing SPI mode and remove unused fields
> [PATCH 3/5] ARM: U300: spi->mode and spi_bits_per_words updates
> [PATCH 4/5] ARM: Ux500: Change SPI mode and remove unused fields
> [PATCH 5/5] spi: amba_pl022: Remove unused fields from pl022_config_chip

There are ordering issues with these patches and the patch they depend
on.  Basically, as-is it is not bisectable.  The above platforms stop
working after the SPI driver changes are applied, but before these
patches are.  You'll need to update the mode field for all the users
in or before the SPI driver changes patch to preserve bisectability.
Then you can have subsequent cleanup patches....

Or just squash all the patches into the SPI driver patch.  I'd be
okay with that in this case because the board changes are well
contained and easy to understand.

g.

