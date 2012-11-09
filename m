Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2KIXYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 18:24:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41278 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2KIXX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 18:23:57 -0500
Message-ID: <509D9089.7020407@wwwdotorg.org>
Date: Fri, 09 Nov 2012 16:23:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
In-Reply-To: <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 09:28 AM, Grant Likely wrote:
> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
...
>> I do rather suspect this use-case is quite common. NVIDIA certainly has
>> a bunch of development boards with pluggable
>> PMIC/audio/WiFi/display/..., and I believe there's some ability to
>> re-use the pluggable components with a variety of base-boards.
>>
>> Given people within NVIDIA started talking about this recently, I asked
>> them to enumerate all the boards we have that support pluggable
>> components, and how common it is that some boards support being plugged
>> into different main boards. I don't know when that enumeration will
>> complete (or even start) but hopefully I can provide some feedback on
>> how common the use-case is for us once it's done.
> 
> From your perspective, is it important to use the exact same .dtb
> overlays for those add-on boards, or is it okay to have a separate
> build of the overlay for each base tree?

I certainly think it'd be extremely beneficial to use the exact same
child board .dtb with arbitrary base boards.

Consider something like the Arduino shield connector format, which I
/believe/ has been re-used across a wide variety of Arduino boards and
other compatible or imitation boards. Now consider a vendor of an
Arduino shield. The shield vendor probably wants to publish a single
.dtb file that works for users irrespective of which board they're using
it with.

(Well, I'm not sure that Arduino can run Linux; perhaps that's why you
picked BeagleBone capes for your document!)

I suppose it would be acceptable for the shield vendor to ship the .dts
file rather than the .dtb, and hence need to build the shield .dtb for a
specific base board.

However, I think the process for an end-user needs to be as simple as
"drop this .dts/.dtb file into some standard directory", and I imagine
it'll be much easier for distros/... to make that process work if
they're dealing with a .dtb that they can just blast into the kernel's
firmware loader interface, rather than having to also locate the
base-board .dts/.dtb file, and run dtc and/or other tools on both .dts
files together.
