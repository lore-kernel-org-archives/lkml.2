Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2AXX1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:27:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2AXX1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178CB81F06@HQMAIL01.nvidia.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<CACRpkdZvakueQGYX0wyTFWmpC6wiixj2g1PTuKM4CgEzqJbmig@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF178CB81F06@HQMAIL01.nvidia.com>
Date: Wed, 25 Jan 2012 00:27:31 +0100
Message-ID: <CACRpkdb5eu+5k98XKkZXA0m0FHEP4XjVGwD9F=Ezm5gVP5WrQQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 12:09 AM, Stephen Warren <swarren@nvidia.com> wrote:
> [Me]
>> Why are all of these things (reg bank bit ets) signed?
>
> The basic issue is that all of these features are optional for any
> given pin group. I used -1 to indicate an unsupported feature.

Ahyeah. Makes sense. Well do it any way that makes sense
to you. Plus note in the kerneldoc that this is the reason these
are signed.

>> Also, things named  *_bit are a bit (no pun intended) binary,
>> are they containing a single bit? In that case say
>
> They're the bit number/shift within a register. Range 0..31

Can that thing really be negative then?
Or is it really: u8 foo_bit:5 ?

>> u8 foo:1
>>
>> To mark that it's only one bit wide, or u8 foo:4 for four bits
>> etc.
>
> I guess I could be explicit about the max range for each value. It might
> save up to about 8 bytes per pin group, perhaps less based on how well
> things pack to u32 boundaries.

Nah I think you would have to pack the struct with #pragmas for that
and I don't even know if it'd pack below byte limits. Probably not.

The valid usecase is for static code analyzers like people tend to
run on military systems and such and loop over every state
of a code path, this restricts the search space.

But it's admittedly *very* esoteric.

>> func_safe doesn't look like an int either when I look at
>> the code. It's something else, u8?
>
> It's a "enum tegra_mux", which IIRC is technically an int, but unsigned
> is more consistent with the rest of pinctrl.

Hm "enum tegra_mux foo" should work fine too then,
what am I missing here...

> On Tegra20, each of these features is configured at a pin group level;
> there is a single register field that affects multiple pins at once.
> (...)
> Tegra30 is somewhat simpler; each pin can be mux'd separately,
> (...)
> some advanced
> drive-strength-related parameters are still configured at a pin-group
> level not a per-pin level, and again not all groups support every
> parameter.

This actually makes me understand what makes Tegra so special
when it comes to muxing, it's the mix of group-level control in
one architecture and pin-level control in another.

For my systems U300 is a pure Tegra20 type, Nomadik is
pure per-pin controlled. This mixture of group and pin-level
control is what makes the Tegra30 so special, with all effects
on how we model it etc...

Yours,
Linus Walleij
