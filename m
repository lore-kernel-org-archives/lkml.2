Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1LLXzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:55:52 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43127 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753675Ab1LLXzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:55:49 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WM1jkJS0m3Tj8HJo19fYa
Date: Mon, 12 Dec 2011 15:55:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to
 postcore
Message-ID: <20111212235544.GM32251@atomide.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <201112130005.35386.jkrzyszt@tis.icnet.pl>
 <20111212231519.GK32251@atomide.com>
 <201112130044.02007.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112130044.02007.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111212 15:13]:
> On Tuesday 13 of December 2011 at 00:15:20, Tony Lindgren wrote:
> > 
> > Might be worth checking if some board specific __initcall helps here
> > too?
> 
> If I only knew how I could insert a board specific __initcall between 
> two points from where the generic-gpio first, then the 8250 driver, are 
> called.
> 
> Any hints?

Hmm, can't you do all that in the order you want in
ams_delta_modem_init()?  Or make that into a late_initcall so
you have generic-gpio available?

It seems that the pieces of code you're talking about don't need
to be initialized early, just needs to be done in the right
order to get things working.

Regards,

Tony
