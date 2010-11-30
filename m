Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0K3QhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:37:12 -0500
Received: from kroah.org ([198.145.64.141]:42614 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0K3QhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:37:09 -0500
Date: Tue, 30 Nov 2010 08:24:13 -0800
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Message-ID: <20101130162413.GA17505@kroah.com>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>
 <201011261224.59490.arnd@arndb.de>
 <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com>
 <201011301621.48140.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011301621.48140.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:21:47PM +0100, Arnd Bergmann wrote:
> On Tuesday 30 November 2010, Linus Walleij wrote:
> > 2010/11/26 Arnd Bergmann <arnd@arndb.de>:
> > 
> > > * When you say that the devices are static, I hope you do not mean
> > >  static in the C language sense. We used to allow devices to be
> > >  declared as "static struct" and registered using
> > >  platform_device_register (or other bus specific functions). This
> > >  is no longer valid and we are removing the existing users, do not
> > >  add new ones. When creating a platform device, use
> > >  platform_device_register_simple or platform_device_register_resndata.
> > 
> > Is this part of the generic ARM runtime multi-platform kernel
> > and device trees shebang?
> > 
> > The Ux500 still isn't in that sector, it needs extensive rewriting
> > of arch/arm/mach-ux500 to be done first, so as to support e.g.
> > U8500 and U5500 with a single kernel image.
> > 
> > Trying to skin that cat that as part of this review is a bit too
> > much to ask IMO, I'd rather have the author of this driver
> > adapt to whatever platform data registration mechanism is
> > in place for the merge window. Else it needs fixing as part
> > of a bigger endavour to root out compile-time platform
> > configuration.
> 
> The 'no static devices' rule is something that Greg brought up
> at the embedded developer session during PlumbersConf this year,
> I wasn't aware of the problem before that either.
> 
> It is not related to the multi-platform kernel work and it's
> not ARM specific.
> 
> Maybe Greg can give a short explanation of the impact of this.
> AFAIR, static device definitions still work, but there are
> plans to remove that capability in the future.

That is exactly correct.

A struct device is a dynamically referenced thing, and as such, should
be dynamically created and it will be automatically destroyed when it
needs to when everyone is finished with it.  By making a struct device
static, that kind of defeats the whole purpose of reference counting the
thing, not to mention making freeing the object when finished a bit
difficult :)

thanks,

greg k-h
