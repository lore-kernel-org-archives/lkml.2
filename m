Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1KSUDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 15:03:24 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:14607 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab1KSUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 15:03:23 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Nov 2011 15:03:23 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4PAMUKyE64rwEk/2dsb2JhbABDmjMZjlyBFYEGgXIBAQUnER4GHAEQCwsDCgkWDwkDAgECAREWDBIGDQEFAgKIB6ROhl89iHQEihcEiBqCDIoWilKDBoRL
X-IronPort-AV: E=Sophos;i="4.69,539,1315195200"; 
   d="scan'208";a="148620738"
Message-ID: <4EC80B48.4060808@gmail.com>
Date: Sat, 19 Nov 2011 15:02:16 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Alex Davis <alex14641@yahoo.com>,
        Kamal Mostafa <kamal@canonical.com>, mjg@redhat.com
Subject: Re: [PATCH] drm/i915: Fix inconsistent backlight level during disabled
References: <s5hboscpexg.wl%tiwai@suse.de>
In-Reply-To: <s5hboscpexg.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> When the brightness property is inquired while the backlight is disabled,
> the driver returns a wrong value (zero) because it probes the value after
> the backlight was turned off.  This caused a black screen even after the
> backlight is enabled again.  It should return the internal backlight_level
> instead, so that it won't be influenced by the backlight-enable state.
>
> BugLink: https://bugs.freedesktop.org/show_bug.cgi?id=41926
> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/872652
>
> Tested-by: Kamal Mostafa<kamal@canonical.com>
> Cc: Alex Davis<alex14641@yahoo.com>
> Cc:<stable@kernel.org>
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
> ---
>   drivers/gpu/drm/i915/intel_panel.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 499d4c0..21f60b7 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -326,7 +326,8 @@ static int intel_panel_update_status(struct backlight_device *bd)
>   static int intel_panel_get_brightness(struct backlight_device *bd)
>   {
>   	struct drm_device *dev = bl_get_data(bd);
> -	return intel_panel_get_backlight(dev);
> +	struct drm_i915_private *dev_priv = dev->dev_private;
> +	return dev_priv->backlight_level;
>   }
>
>   static const struct backlight_ops intel_panel_bl_ops = {
Seems to be fixing a black-screen regression since 3.0 on EeePC devices 
as well...

Thanks, Woody

