Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2AaC3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:29:16 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62533 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2AaC3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:29:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+ZIWUeKU3peC0sPhQhCJu
Date: Mon, 30 Jan 2012 18:29:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120131022906.GH9339@atomide.com>
References: <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
 <20120127020832.GJ29812@atomide.com>
 <20120127065752.GB32740@S2101-09.ap.freescale.net>
 <20120127170545.GH13504@atomide.com>
 <20120130015607.GA10470@S2101-09.ap.freescale.net>
 <20120130172042.GE9339@atomide.com>
 <20120131013215.GB24681@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131013215.GB24681@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shawn Guo <shawn.guo@linaro.org> [120130 16:49]:
> On Mon, Jan 30, 2012 at 09:20:42AM -0800, Tony Lindgren wrote:
> > * Shawn Guo <shawn.guo@linaro.org> [120129 17:13]:
> > > On Fri, Jan 27, 2012 at 09:05:45AM -0800, Tony Lindgren wrote:
> ...
> > > > Wouldn't it be cleaner to just clk_get esdhc_clk during init, then
> > > > do clk_set_rate on it to toggle the rates?
> > > >  
> > > It's not an init-time switch but run-time one.  That said,
> > > sdhci_ops.set_clock will be called during run-time.
> > 
> > Right, basically you don't want to do clk_get or pinmux_get during
> > runtime, you do that once one during init. Then do clk_set_rate or
> > whaterver during runtime.
> > 
> > Is there anything stopping from implementing sdhci_ops.set_rate
> > using clock framework and clk_set_rate in this case BTW?
> >  
> We are doing this exactly for clk, and trying to figure out how to
> handle pinctrl here.  I do not see how we can do pinmux_get at
> init-time and pinmux_set_whatever at run-time.  The pinmux API does
> not work that way.

Hmm OK I see what you mean. Maybe we should have something like
pinmux_get/set_function to change the mux without having to do
pinmux_put and pinmux_get during runtime? As long as the locking is
per pin that should be safe to do.
 
> > > > > > So I'd rather stay out of random named states for
> > > > > > the pins coming from device tree; If we still need them, they should
> > > > > > be common bindings rather than things like "xyz_clock_hack".
> > > > > > 
> > > > > The binding defines the syntax, and I do not see the necessity to
> > > > > force the particular state name, which is really pinctrl client
> > > > > device specific.
> > > > 
> > > > Do you have some other custom pin state example other than the
> > > > clock rate change example above?
> > > > 
> > > I have another case PM related.  To aggressively save power, the pins
> > > configured for particular function during active mode need to be
> > > muxed on gpio mode and output 0 in low-power mode.
> > 
> > OK, but basically only a small subset of pins of the total pins?
> > 
> Actually, all pins used by the block.

That's still a fraction of the total pins on the SoC that need dynamic
remuxing, right?

Regards,

Tony
