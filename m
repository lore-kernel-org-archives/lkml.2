Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2IJRKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:10:10 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25291 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751366Ab2IJRKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:10:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UJisIBTSvRB1cLxLFUwks
Date: Mon, 10 Sep 2012 10:10:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
Message-ID: <20120910171002.GY1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
 <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
 <20120906191019.GZ1303@atomide.com>
 <504A0F21.8080305@ti.com>
 <20120907165553.GV1303@atomide.com>
 <504DD532.4040400@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504DD532.4040400@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120910 04:55]:
> On 09/07/2012 07:55 PM, Tony Lindgren wrote:
> > 
> > I'd like to have something that specifies the controller type so
> > we don't need to mix two types of controllers and test for
> > non-existing properties when parsing the pins.
> > 
> > How about we require something specified for the pinctrl driver
> > in the "one-bit-per-mux" case like pinctrl-single,bit-per-mux?
> > 
> > And then in the pinctrl-single probe we set params = 3 if
> > pinctrl-single,bit-per-mux is specified. And if no
> > pinctrl-single,bit-per-mux is specified then set params = 2.
> > 
> > That way pcs_parse_one_pinctrl_entry() can just test for params.
> > 
> > Sorry I don't have a better name in mind than bit-per-mux..
> 
> I'm not sure if this would make things more prone to error or make the DTS or
> the code more clean in any ways.
> 
> Both pinctrl-single,pins and pinctrl-single,bits works on top of the same
> pinctrl-single area.
> In most cases we are going to use pinctrl-single,pins for the mux
> configuration and only in few places we need to fall back to pinctrl-single,bits.

What about hardware that has tons of one-bit-per-mux type of registers?
Then we end up trying to find the non-existing property potentially
hundreds of times as the pinctrl-single,pins is never specified.
 
> With this patch we will have maximum of two query to find out which type is
> used, while if we add the 'bit-per-mux' property we will always have need to
> have two of_get_property() call to figure out what is used.
> IMHO in this way we could also have copy-paste errors coming at us when adding
> the mux configurations for the pins and at the end we also need to do same
> safety/sanity checks if the user really provided the correct type with
> correlation to the 'bit-per-mux'.

Well I think we should specify the binding for the type of the controller,
not mix different types of bindings for the same controller. So we should
probably have something just like address-cells, gpio-cells and
interrupt-cells, although in this case it would be specific to pinctrl-single
only and not be called cells.

> This would just complicate the code.
> The existence of pinctrl-single,pins or pinctrl-single,bits property alone
> gives enough information for the number of parameters.

Yes but we don't want to allow mixing different kind of registers within
the same controller, they should be specified as separate controllers.

Regards,

Tony
