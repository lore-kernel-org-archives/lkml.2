Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2ECLvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:51:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54529 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab2ECLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:51:03 -0400
Date: Thu, 3 May 2012 13:50:59 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 3/4] leds: add LM3533 LED driver
Message-ID: <20120503115059.GB15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-4-git-send-email-jhovold@gmail.com>
 <20120503104344.GC3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503104344.GC3955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:43:44AM +0100, Mark Brown wrote:
> On Thu, May 03, 2012 at 12:26:38PM +0200, Johan Hovold wrote:
> 
> > +What:		/sys/class/leds/<led>/risetime
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold <jhovold@gmail.com>
> > +Description:
> > +		Set the pattern generator fall and rise times (0..7), where
> > +
> > +		0 - 2048 us
> > +		1 - 262 ms
> > +		2 - 524 ms
> > +		3 - 1.049 s
> > +		4 - 2.097 s
> > +		5 - 4.194 s
> > +		6 - 8.389 s
> > +		7 - 16.78 s
> > +
> 
> Shouldn't these be controlled by led_blink_set() rather than a custom
> ABI?

led_blink_set controls the on/off times, but the LM3533 has the two
additional rise and fall-time settings which determine the transition
time between these states.

> > +What:		/sys/class/leds/<led>/id
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold <jhovold@gmail.com>
> > +Description:
> > +		Get the id of this led (0..3).
> > +
> 
> This should just be a generic LED subsystem thing?

It's related to the output mapping discussed in my previous mail. The
four logical LEDs (0..3) can be used to control either (or all) of the
five low-voltage output. This attribute provides the identity of the
class devices (logical LEDs) which can then be used in the output
mapping (done in the parent device). These id's have been chosen to
correspond to the MFD-id's, but are really device specific.
 
> > +What:		/sys/class/leds/<led>/max_current
> > +Date:		April 2012
> > +KernelVersion:	3.5
> > +Contact:	Johan Hovold <jhovold@gmail.com>
> > +Description:
> > +		Set the full-scale current I_{LED_FULLSCALE} (0..31), where
> > +
> > +		I_{LED_FULLSCALE} = 5mA + max_current * 0.8mA
> > +
> 
> Shouldn't this be set by platform data, the maximum current you can push
> through the LEDs seems like a board dependant thing which won't change
> dynamically at runtime.  The brightness can already be varied.

I fully agree and it is possible to set via the platform data for that
reason. The end-customer, however, insisted that even this setting be
available through sysfs to facilitate their integration and testing.

I'd be willing drop this attribute if requested, as it would only be used
during integration and could easily be added back by the end-customer if
needed.

> It'd also be nicer if the kernel did the calculation for the user.

If it was something that was going to be changed a lot, then yes,
perhaps. But as you point out above, this is generally a fixed setting
set using platform data once by integrators that will have access to
the datasheet and it's current table.

Thanks,
Johan
