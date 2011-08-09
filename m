Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1HIKEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:04:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37812 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1HIKEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
	<20110808081552.GI32513@linux-sh.org>
	<CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
Date: Tue, 9 Aug 2011 12:04:06 +0200
Message-ID: <CACRpkdZ4heT7VwO3uaQi7M-4EEOP53z2t88aC+_NY9nDfD28AA@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <Baohua.Song@csr.com>, workgroup.linux@csr.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 8:24 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Aug 8, 2011 at 2:15 AM, Paul Mundt <lethal@linux-sh.org> wrote:
>> On Sun, Aug 07, 2011 at 10:19:33PM -0700, Barry Song wrote:
>>> Now there are many different implementations for GPIO pull configuration, for
>>> example:
>>> s3c_gpio_setpull()
>>> tegra_pinmux_set_pullupdown()
>>> chipcHw_setPinPullup()
>>> gpio_pullup()
>>> s3c2410_gpio_pullup()
>>>
>>> This patch adds a new generic gpio_set_pull API so that all SoCs can have unified
>>> codes.
>>>
>>> Signed-off-by: Barry Song <Baohua.Song@csr.com>
>>
>> For arch/arm/mach-shmobile we also have gpio_pull_up() for board-g4evm.c
>> and gpio_pull_down() for board-mackerel.c. Both of these would benefit
>> from this sort of an API addition.
>
> I think I'm okay with this API change.  Linus, what say you?  How does
> this interact with your plans for pinctrl?

I have already proposed a similar mechanism in the past, so let's
recap:

1.First I proposed to expose gpio_to_chip() so each driver could
  provide any custom functions using foo_gpio_set_foo() or so
  by dereferencing the struct gpio_chip.
  NIXED: due to bad experience with doing exactly this for
  IRQ chips (Grant)

2. Second I added a sort-of generic control function;
   gpio_config() which would sit in gpiolib and take an enum
   for each operation, if one of these would be
   GPIO_SET_PULL, and a second argument would be
   whether to pull it up or down or open collector or
   open drain or schmitt-trigger or whatever. As you see
   the problem is not limited to up/down.
   This is equal to the proposed patch but with two
   arguments and broader scope, can also be used
   for drive strength etc.

3. Alan Cox suggested that we use a more generic
   control function instead so I wrapped it to an ioctl()-
   like operation with an opaque argument instead.
   This is especially good when you need to pass
   data *out* of the function, not just *in*.

4. After talks with Grant I submitted (1) again.

I'm basically happy with anything as long as there is some
progress, right now we're only bikeshedding, so I'm, resting
my case.

Linus Walleij
