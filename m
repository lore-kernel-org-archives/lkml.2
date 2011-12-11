Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1LKTeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 14:34:13 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13115 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1LKTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 14:34:10 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/uPiEXVO6tzgZEBCdoZAOU
Date: Sun, 11 Dec 2011 11:34:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
Message-ID: <20111211193400.GD31337@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <CAA+hA=Sx=tmnjsY_7EF8NciZO4PvgYOCgRNK9WsGpKmJ8X-r3g@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17518604C3@HQMAIL01.nvidia.com>
 <20111209172407.GP31337@atomide.com>
 <20111209175327.GQ31337@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF175186060C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF175186060C@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [111209 15:42]:
> Tony Lindgren wrote at Friday, December 09, 2011 10:53 AM:
> > * Tony Lindgren <tony@atomide.com> [111209 08:53]:
> ...
> > > For letting a device do it's pingroup in DT, I've played with the
> > > following:
> > >
> > > 	/*      mux func phandle mux func name    hw initial flags */
> > > 	pins = <&uart3_rx_irrx>, "uart3_rx_irrx", <0xdeadbeef>,
> > > 		<&uart3_tx_irtx>, "uart3_tx_irtx", <0xdeadbeef>;
> > >
> > > But it seems that doing mixed-property arrays gets nasty as any
> ...
> > > So I've pretty much come to the conclusion that we would have to
> > > use something like this instead:
> > >
> > > 	/*      phandle        f hw specific initial flags */
> > > 	pins = <&uart3_rx_irrx 0 0xdeadbeef
> > > 		&uart3_tx_irtx 0 0xdeadbeef>;
> > >
> > > This however has a problem for cases where we may not have a phandle
> > > in DT for the mux function. For example, let's assume that we'll have
> > > tens of thousands of lines of mux data for omaps (we already have
> > > over 6k LOC) and just want to load that from /lib/firmware to avoid
> > > bloating the kernel. In that case we won't have the phandle for the
> > > mux function in DT.
> ...
> > Oh forgot to mention of course what Benoit came up which is reg-names.
> > That of course is doable with both phandles and pin names:
> > 
> > So optionally either
> > 
> > 	pins = <&uart3_rx_irrx &uart3_tx_irtx>;
> > or
> > 
> > 	pin-names = "uart3_rx_irrx",  "uart3_tx_irtx";
> 
> Tony,
> 
> It sounds like you've already started working on some DT bindings for
> pin muxing. Are you just at the thinking stage as above, or do you have
> any concrete code? I'd obviously be interested in looking at any early
> bindings to see if I can port the Tegra pinctrl driver to use them.

Yeah I have some code but it still needs a bit more work.. The DT bindings
part I have only briefly played with so far. Mostly to verify that trying
to use the mixed-property arrays will get messy.

For parsing the pins as phandles, drivers/of/gpio.c is a nice example.

After still thinking more about it, I think the cleanest and most flexible
option is using both the pins phandle array or pin-names string array,
combined with a separate pin-flags initial value array. That way we can
use the DT generated maps also for non-dt pinmux drivers where we don't
have phandles around.

Regards,

Tony
