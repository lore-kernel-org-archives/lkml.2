Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2F0AMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:12:49 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60040 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754221Ab2F0AMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:12:48 -0400
Date: Tue, 26 Jun 2012 17:12:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915/sprite: Fix mem leak in intel_plane_init()
Message-ID: <20120626171246.4c385996@jbarnes-desktop>
In-Reply-To: <alpine.LNX.2.00.1206270053570.3759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206270053570.3759@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 00:55:37 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> If we ever hit the default case in the switch statement we'll return
> from the function without freeing the memory we just allocated to
> 'intel_plane' (but that has not been used).
> 
> This patch gets rid of the leak by freeing the memory just before we
> return.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/gpu/drm/i915/intel_sprite.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
> index 2a20fb0..c8851ba 100644
> --- a/drivers/gpu/drm/i915/intel_sprite.c
> +++ b/drivers/gpu/drm/i915/intel_sprite.c
> @@ -685,6 +685,7 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe)
>  		break;
>  
>  	default:
> +		kfree(intel_plane);
>  		return -ENODEV;
>  	}
>  
> @@ -699,4 +700,3 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe)
>  
>  	return ret;
>  }

Yeah, looks fine.  I just fixed the same thing in a local tree (though
by using a goto since I added another path that could fail).

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
