Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab2C1NFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:05:34 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:6286 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757220Ab2C1NFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:05:33 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 14/14 v5] drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332939117-6513-15-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org> <1332939117-6513-15-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 14:05:13 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332939924_127442@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 20:51:57 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> The POSTING_READ() calls were originally added to make sure the writes
> were flushed before any timing delays and across loops.
> However, the normal I915_READ() and I915_WRITE() macros already call
> readl() / writel(), which already have an explicit mb().
> 
> Now that the code has settled a bit, let's remove them.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/i915/intel_i2c.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index 2865313..be2852e 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -131,7 +131,6 @@ static void set_clock(void *data, int state_high)
>  			GPIO_CLOCK_VAL_MASK;
>  
>  	I915_WRITE_NOTRACE(bus->gpio_reg, reserved | clock_bits);
> -	POSTING_READ(bus->gpio_reg);
We do need the write flush here (and set_data) as the next action is a
udelay loop which is not per-se a mb.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
