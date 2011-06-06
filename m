Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1FFLWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:22:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1FFLWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:22:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] spi: reorganize drivers
Date: Mon, 6 Jun 2011 13:21:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
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
References: <20110605071725.26517.11573.stgit@ponder> <201106061100.38249.arnd@arndb.de> <1307352547.7586.6.camel@mulgrave.site>
In-Reply-To: <1307352547.7586.6.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061321.07400.arnd@arndb.de>
X-Provags-ID: V02:K0:pMbIgFjLSS5cMM52VbTUepQ4VSv3Di714I5nG7P/Ard
 t8kfg361iTKw4zlZQw0ZAsab+x0wiJ1YnjU9vmn8/kw+iUCzad
 c4Dt/AJMLt5MURQyZ8hrPiTdLaFhrOTpmFWPjN9nTz+XO4bziK
 p+HaVY1PUVGSKcu7S6K2adLoVzAHNF5NVmOnS40svrXju1zmZ2
 rDtDuLicCw7f6uAldZkGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011, James Bottomley wrote:
> I'd say it only makes sense if we do it for all busses ... so USB and
> PCI would have to move too.  Logically, the bus code should move and we
> should be left with the drivers in both of those directories.  I'd also
> say that we don't have to deepen the tree: /bus would be fine.  That
> way, /drivers/<bus> would be only for <bus> specific drivers, with non
> bus specific drivers we just group them by function as now.

A top-level /bus would work for me, and I guess would also address Russell's
concern. Regarding bus-specific drivers, we're gradually moving those out
of the bus specific directories anyway, basically the only bus directory
that really has device driver in it is USB at this point. It makes some
sense to have a bus-specific low-level user space interface driver like
sg or uio in the bus directory, but everything else should really belong
into some other subsystem.

> What about the half busses (like SCSI)?

I think SCSI is a really special case, not just because of its size
of more than twice the code than everything else I would suggest to
move, but also because it contains mostly host drivers but very few
device drivers (sd, sr, osst, st, and sg). In that sense it's more
a class of devices than a bus and fits in the same category as
mmc and ata than a bus like pci or i2c that have a multitude of
device drivers.

> Finally, is there any real point (other than we can do it)?  what is
> actually helped by having the bus code obviously separated from the
> driver code (assuming we sort out what is bus and what is driver)?

Mostly I think the drivers/ subdirectory is getting a bit cluttered with
stuff that doesn't really fit together, and bus drivers are typically
directories with less than five files in them, apart from the few
exceptions that already came up.

This is about to get worse as we introduce new subsystems (e.g. iommu,
irq, clocksource, eeprom, nvram, ...) into which we are moving
code from arch/arm, drivers/char and drivers/misc. Having buses and
drivers in a separate hierarchy would make the drivers directory and
the respective menuconfig list more clearly structured IMHO.

	Arnd
