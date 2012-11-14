Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2KNIyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:54:11 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:47710 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab2KNIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:54:09 -0500
Message-ID: <50A35C2E.6010602@vmware.com>
Date: Wed, 14 Nov 2012 09:54:06 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/ttm: remove unneeded preempt_disable/enable
References: <1352463043-9408-1-git-send-email-akinobu.mita@gmail.com> <1352463043-9408-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1352463043-9408-3-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 01:10 PM, Akinobu Mita wrote:
> It is unnecessary to disable preemption explicitly while calling
> copy_highpage().  Because copy_highpage() will do it again through
> kmap_atomic/kunmap_atomic.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: David Airlie <airlied@linux.ie>
> ---
>   drivers/gpu/drm/ttm/ttm_tt.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> index bf82601..7d759a4 100644
> --- a/drivers/gpu/drm/ttm/ttm_tt.c
> +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> @@ -308,9 +308,7 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
>   		if (unlikely(to_page == NULL))
>   			goto out_err;
>   
> -		preempt_disable();
>   		copy_highpage(to_page, from_page);
> -		preempt_enable();
>   		page_cache_release(from_page);
>   	}
>   
> @@ -358,9 +356,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
>   			ret = PTR_ERR(to_page);
>   			goto out_err;
>   		}
> -		preempt_disable();
>   		copy_highpage(to_page, from_page);
> -		preempt_enable();
>   		set_page_dirty(to_page);
>   		mark_page_accessed(to_page);
>   		page_cache_release(to_page);

Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

