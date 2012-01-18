Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2ARPdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:33:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49735 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2ARPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:33:07 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195OzaAk2XX+vE3ixyu6S99
Date: Wed, 18 Jan 2012 07:32:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120118153256.GB22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
 <20120118141329.GA22818@atomide.com>
 <CAAQ0ZWTtYz3Lg7=Xz29m07j_k8yA95hn6cyk92SAJ4iGJRT_gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAQ0ZWTtYz3Lg7=Xz29m07j_k8yA95hn6cyk92SAJ4iGJRT_gw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shawn Guo <shawn.guo@linaro.org> [120118 05:57]:
> On 18 January 2012 22:13, Tony Lindgren <tony@atomide.com> wrote:
> > Hi,
> >
> > * Grant Likely <grant.likely@secretlab.ca> [120116 09:55]:
> >> On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
> >> >                 pinmux =
> >> >                         <"default" &pmx_sdhci_active>
> >> >                         <"suspend" &pmx_sdhci_suspend>;
> >> >
> >> >                 /* 1:n example: */
> >> >                 pinmux =
> >> >                         <"default" &pmx_sdhci_mux_a>
> >> >                         <"default" &pmx_sdhci_pincfg_a>
> >> >                         <"suspend" &pmx_sdhci_mux_a>
> >> >                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
> >>
> >>
> >> Yeah, don't do this.  Mixing phandle, string and cell values in a
> >> property gets messy and could become troublesome to parse.  I've
> >> backed away from it in the clk binding.
> >
> > Yup, that's because the string is embedded directly into the mixed
> > mode array and will likely make the following data unaligned. That
> > means it's extremely flakey to parse, and will lead into horrible
> > errors if you have typos in the .dts file.. Tried that and gave up
> > on it.
> >
> > I think I've found a way to avoid using names at all, assuming we set
> > each pin as a phandle for the drivers to use :)
> >
> The problem with doing that is we will have to represent each pin as a
> node in device tree.  For imx6q case, we have 197 pins.  Doing so will
> bloat the device tree.

Sure there's some overhead. I've got it working with 220 pins, it's
not too bad as threre's not much string parsing involved.

I don't have all the devices mapping the pins though. The .dtb for
omap4 is about 25k now.

If we wanted to avoid adding phandles for each pin, then we could do:

serial@0x48020000 {
	compatible = "ti,8250";
	reg = <0x48020000 0x100>;
	reg-shift = <2>;
	interrupts = <106>;

	/* controller, offset, value */
	pins = <&mux1 0xabcd 0x10
                &mux1 0xabcf 0x0>;
};

But then the .dts file becomes an unreadable matrix unless we have
a preprocessor..

Regards,

Tony
