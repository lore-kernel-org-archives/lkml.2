Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1HaHd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 03:33:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11119 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1HaHd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 03:33:57 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-0c-4e5de3e1bc65
Date: Wed, 31 Aug 2011 16:33:30 +0900
From: Inki Dae <inki.dae@samsung.com>
Subject: RE: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
In-reply-to: <20110831020652.GA16547@dumpdata.com>
To: "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Rob Clark'" <robdclark@gmail.com>
Cc: sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Message-id: <001101cc67b0$47b63410$d7229c30$%dae@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
Thread-index: AcxngvT0idM5mbOAQ/y16mD8SrWyZwAJ7Faw
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
 <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
 <20110831020652.GA16547@dumpdata.com>
X-OriginalArrivalTime: 31 Aug 2011 07:34:30.0014 (UTC)
 FILETIME=[6B5E29E0:01CC67B0]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Konrad Rzeszutek Wilk.

> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Wednesday, August 31, 2011 11:07 AM
> To: Rob Clark
> Cc: Inki Dae; sw0312.kim@samsung.com; linux-kernel@vger.kernel.org; dri-
> devel@lists.freedesktop.org; kyungmin.park@samsung.com; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC
> EXYNOS4210.
> 
> > > +       entry->vaddr = dma_alloc_writecombine(dev->dev, entry->size,
> > > +                       (dma_addr_t *)&entry->paddr, GFP_KERNEL);
> > > +       if (!entry->paddr) {
> > > +               DRM_ERROR("failed to allocate buffer.\n");
> > > +               return -ENOMEM;
> > > +       }
> > > +
> > > +       DRM_DEBUG_KMS("allocated : vaddr(0x%x), paddr(0x%x),
> size(0x%x)\n",
> > > +                       (unsigned int)entry->vaddr, entry->paddr,
entry-
> >size);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > [snip]
> >
> > > diff --git a/drivers/gpu/drm/samsung/samsung_drm_buf.h
> b/drivers/gpu/drm/samsung/samsung_drm_buf.h
> > > new file mode 100644
> > > index 0000000..d6a7e95
> > > --- /dev/null
> > > +++ b/drivers/gpu/drm/samsung/samsung_drm_buf.h
> > [snip]
> > > +/**
> > > + * samsung drm buffer entry structure.
> > > + *
> > > + * @paddr: physical address of allocated memory.
> > > + * @vaddr: kernel virtual address of allocated memory.
> > > + * @size: size of allocated memory.
> > > + */
> > > +struct samsung_drm_buf_entry {
> > > +       unsigned int paddr;
> 
> This could be made 'dma_addr_t' and then you can drop all of the
> casts to (dma_addr_t *).
> 

Ok, I will correct it right now. thank you.

> .. snip..
> > > +static int samsung_drm_connector_get_modes(struct drm_connector
> *connector)
> 
> Why not make the return be 'unsigned int'?
> 

Yes, I think so, but please, see drm_connector_helper_funcs structure of
drm_crtc_helper.h. get_modes callback has int type as return.

> .. snip..
> > > +/* get detection status of display device. */
> > > +static enum drm_connector_status
> > > +samsung_drm_connector_detect(struct drm_connector *connector, bool
> force)
> > > +{
> > > +       struct samsung_drm_connector *samsung_connector =
> > > +               to_samsung_connector(connector);
> > > +       struct samsung_drm_display *display =
> > > +               samsung_drm_get_manager(samsung_connector->encoder)-
> >display;
> > > +       unsigned int ret = connector_status_unknown;
> 
> Not 'enum drm_connector_status ret = connector_status_unknown' ?
> 

Oh, you are right, I will fix up it. thank you.

> > > +
> > > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > > +
> > > +       if (display && display->is_connected) {
> > > +               if (display->is_connected())
> > > +                       ret = connector_status_connected;
> > > +               else
> > > +                       ret = connector_status_disconnected;
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> 
> .. snip..
> > > +static void samsung_drm_fb_destroy(struct drm_framebuffer *fb)
> > > +{
> > > +       struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
> > > +       int ret;
> 
> Get rid of 'ret'

It seems that it doesn't need 'ret' but it needs to check 'ret' because of
drm_gem_handle_delete().

> > > +
> > > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > > +
> > > +       drm_framebuffer_cleanup(fb);
> > > +
> > > +       if (samsung_fb->is_default) {
> > > +               ret = drm_gem_handle_delete(samsung_fb->file_priv,
> > > +                               samsung_fb->gem_handle);
> >
> > why not keep the gem buffer ptr, and do something like:
> >
> >   drm_gem_object_unreference_unlocked(samsung_fb->bo)..
> >
> > this way, you get the right behavior if someone somewhere else took a
> > ref to the gem buffer object?  And it avoids needing to keep the
> > file_priv ptr in the fb (which seems a bit strange)
> >
> >
> > > +               if (ret < 0)
> > > +                       DRM_ERROR("failed to delete
drm_gem_handle.\n");
> 
> And just do the check on the function return value here. You are not using
> the 'ret' for anything.

Yes, right. it just prints out error message because drm_gem_handle_delete
function which is mainline function doesn't leave any error message. anyway
using 'ret' is not clear. so I will remove 'ret' and check
drm_gem_handle_delete function directly instead to print out error message.

> > > +       }
> > > +
> > > +       kfree(samsung_fb);
> > > +}
> > > +
> > [snip]
> 
> Hm, so I stopped here - just realized that I am missing some of the code
> and I should look at the original patch..

Thank you for your comments. it's been very useful. please give me your
comments and advices anytime then I will be pleased.


