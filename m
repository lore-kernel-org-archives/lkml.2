Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2EDPDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:03:49 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:53951 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2EDPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:03:48 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/aJDIAgg0KcvwuiOS5Tchq
Date: Fri, 4 May 2012 08:03:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120504150342.GI5140@atomide.com>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504044305.GD7788@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120503 22:08]:
> 
> In my mind in the driver we do not have to care how to list
> register/unregister the group. We just need to be able to do this
> 
> pinctrl_register_group(...)
> 
> or 
> 
> pinctrl_unregistewr_group(...)
> 
> On at91 we have this type of controller

Ah I see. Yeah makes sense. Also I think we should let the pinctrl
core eventually manage the pins more too. Right now the pins are
a static array in the driver, which makes things unnecessarily
complex for the DT case. It would be nice to also have something like
pinctrl_register/unregister_pin instead of requiring them all
be registered while registering with the framework initially.

But all that can be improved later on once we get the binding down..
 
> one pin can have multiple function and each function can be on different pin
> and we need to program and represent each of them one by one
> 
> And each pin have different parameter
> 
> so I was thinking to do like on gpio
> 
> uart {
> 	pin = < &pioA 12 {pararms} >
> 
> }

Hmm I assume the "12" above the gpio number?
 
> and use macro as basicaly we are just this
> 
> and this can be applied to tegra too as you will just refer the pin in this hw
> pin block

I was thinking of adding gpio eventually as a separate attribute with
something like the following. Here cam_d10 pin is used as gpio109:

cam_d10.gpio_109 {
	pinctrl-simple,cells = <0xfa 0x104>;	/* OMAP_PIN_INPUT | OMAP_MUX_MODE4 */
	gpio = <&gpio4 13 0>;			/* gpio109 */
};

The reasoning for this is that as we may not care about the gpio number
for all pins, it should be optional. Would that work for you?

Regards,

Tony
