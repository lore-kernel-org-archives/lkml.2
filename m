Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1FNQOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:14:02 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52360 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FNQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:14:00 -0400
Date: Tue, 14 Jun 2011 10:13:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
Message-ID: <20110614161357.GB1839@ponder.secretlab.ca>
References: <4DDB3AFF.9030006@oracle.com>
 <20110524075248.GB19734@sirena.org.uk>
 <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com>
 <20110527201201.GA6645@ponder.secretlab.ca>
 <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
 <20110603171837.GA9918@opensource.wolfsonmicro.com>
 <BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
 <4DEC4D67.6010506@oracle.com>
 <20110614091211.465553de.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614091211.465553de.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 09:12:11AM -0700, Randy Dunlap wrote:
> On Sun, 05 Jun 2011 20:45:43 -0700 Randy Dunlap wrote:
> 
> > On 06/03/11 10:42, Grant Likely wrote:
> > > On Fri, Jun 3, 2011 at 11:18 AM, Mark Brown
> > > <broonie@opensource.wolfsonmicro.com> wrote:
> > >> On Fri, Jun 03, 2011 at 11:04:52AM -0600, Grant Likely wrote:
> > >>
> > >>> I ended up not pushing this one to Linus.  Turns out it causes other
> > >>> breakage on other platforms that don't include include/linux/gpio.h.
> > >>> Since I don't have confidence that I'll be able to find all the
> > >>> offenders, I'm dropping it.  I recommend making any drivers that are
> > >>
> > >> So, this originally came about because I pushed back on adding random
> > >> dependencies like this for features which are pretty much optional in
> > >> drivers - their use of GPIOs is totally optional and the dependencies
> > >> are just too fragile, leading to noise with all the randconfigs.  It
> > >> seems better to get the architectures to keep up with enhancements to
> > >> gpiolib (or convert to it) than to have to worry about this in drivers.
> > > 
> > > Fair enough.  Randy, if you or someone else can check that all GPIOF_
> > > users have the required #include <linux/gpio.h>, then I'm okay with
> > > this patch.
> > 
> > OK, I'll look at that.
> 
> Of the 70 files that use GPIOF_ macros:
> 
> hdr missing in: ./arch/arm/mach-pxa/spitz_pm.c
> hdr missing in: ./arch/avr32/mach-at32ap/pio.c
> hdr missing in: ./arch/avr32/mach-at32ap/include/mach/portmux.h
> hdr missing in: ./arch/avr32/boards/hammerhead/setup.c
> hdr missing in: ./arch/avr32/boards/hammerhead/flash.c
> hdr missing in: ./arch/avr32/boards/mimc200/setup.c
> hdr missing in: ./arch/avr32/boards/atstk1000/setup.c
> hdr missing in: ./drivers/pcmcia/pxa2xx_vpac270.c
> 
> 
> > Do you have any examples of builds that failed with this patch?
> 
> and would you merge patch(es) that add this header file to those source
> files?  If not, I'll need to make 3 separate patches for them.

Yes I would.  I'm fine with it all being one patch.

g.

