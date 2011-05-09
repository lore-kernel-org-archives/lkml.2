Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1EIPqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:46:50 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47790 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751680Ab1EIPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:46:49 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ov123lBpXcixpPQHToXl3
Date: Mon, 9 May 2011 08:46:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Message-ID: <20110509154644.GE11410@atomide.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
 <20110504091619.GV2092@atomide.com>
 <BANLkTimrGP1ohGX1B4teaNMbgVjSb5Mw5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimrGP1ohGX1B4teaNMbgVjSb5Mw5Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Rapoport <mike.rapoport@gmail.com> [110507 12:07]:
> On Wed, May 4, 2011 at 12:16 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Linus Walleij <linus.walleij@stericsson.com> [110502 12:13]:
> >
> > Good to see this, looks like this should work for omaps too.
> >
> > The numbering solves the issue where we have multiple
> > pinmux domains (base + offset for each domain).
> >
> > Then I would assume that for most cases the pin access can be
> > described with:
> >
> > unsigned long pinmux_base;      /* Can have multiple pinux domains */
> > u16 pinmux_reg_offset;          /* Register offset from pinmux_base */
> > u16 flags;                      /* Register width etc */
> >
> > Which can be accessed with read[bwl] and write[bwl], so we
> > can have default access functions in the pinux framework and
> > don't necessarily have to implement them for each platform.
> 
> On some platforms setting the pin configuration won't require to keep
> that lot of data, see, e.g. Orion and it's successors.

Yeah but if we can figure out some common data format the wasted
memory won't matter compared to having common code.

I guess if we plan on passing the mux registers in devicetree data,
we actually should just have something like this for each mux entry: 

address
muxmodes
flags

Don't know how well that would work for tegra, can you calculate
the configuration registers from some base address maybe?

Regards,

Tony
