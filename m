Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab0LTVOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:14:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186Ab0LTVOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:14:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Mon, 20 Dec 2010 22:13:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201012181559.50347.rjw@sisk.pl> <20101220150051.GI26706@rakim.wolfsonmicro.main>
In-Reply-To: <20101220150051.GI26706@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012202213.53902.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 20, 2010, Mark Brown wrote:
> On Sat, Dec 18, 2010 at 03:59:50PM +0100, Rafael J. Wysocki wrote:
> 
> > Second, the situation at hand is that the bus type implements dev_pm_ops,
> > but the driver doesn't.  Now, pm_generic_suspend() is called with a struct
> > device pointer, so it would have to go back to dev->bus, find the
> > ->legacy_suspend() callback (as opposed to ->suspend(), which also is legacy,
> > but is called by the PM core instead).  May I call that confusing?
> 
> Well, the trouble is that the whole situation is already pretty
> confusing for what should be very simple buses, each one needs to write
> a bunch of not really bus specific code in order to get basic behaviour
> which allows the drivers to make use of runtime PM, requiring more
> thought and care per bus than I'd expect given that they've nothing
> really to contribute.  This leads to the sort of random variations
> between buses that Rabin is reporting, and means that updates keep
> having to get done in multiple different places.
> 
> The overall effect is that from the point of view of trying to use
> runtime PM in drivers which work with these simple buses everything
> feels like it's much harder work than it should be.  Moving all the
> decision making out of the buses and into the PM core seems like a win
> here.

Well, the _solution_ is to get rid of the legacy stuff from those buses in the
first place.  Then, they'll just need to use the generic ops without any
trouble.

What you're proposing is a workaround that people will use as an excuse for
not doing the right thing forever.

Thanks,
Rafael
