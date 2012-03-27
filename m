Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab2C0TOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:14:24 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:63922 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754802Ab2C0TOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:14:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 08/13 v4] drm/i915/intel_i2c: handle zero-length writes
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332873382-29373-9-git-send-email-djkurtz@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org> <1332873382-29373-9-git-send-email-djkurtz@chromium.org>
Date: Tue, 27 Mar 2012 20:14:04 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332875657_117263@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 02:36:17 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> A common method of probing an i2c bus is trying to do a zero-length write.
> Handle this case by checking the length first before decrementing it.
> 
> This is actually important, since attempting a zero-length write is one
> of the ways that i2cdetect and i2c_new_probed_device detect whether
> there is device present on the bus with a given address.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/i915/intel_i2c.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index c12db72..5a94e9b 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -248,9 +248,10 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
>  	u32 val, loop;
>  
>  	val = loop = 0;
> -	do {
> +	while (len && loop < 4) {
while (len-- && loop < 4)

>  		val |= *buf++ << (8 * loop);
> -	} while (--len && ++loop < 4);
> +		len -= 1;
Otherwise this looks too pythonesque ;-)

> +	}

-- 
Chris Wilson, Intel Open Source Technology Centre
