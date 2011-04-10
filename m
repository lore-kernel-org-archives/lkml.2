Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1DJPCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:02:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:55055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab1DJPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:02:42 -0400
Date: Sun, 10 Apr 2011 08:02:38 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] drm: minor kref_put() nits
In-Reply-To: <1298766877.1828.22.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1104081912350.6392@deuxcents.site>
References: <1298766877.1828.22.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Feb 2011, Paul Bolle wrote:

> There's no need to pass kref_put() the address of a function (just the
> function will do just fine) nor to cast its unused return to void.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/gpu/drm/radeon/radeon_fence.c |    2 +-
>  drivers/gpu/drm/ttm/ttm_object.c      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
> index 171b0b2..a1d3ae6 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -324,7 +324,7 @@ void radeon_fence_unref(struct radeon_fence **fence)
>  
>  	*fence = NULL;
>  	if (tmp) {
> -		kref_put(&tmp->kref, &radeon_fence_destroy);
> +		kref_put(&tmp->kref, radeon_fence_destroy);
>  	}
>  }
>  
> diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
> index 75e9d6f..ebddd44 100644
> --- a/drivers/gpu/drm/ttm/ttm_object.c
> +++ b/drivers/gpu/drm/ttm/ttm_object.c
> @@ -206,7 +206,7 @@ void ttm_base_object_unref(struct ttm_base_object **p_base)
>  	 */
>  
>  	write_lock(&tdev->object_lock);
> -	(void)kref_put(&base->refcount, &ttm_release_base);
> +	kref_put(&base->refcount, ttm_release_base);
>  	write_unlock(&tdev->object_lock);
>  }
>  EXPORT_SYMBOL(ttm_base_object_unref);

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

