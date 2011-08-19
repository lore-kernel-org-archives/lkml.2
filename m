Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1HSQxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:53:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35711 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525Ab1HSQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:53:14 -0400
X-Sasl-enc: PWy9vu6eZiBZNt544p9IXRELCCzTYaaRnPxD1IDG7f6H 1313772792
Date: Fri, 19 Aug 2011 09:52:52 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110819165252.GC4016@kroah.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
 <20110819104816.GA5030@pulham.picochip.com>
 <CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
 <201108191636.29161.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108191636.29161.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 04:36:28PM +0200, Arnd Bergmann wrote:
> On Friday 19 August 2011, Linus Walleij wrote:
> > On Fri, Aug 19, 2011 at 12:48 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> > 
> > >> +static struct class pinctrl_class = {
> > >> +     .name = "pinctrl",
> > >> +     .dev_release = pinctrl_dev_release,
> > >> +     .dev_attrs = pinctrl_dev_attrs,
> > >> +};
> > >
> > > Greg K-H has mentioned in the past that class is now deprecated for new
> > > use and that a bus_type should be used instead.
> > 
> > Can you provide a reference with some detail?
> > The pin control devices are usually aleady on a bus like the
> > platform_bus or amba_bus or i2c_bus, then they register a
> > class device in this case.
> > 
> > The kerneldoc documentation says
> > "A bus is a channel between the processor and one or more devices."
> > 
> > This isn't the case here.
> > 
> > Anyhthing that help me understand this is appreciated, Arnd?
> 
> Taking Greg on Cc as well.
> 
> The main difference between a normal device and a class device is
> that one is linked from /sys/bus/*/devices/* and the other is linked
> from /sys/class/*/*. However, they both live in /sys/devices/.../*
> as directories.
> 
> I always liked the separation between the two, although there are
> a few cases where there is a grey area (e.g. /sys/bus/hid or
> /sys/class/mmc_host) and the abstraction doesn't really fit.
> 
> IIRC Greg would prefer now to never have had the distinction
> and wants to make all future uses use a bus_type.

Yes, that is totally correct.  Kay has also written much more about this
and why this is the way forward many times in the past, see lkml
archives for the details if anyone is interested.

thanks,

greg k-h
