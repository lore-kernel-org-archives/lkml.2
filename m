Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1LFXCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:02:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49512 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1LFXCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:02:03 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B7704D@HQMAIL01.nvidia.com>
References: <1322736891-11262-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB0304@HQMAIL01.nvidia.com>
	<CACRpkdZM9vjc+6bkqQi9233j=TYRb3dy4-K_zRtvZhv68fUGTA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1750B7704D@HQMAIL01.nvidia.com>
Date: Wed, 7 Dec 2011 00:02:03 +0100
Message-ID: <CACRpkdaJshh4dzDOH2_bV9VtaMpxf_Uc7kpStOnSJVLWF40e-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2 v5] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, at some point I hit the wrong reply button so the list missed mine
and Stephens replies :-/ sorry. Quoting verbose.

On Mon, Dec 5, 2011 at 6:56 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, December 05, 2011 8:43 AM:
>> On Thu, Dec 1, 2011 at 10:44 PM, Stephen Warren <swarren@nvidia.com> wrote:
>> > Linus Walleij wrote at Thursday, December 01, 2011 3:55 AM:
> ...
>> >> +extern int pin_config_get(struct pinctrl_dev *pctldev, int pin,
>> >> +                       unsigned long *config);
>> >> +extern int pin_config_set(struct pinctrl_dev *pctldev, int pin,
>> >> +                       unsigned long config);
>> >
>> > Should the per-pin APIs take a pin name (char*) instead of a pin number
>> > just like the per-group APIs? That seems more consistent. Currently, only
>> > the pinctrl core -> driver API ever deals with pin numbers, and e.g. the
>> > mapping table only deals with names.
>>
>> But the group definitions deal only with numbers.
>>
>> And the name is not compulsory, and not required to be
>> unique. Which is in turn a side effect of the fact that some chip
>> engineers insist on doing crazy stuff like naming 15 different
>> pins "GND". So requireing them to all be uniquely named
>> could lead to enforcing som arbitrary naming policy which
>> cause a disalignment with terms found in the data sheet,
>> or just bring us full circle back to pin numbers by prefixing
>> or suffixing each name with a number albeit in ASCII...
>>
>> So we'd better stick with numbers ftm, as pointed out
>> we want to get rid of casual use of these functions
>> anyway.
>
> The big problem here is: How do users of these APIs know what the pin
> numbers are? With names, the datasheet presumably gives standard names
> to each pin, whereas the numbering scheme chosen by a pinctrl driver can
> be essentially arbitrary (well, perhaps not with a PLCC package, but
> with others...). I suppose the driver could expose a header with all the
> names in, but it seems like we're trying to get away from that kind of
> thing.
>
> Related, numbers in device tree suck, since there's currently no way of
> using symbolic constants. I suppose the DT parsing code would do a mapping
> from text name to pin number using the driver's exposed table of pins
> though.
>
> Re: unique names: Every pins does have a unique name. "GND" is really
> the semantics of the pin, not its name; it always has some defined ball,
> pad, or pin number which can be included in the name to make it unique.
> I'd certainly vote for making pin names mandatory and unique.

Hm, you are making a perfectly good point about cross-referencing
documentation. And matches my experience.

I certainly have to look into this.

So I need to make pin names
- compulsory
- unique
- reqrite API accessors

I think it can be done since the in-tree drivers have all unique pin
names.

I'll hack on this, it'll be a good step forward.

Yours,
Linus Walleij
