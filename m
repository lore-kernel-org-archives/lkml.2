Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2ATRmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:42:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56438 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2ATRmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:42:02 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18PmpTHXkQolWveKOzJF3+H
Date: Fri, 20 Jan 2012 09:41:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 3/4] pinctrl: Add checks for empty names in
 pinmux_search_function
Message-ID: <20120120174157.GQ22818@atomide.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
 <20120120161730.21955.40332.stgit@kaulin.local>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAB384@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB384@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120120 08:28]:
> Tony Lindgren wrote at Friday, January 20, 2012 9:18 AM:
> > Otherwise we can get the following when dealing with
> > buggy data in a pinmux driver:
> > 
> > Unable to handle kernel NULL pointer dereference at virtual address 00000000
> 
> > diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> > index 06b8943..ffe633d 100644
> > --- a/drivers/pinctrl/pinmux.c
> > +++ b/drivers/pinctrl/pinmux.c
> > @@ -584,6 +584,13 @@ static int pinmux_search_function(struct pinctrl_dev *pctldev,
> >  							   selector);
> >  		int ret;
> > 
> > +		if (!fname) {
> > +			pr_warning("no name for function%i\n",
> > +				   selector);
> > +			selector++;
> > +			continue;
> > +		}
> > +
> >  		if (!strcmp(map->function, fname)) {
> >  			/* Found the function, check pin group */
> >  			ret = pinmux_check_pin_group(pctldev, selector,
> 
> Shouldn't this be BUG_ON(!fname)?
>
> There are lots of other places that pmxops->get_function_name() is
> called. Wouldn't it be better to enhance e.g. pinmux_check_ops() to
> validate that all functions have a name during pinctrl registration?

Maybe yeah. I'll take a look next week when I'm back home.

Tony
