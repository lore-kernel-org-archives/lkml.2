Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1AWQvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 11:51:11 -0500
Received: from mx4.gwdg.de ([134.76.10.17]:32827 "EHLO mx4.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab1AWQvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 11:51:10 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2011 11:51:09 EST
X-IronPort-Reputation-Score: None
X-IronPort-AV: E=McAfee;i="5400,1158,6234"; a="19127565"
X-IronPort-AV: E=Sophos;i="4.60,366,1291590000"; 
   d="scan'208";a="19127565"
In-Reply-To: <mailman.17.1295779812.19325.dri-devel@lists.freedesktop.org>
References: <mailman.17.1295779812.19325.dri-devel@lists.freedesktop.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B3CD294C-4F91-4249-A5C5-2453B938F9BB@tuebingen.mpg.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, chris2553@googlemail.com,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: [PATCH] drm/i915: Disable high-precision vblank timestamping
Date: Sun, 23 Jan 2011 17:41:07 +0100
To: dri-devel@lists.freedesktop.org
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ------------------------------
>
> Message: 10
> Date: Sun, 23 Jan 2011 10:50:01 +0000
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Subject: [PATCH] drm/i915: Disable high-precision vblank timestamping
> 	for UMS
> To: Chris Clayton <chris2553@googlemail.com>
> Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
> Message-ID:
> 	<1295779801-8118-1-git-send-email-chris@chris-wilson.co.uk>
>
> We only have sufficient information for accurate (sub-frame)  
> timestamping
> when the modesetting is under our control.
>
> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/i915_drv.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/ 
> i915_drv.c
> index 59eb19b..66796bb 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -752,6 +752,9 @@ static int __init i915_init(void)
>  		driver.driver_features &= ~DRIVER_MODESET;
>  #endif
>
> +	if (!(driver.driver_features & DRIVER_MODESET))
> +		driver.get_vblank_timestamp = NULL;
> +
>  	return drm_init(&driver);
>  }
>
> -- 
> 1.7.2.3
>
>


Oops! Have missed that. Thanks for fixing it.

Reviewed-by: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>


*********************************************************************
Mario Kleiner
Max Planck Institute for Biological Cybernetics
Spemannstr. 38
72076 Tuebingen
Germany

e-mail: mario.kleiner@tuebingen.mpg.de
office: +49 (0)7071/601-1623
fax:    +49 (0)7071/601-616
www:    http://www.kyb.tuebingen.mpg.de/~kleinerm
*********************************************************************
"For a successful technology, reality must take precedence
over public relations, for Nature cannot be fooled."
(Richard Feynman)

