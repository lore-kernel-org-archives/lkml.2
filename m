Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1LNJFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:05:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47667 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab1LNJFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <010201ccba2e$9b4564e0$d1d02ea0$%park@samsung.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<010201ccba2e$9b4564e0$d1d02ea0$%park@samsung.com>
Date: Wed, 14 Dec 2011 10:05:42 +0100
Message-ID: <CACRpkdasJkhAdtBSRe4B3rWFdU67HqPKv=Nji3Xnxc2GE3misQ@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:04 AM, Chanho Park <chanho61.park@samsung.com> wrote:

>> ChangeLog v5->v6:
>> - Change to using a pin name as parameter for the
>>   [get|set]_config() functions, as suggested by Stephen Warren.
>>   This is more natural as names will be what a developer has
>>   access to in written documentation etc.
>
>
> I don't agree with it.
> Someone doesn't like to assign a pin name individually because a
> pin number is sufficient to represent each pin.
> We also provide a macro to define a anonymous pin descriptor.
>
> /* Convenience macro to define a single named or anonymous pin descriptor */
> #define PINCTRL_PIN(a, b) { .number = a, .name = b }
> #define PINCTRL_PIN_ANON(a) { .number = a }

That is true, anonymous pins won't be reachable from the
outside. But to some extent that's to be expected.

What turned me around to see things Stephen's way was the fact
that if someone reads this code and finds:

pin_config_set(dev, 42, MY_FUNNY_PULLUP_MACRO);

It is harder to understand than:

pin_config_set(dev, "I2C0 SCL", MY_FUNNY_PULLUP_MACRO);

The second gives and idea about what's going on - you can
look up the pin name "I2C0 SCL" in the datasheet and if
you know something about I2C electronic requirements you
immediately see that "aha, it's pulling up I2C0 SCL line, yeah
that's required of course".

> If we use only the pin name for [get|set]_config(), we must assign the name
> of all pins.

No, you only need to assign a name for the pins you want to
send control commands to. You can still use the pins for
say pinmuxing without naming them.

> IMHO, we also provide pin numbers to control anonymous pins.

Also or instead of? I think the interface needs to be
either names or pin numbers, supporting both will
be confusing.

Is this a blocker for the Samsung way of doing things?

I'm not entirely sure about this ... what do others say?

Yours.
Linus Walleij
