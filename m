Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0IXNGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:06:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57510 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752237Ab0IXNGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:06:23 -0400
Date: Fri, 24 Sep 2010 15:02:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Message-ID: <20100924130241.GB1810@ucw.cz>
References: <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
 <20100830214355.GB28865@core.coreip.homeip.net>
 <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
 <20100830224352.GF28865@core.coreip.homeip.net>
 <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
 <20100831161730.GA30947@core.coreip.homeip.net>
 <20100831175937.70a59a91@lxorguk.ukuu.org.uk>
 <20100831170923.GB30947@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831170923.GB30947@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So a voltmeter really makes no sense. It's not a set of keys and it
> > doesn't give X/Y/Z style readings. Nor does a camera. But a lot of things
> > do fit this to varying degrees.
> > 
> > I'm actually more dubious than Linus about ALS - because ALS tends not
> > produce 'events' but to be sampled, and there are significant power
> > implications to unnecessary polling.

That's very similar to analog joysticks, no?

> > And the more it's used the less special
> > code is needed in user or kernel space for PDAs and phones - instead they
> > just work.
> 
> OK, so let's say we start moving some of the devices into input. Which
> ones we consider suitable for input? I guess some 3-digit
> accelerometers, what else? Also, what new event types would we need?
> Let's take GPS - I do not think that ABS_X and ABS_Y are the best events
> to be used for such devices: I am trying to allow applications being

I'd not put GPS into input; yes, they do present 'x,y,z' in meters,
but that's not what users want. 'lat,lon,alt' is better, but it is
actually 'lat,lon,herror,alt,verror,time' and a lot of other
metadata...

Also, we already have driver for GPSes, its called gpsd. I'd leave
GPSes out of input.

> Also, GPS, liek ALS, would probably be polling, no?

Normally, GPS just sends you position info once a second.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
