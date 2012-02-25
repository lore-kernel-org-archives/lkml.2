Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2BYEQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 23:16:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34293 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2BYEQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 23:16:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dongas86@gmail.com designates 10.236.157.10 as permitted sender) smtp.mail=dongas86@gmail.com; dkim=pass header.i=dongas86@gmail.com
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC8F@HQMAIL01.nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
	<20120224032451.GA25789@shlinux2.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC1F@HQMAIL01.nvidia.com>
	<20120224070952.GD25789@shlinux2.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC8F@HQMAIL01.nvidia.com>
Date: Sat, 25 Feb 2012 12:16:16 +0800
Message-ID: <CAA+hA=SbGvdP5+RXXyb9BKg-F0XNKUG01cLmgfgWg_1=gTOdNA@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define, and
 use it
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 1:32 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Dong Aisheng wrote at Friday, February 24, 2012 12:10 AM:
>> On Thu, Feb 23, 2012 at 09:26:14PM -0800, Stephen Warren wrote:
>> > Dong Aisheng wrote at Thursday, February 23, 2012 8:25 PM:
>> > > On Fri, Feb 24, 2012 at 08:04:38AM +0800, Stephen Warren wrote:
>> > > > This provides a single centralized name for the default state.
>> > > >
>> > > > Update PIN_MAP_* macros to use this state name, instead of requiring the
>> > > > user to pass a state name in.
>> > ...
>> > > > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
>> > ...
>> > > > -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
>> > > > +       PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
>> > >
>> > > To keep align with the following
>> > > PIN_MAP_SYS_HOG("pinmux-u300", "power"),
>> > > Maybe PIN_MAP("pinctrl-foo", "i2c0", "foo-i2c.0") is better, right?
>> > >
>> > > And we may want to add a PIN_MAP_STAT macro, as well as PIN_MAP_SYS_HOG_STAT.
>> >
>> > I don't think so.
>> >
>> > PIN_MAP_SYS_HOG hard-codes the state name inside the macro because its
>> > sole purpose is to support drivers/pinctrl/core.c's pinctrl_get() call
>> > for pin hogging purposes, so that state name is always "default", or
>> > rather, PINCTRL_STATE_DEFAULT.
>>
>> I'm considering that we may also need to support multi states for system hog
>> functions, do you agree?
>
> Well, I don't think that'd be hogging; to my mind, hogging is specifically
> setting up PINCTRL_STATE_DEFAULT when a pin controller is registered.
>
The hogging is determined by the device name not state name.
And i can see there may be need for different pin config setting for
system hog function
during different state like suspend and resume.
So the hog function may have different state like suspend and resume.

> But yes, I can see that the pinctrl core might want to use other state
> names for a pin controller, e.g. for suspend/resume, when unregistering
> the pin controller driver, etc.
>
> That's exactly why in the mapping table rework patch I posted, I wrote
> a single all-encompassing table entry macro that'd work for all these
> situations, without the need to create a ton of special-case macros.
>
Looks good, Will see it.

> Still, I suppose now I've already enhanced that patch to support a few
> special case macros, I can add yet more. But, please can I defer this
> to that later patch rather than this one, since I'm already reworking
> all the macros there to support the enhanced mapping table format for
> pin config too?
>
Of course, yes.
It's ok to me since actually it's not a big deal.

>> > BTW, did you have any further thoughts on (not) allowing NULL state names?
>> > I'd like to repost the final version of that patch, or rework it so that
>> > the code actually does allow NULL state names ASAP (i.e. early Friday for
>> > me), since it blocks some of the later patches in the series. Thanks.
>>
>> Personally i wish to support NULL state name.
>> But if it really can't, i can also accept no NULL state names.
>
> OK, can I take that as an ACK for my patch that completely removes the
> partial support for them ("Assume map table entries can't have a NULL
> name filed")?
>
Yes, please take my ACK.
I may miss something since i've not read over all your patches.
You're the main contributor of the dt binding proposal and you may
know it better
We can go for forward to see what we get if you think disallow NULL
name is better.

>> You mentioned it may cause many problems on DT side to support NULL state.
>> I'm still thinking the problems we're facing for dt and if we can fix it.
>>
>> Thinking the model we discussed in Linaro connect:
>> sdhci@c8000200 {
>>       pinctrl-0 = <&pmx_sdhci &pmx_sdhci_active>;
>>       pinctrl-1 = <&pmx_sdhci &pmx_sdhci_standby>;
>>       /* An optional list of state names; depends on SDHCI driver */
>>       pinctrl-names = "active", "suspend";
>> };
>> The orginally purpose will convert the id of pinctrl-0 (eg. it's '0' here)
>> to be the state name if no pincgtrl-names property defined.
>> I'm wondering can we not use that id, just treat this case as no state names?
>> If that we can allow dt to define null state names.
>> And it's easy for map writers to write such map.
>>
>> But i do not know how much troubles it will be caused in implementation since
>> you're writing all these code.
>>
>> What do you think of it?
>
> That sure seems like adding a special-case to the device tree parsing
> code solely to provide justification for a special case in the mapping
> table processing code.
>
> My root issue here: Why do we want a NULL name field? It serves no
The original reason to me is that 1) the mandatory state name does not
make too much sense for those devices which do not support multi
states.
2) And we do not need to change pinctrl_get(dev, NULL) to pinctrl_get(dev,
PINCTR_DEFAULT_STATE) for device drivers already in kernel if allow
NULL state name.
3) it also simplify the dt pinctrl map writing (do not need to add
"default" state name for devices not support multi states).

> benefit that I can see, slightly complicates the code, obscures information
> in device drivers (since they aren't requesting a particular state name)
This is true.

> and the pinctrl debugfs files (since we have these unnamed states, so
> people need to know what that means), etc.
Maybe define these unnamed states to a special name to tell people that means
not support multi states, right?

>
> Given I've agreed to make macros that set .name = PINCTRL_STATE_DEFAULT
> so that no mapping table author will need to do this, I don't think that
For non-dt, yes, for dt we still can not use such macros right?

> having .name=PINCTRL_STATE_DEFAULT is going to save anything either.
>

Regards
Dong Aisheng
