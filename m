Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab2J2Pfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:35:40 -0400
Received: from xvm-169-183.ghst.net ([95.142.169.183]:52948 "EHLO
	photon.sigxcpu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2J2Pfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:35:36 -0400
Date: Mon, 29 Oct 2012 16:35:28 +0100
From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with gma500_gfx on 3.6.2
Message-ID: <20121029153528.GA22581@bogon.sigxcpu.org>
References: <20121021115625.GA2535@bogon.sigxcpu.org>
 <20121022153936.455ac8f8@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <20121022153936.455ac8f8@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 03:39:36PM +0100, Alan Cox wrote:
> > [  689.950596] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
> > [  689.950627] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
> 
> It's got the LVDS configured it seems and the brightness was already set
> up. That should be harmless.
> 
> > Besides the VGA the driver detects a LVDS as well although there's none
> > attached (the board does have a connector for it though):
> 
> Ok so it finds both ports which is what I would expect
> 
> > # grep -l ^connected /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-*/status
> > /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/status
> > /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-VGA-1/status
> 
> This means it found there was a VGA port and from
> psb_intel_sdvo_output_setup called psb_intel_sdvo_analog_init.
> 
> > 
> > It also states that both ports are disabled:
> 
> Which would explain the black screen.
> 
> > 
> > # cat   /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-*/enabled
> > disabled
> > disabled
> > 
> > I didn't find a way to enable any of these ports via sysfs and X.org's
> > modesetting driver fails either. Any pointers on howto debug this
> > further are greatly appreciated.
> 
> My first guess would be that the detection of the VGA failed. That would
> explain all your symptoms and since it relies on the firmware...
> 
> First thing to do is turn drm debug on in full and you should then get a
> dump of the SDVO capabilities, particulary output_flags as well as an
> entry giving the clock range etc if it initialized it ok.

The list of probed modes looks sane:

[    5.059963] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:VGA-1] probed modes :
[    5.059978] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    5.060054] [drm:drm_mode_debug_printmodeline], Modeline 53:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    5.060093] [drm:drm_mode_debug_printmodeline], Modeline 54:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    5.060129] [drm:drm_mode_debug_printmodeline], Modeline 84:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[    5.060163] [drm:drm_mode_debug_printmodeline], Modeline 75:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[    5.060200] [drm:drm_mode_debug_printmodeline], Modeline 74:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
...
[    5.060935] [drm:drm_setup_crtcs], 
[    5.060951] [drm:drm_enable_connectors], connector 7 enabled? yes
[    5.060966] [drm:drm_enable_connectors], connector 11 enabled? no
[    5.060979] [drm:drm_enable_connectors], connector 28 enabled? no
[    5.060993] [drm:drm_enable_connectors], connector 45 enabled? yes
[    5.061006] [drm:drm_target_preferred], looking for cmdline mode on connector 7
[    5.061019] [drm:drm_target_preferred], looking for preferred mode on connector 7
[    5.061033] [drm:drm_target_preferred], found mode 1024x768
[    5.061045] [drm:drm_target_preferred], looking for cmdline mode on connector 45
[    5.061058] [drm:drm_target_preferred], looking for preferred mode on connector 45
[    5.061071] [drm:drm_target_preferred], found mode 1920x1080
[    5.061083] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[    5.061106] [drm:drm_setup_crtcs], desired mode 1024x768 set on crtc 4
[    5.061126] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[    5.061451] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
[    5.160076] [drm:psb_lid_timer_func], LVDS panel never powered up

and there's also enabled connectors according to the debug output. I
tried to get a clue from the source where these get disabled but without
any luck yet. I've attached the full debug output. 
Cheers,
 -- Guido


> 
> Alan
> 

--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="drm.debug"

[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.2 root=/dev/sda1 ro quiet nosplash drm.debug=0x07
[    3.545355] [drm] Initialized drm 1.1.0 20060810
[    3.599432] [drm:drm_pci_init], 
[    3.644606] [drm:drm_get_pci_dev], 
[    3.644777] [drm:drm_get_minor], 
[    3.645371] [drm:drm_get_minor], new minor assigned 64
[    3.645395] [drm:drm_get_minor], 
[    3.645882] [drm:drm_get_minor], new minor assigned 0
[    3.646346] [drm:psb_intel_opregion_setup], OpRegion detected at 0x3f6cc000
[    3.646423] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[    3.646443] [drm:psb_intel_opregion_setup], ASLE supported
[    3.650951] [drm:psb_intel_init_bios], Using VBT from OpRegion: $VBT POULSBO        d
[    3.650995] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    3.651041] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    3.651063] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5
[    3.717999] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.718020] [drm] No driver support for vblank timestamp query.
[    3.718042] [drm:drm_irq_install], irq=16
[    3.769293] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSDDC_C
[    3.769343] [drm:drm_sysfs_connector_add], adding "LVDS-1" to sysfs
[    3.769641] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.954999] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    3.958643] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 42 02 01 01 3D 3E 00
[    3.982094] [drm:psb_intel_sdvo_get_capabilities], SDVO capabilities:
[    3.983699] [drm:drm_sysfs_connector_add], adding "SVIDEO-1" to sysfs
[    3.984073] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    3.984179] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.990740] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success)
[    3.994448] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    3.998070] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF FF FF FF FF 1F
[    4.019000] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    4.022666] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FA DF
[    4.032074] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    4.037136] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 2F 00 20 00
[    4.049857] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    4.053566] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 20 00
[    4.063246] [drm:psb_intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    4.063279] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    4.066937] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 2F 00 20 00
[    4.094691] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    4.098316] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 20 00
[    4.106075] [drm:psb_intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    4.106106] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    4.109734] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF 03 00 02
[    4.137978] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 68                         (SDVO_CMD_GET_HPOS)
[    4.141596] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 00 02
[    4.149842] [drm:psb_intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    4.149872] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    4.153494] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF 03 00 02
[    4.164879] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6B                         (SDVO_CMD_GET_VPOS)
[    4.168536] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 00 02
[    4.174899] [drm:psb_intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    4.174928] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    4.178524] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 7F 00 45 00
[    4.188825] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 56                         (SDVO_CMD_GET_SATURATION)
[    4.192364] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 45 00
[    4.198492] [drm:psb_intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    4.198510] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    4.202045] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 7F 00 40 00
[    4.212295] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    4.215794] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 40 00
[    4.221981] [drm:psb_intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    4.221998] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    4.225543] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 7F 00 40 00
[    4.235728] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 59                         (SDVO_CMD_GET_HUE)
[    4.239252] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 40 00
[    4.245419] [drm:psb_intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    4.245436] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    4.248965] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 07 00 04 00
[    4.259140] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    4.262669] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 04 00
[    4.268831] [drm:psb_intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    4.268847] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    4.272384] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF 00 80 00
[    4.282566] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    4.286099] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 80 00
[    4.292311] [drm:psb_intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    4.292337] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    4.295850] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 07 00 07 00
[    4.306188] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    4.309782] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 07 00
[    4.316073] [drm:psb_intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    4.316099] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    4.319714] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 03 00 01 00
[    4.331092] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    4.334770] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    4.341862] [drm:psb_intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    4.341891] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    4.345537] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00 02 00
[    4.355809] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    4.359364] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[    4.365538] [drm:psb_intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 2, current 2
[    4.365555] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    4.369112] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    4.375222] [drm:psb_intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    4.375263] [drm:drm_sysfs_connector_add], adding "SVIDEO-2" to sysfs
[    4.375503] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    4.375605] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 11 04 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    4.382056] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success)
[    4.384145] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    4.387644] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF FF FF FF FF 1F
[    4.402281] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    4.405869] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FA DF
[    4.412123] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    4.415674] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 2F 00 20 00
[    4.426078] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    4.429659] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 20 00
[    4.435878] [drm:psb_intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    4.435895] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    4.439464] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 2F 00 20 00
[    4.449781] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    4.453325] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 20 00
[    4.459492] [drm:psb_intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    4.459509] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    4.463046] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF 03 00 02
[    4.473298] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 68                         (SDVO_CMD_GET_HPOS)
[    4.476861] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 00 02
[    4.482963] [drm:psb_intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    4.482981] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    4.486520] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF 03 00 02
[    4.496731] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6B                         (SDVO_CMD_GET_VPOS)
[    4.500242] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 00 02
[    4.506337] [drm:psb_intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    4.506353] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    4.509913] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 7F 00 45 00
[    4.520343] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 56                         (SDVO_CMD_GET_SATURATION)
[    4.523888] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 45 00
[    4.530141] [drm:psb_intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    4.530159] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    4.533748] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 7F 00 40 00
[    4.544060] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    4.547571] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 40 00
[    4.553768] [drm:psb_intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    4.553785] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    4.557331] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 7F 00 40 00
[    4.567677] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 59                         (SDVO_CMD_GET_HUE)
[    4.571242] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 40 00
[    4.577514] [drm:psb_intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    4.577532] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    4.581105] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 07 00 04 00
[    4.591509] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    4.595093] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 04 00
[    4.601289] [drm:psb_intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    4.601306] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    4.604862] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) FF 00 80 00
[    4.615090] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    4.618651] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 80 00
[    4.624840] [drm:psb_intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    4.624858] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    4.628385] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 07 00 07 00
[    4.638546] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    4.642068] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 07 00
[    4.648223] [drm:psb_intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    4.648252] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    4.651730] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 03 00 01 00
[    4.661991] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    4.665549] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    4.671722] [drm:psb_intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    4.671738] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    4.675304] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00 02 00
[    4.685603] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    4.689137] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[    4.695275] [drm:psb_intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 2, current 2
[    4.695292] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    4.698826] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    4.704997] [drm:psb_intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    4.705027] [drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
[    4.705236] [drm:drm_sysfs_hotplug_event], generating hotplug event
[    4.705337] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    4.710331] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success)
[    4.712415] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    4.715893] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) C4 09 74 40
[    4.726104] [drm:psb_intel_sdvo_init], SDVOB device VID/DID: 02:42.02, clock range 25MHz - 165MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    4.726158] [drm:psb_intel_sdvo_dpms], DPMS_OFF
[    4.726170] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    4.732647] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success)
[    4.774742] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[    4.779441] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSBLC_B
[    4.779485] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[    4.779505] [drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    4.779545] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1]
[    4.779562] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    4.813030] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[    4.821308] [drm:psb_intel_sdvo_detect], SDVO response 2 0 [8]
[    4.821327] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:SVIDEO-1] disconnected
[    4.821346] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:28:SVIDEO-2]
[    4.821360] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    4.854640] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[    4.862853] [drm:psb_intel_sdvo_detect], SDVO response 2 0 [4]
[    4.862871] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:28:SVIDEO-2] disconnected
[    4.862890] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:VGA-1]
[    4.862903] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    4.896232] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[    4.904460] [drm:psb_intel_sdvo_detect], SDVO response 2 0 [2]
[    4.904484] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    4.911554] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    4.983480] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    4.992104] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    5.059775] [drm:drm_mode_debug_printmodeline], Modeline 80:"1680x1050" 0 187000 1680 1800 1976 2272 1050 1053 1059 1099 0x40 0x6
[    5.059809] [drm:drm_mode_prune_invalid], Not using 1680x1050 mode 15
[    5.059825] [drm:drm_mode_debug_printmodeline], Modeline 79:"1600x1200" 0 202500 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    5.059850] [drm:drm_mode_prune_invalid], Not using 1600x1200 mode 15
[    5.059864] [drm:drm_mode_debug_printmodeline], Modeline 78:"1600x1200" 0 189000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    5.059888] [drm:drm_mode_prune_invalid], Not using 1600x1200 mode 15
[    5.059902] [drm:drm_mode_debug_printmodeline], Modeline 77:"1600x1200" 0 175500 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    5.059926] [drm:drm_mode_prune_invalid], Not using 1600x1200 mode 15
[    5.059963] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:45:VGA-1] probed modes :
[    5.059978] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    5.060054] [drm:drm_mode_debug_printmodeline], Modeline 53:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    5.060093] [drm:drm_mode_debug_printmodeline], Modeline 54:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    5.060129] [drm:drm_mode_debug_printmodeline], Modeline 84:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[    5.060163] [drm:drm_mode_debug_printmodeline], Modeline 75:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[    5.060200] [drm:drm_mode_debug_printmodeline], Modeline 74:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[    5.060237] [drm:drm_mode_debug_printmodeline], Modeline 83:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[    5.060272] [drm:drm_mode_debug_printmodeline], Modeline 72:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    5.060310] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    5.060354] [drm:drm_mode_debug_printmodeline], Modeline 76:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[    5.060378] [drm:drm_mode_debug_printmodeline], Modeline 52:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[    5.060403] [drm:drm_mode_debug_printmodeline], Modeline 50:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    5.060427] [drm:drm_mode_debug_printmodeline], Modeline 82:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[    5.060452] [drm:drm_mode_debug_printmodeline], Modeline 73:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[    5.060476] [drm:drm_mode_debug_printmodeline], Modeline 71:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[    5.060501] [drm:drm_mode_debug_printmodeline], Modeline 70:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[    5.060525] [drm:drm_mode_debug_printmodeline], Modeline 67:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    5.060549] [drm:drm_mode_debug_printmodeline], Modeline 69:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[    5.060573] [drm:drm_mode_debug_printmodeline], Modeline 68:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[    5.060598] [drm:drm_mode_debug_printmodeline], Modeline 49:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[    5.060622] [drm:drm_mode_debug_printmodeline], Modeline 66:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    5.060646] [drm:drm_mode_debug_printmodeline], Modeline 65:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    5.060671] [drm:drm_mode_debug_printmodeline], Modeline 58:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    5.060695] [drm:drm_mode_debug_printmodeline], Modeline 81:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[    5.060719] [drm:drm_mode_debug_printmodeline], Modeline 62:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    5.060743] [drm:drm_mode_debug_printmodeline], Modeline 63:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    5.060767] [drm:drm_mode_debug_printmodeline], Modeline 55:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    5.060791] [drm:drm_mode_debug_printmodeline], Modeline 61:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    5.060815] [drm:drm_mode_debug_printmodeline], Modeline 64:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[    5.060839] [drm:drm_mode_debug_printmodeline], Modeline 60:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    5.060863] [drm:drm_mode_debug_printmodeline], Modeline 59:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[    5.060886] [drm:drm_mode_debug_printmodeline], Modeline 56:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    5.060910] [drm:drm_mode_debug_printmodeline], Modeline 57:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    5.060935] [drm:drm_setup_crtcs], 
[    5.060951] [drm:drm_enable_connectors], connector 7 enabled? yes
[    5.060966] [drm:drm_enable_connectors], connector 11 enabled? no
[    5.060979] [drm:drm_enable_connectors], connector 28 enabled? no
[    5.060993] [drm:drm_enable_connectors], connector 45 enabled? yes
[    5.061006] [drm:drm_target_preferred], looking for cmdline mode on connector 7
[    5.061019] [drm:drm_target_preferred], looking for preferred mode on connector 7
[    5.061033] [drm:drm_target_preferred], found mode 1024x768
[    5.061045] [drm:drm_target_preferred], looking for cmdline mode on connector 45
[    5.061058] [drm:drm_target_preferred], looking for preferred mode on connector 45
[    5.061071] [drm:drm_target_preferred], found mode 1920x1080
[    5.061083] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[    5.061106] [drm:drm_setup_crtcs], desired mode 1024x768 set on crtc 4
[    5.061126] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[    5.061451] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
[    5.160076] [drm:psb_lid_timer_func], LVDS panel never powered up
[  348.087317] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  348.120900] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[  348.129056] [drm:psb_intel_sdvo_detect], SDVO response 2 0 [2]
[  348.129068] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  348.136035] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  378.715260] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  378.748760] [drm:psb_intel_sdvo_read_response], SDVOB: R: (Success) 02 00
[  378.756939] [drm:psb_intel_sdvo_detect], SDVO response 2 0 [2]
[  378.756973] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  378.763888] [drm:psb_intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)

--oC1+HKm2/end4ao3--
