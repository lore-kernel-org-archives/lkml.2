Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1EIN7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:59:37 -0400
Received: from atl.turmel.org ([74.117.157.138]:50208 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1EIN7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:59:35 -0400
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 May 2011 09:59:35 EDT
Message-ID: <4DC7EEE2.7050101@turmel.org>
Date: Mon, 09 May 2011 09:40:50 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: microcai <microcaicai@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Question] Where is the missing 384k? Please, I've searching
 for it years!
References: <4DC6DE72.1000505@gmail.com>
In-Reply-To: <4DC6DE72.1000505@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning, microcai,

On 05/08/2011 02:18 PM, microcai wrote:
> It's being too long since I got this question.
> I have to ask, even with a chance that I am considered as spam, and be
> banned by kernel.org, I have to ask.
> Please CC me if any one is going to answer my questions, I'll be
> appreciate if you solve my haze.

I'll try.

> So, my question is really simple, where is the missing 384k RAM?
> 
> When I read the books about PC, or see the output of dmesg, I've always
> told that, 640k-1M is reserved for BIOS, and should not be used.
> 
> 1)
> 384k RAM is reserved because BIOS is there. But I've heard that BIOS is
> really in a ROM, not in RAM. So, where is the RAM when CPU is addressing
> the ROM? Does the ROM just override the RAM and makes the RAM completely
> un-addressable? What if people just got 2MB RAM? 384k of 2MB RAM is a
> lot of wast!

The ROM and the RAM can't share the same address.  Memory devices of any kind present themselves as a big chuck of bits, addressable from 0 to X.  All other manipulations must be done in address decoding logic in a memory controller chipset.  The chipset can then combine multiple memory chips into consecutive addresses, or interleave them in various ways for speed, or apply arithmetic adjustments to selected addresses.  The system BIOS start address would be offset so the BIOS filled the last addresses below 1M.

In a classic DOS system, any address that didn't match one of the motherboard chipset's known blocks would be passed to the system bus (ISA) for add-on cards to respond to.  Add-on cards, with their own address decoders, had to use addresses that didn't conflict with the motherboard, or each other.  Early video card BIOS extensions were reached this way, along with network boot ROMs, and early SCSI controller ROMs.  It was fairly common to have DIP switches on these cards to set the ROM start address, so you could juggle multiple add-on cards.

All of that is gone, now.  Modern systems use multiple levels of address decoding and remapping in hardware, with standardized configuration methods, such as PCI bus "BAR"s.

> 2)
> Is there a way to unmap the ROM and get back the RAM? or remap the 384k
> RAM to upper address? If there is , why don't the kernel use this and
> get my RAM(which is money) back?

This is a hardware problem.  If the RAM is to be reached instead of the ROM, something must change in the memory controller chipset's address decoders.  If the chipset doesn't have configurable address decoders, it can't be done.

> 3)
> If there is not way to unmap the ROM or remap the RAM, why do they wast
> 384k RAM there! Even if 4G RAM is common now, 2M RAM is common in the
> old days. Why did they do that!

Not all of the old motherboards wasted the space.  I can't identify specific ones, as I didn't keep any of that old hardware, but many chipsets would remap the 384K to above the last normal RAM address.  A 2MB machine would then "look" like 2432KB, but with a gap from 640KB to 1024KB.

Another popular option was to set up "shadow" RAM to avoid accessing slow ROM chips.  The BIOS would copy the real ROM contents into the corresponding RAM, then mark that block as read-only with configurable chipset logic.  The "wasted" RAM would then be used to supply the ROM content, but at the much faster RAM speed.  (This would happen before the BIOS turned everything over to the boot loader.)

I vaguely remember one BIOS that allowed me to choose between "shadow" and "remap".

Bottom line: 1) Hardware problem, not software, and 2) The BIOS must set it up.

> Please help me to erase the big big question mark in my hart, Thanks!

I hope this helps.

Phil
