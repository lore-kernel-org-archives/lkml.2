Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1CGCoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:44:08 -0500
Received: from xes-mad.com ([216.165.139.218]:39643 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1CGCoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:44:07 -0500
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
In-Reply-To: <20110306072505.GC7467@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <20110306072505.GC7467@angua.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 20:43:05 -0600
Message-ID: <1299465785.11719.114.camel@ptyser-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The thing about gpios is that how they are used is entirely dependant
> on what they are wired up to.  There is no avoiding the fact that you
> *absolutely* must understand the usage model before even considering
> fiddling with a gpio (ignoring the "I wonder what this knob does"
> use-case such as when reverse engineer a board).  So, while it is nice
> to have an 'unknown' state for sysfs to report, it is certainly not
> required.  The model still remains that the pin direction must be set
> before (or at the same time as) reading/writing the pin.

As is, even if someone knows about the GPIO wiring on their board, they
have to know Linux has a "rule" that "before I can use a GPIO, I have to
explicitly set its direction, even if the current reported direction is
what I want".  A number of our customers have tried to use a GPIO which
states its an 'input' as an input after exporting it, which is
completely logical.  But it doesn't work, because its not really an
input...  Why not set the direction accurately as 'unknown' so users
intuitively know they have to set the direction before using it?  You
also mention that it would be a nice feature above, so why not include
it?

> Since the addition of an 'unknown'
> direction is solely for benefit of the sysfs interface, I don't (yet)
> see a valid argument for adding it.  *Who cares* if sysfs might report
> direction as 'input' inaccurately?  It may be mildly inconvenient to a
> human reader, but it doesn't change the usage model one iota because
> the direction still must be explicitly set before using the gpio.

Adding an 'unknown' direction *forces* people to use the recommended
usage model.  As is, I'd guess most end users don't know about the
recommended usage model, and they are misled by the incorrect info in
sysfs to boot.

Best,
Peter

