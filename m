Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2KJDP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 22:15:27 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56101 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2KJDP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 22:15:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121109142908.GB4696@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
	<02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
	<CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
	<20121109142908.GB4696@truffula.fritz.box>
Date: Fri, 9 Nov 2012 21:15:25 -0600
Message-ID: <CAD=GYpaQfNKdKWBA+JYPaZXs2X7sRMVsnM_fsH1-Q6CUECC3eQ@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
From: Joel A Fernandes <agnel.joel@gmail.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 8:29 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> On Fri, Nov 09, 2012 at 12:32:09AM -0500, Joel A Fernandes wrote:
>> Hi Pantelis,
>>
>> I hope I'm not too late to reply as I'm traveling.
>>
>> On Nov 6, 2012, at 5:30 AM, Pantelis Antoniou
>> <panto@antoniou-consulting.com> wrote:
>>
>> >> Joanne has purchased one of Jane's capes and packaged it into a rugged
>> >> case for data logging. As far as Joanne is concerned, the BeagleBone and
>> >> cape together are a single unit and she'd prefer a single monolithic FDT
>> >> instead of using an FDT overlay.
>> >> Option A: Using dtc, she uses the BeagleBone and cape .dts source files
>> >>        to generate a single .dtb for the entire system which is
>> >>        loaded by U-Boot. -or-
>> >
>> > Unlikely.
>> >> Option B: Joanne uses a tool to merge the BeagleBone and cape .dtb files
>> >>        (instead of .dts files), -or-
>> > Possible but low probability.
>> >
>> >> Option C: U-Boot loads both the base and overlay FDT files, merges them,
>> >>        and passes the resolved tree to the kernel.
>> >>
>> >
>> > Could be made to work. Only really required if Joanne wants the
>> > cape interface to work for u-boot too. For example if the cape has some
>> > kind of network interface that u-boot will use to boot from.
>> >
>>
>> I love Grant's hashing idea a lot keeping the phandle problem for
>> compile time and not requiring fixups.
>
> Well, using a hash only moves the problem of fixed phandles to a
> problem of fixed node paths.  The details of node paths are, if
> anything, more mutable than phandles.

So what you're saying is there's no way to make a phandle a signature
of a (property of a node) since no one property is unique. If I
follow, even node path can't be used because hash value changes if
node is moved around in the tree. This shoots down the hashing idea
then, which I guess is looked down upon anyway due to dynamic changes
to the base DT as discussed in the usecases.

> [snip]
>> Alternatively to hashing, reading David Gibson's paper I followed,
>> phandle is supposed to 'uniquely' identity node. I wonder why the node
>> name itself is not sufficient to uniquely identify.
>
> Node names are not unique, not even close.  If you have two similar
> NICs in slot 0 of two different PCI domains, they'll almost certainly
> both be called 'ethernet@0,0'.  Similar examples abound on other
> buses.  Node paths are unique, but they are long.
>
> The other big reason for phandles in OF history is that they would be
> more stable than paths.  The device tree could be manipulated during
> OF runtime, but phandles would generally be internal pointers in OF
> and so remain a consistent handle even if the node moved in the tree.
> That's not really relevant for flat trees, but we need to work with
> the same structures.

Thanks.

>> The code that does
>> the tree walking can then just strcmp the node name while it walks the
>> tree instead of having to find a node with a phandle number. I guess
>> the reason is phandles are small to store as data values. Another
>> approach can be to arrange the string block in alphabetical order
>> (unless it already is),
>
> They're not, and doing so would be a painful change to maintain
> compatibility across.  And in any case only property names use the
> strings block, not node names.

Understood, thanks.

Regards,
Joel
