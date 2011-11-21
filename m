Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1KUWDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:03:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16879 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1KUWDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:03:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Nov 2011 14:03:30 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Mon, 21 Nov 2011 14:03:26 -0800
Subject: RE: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Index: AcyohMjQntJZRTFQQiCm9IqEFYCIpAAFAuHg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C246@HQMAIL01.nvidia.com>
References: <4EC572E1.1020209@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
 <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com>
 <4EC6DD8F.9070904@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FE6@HQMAIL01.nvidia.com>
 <4EC6E75E.2080200@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C135@HQMAIL01.nvidia.com>
 <4ECAA894.4050500@solonet.org.ua>
In-Reply-To: <4ECAA894.4050500@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Monday, November 21, 2011 12:38 PM:
> On 11/21/2011 08:07 PM, Stephen Warren wrote:
> > Denis Kuzmenko wrote at Friday, November 18, 2011 4:17 PM:
> >> On 11/19/2011 12:44 AM, Stephen Warren wrote:
...
> >>> OK, I see the need for a pull of some kind (although aren't there meant
> >>> to be ESD protection diodes for this purpose; relying on what are probably
> >>> pretty weak pullup/down resistors doesn't seem like it will provide much
> >>> protection at all).
> >>
> >> I don't mean pull as any kind of good protection. But it's much better
> >> to have it than not.
> >
> > Hmm. I'm not entirely convinced. If the board already has a pull-up/down,
> > it seems like it won't really make much difference to ESD, and you can't
> > make any assumptions in the core driver about whether such an external
> > resistor is already present. In fact, adding another pull resistor inside
> > the SoC in parallel will reduce the overall resistance, and increase wasted
> > power.
> >
> 
> 	I don't think it's a real protection. It's rather "mistake-proofing"
> (Poka-Yoke).
> 	You are right, I didn't considered additional pulls (however I can't
> imagine tristate LED usage with additional external pull) and power
> consumptions.
> 	I was just wondering, why was pull needed in previous implementation.
> Additional ESD protection was the only thing I could imagine. I don't
> think it's needed there and I'm OK to remove pull-related code.
> 	So I'll remove it, test and send patch V3?

I don't see any pulls being configured in the original code at all,
unless some of the s3c2410_* function have unexpected side-effect. The
only related thing is in probe:

        /* no point in having a pull-up if we are always driving */

        if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
..
        } else {
                s3c2410_gpio_pullup(pdata->gpio, 0);

which I assume disables an pull in the case where the pin is always driven.

So, yes, I'd say submit v3 without any pull manipulation at all.

-- 
nvpublic

