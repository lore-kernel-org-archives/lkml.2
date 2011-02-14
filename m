Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1BNRjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:39:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45385 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755753Ab1BNRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:39:41 -0500
Date: Mon, 14 Feb 2011 17:39:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110214173938.GF8226@opensource.wolfsonmicro.com>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert>
 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:26:18AM -0700, Grant Likely wrote:
> On Mon, Feb 14, 2011 at 10:08 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > - input
> > - output

> There are actually multiple output modes that a specific gpio
> controller could implement, but the gpio api only has a boolean
> understanding of output.  I don't know if it is really worthwhile to
> try and encode all the possible configurations in this API.

Ditto for inputs, and of course there's all the pad configuration stuff.

> > - alt_func (pin is in use for some other purpose)

> What is the use-case for alt_func?  From the point of view of a GPIO
> driver, I don't think it cares if the pin has been dedicated to
> something else.  It can twiddle all it wants, but if the pin is routed
> to something else then it won't have any external effects (pin mux is
> often a separate logic block from the gpio controller).  Also with

Not always entirely true, some of the controllers I've worked with have
input and output both as alternate functions among the others there so
selecting input or output mode will tend to force the mode but...

> GPIOs, the engineers fiddling with them *really* needs to know what
> the gpios are routed to.  It is highly unlikely to have any kind of
> automatic configuration of gpios; ie. if it isn't wired as a gpio,
> then don't go twiddling it.

...it doesn't make much difference for the reasons you mention.
