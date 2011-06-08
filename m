Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1FHVme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:42:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33349 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FHVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:42:33 -0400
Date: Wed, 8 Jun 2011 22:42:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608214212.GA751@srcf.ucam.org>
References: <20110608195250.GB30256@srcf.ucam.org>
 <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org>
 <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org>
 <4DEFDD69.7010000@kernel.org>
 <20110608204244.GA31484@srcf.ucam.org>
 <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
 <20110608212813.GB32056@srcf.ucam.org>
 <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:31:55PM -0700, Linus Torvalds wrote:
> On Wed, Jun 8, 2011 at 2:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > Boot services data includes everything that was allocated by the EFI
> > memory allocator. Depending on what the system decided to do before
> > deigning to run our code, that might be a meg - or it might be several
> > hundred. And in the process it's probably fragmented RAM into god knows
> > how many small chunks.
> 
> In reality?
> 
> Whatever. I really think our EFI support is just fundamnetally broken.
> We should do *everything* in the bootloader, and nothing at all in the
> kernel. IOW, I think doing the whole "SetVirtualAddrMap()" (or
> whatever) in the boot loader too, and just promise to neve rever call
> any EFI routines from the kernel.

Windows and MacOS both do all the EFI setup in their bootloader, and it 
obviously makes a lot of things much easier. But unfortunately even in 
that case we still need to make EFI calls from runtime, because there's 
no other way to tell the firmware where we put the bootloader...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
