Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab0EZSsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:48:01 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59045 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab0EZSr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:47:59 -0400
Message-ID: <4BFD6CD7.10806@sgi.com>
Date: Wed, 26 May 2010 11:47:51 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@novell.com
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if 	add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEB0D5F.8070806@oracle.com>	 <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com>	 <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com>	 <4BEC8161.6050206@zytor.com> <4BFC5080.6030103@sgi.com>	 <4BFC5217.6060804@zytor.com> <4BFC5330.5080907@sgi.com> <AANLkTilNXcS_KQTQ4ZwDt8RQqSrlWUH2R5W87g0vI4xG@mail.gmail.com> <4BFD5D98.6090408@sgi.com> <4BFD66D9.4070302@zytor.com>
In-Reply-To: <4BFD66D9.4070302@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 05/26/2010 10:42 AM, Mike Travis wrote:
>> I'm open for suggestions on how to improve this, but we are shipping
>> systems very soon and I don't think we'll get any other change into
>> the system until the next update.
>>
> 
> You know you've been using that excuse for two years when it comes to
> not fixing the bootloader, and I'm starting to be a bit frustrated with
> that.
> 
> 	-hpa

I didn't know bootloader had a problem two years ago  And as I mentioned,
I'm open to suggestions but what I've heard is "fix the bootloader". What
I don't know is how to do that.

I see that BIOS sets up an e820 compatible memory map and extra memmap
entries "somewhere".  EFI seems to pick this up via ELILO and somehow
the kernel finds these extra memmap entries.

So my question is what is broken?  Should the bootloader not use the
standard e820 memmap at all, and invent another way of passing the
memmap entries?  And what about EFI grub, shouldn't that also change?
And how does this affect compatibility?

I'm in the dark here as to how the bootloader manages to pass these
entries from BIOS to the kernel, and how far I can go modifying these
things when I don't completely understand them.  The last problem I
worked on in ELILO I couldn't even print messages as that invalidated
the "magic key" and it would loop endlessly between ELILO and BIOS.

The other thing is priorities.  If something is working and not
causing undue problems, it does not get higher priority than issues
that cause complete system failure.  I've suggested a workable
(maybe short term solution), that gets us past the boot, and on to
the other potentially far more important problems.

And p.s. it's been way longer than two years... ;-)  [the other thing
to consider is we haven't had real hardware that long, and many, many,
many problems have surfaced since then.  The memmap problem only
showed up when we ran over 128 entries.  When has that happened before?
And how was it handled then?] 

Thanks,
Mike
