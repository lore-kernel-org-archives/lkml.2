Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab2CGMRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:17:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:10248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938Ab2CGMRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:17:40 -0500
Message-Id: <f80fcd$3o8hke@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126109326"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 4/9] drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1331121050-17857-5-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-5-git-send-email-djkurtz@chromium.org>
Date: Wed, 07 Mar 2012 12:17:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:45 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> There is no "disabled" port 0.  So, don't even try to initialize/scan
> it, etc.  This saves a bit of time when initializing the driver, since
> the we can avoid a 50ms timeout waiting for a device to respond on
> a port that doesn't even exist.
> 
> Similarly, don't initialize the reserved port, either.

> @@ -150,32 +164,23 @@ static void set_data(void *data, int state_high)
>  static struct i2c_adapter *
>  intel_gpio_create(struct drm_i915_private *dev_priv, u32 pin)
>  {
> -	static const int map_pin_to_reg[] = {
> -		0,
> -		GPIOB,
> -		GPIOA,
> -		GPIOC,
> -		GPIOD,
> -		GPIOE,
> -		GPIOF,
> -		0,
> -	};
>  	struct intel_gpio *gpio;
>  
> -	if (pin >= ARRAY_SIZE(map_pin_to_reg) || !map_pin_to_reg[pin])

And that doesn't do what your changelog proposes? Why?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
