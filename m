Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0KLJ5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:57:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58233 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab0KLJ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:57:45 -0500
Date: Fri, 12 Nov 2010 10:57:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
Message-ID: <20101112095739.GH18358@pengutronix.de>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com> <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, Nov 11, 2010 at 01:33:41PM -0800, john stultz wrote:
> On Thu, Nov 11, 2010 at 1:05 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> > After wraparound-problems in sched_clock() we expand the 32bit
> > timer in the MTU from 32 to 63 bits so the scheduling and
> > timeline is more stable. At current max operating frequency for
> > the MTU, 133 MHz, this should be sufficient for rougly 2200
> > years.
> >
> [snip]
> > What we need to know is whether it's OK to simply blow up
> > clocksource to 63 bits like this. In that case this
> > simplification should also apply to Orion, meaning that it
> > would base it's sched_clock() on the clocksource, using
> > simply clocksource_cyc2ns() cutting down the code
> > significantly.
> 
> I would advise against expanding the hardware counter to 63bits via
> software at the clocksource layer. This breaks the
> CLOCK_SOURCE_IS_CONTINUOUS flag rule (since the hardware will wrap
> below the mask value if not updated in the software layer). And as
> Thomas said, this will cause problems in the nohz idle limiting code
> (which makes sure we wake up before the clocksource wraps).
> 
> Instead, I'd use this extension at the sched_clock level, where it
> seems reasonable that it will be called frequently enough to not brake
> the cnt32_to_63 magic.
Instead of implementing sched_clock for each architecture seperatly,
wouldn't it be nice to have a generic sched_clock that uses the
architecture's clocksource?  I tried to implement that some time ago,
but tglx shoot it down because of locking problems.

Maybe doing that became easier since then?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
