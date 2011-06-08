Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1FHV2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:28:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33210 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1FHV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:28:35 -0400
Date: Wed, 8 Jun 2011 22:28:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608212813.GB32056@srcf.ucam.org>
References: <20110608193833.GA29855@srcf.ucam.org>
 <4DEFD220.5040507@kernel.org>
 <20110608195250.GB30256@srcf.ucam.org>
 <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org>
 <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org>
 <4DEFDD69.7010000@kernel.org>
 <20110608204244.GA31484@srcf.ucam.org>
 <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:06:21PM -0700, Linus Torvalds wrote:
> On Wed, Jun 8, 2011 at 1:42 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Wed, Jun 08, 2011 at 01:36:57PM -0700, Yinghai Lu wrote:
> >
> >> or just let bootloader to mark those boot services just like run-time services in e820 table or setupdata?
> >
> > That was my original approach, but if there's boot services code at the
> > top of RAM it means that max_pfn is wrong and it's difficult to recover
> > the memory.
> 
> WHO CARES if the memory is difficult to recover? Just let it be. EFI
> is an abomination in the eyes of God, and we sure as hell shouldn't
> bend over backwards over the stupidities in it. If it means that you
> lose a meg of RAM when you use EFI, that's the least of our problems.

Boot services data includes everything that was allocated by the EFI 
memory allocator. Depending on what the system decided to do before 
deigning to run our code, that might be a meg - or it might be several 
hundred. And in the process it's probably fragmented RAM into god knows 
how many small chunks.

E820 limits us to 128 ranges, and systems I'm looking at right now are 
already using over 140 boot services regions. Some of them are 
contiguous and we could just merge them for e820, but that leaves us at 
the whim of whoever wrote the allocator for the firmware. And do you 
want to bet on them having done this sanely?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
