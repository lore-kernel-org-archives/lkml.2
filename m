Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0JII4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 04:56:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44711 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0JII4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 04:56:15 -0400
Date: Sat, 9 Oct 2010 09:56:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009085600.GA20975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <AANLkTinPftsrc1uD+Fef2FV6PMit2twiAEzPr90YcBcG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinPftsrc1uD+Fef2FV6PMit2twiAEzPr90YcBcG@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 03:45:16AM +0300, Felipe Contreras wrote:
> 2010/10/9 Greg KH <greg@kroah.com>:
> > On Sat, Oct 09, 2010 at 12:04:51AM +0100, Russell King - ARM Linux wrote:
> >> So, since this has been known about for six months to the day, I completely
> >> fail to see how making this a warning instead will create the necessary
> >> motivation for the issue to be addressed.
> >
> > I doubt that people even noticed that this was a problem.
> >
> > Unless you throw a run-time warning at them, or even better, break the
> > build of their drivers, they will not notice.
> 
> The run-time warning is there, and at the same time the ioremap()
> fails, but this has never been into any release (certainly not there
> in .35).

I've already described the background behind the lifecycle of this
change.

> IMO the vast majority of people only try to run final releases, and
> they will only see the warning on .36. I don't think _all_ ARM users
> are expected to follow every patch sent on the linux-arm-kernel
> mailing list, nor to try the -rc series. In fact, I doubt many try the
> final releases that closely, maybe one yes, one no.

If you have only just noticed it, you have tried zero -rc releases
during this cycle.  What's the point of having -rc releases if no
one in the ARM community tests them?

We might as well push our development stuff out just before Linus
releases a final release if the majority of ARM folk think that -rc
releases are not something they should be testing.

Quite the opposite, -rc releases are _important_ to test to ensure that
the quality of the final kernel is reasonable.  You can't rely on me
being able to test every damned ARM platform, or Tony to test every OMAP
platform.  As a developer, that's _your_ job to ensure that regressions
are found on the setup _you_ have.
