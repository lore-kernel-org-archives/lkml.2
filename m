Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2JUIzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 04:55:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50577 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2JUIzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 04:55:02 -0400
Date: Sun, 21 Oct 2012 10:54:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lars-Peter Clausen <lars@metafoo.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drm: fb: cma: Fail gracefully on allocation failure
Message-ID: <20121021085454.GC27665@pengutronix.de>
References: <1350729172-12506-1-git-send-email-thierry.reding@avionic-design.de>
 <1350729172-12506-2-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350729172-12506-2-git-send-email-thierry.reding@avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:54:33 up 120 days, 6 min, 24 users,  load average: 7.92, 8.41,
 7.41
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 12:32:47PM +0200, Thierry Reding wrote:
> The drm_gem_cma_create() function never returns NULL but rather an error
> encoded in the return value using the ERR_PTR() macro. Callers therefore
> need to check for errors using the IS_ERR() macro. This change allows
> drivers to handle contiguous DMA allocation failures gracefully.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/gpu/drm/drm_fb_cma_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_fb_cma_helper.c b/drivers/gpu/drm/drm_fb_cma_helper.c
> index d6c80a3..fd9d0af 100644
> --- a/drivers/gpu/drm/drm_fb_cma_helper.c
> +++ b/drivers/gpu/drm/drm_fb_cma_helper.c
> @@ -220,7 +220,7 @@ static int drm_fbdev_cma_create(struct drm_fb_helper *helper,
>  
>  	size = mode_cmd.pitches[0] * mode_cmd.height;
>  	obj = drm_gem_cma_create(dev, size);
> -	if (!obj)
> +	if (IS_ERR(obj))
>  		return -ENOMEM;
>  
>  	fbi = framebuffer_alloc(0, dev->dev);
> -- 
> 1.7.12.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
