Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0EZMBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:01:37 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60469 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0EZMBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:01:36 -0400
Subject: Re: [PATCH 1/2] mc13783: add LED support
From: Richard Purdie <rpurdie@rpsys.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Philippe R?tornaz <philippe.retornaz@epfl.ch>,
       linux-arm-kernel@lists.infradead.org, maramaopercheseimorto@gmail.com,
       sameo@linux.intel.com, s.hauer@pengutronix.de,
       linux-kernel@vger.kernel.org, valentin.longchamp@epfl.ch
In-Reply-To: <20100517200017.GA25262@sirena.org.uk>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
	 <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch>
	 <20100517190242.GA17604@pengutronix.de>
	 <20100517200017.GA25262@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 13:01:08 +0100
Message-ID: <1274875268.24079.1.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 21:00 +0100, Mark Brown wrote:
> On Mon, May 17, 2010 at 09:02:42PM +0200, Uwe Kleine-K?nig wrote:
> > On Mon, May 17, 2010 at 06:40:22PM +0200, Philippe R?tornaz wrote:
> 
> > > +static void mc13783_led_set(struct led_classdev *led_cdev,
> > > +			   enum led_brightness value)
> > > +{
> > > +	struct mc13783_led *led;
> > > +
> > > +	led = container_of(led_cdev, struct mc13783_led, cdev);
> > > +	led->new_brightness = value;
> > > +	schedule_work(&led->work);
> > > +}
> 
> > I wonder why you don't set the registers directly here, but use a work
> > struct instead.
> 
> The LED API allows clients to configure the LEDs from interrupt context
> so for devices on blocking buses (like this) the driver needs to defer
> the actual implementation of the change.
> 
> It'd be nice to add helpers for this to the LED core, there's quite a
> few drivers implementing this idiom now - a flag that does the deferring
> of the set() for example.

Agreed, or a wrapper around the core which deferred implementations
could just use. I'm open to patches :)

Cheers,

Richard


