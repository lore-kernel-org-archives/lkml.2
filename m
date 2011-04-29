Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab1D2WvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:51:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:41333 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1D2WvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:51:22 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Jerome Glisse <j.glisse@gmail.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4DBA990F.6040203@vmware.com>
References: <201104212129.17013.arnd@arndb.de>
	 <201104281428.56780.arnd@arndb.de>
	 <20110428131531.GK17290@n2100.arm.linux.org.uk>
	 <201104281629.52863.arnd@arndb.de>
	 <20110428143440.GP17290@n2100.arm.linux.org.uk>
	 <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
	 <1304036962.2513.202.camel@pasglop> <4DBA5194.7080609@vmware.com>
	 <1304062523.2513.235.camel@pasglop>  <4DBA990F.6040203@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 08:50:56 +1000
Message-ID: <1304117456.2513.265.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 12:55 +0200, Thomas Hellstrom wrote:
> On 04/29/2011 09:35 AM, Benjamin Herrenschmidt wrote:
> >
> > We have problems with AGP and macs, we chose to mostly ignore them and
> > things have been working so-so ... with the old DRM. With DRI2 being
> > much more aggressive at mapping/unmapping things, things became a lot
> > less stable and it could be in part related to that. IE. Aliases are
> > similarily forbidden but we create them anyways.
> >
> Do you have any idea how other OS's solve this AGP issue on Macs?
> Using a fixed pool of write-combined pages?

Write-combine is a different business, it's a matter of not mapping with
the G bit, but no, the way MacOS works I think is that they don't
actually use large pages at all, and I don't even think they have a
linear mapping of all memory. On the other hand they are slow :-)

> >> c)  If neither of the above applies, we might be able to either use
> >> explicit cache flushes (which will require a TTM cache sync API), or
> >> require the device to use snooping mode. The architecture may also
> >> perhaps have a pool of write-combined pages that we can use. This should
> >> be indicated by defines in the api header.
> >>      
> > Right. We should still shoot HW designers who give up coherency for the
> > sake of 3D benchmarks. It's insanely stupid.
> >    
> 
> I agree. From a driver writer's perspective having the GPU always 
> snooping the system pages would be a dream. On the GPUs that do support 
> snooping that I have looked at, its internal MMU usually support both 
> modes, but the snooping mode is way slower (we're talking 50-70% or so 
> slower texturing operations), and often buggy causing crashes or scanout 
> timing issues since system designers apparently don't really count on it 
> being used. I've found it usable for device-to-system memory blits.
> 
> In addition memcpy to device is usually way faster if the destination is 
> write-combined. Probably due to cache thrashing effects.

Possibly. It's a matter of the HW folks actually spending some time to
make it work properly. It can be done :-) It's just that they don't
bother. Look at the perfs one can get out of fully coherent PCIe
nowadays, largely enough for a simple scanout :-)

Cheers,
Ben.

> /Thomas
> 
> > Cheers,
> > Ben.
> >
> >    
> >> /Thomas
> >>
> >>
> >>
> >>
> >>      
> >>> _______________________________________________
> >>> Linaro-mm-sig mailing list
> >>> Linaro-mm-sig@lists.linaro.org
> >>> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
> >>>
> >>>        
> >
> >    
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


