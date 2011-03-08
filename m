Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1CHA3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:29:49 -0500
Received: from xes-mad.com ([216.165.139.218]:20019 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1CHA3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:29:48 -0500
Subject: Re: [PATCH v5 1/4] gpiolib: Add "unknown" direction support
From: Peter Tyser <ptyser@xes-inc.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Ryan Mallon <ryan@bluewatersys.com>
In-Reply-To: <20110307065253.GB29999@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <20110306072505.GC7467@angua.secretlab.ca>
	 <1299465785.11719.114.camel@ptyser-laptop>
	 <20110307065253.GB29999@angua.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 18:28:53 -0600
Message-ID: <1299544133.6057.53.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 23:52 -0700, Grant Likely wrote:
> On Sun, Mar 06, 2011 at 08:43:05PM -0600, Peter Tyser wrote:
> > > The thing about gpios is that how they are used is entirely dependant
> > > on what they are wired up to.  There is no avoiding the fact that you
> > > *absolutely* must understand the usage model before even considering
> > > fiddling with a gpio (ignoring the "I wonder what this knob does"
> > > use-case such as when reverse engineer a board).  So, while it is nice
> > > to have an 'unknown' state for sysfs to report, it is certainly not
> > > required.  The model still remains that the pin direction must be set
> > > before (or at the same time as) reading/writing the pin.
> > 
> > As is, even if someone knows about the GPIO wiring on their board, they
> > have to know Linux has a "rule" that "before I can use a GPIO, I have to
> > explicitly set its direction, even if the current reported direction is
> > what I want".  A number of our customers have tried to use a GPIO which
> > states its an 'input' as an input after exporting it, which is
> > completely logical.  But it doesn't work, because its not really an
> > input...  Why not set the direction accurately as 'unknown' so users
> > intuitively know they have to set the direction before using it?  You
> > also mention that it would be a nice feature above, so why not include
> > it?
> 
> I don't like what it does to the implementation, and I'd rather make
> drivers provide accurate data at the outset.

Agreed that ideally drivers should provide accurate data at the outset.
The original patch attempted to move in that direction by making it
optional, and didn't touch the concept of "unknown" directions.  Alan
and others argued we should add support for the "unknown" direction,
which spawned this patch.

To be clear, are you saying you won't accept a patch adding an "unknown"
direction?  Or would you be OK with under circumstance X?  If so, what
is circumstance X?

Best,
Peter

