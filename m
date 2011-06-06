Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1FFOjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:39:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59418 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFOjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <201106061100.38249.arnd@arndb.de>
References: <20110605071725.26517.11573.stgit@ponder> <201106061100.38249.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 08:39:04 -0600
X-Google-Sender-Auth: fJfUqrfNnflAU7jIFF4gIQuS8TY
Message-ID: <BANLkTi=XoD8RiiEihB5bC1Zogxo+J7o3Qg@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pcmcia@lists.infradead.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>, Michael Buesch <mb@bu3sch.de>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Florian Fainelli <florian@openwrt.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 3:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 05 June 2011, Grant Likely wrote:
>>  rename drivers/spi/{omap2_mcspi.c => spi_omap2_mcspi.c} (100%)
>>  rename drivers/spi/{omap_spi_100k.c => spi_omap_100k.c} (100%)
>>  rename drivers/spi/{omap_uwire.c => spi_omap_uwire.c} (100%)
>>  rename drivers/spi/{orion_spi.c => spi_orion.c} (100%)
>>  rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)
>>  rename drivers/spi/{pxa2xx_spi.c => spi_pxa2xx.c} (100%)
>>  rename drivers/spi/{pxa2xx_spi_pci.c => spi_pxa2xx_pci.c} (100%)
>>  rename drivers/spi/{ti-ssp-spi.c => spi_ti_ssp.c} (100%)
>>  rename drivers/spi/{tle62x0.c => spi_tle62x0.c} (100%)
>>  rename drivers/spi/{xilinx_spi.c => spi_xilinx.c} (100%)
>
> I recently looked at the directory structure in drivers/ and found a lot
> of bus drivers with very few files, plus a few bus drivers with a lot
> of files in them besides directories for non-bus specific subsystems.
>
> I think it would be good to move them into a deeper directory drivers/bus/
> if we have support from the maintainers, and it's probably better if we
> only have to move the files once to reduce the amount of churn on the
> MAINTAINERS file and any out of tree patches.

I had this thought too when I was looking at reorganizing the gpio and
spi directories, but ultimately I came to the conclusion that it
didn't really make much sense to move them.  Bus drivers are just
another kind of device driver.  In general, the organization of having
a directory (like spi or i2c) containing both the common bus
infrastructure and a set of drivers using it, and this isn't even
unlike what we do for non-bus drivers.  I don't see much need to move
these.

However, there are a number of bus types that have infrastructure, but
no actual drivers associated with them, like mca, amba and clk.  It
might make sense to move those bus types into drivers/base alongside
the platform_bus_type implementation.

g.
