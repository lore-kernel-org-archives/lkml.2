Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2KIXkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 18:40:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35484 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2KIXk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 18:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <509D9089.7020407@wwwdotorg.org>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
 <509D9089.7020407@wwwdotorg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 23:40:06 +0000
X-Google-Sender-Auth: TSgPNavGhWyQisyEwX7kOg056g8
Message-ID: <CACxGe6vBYOoK9JdMV-ppUMuugmXcSfXYnh=-jCZP99BTkqKswg@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 11:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/09/2012 09:28 AM, Grant Likely wrote:
>> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> ...
>>> I do rather suspect this use-case is quite common. NVIDIA certainly has
>>> a bunch of development boards with pluggable
>>> PMIC/audio/WiFi/display/..., and I believe there's some ability to
>>> re-use the pluggable components with a variety of base-boards.
>>>
>>> Given people within NVIDIA started talking about this recently, I asked
>>> them to enumerate all the boards we have that support pluggable
>>> components, and how common it is that some boards support being plugged
>>> into different main boards. I don't know when that enumeration will
>>> complete (or even start) but hopefully I can provide some feedback on
>>> how common the use-case is for us once it's done.
>>
>> From your perspective, is it important to use the exact same .dtb
>> overlays for those add-on boards, or is it okay to have a separate
>> build of the overlay for each base tree?
>
> I certainly think it'd be extremely beneficial to use the exact same
> child board .dtb with arbitrary base boards.
>
> Consider something like the Arduino shield connector format, which I
> /believe/ has been re-used across a wide variety of Arduino boards and
> other compatible or imitation boards. Now consider a vendor of an
> Arduino shield. The shield vendor probably wants to publish a single
> .dtb file that works for users irrespective of which board they're using
> it with.
>
> (Well, I'm not sure that Arduino can run Linux; perhaps that's why you
> picked BeagleBone capes for your document!)

Correct, the Arduino is only an AVR with a tiny amount of ram. No Linux there.

However, Arduino shields are a good example of a use case. I think
there are even some Arduino shield compatible Linux boards out there.

> I suppose it would be acceptable for the shield vendor to ship the .dts
> file rather than the .dtb, and hence need to build the shield .dtb for a
> specific base board.

That would be better I think than relying on a binary. However, some
though needs to go into how to handle base boards that /aren't/ mostly
equivalent. Such as if they have a different GPIO controller. It may
be that for gpios and irqs, the solution really is to use
interrupt-map and create a gpio-map. i2c, spi and others still would
need to become children of the correct bus.

> However, I think the process for an end-user needs to be as simple as
> "drop this .dts/.dtb file into some standard directory", and I imagine
> it'll be much easier for distros/... to make that process work if
> they're dealing with a .dtb that they can just blast into the kernel's
> firmware loader interface, rather than having to also locate the
> base-board .dts/.dtb file, and run dtc and/or other tools on both .dts
> files together.

The base-board .dts is unnecessary. dtc is fully capable of using
/proc/device-tree as the source material.  :-)

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
