Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1ACSNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:13:10 -0500
Received: from mailout04.t-online.de ([194.25.134.18]:51291 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1ACSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:13:08 -0500
Message-ID: <4D22119B.9050007@t-online.de>
Date: Mon, 03 Jan 2011 19:12:43 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: airlied@linux.ie, eric@anholt.net, jesse.barnes@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com>
In-Reply-To: <b7da2f$q1ffv6@fmsmga001.fm.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: SahxcgZHohmpeEjUYqfykpyjgdP6igpKZ6U+VE4alI9dzW+3h1bSlAPdYkA4ArmgIr
X-TOI-MSGID: 46eb896d-b2b4-46c2-a098-1f5f462c5672
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.01.2011 15:54, schrieb Chris Wilson:

I tried 2.6.37-rc8-git2 with both patches applied.

Well, your patch does not hurt, the system runs fine. But my patch is
still needed as the intel_no_lvds_dmi_callback is called:

<6>[    2.131481] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
<6>[    2.131668] agpgart-intel 0000:00:00.0: detected gtt size: 262144K
total, 262144K mappable
<6>[    2.132594] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
<6>[    2.135338] agpgart-intel 0000:00:00.0: AGP aperture is 256M @
0xc0000000
<6>[    2.135551] [drm] Initialized drm 1.1.0 20060810
<6>[    2.135703] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
<7>[    2.135843] i915 0000:00:02.0: setting latency timer to 64
<7>[    2.139787] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
<7>[    2.139824] [drm:parse_lfp_panel_data], Found panel mode in BIOS
VBT tables:
<7>[    2.139827] [drm:drm_mode_debug_printmodeline], Modeline
0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
<7>[    2.139899] [drm:parse_sdvo_device_mapping], the SDVO device with
slave addr 70 is found on SDVOB port
<7>[    2.139903] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1,
addr=70, wiring=1, ddc_pin=29, i2c_pin=5, i2c_speed=83
<7>[    2.139909] [drm:parse_sdvo_device_mapping], the SDVO device with
slave addr 72 is found on SDVOC port
<7>[    2.139913] [drm:parse_sdvo_device_mapping], SDVO device: dvo=2,
addr=72, wiring=0, ddc_pin=29, i2c_pin=5, i2c_speed=32
<7>[    2.139970] [drm:intel_modeset_init], 2 display pipes available.
<7>[    2.139977] [drm:intel_crtc_init], swapping pipes & planes for FBC
<7>[    2.139984] [drm:intel_crtc_init], swapping pipes & planes for FBC
<7>[    2.139990] [drm:intel_no_lvds_dmi_callback], Skipping LVDS
initialization for AOpen motherboard i915GMm-HFS



> On Mon, 03 Jan 2011 15:25:05 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
>   
>> The AOpen i915GMm-HFS is a desktop motherboard for the Intel Pentium M.
>> A mobile chipset is used
>> (Intel 915GM / ICH6-M). Kernel 2.6.31.14 works fine for that mobo, but
>> from 2.6.32 on graphics support
>> is broken because the i915 driver "detects" an lvds device with a
>> resolution of 1024x768 pixels that in reality
>> is not present. Unfortunately the driver assumes that the "detected"
>> lvds is the primary screen and uses the
>> wrong resolution also for the real VGA and DVI connectors.
>>     
> Can you try:
>
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c
> b/drivers/gpu/drm/i915/intel_i2c.c
> index 58040f6..111128d 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -384,7 +384,7 @@ int intel_setup_gmbus(struct drm_device *dev)
>                 bus->reg0 = i | GMBUS_RATE_100KHZ;
>  
>                 /* XXX force bit banging until GMBUS is fully debugged */
> -               bus->force_bit = intel_gpio_create(dev_priv, i);
> +               //bus->force_bit = intel_gpio_create(dev_priv, i);
>         }
>  
>         intel_i2c_reset(dev_priv->dev);
> -Chris
>
>   

