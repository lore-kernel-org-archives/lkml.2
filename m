Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2BCVov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:44:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47894 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922Ab2BCVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:44:49 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E124DB9@HQMAIL01.nvidia.com>
References: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
	<CACRpkda+KCutSFgPwH2Xvd14h0OCrArFGXAidp3n_ZgG28KB5g@mail.gmail.com>
	<201202021533.14650.arnd@arndb.de>
	<CACRpkdbMPrvN80cLyVLUNvTjx4ZV4iLeHcJaJyM_qvTHHAfWww@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF178E124DB9@HQMAIL01.nvidia.com>
Date: Fri, 3 Feb 2012 22:44:48 +0100
Message-ID: <CACRpkdbOjNTGJ1F9OsoJuA4ymh5=AMAGAWK-gUcsLbEB+PSENg@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 6:50 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Friday, February 03, 2012 7:57 AM:
>> Which is actually bad enough for me to have second thoughts on
>> this.
>>
>> So I'm taking this branch off from -next until we resolve this.
>
> Seriously? That's lame.

I'm not saying I won't add it back in when we've discussed
this some more.

Several involved people are going to meet in person next week to
discuss this, so let's see what kind of conclusions we can come to.

Try to see it from my point of view: when I presented the pinctrl
subsystem to Torvalds it was with the promise that this would
shrink the stuff stacking up in arch/arm/*, naturally I am afraid
of breaking that promise.

If the end result is that none of the pinctrl stuff gets pulled for
the next merge window, it will hit us all. For that reason I am
requesting more consensus.

What speaks for it, even though it adds a few thousand lines,
is that the added lines are functionality growth, so after this
the T20 and T30 pin muxing is *complete*, and the versions
that used to live up in arch/arm were *incomplete* which
is nice.

What we need to figure out is if we really must have all these
lines of code. And I must have something I can write in
my pull request that justifies it. So I want help with that.

>> (A) open-coded in the driver or
>> (B) provided as data in the device tree
>
> There's really no need for everyone to do the same thing here; it's an
> issue that's completely isolated within the individual drivers, and has
> no effect outside of them, other than kernel size in a multi-SoC kernel.
>
> The main issue with (B) is that it slows down boot time measurably by
> requiring a ton of data to be parsed from it, which entails a bunch of
> string handling. And then, you end up with exactly the same data as if
> you'd just bundled it into the kernel in the first place.

That is for a tailored image for one system. If you compile in a few
dozen platforms as is the goal of the single uImage. In which case
we only end up with the stuff from one device tree and a few slim
drivers with no data in them. (As observed by Arnd.)

But I think we could say that if one is preparing a multi-platform
kernel, one should also take the hit of using an initramfs and as
much modules as possible.

>> nVidia Tegra have opted for the former, Texas OMAP for the latter.
>> The in-kernel drivers also do like Tegra. However they
>> are smaller due to less combinatorics.
>
> Well, I think not so much because the SoCs don't have the same number of
> combinations, but that the drivers don't support all the HW's options.

Yes that's true, we certainly have these different ideas as to
whether the driver shall present all possible options or just
the subset used by current kernel board files. Maybe I should
implement all of U300's pin control just to get an idea of how
much it really is, for comparison.

> Rather, it might be interesting to pursue building the pinctrl drivers
> as modules, but somehow binding them into the kernel image itself, and
> allowing them to be unloaded (like __init functions and __initdata) once
> we know they aren't used. That's somewhat similar to an initramfs, but
> avoids the need to package everything into a filesystem and explicitly
> load it before it can be used.

That is a pretty interesting approach if it could be made to work, but
since the sectioning is done at compile-time I think the currently
endorsed mechanism is using modules and initramfs:es for this.

Yours,
Linus Walleij
