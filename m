Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259Ab0HGAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:16:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762204Ab0HGAQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:16:51 -0400
Date: Fri, 6 Aug 2010 17:16:09 -0700
From: Greg KH <gregkh@suse.de>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
Message-ID: <20100807001609.GA22021@suse.de>
References: <1281137016.3986.8.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281137016.3986.8.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 04:23:36PM -0700, David Cross wrote:
> Re-Re-Re-Re-sending with unnecessary files removed and line wrap turned off in
> new email client. The last one did include a Signed-off-by: at the end, I
> believe, and I am re-including here. Please let me know if there are
> formatting issues with this sign off.

Ok, this one worked better, thanks.

Here's the diffstat, for those playing along at home:

 arch/arm/boot/compressed/piggy.gzip                                                                                           |binary
 arch/arm/mach-omap2/gpmc.c                                                                                                    |    3 
 drivers/staging/Kconfig                                                                                                       |    2 
 drivers/staging/Makefile                                                                                                      |    1 
 drivers/staging/westbridge/Kconfig                                                                                            |   34 
 drivers/staging/westbridge/astoria/Kconfig                                                                                    |    9 
 drivers/staging/westbridge/astoria/Makefile                                                                                   |   11 
 drivers/staging/westbridge/astoria/api/Makefile                                                                               |   14 
 drivers/staging/westbridge/astoria/api/src/cyasdma.c                                                                          | 1107 ++
 drivers/staging/westbridge/astoria/api/src/cyasintr.c                                                                         |  143 
 drivers/staging/westbridge/astoria/api/src/cyaslep2pep.c                                                                      |  358 
 drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c                                                                     | 1264 +++
 drivers/staging/westbridge/astoria/api/src/cyasmisc.c                                                                         | 3474 ++++++++
 drivers/staging/westbridge/astoria/api/src/cyasmtp.c                                                                          | 1128 ++
 drivers/staging/westbridge/astoria/api/src/cyasstorage.c                                                                      | 4104 ++++++++++
 drivers/staging/westbridge/astoria/api/src/cyasusb.c                                                                          | 3718 +++++++++
 drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c                                                   | 2450 +++++
 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/cyashaldef.h                                    |   55 
 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h |  319 
 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h         |  555 +
 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h |   72 
 drivers/staging/westbridge/astoria/block/Kconfig                                                                              |    9 
 drivers/staging/westbridge/astoria/block/Makefile                                                                             |   11 
 drivers/staging/westbridge/astoria/block/cyasblkdev_block.c                                                                   | 1628 +++
 drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c                                                                   |  417 +
 drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h                                                                   |   64 
 drivers/staging/westbridge/astoria/device/Kconfig                                                                             |    9 
 drivers/staging/westbridge/astoria/device/Makefile                                                                            |   23 
 drivers/staging/westbridge/astoria/device/cyandevice_export.h                                                                 |  132 
 drivers/staging/westbridge/astoria/device/cyasdevice.c                                                                        |  394 
 drivers/staging/westbridge/astoria/gadget/Kconfig                                                                             |    9 
 drivers/staging/westbridge/astoria/gadget/Makefile                                                                            |   11 
 drivers/staging/westbridge/astoria/gadget/cyasgadget.c                                                                        | 2211 +++++
 drivers/staging/westbridge/astoria/gadget/cyasgadget.h                                                                        |  193 
 drivers/staging/westbridge/astoria/gadget/cyasgadget_ioctl.h                                                                  |   99 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanerr.h                                                         |  418 +
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanmedia.h                                                       |   59 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanmisc.h                                                        |  614 +
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanregs.h                                                        |  180 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyansdkversion.h                                                  |   30 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanstorage.h                                                     |  419 +
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyantioch.h                                                       |   35 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyantypes.h                                                       |   31 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanusb.h                                                         |  619 +
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyas_cplus_end.h                                                  |   11 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyas_cplus_start.h                                                |   11 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyascast.h                                                        |   35 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasdevice.h                                                      | 1057 ++
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasdma.h                                                         |  375 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyaserr.h                                                         | 1094 ++
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyashal.h                                                         |  108 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyashalcb.h                                                       |   44 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyashaldoc.h                                                      |  800 +
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasintr.h                                                        |  104 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyaslep2pep.h                                                     |   36 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyaslowlevel.h                                                    |  366 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmedia.h                                                       |   54 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmisc.h                                                        | 1549 +++
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmisc_dep.h                                                    |   53 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmtp.h                                                         |  646 +
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasprotocol.h                                                    | 3838 +++++++++
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasregs.h                                                        |  201 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h                                                     | 2759 ++++++
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage_dep.h                                                 |  309 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyastoria.h                                                       |   36 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyastsdkversion.h                                                 |   30 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyastypes.h                                                       |   71 
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h                                                         | 1862 ++++
 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h                                                     |  224 
 fs/fat/inode.c                                                                                                                |    1 
 fs/mpage.c                                                                                                                    |   39 
 71 files changed, 42149 insertions(+)

That's big for just one patch.

How about breaking it up into one-patch-per-thing, like the file,
Documentation/SubmittingPatches describes.  At the very least, one patch
per driver/module, which will give people a chance to review it in a
semi-sane manner.

Also, those exports, I'm not so sure about them, or why they are needed.
Why would you be reading fat filesystem blocks directly from within a
kernel module?  It looks like this is within an ioctl, right?  If so,
why not just read the filesystem stuff from userspace instead?

And for those ioctls, you have audited them for proper user/kernel
interfaces and permissions and overflows, right?  And documented them as
to what they do?

And about that "HAL" layer.  It needs to be stripped down.  Way down.
Function calls like:
+               cy_as_hal_print_message("%s, bad ioctl code = 0x%x\n",
+                       __func__, _IOC_NR(code));

Are not acceptable.  Just call printk() and be done with it.  You aren't
porting this code to any other operating system, so it's not needed.

But that's something that can be done once the code is in the staging
tree, for now, let's get it into a format that I can apply it in :)

thanks,

greg k-h
