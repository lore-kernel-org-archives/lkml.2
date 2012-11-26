Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2KZDJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:09:59 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60122 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2KZDJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:09:57 -0500
MIME-Version: 1.0
In-Reply-To: <1353669130-32610-1-git-send-email-james.hogan@imgtec.com>
References: <1353669130-32610-1-git-send-email-james.hogan@imgtec.com>
Date: Sun, 25 Nov 2012 22:09:56 -0500
Message-ID: <CADnq5_Pr2asbM6cR8v305SgFoAr_+6ZE3nefFC3oBuKdfe-dwg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm: only build ati_pcigart if PCI enabled
From: Alex Deucher <alexdeucher@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 6:12 AM, James Hogan <james.hogan@imgtec.com> wrote:
> Prevent ati_pcigart.c being built unless PCI is enabled. The exported
> functions in this file are only used by drivers which depend on PCI
> (namely r128 and radeon), and it tries to use PCI specific functions
> (pci_unmap_page, pci_map_page, and pci_dma_mapping_error) that cause
> compiler errors when PCI is disabled.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: David Airlie <airlied@linux.ie>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 2ff5cef..3e303b1b 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -8,7 +8,7 @@ drm-y       :=  drm_auth.o drm_buffer.o drm_bufs.o drm_cache.o \
>                 drm_context.o drm_dma.o \
>                 drm_drv.o drm_fops.o drm_gem.o drm_ioctl.o drm_irq.o \
>                 drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
> -               drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
> +               drm_agpsupport.o drm_scatter.o drm_pci.o \
>                 drm_platform.o drm_sysfs.o drm_hashtab.o drm_mm.o \
>                 drm_crtc.o drm_modes.o drm_edid.o \
>                 drm_info.o drm_debugfs.o drm_encoder_slave.o \
> @@ -16,6 +16,7 @@ drm-y       :=        drm_auth.o drm_buffer.o drm_bufs.o drm_cache.o \
>
>  drm-$(CONFIG_COMPAT) += drm_ioc32.o
>  drm-$(CONFIG_DRM_GEM_CMA_HELPER) += drm_gem_cma_helper.o
> +drm-$(CONFIG_PCI) += ati_pcigart.o
>
>  drm-usb-y   := drm_usb.o
>
> --
> 1.7.7.6
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
