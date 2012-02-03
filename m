Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2BCWhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:37:47 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32467 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2BCWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:37:46 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Pko29vj3whjP2EyvlU5fI
Date: Fri, 3 Feb 2012 14:37:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH v2] pinctrl: pin configuration states
Message-ID: <20120203223741.GH20333@atomide.com>
References: <1328124889-9780-1-git-send-email-linus.walleij@stericsson.com>
 <20120202230317.GA1426@atomide.com>
 <CACRpkdYEjdX+nNb=fhU3ANFeJwMguEsbGC7Rsqq7g2F-tmE4Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYEjdX+nNb=fhU3ANFeJwMguEsbGC7Rsqq7g2F-tmE4Sw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120203 13:46]:
> On Fri, Feb 3, 2012 at 12:03 AM, Tony Lindgren <tony@atomide.com> wrote:
> > [Me]
> >> +For simple systems that just configure the pins on boot and then forget about
> >> +them, the first configuration table may be sufficient. However some systems
> >> +may need to switch configuration states at runtime, and in that case the
> >> +system may want to ground both pins by simply calling:
> >> +
> >> +ret = pinconf_activate_state("pinctrl-foo", "idle");
> >
> > For dynamic changing of pin states during runtime we should not change
> > the states based on string parsing. This is because some of these pins
> > may need to be changed every time when entering and exiting idle.
> 
> So pinmuxes get a handle back using a get/put pair, and
> have enable/disable semantics as well.
> 
> I avoided this for pin config since it would mean that you have
> to keep some opaque cookie around, like we currently do with
> pinmux. And pin config states are simpler in that you simply
> move from one state to the other, no bookkeeping is involved.
> 
> I never took into consideration that it may be a performance
> issue to do that string parsing and you have a point there.
> 
> So would you prefer something like:
> 
> astat = pinconf_get_state("pinctrl-foo", "idle");
> istat = pinconf_get_state("pinctrl-foo", "idle");
> 
> pinconf_activate_state(astat);
> pinconf_activate_state(istat);
> ...
> 
> If this is what people want I can sure do it like that instead.

OK that sounds good to me.

Regards,

Tony
