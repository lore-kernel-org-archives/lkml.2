Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1FNOzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:55:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42235 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1FNOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:55:47 -0400
Date: Tue, 14 Jun 2011 15:55:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110614145532.GB17469@srcf.ucam.org>
References: <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
 <20110613164712.GA23343@srcf.ucam.org>
 <4DF64E6A.70700@gmail.com>
 <20110613180006.GA24902@srcf.ucam.org>
 <4DF65372.7090307@gmail.com>
 <20110613181750.GA25372@srcf.ucam.org>
 <4DF655B5.8040903@gmail.com>
 <20110613183301.GA25644@srcf.ucam.org>
 <4DF77539.9020000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF77539.9020000@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 04:50:33PM +0200, Maarten Lankhorst wrote:
> Didn't notice it before, but my efi memmap has:
> [    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
> 
> Later on this range gets reserved for bios:
> 
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> 
> So I've added a check for e820.

I've got a patch that ignores any EFI mapping at page 0, since it's 
pretty much guaranteed to provide bogosity. Checking e820 might well be 
a cleaner approach, though.

> Also with some digging into the swapper warning, it appears to be because
> some memory was allocated in the _init part of the kernel, which you didn't check for.
> this probably caused the warnings I had. Now I made sure to cover
> the entire kernel from _text to _end, which should cover the entire kernel.

Ah, ok, that makes sense. If you post that I'll take a look.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
