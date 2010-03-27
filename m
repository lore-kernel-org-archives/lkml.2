Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0C0INX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 04:13:23 -0400
Received: from mailout-hades.uni-duesseldorf.de ([134.99.128.34]:48838 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751066Ab0C0INU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 04:13:20 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Mar 2010 04:13:19 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 27 Mar 2010 08:13:16 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros." and
 old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new
 email address)
In-reply-to: <alpine.DEB.1.10.1003071335390.6474@dr-wily.mit.edu>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.1003270801090.20795@zirkon.biophys.uni-duesseldorf.de>
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
 <alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
 <alpine.DEB.2.00.1001102020420.19754@zirkon.biophys.uni-duesseldorf.de>
 <m2wrzpk81j.fsf@igel.home>
 <alpine.DEB.2.00.1001112040120.31572@zirkon.biophys.uni-duesseldorf.de>
 <alpine.DEB.1.10.1003071335390.6474@dr-wily.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Sun, 7 Mar 2010, Tim Abbott wrote:

> Has this fix been merged yet?  It seems to me that the patch Michael sent 
> is a totally reasonable solution to this problem, and I had assumed that 
> it was going to get picked up in the m68k tree when I saw this patch 2 
> months ago...
> 
> 	-Tim Abbott

This hadn't been picked up last time I tried (at least two weeks back). Can't 
really speak to the current state, as I've juyt lost all of the last half 
year's worth of work due to a disk crash caused by Genesis Energy incompetently 
upgrading power meters in Auckland.

I never complained because it really is only a problem with my broken version of 
the cross toolchain. I'll make a fresh effort with the toolchain now. 

Cheers,

  Michael


> 
> On Mon, 11 Jan 2010, Michael Schmitz wrote:
> 
> > Followup on this: You are absolutely right - the problem appears to be related 
> > to the the .init_end section _only_ having the ALIGN, and nothing else (i.e. 
> > no actual section content). 
> > 
> > Placing the align in the .m68k_fixup section like such:
> > 
> > --- arch/m68k/kernel/vmlinux-std.lds.org	2010-01-09 11:01:05.000000000 
> > +1300
> > +++ arch/m68k/kernel/vmlinux-std.lds	2010-01-12 08:43:07.000000000 +1300
> > @@ -42,6 +42,7 @@
> >  	__start_fixup = .;
> >  	*(.m68k_fixup)
> >  	__stop_fixup = .;
> > +        . = ALIGN(PAGE_SIZE);
> >    }
> >    NOTES
> >    .init_end : {
> > 
> > still puts .init_end, __init_end and _end on a page boundary, but also extends
> > the load section up to that page boundary. (Unfortunately, it also extends the 
> > kernel file size by a bit). 
> > 
> > Can the same be achieved in a more elegant way? The reason why the old script 
> > worked with my binutils appears to be the placement of the initramfs data right 
> > at the end - the start of initramfs is page aligned, and the size of the 
> > initramfs is an integer number of pages, so the end of initramfs data, 
> > __init_end and _end all are on a page boundary. With the fixup section now 
> > placed after the initramfs explicitly, this no longer happens by accident...
> > 
> > Cheers,
> > 
> > 	Michael
> > 
> > 
> > 
> 
