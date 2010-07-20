Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321Ab0GTPGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:06:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:33016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab0GTPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:06:21 -0400
Date: Tue, 20 Jul 2010 17:06:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Adam Jackson <ajax@redhat.com>, Zhao Yakui <yakui.zhao@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/16] trivial: use ARRAY_SIZE
In-Reply-To: <1277726093-24500-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.LNX.2.00.1007201706060.4741@pobox.suse.cz>
References: <1277726093-24500-1-git-send-email-segooon@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/gpu/drm/drm_edid.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index c198186..da06476 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -929,13 +929,11 @@ drm_mode_do_interlace_quirk(struct drm_display_mode *mode,
>  		{ 1440,  576 },
>  		{ 2880,  576 },
>  	};
> -	static const int n_sizes =
> -		sizeof(cea_interlaced)/sizeof(cea_interlaced[0]);
>  
>  	if (!(pt->misc & DRM_EDID_PT_INTERLACED))
>  		return;
>  
> -	for (i = 0; i < n_sizes; i++) {
> +	for (i = 0; i < ARRAY_SIZE(cea_interlaced); i++) {
>  		if ((mode->hdisplay == cea_interlaced[i].w) &&
>  		    (mode->vdisplay == cea_interlaced[i].h / 2)) {
>  			mode->vdisplay *= 2;
> @@ -1375,7 +1373,6 @@ static const struct {
>  	{ 1920, 1440, 60, 0 },
>  	{ 1920, 1440, 75, 0 },
>  };
> -static const int num_est3_modes = sizeof(est3_modes) / sizeof(est3_modes[0]);
>  
>  static int
>  drm_est3_modes(struct drm_connector *connector, struct detailed_timing *timing)
> @@ -1387,7 +1384,7 @@ drm_est3_modes(struct drm_connector *connector, struct detailed_timing *timing)
>  	for (i = 0; i < 6; i++) {
>  		for (j = 7; j > 0; j--) {
>  			m = (i * 8) + (7 - j);
> -			if (m >= num_est3_modes)
> +			if (m >= ARRAY_SIZE(est3_modes))
>  				break;
>  			if (est[i] & (1 << j)) {
>  				mode = drm_mode_find_dmt(connector->dev,

Not found in linux-next as of today. Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
