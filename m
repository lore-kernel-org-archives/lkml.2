Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1HaGwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:52:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58208 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1HaGwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:52:10 -0400
X-AuditID: cbfee61b-b7b7fae000005864-13-4e5dda186994
Date: Wed, 31 Aug 2011 15:51:44 +0900
From: Inki Dae <inki.dae@samsung.com>
Subject: RE: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
In-reply-to: <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
To: "'Rob Clark'" <robdclark@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Message-id: <001001cc67aa$72760460$57620d20$%dae@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
Thread-index: AcxngV1ClKyAnBCzQMihSwrfJ48DVwAFleBQ
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
 <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
X-OriginalArrivalTime: 31 Aug 2011 06:52:44.0799 (UTC)
 FILETIME=[9624B0F0:01CC67AA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rob.
Below is my answers and questions. and could you please include me as CC
when you post your driver?

Thank you.

> -----Original Message-----
> From: Rob Clark [mailto:robdclark@gmail.com]
> Sent: Wednesday, August 31, 2011 10:58 AM
> To: Inki Dae
> Cc: airlied@linux.ie; dri-devel@lists.freedesktop.org;
> sw0312.kim@samsung.com; linux-kernel@vger.kernel.org;
> kyungmin.park@samsung.com; linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC
> EXYNOS4210.
> 
> Hi Inki,
> 
> Sorry for slightly overdue review.. it took a little while to go
> through the whole thing
> 

I  will be always pleased you to give me your advices and comments anytime.
:)

> comments in-line below
> 
> 
> On Fri, Aug 26, 2011 at 6:47 AM, Inki Dae <inki.dae@samsung.com> wrote:
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
> > v1: < https://lwn.net/Articles/454380/ >
> > v2: < http://www.spinics.net/lists/kernel/msg1224275.html >
> >
> > Changelog v2:
> > DRM: add DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl command.
> >
> >     this feature maps user address space to physical memory region
> >     once user application requests DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl.
> >
> > DRM: code clean and add exception codes.
> >
> > Changelog v3:
> > DRM: Support multiple irq.
> >
> >     FIMD and HDMI have their own irq handler but DRM Framework can
> regiter only one irq handler
> >     this patch supports mutiple irq for Samsung SoC.
> >
> > DRM: Consider modularization.
> >
> >     each DRM, FIMD could be built as a module.
> >
> > DRM: Have indenpendent crtc object.
> >
> >     crtc isn't specific to SoC Platform so this patch gets a crtc to be
> used as common object.
> >     created crtc could be attached to any encoder object.
> >
> > DRM: code clean and add exception codes.
> >
> > Signed-off-by: Inki Dae <inki.dae@samsung.com>
> > Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> > Signed-off-by: SeungWoo Kim <sw0312.kim@samsung.com>
> > Signed-off-by: kyungmin.park <kyungmin.park@samsung.com>
> > ---
> [snip]
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_buf.c
> b/drivers/gpu/drm/samsung/samsung_drm_buf.c
> > new file mode 100644
> > index 0000000..563d07e
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_buf.c
> [snip]
> > +static int lowlevel_buffer_allocate(struct drm_device *dev,
> > +               struct samsung_drm_buf_entry *entry)
> > +{
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> 
> very minor point, but DRM_DEBUG_KMS() already includes the function
> name.. not sure if __FILE__ is needed everywhere
> 
> > +
> > +       entry->vaddr = dma_alloc_writecombine(dev->dev, entry->size,
> > +                       (dma_addr_t *)&entry->paddr, GFP_KERNEL);
> > +       if (!entry->paddr) {
> > +               DRM_ERROR("failed to allocate buffer.\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       DRM_DEBUG_KMS("allocated : vaddr(0x%x), paddr(0x%x),
> size(0x%x)\n",
> > +                       (unsigned int)entry->vaddr, entry->paddr, entry-
> >size);
> > +
> > +       return 0;
> > +}
> > +
> [snip]
> 
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_buf.h
> b/drivers/gpu/drm/samsung/samsung_drm_buf.h
> > new file mode 100644
> > index 0000000..d6a7e95
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_buf.h
> [snip]
> > +/**
> > + * samsung drm buffer entry structure.
> > + *
> > + * @paddr: physical address of allocated memory.
> > + * @vaddr: kernel virtual address of allocated memory.
> > + * @size: size of allocated memory.
> > + */
> > +struct samsung_drm_buf_entry {
> > +       unsigned int paddr;
> > +       void __iomem *vaddr;
> > +       unsigned int size;
> > +};
> 
> any reason not to combine this w/ samsung_drm_gem_obj to avoid extra
> levels of indirection?  (This would let you collapse some of the
> buffer allocation/deletion fxns into one level too.)
> 
I wanted it separates buffer allocator from gem but now seeing it, it
doesn't need to do so as you pointed out. I will combine it to
samsung_drm_gem_obj. thank you.

> > +
> > +/**
> > + * samsung drm buffer structure.
> > + *
> > + * @entry: pointer to samsung drm buffer entry object.
> > + * @flags: it means memory type to be alloated or cache attributes.
> > + * @handle: pointer to specific buffer object.
> > + * @id: unique id to specific buffer object.
> > + *
> > + * ps. this object would be transfered to user as kms_bo.handle so
> > + *     user can access to memory through kms_bo.handle.
> > + */
> > +struct samsung_drm_gem_obj {
> > +       struct drm_gem_object base;
> > +       struct samsung_drm_buf_entry *entry;
> > +       unsigned int flags;
> > +
> > +       unsigned int handle;
> > +       unsigned int id;
> > +};
> > +
> > +/* create new buffer object and memory region and add the object to
> list. */
> > +struct samsung_drm_gem_obj *samsung_drm_buf_new(struct drm_device *dev,
> > +               unsigned int size);
> > +
> > +/* allocate physical memory and add its object to list. */
> > +struct samsung_drm_gem_obj *samsung_drm_buf_create(struct drm_device
> *dev,
> > +               unsigned int size);
> > +
> > +/* remove allocated physical memory. */
> > +int samsung_drm_buf_destroy(struct drm_device *dev,
> > +               struct samsung_drm_gem_obj *in_obj);
> > +
> > +/* find object added to list. */
> > +struct samsung_drm_gem_obj *samsung_drm_buffer_find(struct drm_device
> *dev,
> > +               struct samsung_drm_gem_obj *in_obj, unsigned int paddr);
> 
> this doesn't appear to be used anywhere
> 
Oh, it’s my mistake. I will remove it. thank you.

> > +
> > +#endif
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_connector.c
> b/drivers/gpu/drm/samsung/samsung_drm_connector.c
> > new file mode 100644
> > index 0000000..987a629
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_connector.c
> [snip]
> > +
> > +/* convert samsung_video_timings to drm_display_mode */
> > +static inline void
> > +convert_to_display_mode(struct fb_videomode *timing,
> > +                       struct drm_display_mode *mode)
> 
> I sort of prefer copy functions to copy right to left, Ie.
> 
> convert_foo(a, b)
> 
> copies from b to a.. somehow this feels more natural.  (Think a = b,
> the receiving arg is on the left.. same as w/ memcpy()).  Same applies
> w/ the inverse of this fxn.
> 
Ok, I will modify it like your saying. Thank you.

> > +{
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       mode->clock = timing->pixclock / 1000;
> > +
> > +       mode->hdisplay = timing->xres;
> > +       mode->hsync_start = mode->hdisplay + timing->left_margin;
> > +       mode->hsync_end = mode->hsync_start + timing->hsync_len;
> > +       mode->htotal = mode->hsync_end + timing->right_margin;
> > +
> > +       mode->vdisplay = timing->yres;
> > +       mode->vsync_start = mode->vdisplay + timing->upper_margin;
> > +       mode->vsync_end = mode->vsync_start + timing->vsync_len;
> > +       mode->vtotal = mode->vsync_end + timing->lower_margin;
> > +}
> > +
> > +/* convert drm_display_mode to samsung_video_timings */
> > +static inline void
> > +convert_to_video_timing(struct drm_display_mode *mode,
> > +                       struct fb_videomode *timing)
> > +{
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       timing->pixclock = mode->clock * 1000;
> > +
> > +       timing->xres = mode->hdisplay;
> > +       timing->left_margin = mode->hsync_start - mode->hdisplay;
> > +       timing->hsync_len = mode->hsync_end - mode->hsync_start;
> > +       timing->right_margin = mode->htotal - mode->hsync_end;
> > +
> > +       timing->yres = mode->vdisplay;
> > +       timing->upper_margin = mode->vsync_start - mode->vdisplay;
> > +       timing->vsync_len = mode->vsync_end - mode->vsync_start;
> > +       timing->lower_margin = mode->vtotal - mode->vsync_end;
> > +}
> > +
> > +static int samsung_drm_connector_get_modes(struct drm_connector
> *connector)
> > +{
> > +       struct samsung_drm_connector *samsung_connector =
> > +               to_samsung_connector(connector);
> > +       struct samsung_drm_display *display =
> > +               samsung_drm_get_manager(samsung_connector->encoder)-
> >display;
> > +       unsigned int count;
> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       if (display && display->get_edid) {
> > +               void *edid = kzalloc(MAX_EDID, GFP_KERNEL);
> > +               if (!edid) {
> > +                       DRM_ERROR("failed to allocate edid\n");
> > +                       return 0;
> > +               }
> > +
> > +               display->get_edid(connector, edid, MAX_EDID);
> > +
> > +               drm_mode_connector_update_edid_property(connector,
edid);
> > +               count = drm_add_edid_modes(connector, edid);
> > +
> > +               kfree(connector->display_info.raw_edid);
> > +               connector->display_info.raw_edid = edid;
> > +       } else {
> > +               struct drm_display_mode *mode =
drm_mode_create(connector-
> >dev);
> > +               struct fb_videomode *timing;
> > +
> > +               if (display && display->get_timing)
> > +                       timing = display->get_timing();
> 
> also seems a bit weird to not do: display->get_timings(display)..
> 
> maybe you don't have the case of multiple instances of the same
> display time.. but maybe someday you need that.  (Maybe this is just
> an artifact of how the API of your current lower layer driver is.. but
> maybe now is a good time to think about those APIs)
> 

display is static object set by hardware specific driver such as display
controller or hdmi. each hardware specific driver has their own display
object statically. You can refer to the definition in samsung_drm_fimd.c.
and I understood a encoder and a connector is 1:1 relationship, when any
hardware specific driver is probed, they would be created with a manager
that includes their own display object as pointer. Could you please give me
more comments why display object should be considered for multiple
instances? I am afraid there is any part I don't care.

thank you.

> Same comment about not passing the display instance ptr to some of the
> other display fxn ptrs elsewhere in the code.
> 
> > +               else
> > +                       return 0;
> > +
> > +               convert_to_display_mode(timing, mode);
> > +
> > +               mode->type = DRM_MODE_TYPE_DRIVER |
> DRM_MODE_TYPE_PREFERRED;
> > +               drm_mode_set_name(mode);
> > +               drm_mode_probed_add(connector, mode);
> > +
> > +               count = 1;
> > +       }
> > +
> > +       return count;
> > +}
> > +
> > +static int samsung_drm_connector_mode_valid(struct drm_connector
> *connector,
> > +                                           struct drm_display_mode
*mode)
> > +{
> > +       struct samsung_drm_connector *samsung_connector =
> > +               to_samsung_connector(connector);
> > +       struct samsung_drm_display *display =
> > +               samsung_drm_get_manager(samsung_connector->encoder)-
> >display;
> > +       struct fb_videomode timing;
> > +       int ret = MODE_BAD;
> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       convert_to_video_timing(mode, &timing);
> > +
> > +       if (display && display->check_timing)
> > +               if (!display->check_timing((void *)&timing))
> > +                       ret = MODE_OK;
> > +
> > +       return ret;
> > +}
> > +
> > +struct drm_encoder *samsung_drm_best_encoder(struct drm_connector
> *connector)
> > +{
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +       return to_samsung_connector(connector)->encoder;
> > +}
> > +
> > +static struct drm_connector_helper_funcs samsung_connector_helper_funcs
> = {
> > +       .get_modes      = samsung_drm_connector_get_modes,
> > +       .mode_valid     = samsung_drm_connector_mode_valid,
> > +       .best_encoder   = samsung_drm_best_encoder,
> > +};
> > +
> > +/* get detection status of display device. */
> > +static enum drm_connector_status
> > +samsung_drm_connector_detect(struct drm_connector *connector, bool
> force)
> > +{
> > +       struct samsung_drm_connector *samsung_connector =
> > +               to_samsung_connector(connector);
> > +       struct samsung_drm_display *display =
> > +               samsung_drm_get_manager(samsung_connector->encoder)-
> >display;
> > +       unsigned int ret = connector_status_unknown;
> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       if (display && display->is_connected) {
> > +               if (display->is_connected())
> > +                       ret = connector_status_connected;
> > +               else
> > +                       ret = connector_status_disconnected;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static void samsung_drm_connector_destroy(struct drm_connector
> *connector)
> > +{
> > +       struct samsung_drm_connector *samsung_connector =
> > +               to_samsung_connector(connector);
> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       drm_sysfs_connector_remove(connector);
> > +       drm_connector_cleanup(connector);
> > +       connector->dev->mode_config.num_connector--;
> 
> I wonder if num_connector-- should be in drm_connector_cleanup()..
> 
> I missed this in OMAP driver, but it seems that none of the other drm
> drivers are directly decrementing this.. and it would seem more
> symmetric for it to be in drm_connector_cleanup().  But would be

For this, it was already commented by Joonyoun Shim.

> interesting to see what others think.  (I guess no one has really
> dealt w/ dynamic creation/deletion of connectors yet?)
> 

I think our driver creates encoder and connector dynamically. please, see
samsung_drm_subdrv_probe() of samsung_drm_core.c. hardware specific drivers
such as display controller and hdmi are registered to
samsung_drm_subdrv_list and when drm driver is probed, once subdrv->probe
callback is called, a encoder and a connector would be created dynamically.
if there is any missing point, feel free to give me your comments please.

Thank you.

> > +       kfree(samsung_connector);
> > +}
> > +
> [snip]
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_crtc.c
> b/drivers/gpu/drm/samsung/samsung_drm_crtc.c
> > new file mode 100644
> > index 0000000..1c5a70a
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_crtc.c
> [snip]
> > +
> > +struct samsung_drm_crtc {
> > +       struct drm_crtc                 drm_crtc;
> > +       struct samsung_drm_overlay      overlay;
> 
> 
> I guess you are looking fwd to drm_plane support too :-)
> 
> 
> > +       unsigned int                    pipe;
> > +};
> > +
> [snip]
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_fb.c
> b/drivers/gpu/drm/samsung/samsung_drm_fb.c
> > new file mode 100644
> > index 0000000..42096eb
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_fb.c
> > @@ -0,0 +1,248 @@
> > +/*
> > + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> > + * Authors:
> > + *     Inki Dae <inki.dae@samsung.com>
> > + *     Joonyoung Shim <jy0922.shim@samsung.com>
> > + *     SeungWoo Kim <sw0312.kim@samsung.com>
> > + *
> > + * Permission is hereby granted, free of charge, to any person
> obtaining a
> > + * copy of this software and associated documentation files (the
> "Software"),
> > + * to deal in the Software without restriction, including without
> limitation
> > + * the rights to use, copy, modify, merge, publish, distribute,
> sublicense,
> > + * and/or sell copies of the Software, and to permit persons to whom
> the
> > + * Software is furnished to do so, subject to the following conditions:
> > + *
> > + * The above copyright notice and this permission notice (including the
> next
> > + * paragraph) shall be included in all copies or substantial portions
> of the
> > + * Software.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR
> > + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY,
> > + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT
> SHALL
> > + * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
> DAMAGES OR
> > + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE,
> > + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
> OR
> > + * OTHER DEALINGS IN THE SOFTWARE.
> > + */
> > +
> > +#include "drmP.h"
> > +#include "drm_crtc.h"
> > +#include "drm_crtc_helper.h"
> > +
> > +#include "samsung_drm_fb.h"
> > +#include "samsung_drm_buf.h"
> > +#include "samsung_drm_gem.h"
> > +
> > +#define to_samsung_fb(x)       container_of(x, struct samsung_drm_fb,
fb)
> > +
> > +struct samsung_drm_fb {
> > +       struct drm_framebuffer          fb;
> > +       struct drm_file                 *file_priv;
> > +       struct samsung_drm_gem_obj      *samsung_gem_obj;
> > +       unsigned int                    is_default;
> > +
> > +       /* samsung gem object handle. */
> > +       unsigned int                    gem_handle;
> > +       /* unique id to buffer object. */
> > +       unsigned int                    id;
> > +
> > +       unsigned int                    fb_size;
> > +       unsigned long                   paddr;
> > +       void __iomem                    *vaddr;
> > +};
> > +
> > +static void samsung_drm_fb_destroy(struct drm_framebuffer *fb)
> > +{
> > +       struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
> > +       int ret;
> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       drm_framebuffer_cleanup(fb);
> > +
> > +       if (samsung_fb->is_default) {
> > +               ret = drm_gem_handle_delete(samsung_fb->file_priv,
> > +                               samsung_fb->gem_handle);
> 
> why not keep the gem buffer ptr, and do something like:
> 
>   drm_gem_object_unreference_unlocked(samsung_fb->bo)..
> 
> this way, you get the right behavior if someone somewhere else took a
> ref to the gem buffer object?  And it avoids needing to keep the
> file_priv ptr in the fb (which seems a bit strange)
> 
> 
Yes, at booting time, one gem object is created. this is for linux
framebuffer and used as default buffer. register_framebuffer function is
called one time at booting time by drm driver. but when this driver is built
as modules, this gem object should be released with rmmod modules. and the
reason fb has file point is that drm_gem_handle_delete requests it to
release a gem object. our driver considered modularization also. If there is
any point I missed, give me any comment please. Thank you.

> > +               if (ret < 0)
> > +                       DRM_ERROR("failed to delete drm_gem_handle.\n");
> > +       }
> > +
> > +       kfree(samsung_fb);
> > +}
> > +
> [snip]
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_gem.c
> b/drivers/gpu/drm/samsung/samsung_drm_gem.c
> > new file mode 100644
> > index 0000000..1e167a6
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_gem.c
> [snip]
> > +
> > +static unsigned int get_gem_mmap_offset(struct drm_gem_object *obj)
> > +{
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       return (unsigned int)obj->map_list.hash.key << PAGE_SHIFT;
> > +}
> 
> fwiw, candidate to move to drm_gem helper fxn (I have same in my
> driver.. but this wasn't included in my earlier patch to add a couple
> common drm_gem helper fxns like create/free_mmap_offset)
> 

I referred to your code. :) and I wish this code is moved to mainline to be
used commonly.

> > +
> > +/**
> > + * samsung_drm_gem_create_mmap_offset - create a fake mmap offset for
> an object
> > + * @obj: obj in question
> > + *
> > + * GEM memory mapping works by handing back to userspace a fake mmap
> offset
> > + * it can use in a subsequent mmap(2) call.  The DRM core code then
> looks
> > + * up the object based on the offset and sets up the various memory
> mapping
> > + * structures.
> > + *
> > + * This routine allocates and attaches a fake offset for @obj.
> > + */
> > +static int
> > +samsung_drm_gem_create_mmap_offset(struct drm_gem_object *obj)
> 
> some of these other fxns you might at least want to include a comment
> to replace w/ drm_gem helpers once that patch lands.. your's would be
> the 4th driver w/ nearly identical code (well, if you can count
> non-mainline drivers) ;-)
> 
Ok, I know you had posted this patch to be used commonly. but it isn't
applied to dri git. If applied, I will change it to common fxn but for now I
will add a comment.
> > +{
> > +       struct drm_device *dev = obj->dev;
> > +       struct drm_gem_mm *mm = dev->mm_private;
> > +       struct drm_map_list *list;
> > +       struct drm_local_map *map;
> > +       int ret = 0;
> > +
> > +       /* Set the object up for mmap'ing */
> > +       list = &obj->map_list;
> > +       list->map = kzalloc(sizeof(struct drm_map_list), GFP_KERNEL);
> > +       if (!list->map)
> > +               return -ENOMEM;
> > +
> > +       map = list->map;
> > +       map->type = _DRM_GEM;
> > +       map->size = obj->size;
> > +       map->handle = obj;
> > +
> > +       /* Get a DRM GEM mmap offset allocated... */
> > +       list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
> > +                                                   obj->size /
PAGE_SIZE,
> > +                                                   0, 0);
> > +       if (!list->file_offset_node) {
> > +               DRM_ERROR("failed to allocate offset for bo %d\n",
> > +                         obj->name);
> > +               ret = -ENOSPC;
> > +               goto out_free_list;
> > +       }
> > +
> > +       list->file_offset_node =
drm_mm_get_block(list->file_offset_node,
> > +                                                 obj->size / PAGE_SIZE,
> > +                                                 0);
> > +       if (!list->file_offset_node) {
> > +               ret = -ENOMEM;
> > +               goto out_free_list;
> > +       }
> > +
> > +       list->hash.key = list->file_offset_node->start;
> > +       ret = drm_ht_insert_item(&mm->offset_hash, &list->hash);
> > +       if (ret) {
> > +               DRM_ERROR("failed to add to map hash\n");
> > +               goto out_free_mm;
> > +       }
> > +
> > +       return 0;
> > +
> > +out_free_mm:
> > +       drm_mm_put_block(list->file_offset_node);
> > +out_free_list:
> > +       kfree(list->map);
> > +       list->map = NULL;
> > +
> > +       return ret;
> > +}
> > +
> > +static void
> > +samsung_drm_gem_free_mmap_offset(struct drm_gem_object *obj)
> > +{
> > +       struct drm_device *dev = obj->dev;
> > +       struct drm_gem_mm *mm = dev->mm_private;
> > +       struct drm_map_list *list = &obj->map_list;
> > +
> > +       drm_ht_remove_item(&mm->offset_hash, &list->hash);
> > +       drm_mm_put_block(list->file_offset_node);
> > +       kfree(list->map);
> > +       list->map = NULL;
> > +}
> [snip]
> > +struct samsung_drm_gem_obj *
> > +               find_samsung_drm_gem_object(struct drm_file *file_priv,
> > +                       struct drm_device *dev, unsigned int handle)
> > +{
> > +       struct drm_gem_object *gem_obj;
> > +
> > +       gem_obj = drm_gem_object_lookup(dev, file_priv, handle);
> > +       if (!gem_obj) {
> > +               DRM_LOG_KMS("a invalid gem object not registered to
> lookup.\n");
> > +               return NULL;
> > +       }
> > +
> > +       /**
> > +        * unreference refcount of the gem object.
> > +        * at drm_gem_object_lookup(), the gem object was referenced.
> > +        */
> > +       drm_gem_object_unreference(gem_obj);
> 
> this doesn't seem right, to drop the reference before you use the
> buffer elsewhere..
> 
No, see drm_gem_object_lookup fxn. at this function, if there is a object
found then drm_gem_object_reference is called to increase refcount of this
object. if there is any missing point, give me any comment please. thank
you.

> > +       return to_samsung_gem_obj(gem_obj);
> > +}
> > +
> [snip]
> > diff --git a/include/drm/samsung_drm.h b/include/drm/samsung_drm.h
> > new file mode 100644
> > index 0000000..05dc460
> > --- /dev/null
> > +++ b/include/drm/samsung_drm.h
> [snip]
> > +/**
> > + * User-desired buffer creation information structure.
> > + *
> > + * @usr_addr: an address allocated by user process and this address
> > + *     would be mmapped to physical region by fault handler.
> > + * @size: requested size for the object.
> > + *     - this size value would be page-aligned internally.
> > + * @flags: user request for setting memory type or cache attributes.
> > + * @handle: returned handle for the object.
> > + */
> > +struct drm_samsung_gem_create {
> > +       unsigned int usr_addr;
> 
> usr_addr seems dangerous.. and unused?  Maybe can be removed?
> 
Actually, usr_addr isn't used anywhere, so I removed it already and Dave
pointed out it before.

> also, I sort of prefer using stdint types for userspace<->kernel ioctl
> structs.
> 
Ok, I will use stdint types for it. thank you.

> > +       unsigned int size;
> > +       unsigned int flags;
> > +
> > +       unsigned int handle;
> > +};
> > +
> > +/**
> > + * A structure for getting buffer offset.
> > + *
> > + * @handle: a pointer to gem object created.
> > + * @offset: relatived offset value of the memory region allocated.
> > + *     - this value should be set by user.
> > + */
> > +struct drm_samsung_gem_map_off {
> > +       unsigned int handle;
> > +       uint64_t offset;
> > +};
> > +
> > +/**
> > + * A structure for mapping buffer.
> > + *
> > + * @handle: a pointer to gem object created.
> > + * @offset: relatived offset value of the memory region allocated.
> > + *     - this value should be set by user.
> > + * @size: memory size to be mapped.
> > + * @mapped: user virtual address to be mapped.
> > + */
> > +struct drm_samsung_gem_mmap {
> > +       unsigned int handle;
> > +       uint64_t offset;
> > +       unsigned int size;
> > +
> > +       unsigned int mapped;
> 
> I guess this should be obtained by passing offset back to mmap() syscall
No, as I gave you the words about it before, the offset means physical
memory offset to be mapped to user space. and mapped has user virtual
address from do_mmap.
refer to previous answer please: <
http://www.spinics.net/lists/dri-devel/msg13880.html >
> 
> BR,
> -R

Thank you for your comments and advices again. it's been very useful.  :)


