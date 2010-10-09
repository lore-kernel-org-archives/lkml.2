Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab0JIOhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 10:37:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34073 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0JIOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 10:37:33 -0400
Date: Sat, 9 Oct 2010 15:37:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Arnd Hannemann <arnd@arndnet.de>,
        Hemant Pedanekar <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009143709.GB25564@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com> <201010091311.26335.arnd@arndb.de> <AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com> <AANLkTi=37SCuwwze4KS_yOdmi8bvJP_OexHaYLw-AXfJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=37SCuwwze4KS_yOdmi8bvJP_OexHaYLw-AXfJ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 03:10:57PM +0300, Felipe Contreras wrote:
> On Sat, Oct 9, 2010 at 2:43 PM, Dave Airlie <airlied@gmail.com> wrote:
> >> The few drivers that may be hit by this are typically in drivers/staging
> >> exactly because issues like this have not been fixed yet.
> >>
> >> We should probably just fix the non-staging drivers that are hit by
> >> this now and declare the issue done.
> >>
> >> When you say that "many drivers broken", can you list the ones you know
> >> about? It would probably help resolve this the right way.
> >
> > I'm guessing some closed source graphics drivers for ARM do all kinds
> > of wrong crap, and Nokia use them a lot, and nobody wants to tell the
> > closed vendors to change their drivers because it costs money.
> 
> You are over simplifying things.
> 
>  1) The code is open[1]
>  2) the decision comes from TI, Nokia can only do so much before shipping

Well -

1. TI had been complaining last December about vmalloc() creating mappings
   with different shared-ness attributes causing problems with OMAP.

2. May 10, TI on the three-weekly conference call were warned about this
   change to ioremap with system RAM - and this was noted in the minutes
   and circulated.  It was brought up again on June 21st, and yet again
   on August 2nd.

So, the major players in the OMAP community were repeatedly made plainly
aware of this change and some were aware of the problems caused by
violating these kinds of restrictions.

You tell me - if I've raised the issue on the mailing list to which OMAP
people are aware of (and note that there was a reply from OMAP folk in
the inital thread), if I've raised it several times with TI in conference
calls which include the major players, and still OMAP drivers are doing
things wrongly.

You can lead the horse to water but you can not make it drink.  At some
point it either drinks or dies.  In this case, it seems death is the
favoured option as the warnings have been repeatedly ignored.
