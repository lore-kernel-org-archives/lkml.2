Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1LNLhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:37:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38599 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697Ab1LNLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:37:21 -0500
Date: Wed, 14 Dec 2011 19:37:15 +0800
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
Message-ID: <20111214113714.GJ3072@opensource.wolfsonmicro.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
 <4EDAA785.40503@solonet.org.ua>
 <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
 <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:23:58AM +0100, Shreshtha Kumar SAHU wrote:

> The actual amount of current flowing hence brightness variation can then be
> altered using PWM, which is also the case in present driver.

> Hence the idea of current control sysfs interface is provided to further
> decrease the max current through the LED(s) if required for saving power
> (but can never exceed the max current set by the platform).
> After fixing the current, "brightness" interface can be used to control
> brightness which internally cofigures the PWM register.

The above basically sounds like you're using the current limit as a way
of adjusting the maximum brightness dynamically for power saving
reasons.  This doesn't sound like something that individual drivers
should be doing, it sounds like something that either the subsystem or
userspace code ought to be implementing.  It'd seem more natural for the
driver to scale both the PWM and current settings with brightness.
