Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1KPKtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:49:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab1KPKtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:49:51 -0500
Message-ID: <4EC3954B.8030505@fedoraproject.org>
Date: Wed, 16 Nov 2011 11:49:47 +0100
From: Michel Alexandre Salim <salimma@fedoraproject.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: intel-gfx@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] drm/i915: Honor SSC quirk table over the default,
 unless set by user
References: <1320855178.5081.9.camel@fauix11.informatik.uni-erlangen.de> <4EBAAAA5.7030807@fedoraproject.org> <yunvcqtxj8c.fsf@aiko.keithp.com>
In-Reply-To: <yunvcqtxj8c.fsf@aiko.keithp.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

That patch is still not in 3.2-rc2, drm-intel-fixes or drm-intel-next.
I've been using it successfully on i915 (both SSC-blacklisted and not)
and non-i915 machines; feel free to set the Tested-by and Reviewed-by tags.

Thanks,

-- 
Michel

On 11/09/2011 07:07 PM, Keith Packard wrote:
> On Wed, 09 Nov 2011 17:30:29 +0100, Michel Alexandre Salim <salimma@fedoraproject.org> wrote:
>> Additional note: while I've not touched the line since it does not
>> affect me, it seems that i915_panel_use_ssc *cannot* be less than 0
>> since that variable is declared as unsigned.
> 
> Oops. That's the bug here -- we're supposed to make it so that the
> command line can override the quirks, but there's no way to use a quirk
> given the mis-declared parameter.
> 
> This is untested...
> 
> From e64ecadef40e3c2035cd4e9b967ffd83489bdea0 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Wed, 9 Nov 2011 09:57:50 -0800
> Subject: [PATCH] drm/i915: Module parameters using '-1' as default must be
>  signed type
> 
> Testing i915_panel_use_ssc for the default value was broken, so the
> driver would never autodetect the correct value.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_drv.c |    4 ++--
>  drivers/gpu/drm/i915/i915_drv.h |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index 548e04b..13488be 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -67,7 +67,7 @@ module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0600);
>  MODULE_PARM_DESC(i915_enable_rc6,
>  		"Enable power-saving render C-state 6 (default: true)");
>  
> -unsigned int i915_enable_fbc __read_mostly = -1;
> +int i915_enable_fbc __read_mostly = -1;
>  module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
>  MODULE_PARM_DESC(i915_enable_fbc,
>  		"Enable frame buffer compression for power savings "
> @@ -79,7 +79,7 @@ MODULE_PARM_DESC(lvds_downclock,
>  		"Use panel (LVDS/eDP) downclocking for power savings "
>  		"(default: false)");
>  
> -unsigned int i915_panel_use_ssc __read_mostly = -1;
> +int i915_panel_use_ssc __read_mostly = -1;
>  module_param_named(lvds_use_ssc, i915_panel_use_ssc, int, 0600);
>  MODULE_PARM_DESC(lvds_use_ssc,
>  		"Use Spread Spectrum Clock with panels [LVDS/eDP] "
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index d2da91f..4a9c1b9 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1000,10 +1000,10 @@ extern int i915_panel_ignore_lid __read_mostly;
>  extern unsigned int i915_powersave __read_mostly;
>  extern unsigned int i915_semaphores __read_mostly;
>  extern unsigned int i915_lvds_downclock __read_mostly;
> -extern unsigned int i915_panel_use_ssc __read_mostly;
> +extern int i915_panel_use_ssc __read_mostly;
>  extern int i915_vbt_sdvo_panel_type __read_mostly;
>  extern unsigned int i915_enable_rc6 __read_mostly;
> -extern unsigned int i915_enable_fbc __read_mostly;
> +extern int i915_enable_fbc __read_mostly;
>  extern bool i915_enable_hangcheck __read_mostly;
>  
>  extern int i915_suspend(struct drm_device *dev, pm_message_t state);
> 
> 
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx


-- 
Michel Alexandre Salim
µblog:      http://identi.ca/hircus
            http://twitter.com/hircus
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments
