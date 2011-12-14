Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1LNOrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:47:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53834 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab1LNOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:47:07 -0500
Date: Wed, 14 Dec 2011 22:47:00 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111214144659.GB14317@opensource.wolfsonmicro.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
 <4EDAA785.40503@solonet.org.ua>
 <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
 <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
 <20111214113714.GJ3072@opensource.wolfsonmicro.com>
 <20111214140155.GB3999@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214140155.GB3999@bnru02.bnr.st.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 07:31:55PM +0530, Shreshtha Kumar SAHU wrote:

> As far as I know some boost converters can be controlled dynamically for
> power optimized operation by PMIC. Yes exactly as you stated, I wanted to
> provide something similar as done to boost converters by exposing current
> control via sysfs. Otherwise this current control from sysfs can be
> completely ignored by the user and simply use brightness for LED control.

Well, there's also devices that don't bother with the PWM and only
implement brightness control via the current limit.

> > It'd seem more natural for the driver to scale both the PWM and current
> > settings with brightness.

> I will try to implement this. In AB5500, PWM provides 1024 steps from 0 to
> full current, and current 16 steps from 2.5mA to 40mA. I need to derive a
> way to optmially change both PWM and current to get requested brigtness in
> range of 0-255 (i.e. LED_OFF to LED_FULL).

> Bur I fear that changing both PWM and current may lead to non linear
> variation and equation needs to be derived to get it correct which will
> add complexity to ab5500_led_brightness_set and hence API brightness.
> In addition if platform sets max current to 10mA then brightness_set()
> will have only 4 steps for current variation and in thus an overhead if
> we combined current and PWM control calculation.

> Please suggest.

It doesn't seem like it should be *too* complex a problem to solve,
it'll depend on how the PWM and the current scale.  If they're both nice
smooth log scales it should be easy enough.
