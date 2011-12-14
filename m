Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1LNODE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:03:04 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:39845 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757294Ab1LNOCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:02:55 -0500
Date: Wed, 14 Dec 2011 19:31:55 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111214140155.GB3999@bnru02.bnr.st.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
 <4EDAA785.40503@solonet.org.ua>
 <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
 <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
 <20111214113714.GJ3072@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111214113714.GJ3072@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 12:37:15 +0100, Mark Brown wrote:
> On Wed, Dec 14, 2011 at 11:23:58AM +0100, Shreshtha Kumar SAHU wrote:
> 
> > The actual amount of current flowing hence brightness variation can then be
> > altered using PWM, which is also the case in present driver.
> 
> > Hence the idea of current control sysfs interface is provided to further
> > decrease the max current through the LED(s) if required for saving power
> > (but can never exceed the max current set by the platform).
> > After fixing the current, "brightness" interface can be used to control
> > brightness which internally cofigures the PWM register.
> 
> The above basically sounds like you're using the current limit as a way
> of adjusting the maximum brightness dynamically for power saving
> reasons.  This doesn't sound like something that individual drivers
> should be doing, it sounds like something that either the subsystem or
> userspace code ought to be implementing. 

As far as I know some boost converters can be controlled dynamically for
power optimized operation by PMIC. Yes exactly as you stated, I wanted to
provide something similar as done to boost converters by exposing current
control via sysfs. Otherwise this current control from sysfs can be
completely ignored by the user and simply use brightness for LED control.

> It'd seem more natural for the driver to scale both the PWM and current
> settings with brightness.
I will try to implement this. In AB5500, PWM provides 1024 steps from 0 to
full current, and current 16 steps from 2.5mA to 40mA. I need to derive a
way to optmially change both PWM and current to get requested brigtness in
range of 0-255 (i.e. LED_OFF to LED_FULL).
Bur I fear that changing both PWM and current may lead to non linear
variation and equation needs to be derived to get it correct which will
add complexity to ab5500_led_brightness_set and hence API brightness.
In addition if platform sets max current to 10mA then brightness_set()
will have only 4 steps for current variation and in thus an overhead if
we combined current and PWM control calculation.
Please suggest.

Regards,
Shreshtha



