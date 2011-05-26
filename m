Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab1EZUHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:07:10 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:50279 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab1EZUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:07:09 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <20110526200121.GG29496@redhat.com>
References: <1306269105.21443.20.camel@dan>
	 <20110526200121.GG29496@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 16:06:50 -0400
Message-ID: <1306440410.2279.2.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 16:01 -0400, Vivek Goyal wrote:
> On Tue, May 24, 2011 at 04:31:45PM -0400, Dan Rosenberg wrote:
> 
> [..]
> >  ==============================================================
> >  
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 880fcb6..999ea82 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1548,8 +1548,8 @@ config PHYSICAL_START
> >  	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
> >  	  bzImage will decompress itself to above physical address and
> >  	  run from there. Otherwise, bzImage will run from the address where
> > -	  it has been loaded by the boot loader and will ignore above physical
> > -	  address.
> > +	  it has been loaded by the boot loader, using the above physical
> > +	  address as a lower bound.
> >  
> >  	  In normal kdump cases one does not have to set/change this option
> >  	  as now bzImage can be compiled as a completely relocatable image
> > @@ -1595,7 +1595,31 @@ config RELOCATABLE
> >  
> >  	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
> >  	  it has been loaded at and the compile time physical address
> > -	  (CONFIG_PHYSICAL_START) is ignored.
> > +	  (CONFIG_PHYSICAL_START) is solely used as a lower bound.
> > +
> 
> This does not sound too good. Overloading the definition of PHYSICAL_START
> with minimum address. The very definition of relocatable kernel is that
> it should be able to run from the physical address it has been loaded
> at (subjected to alignment constraints).
> 
> So I don't think overloading CONFIG_PHYSICAL_START definition is a good
> idea. In fact there is no reason that why kdump kernels should not run
> and boot below 16MB. So limiting those kernels to not load and run
> below 16MB is does not sound like good option to me.
> 

I'm going to revisit this part of the patch and think of a better way to
do this.

> Also randomization of kernel load address at run time will probably have
> some issues with crashkernel=X@Y address syntax. So far user knew what
> address first kernel is booting from and user could speicy where to 
> reserve memory. Now it might happen that user specified some memory
> to reserve and kernel decided to occupy that space resulting in failed
> memory reservation for crash kernel.
> 

Ok, added to the list of things to figure out.  Thanks.

> Thanks
> Vivek


