Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1EKQbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:31:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35142 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1EKQbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BJ9nZqRi1/sdFcIM6ycg1FIE+OAWHPtaYw0d4Psn/7yoxawlF1+YOHnghV1BTqAdwB
         5Bhjb9QhB+oW3peV86AwNITdx+hpzm8NQkYajvUkcYIJUX3hM2LK5qb2lYOG0nUjbGEm
         aHjeTq/xTEdscqUYG+CL1fUW06bBAcny7hDbA=
Date: Wed, 11 May 2011 14:41:37 +0200
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110511124137.GA2389@patrik-macbook>
References: <20110510212038.GA3279@patrik-macbook>
 <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
 <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
 <20110511101022.7f6e583b@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110511101022.7f6e583b@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:10:22AM +0100, Alan Cox wrote:
> > pipes and LVDS only finds a bogus mode of 0x0 pixels. Not sure why
> > LVDS takes over instead of SDVO since it has valid modes, but my
> > screen just goes into powersave when no proper PLL can be set for the
> > bogus mode.
> 
> Well that is hopeful. If we get a bogus 0x0 pixel mode it means it did
> detect something invalid but for some reason we didn't punt on it.
> 
> Alan

I've tried setting mode_config.min_width and height to 1 to get rid of the
mode but no luck there.

Been probing the display registers and the only difference is that pipe b is
disabled when lvds is disabled. 

As can be seen in the dmesg output, there are 5 correct modes for SDVO but the
display supports up to 1920x1200 so there is something wrong with the SDVO
probing. Will dig into that later this week.

Below is the output from a regdumper I wrote. LVDS is enabled at this point.

-------- gma500 regdump version 0.1 --------

Probing for hardware: Found gma500 and SCH

PCI config registers:
	GMEM_BASE:	0xc0000000
	GTT_BASE:	0xc0000000
	GC		0x30
	GMS:		0x3 (8 MB of pre-allocated framebuffer)
	VD:		0x0 (VGA is enabled)
	BSM:		0x3f800000
	MSAC:		0x2 (256 MB aperture)
	GCR:		0x1ff0006
	GC2D:		0x1 (ratio is 2:1)
	GCCR:		0x2 (ratio is 3:2)
	ASLS:		0x3f6bccbd

Pipe A:
	HTOTAL:		0x53f03ff (Active: 1024, Total: 1344)
	HBLANK:		0x53f03ff (Start: 1024, End: 1344)
	HSYNC:		0x49f0417 (Start: 1048, End: 1184)
	VTOTAL:		0x32502ff (Active: 768, Total: 806)
	VBLANK:		0x32502ff (Start: 768, End: 806)
	VSYNC:		0x3080302 (Start: 771, End: 777)
	PIPESRC:	0x3ff02ff (Width: 1024, Height: 768)
	BCLRPAT:	0x0
	VSYNCSHIFT:	0x0
	PIPE_DSL:	423
	PIPE_SLC:	0
	PIPE_CONF:	0x80000000 (Enabled)
			State: Disabled
			Interlaced mode: No (Progressive)
			Bits per color: 8 bits
	PIPESTAT:	0x203

Pipe B:
	HTOTAL:		0x31f027f (Active: 640, Total: 800)
	HBLANK:		0x3170287 (Start: 648, End: 792)
	HSYNC:		0x2ef028f (Start: 656, End: 752)
	VTOTAL:		0x20c01df (Active: 480, Total: 525)
	VBLANK:		0x20401e7 (Start: 488, End: 517)
	VSYNC:		0x1eb01e9 (Start: 490, End: 492)
	PIPESRC:	0x27f01df (Width: 640, Height: 480)
	BCLRPAT:	0x0
	VSYNCSHIFT:	0x0
	PIPE_DSL:	185
	PIPE_SLC:	0
	PIPE_CONF:	0x80000000 (Enabled)
			State: Disabled
			Interlaced mode: No (Progressive)
			Bits per color: 8 bits
	PIPESTAT:	0x80000202

DPLL A:
	VCO Enabled: Yes
	SDVO Enabled: Yes
	VGA Disabled: Yes
	Mode select: DAC / SDVO / UDI / TV
	P2 DIV: 0x0
	P1 DIV: 0x1
	Reference input select: DREFCLK (default is 96 MHz)

FPA0:	0x30b06
	Freq doubler: Disabled
	N divisor: 5
	M1 divisor: 13
	M2 divisor: 8

FPA1:	0x31108
	N divisor: 5
	M1 divisor: 19
	M2 divisor: 10

DPLL B:
	VCO Enabled: Yes
	SDVO Enabled: No
	VGA Disabled: No
	Mode select: DAC / SDVO / UDI / TV
	P2 DIV: 0x0
	P1 DIV: 0x80
	Reference input select: DREFCLK (default is 96 MHz)

FPB0:	0x31108
	Freq doubler: Disabled
	N divisor: 5
	M1 divisor: 19
	M2 divisor: 10

FPB1:	0x31108
	N divisor: 5
	M1 divisor: 19
	M2 divisor: 10

SDVOB: 0x80480080
	Enabled: Yes
	Detected: No

SDVOC: 0x0
	Enabled: No
	Detected: No


Here's the dmesg with drm_debug=7, LVDS is also enabled here.

-----------------------------------------------------------

[  165.101334] Linux agpgart interface v0.103
[  165.260816] [drm] Initialized drm 1.1.0 20060810
[  165.355994] psb_gfx: module is from the staging directory, the quality is unknown, you have been warned.
[  165.380626] [drm:drm_pci_init], 
[  165.380737] pvrsrvkm 0000:00:02.0: irq 41 for MSI/MSI-X
[  165.380752] [drm:drm_get_pci_dev], 
[  165.380777] pvrsrvkm 0000:00:02.0: setting latency timer to 64
[  165.380830] [drm:drm_get_minor], 
[  165.381208] [drm:drm_get_minor], new minor assigned 64
[  165.381219] [drm:drm_get_minor], 
[  165.382626] [drm:drm_get_minor], new minor assigned 0
[  165.382863] [drm:psb_intel_opregion_init], OpRegion detected at 0x3f6bccbd
[  165.382884] ioremap error for 0x3f6bc000-0x3f6bf000, requested 0x10, got 0x0
[  165.383050] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[  165.383060] [drm:drm_mode_debug_printmodeline], Modeline 0:"0x0" 0 0 0 0 0 0 0 0 0 0 0x8 0x0
[  165.383077] [drm:parse_backlight_data], lvds_options found at c00c15f2
[  165.383491] GMMADR(region 0) start: 0xc0000000 (256M).
[  165.383501] GTTADR(region 3) start: 0xb0000000 (can map 256M RAM), and actual RAM base 0x3ffc0000.
[  165.383508] Stolen memory information
[  165.383514]        base in RAM: 0x3f800000
[  165.383520]        size: 7932K, calculated by (GTT RAM base) - (Stolen base), seems wrong
[  165.383528]       the correct size should be: 8M(dvmt mode=3)
[  165.386044] [drm:psb_gtt_init], [: vram kernel virtual address 00000010
[  165.386063] Set up 1983 stolen pages starting at 0x0003f800, GTT offset 0K
[  165.387847] [drm] SGX core id = 0x01130000
[  165.387854] [drm] SGX core rev major = 0x01, minor = 0x02
[  165.387858] [drm] SGX core rev maintenance = 0x01, designer = 0x00
[  165.400238] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  165.400255] [drm] No driver support for vblank timestamp query.
[  165.400270] [drm:drm_irq_install], irq=41
[  165.450788] [drm:drm_sysfs_connector_add], adding "LVDS-1" to sysfs
[  165.450876] [drm:drm_sysfs_hotplug_event], generating hotplug event
[  165.736102] [drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
[  165.736184] [drm:drm_sysfs_hotplug_event], generating hotplug event
[  165.768328] [drm:psb_intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[  165.821104] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[  165.869395] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[  165.869404] [drm:drm_mode_debug_printmodeline], Modeline 12:"0x0" 0 0 0 0 0 0 0 0 0 0 0x8 0x0
[  165.869415] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:DVI-D-1]
[  165.883967] [drm:psb_intel_sdvo_detect], SDVO response 1 0
[  165.916232] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:DVI-D-1] probed modes :
[  165.916241] [drm:drm_mode_debug_printmodeline], Modeline 17:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[  165.916253] [drm:drm_mode_debug_printmodeline], Modeline 15:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[  165.916264] [drm:drm_mode_debug_printmodeline], Modeline 14:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[  165.916275] [drm:drm_mode_debug_printmodeline], Modeline 16:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[  165.916285] [drm:drm_mode_debug_printmodeline], Modeline 13:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[  165.916296] [drm:drm_setup_crtcs], 
[  165.916302] [drm:drm_enable_connectors], connector 7 enabled? yes
[  165.916308] [drm:drm_enable_connectors], connector 10 enabled? yes
[  165.916314] [drm:drm_target_preferred], looking for cmdline mode on connector 7
[  165.916320] [drm:drm_target_preferred], looking for preferred mode on connector 7
[  165.916326] [drm:drm_target_preferred], found mode 0x0
[  165.916331] [drm:drm_target_preferred], looking for cmdline mode on connector 10
[  165.916337] [drm:drm_target_preferred], looking for preferred mode on connector 10
[  165.916343] [drm:drm_target_preferred], found mode 1024x768
[  165.916348] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[  165.916357] [drm:drm_setup_crtcs], desired mode 0x0 set on crtc 4
[  165.916364] [drm:drm_setup_crtcs], desired mode 1024x768 set on crtc 3
[  165.916372] [drm:psbfb_probe], psbfb_probe
[  165.919014] [drm:psbfb_create], fb depth is 24
[  165.919019] [drm:psbfb_create],    pitch is 4096
[  165.919025] allocated 1024x768 fb
[  165.919193] fbcon: psbfb (fb0) is primary device
[  165.921717] [drm:drm_crtc_helper_set_config], 
[  165.921726] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:20] #connectors=1 (x y) (0 0)
[  165.921748] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[  165.921756] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[  165.921764] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[  165.921776] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[  165.921792] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[  165.921800] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[  165.921808] [drm:drm_crtc_helper_set_config], [CONNECTOR:10:DVI-D-1] to [CRTC:3]
[  165.921817] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[  165.921824] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[  165.921845] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[  165.954960] [drm:psb_intel_crtc_mode_set], Mode for pipe A:
[  165.954968] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[  165.975298] [drm:psb_intel_pipe_set_base], Writing base 00000000 00000000 0 0
[  165.995146] [drm:drm_crtc_helper_set_mode], [ENCODER:11:TMDS-11] set [MODE:19:1024x768]
[  166.243579] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 1344, vtotal 806, vdisplay 768
[  166.243588] [drm:drm_calc_timestamping_constants], crtc 3: clock 130000 kHz framedur 8332428 linedur 10338, pixeldur 7
[  166.243599] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[  166.243605] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:10:DVI-D-1] set DPMS on
[  166.263610] [drm:drm_crtc_helper_set_config], 
[  166.263614] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:20] #connectors=1 (x y) (0 0)
[  166.263637] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[  166.263643] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[  166.263648] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[  166.263653] [drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:4]
[  166.263659] [drm:drm_crtc_helper_set_config], [CONNECTOR:10:DVI-D-1] to [CRTC:3]
[  166.263665] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[  166.263670] [drm:drm_mode_debug_printmodeline], Modeline 18:"0x0" 0 0 0 0 0 0 0 0 0 0 0x8 0x0
[  166.263683] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[  166.283862] [drm:psb_intel_crtc_mode_set] *ERROR* Couldn't find PLL settings for mode!
[  166.283868] [drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:18:0x0]
