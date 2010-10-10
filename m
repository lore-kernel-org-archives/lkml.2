Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0JJMaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:30:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48507 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0JJMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:30:03 -0400
Date: Sun, 10 Oct 2010 14:30:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: REGRESSION 2.6.36: radeon KMS console switch broken
Message-ID: <20101010123000.GD8256@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I see a radeon regression here with 2.6.36-rc7.

I updated a system from 2.6.35 to 2.6.36-rc7. Now I cannot 
switch to the text console from the X server anymore; the screen just 
keeps displaying the X desktop. Eventually when I switch back
to X things work again. 

The console switching worked in 2.6.35 
(I had occasional GPU hangs in .35, but console switch always worked)
I didn't change the Xserver userland.

The system has a ATI Technologies Inc RV710/730 running Dual Head.

-Andi

Relevant kernel logs: (for 2.6.36-rc7):

[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
radeon 0000:01:00.0: setting latency timer to 64
[drm] initializing kernel modesetting (RV710 0x1002:0x954F).
[drm] register mmio base: 0xFBCF0000
[drm] register mmio size: 65536
ATOM BIOS: AHD4350LP2
radeon 0000:01:00.0: VRAM: 512M 0x00000000 - 0x1FFFFFFF (512M used)
radeon 0000:01:00.0: GTT: 512M 0x20000000 - 0x3FFFFFFF
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[drm] Detected VRAM RAM=512M, BAR=256M
[drm] RAM width 64bits DDR
[TTM] Zone  kernel: Available graphics memory: 2022304 kiB.
[TTM] Initializing pool allocator.
[drm] radeon: 512M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
radeon 0000:01:00.0: irq 48 for MSI/MSI-X
radeon 0000:01:00.0: radeon: using MSI.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading RV710 Microcode
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Enabling audio support
failed to evaluate ATIF got AE_BAD_PARAMETER
[drm] Default TV standard: NTSC
[drm] Default TV standard: NTSC
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 1:
[drm]   HDMI-A
[drm]   HPD1
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY
[drm] Connector 2:
[drm]   DVI-I
[drm]   HPD4
[drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP2: INTERNAL_UNIPHY2
[drm] Internal thermal controller with fan control
[drm] radeon: power management initialized
[drm] fb mappable at 0xD0142000
[drm] vram apper at 0xD0000000
[drm] size 9216000
[drm] fb depth is 24
[drm]    pitch is 7680
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.6.0 20080528 for 0000:01:00.0 on minor 0
[drm:drm_mode_getfb] *ERROR* invalid framebuffer id

Xorg log:

[    49.670] 
X.Org X Server 1.8.0
Release Date: 2010-04-02
[    49.701] X Protocol Version 11, Revision 0
[    49.701] Build Operating System: openSUSE SUSE LINUX
[    49.701] Current Operating System: Linux basil 2.6.36-rc7-BASIL #5 SMP Sun Oct 10 12:36:48 CEST 2010 x86_64
[    49.701] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-26
[    49.701] Build Date: 19 August 2010  03:34:22PM
[    49.701]  
[    49.701] Current version of pixman: 0.18.0
[    49.701] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    49.701] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    49.701] (==) Log file: "/var/log/Xorg.0.log", Time: Sun Oct 10 12:46:52 2010
[    49.721] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    49.721] (==) No Layout section.  Using the first Screen section.
[    49.721] (**) |-->Screen "Default Screen" (0)
[    49.721] (**) |   |-->Monitor "Default Monitor"
[    49.721] (**) |   |-->Device "Default Device"
[    49.721] (==) Automatically adding devices
[    49.721] (==) Automatically enabling devices
[    49.721] (WW) The directory "/usr/share/fonts/TTF/" does not exist.
[    49.721] 	Entry deleted from font path.
[    49.721] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[    49.721] 	Entry deleted from font path.
[    49.721] (==) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/URW/,
	/usr/share/fonts/cyrillic:unscaled,
	/usr/share/fonts/misc/sgi:unscaled,
	/usr/share/fonts/truetype/
[    49.721] (==) ModulePath set to "/usr/lib64/xorg/modules/updates,/usr/lib64/xorg/modules"
[    49.721] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    49.721] (II) Loader magic: 0x7d5ba0
[    49.721] (II) Module ABI versions:
[    49.721] 	X.Org ANSI C Emulation: 0.4
[    49.721] 	X.Org Video Driver: 7.0
[    49.721] 	X.Org XInput driver : 9.0
[    49.721] 	X.Org Server Extension : 3.0
[    49.725] (--) PCI:*(0:1:0:0) 1002:954f:1028:904e ATI Technologies Inc RV710 [Radeon HD 4350] rev 0, Mem @ 0xd0000000/268435456, 0xfbcf0000/65536, I/O @ 0x0000c000/256, BIOS @ 0x????????/131072
[    49.725] (II) Open ACPI successful (/var/run/acpid.socket)
[    49.725] (II) LoadModule: "extmod"
[    49.950] (II) Loading /usr/lib64/xorg/modules/extensions/libextmod.so
[    50.041] (II) Module extmod: vendor="X.Org Foundation"
[    50.041] 	compiled for 1.8.0, module version = 1.0.0
[    50.041] 	Module class: X.Org Server Extension
[    50.041] 	ABI class: X.Org Server Extension, version 3.0
[    50.041] (II) Loading extension MIT-SCREEN-SAVER
[    50.041] (II) Loading extension XFree86-VidModeExtension
[    50.041] (II) Loading extension XFree86-DGA
[    50.041] (II) Loading extension DPMS
[    50.041] (II) Loading extension XVideo
[    50.041] (II) Loading extension XVideo-MotionCompensation
[    50.041] (II) Loading extension X-Resource
[    50.041] (II) LoadModule: "dbe"
[    50.042] (II) Loading /usr/lib64/xorg/modules/extensions/libdbe.so
[    50.082] (II) Module dbe: vendor="X.Org Foundation"
[    50.082] 	compiled for 1.8.0, module version = 1.0.0
[    50.082] 	Module class: X.Org Server Extension
[    50.082] 	ABI class: X.Org Server Extension, version 3.0
[    50.082] (II) Loading extension DOUBLE-BUFFER
[    50.082] (II) LoadModule: "glx"
[    50.083] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[    50.083] (II) Module glx: vendor="X.Org Foundation"
[    50.083] 	compiled for 1.8.0, module version = 1.0.0
[    50.083] 	ABI class: X.Org Server Extension, version 3.0
[    50.083] (==) AIGLX enabled
[    50.083] (II) Loading extension GLX
[    50.083] (II) LoadModule: "record"
[    50.083] (II) Loading /usr/lib64/xorg/modules/extensions/librecord.so
[    50.083] (II) Module record: vendor="X.Org Foundation"
[    50.083] 	compiled for 1.8.0, module version = 1.13.0
[    50.083] 	Module class: X.Org Server Extension
[    50.083] 	ABI class: X.Org Server Extension, version 3.0
[    50.083] (II) Loading extension RECORD
[    50.083] (II) LoadModule: "dri"
[    50.084] (II) Loading /usr/lib64/xorg/modules/extensions/libdri.so
[    50.084] (II) Module dri: vendor="X.Org Foundation"
[    50.084] 	compiled for 1.8.0, module version = 1.0.0
[    50.084] 	ABI class: X.Org Server Extension, version 3.0
[    50.084] (II) Loading extension XFree86-DRI
[    50.084] (II) LoadModule: "dri2"
[    50.084] (II) Loading /usr/lib64/xorg/modules/extensions/libdri2.so
[    50.084] (II) Module dri2: vendor="X.Org Foundation"
[    50.084] 	compiled for 1.8.0, module version = 1.2.0
[    50.084] 	ABI class: X.Org Server Extension, version 3.0
[    50.084] (II) Loading extension DRI2
[    50.084] (==) Matched fglrx as autoconfigured driver 0
[    50.084] (==) Matched radeonhd as autoconfigured driver 1
[    50.084] (==) Matched ati as autoconfigured driver 2
[    50.084] (==) Matched fbdev as autoconfigured driver 3
[    50.084] (==) Matched vesa as autoconfigured driver 4
[    50.084] (==) Assigned the driver to the xf86ConfigLayout
[    50.084] (II) LoadModule: "fglrx"
[    50.155] (WW) Warning, couldn't open module fglrx
[    50.161] (II) UnloadModule: "fglrx"
[    50.161] (EE) Failed to load module "fglrx" (module does not exist, 0)
[    50.161] (II) LoadModule: "radeonhd"
[    50.161] (II) Loading /usr/lib64/xorg/modules/drivers/radeonhd_drv.so
[    50.161] (II) Module radeonhd: vendor="AMD GPG"
[    50.161] 	compiled for 1.8.0, module version = 1.3.0
[    50.161] 	Module class: X.Org Video Driver
[    50.161] 	ABI class: X.Org Video Driver, version 7.0
[    50.162] (II) LoadModule: "ati"
[    50.162] (II) Loading /usr/lib64/xorg/modules/drivers/ati_drv.so
[    50.167] (II) Module ati: vendor="X.Org Foundation"
[    50.167] 	compiled for 1.8.0, module version = 6.13.0
[    50.167] 	Module class: X.Org Video Driver
[    50.167] 	ABI class: X.Org Video Driver, version 7.0
[    50.167] (II) LoadModule: "radeon"
[    50.168] (II) Loading /usr/lib64/xorg/modules/drivers/radeon_drv.so
[    50.226] (II) Module radeon: vendor="X.Org Foundation"
[    50.244] 	compiled for 1.8.0, module version = 6.13.0
[    50.244] 	Module class: X.Org Video Driver
[    50.244] 	ABI class: X.Org Video Driver, version 7.0
[    50.244] (II) LoadModule: "fbdev"
[    50.244] (II) Loading /usr/lib64/xorg/modules/drivers/fbdev_drv.so
[    50.255] (II) Module fbdev: vendor="X.Org Foundation"
[    50.269] 	compiled for 1.8.0, module version = 0.4.1
[    50.269] 	ABI class: X.Org Video Driver, version 7.0
[    50.269] (II) LoadModule: "vesa"
[    50.269] (II) Loading /usr/lib64/xorg/modules/drivers/vesa_drv.so
[    50.280] (II) Module vesa: vendor="X.Org Foundation"
[    50.289] 	compiled for 1.8.0, module version = 2.2.1
[    50.289] 	Module class: X.Org Video Driver
[    50.289] 	ABI class: X.Org Video Driver, version 7.0
[    50.289] (II) RADEONHD: X driver for the following AMD GPG (ATI) graphics devices:
[    50.289] 	RV505 : Radeon X1550, X1550 64bit.
	RV515 : Radeon X1300, X1550, X1600; FireGL V3300, V3350.
	RV516 : Radeon X1300, X1550, X1550 64-bit, X1600; FireMV 2250.
	R520  : Radeon X1800; FireGL V5300, V7200, V7300, V7350.
	RV530 : Radeon X1300 XT, X1600, X1600 Pro, X1650; FireGL V3400, V5200.
	RV535 : Radeon X1300, X1650.
	RV550 : Radeon X2300 HD.
	RV560 : Radeon X1650.
	RV570 : Radeon X1950, X1950 GT; FireGL V7400.
	R580  : Radeon X1900, X1950; AMD Stream Processor.
[    50.289] 	R600  : Radeon HD 2900 GT/Pro/XT; FireGL V7600/V8600/V8650.
	RV610 : Radeon HD 2350, HD 2400 Pro/XT, HD 2400 Pro AGP; FireGL V4000.
	RV620 : Radeon HD 3450, HD 3470.
	RV630 : Radeon HD 2600 LE/Pro/XT, HD 2600 Pro/XT AGP; Gemini RV630;
		FireGL V3600/V5600.
	RV635 : Radeon HD 3650, HD 3670.
	RV670 : Radeon HD 3690, 3850, HD 3870, FireGL V7700, FireStream 9170.
	R680  : Radeon HD 3870 X2.
[    50.289] 	M52   : Mobility Radeon X1300.
	M54   : Mobility Radeon X1400; M54-GL.
	M56   : Mobility Radeon X1600; Mobility FireGL V5200.
	M58   : Mobility Radeon X1800, X1800 XT; Mobility FireGL V7100, V7200.
	M62   : Mobility Radeon X1350.
	M64   : Mobility Radeon X1450, X2300.
	M66   : Mobility Radeon X1700, X1700 XT; FireGL V5250.
	M68   : Mobility Radeon X1900.
[    50.289] 	M71   : Mobility Radeon HD 2300.
	M72   : Mobility Radeon HD 2400; Radeon E2400.
	M74   : Mobility Radeon HD 2400 XT.
	M76   : Mobility Radeon HD 2600;
		(Gemini ATI) Mobility Radeon HD 2600 XT.
[    50.289] 	M82   : Mobility Radeon HD 3400.
	M86   : Mobility Radeon HD 3650, HD 3670, Mobility FireGL V5700.
	M88   : Mobility Radeon HD 3850, HD 3850 X2, HD 3870, HD3870 X2.
[    50.289] 	RS600 : Radeon Xpress 1200, Xpress 1250.
	RS690 : Radeon X1200, X1250, X1270.
	RS740 : RS740, RS740M.
	RS780 : Radeon HD 3100/3200/3300 Series.
[    50.289] 	R700  : Radeon R700.
	RV710 : Radeon HD4570, HD4350.
	RV730 : Radeon HD4670, HD4650.
	RV740 : Radeon HD4770. EXPERIMENTAL AND UNTESTED.
	RV770 : Radeon HD 4800 Series; Everest, K2, Denali ATI FirePro.
	RV790 : Radeon HD 4890.
[    50.289] 	M92   : Mobility Radeon HD4330, HD4530, HD4570. EXPERIMENTAL.
	M93   : Mobility Radeon M93. EXPERIMENTAL AND UNTESTED.
	M96   : Mobility Radeon HD4600.
	M97   : Mobility Radeon HD4860. EXPERIMENTAL AND UNTESTED.
	M98   : Mobility Radeon HD4850, HD4870.
[    50.289] 
[    50.289] (II) RADEONHD: version 1.3.0, built from dist of git branch master, commit f6c99911

[    50.289] (II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon 8500 AIW BC (AGP),
	ATI Radeon IGP320M (U1) 4336, ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420) JH (AGP),
	ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP),
	ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9800PRO NH (AGP),
	ATI Radeon 9800 NI (AGP), ATI FireGL X2 NK (AGP),
	ATI Radeon 9800XT NJ (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),
	ATI Radeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI Radeon X800 XTP (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 (R430) (PCIE),
	ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835,
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI ES1000 5969 (PCI), ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE),
	ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4C (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE),
	ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X700 XT (RV410) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X1800,
	ATI Mobility Radeon X1800 XT, ATI Mobility Radeon X1800,
	ATI Mobility FireGL V7200, ATI FireGL V7200, ATI FireGL V5300,
	ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X1800,
	ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,
	ATI FireGL V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,
	ATI Radeon X1300/X1550, ATI Radeon X1550, ATI M54-GL,
	ATI Mobility Radeon X1400, ATI Radeon X1300/X1550,
	ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Radeon X1300, ATI Radeon X1300,
	ATI RV505, ATI RV505, ATI FireGL V3300, ATI FireGL V3350,
	ATI Radeon X1300, ATI Radeon X1550 64-bit, ATI Radeon X1300/X1550,
	ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mobility Radeon X1450,
	ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,
	ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,
	ATI Mobility Radeon X1350, ATI Mobility Radeon X1450,
	ATI Radeon X1300, ATI Radeon X1550, ATI Mobility Radeon X1350,
	ATI FireMV 2250, ATI Radeon X1550 64-bit, ATI Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,
	ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1650, ATI Radeon X1600,
	ATI Radeon X1300 XT/X1600 Pro, ATI FireGL V3400,
	ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,
	ATI Mobility Radeon X1700 XT, ATI FireGL V5200,
	ATI Mobility Radeon X1700, ATI Radeon X2300HD,
	ATI Mobility Radeon HD 2300, ATI Mobility Radeon HD 2300,
	ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X1950,
	ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,
	ATI Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,
	ATI RV560, ATI Radeon X1650, ATI Radeon X1650, ATI RV560,
	ATI Radeon 9100 PRO IGP 7834, ATI Radeon Mobility 9200 IGP 7835,
	ATI Radeon X1200, ATI Radeon X1200, ATI Radeon X1200,
	ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS740M, ATI RS740,
	ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 XT,
	ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD 2900 GT,
	ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,
	ATI Radeon 4800 Series, ATI Radeon HD 4870 x2,
	ATI Radeon 4800 Series, ATI Radeon HD 4850 x2,
	ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),
	ATI Mobility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,
	ATI Radeon 4800 Series, ATI FirePro RV770, AMD FireStream 9270,
	AMD FireStream 9250, ATI FirePro V8700 (FireGL),
	ATI Mobility RADEON HD 4870, ATI Mobility RADEON M98,
	ATI Radeon 4800 Series, ATI Radeon 4800 Series, ATI FirePro M7750,
	ATI M98, ATI M98, ATI M98, ATI Mobility Radeon HD 4650,
	ATI Radeon RV730 (AGP), ATI Mobility Radeon HD 4670,
	ATI FirePro M5750, ATI Radeon RV730 (AGP),
	ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,
	ATI Radeon HD 4600 Series, ATI RV730 PRO [Radeon HD 4650],
	ATI FirePro V7750 (FireGL), ATI FirePro V5700 (FireGL),
	ATI FirePro V3750 (FireGL), ATI Mobility Radeon HD 4830,
	ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,
	ATI Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,
	ATI FirePro M5750, ATI RV610, ATI Radeon HD 2400 XT,
	ATI Radeon HD 2400 Pro, ATI Radeon HD 2400 PRO AGP, ATI FireGL V4000,
	ATI RV610, ATI Radeon HD 2350, ATI Mobility Radeon HD 2400 XT,
	ATI Mobility Radeon HD 2400, ATI RADEON E2400, ATI RV610,
	ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,
	ATI Mobility Radeon HD 3850, ATI Radeon HD3850,
	ATI Mobility Radeon HD 3850 X2, ATI RV670,
	ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 3870 X2,
	ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,
	ATI Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon HD 4350,
	ATI Mobility Radeon 4300 Series, ATI Mobility Radeon 4500 Series,
	ATI Mobility Radeon 4500 Series, ATI FirePro RG220, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon RV710,
	ATI Radeon HD 3470, ATI Mobility Radeon HD 3430,
	ATI Mobility Radeon HD 3400 Series, ATI Radeon HD 3450,
	ATI Radeon HD 3450, ATI Radeon HD 3430, ATI Radeon HD 3450,
	ATI FirePro V3700, ATI FireMV 2450, ATI FireMV 2260, ATI FireMV 2260,
	ATI Radeon HD 3600 Series, ATI Radeon HD 3650 AGP,
	ATI Radeon HD 3600 PRO, ATI Radeon HD 3600 XT,
	ATI Radeon HD 3600 PRO, ATI Mobility Radeon HD 3650,
	ATI Mobility Radeon HD 3670, ATI Mobility FireGL V5700,
	ATI Mobility FireGL V5725, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3100 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3100 Graphics, ATI Radeon HD 3300 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3000 Graphics,
	ATI Radeon HD 4200, ATI Radeon 4100, ATI Mobility Radeon HD 4200,
	ATI Mobility Radeon 4100, ATI Radeon HD 4290, ATI Radeon HD 4290,
	CYPRESS, ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5900 Series, ATI Radeon HD 5900 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 5700 Series,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,
	ATI Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, CEDAR, CEDAR, CEDAR,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, CEDAR, ATI Radeon HD 5450,
	CEDAR
[    50.291] (II) FBDEV: driver for framebuffer: fbdev
[    50.291] (II) VESA: driver for VESA chipsets: vesa
[    50.291] (++) using VT number 7

[    50.297] (II) Primary Device is: PCI 01@00:00:0
[    50.297] drmOpenDevice: node name is /dev/dri/card0
[    51.636] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[    51.636] drmOpenDevice: node name is /dev/dri/card0
[    51.636] drmOpenDevice: open result is 9, (OK)
[    51.636] drmOpenByBusid: drmOpenMinor returns 9
[    51.636] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[    51.636] (II) [DRM] Kernel mode setting enabled
[    51.636] (EE) FATAL: RadeonHD presently does not work with kernel modesetting (KMS).
Please disable KMS in your kernel.
[    51.636] (II) [KMS] Kernel modesetting enabled.
[    51.636] (WW) Falling back to old probe method for fbdev
[    51.636] (II) Loading sub module "fbdevhw"
[    51.636] (II) LoadModule: "fbdevhw"
[    51.637] (II) Loading /usr/lib64/xorg/modules/linux/libfbdevhw.so
[    51.662] (II) Module fbdevhw: vendor="X.Org Foundation"
[    51.662] 	compiled for 1.8.0, module version = 0.0.2
[    51.662] 	ABI class: X.Org Video Driver, version 7.0
[    51.662] (WW) Falling back to old probe method for vesa
[    51.662] (II) RADEON(1): Creating default Display subsection in Screen section
	"Default Screen" for depth/fbbpp 24/32
[    51.662] (==) RADEON(1): Depth 24, (--) framebuffer bpp 32
[    51.662] (II) RADEON(1): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[    51.662] (==) RADEON(1): Default visual is TrueColor
[    51.662] (==) RADEON(1): RGB weight 888
[    51.662] (II) RADEON(1): Using 8 bits per RGB (8 bit DAC)
[    51.662] (--) RADEON(1): Chipset: "ATI Radeon HD 4350" (ChipID = 0x954f)
[    51.662] (II) RADEON(1): PCIE card detected
[    51.663] (WW) RADEON(1): Color tiling is not yet supported on R600/R700
[    51.663] (II) RADEON(1): KMS Color Tiling: disabled
[    51.663] drmOpenDevice: node name is /dev/dri/card0
[    51.663] drmOpenDevice: open result is 10, (OK)
[    51.663] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[    51.663] drmOpenDevice: node name is /dev/dri/card0
[    51.663] drmOpenDevice: open result is 10, (OK)
[    51.663] drmOpenByBusid: drmOpenMinor returns 10
[    51.663] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[    51.684] (II) RADEON(1): Output VGA-0 using monitor section Default Monitor
[    51.793] (II) RADEON(1): Output HDMI-0 has no monitor section
[    51.901] (II) RADEON(1): Output DVI-0 has no monitor section
[    51.916] (II) RADEON(1): EDID for output VGA-0
[    52.024] (II) RADEON(1): EDID for output HDMI-0
[    52.024] (II) RADEON(1): Manufacturer: BNQ  Model: 780a  Serial#: 21573
[    52.024] (II) RADEON(1): Year: 2008  Week: 3
[    52.024] (II) RADEON(1): EDID Version: 1.3
[    52.024] (II) RADEON(1): Digital Display Input
[    52.024] (II) RADEON(1): Max Image Size [cm]: horiz.: 52  vert.: 32
[    52.024] (II) RADEON(1): Gamma: 2.20
[    52.024] (II) RADEON(1): DPMS capabilities: Off
[    52.024] (II) RADEON(1): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    52.024] (II) RADEON(1): Default color space is primary color space
[    52.024] (II) RADEON(1): First detailed timing is preferred mode
[    52.024] (II) RADEON(1): redX: 0.640 redY: 0.340   greenX: 0.290 greenY: 0.610
[    52.024] (II) RADEON(1): blueX: 0.140 blueY: 0.070   whiteX: 0.310 whiteY: 0.320
[    52.024] (II) RADEON(1): Supported established timings:
[    52.024] (II) RADEON(1): 720x400@70Hz
[    52.024] (II) RADEON(1): 640x480@60Hz
[    52.024] (II) RADEON(1): 640x480@75Hz
[    52.024] (II) RADEON(1): 800x600@60Hz
[    52.024] (II) RADEON(1): 800x600@75Hz
[    52.024] (II) RADEON(1): 832x624@75Hz
[    52.024] (II) RADEON(1): 1024x768@60Hz
[    52.024] (II) RADEON(1): 1024x768@75Hz
[    52.024] (II) RADEON(1): 1280x1024@75Hz
[    52.024] (II) RADEON(1): 1152x864@75Hz
[    52.024] (II) RADEON(1): Manufacturer's mask: 0
[    52.024] (II) RADEON(1): Supported standard timings:
[    52.024] (II) RADEON(1): #0: hsize: 1152  vsize 720  refresh: 60  vid: 113
[    52.024] (II) RADEON(1): #1: hsize: 1280  vsize 800  refresh: 60  vid: 129
[    52.024] (II) RADEON(1): #2: hsize: 1440  vsize 900  refresh: 60  vid: 149
[    52.024] (II) RADEON(1): #3: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    52.024] (II) RADEON(1): #4: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[    52.024] (II) RADEON(1): #5: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    52.024] (II) RADEON(1): #6: hsize: 1920  vsize 1200  refresh: 60  vid: 209
[    52.024] (II) RADEON(1): Supported detailed timing:
[    52.024] (II) RADEON(1): clock: 154.0 MHz   Image Size:  519 x 324 mm
[    52.024] (II) RADEON(1): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
[    52.024] (II) RADEON(1): v_active: 1200  v_sync: 1203  v_sync_end 1209 v_blanking: 1235 v_border: 0
[    52.024] (II) RADEON(1): Serial No: 41807922SL0
[    52.024] (II) RADEON(1): Ranges: V min: 50 V max: 85 Hz, H min: 31 H max: 94 kHz, PixClock max 170 MHz
[    52.024] (II) RADEON(1): Monitor name: BenQ G2400W
[    52.024] (II) RADEON(1): Supported detailed timing:
[    52.024] (II) RADEON(1): clock: 74.2 MHz   Image Size:  708 x 398 mm
[    52.024] (II) RADEON(1): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[    52.024] (II) RADEON(1): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    52.024] (II) RADEON(1): Supported detailed timing:
[    52.024] (II) RADEON(1): clock: 74.2 MHz   Image Size:  708 x 398 mm
[    52.024] (II) RADEON(1): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[    52.024] (II) RADEON(1): v_active: 540  v_sync: 542  v_sync_end 547 v_blanking: 562 v_border: 0
[    52.024] (II) RADEON(1): Supported detailed timing:
[    52.024] (II) RADEON(1): clock: 27.0 MHz   Image Size:  708 x 398 mm
[    52.024] (II) RADEON(1): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[    52.024] (II) RADEON(1): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[    52.024] (II) RADEON(1): Supported detailed timing:
[    52.024] (II) RADEON(1): clock: 148.5 MHz   Image Size:  708 x 398 mm
[    52.024] (II) RADEON(1): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[    52.024] (II) RADEON(1): v_active: 1080  v_sync: 1084  v_sync_end 1089 v_blanking: 1125 v_border: 0
[    52.024] (II) RADEON(1): Supported detailed timing:
[    52.024] (II) RADEON(1): clock: 25.2 MHz   Image Size:  530 x 398 mm
[    52.024] (II) RADEON(1): h_active: 640  h_sync: 648  h_sync_end 744 h_blank_end 800 h_border: 8
[    52.024] (II) RADEON(1): v_active: 480  v_sync: 482  v_sync_end 484 v_blanking: 525 v_border: 8
[    52.024] (II) RADEON(1): Number of EDID sections to follow: 1
[    52.024] (II) RADEON(1): EDID (in hex):
[    52.024] (II) RADEON(1): 	00ffffffffffff0009d10a7845540000
[    52.024] (II) RADEON(1): 	03120103803420782ec5c4a3574a9c23
[    52.024] (II) RADEON(1): 	124f52a56b807100810095008180b300
[    52.024] (II) RADEON(1): 	a940d1000101283c80a070b023403020
[    52.024] (II) RADEON(1): 	360007442100001a000000ff00343138
[    52.024] (II) RADEON(1): 	3037393232534c300a20000000fd0032
[    52.024] (II) RADEON(1): 	551f5e11000a202020202020000000fc
[    52.024] (II) RADEON(1): 	0042656e51204732343030570a20011f
[    52.024] (II) RADEON(1): Printing probed modes for output HDMI-0
[    52.024] (II) RADEON(1): Modeline "1920x1200"x60.0  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync (74.0 kHz)
[    52.024] (II) RADEON(1): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    52.024] (II) RADEON(1): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[    52.024] (II) RADEON(1): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    52.024] (II) RADEON(1): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    52.024] (II) RADEON(1): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    52.024] (II) RADEON(1): Modeline "1280x800"x59.8   83.50  1280 1352 1480 1680  800 803 809 831 +hsync -vsync (49.7 kHz)
[    52.024] (II) RADEON(1): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    52.024] (II) RADEON(1): Modeline "1280x720"x60.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    52.024] (II) RADEON(1): Modeline "1152x720"x60.0   67.28  1152 1208 1328 1504  720 721 724 746 -hsync +vsync (44.7 kHz)
[    52.024] (II) RADEON(1): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    52.024] (II) RADEON(1): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    52.024] (II) RADEON(1): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    52.024] (II) RADEON(1): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    52.024] (II) RADEON(1): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    52.024] (II) RADEON(1): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    52.024] (II) RADEON(1): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    52.024] (II) RADEON(1): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    52.134] (II) RADEON(1): EDID for output DVI-0
[    52.134] (II) RADEON(1): Manufacturer: APP  Model: 921d  Serial#: 50204317
[    52.134] (II) RADEON(1): Year: 2005  Week: 5
[    52.134] (II) RADEON(1): EDID Version: 1.3
[    52.134] (II) RADEON(1): Digital Display Input
[    52.134] (II) RADEON(1): Max Image Size [cm]: horiz.: 43  vert.: 27
[    52.134] (II) RADEON(1): Gamma: 2.20
[    52.134] (II) RADEON(1): DPMS capabilities: Off
[    52.134] (II) RADEON(1): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    52.134] (II) RADEON(1): Default color space is primary color space
[    52.134] (II) RADEON(1): First detailed timing is preferred mode
[    52.134] (II) RADEON(1): redX: 0.640 redY: 0.340   greenX: 0.295 greenY: 0.610
[    52.134] (II) RADEON(1): blueX: 0.145 blueY: 0.070   whiteX: 0.312 whiteY: 0.329
[    52.134] (II) RADEON(1): Manufacturer's mask: 0
[    52.134] (II) RADEON(1): Supported standard timings:
[    52.134] (II) RADEON(1): #0: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[    52.134] (II) RADEON(1): Supported detailed timing:
[    52.134] (II) RADEON(1): clock: 119.0 MHz   Image Size:  433 x 270 mm
[    52.134] (II) RADEON(1): h_active: 1680  h_sync: 1728  h_sync_end 1760 h_blank_end 1840 h_border: 0
[    52.134] (II) RADEON(1): v_active: 1050  v_sync: 1053  v_sync_end 1059 v_blanking: 1080 v_border: 0
[    52.134] (II) RADEON(1): Monitor name: Cinema Displa
[    52.134] (II) RADEON(1): Monitor name: y
[    52.134] (II) RADEON(1): Number of EDID sections to follow: 1
[    52.134] (II) RADEON(1): EDID (in hex):
[    52.134] (II) RADEON(1): 	00ffffffffffff0006101d929d0efe02
[    52.134] (II) RADEON(1): 	050f0103802b1b782ec901a3574b9c25
[    52.134] (II) RADEON(1): 	125054000000b3000101010101010101
[    52.134] (II) RADEON(1): 	0101010101017c2e90a0601a1e403020
[    52.134] (II) RADEON(1): 	3600b10e1100001a000000fc0043696e
[    52.134] (II) RADEON(1): 	656d6120446973706c61000000fc0079
[    52.134] (II) RADEON(1): 	0a000000000000000000000000000000
[    52.134] (II) RADEON(1): 	00000000000000000000000000000163
[    52.134] (II) RADEON(1): Printing probed modes for output DVI-0
[    52.134] (II) RADEON(1): Modeline "1680x1050"x59.9  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    52.134] (II) RADEON(1): Output VGA-0 disconnected
[    52.134] (II) RADEON(1): Output HDMI-0 connected
[    52.134] (II) RADEON(1): Output DVI-0 connected
[    52.134] (II) RADEON(1): Using exact sizes for initial modes
[    52.134] (II) RADEON(1): Output HDMI-0 using initial mode 1680x1050
[    52.134] (II) RADEON(1): Output DVI-0 using initial mode 1680x1050
[    52.134] (II) RADEON(1): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    52.134] (II) RADEON(1): mem size init: gart size :1fdff000 vram size: s:20000000 visible:1f6f6000
[    52.134] (II) RADEON(1): EXA: Driver will allow EXA pixmaps in VRAM
[    52.134] (==) RADEON(1): DPI set to (96, 96)
[    52.134] (II) Loading sub module "fb"
[    52.134] (II) LoadModule: "fb"
[    52.134] (II) Loading /usr/lib64/xorg/modules/libfb.so
[    52.186] (II) Module fb: vendor="X.Org Foundation"
[    52.186] 	compiled for 1.8.0, module version = 1.0.0
[    52.186] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    52.186] (II) Loading sub module "ramdac"
[    52.186] (II) LoadModule: "ramdac"
[    52.186] (II) Module "ramdac" already built-in
[    52.186] (II) Loading sub module "exa"
[    52.186] (II) LoadModule: "exa"
[    52.186] (II) Loading /usr/lib64/xorg/modules/libexa.so
[    52.214] (II) Module exa: vendor="X.Org Foundation"
[    52.214] 	compiled for 1.8.0, module version = 2.5.0
[    52.214] 	ABI class: X.Org Video Driver, version 7.0
[    52.214] (II) UnloadModule: "radeonhd"
[    52.214] (II) UnloadModule: "fbdev"
[    52.214] (II) Unloading /usr/lib64/xorg/modules/drivers/fbdev_drv.so
[    52.214] (II) UnloadModule: "fbdevhw"
[    52.214] (II) Unloading /usr/lib64/xorg/modules/linux/libfbdevhw.so
[    52.214] (II) UnloadModule: "vesa"
[    52.214] (II) Unloading /usr/lib64/xorg/modules/drivers/vesa_drv.so
[    52.214] (--) Depth 24 pixmap format is 32 bpp
[    52.214] (II) RADEON(0): [DRI2] Setup complete
[    52.214] (II) RADEON(0): [DRI2]   DRI driver: r600
[    52.214] (II) RADEON(0): Front buffer size: 7392K
[    52.214] (II) RADEON(0): VRAM usage limit set to 456876K
[    52.215] (==) RADEON(0): Backing store disabled
[    52.215] (II) RADEON(0): Direct rendering enabled
[    52.215] (II) RADEON(0): Setting EXA maxPitchBytes
[    52.215] (II) EXA(0): Driver allocated offscreen pixmaps
[    52.215] (II) EXA(0): Driver registered support for the following operations:
[    52.215] (II)         Solid
[    52.215] (II)         Copy
[    52.215] (II)         Composite (RENDER acceleration)
[    52.215] (II)         UploadToScreen
[    52.215] (II)         DownloadFromScreen
[    52.215] (II) RADEON(0): Acceleration enabled
[    52.215] (==) RADEON(0): DPMS enabled
[    52.215] (==) RADEON(0): Silken mouse enabled
[    52.215] (II) RADEON(0): Set up textured video
[    52.632] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    52.633] (--) RandR disabled
[    52.633] (II) Initializing built-in extension Generic Event Extension
[    52.633] (II) Initializing built-in extension SHAPE
[    52.633] (II) Initializing built-in extension MIT-SHM
[    52.633] (II) Initializing built-in extension XInputExtension
[    52.633] (II) Initializing built-in extension XTEST
[    52.633] (II) Initializing built-in extension BIG-REQUESTS
[    52.633] (II) Initializing built-in extension SYNC
[    52.633] (II) Initializing built-in extension XKEYBOARD
[    52.633] (II) Initializing built-in extension XC-MISC
[    52.633] (II) Initializing built-in extension SECURITY
[    52.633] (II) Initializing built-in extension XINERAMA
[    52.633] (II) Initializing built-in extension XFIXES
[    52.633] (II) Initializing built-in extension RENDER
[    52.633] (II) Initializing built-in extension RANDR
[    52.633] (II) Initializing built-in extension COMPOSITE
[    52.633] (II) Initializing built-in extension DAMAGE
[    52.762] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    52.762] (II) AIGLX: enabled GLX_INTEL_swap_event
[    52.762] (II) AIGLX: enabled GLX_SGI_make_current_read
[    52.762] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    52.763] (II) AIGLX: Loaded and initialized /usr/lib64/dri/r600_dri.so
[    52.763] (II) GLX: Initialized DRI2 GL provider for screen 0
[    52.763] (II) RADEON(0): Setting screen physical size to 444 x 277
[    53.040] (II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-8AA988DD479FAABEC4FC3CCCF4CC29B4948840B4.xkm
[    53.075] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    53.075] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    53.075] (**) Power Button: Applying InputClass "LocalKeyboard"
[    53.075] (II) LoadModule: "evdev"
[    53.075] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[    53.075] (II) Module evdev: vendor="X.Org Foundation"
[    53.075] 	compiled for 1.8.0, module version = 2.4.0
[    53.075] 	Module class: X.Org XInput Driver
[    53.075] 	ABI class: X.Org XInput driver, version 9.0
[    53.075] (**) Power Button: always reports core events
[    53.075] (**) Power Button: Device: "/dev/input/event1"
[    53.092] (II) Power Button: Found keys
[    53.092] (II) Power Button: Configuring as keyboard
[    53.092] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    53.092] (**) Option "xkb_rules" "evdev"
[    53.092] (**) Option "xkb_model" "evdev"
[    53.092] (**) Option "xkb_layout" "us"
[    53.092] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    53.094] (II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-98613433316DBD58F9AD58929ECF05A3E1AB0E74.xkm
[    53.106] (II) config/udev: Adding input device Power Button (/dev/input/event0)
[    53.106] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    53.106] (**) Power Button: Applying InputClass "LocalKeyboard"
[    53.106] (**) Power Button: always reports core events
[    53.106] (**) Power Button: Device: "/dev/input/event0"
[    53.128] (II) Power Button: Found keys
[    53.128] (II) Power Button: Configuring as keyboard
[    53.128] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    53.128] (**) Option "xkb_rules" "evdev"
[    53.128] (**) Option "xkb_model" "evdev"
[    53.128] (**) Option "xkb_layout" "us"
[    53.128] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    53.130] (II) config/udev: Adding input device HID 046a:0021 (/dev/input/event2)
[    53.130] (**) HID 046a:0021: Applying InputClass "evdev keyboard catchall"
[    53.130] (**) HID 046a:0021: Applying InputClass "LocalKeyboard"
[    53.130] (**) HID 046a:0021: always reports core events
[    53.130] (**) HID 046a:0021: Device: "/dev/input/event2"
[    53.160] (II) HID 046a:0021: Found keys
[    53.160] (II) HID 046a:0021: Configuring as keyboard
[    53.160] (II) XINPUT: Adding extended input device "HID 046a:0021" (type: KEYBOARD)
[    53.160] (**) Option "xkb_rules" "evdev"
[    53.160] (**) Option "xkb_model" "evdev"
[    53.160] (**) Option "xkb_layout" "us"
[    53.160] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    53.160] (II) config/udev: Adding input device HID 046a:0021 (/dev/input/event3)
[    53.160] (**) HID 046a:0021: Applying InputClass "evdev keyboard catchall"
[    53.160] (**) HID 046a:0021: Applying InputClass "LocalKeyboard"
[    53.160] (**) HID 046a:0021: always reports core events
[    53.160] (**) HID 046a:0021: Device: "/dev/input/event3"
[    53.204] (II) HID 046a:0021: Found 1 mouse buttons
[    53.204] (II) HID 046a:0021: Found scroll wheel(s)
[    53.204] (II) HID 046a:0021: Found relative axes
[    53.204] (II) HID 046a:0021: Found absolute axes
[    53.204] (II) HID 046a:0021: Found keys
[    53.204] (II) HID 046a:0021: Configuring as mouse
[    53.204] (II) HID 046a:0021: Configuring as keyboard
[    53.204] (**) HID 046a:0021: YAxisMapping: buttons 4 and 5
[    53.204] (**) HID 046a:0021: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    53.204] (II) XINPUT: Adding extended input device "HID 046a:0021" (type: KEYBOARD)
[    53.204] (**) Option "xkb_rules" "evdev"
[    53.204] (**) Option "xkb_model" "evdev"
[    53.204] (**) Option "xkb_layout" "us"
[    53.204] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    53.204] (EE) HID 046a:0021: failed to initialize for relative axes.
[    53.204] (II) HID 046a:0021: initialized for absolute axes.
[    53.207] (II) config/udev: Adding input device Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) (/dev/input/event4)
[    53.207] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Applying InputClass "evdev pointer catchall"
[    53.207] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): always reports core events
[    53.207] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Device: "/dev/input/event4"
[    53.236] (II) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Found 9 mouse buttons
[    53.236] (II) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Found scroll wheel(s)
[    53.236] (II) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Found relative axes
[    53.236] (II) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Found x and y relative axes
[    53.236] (II) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): Configuring as mouse
[    53.236] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): YAxisMapping: buttons 4 and 5
[    53.236] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    53.236] (II) XINPUT: Adding extended input device "Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)" (type: MOUSE)
[    53.236] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): (accel) keeping acceleration scheme 1
[    53.236] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): (accel) acceleration profile 0
[    53.236] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): (accel) acceleration factor: 2.000
[    53.236] (**) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): (accel) acceleration threshold: 4
[    53.236] (II) Microsoft Microsoft 5-Button Mouse with IntelliEye(TM): initialized for relative axes.
[    53.236] (II) config/udev: Adding input device Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) (/dev/input/mouse0)
[    53.236] (EE) No input driver/identifier specified (ignoring)
[    56.867] (II) RADEON(0): EDID vendor "APP", prod id 37405
[    56.867] (II) RADEON(0): Printing DDC gathered Modelines:
[    56.867] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    56.922] (II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-A9ACCDF38EB1446AC7992CE0B930842F0AD908B1.xkm
[  4220.395] (II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-6C46FE9CC2B823962EBAEBC177368C0D9EFE00CD.xkm
[  4223.125] (II) RADEON(0): EDID vendor "APP", prod id 37405
[  4223.125] (II) RADEON(0): Printing DDC gathered Modelines:
[  4223.125] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[  4223.361] (II) RADEON(0): EDID vendor "APP", prod id 37405
[  4223.361] (II) RADEON(0): Printing DDC gathered Modelines:
[  4223.361] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[  4223.362] (II) RADEON(0): Allocate new frame buffer 3360x1056 stride 3392
[  4223.362] (II) RADEON(0): VRAM usage limit set to 450936K
[  4223.597] (II) RADEON(0): EDID vendor "APP", prod id 37405
[  4223.597] (II) RADEON(0): Printing DDC gathered Modelines:
[  4223.597] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[  4223.598] (II) RADEON(0): Allocate new frame buffer 3600x1200 stride 3648
[  4223.598] (II) RADEON(0): VRAM usage limit set to 448138K
[  5886.596] (II) AIGLX: Suspending AIGLX clients for VT switch
[  5893.286] (II) Open ACPI successful (/var/run/acpid.socket)
[  5893.286] (II) AIGLX: Resuming AIGLX clients after VT switch
[  5893.521] (II) RADEON(0): EDID vendor "APP", prod id 37405
[  5893.521] (II) RADEON(0): Printing DDC gathered Modelines:
[  5893.521] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)

-Andi

