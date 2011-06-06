Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1FFJ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:29:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32799 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab1FFJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:29:12 -0400
Subject: Re: [PATCH] spi: reorganize drivers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
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
In-Reply-To: <201106061100.38249.arnd@arndb.de>
References: <20110605071725.26517.11573.stgit@ponder>
	 <201106061100.38249.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 18:29:07 +0900
Message-ID: <1307352547.7586.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 11:00 +0200, Arnd Bergmann wrote:
> On Sunday 05 June 2011, Grant Likely wrote:
> >  rename drivers/spi/{omap2_mcspi.c => spi_omap2_mcspi.c} (100%)
> >  rename drivers/spi/{omap_spi_100k.c => spi_omap_100k.c} (100%)
> >  rename drivers/spi/{omap_uwire.c => spi_omap_uwire.c} (100%)
> >  rename drivers/spi/{orion_spi.c => spi_orion.c} (100%)
> >  rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)
> >  rename drivers/spi/{pxa2xx_spi.c => spi_pxa2xx.c} (100%)
> >  rename drivers/spi/{pxa2xx_spi_pci.c => spi_pxa2xx_pci.c} (100%)
> >  rename drivers/spi/{ti-ssp-spi.c => spi_ti_ssp.c} (100%)
> >  rename drivers/spi/{tle62x0.c => spi_tle62x0.c} (100%)
> >  rename drivers/spi/{xilinx_spi.c => spi_xilinx.c} (100%)
> 
> I recently looked at the directory structure in drivers/ and found a lot
> of bus drivers with very few files, plus a few bus drivers with a lot
> of files in them besides directories for non-bus specific subsystems.
> 
> I think it would be good to move them into a deeper directory drivers/bus/
> if we have support from the maintainers, and it's probably better if we
> only have to move the files once to reduce the amount of churn on the
> MAINTAINERS file and any out of tree patches.
> 
> Specifically, I'd like to do these moves:
> 
> drivers/{ => bus}/amba
> drivers/{ => bus}/dio
> drivers/{ => bus}/eisa
> drivers/{ => bus}/firewire
> drivers/{ => bus}/i2c
> drivers/{ => bus}/mca
> drivers/{ => bus}/nubus
> drivers/{ => bus}/pcmcia
> drivers/{ => bus}/rapidio
> drivers/{ => bus}/sbus
> drivers/{ => bus}/spi
> drivers/{ => bus}/ssb
> drivers/{ => bus}/tc
> drivers/{ => bus}/uwb
> drivers/{ => bus}/virtio
> drivers/{ => bus}/vlync
> drivers/{ => bus}/w1
> drivers/{ => bus}/zorro
> 
> This leaves out the two most common buses, USB and PCI, mostly because
> the directories contain a lot of stuff that is not really bus code
> but actual drivers. It does include i2c and spi, which stick out by
> being a lot larger than most others.
> 
> Opinions? Move or don't move?

I'd say it only makes sense if we do it for all busses ... so USB and
PCI would have to move too.  Logically, the bus code should move and we
should be left with the drivers in both of those directories.  I'd also
say that we don't have to deepen the tree: /bus would be fine.  That
way, /drivers/<bus> would be only for <bus> specific drivers, with non
bus specific drivers we just group them by function as now.

What about the half busses (like SCSI)?

Finally, is there any real point (other than we can do it)?  what is
actually helped by having the bus code obviously separated from the
driver code (assuming we sort out what is bus and what is driver)?

James


