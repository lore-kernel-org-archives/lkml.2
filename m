Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1ASOXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:23:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1ASOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:23:16 -0500
Date: Wed, 19 Jan 2011 15:23:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH 03/17][trivial] GPU DRM: Remove unnecessary casts of void
 ptr returning alloc function return values
In-Reply-To: <alpine.LNX.2.00.1011082314420.23697@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1101191522570.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1011082314420.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Jesper Juhl wrote:

> Hi,
> 
> The [vk][cmz]alloc(_node) family of functions return void pointers which
> it's completely unnecessary/pointless to cast to other pointer types since
> that happens implicitly.
> 
> This patch removes such casts from drivers/gpu/drm/
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drm_sman.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_sman.c b/drivers/gpu/drm/drm_sman.c
> index 463aed9..3466458 100644
> --- a/drivers/gpu/drm/drm_sman.c
> +++ b/drivers/gpu/drm/drm_sman.c
> @@ -59,9 +59,7 @@ drm_sman_init(struct drm_sman * sman, unsigned int num_managers,
>  {
>  	int ret = 0;
>  
> -	sman->mm = (struct drm_sman_mm *) kcalloc(num_managers,
> -						  sizeof(*sman->mm),
> -						  GFP_KERNEL);
> +	sman->mm = kcalloc(num_managers, sizeof(*sman->mm), GFP_KERNEL);
>  	if (!sman->mm) {
>  		ret = -ENOMEM;
>  		goto out;
> 

Doesn't seem to be present in linux-next as of today, applied to trivial 
queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
