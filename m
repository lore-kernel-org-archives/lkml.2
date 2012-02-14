Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab2BNC3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:29:51 -0500
Received: from seven.medozas.de ([188.40.89.202]:38761 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2BNC3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:29:47 -0500
Date: Tue, 14 Feb 2012 03:29:43 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alex Deucher <alexander.deucher@amd.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: drm/radeon: white screen after X does modeswitch from KMS con
Message-ID: <alpine.LNX.2.01.1202140305030.23763@frira.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


the SONY PCG U3 device has a

00:0c.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon 
Mobility M6 LY [1002:4c59]

graphics card. With linux 3.1.10, X.org server 7.6_1.10.4 and
xf86-video-ati-6.14.2, switching from KMS'd console to X on tty7
yields a white screen that also stays when attempting to back to
tty1.

I have to boot with nomodeset to get a usable Xorg picture.
Is it just that radeon_drv does not work together with KMS?


= log when starting X from a KMS console =
[   837.009] 
X.Org X Server 1.10.4
Release Date: 2011-08-19
[   837.012] X Protocol Version 11, Revision 0
[   837.013] Build Operating System: openSUSE SUSE LINUX [12.1]
[   837.014] Current Operating System: Linux takeshi 3.1.10-jng3-desktop #1 SMP PREEMPT Sun Jan 22 13:04:41 UTC 2012 (479c31a) i586
[   837.016] Kernel command line: root=/dev/mapper/root quiet 3
[   837.018] Build Date: 10 November 2011  03:34:02PM
[   837.019]  
[   837.020] Current version of pixman: 0.24.0
[   837.021] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[   837.024] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[   837.031] (==) Log file: "/var/log/Xorg.0.log", Time: Tue Feb 14 04:18:10 2012
[   837.035] (==) Using config directory: "/etc/X11/xorg.conf.d"
[   837.037] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[   837.042] (==) No Layout section.  Using the first Screen section.
[   837.042] (==) No screen section available. Using defaults.
[   837.042] (**) |-->Screen "Default Screen Section" (0)
[   837.042] (**) |   |-->Monitor "<default monitor>"
[   837.044] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[   837.044] (==) Automatically adding devices
[   837.044] (==) Automatically enabling devices
[   837.046] (==) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/URW/,
	/usr/share/fonts/cyrillic:unscaled,
	/usr/share/fonts/truetype/,
	built-ins
[   837.046] (==) ModulePath set to "/usr/lib/xorg/modules/updates,/usr/lib/xorg/modules"
[   837.046] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[   837.046] (II) Loader magic: 0x8233d40
[   837.046] (II) Module ABI versions:
[   837.046] 	X.Org ANSI C Emulation: 0.4
[   837.046] 	X.Org Video Driver: 10.0
[   837.047] 	X.Org XInput driver : 12.2
[   837.047] 	X.Org Server Extension : 5.0
[   837.054] (--) PCI:*(0:0:12:0) 1002:4c59:104d:810f rev 0, Mem @ 0xf0000000/134217728, 0xe8110000/65536, I/O @ 0x00002000/256, BIOS @ 0x????????/131072
[   837.060] (II) Open ACPI successful (/var/run/acpid.socket)
[   837.061] (II) LoadModule: "extmod"
[   837.069] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[   837.070] (II) Module extmod: vendor="X.Org Foundation"
[   837.071] 	compiled for 1.10.4, module version = 1.0.0
[   837.071] 	Module class: X.Org Server Extension
[   837.071] 	ABI class: X.Org Server Extension, version 5.0
[   837.071] (II) Loading extension MIT-SCREEN-SAVER
[   837.071] (II) Loading extension XFree86-VidModeExtension
[   837.071] (II) Loading extension XFree86-DGA
[   837.071] (II) Loading extension DPMS
[   837.071] (II) Loading extension XVideo
[   837.071] (II) Loading extension XVideo-MotionCompensation
[   837.071] (II) Loading extension X-Resource
[   837.072] (II) LoadModule: "dbe"
[   837.075] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[   837.077] (II) Module dbe: vendor="X.Org Foundation"
[   837.077] 	compiled for 1.10.4, module version = 1.0.0
[   837.077] 	Module class: X.Org Server Extension
[   837.077] 	ABI class: X.Org Server Extension, version 5.0
[   837.077] (II) Loading extension DOUBLE-BUFFER
[   837.077] (II) LoadModule: "glx"
[   837.081] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[   837.083] (II) Module glx: vendor="X.Org Foundation"
[   837.083] 	compiled for 1.10.4, module version = 1.0.0
[   837.083] 	ABI class: X.Org Server Extension, version 5.0
[   837.083] (==) AIGLX enabled
[   837.083] (II) Loading extension GLX
[   837.084] (II) LoadModule: "record"
[   837.088] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[   837.089] (II) Module record: vendor="X.Org Foundation"
[   837.089] 	compiled for 1.10.4, module version = 1.13.0
[   837.089] 	Module class: X.Org Server Extension
[   837.089] 	ABI class: X.Org Server Extension, version 5.0
[   837.089] (II) Loading extension RECORD
[   837.089] (II) LoadModule: "dri"
[   837.094] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[   837.095] (II) Module dri: vendor="X.Org Foundation"
[   837.096] 	compiled for 1.10.4, module version = 1.0.0
[   837.096] 	ABI class: X.Org Server Extension, version 5.0
[   837.096] (II) Loading extension XFree86-DRI
[   837.096] (II) LoadModule: "dri2"
[   837.100] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[   837.101] (II) Module dri2: vendor="X.Org Foundation"
[   837.102] 	compiled for 1.10.4, module version = 1.2.0
[   837.102] 	ABI class: X.Org Server Extension, version 5.0
[   837.102] (II) Loading extension DRI2
[   837.102] (==) Matched fglrx as autoconfigured driver 0
[   837.102] (==) Matched radeonhd as autoconfigured driver 1
[   837.102] (==) Matched ati as autoconfigured driver 2
[   837.102] (==) Matched fbdev as autoconfigured driver 3
[   837.102] (==) Matched vesa as autoconfigured driver 4
[   837.103] (==) Assigned the driver to the xf86ConfigLayout
[   837.103] (II) LoadModule: "fglrx"
[   837.110] (WW) Warning, couldn't open module fglrx
[   837.111] (II) UnloadModule: "fglrx"
[   837.111] (II) Unloading fglrx
[   837.111] (EE) Failed to load module "fglrx" (module does not exist, 0)
[   837.112] (II) LoadModule: "radeonhd"
[   837.120] (WW) Warning, couldn't open module radeonhd
[   837.120] (II) UnloadModule: "radeonhd"
[   837.120] (II) Unloading radeonhd
[   837.120] (EE) Failed to load module "radeonhd" (module does not exist, 0)
[   837.122] (II) LoadModule: "ati"
[   837.124] (II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
[   837.125] (II) Module ati: vendor="X.Org Foundation"
[   837.125] 	compiled for 1.10.4, module version = 6.14.2
[   837.125] 	Module class: X.Org Video Driver
[   837.126] 	ABI class: X.Org Video Driver, version 10.0
[   837.126] (II) LoadModule: "radeon"
[   837.129] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[   837.133] (II) Module radeon: vendor="X.Org Foundation"
[   837.133] 	compiled for 1.10.4, module version = 6.14.2
[   837.133] 	Module class: X.Org Video Driver
[   837.133] 	ABI class: X.Org Video Driver, version 10.0
[   837.133] (II) LoadModule: "fbdev"
[   837.136] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[   837.137] (II) Module fbdev: vendor="X.Org Foundation"
[   837.138] 	compiled for 1.10.4, module version = 0.4.2
[   837.138] 	ABI class: X.Org Video Driver, version 10.0
[   837.138] (II) LoadModule: "vesa"
[   837.141] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[   837.142] (II) Module vesa: vendor="X.Org Foundation"
[   837.143] 	compiled for 1.10.4, module version = 2.3.0
[   837.143] 	Module class: X.Org Video Driver
[   837.143] 	ABI class: X.Org Video Driver, version 10.0
[   837.143] (II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI FireMV 2400 3155 (PCI),
	ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon IGP320M (U1) 4336,
	ATI Radeon IGP330M/340M/350M (U2) 4337,
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
	ATI Mobility RADEON HD 4870, ATI Radeon 4800 Series,
	ATI Radeon 4800 Series, ATI FirePro M7750, ATI M98, ATI M98, ATI M98,
	ATI Mobility Radeon HD 4650, ATI Radeon RV730 (AGP),
	ATI Mobility Radeon HD 4670, ATI FirePro M5750,
	ATI Mobility Radeon HD 4670, ATI Radeon RV730 (AGP),
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
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon RV710,
	ATI Radeon HD 4350, ATI Mobility Radeon 4300 Series,
	ATI Mobility Radeon 4500 Series, ATI Mobility Radeon 4500 Series,
	ATI FirePro RG220, ATI Mobility Radeon 4330, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon HD 3470,
	ATI Mobility Radeon HD 3430, ATI Mobility Radeon HD 3400 Series,
	ATI Radeon HD 3450, ATI Radeon HD 3450, ATI Radeon HD 3430,
	ATI Radeon HD 3450, ATI FirePro V3700, ATI FireMV 2450,
	ATI FireMV 2260, ATI FireMV 2260, ATI Radeon HD 3600 Series,
	ATI Radeon HD 3650 AGP, ATI Radeon HD 3600 PRO,
	ATI Radeon HD 3600 XT, ATI Radeon HD 3600 PRO,
	ATI Mobility Radeon HD 3650, ATI Mobility Radeon HD 3670,
	ATI Mobility FireGL V5700, ATI Mobility FireGL V5725,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3300 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3000 Graphics, ATI Radeon HD 4200, ATI Radeon 4100,
	ATI Mobility Radeon HD 4200, ATI Mobility Radeon 4100,
	ATI Radeon HD 4290, ATI Radeon HD 4250, AMD Radeon HD 6310 Graphics,
	AMD Radeon HD 6310 Graphics, AMD Radeon HD 6250 Graphics,
	AMD Radeon HD 6250 Graphics, AMD Radeon HD 6300 Series Graphics,
	AMD Radeon HD 6200 Series Graphics, CYPRESS,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
	AMD Firestream 9350, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5900 Series,
	ATI Radeon HD 5900 Series, ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 6700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 6700 Series,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon HD 5570,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,
	ATI Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon Graphics,
	ATI Mobility Radeon Graphics, CEDAR,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI FirePro 2270, CEDAR,
	ATI Radeon HD 5450, CEDAR, CAYMAN, CAYMAN, CAYMAN, CAYMAN, CAYMAN,
	CAYMAN, CAYMAN, CAYMAN, CAYMAN, CAYMAN, AMD Radeon HD 6900 Series,
	AMD Radeon HD 6900 Series, CAYMAN, CAYMAN, CAYMAN,
	AMD Radeon HD 6900M Series, Mobility Radeon HD 6000 Series, BARTS,
	BARTS, Mobility Radeon HD 6000 Series,
	Mobility Radeon HD 6000 Series, BARTS, BARTS, BARTS, BARTS,
	AMD Radeon HD 6800 Series, AMD Radeon HD 6800 Series,
	AMD Radeon HD 6700 Series, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS,
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS
[   837.165] (II) FBDEV: driver for framebuffer: fbdev
[   837.166] (II) VESA: driver for VESA chipsets: vesa
[   837.166] (--) using VT number 3

[   837.184] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[   837.189] (II) [KMS] Kernel modesetting enabled.
[   837.193] (WW) Falling back to old probe method for fbdev
[   837.193] (II) Loading sub module "fbdevhw"
[   837.193] (II) LoadModule: "fbdevhw"
[   837.204] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[   837.209] (II) Module fbdevhw: vendor="X.Org Foundation"
[   837.209] 	compiled for 1.10.4, module version = 0.0.2
[   837.210] 	ABI class: X.Org Video Driver, version 10.0
[   837.210] (WW) Falling back to old probe method for vesa
[   837.215] (II) RADEON(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[   837.215] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[   837.216] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[   837.216] (==) RADEON(0): Default visual is TrueColor
[   837.216] (==) RADEON(0): RGB weight 888
[   837.216] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[   837.216] (--) RADEON(0): Chipset: "ATI Radeon Mobility M6 LY (AGP)" (ChipID = 0x4c59)
[   837.217] (II) RADEON(0): PCI card detected
[   837.217] drmOpenDevice: node name is /dev/dri/card0
[   837.223] drmOpenDevice: open result is 10, (OK)
[   837.224] drmOpenByBusid: Searching for BusID pci:0000:00:0c.0
[   837.224] drmOpenDevice: node name is /dev/dri/card0
[   837.225] drmOpenDevice: open result is 10, (OK)
[   837.225] drmOpenByBusid: drmOpenMinor returns 10
[   837.225] drmOpenByBusid: drmGetBusid reports pci:0000:00:0c.0
[   837.232] (II) Loading sub module "exa"
[   837.232] (II) LoadModule: "exa"
[   837.238] (II) Loading /usr/lib/xorg/modules/libexa.so
[   837.239] (II) Module exa: vendor="X.Org Foundation"
[   837.239] 	compiled for 1.10.4, module version = 2.5.0
[   837.239] 	ABI class: X.Org Video Driver, version 10.0
[   837.243] (II) RADEON(0): KMS Color Tiling: disabled
[   837.243] (II) RADEON(0): KMS Pageflipping: enabled
[   837.243] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[   837.300] (II) RADEON(0): Output VGA-0 has no monitor section
[   837.301] (II) RADEON(0): Output LVDS has no monitor section
[   837.308] (II) RADEON(0): Output S-video has no monitor section
[   837.348] (II) RADEON(0): EDID for output VGA-0
[   837.349] (II) RADEON(0): EDID for output LVDS
[   837.350] (II) RADEON(0): Printing probed modes for output LVDS
[   837.350] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1040 1176 1344  768 770 776 806 (48.4 kHz)
[   837.350] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
[   837.350] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1056  480 483 493 500 -hsync +vsync (29.8 kHz)
[   837.350] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 896  480 483 493 500 -hsync +vsync (29.9 kHz)
[   837.350] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
[   837.357] (II) RADEON(0): EDID for output S-video
[   837.357] (II) RADEON(0): Output VGA-0 disconnected
[   837.357] (II) RADEON(0): Output LVDS connected
[   837.357] (II) RADEON(0): Output S-video disconnected
[   837.359] (II) RADEON(0): Using exact sizes for initial modes
[   837.359] (II) RADEON(0): Output LVDS using initial mode 1024x768
[   837.359] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[   837.360] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:800000 visible:700000
[   837.360] (II) RADEON(0): EXA: Driver will not allow EXA pixmaps in VRAM
[   837.360] (==) RADEON(0): DPI set to (96, 96)
[   837.360] (II) Loading sub module "fb"
[   837.360] (II) LoadModule: "fb"
[   837.365] (II) Loading /usr/lib/xorg/modules/libfb.so
[   837.367] (II) Module fb: vendor="X.Org Foundation"
[   837.367] 	compiled for 1.10.4, module version = 1.0.0
[   837.367] 	ABI class: X.Org ANSI C Emulation, version 0.4
[   837.367] (II) Loading sub module "ramdac"
[   837.367] (II) LoadModule: "ramdac"
[   837.368] (II) Module "ramdac" already built-in
[   837.368] (II) UnloadModule: "fbdev"
[   837.368] (II) Unloading fbdev
[   837.368] (II) UnloadModule: "fbdevhw"
[   837.368] (II) Unloading fbdevhw
[   837.368] (II) UnloadModule: "vesa"
[   837.368] (II) Unloading vesa
[   837.368] (--) Depth 24 pixmap format is 32 bpp
[   837.370] (II) RADEON(0): [DRI2] Setup complete
[   837.370] (II) RADEON(0): [DRI2]   DRI driver: radeon
[   837.372] (II) RADEON(0): Front buffer size: 3072K
[   837.372] (II) RADEON(0): VRAM usage limit set to 3686K
[   837.374] (==) RADEON(0): Backing store disabled
[   837.374] (II) RADEON(0): Direct rendering enabled
[   837.374] (II) RADEON(0): Render acceleration enabled for R100 type cards.
[   837.374] (II) RADEON(0): Setting EXA maxPitchBytes
[   837.375] (II) EXA(0): Driver allocated offscreen pixmaps
[   837.375] (II) EXA(0): Driver registered support for the following operations:
[   837.375] (II)         Solid
[   837.375] (II)         Copy
[   837.375] (II)         Composite (RENDER acceleration)
[   837.375] (II)         UploadToScreen
[   837.375] (II)         DownloadFromScreen
[   837.375] (II) RADEON(0): Acceleration enabled
[   837.376] (==) RADEON(0): DPMS enabled
[   837.376] (==) RADEON(0): Silken mouse enabled
[   837.377] (II) RADEON(0): Set up textured video
[   837.377] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[   837.382] (--) RandR disabled
[   837.382] (II) Initializing built-in extension Generic Event Extension
[   837.382] (II) Initializing built-in extension SHAPE
[   837.382] (II) Initializing built-in extension MIT-SHM
[   837.382] (II) Initializing built-in extension XInputExtension
[   837.382] (II) Initializing built-in extension XTEST
[   837.382] (II) Initializing built-in extension BIG-REQUESTS
[   837.382] (II) Initializing built-in extension SYNC
[   837.383] (II) Initializing built-in extension XKEYBOARD
[   837.383] (II) Initializing built-in extension XC-MISC
[   837.383] (II) Initializing built-in extension SECURITY
[   837.383] (II) Initializing built-in extension XINERAMA
[   837.383] (II) Initializing built-in extension XFIXES
[   837.383] (II) Initializing built-in extension RENDER
[   837.383] (II) Initializing built-in extension RANDR
[   837.383] (II) Initializing built-in extension COMPOSITE
[   837.383] (II) Initializing built-in extension DAMAGE
[   837.452] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[   837.452] (II) AIGLX: enabled GLX_INTEL_swap_event
[   837.452] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[   837.452] (II) AIGLX: enabled GLX_SGI_make_current_read
[   837.453] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[   837.455] (II) AIGLX: Loaded and initialized /usr/lib/dri/radeon_dri.so
[   837.455] (II) GLX: Initialized DRI2 GL provider for screen 0
[   837.524] (II) RADEON(0): Setting screen physical size to 270 x 203
[   837.997] (II) config/udev: Adding input device Sony Vaio Keys (/dev/input/event4)
[   837.998] (**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
[   837.998] (**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
[   837.998] (**) Sony Vaio Keys: Applying InputClass "LocalKeyboard"
[   837.998] (II) LoadModule: "evdev"
[   838.000] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   838.002] (II) Module evdev: vendor="X.Org Foundation"
[   838.002] 	compiled for 1.10.4, module version = 2.6.0
[   838.002] 	Module class: X.Org XInput Driver
[   838.002] 	ABI class: X.Org XInput driver, version 12.2
[   838.003] (II) Using input driver 'evdev' for 'Sony Vaio Keys'
[   838.003] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   838.003] (**) Sony Vaio Keys: always reports core events
[   838.003] (**) Sony Vaio Keys: Device: "/dev/input/event4"
[   838.004] (--) Sony Vaio Keys: Found keys
[   838.004] (II) Sony Vaio Keys: Configuring as keyboard
[   838.005] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/SNY5001:00/input/input4/event4"
[   838.005] (II) XINPUT: Adding extended input device "Sony Vaio Keys" (type: KEYBOARD)
[   838.005] (**) Option "xkb_rules" "evdev"
[   838.005] (**) Option "xkb_model" "evdev"
[   838.005] (**) Option "xkb_layout" "us"
[   838.209] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[   838.209] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[   838.210] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[   838.210] (**) AT Translated Set 2 keyboard: Applying InputClass "LocalKeyboard"
[   838.210] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[   838.210] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   838.210] (**) AT Translated Set 2 keyboard: always reports core events
[   838.211] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[   838.211] (--) AT Translated Set 2 keyboard: Found keys
[   838.211] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[   838.212] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[   838.212] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[   838.212] (**) Option "xkb_rules" "evdev"
[   838.212] (**) Option "xkb_model" "evdev"
[   838.212] (**) Option "xkb_layout" "us"
[   838.219] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event1)
[   838.219] (**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
[   838.219] (**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
[   838.220] (**) PS/2 Generic Mouse: Applying InputClass "PS/2 Generic Mouse"
[   838.220] (II) Using input driver 'evdev' for 'PS/2 Generic Mouse'
[   838.220] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   838.220] (**) PS/2 Generic Mouse: always reports core events
[   838.221] (**) PS/2 Generic Mouse: Device: "/dev/input/event1"
[   838.221] (--) PS/2 Generic Mouse: Found 3 mouse buttons
[   838.222] (--) PS/2 Generic Mouse: Found relative axes
[   838.222] (--) PS/2 Generic Mouse: Found x and y relative axes
[   838.222] (II) PS/2 Generic Mouse: Configuring as mouse
[   838.222] (**) Option "Emulate3Buttons" "on"
[   838.222] (**) Option "EmulateWheel" "on"
[   838.222] (**) Option "EmulateWheelButton" "2"
[   838.222] (**) Option "EmulateWheelTimeout" "200"
[   838.226] (**) Option "YAxisMapping" "4 5"
[   838.226] (**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
[   838.226] (**) Option "XAxisMapping" "6 7"
[   838.227] (**) PS/2 Generic Mouse: XAxisMapping: buttons 6 and 7
[   838.227] (**) PS/2 Generic Mouse: EmulateWheelButton: 2, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[   838.227] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input1/event1"
[   838.227] (II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
[   838.229] (II) PS/2 Generic Mouse: initialized for relative axes.
[   838.239] (**) PS/2 Generic Mouse: (accel) keeping acceleration scheme 1
[   838.239] (**) PS/2 Generic Mouse: (accel) acceleration profile 0
[   838.240] (**) PS/2 Generic Mouse: (accel) acceleration factor: 2.000
[   838.240] (**) PS/2 Generic Mouse: (accel) acceleration threshold: 4
[   838.244] (II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
[   838.245] (**) PS/2 Generic Mouse: Applying InputClass "PS/2 Generic Mouse"
[   838.245] (II) Using input driver 'evdev' for 'PS/2 Generic Mouse'
[   838.245] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   838.246] (**) PS/2 Generic Mouse: always reports core events
[   838.246] (**) PS/2 Generic Mouse: Device: "/dev/input/mouse0"
[   838.247] (EE) ioctl EVIOCGNAME failed: Inappropriate ioctl for device
[   838.252] (EE) PreInit returned 8 for "PS/2 Generic Mouse"
[   838.253] (II) UnloadModule: "evdev"
[   838.254] (II) Unloading evdev
[   838.269] (II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/event2)
[   838.269] (II) No input driver/identifier specified (ignoring)
[   838.272] (II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/mouse1)
[   838.272] (II) No input driver/identifier specified (ignoring)
[   838.275] (II) config/udev: Adding input device Sony Vaio Keys (/dev/input/event3)
[   838.276] (**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
[   838.276] (**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
[   838.276] (**) Sony Vaio Keys: Applying InputClass "LocalKeyboard"
[   838.276] (II) Using input driver 'evdev' for 'Sony Vaio Keys'
[   838.276] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   838.277] (**) Sony Vaio Keys: always reports core events
[   838.277] (**) Sony Vaio Keys: Device: "/dev/input/event3"
[   838.278] (--) Sony Vaio Keys: Found keys
[   838.278] (II) Sony Vaio Keys: Configuring as keyboard
[   838.278] (**) Option "config_info" "udev:/sys/devices/platform/sonypi/input/input3/event3"
[   838.278] (II) XINPUT: Adding extended input device "Sony Vaio Keys" (type: KEYBOARD)
[   838.278] (**) Option "xkb_rules" "evdev"
[   838.279] (**) Option "xkb_model" "evdev"
[   838.279] (**) Option "xkb_layout" "us"
[   838.291] (II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/event5)
[   838.291] (II) No input driver/identifier specified (ignoring)
[   838.294] (II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/mouse2)
[   838.294] (II) No input driver/identifier specified (ignoring)
