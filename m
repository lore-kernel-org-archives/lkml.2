Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab1LNSV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:21:56 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41104 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1LNSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:21:53 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19D5MkmoYW9a7sQmgA/zD7n
Date: Wed, 14 Dec 2011 10:21:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to
 postcore
Message-ID: <20111214182149.GF32251@atomide.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <201112130044.02007.jkrzyszt@tis.icnet.pl>
 <20111212235544.GM32251@atomide.com>
 <201112141410.53522.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112141410.53522.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111214 04:40]:
> On Tuesday 13 of December 2011 at 00:55:44, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111212 15:13]:
> > > On Tuesday 13 of December 2011 at 00:15:20, Tony Lindgren wrote:
> > > > 
> > > > Might be worth checking if some board specific __initcall helps here
> > > > too?
> > > 
> > > If I only knew how I could insert a board specific __initcall between 
> > > two points from where the generic-gpio first, then the 8250 driver, are 
> > > called.
> > > 
> > > Any hints?
> > 
> > Hmm, can't you do all that in the order you want in
> > ams_delta_modem_init()?  Or make that into a late_initcall so
> > you have generic-gpio available?
> > 
> > It seems that the pieces of code you're talking about don't need
> > to be initialized early, just needs to be done in the right
> > order to get things working.
> 
> Hi,
> I'm almost done with moving registration of all latch dependent devices 
> down to a late_initcall hook, however while working on this, I've found 
> still another arrangement, yet better in my opinion:
> 1) generic-gpio driver registration moved from device_initcall up to 
>    subsys_initcall,
> 2) latch dependent device registration left at arch_initcall, as it is 
>    now,
> 3) a temporary hack, removed with the last patch in the series, that 
>    requests GPIO pins on behalf of device drivers before those are 
>    updated, placed between subsys_initcall and device_initcall, i.e., at 
>    fs_initcall or rootfs_initcall; both look ugly, but this is only for 
>    a while, in order to keep things working while in the transition,
> 4) the modem init hook, once updated with extra GPIO setup that must be 
>    done on behalf of the 8250 driver, which is not prepared for 
>    accepting any extra init hooks passed with the device platform data, 
>    moved down to late_initcall, as suggested,
> 5) once all drivers are updated, the hack is removed, and an 
>    initialization of unused pins added to that late_initcall modem hook, 
>    perhaps renamed in order to not suggest it is still modem only 
>    related.
> 
> What do you think?

Sounds better for sure than what we currently have :)

Tony
