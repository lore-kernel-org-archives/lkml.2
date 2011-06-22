Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1FVMYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:24:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53643 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1FVMYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:24:16 -0400
Date: Wed, 22 Jun 2011 13:24:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622122413.GB23666@sirena.org.uk>
References: <20110618171946.GB3441@infomag.iguana.be> <201106182058.14702.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106182058.14702.arnd@arndb.de>
X-Cookie: Is it clean in other dimensions?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 08:58:14PM +0200, Arnd Bergmann wrote:
> On Saturday 18 June 2011 19:19:46 Wim Van Sebroeck wrote:

> > +static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> > +					/* The timer that pings the watchdog */
> > +static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
> > +static unsigned long running;		/* is watchdog running for userspace? */

> How about moving these into a structure that hangs off watchdog_device->priv?
> It would be nice if a driver could live without global variables, especially
> if you want to eventually support multiple concurrent watchdog instances.

Yes, please - even if we can only support a single watchdog at once it'd
be helpful if the common code took care of that limitation and drivers
mould be implemented with support for multiple watchdogs.  It'll be less
work when the core does get this support and until then it means that
drivers don't need to worry about it.
