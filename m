Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2HIFcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:32:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42808 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2HIFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120808140638.GK5490@phenom.ffwll.local>
References: <50223CC5.9060007@samsung.com> <1404275.atroogfRqe@avalon>
 <50226F46.3080800@samsung.com> <20120808140638.GK5490@phenom.ffwll.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 9 Aug 2012 11:02:08 +0530
Message-ID: <CAO_48GF+5tV_24R1NeqRDLh1S3+LQUFDN9B4cAg1HJrP5ZGcRA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: add reference counting for exporter module
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Pawel Osciak <pawel@osciak.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Glisse <jglisse@redhat.com>, Vinod Koul <vinod.koul@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>,
        Alex Deucher <alexander.deucher@amd.com>, Rob Clark <rob@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 8 August 2012 19:36, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Aug 08, 2012 at 03:53:10PM +0200, Tomasz Stanislawski wrote:
>> Hi Laurent,
>>
>> On 08/08/2012 03:35 PM, Laurent Pinchart wrote:
>> > Hi Tomasz,
>> >
>> > Thanks for the patch.
Thanks for the patch; may I ask you to split it into 2 patches (1
dma-buf and 1 drm) and submit? That ways, either Dave or I can take
the patches for either pull request.
With that, please feel free to add my Acked-by as well.
>> >
>> > On Wednesday 08 August 2012 12:17:41 Tomasz Stanislawski wrote:
>> >> This patch adds reference counting on a module that exports dma-buf and
>> >> implements its operations. This prevents the module from being unloaded
>> >> while DMABUF file is in use.
>> >>
>> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> >> ---
>> >>  Documentation/dma-buf-sharing.txt          |    3 ++-
>> >>  drivers/base/dma-buf.c                     |   10 +++++++++-
>> >>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
>> >>  drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
>> >>  drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
>> >>  drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
>> >>  drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
>> >>  include/linux/dma-buf.h                    |    2 ++
>> >>  8 files changed, 18 insertions(+), 2 deletions(-)
>> >>
>> [snip]
>>
>> >> @@ -96,6 +98,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct
>> >> dma_buf_ops *ops, struct file *file;
>> >>
>> >>    if (WARN_ON(!priv || !ops
>> >> +                    || !ops->owner
>>
>> Thank you for spotting this.
>> I didn'y know that try_get_module returned true is module was NULL.
>>
>> BTW. Is it worth to add ".owner = THIS_MODULE," to all dma_buf
>> exporters in this patch?
>
> Yeah, I think that makes sense. Otherwise it might get lost somewhere,
> i.e. you can smash my Ack on this.
> -Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48



-- 
Thanks and regards,
Sumit Semwal.
