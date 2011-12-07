Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1LGOHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:07:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46821 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1LGOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:07:06 -0500
MIME-Version: 1.0
In-Reply-To: <4EDAA785.40503@solonet.org.ua>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
	<4EDAA785.40503@solonet.org.ua>
Date: Wed, 7 Dec 2011 15:07:05 +0100
Message-ID: <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
From: Linus Walleij <linus.walleij@linaro.org>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 11:49 PM, Denis Kuzmenko <linux@solonet.org.ua> wrote:

> (snip)
>> diff --git a/drivers/leds/leds-ab5500.c b/drivers/leds/leds-ab5500.c
> (snip)
>> +/*
>> + * Driver for HVLED in ST-Ericsson AB5500 analog baseband controller
>> + *
>> + * This chip can drive upto 3 leds, of upto 40mA of led sink current.
>
> Can't get these are High Voltage or High Current LEDs?
> If Voltage why haven't you wrote about supplied voltage but wrote about
> max. current?

The three channels are indeed high-voltage LEDs, they supply
up to 20V from a supply voltage of some standard mobile handset
battery at say 3.8 V or so. But there is no register to control the
voltage or anything like that.

My naive understanding is that you set the current limit and then
the HV transformer (I guess this is a buck converter of some kind)
will raise the voltage level until it either (A) cannot raise it any more
at c:a 20V or (b) the current limit is reached.

I suspect this is because for LEDs of this type you get a
specified current but the voltage just has to be "high enough"
to break through some diode barrier threshold or so. After
that intensity is controlled by limiting the current.

Does this suffice as explanation...?

Yours,
Linus Walleij
