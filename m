Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0IMBNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 21:13:10 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:44755 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab0IMBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 21:13:08 -0400
Date: Mon, 13 Sep 2010 11:13:02 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
Message-ID: <20100913011302.GV14056@atomos.longlandclan.yi.org>
References: <20100909000245.GK14056@atomos.longlandclan.yi.org>
 <4C88D668.7030501@jic23.retrosnub.co.uk>
 <20100910063253.GA5895@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910063253.GA5895@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 11:32:54PM -0700, Dmitry Torokhov wrote:
> On Thu, Sep 09, 2010 at 01:43:20PM +0100, Jonathan Cameron wrote:
> > ....
> > > 
> > > Likewise with the PIR sensor, I notice there's a "gesture" input
> > > (MSC_GESTURE)... seems appropriate?  Or am I barking up the wrong tree?
> > Does it look like a button (e.g. is it a straight on off device with
> > no control parameters etc)?

Had a discussion with a few of the people involved on Friday.  For all
intents and purposes, it will look like a "button".  Apparently with the
PIR sensor, nominally the value I get (which is a raw 10-bit reading
from an ADC) will be some high but mostly constant value.  When movement
is detected, it'll shoot up, then down, then settle back to where it
was.

At this point, the sensor controller will send an interrupt.  I can
consider this a "button press"... I suppose I can consider a button
release as being some time after the movement has ceased.  There is a
register that controls sensitivity.  I could make that a
sysfs-adjustable parameter, but ideally if there's a standard interface
for things like trigger sensitivity, I'd like to use that too.

> > Dmitry, what would you put this as and would
> > this be acceptable in input?  
> 
> Phone guys made me add SW_FRONT_PROXIMITY at some point which is
> supposed to be reported when someone covers phone screen with something
> (puts into pocket or talks holding against the cheek). Could be used
> here as well...

I'll have a hunt around for this SW_FRONT_PROXIMITY (it wasn't in kernel
2.6.28) and see if I can bring it in.  The idea here is that when
someone passes this entrance station, it can trigger the LCD/keypad to
light up, turn on security lights...etc.

Thanks for the advice.
Regards,
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
