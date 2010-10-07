Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab0JGTVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:21:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab0JGTVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:21:44 -0400
Date: Thu, 7 Oct 2010 15:21:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "caiqian@redhat.com" <caiqian@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
Message-ID: <20101007192129.GC2581@redhat.com>
References: <4CABAF2A.5090501@kernel.org>
 <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org>
 <20101006151449.GA7378@redhat.com>
 <4CACF531.2060407@intel.com>
 <20101006224704.GD7378@redhat.com>
 <4CAD01A9.9050907@intel.com>
 <20101007181804.GE23308@redhat.com>
 <4CAE1767.5040409@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAE1767.5040409@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 11:54:31AM -0700, H. Peter Anvin wrote:
> On 10/07/2010 11:18 AM, Vivek Goyal wrote:
> > 
> > Ok, I was browsing through kexec-tools, x86 bzImage code and trying to
> > refresh my memory what segments were being loaded and what were memory
> > address concerns.
> > 
> > - relocatable bzImage (max addr 0x37ffffff, 896MB). 
> > 	Though I don't know/understand where that 896MB come from.
> > 
> > - initrd (max addr 0x37ffffff, 896MB)
> > 	Don't know why 896MB as upper limit
> 
> 896 MB is presumably the (default!!) LOWMEM limit on 32 bits.  This is
> actually wrong if vmalloc= is also specified on command line, though, or
> with nonstandard compile-time options.
> 
> > - Purgatory (max addr 2G)
> > 
> > - A segment to keep elf headers (no limit)
> > 	These are accessed when second kernel as fully booted so can be
> > 	addressed in higher addresses.
> > 
> > - A backup segment to copy first 640K of memory (not aware of any limit)
> > - Setup/parameter segment (no limit)
> > 	- We don't really execute anything here and just access it for
> >   	  command line.
> 
> Probably has a 4 GB limit, since I believe it only has a 32-bit pointer.
> 
> > So atleast for bzImage it looks that if we specify crashkernel=128M<896M, it
> > will work.
> > 
> > So I am fine with above additional syntax for crashkernel=. May be we shall
> > have to the deprecate the crashkernel=X<@0 syntax.
> > 
> > CCing kexec list, in case others have any comments.
> 
> It would be easy enough to either deprecate or make it an alias for
> crashkernel=...<896M, which is basically what Yinghai's patch does.

Agreed.

So Yinghai's patch is fine. I need to write a patch for introducing
crashkernel=X<Y syntax to make the behavior explicit. Will do...

Thanks
Vivek
