Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab0IIWrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:47:16 -0400
Received: from helicon.mas.viperplatform.net.au ([202.147.75.21]:56775 "EHLO
	helicon.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933261Ab0IIWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:47:01 -0400
Date: Fri, 10 Sep 2010 08:46:55 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
Message-ID: <20100909224655.GT14056@atomos.longlandclan.yi.org>
References: <20100909000245.GK14056@atomos.longlandclan.yi.org>
 <4C88D668.7030501@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C88D668.7030501@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 01:43:20PM +0100, Jonathan Cameron wrote:
> > For the temperature and light sensing... temperature sensors certainly
> > exist in the PC world, and maybe I should look closely at how they are
> > normally done, but I wasn't sure about the light sensor.  I was thinking
> > maybe an input device with some new absolute value reported?
> Light sensing options are currently either /misc or /staging/iio/light.
> 
> There are several different interfaces unfortunately.  IIO can work with
> a bridge (via uinput) to generate input events is that is what you need.
> The interface is still a bit unstable, though it is getting cleaned up
> at the moment.

That's fine.  Since I'm writing the driver from scratch, now is a good
time to put it in its rightful place first time.  I get a reading back
in lux, showing the ambient light detected by the sensor.

It'll be used for deciding whether to brighten up backlighting or turn
on LEDs on a camera, etc.  No specific interrupts or such like are
reported, but that could change.

This morning I also spotted the 'thermal' class, and thermal zones, that
looks like a good fit for the temperature sensor; which just measures
the temperature inside the chassis... in some cases next to components
to keep it warm at night.

hwmon seems like a good fit too.  I'll have a look.

> > Likewise with the PIR sensor, I notice there's a "gesture" input
> > (MSC_GESTURE)... seems appropriate?  Or am I barking up the wrong tree?
>
> Does it look like a button (e.g. is it a straight on off device with
> no control parameters etc)? Dmitry, what would you put this as and would
> this be acceptable in input?  

This I'm not sure of... there's a 16-bit field which reports some
numeric value (the doc I have doesn't mention a unit yet)... I think
this part of the controller is still being developed here.  I'll
probably receive an interrupt when movement is detected, and so that
could be a "button" I guess.

If you could imagine an intercom station on a street front, running
embedded Linux... the PIR sensor could alert the application to
someone's presence.  The question is how to best report this to the
application, ideally using standard interfaces that already exist.
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
