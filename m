Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1ASDZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:25:03 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50942 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1ASDZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:25:01 -0500
Date: Wed, 19 Jan 2011 14:24:49 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Correctly test for an initialised ring for
	dri1
Message-ID: <20110119032449.GA20598@gondor.apana.org.au>
References: <20110118115701.GA11952@gondor.apana.org.au> <1295371449-22979-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295371449-22979-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 05:24:09PM +0000, Chris Wilson wrote:
>
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 46d649b..19a58bd 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -1302,12 +1302,12 @@ int i915_irq_emit(struct drm_device *dev, void *data,
>  	drm_i915_irq_emit_t *emit = data;
>  	int result;
>  
> -	if (!dev_priv || !LP_RING(dev_priv)->virtual_start) {
> +	if (!dev_priv || !LP_RING(dev_priv)->obj) {
>  		DRM_ERROR("called with no initialization\n");
>  		return -EINVAL;
>  	}
>  
> -	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
> +	LOCK_TEST_WITH_RETURN(dev, file_priv);

While this would surely fix the crash here, this appears to take
away existing functionality with KMS off.

We usually don't require people to upgrade user-space along
with the kernel in order to preserve existing functionality.
Do different rules apply in the DRM area?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
