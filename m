Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1KWMun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:50:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51228 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1KWMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C239@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
	<CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
	<CACRpkdapm2cx=QJkPinwteCPZFNNnxVcKqR4f0D8_ikWMTea_g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C17B@HQMAIL01.nvidia.com>
	<CACRpkdZsYrCJoEFM5_mrMCns_2AXYFxCxQc=97-1pJVvrGpiiw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C239@HQMAIL01.nvidia.com>
Date: Wed, 23 Nov 2011 13:50:41 +0100
Message-ID: <CACRpkdaTmCkJiiu+FE+XODj_K_oNy8u7JUzEKTnc_TZFMyd4Xw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:54 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, November 21, 2011 2:44 PM:
>> On Mon, Nov 21, 2011 at 8:00 PM, Stephen Warren <swarren@nvidia.com> wrote:
>> >
>> > int gpio_request_at(unsigned gpio, const char *label, unsigned at);
>>
>> This has a nice look to it, I must admit.
>>
>> Since the pinctrl number space is per-controller this signature
>> will not work. It would have to pass in a pin controller reference
>> too, preferably as struct device * or a string. Else "at" is just
>> a number without meaning. "At *which* controller?"
>
> I'm assuming that each (physical) chip will have one pinctrl driver.
> Therefore, for any GPIO driver (and hence any GPIO number) on that chip,
> there is a single pinctrl driver that's relevant, and hence pinctrl
> driver can be determined directly and internally from the GPIO ID.

Yep that's the assumption behind the current range concept
as well. (And the ranges are used to look up pin controllers for
a certain GPIO.)

> Now that I say it though, I wonder if that assumption is totally valid;
> after all, we're talking about having multiple GPIO controller drivers
> within a (physical) chip, so perhaps having multiple pinctrl drivers
> for different subsets of the pins wouldn't be impossible, albeit pretty
> unlikely and bizarre. Should we just ignore that case?

No but we could postpone dealing with it until there is a
piece of hardware that needs the feature. :-)

> We could deal
> with it by internally creating an aggregate driver if it ever happened.

That's one way, the agregate driver will be more beautiful
if we spread it out across a few separate files in that case.
But let's take that when it hits us.

>> Yes letting gpio_chip hold a reference to the pin controller
>> is equivalent to the pin controller GPIO range holding a
>> reference to the struct gpio_chip * as it can do today.
>
> Yes, those are pretty much the same thing.
>
> Assuming my assumption above is correct, then each GPIO (and GPIO chip)
> maps to a single pinctrl, which makes storing the data easy and static,
> but each pinctrl range might map to different GPIO chips and IDs which
> makes things harder, so I still see some value pushing the data storage
> into GPIO.

I think it's possible to make a patch for that and refactor
the current range concept into that pretty cleanly while
moving along with the current codebase. It would take some time
though, not due to writing code but due to unavoidable discussions
about gpiolib, since people are full of opinions regarding that...

Yours,
Linus Walleij
