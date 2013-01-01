Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3AABWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 20:22:19 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62295 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3AABWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 20:22:17 -0500
Date: Tue, 1 Jan 2013 02:21:45 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, Ben Skeggs <skeggsb@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stefan@konink.de
Subject: Re: [RESEND PATCH] drm/nouveau: fix init with agpgart-uninorth
Message-ID: <20130101011158.GA7601@joi.lan>
References: <1356917699-19479-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1356917699-19479-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 03:34:59AM +0200, Aaro Koskinen wrote:
> Check that the AGP aperture can be mapped. This follows a similar change
> done for Radeon (commit 365048ff, drm/radeon: AGP memory is only I/O if
> the aperture can be mapped by the CPU.).
> 
> The patch fixes the following error seen on G5 iMac:
> 
> 	nouveau E[     DRM] failed to create kernel channel, -12
> 
> Reviewed-by: Michel Dänzer <michel@daenzer.net>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---

This patch fixes https://bugs.freedesktop.org/show_bug.cgi?id=58806.
For some (weird) reason Nouveau worked on this configuration on 3.6 kernel,
so cc'ing stable@vger seems to be appropriate.

>  drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 5614c89..69d7b1d 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -1276,7 +1276,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
>  		if (drm->agp.stat == ENABLED) {
>  			mem->bus.offset = mem->start << PAGE_SHIFT;
>  			mem->bus.base = drm->agp.base;
> -			mem->bus.is_iomem = true;
> +			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
>  		}
>  #endif
>  		break;
> -- 
