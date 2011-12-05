Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1LEKGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:06:48 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53988 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755321Ab1LEKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:06:47 -0500
Date: Mon, 5 Dec 2011 02:06:46 -0800 (PST)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <855788278.405280.1323079606487.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1322600880.1534.299.camel@localhost.localdomain>
Subject: Re: [PATCH] vmwgfx: Use kcalloc instead of kzalloc to allocate
 array
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC15 (Mac)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

----- Original Message -----
> The advantage of kcalloc is, that will prevent integer overflows
> which could result from the multiplication of number of elements
> and size and it is also a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
> b/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c 2011-11-13
> 11:07:24.343455126 +0100
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c 2011-11-28
> 19:50:07.413502824 +0100
> @@ -140,7 +140,7 @@ int vmw_present_ioctl(struct drm_device
>  		goto out_clips;
>  	}
>  
> -	clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
> +	clips = kcalloc(num_clips, sizeof(*clips), GFP_KERNEL);
>  	if (clips == NULL) {
>  		DRM_ERROR("Failed to allocate clip rect list.\n");
>  		ret = -ENOMEM;
> @@ -232,7 +232,7 @@ int vmw_present_readback_ioctl(struct dr
>  		goto out_clips;
>  	}
>  
> -	clips = kzalloc(num_clips * sizeof(*clips), GFP_KERNEL);
> +	clips = kcalloc(num_clips, sizeof(*clips), GFP_KERNEL);
>  	if (clips == NULL) {
>  		DRM_ERROR("Failed to allocate clip rect list.\n");
>  		ret = -ENOMEM;
