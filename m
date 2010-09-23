Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0IWS4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:56:37 -0400
Received: from atl.turmel.org ([74.117.157.138]:44346 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab0IWS4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:56:36 -0400
Message-ID: <4C9BA2DB.8060503@turmel.org>
Date: Thu, 23 Sep 2010 14:56:27 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: dri-devel@lists.freedesktop.org, airlied@redhat.com,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH] drm/nouveau: fix panels using straps-based mode detection
References: <20100922225612.826b0553.akpm@linux-foundation.org> <1285224241-32683-1-git-send-email-skeggsb@gmail.com>
In-Reply-To: <1285224241-32683-1-git-send-email-skeggsb@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 02:44 AM, Ben Skeggs wrote:
> From: Ben Skeggs <bskeggs@redhat.com>
> 
> nouveau_bios_fp_mode() zeroes the mode struct before filling in relevant
> entries.  This nukes the mode id initialised by drm_mode_create(), and
> causes warnings from idr when we try to remove the mode.
> 
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_connector.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
> index 98c214c..4b286a8 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_connector.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
> @@ -594,8 +594,10 @@ nouveau_connector_get_modes(struct drm_connector *connector)
>  	if (nv_encoder->dcb->type == OUTPUT_LVDS &&
>  	    (nv_encoder->dcb->lvdsconf.use_straps_for_mode ||
>  	     dev_priv->vbios.fp_no_ddc) && nouveau_bios_fp_mode(dev, NULL)) {
> -		nv_connector->native_mode = drm_mode_create(dev);
> -		nouveau_bios_fp_mode(dev, nv_connector->native_mode);
> +		struct drm_display_mode mode;
> +
> +		nouveau_bios_fp_mode(dev, &mode);
> +		nv_connector->native_mode = drm_mode_duplicate(dev, &mode);
>  	}
>  
>  	/* Find the native mode if this is a digital panel, if we didn't

I had this same problem, and this patch fixes it.  Feel free to add:

Tested-by: Philip J. Turmel <philip@turmel.org>

Regards,

Phil
