Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2BDDm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 22:42:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63764 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BDDm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 22:42:58 -0500
Date: Fri, 03 Feb 2012 22:42:55 -0500
Message-Id: <85aa4zs1q8.fsf@gmail.com>
From: Michael D Labriola <michael.d.labriola@gmail.com>
To: Alan Cox <alan@linux.intel.com>
To: David Airlie <airlied@linux.ie>
CC: Michael D Labriola <mlabriol@gdeb.com>
CC: dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org
Subject: gma500: invalid frequency for monitor
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a VersaLogic Ocelot (Atom Z530, Menlow) and I've been test
driving the new GMA500 driver w/out much luck.  I tried the old
staging driver a few times, and just compiled and tested a checkout
from Linus' tree (d12566).  I've got the gma500 driver compiled as a
module, with the optional parts disabled.  Here's what I'm seeing.

My system boots up, loads drm, loads gma500_gfx, and then my monitor's
OSD says "Out of Frequency".  Pretty much the same behavior with the
old psb_gfx module and the new gma500_gfx module.

My system is configured with a LVDS-VGA adapter board, which is
plugged into the VGA port on a 1680x1050 LCD.  The BIOS for the Ocelot
is configured for a 1280x1024 LVDS panel, which seems like a
resolution my monitor should be able to handle.  I've attached
relevant kernel log with drm.debug set to 999.

I think my setup is correct, because the vesa frambuffer seems to work
correctly.  All is well unless I load the gma500_gfx driver and let it
set the mode.

I'd love to help nail this down, let me know if you want me to try
anything.

[  102.969863] [drm] Initialized drm 1.1.0 20060810
[  110.192778] [drm:drm_pci_init], 
[  110.192863] [drm:drm_get_pci_dev], 
[  110.192930] gma500 0000:00:02.0: setting latency timer to 64
[  110.193545] [drm:drm_get_minor], 
[  110.193863] [drm:drm_get_minor], new minor assigned 64
[  110.193887] [drm:drm_get_minor], 
[  110.194753] [drm:drm_get_minor], new minor assigned 0
[  110.197942] ioremap error for 0x7f7f8000-0x7f7fb000, requested 0x10, got 0x0
[  110.206418] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
[  110.207738] Stolen memory information
[  110.207757]        base in RAM: 0x7f800000
[  110.207771]        size: 8060K, calculated by (GTT RAM base) - (Stolen base), seems wrong
[  110.207789]       the correct size should be: 8M(dvmt mode=3)
[  110.216955] Set up 2015 stolen pages starting at 0x7f800000, GTT offset 0K
[  110.217662] [drm] SGX core id = 0x01130000
[  110.217682] [drm] SGX core rev major = 0x01, minor = 0x02
[  110.217701] [drm] SGX core rev maintenance = 0x01, designer = 0x00
[  110.223579] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/LNXVIDEO:00/input/input6
[  110.223800] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[  110.223940] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  110.223958] [drm] No driver support for vblank timestamp query.
[  110.223980] [drm:drm_irq_install], irq=16
[  110.257714] [drm:drm_sysfs_connector_add], adding "LVDS-1" to sysfs
[  110.257932] [drm:drm_sysfs_hotplug_event], generating hotplug event
[  110.269604] [drm:psb_intel_sdvo_read_byte], i2c transfer returned -6
[  110.269633] [drm:psb_intel_sdvo_init], No SDVO device found on SDVOB
[  110.561304] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[  110.586242] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[  110.586274] [drm:drm_mode_debug_printmodeline], Modeline 10:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
[  110.586314] [drm:drm_setup_crtcs], 
[  110.586335] [drm:drm_enable_connectors], connector 7 enabled? yes
[  110.586357] [drm:drm_target_preferred], looking for cmdline mode on connector 7
[  110.586380] [drm:drm_target_preferred], looking for preferred mode on connector 7
[  110.586402] [drm:drm_target_preferred], found mode 1280x1024
[  110.586423] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[  110.586450] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 4
[  110.586513] gma500 0000:00:02.0: allocated 1280x1024 fb
[  110.586819] fbcon: psbfb (fb0) is primary device
[  110.596288] [drm:drm_crtc_helper_set_config], 
[  110.596306] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[  110.637408] [drm:drm_crtc_helper_set_config], 
[  110.637427] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:12] #connectors=1 (x y) (0 0)
[  110.637467] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[  110.637484] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[  110.637500] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  110.637529] [drm:drm_mode_debug_printmodeline], Modeline 11:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
[  110.637564] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[  110.637580] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[  110.637599] [drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:4]
[  110.637618] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[  110.637634] [drm:drm_mode_debug_printmodeline], Modeline 11:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
[  110.637678] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[  110.658501] [drm:drm_mode_debug_printmodeline], Modeline 11:"1280x1024" 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
[  110.699109] [drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:11:1280x1024]
[  110.977395] [drm:drm_calc_timestamping_constants], crtc 4: hwmode: htotal 1688, vtotal 1072, vdisplay 1024
[  110.977415] [drm:drm_calc_timestamping_constants], crtc 4: clock 71500 kHz framedur 25307776 linedur 23608, pixeldur 13
[  110.977439] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[  110.977453] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[  111.032366] Console: switching to colour frame buffer device 160x64
[  111.064932] fb0: psbfb frame buffer device
[  111.064944] drm: registered panic notifier
[  111.066827] gma500 0000:00:02.0: Backlight lvds set brightness 7a120000
[  111.066860] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
