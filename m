Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2BTKEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:04:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59370 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2BTKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:04:52 -0500
Date: Mon, 20 Feb 2012 10:04:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/18] ARM: at91/rtc-at91sam9: pass the GPBR to use via
	ressources
Message-ID: <20120220100437.GD22562@n2100.arm.linux.org.uk>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <8187feb330895bf9e077ede21e68cc81a72438cc.1329500622.git.nicolas.ferre@atmel.com> <4F419742.70200@gmail.com> <20120220012010.GA29599@game.jcrosoft.org> <20120220073621.GB22562@n2100.arm.linux.org.uk> <20120220091647.GA28066@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220091647.GA28066@game.jcrosoft.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 10:16:47AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 07:36 Mon 20 Feb     , Russell King - ARM Linux wrote:
> > On Mon, Feb 20, 2012 at 02:20:10AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > On 11:43 Mon 20 Feb     , Ryan Mallon wrote:
> > > > On 18/02/12 04:50, Nicolas Ferre wrote:
> > > > 
> > > > > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > > > > 
> > > > > The GPBR registers are used for storing RTC values. The GPBR registers
> > > > > to use are now provided using standard resource entry. The array is
> > > > > filled in SoC specific code.
> > > > > rtc-at91sam9 RTT as RTC driver is modified to retrieve this information.
> > > > > 
> > > > > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > > > > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > > > ---
> > > > >  arch/arm/mach-at91/at91sam9260_devices.c      |   10 +++++++-
> > > > >  arch/arm/mach-at91/at91sam9261_devices.c      |    8 ++++++-
> > > > >  arch/arm/mach-at91/at91sam9263_devices.c      |   16 +++++++++++--
> > > > >  arch/arm/mach-at91/at91sam9g45_devices.c      |    8 ++++++-
> > > > >  arch/arm/mach-at91/at91sam9rl_devices.c       |    8 ++++++-
> > > > >  arch/arm/mach-at91/include/mach/at91sam9260.h |    5 +--
> > > > >  arch/arm/mach-at91/include/mach/at91sam9261.h |    5 +--
> > > > >  arch/arm/mach-at91/include/mach/at91sam9263.h |    5 +--
> > > > >  arch/arm/mach-at91/include/mach/at91sam9g45.h |    5 +--
> > > > >  arch/arm/mach-at91/include/mach/at91sam9rl.h  |    2 +-
> > > > >  drivers/rtc/rtc-at91sam9.c                    |   29 +++++++++++++++++++++---
> > > > >  11 files changed, 76 insertions(+), 25 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> > > > > index 2071017..ae2b648 100644
> > > > > --- a/arch/arm/mach-at91/at91sam9260_devices.c
> > > > > +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> > > > > @@ -718,14 +718,16 @@ static struct resource rtt_resources[] = {
> > > > >  		.start	= AT91SAM9260_BASE_RTT,
> > > > >  		.end	= AT91SAM9260_BASE_RTT + SZ_16 - 1,
> > > > >  		.flags	= IORESOURCE_MEM,
> > > > > -	}
> > > > > +	}, {
> > > > > +		.flags	= IORESOURCE_MEM,
> > > > > +	},
> > > > >  };
> > > > >  
> > > > >  static struct platform_device at91sam9260_rtt_device = {
> > > > >  	.name		= "at91_rtt",
> > > > >  	.id		= 0,
> > > > >  	.resource	= rtt_resources,
> > > > > -	.num_resources	= ARRAY_SIZE(rtt_resources),
> > > > > +	.num_resources	= 1,
> > > > 
> > > > 
> > > > Why this change? The device has two resources, and the rtc driver
> > > > request both of them, so why are you saying there is only one resource
> > > > here. It either needs to be changed back to use ARRAY_SIZE, or needs a
> > > > comment explaining what magic is in use.
> > > because the number of resources depends on the user of rtt
> > > we must not hardcode the GPBR reg as this resource will be present only if the
> > > rtc-at91sam9 is enabled
> > 
> > Better would be to leave .num_resources uninitalized and set that
> > appropriately elsewhere when you make the decision whether GPBR is
> > present or not.  That may help to avoid people trying to "fix" this
> > for you via static checking tools.
> > 
> > As Ryan mentions, a comment in the code would be a good idea too.
> the comment is in the drivers code and Kconfig

Not good enough.  It needs to explain at the at91sam9260_rtt_device
definition why there is a disparity between the number of resources
and the number in the device definition.

People running static checking tools or reading this code aren't going
to look in the Kconfig nor the corresponding driver source for this
information.
