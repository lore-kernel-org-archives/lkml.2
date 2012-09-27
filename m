Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2I0RuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:50:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45338 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2I0RuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:50:05 -0400
Date: Thu, 27 Sep 2012 18:49:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: CMA broken in next-20120926
Message-ID: <20120927174939.GA5460@sirena.org.uk>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <000601cd9cc9$100428c0$300c7a40$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601cd9cc9$100428c0$300c7a40$%szyprowski@samsung.com>
X-Cookie: We've upped our standards, so up yours!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 05:59:19PM +0200, Marek Szyprowski wrote:
> On Thursday, September 27, 2012 1:29 PM Thierry Reding wrote:

> > any idea why CMA might be broken in next-20120926. I see that there
> > haven't been any major changes to CMA itself, but there's been quite a
> > bit of restructuring of various memory allocation bits lately. I wasn't
> > able to track the problem down, though.

> > What I see is this during boot (with CMA_DEBUG enabled):

> > [    0.266904] cma: dma_alloc_from_contiguous(cma db474f80, count 64, align 6)
> > [    0.284469] cma: dma_alloc_from_contiguous(): memory range at c09d7000 is busy, retrying
> > [    0.293648] cma: dma_alloc_from_contiguous(): memory range at c09d7800 is busy, retrying
> > ...
> > [    2.648619] DMA: failed to allocate 256 KiB pool for atomic coherent allocation
> > ...
> > [    4.196193] WARNING: at /home/thierry.reding/src/kernel/linux-ipmp.git/arch/arm/mm/dma-
> > mapping.c:485 __alloc_from_pool+0xdc/0x110()
> > [    4.207988] coherent pool not initialised!

> > So the pool isn't getting initialized properly because CMA can't get at
> > the memory. Do you have any hints as to what might be going on? If it's
> > any help, I started seeing this with next-20120926 and it is in today's
> > next as well.

> Thanks for the report, I will check this issue asap.

Myself and Peter have seen the same thing, though neither of us drilled
down enough to make a sensible report.
