Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2A0Rmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:42:44 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:25261 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2A0Rmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:42:43 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19SeKpGxutyFw6wZCDHn5Vr
Date: Fri, 27 Jan 2012 09:42:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>,
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
Message-ID: <20120127174232.GK13504@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
 <20120127020832.GJ29812@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178E123E57@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E123E57@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120127 09:05]:
> Tony Lindgren wrote at Thursday, January 26, 2012 7:09 PM:
> ...
> > I don't think we should try to pass the different possible states from
> > device tree. The pinmux/pinconf driver should know how to deal with that,
> 
> Somehow, the pinctrl driver needs to know how to implement each state. In 
> general, I believe this will be board-specific.
> 
> Do you disagree with this assertion?
> 
> If the data is board-specific, I don't see how it can be represented
> anywhere but the device tree.

Agreed, for board specific things device tree is the place to put it.
 
> > and the driver using the mux should be able to communicate what it wants
> > to the pinmux/pinconf driver. If people really want to be able to pass
> > alternative mux states from device tree, they should be standard bindings
> > for things like active/idle/suspend/off.
> 
> As I've mentioned before, people have asked for driver-specific states to
> handle the case where e.g. drive strength must be adjusted based on clock
> rates of the interface. Again, I believe that's board-specific data since
> the actual values to use may be derived during board calibration, not
> SoC design.
> 
> Do you disagree that this data may be board specific?

Right, but for the dynamic mux cases I've seen the alternative states
are usually specific to the driver using the mux. That's why I'm
suspicious of the board specific custom alternative states :)

Anyways, do you think the pinctrl-static + pinctrl-dynamic binding
I just posted as a reply to Simon's email would work for you?

Regards,

Tony
