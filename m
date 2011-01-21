Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AURjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:39:37 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45532 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1AURjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:39:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZCGt4BLfc9yr3b6cRH+VBEOYZ6gjh0j2EahyGfGoC3Ab8EUIKeIR4SBiySwAWBtOVs
         aFj1fCu46HPRZ/0Xt/k0JvLHGKMuR3e9sFRMSZY0NTLka7croH2m2dYFGXOSbXElyDcG
         oeooJZPKCdJ2r/EI64DW+HfLsleZ5D3JXWVq8=
MIME-Version: 1.0
In-Reply-To: <4D38BCFA.8050609@google.com>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	<20110119135546.bb7e8f62.akpm@linux-foundation.org>
	<1295484358.15213.25.camel@yhuang-dev>
	<20110119165247.cca2f434.akpm@linux-foundation.org>
	<1295520247.28776.152.camel@laptop>
	<AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
	<1295522876.28776.158.camel@laptop>
	<AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
	<20110120121455.GA7680@elte.hu>
	<AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
	<20110120130625.GA14436@elte.hu>
	<4D38BCFA.8050609@google.com>
Date: Fri, 21 Jan 2011 09:39:34 -0800
X-Google-Sender-Auth: IxcpLC_KLsqGYejIq_H1_MxYHOI
Message-ID: <AANLkTinbnJCWbtJWQPC7dYqTZGJWTS_mPCk-MnrNetXd@mail.gmail.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: Tim Hockin <thockin@hockin.org>
To: Mike Waychison <mikew@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, huang ying <huang.ying.caritas@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        Robert Lippert <rlippert@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OOh ohh, can I jump in?  As another of "those Google guys" who has
been dealing with Linux's lack of solutions here for years....

On Thu, Jan 20, 2011 at 2:53 PM, Mike Waychison <mikew@google.com> wrote:
> On 01/20/11 05:06, Ingo Molnar wrote:
>>
>> * huang ying<huang.ying.caritas@gmail.com>  wrote:
>>
>>> On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar<mingo@elte.hu>  wrote:
>>>>
>>>> * huang ying<huang.ying.caritas@gmail.com>  wrote:
>>>>
>>>>>> But will all that stuff be accepted? Please stop sending
>>>>>> infrastructure bits and
>>>>>> focus on your larger RAS picture, once you have consensus on that from
>>>>>> all
>>>>>> parties involved, then, and only then, does it make sense to submit
>>>>>> everything,
>>>>>> including infrastructure.
>>>>>
>>>>> I am not sending hardware error reporting infrastructure.  As far as I
>>>>> know, Linus
>>>>> and Andrew suggest to use printk for hardware error reporting.  And
>>>>> now, I just
>>>>> try to write APEI driver and reporting hardware error with printk.  Is
>>>>> it
>>>>> acceptable?  Do you have some other idea about hardware error
>>>>> reporting?
>>>>
>>>> Erm, how could you possible have missed the perf based RAS daemon work
>>>> of Boris,
>>>> which we've pointed out about half a dozen times already?
>>>
>>> Even if there is some other hardware error reporting infrastructure
>>> such as perf based, I think we still need printk too. After all, as
>>> Linus pointed out, printk is the most popular error reporting
>>> mechanism so far. Do you think so?
>>
>> Of course, that's why the upstream EDAC code uses printk too. In fact it
>> does all
>> sorts of in-kernel decoding to make the printk output more useful - the
>> /dev/mcelog
>> method of pushing all decoding to user-space is fundamentally flawed.

EDAC is fundamentally flawed and we don't use it any more.  It strips
off so much information that we can't actually figure out what
happened to the level we want.  We do it in userspace now.

> Geez, I don't know how to approach this preposition in a concise way :(
>  Processing machine checks in-kernel is just as flawed as relying on
> /dev/mcelog alone IMO.  I agree with you that relying on /dev/mcelog to get
> all of our error data out is flawed, but so is relying on an in-kernel
> "abstraction" of the data exposed from the hardware.
>
>
> There are many different ways a system can fail such that an MCE isn't
> received and processed by the kernel.  Sometimes the error is just too fatal
> to do anything useful.  Errors like a NB buffer CRC error, a bus syncflood,
> or a cache hierarchy ECC error that was incorrectly propagated up through to
> the L1 (which may only have parity checking) can cause the kernel to fall
> over as the CPU is either cut off from the rest of the world or too confused
> to get anything right.
>
> Getting at this information is still very worthwhile however, and I'm
> guessing that this is what the APEI bits are meant to be doing.  You'll be
> seeing patches for Google firmware drivers that provide functionality along
> the same vein in the coming days (I'm still busy whitewashing and
> documenting them).
>
> It's also very ignorant to assume that the kernel knows everything about the
> system and is capable of decoding errors to the satisfaction of userland.
>  As Duncan Laurie pointed out (https://lkml.org/lkml/2011/1/11/390) we care
> about not only the physical address, but which stick and which dimm *chip*
> on the stick is having problems.  In-kernel abstractions  break down due to
> the following:

This.  Andi was trying to use DMI tables to decode physical address to
DIMMs, but I'll tell you this: I have yet to see a platform that has
THAT MUCH information in the DMI tables and have it be *correct*.

>
>   * The kernel couldn't possible know how my i2c busses are setup and the
> SPD EEPROMs are related to the physical memory abstraction that the bios
> sets up for me.  I don't know of any standard way to have the BIOS expose
> this sort of information to the operating system.  This sort of layout
> changes between motherboard spins quite frequently as well, so good luck
> mapping it yourself in any generic way.
>
>   * The kernel couldn't know how to map SPD JEDEC Manufacturer ID, Model
> part number and revision to anything useful about the chips themselves.
>
>   * The kernel also couldn't know how to communicate with the AMBs in a
> meaningful way (if present).
>
>
> At the end of the day,   The only things I really care about are:
>
>   * I don't care if the kernel pre-processes the data it gets from the
> hardware when there is an error.  For most users, burping something out to
> the logs in decoded form is generally useful.  It isn't for us.
>   * Don't ever put the kernel in a position where it will spam the logs and
> wedge the system -- even if the hardware is wonky.

I'll add to this - sometimes 100 MCEs/second is acceptable.  The
Kernel needs to not flake out under that.

>   * Don't dummy the data such that I can't do the same calculations with
> better visibility from userland.

This.  We do extensive analysis of data in userland.

>   * Don't ever enforce a reactive policy that can't be changed from
> userland.
>   * I don't care whether the data comes from netlink, /dev/mcelog,
> whiz-bang-sysfs uevent, or thingamaboo perfevents doohickie: as long as I
> get events that are both atomic+consistent and the ABI is maintained.

I've been asking for hardware events for ever.  I seem to recall a
proposal from IBM at OLS 2002 or 2003 where this was discussed.  I
wanted it then, and I still want it.  But I don't just want MCEs.  Why
can I not use the same channel to get PCI errors or SATA errors or
EDAC (non-MCE) errors.

I don't care what the channel is, so long as I can rate-limit
(/dev/mcelog is pretty good at that) events and the events I read
contain full details about what happened.

> I've CCed Robert who owns our userland bits as he may have something to add.
>
> That said, I'd love to have generic NMI-safe data-passing for improved
> debugability, regardless of this conflated bickering about RAS
> infrastructure :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
