Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2C0Spm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:45:42 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:60185 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755707Ab2C0Spl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:45:41 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 09/13 v4] drm/i915/intel_i2c: use double-buffered writes
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332873382-29373-10-git-send-email-djkurtz@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org> <1332873382-29373-10-git-send-email-djkurtz@chromium.org>
Date: Tue, 27 Mar 2012 19:45:22 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332873931_116908@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 02:36:18 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> @@ -276,6 +269,13 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
>  
>  		I915_WRITE(GMBUS3 + reg_offset, val);
>  		POSTING_READ(GMBUS2 + reg_offset);

You might as well squash this posting read as the write flush is
redundant given the following read of GMBUS2.

> +
> +		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
> +			     (GMBUS_SATOER | GMBUS_HW_RDY),
> +			     50))
> +			return -ETIMEDOUT;
> +		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
> +			return -ENXIO;

-- 
Chris Wilson, Intel Open Source Technology Centre
