Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2KGRSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:18:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59446 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2KGRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:18:13 -0500
Message-ID: <509A97D0.5010006@wwwdotorg.org>
Date: Wed, 07 Nov 2012 10:18:08 -0700
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
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <5A5C45CB-CDF8-4D93-8698-46A27143ABFA@antoniou-consulting.com>
In-Reply-To: <5A5C45CB-CDF8-4D93-8698-46A27143ABFA@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 01:47 AM, Pantelis Antoniou wrote:
> Hi Stephen,
> 
> On Nov 6, 2012, at 11:37 PM, Stephen Warren wrote:
> 
>> On 11/05/2012 01:40 PM, Grant Likely wrote:
>>> Hey folks,
>>>
>>> As promised, here is my early draft to try and capture what device
>>> tree overlays need to do and how to get there. Comments and
>>> suggestions greatly appreciated.
>>
>> Interesting. This just came up internally at NVIDIA within the last
>> couple weeks, and was discussed on the U-Boot mailing list very recently
>> too:
>>
>> http://lists.denx.de/pipermail/u-boot/2012-October/thread.html#138227
>> (it spills into the November archive too)
> 
> I am aware of this discussion. For our use case u-boot DT manipulation was
> tried, but then abandoned. Asking our user base to modify anything in u-boot
> was ruled out.
>  
>>
>>> For these cases it is proposed to implement an overlay feature for the
>>> so that the initial device tree data can be modified by userspace at
>>
>> I don't know if you're maintaining this as a document and taking patches
>> to it, but if so:
>>
>> "for the so" split across those two lines.
>>
>>> Jane solves this problem by storing an FDT overlay for each cape in the
>>> root filesystem. When the kernel detects that a cape is installed it
>>> reads the cape's eeprom to identify it and uses request_firmware() to
>>> obtain the appropriate overlay. Userspace passes the overlay to the
>>> kernel in the normal way. If the cape doesn't have an eeprom, then the
>>> kernel will still use firmware_request(), but userspace needs to already
>>> know which cape is installed.
>>
>> As mentioned by Pantelis, multiple versions of a board is also very
>> common. We already have the following .dts files in the kernel where
>> this applies, for the main board even:
>>
>> arch/arm/boot/dts/tegra30-cardhu.dtsi
>> arch/arm/boot/dts/tegra30-cardhu-a02.dts
>> arch/arm/boot/dts/tegra30-cardhu-a04.dts
> 
> Exactly. I've made this point in another email, but IMHO board-revision
> management is exactly the same with cape revision management.
> 
> Ideally you'd like to get rid of those three, and replace it with only
> one that's properly versioned.

I don't expect we would ever get rid of some of those .dts files; there
is after all a common subset that applies to all boards, and an
incremental difference that applies to only A02/3, and another for
A04/5/... Representing those as separate source files seems appropriate
to me. If we try and dump all the multiple versions into a single file
with some markup indicating which version of the board some sub-sections
of the .dts apply to, I think we'll end up with rather complex .dts
files. In this case, the simple overlay model works extremely well.
