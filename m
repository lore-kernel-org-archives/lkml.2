Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab2HXMkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:40:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35301 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab2HXMkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:40:00 -0400
Date: Fri, 24 Aug 2012 14:40:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX
 motherboard
Message-ID: <20120824124022.GC5371@phenom.ffwll.local>
Mail-Followup-To: Calvin Walton <calvin.walton@kepstin.ca>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1345809391.3443.9.camel@ayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345809391.3443.9.camel@ayu>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 07:56:31AM -0400, Calvin Walton wrote:
> This board is incorrectly detected as having an LVDS connector,
> resulting in the VGA output (the only available output on the board)
> showing the console only in the top-left 1024x768 pixels, and an extra
> LVDS connector appearing in X.
> 
> It's a desktop Mini-ITX board using an Atom D525 CPU with an NM10
> chipset.
> 
> I've had this board for about a year, but this is the first time I
> noticed the issue because I've been running it headless for most of its
> life.
> 
> Signed-off-by: Calvin Walton <calvin.walton@kepstin.ca>

Looks good, applied to -fixes.
-Daniel
> ---
> 
> This board:
> http://www.gigabyte.us/products/product-page.aspx?pid=3549#sp
> 
> If you want any additional debug output from this machine, let me know
> what you would like and how to find it.
> 
> I think this patch would probably be a reasonable candidate for -stable?
> 
>  drivers/gpu/drm/i915/intel_lvds.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index 08eb04c..2c58310 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -777,6 +777,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
>  			DMI_MATCH(DMI_BOARD_NAME, "MS-7469"),
>  		},
>  	},
> +	{
> +		.callback = intel_no_lvds_dmi_callback,
> +		.ident = "Gigabyte GA-D525TUD",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
> +			DMI_MATCH(DMI_BOARD_NAME, "D525TUD"),
> +		},
> +	},
>  
>  	{ }	/* terminating entry */
>  };
> -- 
> 1.7.12
> 
> -- 
> Calvin Walton <calvin.walton@kepstin.ca>
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
