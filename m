Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab2FRFup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:50:45 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:23318 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2FRFun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:50:43 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/o0jRp4oAWbIfiTB4AHRqW
Date: Sun, 17 Jun 2012 22:50:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree
 based pinctrl driver
Message-ID: <20120618055036.GU12766@atomide.com>
References: <20120611135826.GB12766@atomide.com>
 <4FDA6FCD.1020605@wwwdotorg.org>
 <20120615094938.GQ12766@atomide.com>
 <4FDB6000.5080703@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDB6000.5080703@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120615 09:21]:
> On 06/15/2012 03:49 AM, Tony Lindgren wrote:
> 
> (Arnd, Grant, Rob, CC'ing you mainly re: the very last set of comments
> in this email; can you take a look at Tony's patch and comment on the
> binding)

Yes please take a look.
 
> > Care to clarify a bit what you had in mind there?
> 
> Basically I meant:
> 
> 1) Remove anything TI-/OMAP-specific from the generic binding document
> 
> 2) For any TI-/OMAP-specific additions, create a binding document that
> describes those separately to the generic binding documentation.
> 
> However, given that there are no TI-/OMAP-specific additions; OMAP2 just
> uses the base generic bindings exactly as defined, I don't think you
> actually need to create an TI-/OMAP-specific document, since there's
> nothing for it to document.

OK so basically you just want the pinctrl-single binding document to be
generic. Yes I'll do that.
 
> > It's best to describe the hardware in case we need to set up some hardware
> > specific things in the driver.
> 
> There's a difference between the (set of) compatible value(s) that
> appears in the .dts file, and the compatible value(s) that the driver
> binds to.
> 
> Since this driver is purely implementing the pinctrl-single binding, I
> believe only that should be listed in the driver's of_match table.
> 
> However, since the .dts file is describing HW that is both a specific
> OMAP instance, and compatible with pinctrl-single, the .dts file can
> certainly list both. If in the future, the driver ever needs to
> specifically know the difference between the specific OMAP versions, or
> OMAP-vs-something-else, the compatible value will be there already in
> the .dts file, so this will all work. However, I'd argue that if the
> driver has to ever know that, it's probably not appropriate to say it's
> compatible with pinctrl-single any more...

Yes OK I see what you mean now. Sounds good to me, and if/when we need
some hardware specific things, we'll add specific parsing for the other
compatible values.
 
> >> One final comment: A little while before Linaro Connect in San
> >> Francisco, we were all having difficulty coming up with any kind of DT
> >> binding for pinctrl. I had suggested the possibility of creating a
> >> binding which just said "write value X to register Y, write value P to
> >> register Q, ...". This was rejected at connect, because a raw list of
> >> register writes didn't document anything or describe semantics - it was
> >> too much of a binary blob. This driver seems to be doing almost the
> >> exact same thing. In order to avoid that assertion, it'd need to truly
> >> have individual representations of which pins exist, which pingroups
> >> exist, which functions exist, and which functions can be selected onto
> >> which pins/pingroups. That would be a radically different binding. I
> >> wonder what's changed such that this kind of driver wasn't acceptable
> >> then, but is now?
> > 
> > Well that's why I had two bindings earlier: The current binding for the
> > bulk pins that's faster to parse, and a more verbose binding for drivers that
> > allows naming the functions.
> > 
> > In your previous comments at [1] you seemed to prefer this current binding
> > based on the "Why not only allow (1)?" comment. Maybe you had something else
> > in mind, care to clarify that a bit too?
> 
> Well, first I thought about semantics vs. just banging a register list a
> tiny bit more, and remembered the previous discussion.
> 
> But my comment at [1] wasn't so much about "why not just have a raw
> register list", but more regarding why support two different
> representations within the same binding; it wasn't really clear to me
> from reading the original email what the difference between the two
> representations; why have two representations, why/when-to use one vs.
> the other, that the difference was about providing a "semantic" list of
> pins/pingroups/functions vs. providing a "raw" register list.

I too would prefer more verbose .dts files. Unfortunately the parsing of
several hundred board specific pins adds quite a bit of overhead.
 
> IIRC, the pushback on a raw "bang these registers" representation came
> from Grant and/or Arnd. It'd be a good idea if they (and indeed Rob)
> could comment on this binding proposal. If they're OK with this kind of
> pretty raw representation, I'm not going to object, but I have a feeling
> they might not like it?

Yes let's see if anybody has better ideas.

Regards,

Tony

 
> > [1] http://article.gmane.org/gmane.linux.kernel/1291838
