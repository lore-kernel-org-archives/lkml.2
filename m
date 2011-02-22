Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1BVOow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:44:52 -0500
Received: from kroah.org ([198.145.64.141]:41985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1BVOot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:44:49 -0500
Date: Tue, 22 Feb 2011 06:44:26 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110222144426.GA1232@kroah.com>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222121704.19437.4650.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:17:46PM +0000, Alan Cox wrote:
> This is an initial staging driver for the GMA500. It's been stripped out
> of the PVR drivers and crunched together from various bits of code and
> different kernels.

Nice!

> Currently it's unaccelerated but still pretty snappy even compositing with
> the frame buffer X server.

So that's all that is needed on the userspace side?  Or is there a
driver for X that also goes along with this patch that is available
somewhere?

> Lots of work is needed to rework the ttm and bo interfaces from being
> ripped out and then 2D acceleration wants putting back for framebuffer and
> somehow eventually via DRM.
> 
> There is no support for the parts without open source userspace (video
> accelerators, 3D) as per kernel policy.
> 
> I'm not a DRM expert so if there is anyone with a GMA500 who actually knows
> something about DRI internals then help would be most welcome.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/staging/Kconfig                         |    2 
>  drivers/staging/Makefile                        |    9 
>  drivers/staging/gma500/Kconfig                  |   12 
>  drivers/staging/gma500/Makefile                 |   30 
>  drivers/staging/gma500/psb_bl.c                 |  167 ++
>  drivers/staging/gma500/psb_buffer.c             |  450 ++++++
>  drivers/staging/gma500/psb_drm.h                |  696 ++++++++++
>  drivers/staging/gma500/psb_drv.c                | 1677 +++++++++++++++++++++++
>  drivers/staging/gma500/psb_drv.h                | 1139 ++++++++++++++++
>  drivers/staging/gma500/psb_fb.c                 |  840 ++++++++++++
>  drivers/staging/gma500/psb_fb.h                 |   59 +
>  drivers/staging/gma500/psb_fence.c              |  122 ++
>  drivers/staging/gma500/psb_gfx.mod.c            |   27 
>  drivers/staging/gma500/psb_gtt.c                | 1034 ++++++++++++++
>  drivers/staging/gma500/psb_gtt.h                |  105 +
>  drivers/staging/gma500/psb_intel_bios.c         |  301 ++++
>  drivers/staging/gma500/psb_intel_bios.h         |  430 ++++++
>  drivers/staging/gma500/psb_intel_display.c      | 1489 ++++++++++++++++++++
>  drivers/staging/gma500/psb_intel_display.h      |   25 
>  drivers/staging/gma500/psb_intel_drv.h          |  247 +++
>  drivers/staging/gma500/psb_intel_i2c.c          |  169 ++
>  drivers/staging/gma500/psb_intel_lvds.c         |  889 ++++++++++++
>  drivers/staging/gma500/psb_intel_modes.c        |   77 +
>  drivers/staging/gma500/psb_intel_opregion.c     |   78 +
>  drivers/staging/gma500/psb_intel_reg.h          | 1200 ++++++++++++++++
>  drivers/staging/gma500/psb_intel_sdvo.c         | 1298 ++++++++++++++++++
>  drivers/staging/gma500/psb_intel_sdvo_regs.h    |  338 +++++
>  drivers/staging/gma500/psb_irq.c                |  637 +++++++++
>  drivers/staging/gma500/psb_irq.h                |   49 +
>  drivers/staging/gma500/psb_mmu.c                |  919 +++++++++++++
>  drivers/staging/gma500/psb_powermgmt.c          |  797 +++++++++++
>  drivers/staging/gma500/psb_powermgmt.h          |   96 +
>  drivers/staging/gma500/psb_pvr_glue.c           |   73 +
>  drivers/staging/gma500/psb_pvr_glue.h           |   25 
>  drivers/staging/gma500/psb_reg.h                |  588 ++++++++
>  drivers/staging/gma500/psb_reset.c              |   90 +
>  drivers/staging/gma500/psb_sgx.c                |  238 +++
>  drivers/staging/gma500/psb_sgx.h                |   32 
>  drivers/staging/gma500/psb_ttm_fence.c          |  605 ++++++++
>  drivers/staging/gma500/psb_ttm_fence_api.h      |  272 ++++
>  drivers/staging/gma500/psb_ttm_fence_driver.h   |  302 ++++
>  drivers/staging/gma500/psb_ttm_fence_user.c     |  237 +++
>  drivers/staging/gma500/psb_ttm_fence_user.h     |  140 ++
>  drivers/staging/gma500/psb_ttm_glue.c           |  349 +++++
>  drivers/staging/gma500/psb_ttm_placement_user.c |  628 +++++++++
>  drivers/staging/gma500/psb_ttm_placement_user.h |  252 +++
>  drivers/staging/gma500/psb_ttm_userobj_api.h    |   85 +
>  47 files changed, 19320 insertions(+), 4 deletions(-)

Can I also get a TODO file for this directory that lists what needs to
be done to move it out of the staging tree, as well as an email to
contact for patches and questions?

> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -62,12 +62,13 @@ obj-$(CONFIG_SOLO6X10)		+= solo6x10/
>  obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
>  obj-$(CONFIG_ACPI_QUICKSTART)	+= quickstart/
>  obj-$(CONFIG_WESTBRIDGE_ASTORIA)	+= westbridge/astoria/
> -obj-$(CONFIG_SBE_2T3E3)	+= sbe-2t3e3/
> +obj-$(CONFIG_SBE_2T3E3)		+= sbe-2t3e3/
>  obj-$(CONFIG_ATH6K_LEGACY)	+= ath6kl/
>  obj-$(CONFIG_USB_ENESTORAGE)	+= keucr/
> -obj-$(CONFIG_BCM_WIMAX)	+= bcm/
> +obj-$(CONFIG_BCM_WIMAX)		+= bcm/
>  obj-$(CONFIG_FT1000)		+= ft1000/
> -obj-$(CONFIG_SND_INTEL_SST)		+= intel_sst/
> -obj-$(CONFIG_SPEAKUP)	+= speakup/
> +obj-$(CONFIG_SND_INTEL_SST)	+= intel_sst/
> +obj-$(CONFIG_SPEAKUP)		+= speakup/
>  obj-$(CONFIG_TOUCHSCREEN_CLEARPAD_TM1217)	+= cptm1217/
>  obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
> +obj-$(CONFIG_DRM_PSB)		+= gma500/

What's with the formatting changes to this file?

thanks,

greg k-h
