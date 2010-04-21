Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0DUXrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:47:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29979 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab0DUXrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:47:14 -0400
Message-ID: <4BCF8DAE.5020204@oracle.com>
Date: Wed, 21 Apr 2010 16:43:42 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
References: <20100409223532.GC11130@hexapodia.org> <201004211059.17264.bjorn.helgaas@hp.com> <4BCF7D38.8070206@zytor.com> <201004211704.05541.bjorn.helgaas@hp.com> <4BCF85CF.1080101@zytor.com>
In-Reply-To: <4BCF85CF.1080101@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4BCF8E3F.01C3:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 04:10 PM, H. Peter Anvin wrote:
> On 04/21/2010 04:04 PM, Bjorn Helgaas wrote:
>> On Wednesday 21 April 2010 04:33:28 pm H. Peter Anvin wrote:
>>> Do you have opinions on patches 1-2 of the series?
>>>
>>> I'm getting concerned about how the size of the patchset has grown, and
>>> we're past -rc5 already... but it is a regression so we can't just defer
>>> it to .35.
>>
>> Part 1: the essential part of this seems to be the trim_bios_range()
>> change, and that part is not too big.  In v4, Yinghai also removed
>> probe_roms_32.c.  That sounds like the right thing to do, but I'd
>> rather have that in separate patch so it doesn't obfuscate the other
>> change, and I don't know whether it *has* to be done for .34; maybe
>> it could be deferred.
> 
> I would agree with that.

then use -v3 please

-v4: also don't trim [0xa0000, 0x100000] for mrst.

> 
>> Part 2: IMHO, we're putting way too much crap in kernel/resource.c.
>> A name like "reserve_region_with_split_check_child()" is a pretty
>> good clue that we've lost our way somewhere.  But that's mostly a
>> cosmetic thing, and the end result does seem to be something that
>> fixes the current regression.
> 
> It's not just a good clue we have lost our way, it's also completely
> impossible for anyone but Yinghai to divine what the intended semantics
> are supposed to be.  This *greatly* concerns me, especially given
> previous track record.

I don't know.

insert_resource_expand_to_fit() is added by Linus.

And at least he knew old reserve_region_with_split()

> 
> Even the checkin comment is almost unparsable, which makes it very
> likely that someone is going to trip up on some of this in the future.
> I really would like to get a better description.
> 
> The use of a string match in:
> 
> +       if (check_child && !conflict->child && strstr(conflict->name,
> "PCI Bus"))
> ^^^^^^^^^
> 
> ... screams "wrong! ugly! bad!" in my opinion.  I utterly fail to see
> how that could be acceptable under any circumstances.  I thought that
> had been flagged earlier in the conversation, but it is apparently still
> there.


the string checking is to make sure pci device that is hooked into bus0 directly, but pci bar is falling into
0xa0000 - 0x100000.
so can not put "reserved" holder under them.

YH
