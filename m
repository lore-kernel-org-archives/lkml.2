Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1ALNDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:03:43 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:36690 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab1ALNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:03:41 -0500
Message-ID: <4D2DA6A7.4010609@de.ibm.com>
Date: Wed, 12 Jan 2011 14:03:35 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm for rc1
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <alpine.LFD.2.00.1101121235360.8212@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.1101121235360.8212@casper.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2011 13:49, schrieb James Simmons:
> I see the problem. Nouveau for some hardware does a accelerated 
> clearing of the screen before we register the framebuffer. The above patch 
> does fix a real issue so please don't revert it. Can you try this patch.
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
> index a26d047..4ef24d6 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
> @@ -359,6 +359,8 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
>  	info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
>  	info->screen_size = size;
> 
> +	info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
> +                FB_VISUAL_TRUECOLOR;
>  	drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
> 
>  	/* Set aperture base/size for vesafb takeover */

Hmm, does not seem to work. Any more initialization missing?
