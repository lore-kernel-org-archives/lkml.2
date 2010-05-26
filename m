Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0EZTFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:05:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39041 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab0EZTFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:05:12 -0400
Message-ID: <4BFD70CC.3050806@zytor.com>
Date: Wed, 26 May 2010 12:04:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@novell.com
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if 	add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEB0D5F.8070806@oracle.com>	 <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com>	 <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com>	 <4BEC8161.6050206@zytor.com> <4BFC5080.6030103@sgi.com>	 <4BFC5217.6060804@zytor.com> <4BFC5330.5080907@sgi.com> <AANLkTilNXcS_KQTQ4ZwDt8RQqSrlWUH2R5W87g0vI4xG@mail.gmail.com> <4BFD5D98.6090408@sgi.com> <4BFD66D9.4070302@zytor.com> <4BFD6CD7.10806@sgi.com>
In-Reply-To: <4BFD6CD7.10806@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:47 AM, Mike Travis wrote:
> 
> I didn't know bootloader had a problem two years ago  And as I mentioned,
> I'm open to suggestions but what I've heard is "fix the bootloader". What
> I don't know is how to do that.
> 
> I see that BIOS sets up an e820 compatible memory map and extra memmap
> entries "somewhere".  EFI seems to pick this up via ELILO and somehow
> the kernel finds these extra memmap entries.
> 
> So my question is what is broken?  Should the bootloader not use the
> standard e820 memmap at all, and invent another way of passing the
> memmap entries?  And what about EFI grub, shouldn't that also change?
> And how does this affect compatibility?
> 
> I'm in the dark here as to how the bootloader manages to pass these
> entries from BIOS to the kernel, and how far I can go modifying these
> things when I don't completely understand them.  The last problem I
> worked on in ELILO I couldn't even print messages as that invalidated
> the "magic key" and it would loop endlessly between ELILO and BIOS.
> 
> The other thing is priorities.  If something is working and not
> causing undue problems, it does not get higher priority than issues
> that cause complete system failure.  I've suggested a workable
> (maybe short term solution), that gets us past the boot, and on to
> the other potentially far more important problems.
> 
> And p.s. it's been way longer than two years... ;-)  [the other thing
> to consider is we haven't had real hardware that long, and many, many,
> many problems have surfaced since then.  The memmap problem only
> showed up when we ran over 128 entries.  When has that happened before?
> And how was it handled then?] 
> 

The 128-entry limit (caused by the fixed array in struct setup_info) was
brought to our attention in 2007.  At that time, a number of
alternatives were discussed; Linus in particular was adamant that this
should be handled in the bootloader, and not by the kernel.

The result was that we added a facility to the kernel to supply
arbitrary information via a linked list.  That has been in there since
at least early 2008.  However, noone who cares about this issue has
bothered stepping up and put the support into the bootloaders --
instead, we got suckered into accepting a "temporary hack" which only
has had the effect of giving you guys yet another excuse not to do what
you signed off to do in the first place.

Accordingly, the right answer for me to do is to veto this and any
further patches which enable you to skirt your responsibility, and I'm
getting damned close to doing so.

	-hpa
