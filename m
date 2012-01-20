Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2ATRyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:54:08 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:17038 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab2ATRyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:54:02 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dkDqAtRRB+vdIcoUNUCuD
Date: Fri, 20 Jan 2012 18:53:51 +0100
From: Tony Lindgren <tony@atomide.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120120175351.GL7807@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <CAJuYYwQoh4_SnA9wmy4x+cG0w0hGukxTkODWtcSw_2QHYuDsrg@mail.gmail.com>
 <20120119165607.GG22818@atomide.com>
 <CAJuYYwQB1pDu-JS5o3XPA1D8WbVcwbdtD43M4y7PeJNWeNXxQQ@mail.gmail.com>
 <20120119182019.GI22818@atomide.com>
 <CAJuYYwQouBDP6dL0B8QOaF0_JsbR7fysySZ5ebcF4op9aTQqbQ@mail.gmail.com>
 <20120120100528.GJ22818@atomide.com>
 <CAJuYYwQ79o5JuOQfs8rSdasVg+ei4KX7tGLuDA-yysseZya9TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwQ79o5JuOQfs8rSdasVg+ei4KX7tGLuDA-yysseZya9TA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Abraham <thomas.abraham@linaro.org> [120120 16:45]:
> On 20 January 2012 15:35, Tony Lindgren <tony@atomide.com> wrote:
> > * Thomas Abraham <thomas.abraham@linaro.org> [120119 10:05]:
> >> On 19 January 2012 23:50, Tony Lindgren <tony@atomide.com> wrote:
> >>
> >> I would like to understand the need for populating the
> >> pinmux/pingroups tables from dt. The question here is when we have
> >> something like
> >>
> >> pins = <&pinctrl0 0x0030 0x15 0x15 0x7>;
> >>
> >> which specifies the values that need to be written to the hardware
> >> registers, would populating pinmux/pingroup tables from dt required.
> >> The SoC specific pinctrl driver can provide a way (with the help of
> >> pinctrl core) to translate these values and write to corresponding
> >> hardware registers. Is there any particular reason for populating the
> >> pinmux/pingroups tables from dt?
> >
> > Hmm I see. Yes it's still needed as we only want to parse the DT once
> > because it's slower unless it was one time only configuration during
> > init.
> 
> Ok. The time spent on searching for the pin-config property can be
> reduced by having the device driver (say, i2c) keep a pointer to all
> the pinconfig properties in its node. The next time a driver needs to
> reconfigure the pins, the search time can be reduced. The time to
> parse the property values though would still be applicable. But I
> would still not opt to build pinmux/pinconfig/pindesc tables from dt.

Hmm that's something to consider to save memory as the node will stay
there. This would allow making all the pinctrl framework data __initdata
in some cases. You'd probably want to copy the data into the driver in
some pinctrl framework struct so you could still use pinctrl framework
functions with this data and not have to parse the node again.

For building the tables from dt, what I have currently is building
the tables without any specific knowledge about the pinmux functions.
I'm thinking that any further knowledge for debugging etc can be done
later on using user space tools to avoid storing the data in kernel.

Regards,

Tony
