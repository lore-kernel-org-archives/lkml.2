Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2ECQqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:46:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38937 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2ECQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:46:45 -0400
Date: Thu, 3 May 2012 18:46:41 +0200
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
Message-ID: <20120503164641.GE15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-4-git-send-email-jhovold@gmail.com>
 <20120503104344.GC3955@opensource.wolfsonmicro.com>
 <20120503115059.GB15752@localhost>
 <20120503145108.GI3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503145108.GI3955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:51:08PM +0100, Mark Brown wrote:
> On Thu, May 03, 2012 at 01:50:59PM +0200, Johan Hovold wrote:
> > On Thu, May 03, 2012 at 11:43:44AM +0100, Mark Brown wrote:
> 
> > > > +		5 - 4.194 s
> > > > +		6 - 8.389 s
> > > > +		7 - 16.78 s
> 
> > > Shouldn't these be controlled by led_blink_set() rather than a custom
> > > ABI?
> 
> > led_blink_set controls the on/off times, but the LM3533 has the two
> > additional rise and fall-time settings which determine the transition
> > time between these states.
> 
> Hrm.  In that case these rise times are very large - I'd expect them to
> cause issues with led_set_blink() users?

They are. The default settings (as fast a transition as possible) will
probably what most people use, and if they start fiddling with the
transition times they probably know what they're doing.

> Though actually I suspect the
> solution here is to pull these out into the framework later; we can
> probably simulate reasonably in software with a lot of brightness
> variable LEDs.

Ok.

> > > > +What:		/sys/class/leds/<led>/max_current
> 
> > > Shouldn't this be set by platform data, the maximum current you can push
> > > through the LEDs seems like a board dependant thing which won't change
> > > dynamically at runtime.  The brightness can already be varied.
> 
> > I fully agree and it is possible to set via the platform data for that
> > reason. The end-customer, however, insisted that even this setting be
> > available through sysfs to facilitate their integration and testing.
> 
> > I'd be willing drop this attribute if requested, as it would only be used
> > during integration and could easily be added back by the end-customer if
> > needed.
> 
> I'd strongly suggest removing this for mainline.  If it's present it
> should at least be limited to the maximum specified in platform data
> (just for safety if nothing else).

Agreed.

Thanks,
Johan
