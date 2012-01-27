Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2A0Q7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:59:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16709 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2A0Q7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:59:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 27 Jan 2012 08:58:49 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Fri, 27 Jan 2012 08:58:47 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: Aczc60fV95dWKgpfRCGUGwX1Celm1QAKLkRw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E123E3C@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
	<20120117082334.GA31295@S2101-09.ap.freescale.net>
	<7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D22F5@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885095125@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB445@HQMAIL01.nvidia.com>
 <CACRpkdae58AYCYzwx8ysSDr_i0UHBfCujm2Fmnb+hx7825Lm4w@mail.gmail.com>
In-Reply-To: <CACRpkdae58AYCYzwx8ysSDr_i0UHBfCujm2Fmnb+hx7825Lm4w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Friday, January 27, 2012 5:01 AM:
> On Fri, Jan 20, 2012 at 9:28 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Dong Aisheng wrote at Wednesday, January 18, 2012 4:06 AM:
> >>
> >> Each entry in the list is PIN rather than group.
> >> So we cannot create each map for each entry in the list except we treat the PIN as
> >> A group(this will cause a huge maps and predefined groups and functions).
> >
> > Linusw has NAKd the idea that we should not use these "virtual groups",
> > i.e. he believes they're fine to use if you wish.
> 
> Interesting double inversion here: I NACK to NOT use groups
> this way...

I don't think that's true.

If you did that, you would be /forcing/ people to use virtual pin groups,
which means that the Tegra driver I proposed wouldn't be acceptable
since it only defines groups that actually exist in HW.

> The groups are not "virtual" if they share some physical
> property. Such as being used by the same device.

No, that's not what a virtual group is (I'm the person who came up
with that term, and really the only person using it, so I get to decide
what I mean by it!) I suppose you can mean something different, but that's
just going to be ridiculously confusing.

In HW, there are individual register fields. Each one of these affects
often a single pin, but on some chips n pins at a time. A physical
group would be precisely those groups of pins which the actual HW
registers affect. A virtual group is a SW group that ends up affecting
more than one of those physical groups, since when a virtual groups is
programmed, the pinctrl driver goes and programs n register fields and
hence affects n physical groups.

And those registers and either physical or virtual groups don't have to
be anything to do with muxing. On Tegra, there are certainly groups that
only affect e.g. drive strength and not mux selection.

-- 
nvpublic

