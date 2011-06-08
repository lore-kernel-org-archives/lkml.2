Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1FHTwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:52:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43114 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1FHTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:52:39 -0400
Date: Wed, 8 Jun 2011 20:52:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jim Bos <jim876@xs4all.nl>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608195215.GA30256@srcf.ucam.org>
References: <4DEE17F9.6020503@gmail.com>
 <4DEEA548.5020405@kernel.org>
 <4DEFA6E3.6090809@xs4all.nl>
 <4DEFCAE0.6050700@kernel.org>
 <20110608192321.GA28865@srcf.ucam.org>
 <4DEFCD07.5020505@kernel.org>
 <20110608192950.GA29235@srcf.ucam.org>
 <4DEFCF1A.9030400@kernel.org>
 <20110608193833.GA29855@srcf.ucam.org>
 <4DEFD17C.8000001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEFD17C.8000001@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 12:46:04PM -0700, Yinghai Lu wrote:
> On 06/08/2011 12:38 PM, Matthew Garrett wrote:
> >>> All Dell laptops, all new Apples, some Lenovos, various Intel server 
> >>> platforms. That I've found so far.
> >>
> >> do you mean before that patch, all those machine will not boot linux kernel with UEFI support?
> > 
> > Correct.
> 
> good, they never test that. just let them to use bootcamp.

If you'd like to tell Intel to stop filing bugs about Intel SDVs that 
won't boot via EFI, be my guest. These are systems that have no problem 
booting Windows because SetVirtualAddressMap() is called in the Windows 
bootloader rather than in the Windows kernel.

> >> after bootloader, those area should be free already.
> > 
> > That's what the spec says. Reality says differently. We need those 
> > ranges to be available to the kernel until after SetVirtualAddressMap() 
> > has been called, which means we need to avoid putting the kernel on top 
> > of them.
> 
> bootloader will load kernel (bzImage) high, and it will decompressed to 16M ram position.

Well that's a problem.

> can you call SetVirtualAddressMap before you exit bootloader instead?

No. We don't know where the kernel will map the runtime regions.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
