Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2KLQwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:52:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59201 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2KLQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:52:36 -0500
Message-ID: <50A12950.6090808@wwwdotorg.org>
Date: Mon, 12 Nov 2012 09:52:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
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
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com>
In-Reply-To: <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 05:10 AM, Pantelis Antoniou wrote:
> Hi Stephen,
> 
> On Nov 10, 2012, at 1:23 AM, Stephen Warren wrote:
> 
>> On 11/09/2012 09:28 AM, Grant Likely wrote:
>>> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> ...
>>>> I do rather suspect this use-case is quite common. NVIDIA certainly has
>>>> a bunch of development boards with pluggable
>>>> PMIC/audio/WiFi/display/..., and I believe there's some ability to
>>>> re-use the pluggable components with a variety of base-boards.
>>>>
>>>> Given people within NVIDIA started talking about this recently, I asked
>>>> them to enumerate all the boards we have that support pluggable
>>>> components, and how common it is that some boards support being plugged
>>>> into different main boards. I don't know when that enumeration will
>>>> complete (or even start) but hopefully I can provide some feedback on
>>>> how common the use-case is for us once it's done.
>>>
>>> From your perspective, is it important to use the exact same .dtb
>>> overlays for those add-on boards, or is it okay to have a separate
>>> build of the overlay for each base tree?
>>
>> I certainly think it'd be extremely beneficial to use the exact same
>> child board .dtb with arbitrary base boards.
>>
> 
> Oh yes. In fact if one was to use a single kernel image for beagleboard
> and beaglebone, for the cape to work for both, it is required for it's
> dtb to be compatible. 

Well, as Grant pointed out, it's not actually strictly necessary for the
.dtb to be compatible; only the .dts /need/ be compatible, and the .dtb
can be generated at run-time using dtc for example.

Of course, relying on .dts compatibility rather than .dtb compatibility
might negatively impact the complexity of an initrd environment if we
end up loading overlays from there...

> We're not there yet, but people would like to have an upgrade path.
> 
> beaglebone -> beagleboard -> pandaboard -> future-boards
> 
> It is not possible yet, but perhaps newer boards could have that.

