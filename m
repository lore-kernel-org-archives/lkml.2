Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164Ab0HFX0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:26:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:44034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab0HFX0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:26:01 -0400
Date: Fri, 6 Aug 2010 16:02:46 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross / Applications Engineer <odc@cypress.com>
Cc: linux-kernel@vger.kernel.org, david.cross@cypress.com
Subject: Re: PATCH: West Bridge Driver Kernel Support linux-2.6.35
Message-ID: <20100806230246.GA6433@suse.de>
References: <20100806222815.M60253@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100806222815.M60253@cypress.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 03:31:19PM -0700, David Cross / Applications Engineer wrote:
> 
> Re-Re-Re-sending with unnecessary files removed and line wrap turned off in
> new email client. The last one did include a Signed-off-by: at the end, I
> believe, and I am re-including here. Please let me know if there are
> formatting issues with this sign off.

Signed-off-by: goes after the body of the changelog comment, and before
the patch itself.

> This is a driver for the Cypress West Bridge companion chip. Its function is
> analogous to the North/South Bridges of PC environments applied to embedded
> devices, in that it expands I/O and storage capabilities of an embedded
> processor. The Astoria version, which this driver applies to, functions as a
> USB, embedded memory and SDIO controller. The kernel that this patch was
> applied to is linux-2.6.35, although it was tested using the android kernel
> 2.6.29 running on the Zoom 2 platform. In this system, it was used primarily
> as a sideloading accelerator enabling direct data transfers between a USB host
> PC and embedded memory without system overheads.
> Minor modifications were also made to the kernel for this patch. These include
> changes such as EXPORTing of fat_get_block in the kernel code. Another
> function, mpage_cleardirty was also added to the memory management code. This
> function is used to clear the dirty pages from a specific inode. This allows
> for direct, file based DMA. None of these changes are believed to have any
> negative impact on the kernel and may provide additional benefit for other
> developers and drivers.
> The driver, as submitted, was placed into the drivers/staging/westbridge
> folder as the directory structure it will eventually reside in is not yet
> defined. The driver, as placed in staging is divided into four parts:
> 1) gadget – this implements a gadget peripheral controller and includes IOCTLs
> for MTP transfers
> 2) block – this implements a generic block device driver to enable access to
> embedded memory
> 3) api – this is the Cypress SDK, and includes USB and Storage specific
> functions. In addition, it includes common code for low level routines such as
> message passing and common data transfer routines
> 4) hal – this should likely be included in the arch directory as it needs to
> be modified for a given platform. The directory structure in the staging area
> is meant to reflect the eventual location of where this code likely should be.
> It is platform specific. In this case, the HAL included is for the Android
> Zoom 2 platform. Here, West Bridge is connected to the GPMC (general purpose
> memory controller) of the OMAP3. Specific timing needs to be enabled to ensure
> reliable communication.
> Many thanks to Greg KH for conducting initial reviews and providing pointers.
> Please contact david.cross@cypress.com for questions, concerns or feedback.
> 
> Binary files linux-2.6-35-vanilla/arch/arm/boot/compressed/piggy.gzip and
> linux-2.6-35_incl_sdk/arch/arm/boot/compressed/piggy.gzip differ
> diff -uprN -X linux-2.6-35-vanilla/Documentation/dontdiff
> linux-2.6-35-vanilla/arch/arm/mach-omap2/gpmc.c
> linux-2.6-35_incl_sdk/arch/arm/mach-omap2/gpmc.c
> --- linux-2.6-35-vanilla/arch/arm/mach-omap2/gpmc.c	2010-08-03
> 14:40:10.000000000 -0700

The patch is still line-wrapped and you have files in your diff that
shouldn't be (i.e. the "binary" files above.)

Care to redo it?

Also, I need a TODO file in the driver directory that details what needs
to be done in order to move the code into the main portion of the
kernel.  Take a look at the other drivers/staging/*/TODO files for
examples of the format and content.

thanks,

greg k-h
