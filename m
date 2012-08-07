Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2HGOmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:42:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56483 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2HGOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:42:00 -0400
Date: Tue, 7 Aug 2012 15:41:38 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807144137.GJ24257@flint.arm.linux.org.uk>
References: <20120806213124.GB14594@flint.arm.linux.org.uk> <20120807121157.GA10166@flint.arm.linux.org.uk> <20120807132510.GE16861@opensource.wolfsonmicro.com> <201208071428.15739.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208071428.15739.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:28:15PM +0000, Arnd Bergmann wrote:
> On Tuesday 07 August 2012, Mark Brown wrote:
> > On Tue, Aug 07, 2012 at 01:11:57PM +0100, Russell King wrote:
> > > index 589e0e7..bfee885 100644
> > > --- a/include/linux/ioport.h
> > > +++ b/include/linux/ioport.h
> > > @@ -31,6 +31,7 @@ struct resource {
> > >  #define IORESOURCE_TYPE_BITS 0x00001f00      /* Resource type */
> > >  #define IORESOURCE_IO                0x00000100
> > >  #define IORESOURCE_MEM               0x00000200
> > > +#define IORESOURCE_REG               0x00000300      /* Register offsets */
> > >  #define IORESOURCE_IRQ               0x00000400
> > >  #define IORESOURCE_DMA               0x00000800
> > >  #define IORESOURCE_BUS               0x00001000
> > 
> > As I've said before I'm fine with the driver changes.  I do feel that it
> > would be better to also renumber all the existing resource types while
> > we're at it in order to make it clear that these are just plain numbers,
> > that's the reason nobody wrote this patch previously.  This will avoid
> > any future confusion.
> 
> This gets into a lot more tricky territory: We have a bunch of drivers
> doing their own bitmask operations on these, like drivers/video/offb.c
> testing
> 
>         if ((flags & (IORESOURCE_IO | IORESOURCE_MEM)) == 0)
>                 return NULL;
> 
> or drivers/scsi/gdth.c doing
> 
>             if (!(base0 & IORESOURCE_MEM) ||
>                 !(base2 & IORESOURCE_MEM) ||
>                 !(base1 & IORESOURCE_IO)) 
>                 return -ENODEV;
> 
> Now I've looked at the three drivers with the immediate problem of
> IORESOURCE_IO abuse (max8925, wm831x, 88pm860x) and none of them are
> doing such bitmask operations, so I'm reasonably sure we are fine
> for those drivers. I also agree that renumbering the resources in a
> way that makes it impossible to use bitmasks is a good idea, but
> that would actually be pretty invasive because then we have to rewrite
> all the functions that currently do it.

Don't feed the troll :)

None of the code you list above would be affected in any way by the
changes I propose; we're not changing the existing values, and these
drivers would not see the new IORESOURCE_REG type.

That's not to say that they wouldn't need fixing (they do), but they
are not a reason to reject my proposal, even for -stable trees.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
