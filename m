Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1LHBTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:19:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41661 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757149Ab1LHBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:19:05 -0500
Date: Thu, 8 Dec 2011 01:19:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Kuzmenko <linux@solonet.org.ua>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111208011904.GD5748@opensource.wolfsonmicro.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com> <4EDAA785.40503@solonet.org.ua> <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com> <4EDFAA0A.7040607@solonet.org.ua> <20111207160002.8b52df42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207160002.8b52df42.akpm@linux-foundation.org>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:00:02PM -0800, Andrew Morton wrote:
> Denis Kuzmenko <linux@solonet.org.ua> wrote:

Hrm, for some reason lots of the mails here didn't reach my inbox...
anyway.

> > > My naive understanding is that you set the current limit and then
> > > the HV transformer (I guess this is a buck converter of some kind)

Boost convertor.  A buck is always step down I beleive.

> > > will raise the voltage level until it either (A) cannot raise it any more
> > > at c:a 20V or (b) the current limit is reached.

> > > I suspect this is because for LEDs of this type you get a
> > > specified current but the voltage just has to be "high enough"
> > > to break through some diode barrier threshold or so. After
> > > that intensity is controlled by limiting the current.

> > > Does this suffice as explanation...?

OK, that's exactly the sort of hardware I thought you were driving.
There's several drivers for this type of LED in the kernel already.

> I won't do anything with this patch yet - I'm waiting to see if Mark
> stops being surprised ;)

I'm still surprised I'm afraid.  The voltage is generally fixed by the
platform (approximately anyway) to be whatever is needed to get the LEDs
to start doing something and the current is varied to control the
brightness with an upper limit configured based on what the LEDs can
carry and what is sane for the physical design (blinding users tends not
to be popular).  The funciton of the current regulator in the system is
to constrain the brightness of the LED so that it doesn't just go to
maximum brightness without burning power on a resistive load.

This means that usually the current control does map fairly directly
onto the LED API brightness, normally with a scaling as the eye
percieves things on a log scale but we expect brightness to be linear.
This scaling may be pre-done by the choice of current limits in the
current regulator.
