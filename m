Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab1LNUpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:45:03 -0500
Received: from relais.videotron.ca ([24.201.245.36]:28176 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1LNUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:45:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 14 Dec 2011 15:45:00 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-next] make  s5p64x0_defconfig build error
In-reply-to: <20111214191205.GF14542@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1112141530520.2907@xanadu.home>
References: <1323838630.18517.1.camel@phoenix>
 <20111214123244.GE7122@mudshark.cambridge.arm.com>
 <20111214191205.GF14542@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Russell King - ARM Linux wrote:

> On Wed, Dec 14, 2011 at 12:32:44PM +0000, Will Deacon wrote:
> > On Wed, Dec 14, 2011 at 04:57:10AM +0000, Axel Lin wrote:
> > > I got below build error on linux-next 20111213.
> > > 
> > >   CC      arch/arm/kernel/process.o
> > > In file included from arch/arm/mach-s5p64x0/include/mach/system.h:16,
> > >                  from arch/arm/kernel/process.c:64:
> > > arch/arm/plat-samsung/include/plat/system-reset.h:19:2: error: #error Fix me up
> > > make[1]: *** [arch/arm/kernel/process.o] Error 1
> > > make: *** [arch/arm/kernel] Error 2
> > 
> > The clue is in the commit message:
> > 
> > commit d0f7e2beabe6a116152ccc31959b6654b6ef0071
> > Author: Russell King <rmk+kernel@arm.linux.org.uk>
> > Date:   Tue Dec 6 12:57:02 2011 +0000
> > 
> >     ARM: restart: Temporary #error to persuade platform maintainers to take the restart changes seriously
> > 
> >     Force builds to fail to ensure that platform maintainers take the
> >     restart changes seriously, and sort out fixing their code before the
> >     next merge window.
> > 
> >     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Indeed, and note the date, and how long its taken for just one of the
> platforms to be noticed.
> 
> It seems to me that no one really cares about whether six of the seven
> platforms which have the #error build or don't build, so I really think
> there's a simple solution to this at the next merge window - delete any
> platform which hasn't _at_ _least_ responded with a proposed patch to
> this.
> 
> The platform maintainers have had _enough_ notice of this - by not
> responding, they're quite simply an obstacle to further consolidation,
> and we're not going to go through months of waiting for their response
> time and time again.
> 
> I've posted the patches to the mailing list, I've copied them asking
> for help, I've chased them several times, and now they have a #error
> to deal with.  If none of this gets their attention (it seems it
> doesn't), then frankly their platform is unmaintained, it will be
> broken at the next merge window, and therefore _should_ be deleted.
> 
> So... unless things change, we can expect Gemini, almost all Samsung
> stuff, shmobile, vt8500, and Telechips TCC8k to be at least broken at
> the next merge window.

Let me add to this by pointing to this piece of code in
arch/arm/include/asm/pgtable.h:

|/* This is a temporary hack until shmobile's DMA area size is sorted out */
|#ifdef CONFIG_ARCH_SHMOBILE
|#warning "SH-Mobile's consistent DMA size conflicts with VMALLOC_END by 144MB"
|#undef VMALLOC_END
|#define VMALLOC_END             0xF6000000UL
|#endif

Again, the reason for this is in the commit message.  My hope was that, 
by the central nature of this header file, the build would be 
sufficiently overwhelmed with #warning noise that the maintainers would 
manifest themselves and come forth with the needed fix.

After repeated inquiries to the listed maintainers in the MAINTAINERS 
file, I still didn't receive any feedback at this point, and I still 
can't find a reason for the current state of things either by looking at 
the concerned code or the related Git commit logs.

So if no one cares about this platform then I propose to delete it for 
v3.3 as well.


Nicolas
