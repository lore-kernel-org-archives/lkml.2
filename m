Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1FFMRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:17:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1585 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab1FFMRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:17:37 -0400
Date: Mon, 6 Jun 2011 14:16:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
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
Subject: Re: [PATCH] spi: reorganize drivers
Message-ID: <20110606141636.150c54b5@endymion.delvare>
In-Reply-To: <201106061321.07400.arnd@arndb.de>
References: <20110605071725.26517.11573.stgit@ponder>
	<201106061100.38249.arnd@arndb.de>
	<1307352547.7586.6.camel@mulgrave.site>
	<201106061321.07400.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 13:21:07 +0200, Arnd Bergmann wrote:
> On Monday 06 June 2011, James Bottomley wrote:
> > I'd say it only makes sense if we do it for all busses ... so USB and
> > PCI would have to move too.  Logically, the bus code should move and we
> > should be left with the drivers in both of those directories.  I'd also
> > say that we don't have to deepen the tree: /bus would be fine.  That
> > way, /drivers/<bus> would be only for <bus> specific drivers, with non
> > bus specific drivers we just group them by function as now.
> 
> A top-level /bus would work for me, and I guess would also address Russell's
> concern. Regarding bus-specific drivers, we're gradually moving those out
> of the bus specific directories anyway, basically the only bus directory
> that really has device driver in it is USB at this point. It makes some
> sense to have a bus-specific low-level user space interface driver like
> sg or uio in the bus directory, but everything else should really belong
> into some other subsystem.

Err, what about I2C and SPI? Aren't drivers/i2c/busses and drivers/spi
full of "device drivers"? Or are these what you call "bus-specific
drivers"? Maybe we need to define all the terms before the discussion
continues further.

> (...)
> This is about to get worse as we introduce new subsystems (e.g. iommu,
> irq, clocksource, eeprom, nvram, ...) into which we are moving
> code from arch/arm, drivers/char and drivers/misc. Having buses and
> drivers in a separate hierarchy would make the drivers directory and
> the respective menuconfig list more clearly structured IMHO.

This gets interesting. Would you suggest for example that i2c-core.c
goes to bus/i2c, and drivers/i2c/busses becomes drivers/i2c? And that
CONFIG_I2C is somewhere in menuconfig, and the hardware driver
selection for drivers/i2c is in a totally different place?

While I am surprised, I am not necessarily objecting. But it seems that
you should better define what your actual plan is, before asking us if
we agree with it.

-- 
Jean Delvare
