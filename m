Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1HZGYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:24:44 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34250 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753482Ab1HZGYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:24:43 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [RFC PATCH v2] Resurrect Intel740 driver: i740fb
Date: Fri, 26 Aug 2011 08:24:38 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <201108212242.12717.linux@rainbow-software.org> <CAPM=9tzF7C_gW44csqYwK+wdT9mwWBrA3O_9JQNfg=6aip4kag@mail.gmail.com>
In-Reply-To: <CAPM=9tzF7C_gW44csqYwK+wdT9mwWBrA3O_9JQNfg=6aip4kag@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201108260824.38352.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 August 2011, Dave Airlie wrote:
> On Sun, Aug 21, 2011 at 9:42 PM, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > Hello,
> > this is an v2 attempt to resurrect an old (like 2.4.19) out-of-tree
> > driver for Intel740 graphics cards and modify it for recent kernels. The
> > old driver is located at:
> > http://sourceforge.net/projects/i740fbdev/files/
> >
> > It was easier to create a new driver based on skeletonfb, using most of
> > the low level HW code from the old driver. The DDC code is completely
> > new.
> >
> > The driver was tested on two 8MB cards: ManLi and Diamond Stealth II G460
> >
> > The i740_calc_fifo() function formatting is nice but does not pass
> > checkpatch. Making it checkpatch-compliant makes the code look ugly. How
> > to make it both nice and compatible with Linux coding style?
> > (the remaining // comments mark things that need attention - missing xpan
> > and suspend/resume)
> >
> > Changes in v2:
> > - fixed 15bpp (16bpp 555) mode
> > - not working 1280x1024-32 is not a bug but card's feature, it's now
> > handled correctly by the driver
> > - 24bpp modes still don't work in fbtest but it looks like fbtest bug!
> >
> > Is there any better way to test fb drivers than fbtest?
> >
> > no signed-off-by yet
> >
> > --- linux-2.6.39-rc2-orig/drivers/video/Kconfig 2011-04-06
> > 03:30:43.000000000 +0200 +++ linux-2.6.39-rc2/drivers/video/Kconfig    
> >  2011-07-30 11:34:10.000000000 +0200 @@ -1117,6 +1117,17 @@ config
> > FB_RIVA_BACKLIGHT
> >        help
> >          Say Y here if you want to control the backlight of your display.
> >
> > +config FB_I740
> > +       tristate "Intel740 support (EXPERIMENTAL)"
> > +       depends on EXPERIMENTAL && FB && PCI && X86_32 && AGP_INTEL
> > +       select FB_MODE_HELPERS
> > +       select FB_CFB_FILLRECT
> > +       select FB_CFB_COPYAREA
> > +       select FB_CFB_IMAGEBLIT
> > +       select VGASTATE
> > +       help
> > +         This driver supports graphics cards based on Intel740 chip.
> > +
>
> It shouldn't need AGP_INTEL, as its an AGP card not an integrated
> chipset, it might need just AGP.

Oops, I copied that from I810 and then forgot about it...will fix that to 
really match the driver requirements.

BTW. i740 cards are really picky, they don't even POST with most boards that 
don't have i440LX/EX or i440BX/ZX chipsets.


-- 
Ondrej Zary
