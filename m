Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2KLQpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:45:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53096 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2KLQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:45:50 -0500
Message-ID: <50A127B9.1000601@wwwdotorg.org>
Date: Mon, 12 Nov 2012 09:45:45 -0700
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
>>
>>> For these cases it is proposed to implement an overlay feature for the
>>> so that the initial device tree data can be modified by userspace at
>>
>> I don't know if you're maintaining this as a document and taking patches
>> to it, but if so:
> 
> Sure, why not...
> 
> http://git.secretlab.ca/?p=devicetree-overlays.git;a=summary
> 
>>
>> "for the so" split across those two lines.
> 
> fixed
> 
>>>   - SHOULD reliably handle changes between different underlying overlays
>>>     (ie. what happens to existing .dtb overly files if the structure of
>>>     the dtb it is layered over changes. If not possible, then SHALL
>>>     detect when the base tree doesn't match and refuse to apply the
>>>     overlay.
>>
>> Perhaps use (versioned) DT bindings to represent the interface between
>> the two .dts files? See the links to the U-Boot mailing list discussions
>> below?
> 
> Implementing versioning is conceptually a lot more complex than plain
> overlays since it means either the kernel or u-boot needs to start
> filtering the data that it's given. This can get really complex in a
> hurry. Mitch makes a valid point later in this thread that when it
> comes to manipulating the data depending on the board then the data
> overlay model alone doesn't handle it well.

What I was thinking of sounds a lot simpler than what I think you're
responding to.

All I was thinking about was that we define some kind of explicit
interface between .dts files, e.g. some kind of direct representation of
the connector between the boards.

The versioning aspect is then:

Then, when the connector design changes, we change the naming of that
interface representation. This would happen in just the same way that
we'd name/represent the connector design of a BeagleBone differently
from that of an Arduino.

So, perhaps we start out with:

ti,beaglebone-cape-connector
arduino,shield-connector

and later end up with:

ti,beaglebone-cape-connector-v2

as far as any code that handled/references the v1/v2 interface
definitions, they'd probably be completely unrelated types in the
general case, just named very similarly.
