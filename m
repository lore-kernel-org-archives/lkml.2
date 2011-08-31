Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1HaI52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 04:57:28 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:2245 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750779Ab1HaI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 04:57:25 -0400
X-Greylist: delayed 986 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Aug 2011 04:57:25 EDT
Message-ID: <4E5DF323.9020509@shipmail.org>
Date: Wed, 31 Aug 2011 10:38:59 +0200
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: airlied@linux.ie, dri-devel@lists.freedesktop.org, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
In-Reply-To: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 01:47 PM, Inki Dae wrote:
> This patch is a DRM Driver for Samsung SoC Exynos4210 and now enables only FIMD yet
> but we will add HDMI support also in the future.
>
> this patch is based on git repository below:
> git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git,
> branch name: drm-next
> commit-id: bcc65fd8e929a9d9d34d814d6efc1d2793546922
>
> you can refer to our working repository below:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung
> branch name: samsung-drm
>
> We tried to re-use lowlevel codes of the FIMD driver(s3c-fb.c
> based on Linux framebuffer) but couldn't so because lowlevel codes
> of s3c-fb.c are included internally and so FIMD module of this driver has
> its own lowlevel codes.
>
> We used GEM framework for buffer management and DMA APIs(dma_alloc_*)
> for buffer allocation. by using DMA API, we could use CMA later.
>
> Refer to this link for CMA(Continuous Memory Allocator):
> http://lkml.org/lkml/2011/7/20/45
>
> this driver supports only physically continuous memory(non-iommu).
>
> Links to previous versions of the patchset:
> v1:<  https://lwn.net/Articles/454380/>
> v2:<  http://www.spinics.net/lists/kernel/msg1224275.html>
>
> Changelog v2:
> DRM: add DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl command.
>
>       this feature maps user address space to physical memory region
>       once user application requests DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl.
>
> DRM: code clean and add exception codes.
>
> Changelog v3:
> DRM: Support multiple irq.
>
>       FIMD and HDMI have their own irq handler but DRM Framework can regiter only one irq handler
>       this patch supports mutiple irq for Samsung SoC.
>
> DRM: Consider modularization.
>
>       each DRM, FIMD could be built as a module.
>
> DRM: Have indenpendent crtc object.
>
>       crtc isn't specific to SoC Platform so this patch gets a crtc to be used as common object.
>       created crtc could be attached to any encoder object.
>
> DRM: code clean and add exception codes.
>
> S
>    

...

> +static struct drm_ioctl_desc samsung_ioctls[] = {
> +	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_CREATE, samsung_drm_gem_create_ioctl,
> +			DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_MAP_OFFSET,
> +			samsung_drm_gem_map_offset_ioctl, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_MMAP,
> +			samsung_drm_gem_mmap_ioctl, DRM_UNLOCKED),
> +};
>    

What about security here? It looks to me like *any* user-space process 
can create a gem object and quickly exhaust available DMA memory space, 
potentially bringing the system down?

Likewise, there seems to be no owner check in the SAMSUNG_GEM_MMAP 
ioctl, allowing any user-space process unlimited graphics buffer access?

/Thomas



