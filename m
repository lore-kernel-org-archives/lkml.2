Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2EJR1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:27:30 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14374 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2EJR13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:27:29 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Hc0ey0NX3UogxPGbYKPLv
Date: Thu, 10 May 2012 10:27:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120510172722.GE21851@atomide.com>
References: <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
 <20120504150342.GI5140@atomide.com>
 <20120504153251.GE7788@game.jcrosoft.org>
 <20120504163420.GA5613@atomide.com>
 <4FA42631.6060304@wwwdotorg.org>
 <20120504220809.GW5613@atomide.com>
 <4FAAD141.3090306@wwwdotorg.org>
 <20120509204925.GV5088@atomide.com>
 <4FABF553.20601@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABF553.20601@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120510 10:09]:
> On 05/09/2012 02:49 PM, Tony Lindgren wrote:
> > * Stephen Warren <swarren@wwwdotorg.org> [120509 13:22]:
> >> On 05/04/2012 04:08 PM, Tony Lindgren wrote:
> >>> * Stephen Warren <swarren@wwwdotorg.org> [120504 11:59]:
> >>>> On 05/04/2012 10:34 AM, Tony Lindgren wrote:
> >>>>> * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120504 08:58]:
> >>>>>> On 08:03 Fri 04 May     , Tony Lindgren wrote:
> >>>>>>>>
> >>>>>>>> so I was thinking to do like on gpio
> >>>>>>>>
> >>>>>>>> uart {
> >>>>>>>> 	pin = < &pioA 12 {pararms} >
> >>>>>>>>
> >>>>>>>> }
> >>>>>>>
> >>>>>>> Hmm I assume the "12" above the gpio number?
> >>>>>> no pin number in the bank because it could not be gpio
> >>>>>
> >>>>> Yes OK, but pin number 12 in the gpio bank, not in the mux register.
> >>>>> Got it.
> >>>>
> >>>> I'd prefer to avoid any references to GPIOs here; not all muxable pins
> >>>> are GPIOs and not all GPIOs are muxable pins. Lets keep the two concepts
> >>>> independent.
> >>>
> >>> And it seems that &pioA 12 is not always enough information for the pinctrl
> >>> driver to request a GPIO. So it's best to specify it separately.
> >>
> >> Why would a pinctrl driver "request a GPIO"?
> > 
> > Hmm what would pinctrl_request_gpio do if the GPIO driver is separate driver?
> 
> Well, that's a GPIO driver requesting a GPIO from the pinctrl system,
> rather than the pinctrl driver requesting a GPIO (sorry to be picky).

Oh sorry maybe I misunderstood what pinctrl_request_gpio is doing.
Seems like that should work the same way from binding point of view.
 
> It wasn't at all obvious to me from your binding proposal that you
> intended the pinctrl-simple driver to support the GPIO operations at
> all. If you do want this, I think you'd need some properties (perhaps
> some kind of explicit table) in order to set up the GPIO ID -> pinctrl
> pin ID mapping. I don't recall seeing those; did I just miss them? I
> think we'd want this to be explicit because:
> 
> a) It may well be the case that not all users of pinctrl-simple actually
> mux/control GPIOs at all. It's certainly possible to only mux "special
> functions", and have dedicated pins for a GPIO controller.
> 
> b) Even when GPIOs do come into the picture, it may be that only some of
> the pins are available as GPIOs.

Right, we need some pinctrl to gpio mapping eventually. That comes
automatically from DT for the pins and gpios we care about.

And that's why the binding needs to be flexible enough so we can add
optional pin specific options as needed in addition to parsing a larger
set of pins with no options.

> Also, were you intending pinctrl-simple to actually be the GPIO
> controller itself? That'd be another case that one might consider fairly
> simple, but then extends to being gpio-simple as well as pinctrl-simple...

No, I was thinking that we can have other drivers using pinctrl simple
and add the extra features for the pins that have those.

Regards,

Tony
