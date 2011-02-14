Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1BNRqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:46:00 -0500
Received: from xes-mad.com ([216.165.139.218]:33067 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1BNRp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:45:56 -0500
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
In-Reply-To: <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	 <1297698493.965.5475.camel@petert>
	 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:45:20 -0600
Message-ID: <1297705520.965.5657.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We need four states for a gpio pin direction though. A pin can be
> >
> > - input
> > - output
> 
> There are actually multiple output modes that a specific gpio
> controller could implement, but the gpio api only has a boolean
> understanding of output.  I don't know if it is really worthwhile to
> try and encode all the possible configurations in this API.
> 
> > - unknown (hardware lacks get functionality and it has not been set by
> >  software yet)

I'm not sure how we could handle unknown directions in a better way.  We
really should know the direction by this point for most (all?) GPIO
chips.  I'd think the proper fix would be to make sure we can detect a
direction for all chips - either by reading hardware bits or by having
the platform code let us know (eg pdata->n_latch in pcf857x.c).  If you
have a suggestion about how unknown pins should be used, I can look into
it and submit a follow up patch.

> > - alt_func (pin is in use for some other purpose)
> 
> What is the use-case for alt_func?  From the point of view of a GPIO
> driver, I don't think it cares if the pin has been dedicated to
> something else.  It can twiddle all it wants, but if the pin is routed
> to something else then it won't have any external effects (pin mux is
> often a separate logic block from the gpio controller).  Also with
> GPIOs, the engineers fiddling with them *really* needs to know what
> the gpios are routed to.  It is highly unlikely to have any kind of
> automatic configuration of gpios; ie. if it isn't wired as a gpio,
> then don't go twiddling it.

Additionally, for this case I thought the low level GPIO driver should
implement a request() function to prevent a non-GPIO pin from being used
in the first place.  Eg like chip_gpio_request() in cs5535-gpio.c, or
ichx_gpio_request() in patch 3 of this series.

> > (and being able to set them alt_func was proposed a while ago and I think
> > wants revisiting judging by the number of platforms which use gpio, and
> > in their own arch code are privately handling alt_func stuff)
> 
> Fair enough; convince me on alt_func.  What is the use case that I'm missing?

Peter

