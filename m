Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966378Ab2ERR5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:57:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58104 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965071Ab2ERR5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:57:46 -0400
Date: Fri, 18 May 2012 19:57:42 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Johan Hovold <jhovold@gmail.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] iio: add LM3533 ambient light sensor driver
Message-ID: <20120518175742.GA12894@localhost>
References: <1336040799-18433-3-git-send-email-jhovold@gmail.com>
 <4FA26E9A.8080209@cam.ac.uk>
 <20120503163617.GD15752@localhost>
 <4FA923E7.6050707@cam.ac.uk>
 <20120515164456.GB15632@localhost>
 <4FB2B5EE.6080009@kernel.org>
 <20120516130507.GA10774@localhost>
 <4FB3B7DA.5050306@cam.ac.uk>
 <20120518122725.GB20467@localhost>
 <4FB68809.2010009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB68809.2010009@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 06:34:01PM +0100, Jonathan Cameron wrote:
> On 05/18/2012 01:27 PM, Johan Hovold wrote:

[...]

> > I really think that this should remain a device specific attribute as I
> > originally suggested. It's an integration parameter that needs to be set
> > precisely depending on the actual hardware setup (which analog light
> > sensor and other external components). 
> Then it shouldn't be exposed to userspace.  If there is reason to vary
> it from userspace then it is a calibration parameter and should be
> treated like the other ones we have, if not it should be done from
> dt or platform data.
> > 
> > The lm3533 also supports two types of light sensors: pwm- and analog-
> > output ones. The resistor select settings only applies when in analog
> > mode as the input is always high impedance otherwise. Thus a generic
> > attribute (such as calibscale or hardware gain) shouldn't be used as it
> > will have no effect whatsoever in PWM-mode.
> > 
> > I'm thus back at my original proposal, albeit with a different name (I
> > think a lot of this discussion could have been avoided had I not
> > misnamed the parameter "gain"): 
> > 
> > What:		/sys/bus/iio/devices/iio:deviceX/r_select
> > Description:
> > 		Set the ALS internal pull-down resistor for analog input mode
> > 		(1..127), such that,
> > 
> > 		R_als = 200000 / r_select	(ohm)
> > 
> > 		This setting is ignored in PWM-mode (input is always high
> > 		impedance in PWM-mode).
> > 
> > I don't think much is gained from using ohm as the unit: it just adds
> > complexity and the selected resistor setting will likely not match the
> > input value anyway. It's better that the chip integrators have full
> > control over which resistor setting is actually used so that it matches
> > external components.
> This smacks of something that should never be exposed to users.
> I'd hide it away in platform data.

Fair enough. I'll drop the sysfs param and submit a patch for mfd-next
which adds r_select to the platform data.

Thanks,
Johan
