Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2BVGIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:08:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61932 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2BVGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:08:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.178.73 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC368@HQMAIL01.nvidia.com>
References: <1329831275-21769-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BC368@HQMAIL01.nvidia.com>
Date: Wed, 22 Feb 2012 07:08:23 +0100
Message-ID: <CACRpkdbuCMV0k=bfST65ZNojzUQVvDpbOB=-NN=wd3Hc7Mj_MQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: spawn U300 pinctrl from the COH901 GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
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

On Tue, Feb 21, 2012 at 7:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Tuesday, February 21, 2012 6:35 AM:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This solves the riddle on how the U300 pin controller shall be
>> able to reference the struct gpio_chip even though these are
>> two separate drivers: spawn the pinctrl child from the GPIO
>> driver and pass in the struct gpio_chip as platform data.
>> In the process we rename the U300 "pinmux-u300" to
>> "pinctrl-u300" so as not to confuse.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> That's quite a neat solution, but it's not going to work very well with
> device tree, if U300 is being converted to it.

Right now it looks like it won't happen.

U300 has a hard-coded bootloader I cannot change so cannot pass
DT from bootloader.

I cannot use attached device tree either, since those can only be
attached to compressed kernels, and U300 uses uncompressed
kernels.

If I try to fix either of the above, I have so much problems to
fix that probeing of the devices is going to be eclipsed by
those issues :-D

> I'd thought about doing the following for Tegra, where we're cheating a
> little with the gpio range base value:
>
> When GPIO driver is probed, call a function in the pinctrl driver to
> tell it what the "struct gpio_chip *" value is.
>
> When pinctrl is probed, if that call has happened, go ahead and register
> the GPIO range, else don't.
>
> In the call from GPIO to pinctrl, if the pinctrl driver has already
> probed, register the GPIO range, else just save the gpio_chip value for
> later use in the pinctrl driver's probe.
>
> This way, the communication is explicit in code in the drivers, works
> whichever order the drivers probe, etc.
>
> Does that sound like a reasonable solution?

Sure anything that works and can be understood... the root of the
problem is the global GPIO pin space anyway, so we will have to live
with any solutions to patch around it until that happens.

Maybe some of the above described mechanisms can ge
generalized though?

Thanks,
Linus Walleij
