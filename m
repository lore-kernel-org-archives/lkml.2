Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab2CBSIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 13:08:54 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45102 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab2CBSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 13:08:52 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18R2OkNS62APyIr+YucmzQA
Date: Fri, 2 Mar 2012 10:08:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] gpiolib: Add gpiochip_find_by_name() and
 gpio_find_by_chip_name()
Message-ID: <20120302180848.GM18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185524.29210.60381.stgit@kaulin.local>
 <20120302075804.F28DB3E2DB4@localhost>
 <20120302170327.GF18901@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302170327.GF18901@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [120302 08:31]:
> * Grant Likely <grant.likely@secretlab.ca> [120302 01:00]:
> > On Thu, 01 Mar 2012 10:55:24 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > > +
> > > +/**
> > > + * gpiochip_find_by_name() - iterator for locating a gpio_chip by name
> > > + * @name: name of the gpio_chip
> > > + *
> > > + * Similar to bus_find_device_by_name. It returns a reference to the
> > > + * first gpio_chip with matching name. It ignores NULL and empty names.
> > > + * If you need to do something more complex, then use gpiochip_find.
> > > + */
> > > +struct gpio_chip *gpiochip_find_by_name(const char *name)
> > > +{
> > > +	if (!name || !strcmp(name, ""))
> > > +		return NULL;
> > > +
> > > +	return gpiochip_find((void *)name, match_name);
> > 
> > Nasty cast.  Can the signature for gpiochip_find be changed to accept
> > a (const void *)?
> 
> I think so, this too comes from the bus code.

Looks like it can't be const as of_node_to_gpiochip uses it with
a struct device_node * that for of_get_named_gpio_flags comes from
of_parse_phandle_with_args.

Regards,

Tony
