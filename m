Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab2HHNxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:53:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15843 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2HHNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:53:15 -0400
Message-id: <50226F46.3080800@samsung.com>
Date: Wed, 08 Aug 2012 15:53:10 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Pawel Osciak <pawel@osciak.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Glisse <jglisse@redhat.com>, Vinod Koul <vinod.koul@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>, Rob Clark <rob@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: add reference counting for exporter module
References: <50223CC5.9060007@samsung.com> <1404275.atroogfRqe@avalon>
In-reply-to: <1404275.atroogfRqe@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 08/08/2012 03:35 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Wednesday 08 August 2012 12:17:41 Tomasz Stanislawski wrote:
>> This patch adds reference counting on a module that exports dma-buf and
>> implements its operations. This prevents the module from being unloaded
>> while DMABUF file is in use.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  Documentation/dma-buf-sharing.txt          |    3 ++-
>>  drivers/base/dma-buf.c                     |   10 +++++++++-
>>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
>>  drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
>>  drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
>>  drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
>>  drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
>>  include/linux/dma-buf.h                    |    2 ++
>>  8 files changed, 18 insertions(+), 2 deletions(-)
>>
[snip]

>> @@ -96,6 +98,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct
>> dma_buf_ops *ops, struct file *file;
>>
>>  	if (WARN_ON(!priv || !ops
>> +			  || !ops->owner

Thank you for spotting this.
I didn'y know that try_get_module returned true is module was NULL.

BTW. Is it worth to add ".owner = THIS_MODULE," to all dma_buf
exporters in this patch?

Regards,
Tomasz Stanislawski

> 
> THIS_MODULE is defined as ((struct module *)0) when the driver is built-in, 
> this check should thus be removed.
> 
>>  			  || !ops->map_dma_buf
>>  			  || !ops->unmap_dma_buf
>>  			  || !ops->release
>>

