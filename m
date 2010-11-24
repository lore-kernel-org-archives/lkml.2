Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0KXBqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:46:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0KXBqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:46:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [Regression, post-2.6.37-rc2] Unable to start KDE with 2.6.37-rc3 on Acer Ferrari One
Date: Wed, 24 Nov 2010 02:45:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
References: <201011240122.33174.rjw@sisk.pl> <201011240157.00726.rjw@sisk.pl> <AANLkTinRvXC9qDi9rkg1OeQ9FXrBwVJU0Y=9bUwrv8T4@mail.gmail.com>
In-Reply-To: <AANLkTinRvXC9qDi9rkg1OeQ9FXrBwVJU0Y=9bUwrv8T4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_T5G7MuddZyFUcQQ"
Message-Id: <201011240245.55786.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_T5G7MuddZyFUcQQ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Wednesday, November 24, 2010, Alex Deucher wrote:
> 2010/11/23 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday, November 24, 2010, Rafael J. Wysocki wrote:
> >> Hi,
> >>
> >> I cannot start KDE with the 2.6.37-rc3 kernel.  The X server and display
> >> manager start normally, but when I attempt to log into KDE, it attempts to
> >> start, but then the X apparently crashes and this appears in the dmesg output:
> >>
> >> [   24.342287] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
> >> [   24.342298] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
> >> [   24.342304] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> >> [   24.694106] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> >> [   93.938946] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
> >> [   93.938956] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
> >> [   93.938962] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> >> [   94.278050] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> >> [  114.898043] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
> >> [  114.898053] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
> >> [  114.898058] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> >> [  115.266113] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> >> [  129.722472] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> >> [  142.984314] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
> >> [  142.984324] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
> >> [  142.984330] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> >> [  143.370083] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> >>
> >> This doesn't happen with 2.6.37-rc2.
> >
> > Reverting the following commit:
> >
> > commit 16790569eddf4d406a16a65f4750f405fa669c52
> > Author: Alex Deucher <alexdeucher@gmail.com>
> > Date:   Sun Nov 14 20:24:35 2010 -0500
> >
> >    drm/radeon/kms: fix and unify tiled buffer alignment checking for r6xx/7xx
> >
> > fixes the issue for me (so everyone involved is already in the Cc list ;-)).
> >
> 
> Are you sure you've got the right commit?

Well, as I said, I reverted that particular commit and things started to work.

> That shouldn't change the calculation that's failing at all.  I'd guess it's
> probably one of these:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d33ef52d9db8a36900dd53f2e32db9a521ace259
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f30df2fad0c901e74ac9a52a488a54c69a373a41

I don't know.  Perhaps there are some interactions between the two and the
reverted one.  I can try reverting these tomorrow if you want me to.

> Can you attach your xorg log as well?

Sure, attached (the working case).

Thanks,
Rafael

--Boundary-00=_T5G7MuddZyFUcQQ
Content-Type: text/x-log;
  charset="UTF-8";
  name="Xorg.0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Xorg.0.log"

[    11.926] 
X.Org X Server 1.8.0
Release Date: 2010-04-02
[    11.927] X Protocol Version 11, Revision 0
[    11.927] Build Operating System: openSUSE SUSE LINUX
[    11.927] Current Operating System: Linux ferrari 2.6.37-rc2-rjw+ #162 SMP PREEMPT Tue Nov 16 23:33:09 CET 2010 x86_64
[    11.927] Kernel command line: root=/dev/sda3 resume=/dev/sda2
[    11.927] Build Date: 19 August 2010  03:34:22PM
[    11.927]  
[    11.927] Current version of pixman: 0.18.0
[    11.927] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    11.927] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    11.928] (==) Log file: "/var/log/Xorg.0.log", Time: Wed Nov 24 01:44:11 2010
[    11.928] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    11.929] (==) No Layout section.  Using the first Screen section.
[    11.929] (**) |-->Screen "Default Screen" (0)
[    11.929] (**) |   |-->Monitor "Default Monitor"
[    11.929] (**) |   |-->Device "Default Device"
[    11.929] (==) Automatically adding devices
[    11.929] (==) Automatically enabling devices
[    11.930] (WW) The directory "/usr/share/fonts/TTF/" does not exist.
[    11.930] 	Entry deleted from font path.
[    11.930] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[    11.930] 	Entry deleted from font path.
[    11.930] (WW) The directory "/usr/share/fonts/misc/sgi" does not exist.
[    11.930] 	Entry deleted from font path.
[    11.930] (==) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/URW/,
	/usr/share/fonts/cyrillic:unscaled,
	/usr/share/fonts/truetype/
[    11.930] (==) ModulePath set to "/usr/lib64/xorg/modules/updates,/usr/lib64/xorg/modules"
[    11.930] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    11.930] (II) Loader magic: 0x7d5ba0
[    11.930] (II) Module ABI versions:
[    11.930] 	X.Org ANSI C Emulation: 0.4
[    11.930] 	X.Org Video Driver: 7.0
[    11.930] 	X.Org XInput driver : 9.0
[    11.930] 	X.Org Server Extension : 3.0
[    11.941] (--) PCI:*(0:1:5:0) 1002:9612:1025:029e ATI Technologies Inc RS780M/RS780MN [Radeon HD 3200 Graphics] rev 0, Mem @ 0xa0000000/268435456, 0x9fdf0000/65536, 0x9fe00000/1048576, I/O @ 0x00009000/256
[    11.942] (II) Open ACPI successful (/var/run/acpid.socket)
[    11.942] (II) LoadModule: "extmod"
[    11.964] (II) Loading /usr/lib64/xorg/modules/extensions/libextmod.so
[    11.964] (II) Module extmod: vendor="X.Org Foundation"
[    11.964] 	compiled for 1.8.0, module version = 1.0.0
[    11.964] 	Module class: X.Org Server Extension
[    11.964] 	ABI class: X.Org Server Extension, version 3.0
[    11.964] (II) Loading extension MIT-SCREEN-SAVER
[    11.964] (II) Loading extension XFree86-VidModeExtension
[    11.964] (II) Loading extension XFree86-DGA
[    11.964] (II) Loading extension DPMS
[    11.964] (II) Loading extension XVideo
[    11.964] (II) Loading extension XVideo-MotionCompensation
[    11.964] (II) Loading extension X-Resource
[    11.964] (II) LoadModule: "dbe"
[    11.965] (II) Loading /usr/lib64/xorg/modules/extensions/libdbe.so
[    11.965] (II) Module dbe: vendor="X.Org Foundation"
[    11.965] 	compiled for 1.8.0, module version = 1.0.0
[    11.965] 	Module class: X.Org Server Extension
[    11.965] 	ABI class: X.Org Server Extension, version 3.0
[    11.965] (II) Loading extension DOUBLE-BUFFER
[    11.966] (II) LoadModule: "glx"
[    11.966] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[    11.967] (II) Module glx: vendor="X.Org Foundation"
[    11.967] 	compiled for 1.8.0, module version = 1.0.0
[    11.967] 	ABI class: X.Org Server Extension, version 3.0
[    11.967] (==) AIGLX enabled
[    11.967] (II) Loading extension GLX
[    11.967] (II) LoadModule: "record"
[    11.971] (II) Loading /usr/lib64/xorg/modules/extensions/librecord.so
[    11.971] (II) Module record: vendor="X.Org Foundation"
[    11.971] 	compiled for 1.8.0, module version = 1.13.0
[    11.971] 	Module class: X.Org Server Extension
[    11.971] 	ABI class: X.Org Server Extension, version 3.0
[    11.971] (II) Loading extension RECORD
[    11.971] (II) LoadModule: "dri"
[    11.972] (II) Loading /usr/lib64/xorg/modules/extensions/libdri.so
[    11.973] (II) Module dri: vendor="X.Org Foundation"
[    11.973] 	compiled for 1.8.0, module version = 1.0.0
[    11.973] 	ABI class: X.Org Server Extension, version 3.0
[    11.973] (II) Loading extension XFree86-DRI
[    11.973] (II) LoadModule: "dri2"
[    11.973] (II) Loading /usr/lib64/xorg/modules/extensions/libdri2.so
[    11.974] (II) Module dri2: vendor="X.Org Foundation"
[    11.974] 	compiled for 1.8.0, module version = 1.2.0
[    11.974] 	ABI class: X.Org Server Extension, version 3.0
[    11.974] (II) Loading extension DRI2
[    11.974] (II) LoadModule: "radeon"
[    11.975] (II) Loading /usr/lib64/xorg/modules/drivers/radeon_drv.so
[    11.977] (II) Module radeon: vendor="X.Org Foundation"
[    11.977] 	compiled for 1.8.0, module version = 6.13.0
[    11.977] 	Module class: X.Org Video Driver
[    11.977] 	ABI class: X.Org Video Driver, version 7.0
[    11.977] (II) RADEON: Driver for ATI Radeon chipsets:
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
[    11.991] (++) using VT number 7

[    12.014] (II) Primary Device is: PCI 01@00:05:0
[    12.015] (II) [KMS] Kernel modesetting enabled.
[    12.015] (II) RADEON(0): Creating default Display subsection in Screen section
	"Default Screen" for depth/fbbpp 24/32
[    12.016] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[    12.016] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[    12.016] (==) RADEON(0): Default visual is TrueColor
[    12.016] (==) RADEON(0): RGB weight 888
[    12.016] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[    12.016] (--) RADEON(0): Chipset: "ATI Radeon HD 3200 Graphics" (ChipID = 0x9612)
[    12.016] (II) RADEON(0): PCI card detected
[    12.016] (WW) RADEON(0): Color tiling is not yet supported on R600/R700
[    12.016] (II) RADEON(0): KMS Color Tiling: disabled
[    12.016] drmOpenDevice: node name is /dev/dri/card0
[    12.016] drmOpenDevice: open result is 10, (OK)
[    12.016] drmOpenByBusid: Searching for BusID pci:0000:01:05.0
[    12.016] drmOpenDevice: node name is /dev/dri/card0
[    12.017] drmOpenDevice: open result is 10, (OK)
[    12.017] drmOpenByBusid: drmOpenMinor returns 10
[    12.017] drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
[    12.017] (II) RADEON(0): Output LVDS using monitor section Default Monitor
[    12.036] (II) RADEON(0): Output VGA-0 has no monitor section
[    12.036] (II) RADEON(0): EDID for output LVDS
[    12.036] (II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
[    12.036] (II) RADEON(0): Year: 2008  Week: 1
[    12.036] (II) RADEON(0): EDID Version: 1.3
[    12.036] (II) RADEON(0): Digital Display Input
[    12.036] (II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
[    12.036] (II) RADEON(0): Gamma: 2.20
[    12.036] (II) RADEON(0): No DPMS capabilities specified
[    12.037] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    12.037] (II) RADEON(0): First detailed timing is preferred mode
[    12.037] (II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
[    12.037] (II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
[    12.037] (II) RADEON(0): Manufacturer's mask: 0
[    12.037] (II) RADEON(0): Supported detailed timing:
[    12.037] (II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
[    12.037] (II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
[    12.037] (II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
[    12.037] (II) RADEON(0): Unknown vendor-specific block f
[    12.037] (II) RADEON(0):  AUO
[    12.037] (II) RADEON(0):  B116XW02 V0
[    12.037] (II) RADEON(0): EDID (in hex):
[    12.037] (II) RADEON(0): 	00ffffffffffff0006af5c2000000000
[    12.037] (II) RADEON(0): 	01120103801a0e780a99859555569228
[    12.037] (II) RADEON(0): 	22505400000001010101010101010101
[    12.037] (II) RADEON(0): 	01010101010196195628500008301810
[    12.037] (II) RADEON(0): 	24000090100000180000000f00000000
[    12.037] (II) RADEON(0): 	00000000000000000020000000fe0041
[    12.037] (II) RADEON(0): 	554f0a202020202020202020000000fe
[    12.037] (II) RADEON(0): 	004231313658573032205630200a00f8
[    12.037] (II) RADEON(0): EDID vendor "AUO", prod id 8284
[    12.037] (II) RADEON(0): Printing DDC gathered Modelines:
[    12.037] (II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
[    12.037] (II) RADEON(0): Printing probed modes for output LVDS
[    12.037] (II) RADEON(0): Modeline "1366x768"x60.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
[    12.037] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[    12.037] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[    12.037] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[    12.037] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
[    12.037] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1056  480 483 493 500 -hsync +vsync (29.8 kHz)
[    12.038] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 896  480 483 493 500 -hsync +vsync (29.9 kHz)
[    12.038] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
[    12.056] (II) RADEON(0): EDID for output VGA-0
[    12.056] (II) RADEON(0): Output LVDS connected
[    12.056] (II) RADEON(0): Output VGA-0 disconnected
[    12.056] (II) RADEON(0): Using exact sizes for initial modes
[    12.056] (II) RADEON(0): Output LVDS using initial mode 1366x768
[    12.056] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    12.056] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:15000000 visible:14ba0000
[    12.056] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[    12.056] (**) RADEON(0): Display dimensions: (260, 140) mm
[    12.056] (**) RADEON(0): DPI set to (133, 139)
[    12.056] (II) Loading sub module "fb"
[    12.056] (II) LoadModule: "fb"
[    12.057] (II) Loading /usr/lib64/xorg/modules/libfb.so
[    12.058] (II) Module fb: vendor="X.Org Foundation"
[    12.058] 	compiled for 1.8.0, module version = 1.0.0
[    12.058] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    12.058] (II) Loading sub module "ramdac"
[    12.058] (II) LoadModule: "ramdac"
[    12.058] (II) Module "ramdac" already built-in
[    12.058] (II) Loading sub module "exa"
[    12.058] (II) LoadModule: "exa"
[    12.060] (II) Loading /usr/lib64/xorg/modules/libexa.so
[    12.060] (II) Module exa: vendor="X.Org Foundation"
[    12.060] 	compiled for 1.8.0, module version = 2.5.0
[    12.060] 	ABI class: X.Org Video Driver, version 7.0
[    12.060] (--) Depth 24 pixmap format is 32 bpp
[    12.060] (II) RADEON(0): [DRI2] Setup complete
[    12.060] (II) RADEON(0): [DRI2]   DRI driver: r600
[    12.061] (II) RADEON(0): Front buffer size: 4608K
[    12.061] (II) RADEON(0): VRAM usage limit set to 301478K
[    12.061] (==) RADEON(0): Backing store disabled
[    12.061] (II) RADEON(0): Direct rendering enabled
[    12.061] (II) RADEON(0): Setting EXA maxPitchBytes
[    12.061] (II) EXA(0): Driver allocated offscreen pixmaps
[    12.061] (II) EXA(0): Driver registered support for the following operations:
[    12.061] (II)         Solid
[    12.061] (II)         Copy
[    12.061] (II)         Composite (RENDER acceleration)
[    12.061] (II)         UploadToScreen
[    12.061] (II)         DownloadFromScreen
[    12.061] (II) RADEON(0): Acceleration enabled
[    12.061] (==) RADEON(0): DPMS enabled
[    12.061] (==) RADEON(0): Silken mouse enabled
[    12.062] (II) RADEON(0): Set up textured video
[    12.062] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    12.063] (--) RandR disabled
[    12.063] (II) Initializing built-in extension Generic Event Extension
[    12.063] (II) Initializing built-in extension SHAPE
[    12.063] (II) Initializing built-in extension MIT-SHM
[    12.063] (II) Initializing built-in extension XInputExtension
[    12.063] (II) Initializing built-in extension XTEST
[    12.063] (II) Initializing built-in extension BIG-REQUESTS
[    12.063] (II) Initializing built-in extension SYNC
[    12.063] (II) Initializing built-in extension XKEYBOARD
[    12.063] (II) Initializing built-in extension XC-MISC
[    12.063] (II) Initializing built-in extension SECURITY
[    12.063] (II) Initializing built-in extension XINERAMA
[    12.063] (II) Initializing built-in extension XFIXES
[    12.063] (II) Initializing built-in extension RENDER
[    12.063] (II) Initializing built-in extension RANDR
[    12.063] (II) Initializing built-in extension COMPOSITE
[    12.063] (II) Initializing built-in extension DAMAGE
[    12.099] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    12.099] (II) AIGLX: enabled GLX_INTEL_swap_event
[    12.099] (II) AIGLX: enabled GLX_SGI_make_current_read
[    12.099] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    12.099] (II) AIGLX: Loaded and initialized /usr/lib64/dri/r600_dri.so
[    12.099] (II) GLX: Initialized DRI2 GL provider for screen 0
[    12.100] (II) RADEON(0): Setting screen physical size to 361 x 203
[    12.267] (II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-8AA988DD479FAABEC4FC3CCCF4CC29B4948840B4.xkm
[    12.339] (II) config/udev: Adding input device Power Button (/dev/input/event6)
[    12.339] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    12.339] (**) Power Button: Applying InputClass "LocalKeyboard"
[    12.339] (II) LoadModule: "evdev"
[    12.340] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[    12.340] (II) Module evdev: vendor="X.Org Foundation"
[    12.341] 	compiled for 1.8.0, module version = 2.4.0
[    12.341] 	Module class: X.Org XInput Driver
[    12.341] 	ABI class: X.Org XInput driver, version 9.0
[    12.341] (**) Power Button: always reports core events
[    12.341] (**) Power Button: Device: "/dev/input/event6"
[    12.348] (II) Power Button: Found keys
[    12.348] (II) Power Button: Configuring as keyboard
[    12.348] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    12.348] (**) Option "xkb_rules" "evdev"
[    12.348] (**) Option "xkb_model" "evdev"
[    12.348] (**) Option "xkb_layout" "pl"
[    12.348] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.352] (II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-35F2FF34338040D067AEC80497D56D83D2A286EF.xkm
[    12.360] (II) config/udev: Adding input device Video Bus (/dev/input/event7)
[    12.361] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    12.361] (**) Video Bus: Applying InputClass "LocalKeyboard"
[    12.361] (**) Video Bus: always reports core events
[    12.361] (**) Video Bus: Device: "/dev/input/event7"
[    12.372] (II) Video Bus: Found keys
[    12.372] (II) Video Bus: Configuring as keyboard
[    12.372] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
[    12.372] (**) Option "xkb_rules" "evdev"
[    12.372] (**) Option "xkb_model" "evdev"
[    12.372] (**) Option "xkb_layout" "pl"
[    12.372] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.373] (II) config/udev: Adding input device Power Button (/dev/input/event4)
[    12.374] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    12.374] (**) Power Button: Applying InputClass "LocalKeyboard"
[    12.374] (**) Power Button: always reports core events
[    12.374] (**) Power Button: Device: "/dev/input/event4"
[    12.380] (II) Power Button: Found keys
[    12.380] (II) Power Button: Configuring as keyboard
[    12.380] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    12.380] (**) Option "xkb_rules" "evdev"
[    12.380] (**) Option "xkb_model" "evdev"
[    12.380] (**) Option "xkb_layout" "pl"
[    12.380] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.381] (II) config/udev: Adding input device Lid Switch (/dev/input/event5)
[    12.381] (EE) No input driver/identifier specified (ignoring)
[    12.382] (II) config/udev: Adding input device Sleep Button (/dev/input/event3)
[    12.382] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    12.382] (**) Sleep Button: Applying InputClass "LocalKeyboard"
[    12.382] (**) Sleep Button: always reports core events
[    12.382] (**) Sleep Button: Device: "/dev/input/event3"
[    12.392] (II) Sleep Button: Found keys
[    12.392] (II) Sleep Button: Configuring as keyboard
[    12.392] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
[    12.392] (**) Option "xkb_rules" "evdev"
[    12.392] (**) Option "xkb_model" "evdev"
[    12.392] (**) Option "xkb_layout" "pl"
[    12.392] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.401] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event1)
[    12.401] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[    12.401] (**) Logitech USB Receiver: Applying InputClass "LocalKeyboard"
[    12.401] (**) Logitech USB Receiver: always reports core events
[    12.401] (**) Logitech USB Receiver: Device: "/dev/input/event1"
[    12.408] (II) Logitech USB Receiver: Found keys
[    12.408] (II) Logitech USB Receiver: Configuring as keyboard
[    12.408] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[    12.408] (**) Option "xkb_rules" "evdev"
[    12.408] (**) Option "xkb_model" "evdev"
[    12.408] (**) Option "xkb_layout" "pl"
[    12.408] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.409] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event2)
[    12.409] (**) Logitech USB Receiver: Applying InputClass "evdev pointer catchall"
[    12.409] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[    12.409] (**) Logitech USB Receiver: Applying InputClass "LocalKeyboard"
[    12.409] (**) Logitech USB Receiver: always reports core events
[    12.409] (**) Logitech USB Receiver: Device: "/dev/input/event2"
[    12.416] (II) Logitech USB Receiver: Found 20 mouse buttons
[    12.416] (II) Logitech USB Receiver: Found scroll wheel(s)
[    12.416] (II) Logitech USB Receiver: Found relative axes
[    12.416] (II) Logitech USB Receiver: Found x and y relative axes
[    12.416] (II) Logitech USB Receiver: Found absolute axes
[    12.416] (II) Logitech USB Receiver: Found keys
[    12.416] (II) Logitech USB Receiver: Configuring as mouse
[    12.416] (II) Logitech USB Receiver: Configuring as keyboard
[    12.416] (**) Logitech USB Receiver: YAxisMapping: buttons 4 and 5
[    12.416] (**) Logitech USB Receiver: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    12.416] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[    12.416] (**) Option "xkb_rules" "evdev"
[    12.416] (**) Option "xkb_model" "evdev"
[    12.416] (**) Option "xkb_layout" "pl"
[    12.416] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.417] (**) Logitech USB Receiver: (accel) keeping acceleration scheme 1
[    12.417] (**) Logitech USB Receiver: (accel) acceleration profile 0
[    12.417] (**) Logitech USB Receiver: (accel) acceleration factor: 2.000
[    12.417] (**) Logitech USB Receiver: (accel) acceleration threshold: 4
[    12.417] (II) Logitech USB Receiver: initialized for relative axes.
[    12.417] (WW) Logitech USB Receiver: ignoring absolute axes.
[    12.417] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/mouse0)
[    12.417] (**) Logitech USB Receiver: Applying InputClass "LocalKeyboard"
[    12.417] (EE) No input driver/identifier specified (ignoring)
[    12.422] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event8)
[    12.422] (EE) No input driver/identifier specified (ignoring)
[    12.423] (II) config/udev: Adding input device HDA ATI SB Headphone (/dev/input/event10)
[    12.423] (EE) No input driver/identifier specified (ignoring)
[    12.423] (II) config/udev: Adding input device HDA ATI SB Mic (/dev/input/event9)
[    12.423] (EE) No input driver/identifier specified (ignoring)
[    12.425] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    12.426] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    12.426] (**) AT Translated Set 2 keyboard: Applying InputClass "LocalKeyboard"
[    12.426] (**) AT Translated Set 2 keyboard: always reports core events
[    12.426] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    12.432] (II) AT Translated Set 2 keyboard: Found keys
[    12.432] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    12.432] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
[    12.432] (**) Option "xkb_rules" "evdev"
[    12.432] (**) Option "xkb_model" "evdev"
[    12.432] (**) Option "xkb_layout" "pl"
[    12.432] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    12.433] (II) config/udev: Adding input device ImPS/2 Generic Wheel Mouse (/dev/input/event11)
[    12.433] (**) ImPS/2 Generic Wheel Mouse: Applying InputClass "evdev pointer catchall"
[    12.433] (**) ImPS/2 Generic Wheel Mouse: always reports core events
[    12.433] (**) ImPS/2 Generic Wheel Mouse: Device: "/dev/input/event11"
[    12.440] (II) ImPS/2 Generic Wheel Mouse: Found 3 mouse buttons
[    12.440] (II) ImPS/2 Generic Wheel Mouse: Found scroll wheel(s)
[    12.440] (II) ImPS/2 Generic Wheel Mouse: Found relative axes
[    12.440] (II) ImPS/2 Generic Wheel Mouse: Found x and y relative axes
[    12.440] (II) ImPS/2 Generic Wheel Mouse: Configuring as mouse
[    12.440] (**) ImPS/2 Generic Wheel Mouse: YAxisMapping: buttons 4 and 5
[    12.440] (**) ImPS/2 Generic Wheel Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    12.440] (II) XINPUT: Adding extended input device "ImPS/2 Generic Wheel Mouse" (type: MOUSE)
[    12.440] (**) ImPS/2 Generic Wheel Mouse: (accel) keeping acceleration scheme 1
[    12.440] (**) ImPS/2 Generic Wheel Mouse: (accel) acceleration profile 0
[    12.440] (**) ImPS/2 Generic Wheel Mouse: (accel) acceleration factor: 2.000
[    12.440] (**) ImPS/2 Generic Wheel Mouse: (accel) acceleration threshold: 4
[    12.440] (II) ImPS/2 Generic Wheel Mouse: initialized for relative axes.
[    12.441] (II) config/udev: Adding input device ImPS/2 Generic Wheel Mouse (/dev/input/mouse1)
[    12.441] (EE) No input driver/identifier specified (ignoring)
[    13.288] (II) RADEON(0): EDID vendor "AUO", prod id 8284
[    13.288] (II) RADEON(0): Printing DDC gathered Modelines:
[    13.288] (II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
[    25.774] (II) RADEON(0): EDID vendor "AUO", prod id 8284
[    25.774] (II) RADEON(0): Printing DDC gathered Modelines:
[    25.774] (II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
[    25.898] (II) RADEON(0): EDID vendor "AUO", prod id 8284
[    25.898] (II) RADEON(0): Printing DDC gathered Modelines:
[    25.898] (II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
[    41.059] (II) RADEON(0): EDID vendor "AUO", prod id 8284
[    41.059] (II) RADEON(0): Printing DDC gathered Modelines:
[    41.059] (II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
[    91.756] (II) AIGLX: Suspending AIGLX clients for VT switch
[   100.514] (II) Open ACPI successful (/var/run/acpid.socket)
[   100.515] (II) AIGLX: Resuming AIGLX clients after VT switch
[   100.515] (II) RADEON(0): EDID vendor "AUO", prod id 8284
[   100.516] (II) RADEON(0): Printing DDC gathered Modelines:
[   100.516] (II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)

--Boundary-00=_T5G7MuddZyFUcQQ--
