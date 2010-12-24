Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0LXNCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:02:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36238 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0LXNCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:02:47 -0500
Date: Fri, 24 Dec 2010 13:02:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-arch@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
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
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to
	caller
Message-ID: <20101224130200.GG20587@n2100.arm.linux.org.uk>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012240020.37208.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik wrote:
> The patch tries to implement a solution suggested by Russell King, 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/035264.html. 
> It is expected to solve video buffer allocation issues for at least a 
> few soc_camera I/O memory less host interface drivers, designed around 
> the videobuf_dma_contig layer, which allocates video buffers using 
> dma_alloc_coherent().
> 
> Created against linux-2.6.37-rc5.
> 
> Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera patch, 
> patterned upon two mach-mx3 machine types which already try to use the 
> dma_declare_coherent_memory() method for reserving a region of system 
> RAM preallocated with another dma_alloc_coherent(). Compile tested for 
> all modified files except arch/sh/drivers/pci/fixups-dreamcast.c.

Another note: with the pair of patches I've sent to the linux-arm-kernel
list earlier today changing the DMA coherent allocator to steal memory
from the system at boot.

This means there's less need to pre-allocate DMA memory - if there's
sufficient contiguous space in the DMA region to satisfy the allocation,
then the allocation will succeed.  It's also independent of the maximum
page size from the kernel's memory allocators too.

So I suspect that mach-mx3 (and others) no longer need to do their own
pre-allocation anymore if both of these patches go in.
