Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1BNSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:46:48 -0500
Received: from xes-mad.com ([216.165.139.218]:12152 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1BNSqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:46:46 -0500
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
In-Reply-To: <AANLkTin7gBNBXKCuwL6Az+-+KQEw8Hsq-DYYr1RTXhFm@mail.gmail.com>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	 <1297698493.965.5475.camel@petert>
	 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	 <1297705520.965.5657.camel@petert>
	 <AANLkTin7gBNBXKCuwL6Az+-+KQEw8Hsq-DYYr1RTXhFm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 12:46:03 -0600
Message-ID: <1297709163.965.5858.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 11:04 -0700, Grant Likely wrote:
> On Mon, Feb 14, 2011 at 10:45 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
> >> > We need four states for a gpio pin direction though. A pin can be
> >> >
> >> > - input
> >> > - output
> >>
> >> There are actually multiple output modes that a specific gpio
> >> controller could implement, but the gpio api only has a boolean
> >> understanding of output.  I don't know if it is really worthwhile to
> >> try and encode all the possible configurations in this API.
> >>
> >> > - unknown (hardware lacks get functionality and it has not been set by
> >> >  software yet)
> >
> > I'm not sure how we could handle unknown directions in a better way.  We
> > really should know the direction by this point for most (all?) GPIO
> > chips.  I'd think the proper fix would be to make sure we can detect a
> > direction for all chips - either by reading hardware bits or by having
> > the platform code let us know (eg pdata->n_latch in pcf857x.c).  If you
> > have a suggestion about how unknown pins should be used, I can look into
> > it and submit a follow up patch.
> 
> Does it really matter?  Sure it's *nice* to have the current status
> information if the driver can easily get it, but it probably isn't
> critical.  Any user of the pin should be putting the pin in the mode
> it needs regardless of the initial state.

I don't think it matters too much since I haven't encountered a driver
where you can't determine a pin direction yet.  But if it were
impossible to determine a direction, it would throw people off.  They'd
have to know that the pin direction couldn't be trusted initially, which
is a big leap (this is the bug I'm trying to fix with this patch).  Eg
if someone sees a pin direction as "input" via sysfs, what are the odds
that they'll run "echo input > direction" just to make sure...

Anyway, I don't think its a critical issue either since its a corner
case with an easy workaround.  If we did want to add support for
allowing a direction of "unknown", it could be in a follow up patch
since its technically a bigger issue than this patch.

Peter

