Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0LXN47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:56:59 -0500
Received: from d1.icnet.pl ([212.160.220.21]:38516 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0LXN44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:56:56 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Fri, 24 Dec 2010 14:55:25 +0100
User-Agent: KMail/1.9.10
Cc: linux-arch@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl> <20101224130200.GG20587@n2100.arm.linux.org.uk>
In-Reply-To: <20101224130200.GG20587@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201012241455.30430.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friday 24 December 2010 14:02:00 Russell King - ARM Linux wrote:
> On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik wrote:
> > The patch tries to implement a solution suggested by Russell King,
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December
> >/035264.html. It is expected to solve video buffer allocation issues
> > for at least a few soc_camera I/O memory less host interface
> > drivers, designed around the videobuf_dma_contig layer, which
> > allocates video buffers using dma_alloc_coherent().
> >
> > Created against linux-2.6.37-rc5.
> >
> > Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera
> > patch, patterned upon two mach-mx3 machine types which already try
> > to use the dma_declare_coherent_memory() method for reserving a
> > region of system RAM preallocated with another
> > dma_alloc_coherent(). Compile tested for all modified files except
> > arch/sh/drivers/pci/fixups-dreamcast.c.
>
> Another note: with the pair of patches I've sent to the
> linux-arm-kernel list earlier today changing the DMA coherent
> allocator to steal memory from the system at boot.
>
> This means there's less need to pre-allocate DMA memory - if there's
> sufficient contiguous space in the DMA region to satisfy the
> allocation, then the allocation will succeed.  It's also independent
> of the maximum page size from the kernel's memory allocators too.
>
> So I suspect that mach-mx3 (and others) no longer need to do their
> own pre-allocation anymore if both of these patches go in.

Then, my rationale will no longer be valid. So, either drop my patch if 
you think you have finally come out with a better solution which 
doesn't touch any system-wide API, or suggest a new justification for 
use in the commit log if you think still the patch solves something 
important.

Thanks,
Janusz
