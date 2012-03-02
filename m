Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2CBRGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:06:08 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:25258 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2CBRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:06:05 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OVphWDbqOI3iBTpomf7NP
Date: Fri, 2 Mar 2012 09:06:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] mmc: omap_hsmmc: Use gpio_find_by_chip_name() for
 omap_hsmmc_gpio_init()
Message-ID: <20120302170600.GG18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185528.29210.85854.stgit@kaulin.local>
 <4F5060B0.7010703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5060B0.7010703@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rajendra Nayak <rnayak@ti.com> [120301 21:23]:
> On Friday 02 March 2012 12:25 AM, Tony Lindgren wrote:
> >Use gpio_find_by_chip_name() to find the GPIO pins as they can
> >be dynamically allocated on various gpio_chips.
> >
> >Note that we don't want to touch the platform data as it can
> >now specify the GPIO offset on a named gpio_chip.
> >
> >This removes the need to use callbacks to set the GPIO pins
> >in platform data.
> 
> While one of the reasons for those callbacks was to set the GPIO
> pins in platform data, I guess the other and more important one
> was to make sure the init sequencing between twl4030-gpio and the
> mmc device depending on it was done rightly. Doesn't this patch now
> leave the sequencing to work by luck (in the absence of something
> like deferred probe being in place) like is the case of twl6030 and
> mmc init sequence on OMAP4 already?

Nope :) The difference is that  we can exit and produce a sensible
error to the user about the particular gpio_chip not being available.

Regards,

Tony
