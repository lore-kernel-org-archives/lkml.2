Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab2DXCJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:09:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39884 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2DXCJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:09:21 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120423110912.GC8318@opensource.wolfsonmicro.com>
References: <1335107508.6261.3.camel@phoenix> <20120423110912.GC8318@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 24 Apr 2012 10:09:00 +0800
Message-ID: <CAF+7xWkzy5e0rcpwprEE3VWTikOu2+qtsgfdhTN12-yonDxadA@mail.gmail.com>
Subject: Re: [PATCH] leds: lm3530: fix handling of already enabled regulators
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/23 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Sun, Apr 22, 2012 at 11:11:48PM +0800, Axel Lin wrote:
>
>>               drvdata->regulator = NULL;
>>               goto err_regulator_get;
>>       }
>> +     drvdata->enable = regulator_is_enabled(drvdata->regulator);
>>
>
> This isn't sufficient for what the driver is doing - it also needs to
> enable the regulator.  Regulator enables are reference counted (since
> the regulator can be shared by many device supplies) so if this driver
> doesn't reference the regulator when it's needed then it could get
> powered off.

The regulator_enable() is called in lm3530_init_registers().

>
> If this regulator is the actual LED then the current default of assuming
> the regulator is off on boot isn't ideal either as it means that if the
> regulator is enabled on boot then the LED may be left on even though the
> driver thinks it's off.

Hi Shreshtha,
I think without this patch you can see the symptom Mark mentioned if the
regulator is enabled on boot.
Any chance to test if this patch works or not?

Regards,
Axel
