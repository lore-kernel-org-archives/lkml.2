Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2DRNiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:38:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36375 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2DRNiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <s5hwr5d89bw.wl%tiwai@suse.de>
References: <s5h4nshdxid.wl%tiwai@suse.de>
	<s5hy5pt89dy.wl%tiwai@suse.de>
	<s5hwr5d89bw.wl%tiwai@suse.de>
Date: Wed, 18 Apr 2012 09:38:17 -0400
Message-ID: <CADnq5_M88VeEWfbc1nSjSVQBKPd9L=iBoxTMFT1+mtf-a3Wseg@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/kms: fix the regression of DVI connector check
From: Alex Deucher <alexdeucher@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 9:21 AM, Takashi Iwai <tiwai@suse.de> wrote:
> The check of the encoder type in the commit [e00e8b5e: drm/radeon/kms:
> fix analog load detection on DVI-I connectors] is obviously wrong, and
> it's the culprit of the regression on my workstation with DVI-analog
> connection resulting in the blank output.
>
> Fixed the typo now.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
> index bd05156..aa8268d 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -970,7 +970,7 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
>
>                        encoder = obj_to_encoder(obj);
>
> -                       if (encoder->encoder_type != DRM_MODE_ENCODER_DAC ||
> +                       if (encoder->encoder_type != DRM_MODE_ENCODER_DAC &&
>                            encoder->encoder_type != DRM_MODE_ENCODER_TVDAC)
>                                continue;
>
> --
> 1.7.9.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
