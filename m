Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0EQUAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:00:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43039 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0EQUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:00:23 -0400
Date: Mon, 17 May 2010 21:00:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Philippe R?tornaz <philippe.retornaz@epfl.ch>,
       linux-arm-kernel@lists.infradead.org, maramaopercheseimorto@gmail.com,
       sameo@linux.intel.com, s.hauer@pengutronix.de,
       linux-kernel@vger.kernel.org, rpurdie@linux.intel.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 1/2] mc13783: add LED support
Message-ID: <20100517200017.GA25262@sirena.org.uk>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch> <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch> <20100517190242.GA17604@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517190242.GA17604@pengutronix.de>
X-Cookie: I had pancake makeup for brunch!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 09:02:42PM +0200, Uwe Kleine-K?nig wrote:
> On Mon, May 17, 2010 at 06:40:22PM +0200, Philippe R?tornaz wrote:

> > +static void mc13783_led_set(struct led_classdev *led_cdev,
> > +			   enum led_brightness value)
> > +{
> > +	struct mc13783_led *led;
> > +
> > +	led = container_of(led_cdev, struct mc13783_led, cdev);
> > +	led->new_brightness = value;
> > +	schedule_work(&led->work);
> > +}

> I wonder why you don't set the registers directly here, but use a work
> struct instead.

The LED API allows clients to configure the LEDs from interrupt context
so for devices on blocking buses (like this) the driver needs to defer
the actual implementation of the change.

It'd be nice to add helpers for this to the LED core, there's quite a
few drivers implementing this idiom now - a flag that does the deferring
of the set() for example.
