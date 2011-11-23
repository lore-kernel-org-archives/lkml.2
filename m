Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1KWW0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:26:51 -0500
Received: from sif.is.scarlet.be ([193.74.71.28]:56098 "EHLO sif.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab1KWW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:26:48 -0500
X-Scarlet: d=1322087206 c=62.235.213.72
From: Treeve Jelbert <treeve@scarlet.be>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Radeon display connector : No monitor connected or invalid EDID
Date: Wed, 23 Nov 2011 23:26:45 +0100
Message-ID: <37778844.LVea7QDOO0@gemini-64>
User-Agent: KMail/4.7.3 (Linux/3.1.2; KDE/4.7.3; x86_64; git-a0efdf8; 2011-11-15)
In-Reply-To: <4ECD5973.7080605@canonical.com>
References: <2407026.akcTO2Ggic@gemini-64> <4ECD5973.7080605@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-DCC-scarlet.be-Metrics: sif 20001; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 November 2011 15:37:07 you wrote:
> Have you ever tested the 3.0 kernel on this machine?  There is a similar 
> issue reported[1] for a system equipped with an AMD APU, but that issue 
> happens on a 3.0.6 kernel.


I tried git-bisect all the way back to 3.0, with the same result

I currently have 3.1.2
If I build the kernel without Radeon KMS support, everything boots 
successfully, but Xorg reports that the Radeon driver needs KMS, so reverts to 
VESA and then everything is ok.

When I enable KMS, the screen blacks out during the boot process, but I can 
login in using ssh

# dmesg |grep drm
[    4.916467] [drm] Initialized drm 1.1.0 20060810
[    5.498832] [drm] radeon defaulting to kernel modesetting.
[    5.498899] [drm] radeon kernel modesetting enabled.
[    5.676991] [drm] initializing kernel modesetting (SUMO 0x1002:0x9647 
0x17AA:0x21EA).
[    5.677155] [drm] register mmio base: 0xF0B00000
[    5.677230] [drm] register mmio size: 262144
[    5.678224] [drm] Detected VRAM RAM=512M, BAR=256M
[    5.678295] [drm] RAM width 32bits DDR
[    5.678656] [drm] radeon: 512M of VRAM memory ready
[    5.678721] [drm] radeon: 512M of GTT memory ready.
[    5.678800] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.678863] [drm] Driver supports precise vblank timestamp query.
[    5.679080] [drm] radeon: irq initialized.
[    5.679148] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.681874] [drm] Loading SUMO Microcode
[    6.101298] [drm] ring test succeeded in 1 usecs
[    6.101477] [drm] radeon: ib pool ready.
[    6.101605] [drm] ib test succeeded in 0 usecs
[    6.106994] [drm] Radeon Display Connectors
[    6.107061] [drm] Connector 0:
[    6.107123] [drm]   VGA
[    6.107184] [drm]   HPD2
[    6.107305] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 
0x644c
[    6.107395] [drm]   Encoders:
[    6.107456] [drm]     CRT1: INTERNAL_UNIPHY2
[    6.107517] [drm]     CRT1: NUTMEG
[    6.107579] [drm] Connector 1:
[    6.107640] [drm]   LVDS
[    6.107700] [drm]   HPD1
[    6.107762] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 
0x643c
[    6.107851] [drm]   Encoders:
[    6.107912] [drm]     LCD1: INTERNAL_UNIPHY2
[    6.107974] [drm]     LCD1: TRAVIS
[    6.108035] [drm] Connector 2:
[    6.108096] [drm]   HDMI-A
[    6.108157] [drm]   HPD3
[    6.108264] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 
0x645c
[    6.108358] [drm]   Encoders:
[    6.108421] [drm]     DFP1: INTERNAL_UNIPHY
[    6.505257] [drm] Radeon display connector VGA-1: No monitor connected or 
invalid EDID
[    6.905818] [drm] Radeon display connector LVDS-1: No monitor connected or 
invalid EDID
[    7.305261] [drm] Radeon display connector HDMI-A-1: No monitor connected 
or invalid EDID
[    7.333255] [drm] Internal thermal controller without fan control
[    7.333639] [drm] radeon: power management initialized
[    7.584072] [drm] fb mappable at 0xE0141000
[    7.584188] [drm] vram apper at 0xE0000000
[    7.584253] [drm] size 4325376
[    7.584314] [drm] fb depth is 24
[    7.584376] [drm]    pitch is 5632
[    7.584790] fbcon: radeondrmfb (fb0) is primary device
[    7.677457] fb0: radeondrmfb frame buffer device
[    7.677472] drm: registered panic notifier
[    7.677497] [drm] Initialized radeon 2.11.0 20080528 for 0000:00:01.0 on 
minor 0


I am not sure why fb support is enabled, but I could not remove it.

the Xorg.log shows:

[ 16851.295] (II) RADEON(0): Creating default Display subsection in Screen 
section
[ 16851.295] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[ 16851.295] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp 
pixmaps)
[ 16851.295] (==) RADEON(0): Default visual is TrueColor
[ 16851.295] (==) RADEON(0): RGB weight 888
[ 16851.295] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[ 16851.295] (--) RADEON(0): Chipset: "SUMO" (ChipID = 0x9647)
[ 16851.295] (II) RADEON(0): PCIE card detected
[ 16851.309] (II) RADEON(0): KMS Color Tiling: enabled
[ 16851.309] (II) RADEON(0): KMS Pageflipping: enabled
[ 16851.309] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[ 16851.502] (II) RADEON(0): Output VGA-0 has no monitor section
[ 16851.541] (II) RADEON(0): Output LVDS has no monitor section
[ 16851.700] (II) RADEON(0): Output HDMI-0 has no monitor section
[ 16851.892] (II) RADEON(0): EDID for output VGA-0
[ 16851.958] (II) RADEON(0): EDID for output LVDS
[ 16851.958] (II) RADEON(0): Manufacturer: AUO  Model: 23ec  Serial#: 0
[ 16851.958] (II) RADEON(0): Year: 2009  Week: 1
[ 16851.958] (II) RADEON(0): EDID Version: 1.3
[ 16851.958] (II) RADEON(0): Digital Display Input
[ 16851.958] (II) RADEON(0): Max Image Size [cm]: horiz.: 34  vert.: 19
[ 16851.958] (II) RADEON(0): Gamma: 2.20
[ 16851.958] (II) RADEON(0): No DPMS capabilities specified
[ 16851.958] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[ 16851.958] (II) RADEON(0): First detailed timing is preferred mode
[ 16851.958] (II) RADEON(0): redX: 0.620 redY: 0.340   greenX: 0.330 greenY: 
0.570
[ 16851.958] (II) RADEON(0): blueX: 0.150 blueY: 0.060   whiteX: 0.313 whiteY: 
0.329
[ 16851.958] (II) RADEON(0): Manufacturer's mask: 0
[ 16851.958] (II) RADEON(0): Supported detailed timing:
[ 16851.958] (II) RADEON(0): clock: 69.3 MHz   Image Size:  344 x 193 mm
[ 16851.958] (II) RADEON(0): h_active: 1366  h_sync: 1398  h_sync_end 1422 
h_blank_end 1432 h_border: 0
[ 16851.958] (II) RADEON(0): v_active: 768  v_sync: 771  v_sync_end 775 
v_blanking: 806 v_border: 0
[ 16851.958] (II) RADEON(0): Unknown vendor-specific block f
[ 16851.958] (II) RADEON(0):  AUO
[ 16851.958] (II) RADEON(0):  B156XW02 V3
[ 16851.958] (II) RADEON(0): EDID (in hex):
[ 16851.958] (II) RADEON(0):    00ffffffffffff0006afec2300000000
[ 16851.958] (II) RADEON(0):    01130103802213780ac8959e57549226
[ 16851.958] (II) RADEON(0):    0f505400000001010101010101010101
[ 16851.958] (II) RADEON(0):    010101010101121b5642500026302018
[ 16851.958] (II) RADEON(0):    340058c1100000180000000f00000000
[ 16851.958] (II) RADEON(0):    00000000000000000020000000fe0041
[ 16851.958] (II) RADEON(0):    554f0a202020202020202020000000fe
[ 16851.958] (II) RADEON(0):    004231353658573032205633200a00be
[ 16851.958] (II) RADEON(0): Printing probed modes for output LVDS
[ 16851.958] (II) RADEON(0): Modeline "1366x768"x60.0   69.30  1366 1398 1422 
1432  768 771 775 806 -hsync -vsync (48.4 kHz)
[ 16851.958] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 
1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[ 16851.958] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 
1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[ 16851.958] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 
1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[ 16851.958] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  
600 603 607 624 -hsync +vsync (37.4 kHz)
[ 16851.958] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1056  
480 483 493 500 -hsync +vsync (29.8 kHz)
[ 16851.958] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 896  
480 483 493 500 -hsync +vsync (29.9 kHz)
[ 16851.958] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  
480 483 487 500 -hsync +vsync (29.7 kHz)
[ 16852.116] (II) RADEON(0): EDID for output HDMI-0
[ 16852.116] (II) RADEON(0): Output VGA-0 disconnected
[ 16852.116] (II) RADEON(0): Output LVDS connected
[ 16852.116] (II) RADEON(0): Output HDMI-0 disconnected
[ 16852.116] (II) RADEON(0): Using exact sizes for initial modes
[ 16852.116] (II) RADEON(0): Output LVDS using initial mode 1366x768
[ 16852.116] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless 
otherwise stated.
[ 16852.116] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: 
s:20000000 visible:fba0000
[ 16852.116] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[ 16852.116] (==) RADEON(0): DPI set to (96, 96)
[ 16852.149] (II) RADEON(0): [DRI2] Setup complete
[ 16852.149] (II) RADEON(0): [DRI2]   DRI driver: r600
[ 16852.149] (II) RADEON(0): [DRI2]   VDPAU driver: r600
[ 16852.149] (II) RADEON(0): Front buffer size: 4224K
[ 16852.149] (II) RADEON(0): VRAM usage limit set to 228096K
[ 16852.153] (==) RADEON(0): Backing store disabled
[ 16852.153] (II) RADEON(0): Direct rendering enabled
[ 16852.167] (II) RADEON(0): Setting EXA maxPitchBytes
[ 16852.168] (II) RADEON(0): Acceleration enabled
[ 16852.168] (==) RADEON(0): DPMS enabled
[ 16852.168] (==) RADEON(0): Silken mouse enabled
[ 16852.197] (II) RADEON(0): Set up textured video
[ 16852.197] (II) RADEON(0): [XvMC] Associated with Radeon Textured Video.
[ 16852.197] (II) RADEON(0): [XvMC] Extension initialized.
[ 16852.197] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR 
disabled message.
[ 16852.617] (II) RADEON(0): Setting screen physical size to 361 x 203


but the screen is still black





Regards, Treeve



