Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0KHPlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:41:15 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:28339 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab0KHPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:41:14 -0500
Message-ID: <4CD81A0B.30209@vmware.com>
Date: Mon, 08 Nov 2010 16:40:59 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Jakob Bornecrantz <jakob@vmware.com>,
        Dan Carpenter <error27@gmail.com>, Jerome Glisse <jglisse@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpu: drm: vmwgfx: fix information leak to userland
References: <1289054477-18100-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1289054477-18100-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 03:41 PM, Vasiliy Kulikov wrote:
> Structure drm_vmw_fence_rep is copied to userland with field "pad64"
> uninitialized.  It leads to leaking of contents of kernel stack memory.
>
> Signed-off-by: Vasiliy Kulikov<segooon@gmail.com>
> ---
>   Compile tested.
>
>   drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
> index 51d9f9f..76954e3 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
> @@ -691,6 +691,7 @@ int vmw_execbuf_ioctl(struct drm_device *dev, void *data,
>
>   	fence_rep.error = ret;
>   	fence_rep.fence_seq = (uint64_t) sequence;
> +	fence_rep.pad64 = 0;
>
>   	user_fence_rep = (struct drm_vmw_fence_rep __user *)
>   	    (unsigned long)arg->fence_rep;
>    
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

