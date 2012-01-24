Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2AXXgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:36:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7898 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2AXXgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:36:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jan 2012 15:36:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jan 2012 15:36:06 -0800
Subject: RE: [PATCH 1/4] pinctrl: add a driver for NVIDIA Tegra
Thread-Topic: [PATCH 1/4] pinctrl: add a driver for NVIDIA Tegra
Thread-Index: Acza777/CXzEUJNHS1+se7+yi/VniwAAK1Fg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB81F1A@HQMAIL01.nvidia.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<CACRpkdZvakueQGYX0wyTFWmpC6wiixj2g1PTuKM4CgEzqJbmig@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF178CB81F06@HQMAIL01.nvidia.com>
 <CACRpkdb5eu+5k98XKkZXA0m0FHEP4XjVGwD9F=Ezm5gVP5WrQQ@mail.gmail.com>
In-Reply-To: <CACRpkdb5eu+5k98XKkZXA0m0FHEP4XjVGwD9F=Ezm5gVP5WrQQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, January 24, 2012 4:28 PM:
> On Wed, Jan 25, 2012 at 12:09 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > [Me]
> >> Why are all of these things (reg bank bit ets) signed?
> >
> > The basic issue is that all of these features are optional for any
> > given pin group. I used -1 to indicate an unsupported feature.
> 
> Ahyeah. Makes sense. Well do it any way that makes sense
> to you. Plus note in the kerneldoc that this is the reason these
> are signed.
> 
> >> Also, things named  *_bit are a bit (no pun intended) binary,
> >> are they containing a single bit? In that case say
> >
> > They're the bit number/shift within a register. Range 0..31
> 
> Can that thing really be negative then?
> Or is it really: u8 foo_bit:5 ?

Only reg needs to be signed/negative; the rest I just did for consistency
in the struct definition; I think an old version of the code wrote -1 to
foo_reg, foo_bank and foo_bit too.

> >> u8 foo:1
> >>
> >> To mark that it's only one bit wide, or u8 foo:4 for four bits
> >> etc.
> >
> > I guess I could be explicit about the max range for each value. It might
> > save up to about 8 bytes per pin group, perhaps less based on how well
> > things pack to u32 boundaries.
> 
> Nah I think you would have to pack the struct with #pragmas for that
> and I don't even know if it'd pack below byte limits. Probably not.

u32 x:4;
u32 y:5;
u32 z:4;

should pack them all together, and adjacent u32s in the struct would be
packed into the struct without padding.

...
> >> func_safe doesn't look like an int either when I look at
> >> the code. It's something else, u8?
> >
> > It's a "enum tegra_mux", which IIRC is technically an int, but unsigned
> > is more consistent with the rest of pinctrl.
> 
> Hm "enum tegra_mux foo" should work fine too then,
> what am I missing here...

Good point. It's because each chip has a different set definition of
enum tegra_mux, and pinctrl-tegra.h is shared across both chips.

-- 
nvpublic

