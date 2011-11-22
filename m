Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1KVA0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:26:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39189 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1KVA0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:26:16 -0500
Message-ID: <4ECAECA6.7090109@solonet.org.ua>
Date: Tue, 22 Nov 2011 02:28:22 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
References: <4EC572E1.1020209@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com> <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com> <4EC6DD8F.9070904@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FE6@HQMAIL01.nvidia.com> <4EC6E75E.2080200@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C135@HQMAIL01.nvidia.com> <4ECAA894.4050500@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C246@HQMAIL01.nvidia.com> <4ECAD613.3030605@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C2B4@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C2B4@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 01:39 AM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Monday, November 21, 2011 3:52 PM:
> ...
>>> I don't see any pulls being configured in the original code at all,
>>> unless some of the s3c2410_* function have unexpected side-effect. The
>>> only related thing is in probe:
>>>
>>>         /* no point in having a pull-up if we are always driving */
>>>
>>>         if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
>>> ..
>>>         } else {
>>>                 s3c2410_gpio_pullup(pdata->gpio, 0);
>>>
>>> which I assume disables an pull in the case where the pin is always driven.
>>>
>>> So, yes, I'd say submit v3 without any pull manipulation at all.
>>>
>>
>> Actually, "s3c2410_gpio_pullup(pdata->gpio, 0);" enables pull in the
>> same way I've done that. Here is it's code:
> 
> So it does. That's extremely non-obvious if not broken.
> 
> Anyway, I guess that means that your patch V1 is at least a pure conversion
> of the code from custom functions to gpiolib, even if what it was and still
> is doing doesn't make much sense to me.
> 

So what do you suggest? Leave original behavior?
I'd like to remove pull-related actions at all considering:
 - power consumption
 - we are both not able to find any sense in that code
 - s3c2410_gpio_pullup looks like deprecated
 - can't imagine situation where this change will break functionality
(of course when this code used to drive actually LED and not something else)

-- 
Best regards, Denis Kuzmenko.
