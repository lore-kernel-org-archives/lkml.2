Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2ECL2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:28:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40393 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2ECL2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:28:07 -0400
Date: Thu, 3 May 2012 13:28:03 +0200
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
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503112803.GA15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503103848.GB3955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:38:48AM +0100, Mark Brown wrote:
> On Thu, May 03, 2012 at 12:26:36PM +0200, Johan Hovold wrote:
> > Add support for National Semiconductor / TI LM3533 lighting power chips.
> > 
> > This is the core driver which provides register access over I2C and
> > registers the ambient-light-sensor, LED and backlight sub-drivers.
> 
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> though
> 
> > +	dev_dbg(lm3533->dev, "read [%02x]: %02x\n", reg, *val);
> 
> I'd expect you can drop these log messages, if there's stuff like this
> missing we should add it to regmap.  At the minute the regmap logging is
> via trace points rather than debug logs as you can leave them enabled
> all the time.

If such debugging is added to regmap we still need a way to enable them
per driver (or rather regmap) to not clutter the logs.

These three dev_dbg statements are extremely useful during debugging /
development especially in combination with the other dynamic printks in
these drivers.

I'd actually prefer just keeping them for now.
 
> Might also be worth moving some of the sysfs stuff to live with the
> relevant drivers.

Which attributes do you have in mind?

The boost_freq and boost_ovp affect both backlight devices (i.e. cannot
be set separately) and as such belong in the parent driver IMO.

Same with the output_hvled{1..2}, output_lvled{1..5} attributes. The
chip has four logical LEDs ("control banks") but five low-voltage output
sinks. The five output_lvled attributes determine the mapping and as
such belong in the parent driver. The two logical backlight devices can
likewise be used to control either or both high-voltage outputs and
belong in the parent driver for the same reasons.

Thanks,
Johan
