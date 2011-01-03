Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1ACOyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:54:41 -0500
Received: from imr4.ericy.com ([198.24.6.8]:34939 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab1ACOyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:54:40 -0500
Date: Mon, 3 Jan 2011 06:53:40 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Urs Fleisch <urs.fleisch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-ID: <20110103145340.GA25600@ericsson.com>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
 <4D1DF097.1080200@cam.ac.uk>
 <20110103081448.f96c413e.urs.fleisch@gmail.com>
 <4D21ADCB.4070206@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D21ADCB.4070206@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 06:06:51AM -0500, Jonathan Cameron wrote:
> On 01/03/11 07:14, Urs Fleisch wrote:
> > Hi Jonathan,
> When posting an updated driver, use the form
> [PATCH V2] hwmon: driver...
> 
> That way it will be obvious to people that it isn't just a repost of the
> previous code.
> >
> > Thanks for reviewing the patch. I have fixed the issues you reported and the
> > style problems.
> >
> >> Sorry, but this isn't going to be acceptable.  Classic case of magic numbers.
> >> This needs to be broken up into several different attributes.
> >> We have:
> >> * control over the measurement resolution (which is somewhat fiddly
> >> on this device)
> >> * Battery voltage threshold > 2.25V
> >> * Enable on chip heater
> >
> >> So this one is the only one I have problem with. Other two attributes are
> >> standard (well humidity is pretty unusual but no one ever complained about
> >> the sht15 afaik!)
> >
Might make sense to document it in the ABI, though.

> > The user_register attribute is now replaced by
> > temp1_resolution_bits, humidity1_resolution_bits,
> Those two aren't in the documentation for hwmon.
> Guenter/Jean, how should this be done?
> Is there actualy a use case that means these can't both be set
> by platform data?  Also, if these are acceptable, should they have
> some means of indicating which combination of values are available?
> 
> > in0_min_alarm, heater_enable
> > attributes. in0_min_alarm is used for the "end of battery" state, the other
> > attributes are non-standard. Unfortunately, the temperature and humidity
> > resolutions are not independent. Is this acceptable?
> Up to maintainers.  Other than trying to work out some way of indicating valid
> options for the two resolution attributes I'd be happy with these.

I am opposed to non-ABI attributes. That doesn't mean that I am opposed to
extending the ABI; if the ABI needs to be extended, it should be extended
instead of providing non-standard attributes. But there should be a use case
for extending the ABI - meaning new ABI attributes should provide value not just
for one chip, but for others as well.

sysfs attributes should only be used for values expected to change during
runtime. "resolution" and "heater_enable" sounds like it might fit better into
platform data. System wide information can also be set using driver parameters.

> >
> >>> +   userreg_changed = status ^ SHT21_RES_MASK;
> >> This needs a comment.  Why exclusive or with a mask?
> >>> +   if (status != userreg_changed) {
> >>> +           dev_err(&client->dev, "user register settings did not stick\n");
> >> This does seem a somewhat paranoid check. Is it really needed in
> >> a production driver?  If this has been seen in the wild, then fair enough!
> >
> > The resolution bits of the user register are toggled and read back to make
> > sure that this is really an SHT21 device.\
> Rely on platform data to get this right rather than an adhoc test that
> might well pass on some random devices.
> 
Yes.

Guenter
