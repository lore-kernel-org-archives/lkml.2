Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1HHW50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:57:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55679 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1HHW5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
	<20110808081552.GI32513@linux-sh.org>
	<CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
Date: Tue, 9 Aug 2011 07:57:24 +0900
X-Google-Sender-Auth: fn0qZSfuBVpFrJ6J6WwaBxYV-18
Message-ID: <CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
From: Kyungmin Park <kmpark@infradead.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 3:24 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
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

If gpiolib accept the pullup control. gpiolib is better place to
control gpio config.
then remains are the gpio driver strength, and power down mode
control. powerdown pull-up/down, powerdown in/out at samsung gpios.

Thank you,
Kyungmin Park

>
> g.
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
