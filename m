Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1LEDER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:04:17 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:59666 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1LEDEP (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 4 Dec 2011 22:04:15 -0500
Subject: Re: [Dual-LVDS Acer Iconia laptop] i915/DRM issue: one screen
 stays off [3.2-rc4+]
From: joeyli <jlee@suse.com>
To: Baptiste Jonglez <baptiste@jonglez.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20111204160728.GA27292@archminux>
References: <20111204160728.GA27292@archminux>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 11:00:41 +0800
Message-ID: <1323054041.6046.79.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Cc. to platform-driver-x86 and linux-acpi

Hi Baptiste

於 日，2011-12-04 於 17:07 +0100，Baptiste Jonglez 提到：
> Hi,
> 
> I've got a lot of troubles with a dual-LVDS Acer laptop (it doesn't
> have a keyboard, but two displays with touchscreens)
> 
> The Intel GPU is integrated into the Core i5-480M CPU: it's a bit
> older than Sandybridge, as it seems to be based on the Arrandale
> micro-architecture.
> 
> In the BIOS, both displays work fine; but as soon as the kernel boots
> up, the second display (i.e. the one where you usually find a
> keyboard) is turned off. The main display works as expected.
> 
> xrandr reports two LVDS displays: LVDS1, which is connected, and
> LVDS2, which is marked as "disconnected". No matter what I tried, I
> can't bring that second display up.
> 
> During the boot, just after the drm is set up, the following message
> shows up:
> 
>   [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
> 
> (attached is the relevant part of dmesg [1])
> 
> 

Have no idea for this _DSM error, need help from drm and acpi experts.

> 
> I then tried booting with "video=LVDS-2:e". The same message shows up
> while booting, with these two following:
> 
>   [drm:drm_crtc_helper_set_config] *ERROR* failed to set mode on [CRTC:4]
>   fbcon_init: detected unhandled fb_set_par error, error code -22
> 
> (attached is the relevant part of dmesg [2])
> 
> With that kernel command line forcing LVDS2, the
> "drm_crtc_helper_set_config" error shows up each time I switch tty;
> additionally, X does not want to start anymore (spewing out the
> aforementioned error multiple times before giving up)
> 
> 
> I'm currently using the latest 3.2 kernel from linus' tree
> (af968e29acd91ebeb4224e899202c46c93171ecd), but the behavior was
> similar with a vanilla 3.1.2.
> 
> 
> Other notes about this issue:
> 
>  - with an Ubuntu 2.6.35 kernel, the second display is on but
>    flickering (with the picture distorted like an old analog TV...).
>    The main display is working fine, as always.
> 
>  - with an Archlinux 2.6.37.5 kernel, the behavior is the same as with
>    3.2, the main display is ok and the second one is off.
> 
>  - I did succeed, only once and out of pure luck, to get the second
>    screen to work with the 3.1.2 kernel. I haven't been able to
>    reproduce that... I had booted with "video=LVDS-2:e" and let the
>    laptop running ; pressing a key a few hours later turned back
>    *both* displays on (the main display had been turned off by DPMS,
>    and the second, well, was off from the start, as always)
>    While not very helpful, it shows that it's definitely possible.
> 

What does Windows platform's behavior? Does there have any physical key
that can turn on/off the second LVDS on Windows?

>  - there are a some unhandled WMI events logged from the acer-wmi
>    module [3] when closing the lid, opening it, and most importantly,
>    when the (main) screen is turned on or off by DPMS.
> 

I will look at your dsdt and log from acer-wmi then try to improve
acer-wmi.

> 
> 
> What do you think? I haven't really succeeded in nailing the source of
> the issue down, but here are a few possibilities I'm thinking of:
> 
>  - the driver is not aware it can drive two LVDS displays (not very
>    likely, and it has worked once, see above)
> 
>  - there is some kind of switch that is able to turn the second screen
>    on or off (I'm thinking of something like rfkill). If so, it looks
>    like something non-standard and undocumented. This would explain
>    the WMI events (see the last note above)
> 

What's the behavior of Windows?

>  - buggy ACPI implementation. I tried to extract then recompile the
>    DSDT [4], and iasl spews out 17 errors and 12 warnings. Also worth
>    noticing is that line in dmesg:
> "pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d"
> 
> 
> The Archlinux userland is:
>  - libdrm 2.4.27
>  - xorg-server 1.11.2
>  - intel-dri 7.11.1
>  - xf86-video-intel 2.17.0
> 
> 
> Please let me know if there are any other details I should provide.
> Regards,
> Baptiste
> 
> Attachments:
> [1] dmesg-DSM-functions.log - drm errors when booting normally
> [2] dmesg-video-lvds2.log - drm errors when forcing LVDS2 on the cmdline
> [3] acer_wmi.log - WMI events that land in dmesg
> [4] dsdt - /sys/firmware/acpi/tables/DSDT

Please also attached on dmidecode log.


Thank's a lot!
Joey Lee

