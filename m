Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0JLPey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:34:54 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:42593 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751935Ab0JLPex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:34:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Rv3SmRC6aaq/fFRQUxJ7qs39Di8Nf8sY23TrvN9y2q8sSmkVkgTtcLHD2UjdGBLlWt39ToxhQQou1FdhwhPEZCfDQ8lgCiuT+fbv5TFXsfvKInVXtNaCo6N/UC8U/q6o;
Date: Tue, 12 Oct 2010 08:38:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drm,kdb,kms: Add an enter argument to
 mode_set_base_atomic() API
Message-ID: <20101012083827.12b8ccce@jbarnes-desktop>
In-Reply-To: <1286887801-8179-4-git-send-email-jason.wessel@windriver.com>
References: <1286887801-8179-1-git-send-email-jason.wessel@windriver.com>
	<1286887801-8179-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 07:49:59 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> Some devices such as the pre nv02 chips have enter and exit
> constraints where hardware compression must be turned off and
> re-enabled on resuming normal operations.
> 
> This patch extends the mode_set_base_atomic() call to pass an argument
> to indicate if this is an entry or an exit from an atomic kernel mode
> set change.  Individual drm drivers can properly save and restore
> state accordingly.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: David Airlie <airlied@linux.ie>
> CC: dri-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/drm_fb_helper.c             |    5 +++--
>  drivers/gpu/drm/i915/intel_display.c        |    4 ++--
>  drivers/gpu/drm/nouveau/nv04_crtc.c         |    2 +-
>  drivers/gpu/drm/nouveau/nv50_crtc.c         |    2 +-
>  drivers/gpu/drm/radeon/atombios_crtc.c      |    2 +-
>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
>  drivers/gpu/drm/radeon/radeon_mode.h        |    4 ++--
>  include/drm/drm_crtc_helper.h               |    3 ++-
>  8 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 6a5e403..625a2d5 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -263,7 +263,8 @@ int drm_fb_helper_debug_enter(struct fb_info *info)
>  			funcs->mode_set_base_atomic(mode_set->crtc,
>  						    mode_set->fb,
>  						    mode_set->x,
> -						    mode_set->y);
> +						    mode_set->y,
> +						    1);

An enum for the last arg would make this call much less mysterious. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
