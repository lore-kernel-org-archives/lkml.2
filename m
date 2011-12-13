Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1LMW44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:56:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64539 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab1LMW4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1751860BDA@HQMAIL01.nvidia.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<CAN1soZztU+gC3tkzXK5m51-+djqqcC_JhiJyc4xys2K_ZxUnGA@mail.gmail.com>
	<CACRpkdYFvRDegS63EQzp8pjRMUj7Ru57bK7a+Qq81OkBXmrCBQ@mail.gmail.com>
	<CAN1soZw=51caZjEoxBx8ch0KiE-kgHQFA1amRcTOyDDKe5Ymzw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1751860BDA@HQMAIL01.nvidia.com>
Date: Tue, 13 Dec 2011 23:56:54 +0100
Message-ID: <CACRpkdb-zb3M4Rfo=DnSQvrO5q1qz8q91-X7ps1Ouyp_jou8pw@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:49 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Haojian Zhuang wrote at Tuesday, December 13, 2011 12:22 AM:

>> Excuse me that I didn't find that patch. Did you merge it into your
>> git tree? The latest patch on pinconf.c is updating pdev->dev to
>> &pdev->dev.
>
> I just hit the same problem. This isn't what my patch addresses.
>
> My patch prevents the pinctrl core from creating a struct device for the
> pin controller, since it already has one.
>
> The problem that Haojian mentions is regarding struct pinctrl_dev, not
> plain device.

Aha, sorry guys I got it all wrong :-/

Yes as it stands now it can only be used from within the pin
control drivers and frameworks themselves, what good is
that...

> I'd suggest modifying all the pin_config_* APIs to take a device name
> rather than a "struct pinctrl_dev *". I'll work on a patch to do this,
> since I'm hitting the same problem.

It can use the struct device * for the pin controller or a device name,
either works fine I guess. But strings are nice, you tend to understand
them.

> An alternative may be to either:
>
> * Add function pinctrl_get_dev_by_name(name)
>
> Or:
>
> * Use dev = bus_find_device_by_name(name) to get the plain device, and
> add a pinctrl_find_dev_by_dev(dev).
>
> Either of those sound more complex though, but I suppose do allow
> direct operation if you somehow do already have the struct pinctrl_dev.

Nah, seems like opening a can of worms, let's keep
that stuff internal. A string is nice.

Thanks,
Linus Walleij
