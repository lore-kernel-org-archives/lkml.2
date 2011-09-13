Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1IMNGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:06:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61473 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1IMNGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:06:24 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A570@HQMAIL01.nvidia.com>
References: <1314869552-5531-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B327A40C@HQMAIL01.nvidia.com>
	<CACRpkdZ1kNbtOqw=X1mmM-bA+Gg2BbmO5_CT0sSQtBCK_WdwYw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B327A570@HQMAIL01.nvidia.com>
Date: Tue, 13 Sep 2011 15:06:23 +0200
Message-ID: <CACRpkdan_g6dBvuXwbAdtHFd14GLkKsKLcHnybTuNGmYiqcStA@mail.gmail.com>
Subject: Re: [PATCH 2/4 v6] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 6:04 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Friday, September 02, 2011 2:12 AM:
>> On Thu, Sep 1, 2011 at 11:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>> >> +static const struct u300_pmx_func u300_pmx_functions[] = {
>> >> +     {
>> >> +             .name = "power",
>> >> +             .groups = { POWERGRP_INDEX },
>> >> +             /* Mask is N/A */
>> >> +     },
>> >
>> > Hmmm. That's a lot of _INDEX defines that'd need to be set up, at least
>> > to fully represent a chip like Tegra. Can the pinmux core be modified
>> > such that the group list is an array of names (char*) rather than the
>> > actual numeric IDs of the groups? Still, perhaps we could use the enum
>> > we already have for this, so perhaps it isn't a big deal...
>>
>> Well I could think about a lot of ways to do this, but it's basically up
>> to the driver, the U300 is just some simple example of what you can
>> do, it's just trying to satisfy the API.
>>
>> Maybe as part of writing the nVidia driver you find a clever
>> mechanism for doing this, if it's looking generally useful at that
>> point then let's move it to the core I'd say.
>
> The reason I asked about the pinmux core handling this is because the
> driver op get_function_groups:
>
> +       int (*get_function_groups) (struct pinctrl_dev *pctldev,
> +                                 unsigned selector,
> +                                 unsigned ** const groups,
> +                                 unsigned * const num_groups);
>
> returns an array of integer indexes. I think the only way to get rid of
> the index definitions in the drivers is to allow get_function_groups to
> return an array of strings instead.

OK good idea, I reworked this interface to get an array of strings
instead, I've been told several times to use strings rather than numbers
when possible, so I think this is the right thing to do.

Check it out in v7!

Yours,
Linus Walleij
