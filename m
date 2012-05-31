Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2EaOgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:36:25 -0400
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:59057 "EHLO
	bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754297Ab2EaOgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:36:23 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 10:35:44 EDT
Date: Thu, 31 May 2012 16:25:40 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Florian Fainelli <florian@openwrt.org>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: BCM36xx support.
Message-ID: <20120531142540.GA4785@bitwizard.nl>
References: <20120418055139.GA25952@bitwizard.nl>
 <7383662.i0oNtC19fQ@flexo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7383662.i0oNtC19fQ@flexo>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Florian, 

On Thu, May 31, 2012 at 03:55:34PM +0200, Florian Fainelli wrote:
> First of all, you should have CC'd linux-mips, because that's where
> BCM63xx development happens.

As I'm not familiar with mips-development, I didn't know that. 

> On Wednesday 18 April 2012 07:51:40 Rogier Wolff wrote:
> > 
> > While working on SPI and I2C support for the BCM2835, I found the
> > BCM63xx SPI driver in the kernel. Turns out that this support
> > was partially merged: 
> > 
> > The support can only be enabled when BCM63xx configuration symbol
> > is defined which menuconfig lists as: 
> > 
> >  Symbol: BCM63XX [=BCM63XX]                                                
> >    Type  : unknown                                                           
> > 
> > I'd say the definition of this is not possible through the normal
> > channels.
> > 
> > And in the driver (drivers/spi/spi-bcm63xx.c) I see: 
> > 
> > #include <bcm63xx_dev_spi.h>
> > 
> > but that file is not in the current git release.
> 
> No, it did not make it for a reason I ignore, probably miscommunication.
> 
> > 
> > (some more googling has resulted in me finding out that I don't want
> > to know how the 63xx SPI controller works as it's for a MIPS processor
> > while the 2835 is ARM).

> And so? if the core is the same, just use it on your platform
> too. If you have a look at the architecture files, you will see that
> the various BCM63xx SoC have their internal registers shuffled but
> the SPI core is always software compatible, another set of registers
> can be added for BCM2835.

I expect the core to be very different because they are for different
processors. But of course if they are the same, a single driver would
be better. 

However, with the header file missing, I can't find if the register
offsets are the same. That would be a hint that the module is the the
same. 

Reading the driver I see lots "readb" and "writeb" calls. These
presumably read/write a byte. The '2835 module doesn't have any
byte-registers. All registers are 32bits. I consider this a further
hint that the modules are not the same. 

I've read some of the code, and for instance, there seems to be a
limited-width register (3 or 4 bits) that specify the clock rate on
the bcm63xx. On the bcm2835 the clock is set by good chunk (15 bits
IIRC) of a 32-bit register which specifies the clock divisor. The core
clock runs at 250MHz, so I can specify clock rates at with 1:250
accuracy around 1MHz. (i.e. 1000000 Hz is possible as well as 1004000)
I consider this a further hint that the modules are not the same. 

So with three of those hints I'll take the hint that they are not the
same, and concentrate on building a new driver for the bcm2835 (and
2708?)

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
The plan was simple, like my brother-in-law Phil. But unlike
Phil, this plan just might work.
