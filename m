Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab1IUIZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:25:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51503 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IUIZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
Date: Wed, 21 Sep 2011 10:25:06 +0200
Message-ID: <CACRpkdY5ETbJxSpwJL-7KZhjOnhwrdT1=djwByek75ye=S9L9w@mail.gmail.com>
Subject: Re: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:15 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Friday, September 16, 2011 6:14 AM:
>> +     for (i = 0; i < ARRAY_SIZE(u300_mux_hogs); i++) {
>> +             struct pinmux *pmx;
>> +             int ret;
>> +
>> +             pmx = pinmux_get(u300_mux_hogs[i].dev, NULL);
>> +             if (IS_ERR(pmx)) {
>> +                     pr_err("u300: could not get pinmux hog %s\n",
>> +                            u300_mux_hogs[i].name);
>> +                     continue;
>> +             }
>> +             ret = pinmux_enable(pmx);
>> +             if (ret) {
>> +                     pr_err("u300: could enable pinmux hog %s\n",
>> +                            u300_mux_hogs[i].name);
>> +                     continue;
>> +             }
>> +             u300_mux_hogs[i].pmx = pmx;
>> +     }
>> +     return 0;
>> +}
>> +subsys_initcall(u300_pinmux_fetch);
>
> Why not just have the pinmux core support hogging on non-"system" mapping
> entries; then everything I quoted above except u300_pinmux_map[] could
> be deleted, and the "hog" flag set on the last 3 u300_pinmux_map[] entries.

Very good question, luckily I have a good answer.

There is no way for the pinmux core to traverse the system and look
up the apropriate struct device * pointers.

When/if we have device tree support, I think this will be possible, then I
will be able to have the pinmux hog look up devices from device tree
and hog their pinmux.

At that point we'll likely have the mapping in the device tree too and
the core does not need to be involved at all.

What I could do right now is add some open-ended function like
pinmux_hog_device_pinmuxes(struct device **devices);
that can take an array of devices and hog their respective
pinmuxes in the hog list. Do you think it's a good idea?

Yours,
Linus Walleij
