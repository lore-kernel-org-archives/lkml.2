Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1FFJIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:08:12 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:57282 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752165Ab1FFJII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:08:08 -0400
Date: Mon, 6 Jun 2011 11:08:05 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
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
Subject: Re: [PATCH] spi: reorganize drivers
Message-ID: <20110606090805.GA24716@isilmar-3.linta.de>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	"Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-pcmcia@lists.infradead.org,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alexandre.bounine@idt.com>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Buesch <mb@bu3sch.de>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Florian Fainelli <florian@openwrt.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	spi-devel-general@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
References: <20110605071725.26517.11573.stgit@ponder> <201106061100.38249.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106061100.38249.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:00:38AM +0200, Arnd Bergmann wrote:
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

For PCMCIA, you'd have my Acked-by, if it doesn't end up being the only
directory being moved ;)

Best
	Dominik
