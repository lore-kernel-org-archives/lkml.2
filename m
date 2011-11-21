Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1KUVyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:54:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15737 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1KUVyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:54:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Nov 2011 13:54:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Date: Mon, 21 Nov 2011 13:54:33 -0800
Subject: RE: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Topic: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Index: AcyolrvSw7DLYQ3sRGmFm1SkcBG4iAAAEFjw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C239@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
	<CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
	<CACRpkdapm2cx=QJkPinwteCPZFNNnxVcKqR4f0D8_ikWMTea_g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C17B@HQMAIL01.nvidia.com>
 <CACRpkdZsYrCJoEFM5_mrMCns_2AXYFxCxQc=97-1pJVvrGpiiw@mail.gmail.com>
In-Reply-To: <CACRpkdZsYrCJoEFM5_mrMCns_2AXYFxCxQc=97-1pJVvrGpiiw@mail.gmail.com>
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

Linus Walleij wrote at Monday, November 21, 2011 2:44 PM:
> On Mon, Nov 21, 2011 at 8:00 PM, Stephen Warren <swarren@nvidia.com> wrote:
...
> > I thought I'd sent this on Friday, but perhaps I only thought it up over
> > the weekend... Here's my proposal:
> >
> > 1)
> >
> > Add a new gpiolib API:
> >
> > int gpio_request_at(unsigned gpio, const char *label, unsigned at);
> 
> This has a nice look to it, I must admit.
> 
> Since the pinctrl number space is per-controller this signature
> will not work. It would have to pass in a pin controller reference
> too, preferably as struct device * or a string. Else "at" is just
> a number without meaning. "At *which* controller?"

I'm assuming that each (physical) chip will have one pinctrl driver.
Therefore, for any GPIO driver (and hence any GPIO number) on that chip,
there is a single pinctrl driver that's relevant, and hence pinctrl
driver can be determined directly and internally from the GPIO ID.

Now that I say it though, I wonder if that assumption is totally valid;
after all, we're talking about having multiple GPIO controller drivers
within a (physical) chip, so perhaps having multiple pinctrl drivers
for different subsets of the pins wouldn't be impossible, albeit pretty
unlikely and bizarre. Should we just ignore that case? We could deal
with it by internally creating an aggregate driver if it ever happened.

...
> Yes letting gpio_chip hold a reference to the pin controller
> is equivalent to the pin controller GPIO range holding a
> reference to the struct gpio_chip * as it can do today.

Yes, those are pretty much the same thing.

Assuming my assumption above is correct, then each GPIO (and GPIO chip)
maps to a single pinctrl, which makes storing the data easy and static,
but each pinctrl range might map to different GPIO chips and IDs which
makes things harder, so I still see some value pushing the data storage
into GPIO.

> Any solution like the above needs to be anchored with the
> GPIO maintainer anyway.
> 
> My past attempts to patch gpio_chip have been shot down,
> pinctrl was created to get away from having to introduce any kind of
> control or muxing in gpiolib drivers. The current ranges are
> totally encapsulated in the pinctrl subsystem and that's a pretty
> nice feature I suspect.

Yes, that's all true.

-- 
nvpublic

