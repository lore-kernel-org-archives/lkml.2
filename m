Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2AaAy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:54:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2AaAy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:54:57 -0500
Date: Tue, 31 Jan 2012 09:07:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Tony Lindgren <tony@atomide.com>
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
Message-ID: <20120131010708.GA24681@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <20120126093610.GD2287@S2101-09.ap.freescale.net>
 <20120126175122.GX22818@atomide.com>
 <20120127071944.GC32740@S2101-09.ap.freescale.net>
 <20120127171653.GI13504@atomide.com>
 <20120130021041.GB10470@S2101-09.ap.freescale.net>
 <20120130174323.GF9339@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130174323.GF9339@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 09:43:23AM -0800, Tony Lindgren wrote:
> * Shawn Guo <shawn.guo@linaro.org> [120129 17:27]:
> > On Fri, Jan 27, 2012 at 09:16:53AM -0800, Tony Lindgren wrote:
> > ...
> > > I guess the analog we should follow here is clk_get and clk_set_rate,
> > > except we would have pinconf_set_state with predefined states.
> > > 
> > It seems working for cases that we only change pinconf but never pinmux
> > for different configuration states.  But how would that work for cases
> > that require mux change for different configuration states?
> 
> I don't see why we should not allow changing the mux state with pinconf
> too, after all it's the mux/pin that's locked, not the functionality of
> the pin.
> 
My point is I do not see how we can use the current pinmux APIs design
to change mux in the way how clk_get and clk_set_rate work.  Or you
have a pinmux APIs reconstruction on your mind?

Regards,
Shawn

> An example of this would be remuxing a shared UART line between rx and
> tx. Those kind of cases could be defined as PMX_DIRECTION_INPUT and
> PMX_DIRECTION_OUTPUT so driver could call Linux generic functions for
> those if implemented.
> 
