Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1ACSKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:10:15 -0500
Received: from imr3.ericy.com ([198.24.6.13]:43646 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1ACSKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:10:13 -0500
Subject: Re: [PATCH] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Urs Fleisch <urs.fleisch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
In-Reply-To: <4D21ADCB.4070206@cam.ac.uk>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
	 <4D1DF097.1080200@cam.ac.uk>
	 <20110103081448.f96c413e.urs.fleisch@gmail.com>
	 <4D21ADCB.4070206@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 3 Jan 2011 10:09:19 -0800
Message-ID: <1294078159.9786.9.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 06:06 -0500, Jonathan Cameron wrote:
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
I have been thinking about this, and would like to get Jean's input.

Humidity doesn't really sound like "hardware monitoring"; more like
environmental monitoring. But on the other side, even though humidity
doesn't really monitor the HW, it does monitor operational conditions,
and its reported values may have impact on system operation (eg cause a
shutdown if humidity is too high, to prevent HW damage).

So question is if hwmon should include explicit environmental monitoring
attributes or not, and if hwmon and environmental monitoring can and
should be separated to start with (for example, what if any is the
difference between environment temperature and hw monitoring
temperature ?).

Thoughts, anyone ?

Guenter


