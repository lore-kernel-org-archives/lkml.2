Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1FNQMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:12:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FNQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:12:48 -0400
Date: Tue, 14 Jun 2011 09:12:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
Message-Id: <20110614091211.465553de.randy.dunlap@oracle.com>
In-Reply-To: <4DEC4D67.6010506@oracle.com>
References: <20110523155343.2e68c265.randy.dunlap@oracle.com>
	<20110524000837.GA30515@opensource.wolfsonmicro.com>
	<4DDB082F.3010107@oracle.com>
	<20110524014959.GA27710@opensource.wolfsonmicro.com>
	<4DDB3AFF.9030006@oracle.com>
	<20110524075248.GB19734@sirena.org.uk>
	<20110527074552.GA907@ponder.secretlab.ca>
	<4DDFE391.2030507@oracle.com>
	<20110527201201.GA6645@ponder.secretlab.ca>
	<BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
	<20110603171837.GA9918@opensource.wolfsonmicro.com>
	<BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
	<4DEC4D67.6010506@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DF7886C.00C8:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Jun 2011 20:45:43 -0700 Randy Dunlap wrote:

> On 06/03/11 10:42, Grant Likely wrote:
> > On Fri, Jun 3, 2011 at 11:18 AM, Mark Brown
> > <broonie@opensource.wolfsonmicro.com> wrote:
> >> On Fri, Jun 03, 2011 at 11:04:52AM -0600, Grant Likely wrote:
> >>
> >>> I ended up not pushing this one to Linus.  Turns out it causes other
> >>> breakage on other platforms that don't include include/linux/gpio.h.
> >>> Since I don't have confidence that I'll be able to find all the
> >>> offenders, I'm dropping it.  I recommend making any drivers that are
> >>
> >> So, this originally came about because I pushed back on adding random
> >> dependencies like this for features which are pretty much optional in
> >> drivers - their use of GPIOs is totally optional and the dependencies
> >> are just too fragile, leading to noise with all the randconfigs.  It
> >> seems better to get the architectures to keep up with enhancements to
> >> gpiolib (or convert to it) than to have to worry about this in drivers.
> > 
> > Fair enough.  Randy, if you or someone else can check that all GPIOF_
> > users have the required #include <linux/gpio.h>, then I'm okay with
> > this patch.
> 
> OK, I'll look at that.

Of the 70 files that use GPIOF_ macros:

hdr missing in: ./arch/arm/mach-pxa/spitz_pm.c
hdr missing in: ./arch/avr32/mach-at32ap/pio.c
hdr missing in: ./arch/avr32/mach-at32ap/include/mach/portmux.h
hdr missing in: ./arch/avr32/boards/hammerhead/setup.c
hdr missing in: ./arch/avr32/boards/hammerhead/flash.c
hdr missing in: ./arch/avr32/boards/mimc200/setup.c
hdr missing in: ./arch/avr32/boards/atstk1000/setup.c
hdr missing in: ./drivers/pcmcia/pxa2xx_vpac270.c


> Do you have any examples of builds that failed with this patch?

and would you merge patch(es) that add this header file to those source
files?  If not, I'll need to make 3 separate patches for them.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
