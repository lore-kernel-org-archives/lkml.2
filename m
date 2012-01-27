Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab2A0RRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:17:10 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59648 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2A0RRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:17:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rkKn/avWQKO31E4ZXFl5S
Date: Fri, 27 Jan 2012 09:16:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120127171653.GI13504@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <20120126093610.GD2287@S2101-09.ap.freescale.net>
 <20120126175122.GX22818@atomide.com>
 <20120127071944.GC32740@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127071944.GC32740@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shawn Guo <shawn.guo@linaro.org> [120126 22:37]:
> On Thu, Jan 26, 2012 at 09:51:23AM -0800, Tony Lindgren wrote:
> > Hi,
> > 
> > * Shawn Guo <shawn.guo@linaro.org> [120126 00:53]:
> > > 
> > > On Mon, Jan 23, 2012 at 01:00:52PM -0800, Tony Lindgren wrote:
> > > ...
> > > > So to summarize: I suggest we'll just stick to basics to get the system
> > > > booting and devices working using device tree. In most cases the device
> > > > drivers should be able to configure the suspend and off states in a generic
> > > > way using pinctrl API. Everything else, like debugging, we can probably
> > > > do with userspace tools.
> > > > 
> > > > This would mean just using a minimal subset of your binding, probably
> > > > very close to what you originally suggested.
> > > > 
> > > IMHO, as a generic device tree binding, it should be able to cope with
> > > different use cases.  It's really free for you to use the minimal
> > > subset of the binding as your need, but we should not make the binding
> > > design just be that minimal subset to force that everyone else can
> > > only use the minimal subset.
> > 
> > The main issue I have is that the example posted in this thread repeats
> > the same registers five times for one driver entry alone in the device
> > tree data. The repeated registers are TEGRA_PMX_PG_DTA and TEGRA_PMX_PG_DTD
> > in the example.
> > 
> > The alternative values are something that the pinmux/pinconf driver can
> > set based on state changes communicated from the driver using these pins.
> 
> I'm against the idea that requires client device drivers call pinctrl
> APIs on pin basis.  They do not even know or care about the pins that
> they are using.  That's all pinctrl driver's business.  All client
> driver needs to do when it wants to change pinctrl setup should just
> be calling pinmux/pinconf_get/put[enable/disable](dev, "state").

That should work fine too. As long as the states are generic, such as
PMX_STATE_ENABLED, PMX_STATE_IDLE, PMX_STATE_SUSPEND, PMX_STATE_OFF
and so on. You really don't want to change states with some string
names if you need to toggle something every time your enter and exit
idle. And it should be possible to set it on per pin or pingroup basis.
For wake-up events you typically just toggle one pin for the device,
such as serial rx line.

I guess the analog we should follow here is clk_get and clk_set_rate,
except we would have pinconf_set_state with predefined states.

Regards,

Tony
