Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320Ab0HGAxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:53:33 -0400
Received: from ns2.cypress.com ([157.95.67.5]:40405 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0HGAx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:53:28 -0400
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100807001609.GA22021@suse.de>
References: <1281137016.3986.8.camel@odc-laptop>
	 <20100807001609.GA22021@suse.de>
Content-Type: text/plain
Organization: Cypress
Date: Fri, 06 Aug 2010 17:53:16 -0700
Message-Id: <1281142396.4035.30.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, there seems to be a bit of a disconnect between when I am sending
mail and getting replies, I just sent another patch with TODO and
Signed-off-by included, although it includes none of this feedback.

On Fri, 2010-08-06 at 17:16 -0700, Greg KH wrote:
> On Fri, Aug 06, 2010 at 04:23:36PM -0700, David Cross wrote:
> > Re-Re-Re-Re-sending with unnecessary files removed and line wrap turned off in
> > new email client. The last one did include a Signed-off-by: at the end, I
> > believe, and I am re-including here. Please let me know if there are
> > formatting issues with this sign off.
> 
> Ok, this one worked better, thanks.
> 
> Here's the diffstat, for those playing along at home:
> 
>  arch/arm/boot/compressed/piggy.gzip                                                                                           |binary
>  arch/arm/mach-omap2/gpmc.c                                                                                                    |    3 
>  drivers/staging/Kconfig                                                                                                       |    2 
>  drivers/staging/Makefile                                                                                                      |    1 
>  drivers/staging/westbridge/Kconfig                                                                                            |   34 
>  drivers/staging/westbridge/astoria/Kconfig                                                                                    |    9 
>  drivers/staging/westbridge/astoria/Makefile                                                                                   |   11 
>  drivers/staging/westbridge/astoria/api/Makefile                                                                               |   14 
>  drivers/staging/westbridge/astoria/api/src/cyasdma.c                                                                          | 1107 ++
>  drivers/staging/westbridge/astoria/api/src/cyasintr.c                                                                         |  143 
>  drivers/staging/westbridge/astoria/api/src/cyaslep2pep.c                                                                      |  358 
>  drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c                                                                     | 1264 +++
>  drivers/staging/westbridge/astoria/api/src/cyasmisc.c                                                                         | 3474 ++++++++
>  drivers/staging/westbridge/astoria/api/src/cyasmtp.c                                                                          | 1128 ++
>  drivers/staging/westbridge/astoria/api/src/cyasstorage.c                                                                      | 4104 ++++++++++
>  drivers/staging/westbridge/astoria/api/src/cyasusb.c                                                                          | 3718 +++++++++
>  drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c                                                   | 2450 +++++
>  drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/cyashaldef.h                                    |   55 
>  drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h |  319 
>  drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h         |  555 +
>  drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h |   72 
>  drivers/staging/westbridge/astoria/block/Kconfig                                                                              |    9 
>  drivers/staging/westbridge/astoria/block/Makefile                                                                             |   11 
>  drivers/staging/westbridge/astoria/block/cyasblkdev_block.c                                                                   | 1628 +++
>  drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c                                                                   |  417 +
>  drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h                                                                   |   64 
>  drivers/staging/westbridge/astoria/device/Kconfig                                                                             |    9 
>  drivers/staging/westbridge/astoria/device/Makefile                                                                            |   23 
>  drivers/staging/westbridge/astoria/device/cyandevice_export.h                                                                 |  132 
>  drivers/staging/westbridge/astoria/device/cyasdevice.c                                                                        |  394 
>  drivers/staging/westbridge/astoria/gadget/Kconfig                                                                             |    9 
>  drivers/staging/westbridge/astoria/gadget/Makefile                                                                            |   11 
>  drivers/staging/westbridge/astoria/gadget/cyasgadget.c                                                                        | 2211 +++++
>  drivers/staging/westbridge/astoria/gadget/cyasgadget.h                                                                        |  193 
>  drivers/staging/westbridge/astoria/gadget/cyasgadget_ioctl.h                                                                  |   99 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyanerr.h                                                         |  418 +
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyanmedia.h                                                       |   59 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyanmisc.h                                                        |  614 +
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyanregs.h                                                        |  180 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyansdkversion.h                                                  |   30 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyanstorage.h                                                     |  419 +
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyantioch.h                                                       |   35 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyantypes.h                                                       |   31 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyanusb.h                                                         |  619 +
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyas_cplus_end.h                                                  |   11 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyas_cplus_start.h                                                |   11 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyascast.h                                                        |   35 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasdevice.h                                                      | 1057 ++
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasdma.h                                                         |  375 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyaserr.h                                                         | 1094 ++
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyashal.h                                                         |  108 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyashalcb.h                                                       |   44 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyashaldoc.h                                                      |  800 +
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasintr.h                                                        |  104 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyaslep2pep.h                                                     |   36 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyaslowlevel.h                                                    |  366 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmedia.h                                                       |   54 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmisc.h                                                        | 1549 +++
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmisc_dep.h                                                    |   53 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmtp.h                                                         |  646 +
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasprotocol.h                                                    | 3838 +++++++++
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasregs.h                                                        |  201 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h                                                     | 2759 ++++++
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage_dep.h                                                 |  309 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyastoria.h                                                       |   36 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyastsdkversion.h                                                 |   30 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyastypes.h                                                       |   71 
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h                                                         | 1862 ++++
>  drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h                                                     |  224 
>  fs/fat/inode.c                                                                                                                |    1 
>  fs/mpage.c                                                                                                                    |   39 
>  71 files changed, 42149 insertions(+)
> 
> That's big for just one patch.
> 
> How about breaking it up into one-patch-per-thing, like the file,
> Documentation/SubmittingPatches describes.  At the very least, one patch
> per driver/module, which will give people a chance to review it in a
> semi-sane manner.
> 
I can probably break it up into these three patches:
1) sdk, common code and hal as well as minor kernel updates
2) block driver
3) gadget driver

But (1) will still have the majority of the code. Also the block driver
and gadget driver won't compile independently as is. In order to break
it up, I think I would need to stage things, and (1) does not make sense
independent of the other two functions (it does nothing for the kernel
on its own). Would you prefer I staged it such that the block driver and
gadget were not included initially?

> Also, those exports, I'm not so sure about them, or why they are needed.
> Why would you be reading fat filesystem blocks directly from within a
> kernel module?  It looks like this is within an ioctl, right?  If so,
> why not just read the filesystem stuff from userspace instead?
> 
The usage case for these is as follows: we need to pre-allocate a file
in the file system and transfer data to it external to the CPU. West
Bridge has both access to USB and storage, so it transfers data directly
to the file from a USB host once that file is allocated in order to
improve performance and avoid loading the CPU. The way to pre-allocate a
FAT file that I could find was through the fat_get_block API. I don't
know of any userspace method that implements this functionality, but am
open to using any that are available.

> And for those ioctls, you have audited them for proper user/kernel
> interfaces and permissions and overflows, right?  And documented them as
> to what they do?
> 
I don't know, so probably not. I have audited mostly for functionality.
Can I add this to the TODO list and still submit the driver in staging
or does this need to happen first?

> And about that "HAL" layer.  It needs to be stripped down.  Way down.
> Function calls like:
> +               cy_as_hal_print_message("%s, bad ioctl code = 0x%x\n",
> +                       __func__, _IOC_NR(code));
> 
> Are not acceptable.  Just call printk() and be done with it.  You aren't
> porting this code to any other operating system, so it's not needed.
As you probably guessed, the original idea of the SDK was portability,
which is the reason for the implementation choice. But I understand your
point, I will add that to the TODO list. I am guessing the cplusplus
defines are out as well?


> But that's something that can be done once the code is in the staging
> tree, for now, let's get it into a format that I can apply it in :)
Just got your next email (checked before send this time), let me know if
other changes are needed.

> On Fri, Aug 06, 2010 at 05:29:03PM -0700, David Cross wrote:
> > Re-Re-Re-Re-Re-sending with unnecessary files removed, line wrap
> turned off in
> > new email client, Signed-off-by included in the correct place, and
> TODO file added.
> 
> Looks much better.
> 
> I can queue this up in the staging-next tree for the .37 merge, after
> the .36 merge window closes, if you don't mind me removing the non
> drivers/staging/ file changes here.
> 
> Is that ok?
Yes, that is fine by me, but it won't compile as is without these
changes in place. Do you need me to comment out the lines that would
need to be added back in later (gpmc_cs_write_reg, etc.)?

> > --- linux-2.6-35-vanilla/arch/arm/mach-omap2/gpmc.c   2010-08-03
> 14:40:10.000000000 -0700
> > +++ linux-2.6-35_incl_sdk/arch/arm/mach-omap2/gpmc.c  2010-08-05
> 16:50:24.000000000 -0700
> > @@ -115,6 +115,7 @@ void gpmc_cs_write_reg(int cs, int idx, 
> >       reg_addr = gpmc_base + GPMC_CS0 + (cs * GPMC_CS_SIZE) + idx;
> >       __raw_writel(val, reg_addr);
> >  }
> > +EXPORT_SYMBOL(gpmc_cs_write_reg);
> >  
> >  u32 gpmc_cs_read_reg(int cs, int idx)
> >  {
> > @@ -123,6 +124,7 @@ u32 gpmc_cs_read_reg(int cs, int idx)
> >       reg_addr = gpmc_base + GPMC_CS0 + (cs * GPMC_CS_SIZE) + idx;
> >       return __raw_readl(reg_addr);
> >  }
> > +EXPORT_SYMBOL(gpmc_cs_read_reg);
> >  
> >  /* TODO: Add support for gpmc_fck to clock framework and use it */
> >  unsigned long gpmc_get_fclk_period(void)
> > @@ -276,6 +278,7 @@ int gpmc_cs_set_timings(int cs, const st
> >  
> >       return 0;
> >  }
> > +EXPORT_SYMBOL(gpmc_cs_set_timings);
> >  
> >  static void gpmc_cs_enable_mem(int cs, u32 base, u32 size)
> >  {
> 
> What are these symbols needed for?

These symbols are needed to configure timing on the OMAP: hardware
configuration such as setup, hold times, how long the address is on the
bus for, how long CE is asserted, etc.

> Can they be marked EXPORT_SYMBOL_GPL()?
Probably, I am not their maintainer though so I don't know if I am
authorized to make that choice.

thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

