Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab1BRU2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:28:00 -0500
Received: from xes-mad.com ([216.165.139.218]:14681 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab1BRU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:27:58 -0500
Subject: Re: [PATCH v3 2/4] gpiolib: Add ability to get GPIO pin direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20110218184954.GE22310@pengutronix.de>
References: <1297983799-4747-1-git-send-email-ptyser@xes-inc.com>
	 <1297983799-4747-2-git-send-email-ptyser@xes-inc.com>
	 <20110218085734.GX22310@pengutronix.de> <1298050586.965.20444.camel@petert>
	 <20110218184954.GE22310@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 14:27:23 -0600
Message-ID: <1298060843.965.20478.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 19:49 +0100, Uwe Kleine-König wrote:
> Hello Peter,
> 
> On Fri, Feb 18, 2011 at 11:36:26AM -0600, Peter Tyser wrote:
> > On Fri, 2011-02-18 at 09:57 +0100, Uwe Kleine-König wrote:
> > > On Thu, Feb 17, 2011 at 05:03:17PM -0600, Peter Tyser wrote:
> > > > Add a new get_direction() function to the gpio_chip structure.  This is
> > > > useful so that the direction of a pin can be determined when its
> > > > initially exported.  Previously, the direction defaulted to "unknown"
> > > > regardless of the actual configuration of the GPIO pin.
> > > > 
> > > > If a GPIO driver implements get_direction(), it is called in
> > > > gpio_request() to set the initial direction of the pin accurately.
> > > IMHO the commit log is conceptually wrong, because it talks about a
> > > "pin".  Better use gpio here.
> > 
> > I don't follow.  I used "pin" to make it clear that the get_direction()
> > function operates on a pin-by-pin basis, and to help reduce any
> > ambiguity about if a gpio chip or gpio pin is being referred to.  Would
> > you prefer that the "pin" references are clarified to be "GPIO pin"?
> Maybe it's just that we use different terms.  For me a "pin" is an
> entry/exit point into/from a cpu or other chip.  A gpio is (hmm, how
> should I say) a concept how to drive a pin.  A gpio might or might not
> be "connected" to a pin at a given time.

Ahh, I see...  The GPIO subsystem doesn't have the capability to
multiplex a GPIO to different physical pins at the moment, so I always
equate a GPIO with a specific pin, even if its not "connected" all the
time.  I'll remove the "pin" references when I resubmit if you think it
is more accurate.

Peter

