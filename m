Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2KLMsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:48:43 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:57565 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552Ab2KLMsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:48:42 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CAD=GYpZwpRRUD=Qy529KkiL-5e2zHaCWMZM9+CTQEnMqSR3yEw@mail.gmail.com>
Date: Mon, 12 Nov 2012 14:48:33 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C26F7AC2-3C0E-47BF-AC37-BB1F1E246145@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <-4237940489086529028@unknownmsgid> <559B8433-67C3-4A1A-A5D6-859907655176@antoniou-consulting.com> <CAD=GYpZwpRRUD=Qy529KkiL-5e2zHaCWMZM9+CTQEnMqSR3yEw@mail.gmail.com>
To: Joel A Fernandes <agnel.joel@gmail.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

Again, sorry for the late reply due to travel.

On Nov 10, 2012, at 5:36 AM, Joel A Fernandes wrote:

> Hi Pantelis,
> 
> On Fri, Nov 9, 2012 at 2:13 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
> 
>>>>> Option C: U-Boot loads both the base and overlay FDT files, merges them,
>>>>>      and passes the resolved tree to the kernel.
>>>>> 
>>>> 
>>>> Could be made to work. Only really required if Joanne wants the
>>>> cape interface to work for u-boot too. For example if the cape has some
>>>> kind of network interface that u-boot will use to boot from.
>>>> 
>>> 
>>> I love Grant's hashing idea a lot keeping the phandle problem for
>>> compile time and not requiring fixups.
>>> 
>>> IMO it is still a cleaner approach if u-boot does the tree merging for
>>> all cases, and not the kernel.
>>> 
>>> That way from a development standpoint, very little or nothing will
>>> have to be changed in kernel (except for scripts/dtc) considering we
>>> are moving forward with hashing.
>>> 
>>> Also this discussed a while back but at some point is going to brought
>>> up again-  loading of dt fragment directly from EEPROM and merging at
>>> run time. If we were to implement this in kernel, we would have to add
>>> cape specific EEPROM reading code, merge the tree before it is
>>> unflattened and parse. I think doing tree merging in kernel is messy
>>> and we should do it in uboot. Ideally reading the fragment from the
>>> EEPROM for all capes and merging without worrying about version
>>> detection, Doing the merge and passing the merged blob to the kernel
>>> which (kernel) works the same way it does today.
>> 
>> Not going to work, for a lot of cases. Doing it in the kernel seems to be
>> the cleaner option. There are valid use cases for doing in u-boot too.
> 
> True, if dynamic runtime stuff from userspace is what we're talking
> about, then yeah I see the important need for kernel to do the merge.
> 

Kernel doing the merge is our use case, and I feel it's the use case of
about 90% of users.

u-boot doing the merge is the rest.

>>> Alternatively to hashing, reading david gibsons paper I followed,
>>> phandle is supposed to 'uniquely' identity node. I wonder why the node
>>> name itself is not sufficient to unquiely identify. The code that does
>>> the tree walking can then just strcmp the node name while it walks the
>>> tree instead of having to find a node with a phandle number. I guess
>>> the reason is phandles are small to store as data values. Another
>>> approach can be to arrange the string block in alphabetical order
>>> (unless it already is), and store phandle as index of the node name
>>> referenced relative to the starting of the strong block. This will not
>>> affect nodes in dtb being moved around since they will still have the
>>> same index value. the problem being adding or removing nodes Changes
>>> the offsets of all other nodes in the string block as well.. Hmm.
>>> 
>> 
>> This is pretty radical change to the DT format, no?
> 
> Yes, true and the only way hypothetically to replace the phandle
> tree-walking mechanism is to store node paths instead of phandle which
> David pointed is too long to store, so I guess this wont work after
> all. Anyway this was an interesting exercise, thanks.
> 

It is always nice to have a fresh perspective. Thank you.

> Regards,
> Joel

Regards

-- Pantelis

