Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0EKVyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:54:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62731 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0EKVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S4wk0rzI9YsZe2H9W/bjrTEaJcP+NBs83lSDon5AIsxURwSBaoG45IGb3Dvr3301ZU
         4fPC9UVXUdF3FH3rZQt7Nc8scX/hyX3LmxnhzBGGO3WkMFd6DbtFTqw6My+wP/OObfe7
         /8ZPmJhDMrEGiz+9pnmB6rHMuA3aUVeo0ofWk=
Date: Tue, 11 May 2010 14:53:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Weiner <jw@emlix.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Nick Piggin <npiggin@suse.de>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100511215359.GF7396@core.coreip.homeip.net>
References: <20100511063309.GC9644@core.coreip.homeip.net>
 <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
 <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
 <1273608441.15067.1002.camel@calx>
 <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
 <alpine.DEB.2.00.1005111520260.1500@router.home>
 <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
 <alpine.DEB.2.00.1005111544330.8388@router.home>
 <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
 <20100511214836.GH1726@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511214836.GH1726@emlix.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:48:36PM +0200, Johannes Weiner wrote:
> On Tue, May 11, 2010 at 04:54:41PM -0400, Mike Frysinger wrote:
> > does the phrase "DMA safe buffer" imply cache alignment ?
> 
> I guess that depends on the architectural requirements.  On x86,
> apparently, not so much.  On ARM, probably yes, as it's the
> requirement to properly maintain coherency.

It looks liek ARM (and a few others) do this:

[dtor@hammer work]$ grep -r ARCH_KMALLOC_MINALIGN arch/
arch/sh/include/asm/page.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
arch/frv/include/asm/mem-layout.h:#define       ARCH_KMALLOC_MINALIGN           8
arch/powerpc/include/asm/page_32.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
arch/arm/include/asm/cache.h:#define ARCH_KMALLOC_MINALIGN      L1_CACHE_BYTES
arch/microblaze/include/asm/page.h:#define ARCH_KMALLOC_MINALIGN        L1_CACHE_BYTES
arch/mips/include/asm/mach-tx49xx/kmalloc.h: * All happy, no need to define ARCH_KMALLOC_MINALIGN
arch/mips/include/asm/mach-ip27/kmalloc.h: * All happy, no need to define ARCH_KMALLOC_MINALIGN
arch/mips/include/asm/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN 32
arch/mips/include/asm/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN 128
arch/mips/include/asm/mach-generic/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      128
arch/avr32/include/asm/cache.h:#define ARCH_KMALLOC_MINALIGN    L1_CACHE_BYTES

-- 
Dmitry
