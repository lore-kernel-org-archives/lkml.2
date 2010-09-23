Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0IWLgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:36:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab0IWLgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:36:06 -0400
Date: Thu, 23 Sep 2010 13:36:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] drivers/gpu/drm: Remove unnecessary casts of
 private_data
In-Reply-To: <41dc995dbe142151c89cff07db0f34277af9446e.1283650107.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1009231335470.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com> <41dc995dbe142151c89cff07db0f34277af9446e.1283650107.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/gpu/drm/radeon/radeon_ttm.c      |    2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c     |    2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 84c53e4..a823d8f 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -631,7 +631,7 @@ int radeon_mmap(struct file *filp, struct vm_area_struct *vma)
>  		return drm_mmap(filp, vma);
>  	}
>  
> -	file_priv = (struct drm_file *)filp->private_data;
> +	file_priv = filp->private_data;
>  	rdev = file_priv->minor->dev->dev_private;
>  	if (rdev == NULL) {
>  		return -EINVAL;
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
> index e6a1eb7..dc043c3 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
> @@ -542,7 +542,7 @@ int vmw_fifo_mmap(struct file *filp, struct vm_area_struct *vma)
>  	struct drm_file *file_priv;
>  	struct vmw_private *dev_priv;
>  
> -	file_priv = (struct drm_file *)filp->private_data;
> +	file_priv = filp->private_data;
>  	dev_priv = vmw_priv(file_priv->minor->dev);
>  
>  	if (vma->vm_pgoff != (dev_priv->mmio_start >> PAGE_SHIFT) ||
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
> index 8312328..1e8eedd 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
> @@ -39,7 +39,7 @@ int vmw_mmap(struct file *filp, struct vm_area_struct *vma)
>  		return drm_mmap(filp, vma);
>  	}
>  
> -	file_priv = (struct drm_file *)filp->private_data;
> +	file_priv = filp->private_data;
>  	dev_priv = vmw_priv(file_priv->minor->dev);
>  	return ttm_bo_mmap(filp, vma, &dev_priv->bdev);
>  }

This patch isn't present in linux-next as of today. Taking through trivial 
queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
