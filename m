Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1IAD5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:57:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41561 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab1IAD5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:57:51 -0400
X-AuditID: cbfee61b-b7b7fae000005864-9d-4e5f02bd9a36
Date: Thu, 01 Sep 2011 12:57:27 +0900
From: Inki Dae <inki.dae@samsung.com>
Subject: RE: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
In-reply-to: <4E5DF323.9020509@shipmail.org>
To: "'Thomas Hellstrom'" <thomas@shipmail.org>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Message-id: <001e01cc685b$439c4850$cad4d8f0$%dae@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcxnubMzD2c1Sm3IQZ23S1DSUV6qhgAoUXGQ
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
 <4E5DF323.9020509@shipmail.org>
X-OriginalArrivalTime: 01 Sep 2011 03:58:26.0243 (UTC)
 FILETIME=[66C57130:01CC685B]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas.

> -----Original Message-----
> From: Thomas Hellstrom [mailto:thomas@shipmail.org]
> Sent: Wednesday, August 31, 2011 5:39 PM
> To: Inki Dae
> Cc: airlied@linux.ie; dri-devel@lists.freedesktop.org;
> sw0312.kim@samsung.com; linux-kernel@vger.kernel.org;
> kyungmin.park@samsung.com; linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC
> EXYNOS4210.
> 
> On 08/26/2011 01:47 PM, Inki Dae wrote:
> > This patch is a DRM Driver for Samsung SoC Exynos4210 and now enables
> only FIMD yet
> > but we will add HDMI support also in the future.
> >
> > this patch is based on git repository below:
> > git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git,
> > branch name: drm-next
> > commit-id: bcc65fd8e929a9d9d34d814d6efc1d2793546922
> >
> > you can refer to our working repository below:
> > http://git.infradead.org/users/kmpark/linux-2.6-samsung
> > branch name: samsung-drm
> >
> > We tried to re-use lowlevel codes of the FIMD driver(s3c-fb.c
> > based on Linux framebuffer) but couldn't so because lowlevel codes
> > of s3c-fb.c are included internally and so FIMD module of this driver
> has
> > its own lowlevel codes.
> >
> > We used GEM framework for buffer management and DMA APIs(dma_alloc_*)
> > for buffer allocation. by using DMA API, we could use CMA later.
> >
> > Refer to this link for CMA(Continuous Memory Allocator):
> > http://lkml.org/lkml/2011/7/20/45
> >
> > this driver supports only physically continuous memory(non-iommu).
> >
> > Links to previous versions of the patchset:
> > v1:<  https://lwn.net/Articles/454380/>
> > v2:<  http://www.spinics.net/lists/kernel/msg1224275.html>
> >
> > Changelog v2:
> > DRM: add DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl command.
> >
> >       this feature maps user address space to physical memory region
> >       once user application requests DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl.
> >
> > DRM: code clean and add exception codes.
> >
> > Changelog v3:
> > DRM: Support multiple irq.
> >
> >       FIMD and HDMI have their own irq handler but DRM Framework can
> regiter only one irq handler
> >       this patch supports mutiple irq for Samsung SoC.
> >
> > DRM: Consider modularization.
> >
> >       each DRM, FIMD could be built as a module.
> >
> > DRM: Have indenpendent crtc object.
> >
> >       crtc isn't specific to SoC Platform so this patch gets a crtc to
be
> used as common object.
> >       created crtc could be attached to any encoder object.
> >
> > DRM: code clean and add exception codes.
> >
> > S
> >
> 
> ...
> 
> > +static struct drm_ioctl_desc samsung_ioctls[] = {
> > +	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_CREATE, samsung_drm_gem_create_ioctl,
> > +			DRM_UNLOCKED),
> > +	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_MAP_OFFSET,
> > +			samsung_drm_gem_map_offset_ioctl, DRM_UNLOCKED),
> > +	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_MMAP,
> > +			samsung_drm_gem_mmap_ioctl, DRM_UNLOCKED),
> > +};
> >
> 
> What about security here? It looks to me like *any* user-space process
> can create a gem object and quickly exhaust available DMA memory space,
> potentially bringing the system down?
> 
> Likewise, there seems to be no owner check in the SAMSUNG_GEM_MMAP
> ioctl, allowing any user-space process unlimited graphics buffer access?
> 
> /Thomas
> 

Right, we should consider security issue also as you mentioned above. thank
you for your pointing out.


