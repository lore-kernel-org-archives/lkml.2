Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2FKWks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:40:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FKWkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
Date: Tue, 12 Jun 2012 00:40:46 +0200
Message-ID: <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 4:16 PM, Christian Gmeiner
<christian.gmeiner@gmail.com> wrote:
> Hi,
>
> I am working with a custom/embedded device, which has the following device:
>
-- Snip ---
>
> At the moment (kernel 3.2.20) I am using this device with the vesa
> driver, but I tested 3.5-rc2+ on the
> device with the gma500 driver.
>
>
> [    7.885054] gma500 0000:00:02.0: setting latency timer to 64
> [    7.885395] [drm:psb_intel_opregion_setup], Public ACPI methods supported
> [    7.885408] [drm:psb_intel_opregion_setup], ASLE supported
> [    7.885435] gma500 0000:00:02.0: Enabling MSI failed!
> [    7.885542] [drm] internal display is MIPI display
> [    7.885658] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
> [    7.885759] gma500 0000:00:02.0: Unable to read GCT!
--- Snip ---
> [    7.914951] gma500 0000:00:02.0: VBT signature missing
--- Snip ---
> [    8.063001] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    8.063127] [drm] No driver support for vblank timestamp query.
> [    8.063369] gma500 0000:00:02.0: DSI is not supported
Indicates that oaktrail_lvds_init() is skipped

> [    8.113473] No connectors reported connected with modes
> [    8.113575] [drm:drm_setup_crtcs],
> [    8.113591] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
> [    8.113601] [drm] Cannot find any crtc or sizes - going 1024x768
> [    8.125973] fbcon: psbfb (fb0) is primary device
> [    8.127827] [drm:drm_crtc_helper_set_config],
> [    8.127835] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
> [    8.168231] [drm:drm_crtc_helper_set_config],
> [    8.168238] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB]
> [    8.231312] Console: switching to colour frame buffer device 128x48
> [    8.257610] fb0: psbfb frame buffer device
> [    8.257807] drm: registered panic notifier
> [    8.258049] [drm] Initialized gma500 1.0.0 2011-06-06 for
> 0000:00:02.0 on minor 0
--- Snip ---
> An run into this problem - there may be some more:
> Cannot find any crtc or sizes - going 1024x768
>
> Depending on the connected display, there are two ways the panel is connected.
>
> 1) up to WVGA - LVDS
> 2) else SDVO
>
> There is no EDID available.. it is only possible to read out the
> defined display resolution
> via an at24 eeprom found on the i2c bus of the device.
--- Snip ---
> So... what options do I have to fix my problems?

Your device seems to lack the pieces needed for auto-detection of the outputs.

I'd start by forcing oaktrail_lvds_init to run. Look at the first function in
oaktrail_device.c. You'll find that a fuse value is required and that you don't
have it.

We have no SDVO support for Oaktrail and I've never seen any hardware
that does LVDS over SDVO (though there is support for that on Poulsbo).

-Patrik
