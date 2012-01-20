Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2ATIab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:30:31 -0500
Received: from pecan2.exetel.com.au ([220.233.0.70]:39761 "EHLO
	pecan2.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2ATIa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:30:27 -0500
X-Greylist: delayed 986 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 03:30:26 EST
Message-ID: <4F192242.1070909@exemail.com.au>
Date: Fri, 20 Jan 2012 19:13:54 +1100
From: Padfoot <padfoot@exemail.com.au>
Reply-To: padfoot@exemail.com.au
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel version 3.2.1 usb touchscreen device not recognised
 [UDEV? USBINPUT? HOOK]
Content-Type: multipart/mixed;
 boundary="------------010008000905040203000307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010008000905040203000307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Upgrade from kernel 3.1.9 to 3.2.1 eGalax usb touchscreen device is no 
longer recognised.

Device is an Acer Iconia Tab w501 with inbuilt touchscreen. Screen is a 
pci device but is connected on boot as a usb input device. Issue appears 
to be with either UDEV or USBINPUT boot hook failing to recognise the 
device as can be seen in the dmesg.3.2.1 attachment.

Downgrading to kernel 3.1.9 corrects the issue.

Please see attached files for comparative information between kernel 
versions - using x86_64.

Attachments:

1. Processor
     cpuinfo

2. Kernel 3.1.9:
     dmesg.3.1.9 ($ dmesg | grep eGalax)
     lspci.3.1.9 (# lspci -vvv)
     xinput.list.3.1.9 ($ xinput list)
     xorg.log.3.1.9 (/var/log/Xorg.0.log)

3. Kernel 3.2.1:
     dmesg.3.2.1 ($ dmesg | grep "usb 5-")
     lspci.3.2.1 (# lspci -vvv)
     xinput.list.3.2.1 ($ xinput list)
     xorg.log.3.2.1 (/var/log/Xorg.0.log)

Please CC me into discussion on this issue.

Happy to provide any further information you require.

Cheers.
Lachlan.

--------------010008000905040203000307
Content-Type: text/plain;
 name="cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cpuinfo"

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 2
model name	: AMD C-60 Processor 
stepping	: 0
microcode	: 0x5000101
cpu MHz		: 997.999
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt arat cpb npt lbrv svm_lock nrip_save pausefilter
bogomips	: 1996.16
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate [9]

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 2
model name	: AMD C-60 Processor 
stepping	: 0
microcode	: 0x5000101
cpu MHz		: 997.999
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt arat cpb npt lbrv svm_lock nrip_save pausefilter
bogomips	: 1996.95
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate [9]


--------------010008000905040203000307
Content-Type: text/plain;
 name="dmesg.3.1.9"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.3.1.9"

[    4.920911] input: eGalax Inc. USB TouchController as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.0/input/input10
[    4.923565] generic-usb 0003:0EEF:7302.0001: input,hiddev0,hidraw0: USB HID v2.10 Pointer [eGalax Inc. USB TouchController] on usb-0000:00:13.0-1/input0
[    7.701218] input: eGalaxTouch Virtual Device for Multi as /devices/virtual/input/input13
[    7.701692] input: eGalaxTouch Virtual Device for Single as /devices/virtual/input/input14

--------------010008000905040203000307
Content-Type: text/plain;
 name="dmesg.3.2.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.3.2.1"

[    3.853443] usb 5-1: new full-speed USB device number 2 using ohci_hcd
[    3.990164] usb 5-1: device descriptor read/64, error -62
[    4.226771] usb 5-1: device descriptor read/64, error -62
[    4.460091] usb 5-1: new full-speed USB device number 3 using ohci_hcd
[    4.593421] usb 5-1: device descriptor read/64, error -62
[    4.830326] usb 5-1: device descriptor read/64, error -62
[    5.063660] usb 5-1: new full-speed USB device number 4 using ohci_hcd
[    5.470315] usb 5-1: device not accepting address 4, error -62
[    5.600320] usb 5-1: new full-speed USB device number 5 using ohci_hcd
[    6.006989] usb 5-1: device not accepting address 5, error -62
[    6.256982] usb 5-5: new full-speed USB device number 6 using ohci_hcd

--------------010008000905040203000307
Content-Type: text/plain;
 name="lspci.3.1.9"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci.3.1.9"

00:13.0 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 0577
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 9014b000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 0577
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at 9014a000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

--------------010008000905040203000307
Content-Type: text/plain;
 name="lspci.3.2.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci.3.2.1"

00:13.0 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 0577
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 9014b000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 0577
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at 9014a000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

--------------010008000905040203000307
Content-Type: text/plain; charset=UTF-8;
 name="xinput.list.3.1.9"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="xinput.list.3.1.9"

⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ SONiX USB Keyboard                      	id=12	[slave  pointer  (2)]
⎜   ↳ eGalaxTouch Virtual Device for Multi    	id=14	[slave  pointer  (2)]
⎜   ↳ eGalaxTouch Virtual Device for Single   	id=15	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Power Button                            	id=8	[slave  keyboard (3)]
    ↳ 1.3M Rear                               	id=9	[slave  keyboard (3)]
    ↳ 1.3M Front                              	id=10	[slave  keyboard (3)]
    ↳ SONiX USB Keyboard                      	id=11	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=13	[slave  keyboard (3)]

--------------010008000905040203000307
Content-Type: text/plain; charset=UTF-8;
 name="xinput.list.3.2.1"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="xinput.list.3.2.1"

⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ SONiX USB Keyboard                      	id=12	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Power Button                            	id=8	[slave  keyboard (3)]
    ↳ 1.3M Rear                               	id=9	[slave  keyboard (3)]
    ↳ 1.3M Front                              	id=10	[slave  keyboard (3)]
    ↳ SONiX USB Keyboard                      	id=11	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=13	[slave  keyboard (3)]
    ↳ Acer WMI hotkeys                        	id=14	[slave  keyboard (3)]

--------------010008000905040203000307
Content-Type: text/plain;
 name="xorg.log.3.1.9"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xorg.log.3.1.9"

[     8.246] 
X.Org X Server 1.11.3
Release Date: 2011-12-16
[     8.246] X Protocol Version 11, Revision 0
[     8.246] Build Operating System: Linux 3.1.5-1-ARCH x86_64 
[     8.247] Current Operating System: Linux charlie 3.1.9-2-ARCH #1 SMP PREEMPT Sat Jan 14 09:11:37 CET 2012 x86_64
[     8.247] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=/dev/sda2 ro radeon.modeset=1 quiet resume=/dev/sda3 loglevel=3 logo.nologo console=tty1 splash=silent,fadein,fadeout,theme:archlinux-deep-aurora
[     8.247] Build Date: 17 December 2011  09:17:41AM
[     8.247]  
[     8.247] Current version of pixman: 0.24.0
[     8.247] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[     8.247] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[     8.247] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Jan 19 18:44:10 2012
[     8.253] (==) Using config directory: "/etc/X11/xorg.conf.d"
[     8.255] (==) No Layout section.  Using the first Screen section.
[     8.255] (==) No screen section available. Using defaults.
[     8.255] (**) |-->Screen "Default Screen Section" (0)
[     8.255] (**) |   |-->Monitor "<default monitor>"
[     8.257] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[     8.257] (==) Automatically adding devices
[     8.257] (==) Automatically enabling devices
[     8.267] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[     8.268] 	Entry deleted from font path.
[     8.275] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/100dpi/".
[     8.275] 	Entry deleted from font path.
[     8.275] 	(Run 'mkfontdir' on "/usr/share/fonts/100dpi/").
[     8.276] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/75dpi/".
[     8.276] 	Entry deleted from font path.
[     8.276] 	(Run 'mkfontdir' on "/usr/share/fonts/75dpi/").
[     8.276] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/
[     8.276] (==) ModulePath set to "/usr/lib/xorg/modules"
[     8.276] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[     8.276] (II) Loader magic: 0x7ccae0
[     8.276] (II) Module ABI versions:
[     8.276] 	X.Org ANSI C Emulation: 0.4
[     8.276] 	X.Org Video Driver: 11.0
[     8.276] 	X.Org XInput driver : 13.0
[     8.276] 	X.Org Server Extension : 6.0
[     8.278] (--) PCI:*(0:0:1:0) 1002:9807:1025:0577 rev 0, Mem @ 0x80000000/268435456, 0x90100000/262144, I/O @ 0x00002000/256
[     8.278] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[     8.278] (II) LoadModule: "extmod"
[     8.286] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[     8.288] (II) Module extmod: vendor="X.Org Foundation"
[     8.288] 	compiled for 1.11.3, module version = 1.0.0
[     8.288] 	Module class: X.Org Server Extension
[     8.288] 	ABI class: X.Org Server Extension, version 6.0
[     8.288] (II) Loading extension MIT-SCREEN-SAVER
[     8.288] (II) Loading extension XFree86-VidModeExtension
[     8.289] (II) Loading extension XFree86-DGA
[     8.289] (II) Loading extension DPMS
[     8.289] (II) Loading extension XVideo
[     8.289] (II) Loading extension XVideo-MotionCompensation
[     8.289] (II) Loading extension X-Resource
[     8.289] (II) LoadModule: "dbe"
[     8.289] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[     8.290] (II) Module dbe: vendor="X.Org Foundation"
[     8.291] 	compiled for 1.11.3, module version = 1.0.0
[     8.291] 	Module class: X.Org Server Extension
[     8.291] 	ABI class: X.Org Server Extension, version 6.0
[     8.291] (II) Loading extension DOUBLE-BUFFER
[     8.291] (II) LoadModule: "glx"
[     8.291] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[     8.296] (II) Module glx: vendor="X.Org Foundation"
[     8.296] 	compiled for 1.11.3, module version = 1.0.0
[     8.296] 	ABI class: X.Org Server Extension, version 6.0
[     8.296] (==) AIGLX enabled
[     8.296] (II) Loading extension GLX
[     8.297] (II) LoadModule: "record"
[     8.297] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[     8.299] (II) Module record: vendor="X.Org Foundation"
[     8.299] 	compiled for 1.11.3, module version = 1.13.0
[     8.299] 	Module class: X.Org Server Extension
[     8.299] 	ABI class: X.Org Server Extension, version 6.0
[     8.299] (II) Loading extension RECORD
[     8.299] (II) LoadModule: "dri"
[     8.299] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[     8.303] (II) Module dri: vendor="X.Org Foundation"
[     8.303] 	compiled for 1.11.3, module version = 1.0.0
[     8.303] 	ABI class: X.Org Server Extension, version 6.0
[     8.303] (II) Loading extension XFree86-DRI
[     8.303] (II) LoadModule: "dri2"
[     8.303] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[     8.305] (II) Module dri2: vendor="X.Org Foundation"
[     8.305] 	compiled for 1.11.3, module version = 1.2.0
[     8.305] 	ABI class: X.Org Server Extension, version 6.0
[     8.305] (II) Loading extension DRI2
[     8.305] (==) Matched ati as autoconfigured driver 0
[     8.305] (==) Matched vesa as autoconfigured driver 1
[     8.305] (==) Matched fbdev as autoconfigured driver 2
[     8.305] (==) Assigned the driver to the xf86ConfigLayout
[     8.305] (II) LoadModule: "ati"
[     8.305] (II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
[     8.306] (II) Module ati: vendor="X.Org Foundation"
[     8.306] 	compiled for 1.11.1.902, module version = 6.14.3
[     8.306] 	Module class: X.Org Video Driver
[     8.306] 	ABI class: X.Org Video Driver, version 11.0
[     8.307] (II) LoadModule: "radeon"
[     8.307] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     8.316] (II) Module radeon: vendor="X.Org Foundation"
[     8.316] 	compiled for 1.11.1.902, module version = 6.14.3
[     8.316] 	Module class: X.Org Video Driver
[     8.316] 	ABI class: X.Org Video Driver, version 11.0
[     8.318] (II) LoadModule: "vesa"
[     8.319] (WW) Warning, couldn't open module vesa
[     8.319] (II) UnloadModule: "vesa"
[     8.319] (II) Unloading vesa
[     8.319] (EE) Failed to load module "vesa" (module does not exist, 0)
[     8.319] (II) LoadModule: "fbdev"
[     8.319] (WW) Warning, couldn't open module fbdev
[     8.319] (II) UnloadModule: "fbdev"
[     8.319] (II) Unloading fbdev
[     8.319] (EE) Failed to load module "fbdev" (module does not exist, 0)
[     8.320] (II) RADEON: Driver for ATI Radeon chipsets:
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
	ATI Radeon 3000 Graphics, SUMO, SUMO, SUMO2, SUMO2, SUMO2, SUMO2,
	SUMO, SUMO, SUMO, SUMO, SUMO, ATI Radeon HD 4200, ATI Radeon 4100,
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
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS
[     8.331] (++) using VT number 7

[     8.331] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     8.332] (II) [KMS] Kernel modesetting enabled.
[     8.333] (II) RADEON(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[     8.333] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[     8.333] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[     8.333] (==) RADEON(0): Default visual is TrueColor
[     8.333] (==) RADEON(0): RGB weight 888
[     8.333] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[     8.333] (--) RADEON(0): Chipset: "AMD Radeon HD 6200 Series Graphics" (ChipID = 0x9807)
[     8.333] (II) RADEON(0): PCIE card detected
[     8.334] drmOpenDevice: node name is /dev/dri/card0
[     8.334] drmOpenDevice: open result is 11, (OK)
[     8.334] drmOpenByBusid: Searching for BusID pci:0000:00:01.0
[     8.334] drmOpenDevice: node name is /dev/dri/card0
[     8.334] drmOpenDevice: open result is 11, (OK)
[     8.334] drmOpenByBusid: drmOpenMinor returns 11
[     8.334] drmOpenByBusid: drmGetBusid reports pci:0000:00:01.0
[     8.334] (II) Loading sub module "exa"
[     8.334] (II) LoadModule: "exa"
[     8.334] (II) Loading /usr/lib/xorg/modules/libexa.so
[     8.337] (II) Module exa: vendor="X.Org Foundation"
[     8.337] 	compiled for 1.11.3, module version = 2.5.0
[     8.337] 	ABI class: X.Org Video Driver, version 11.0
[     8.337] (II) RADEON(0): KMS Color Tiling: enabled
[     8.337] (II) RADEON(0): KMS Pageflipping: enabled
[     8.337] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[     8.337] (II) RADEON(0): Output LVDS has no monitor section
[     8.342] (II) RADEON(0): Output HDMI-0 has no monitor section
[     8.343] (II) RADEON(0): EDID for output LVDS
[     8.343] (II) RADEON(0): Manufacturer: AUO  Model: 53d4  Serial#: 0
[     8.343] (II) RADEON(0): Year: 2010  Week: 0
[     8.343] (II) RADEON(0): EDID Version: 1.4
[     8.343] (II) RADEON(0): Digital Display Input
[     8.343] (II) RADEON(0): 6 bits per channel
[     8.343] (II) RADEON(0): Digital interface is undefined
[     8.343] (II) RADEON(0): Max Image Size [cm]: horiz.: 22  vert.: 14
[     8.343] (II) RADEON(0): Gamma: 2.20
[     8.343] (II) RADEON(0): No DPMS capabilities specified
[     8.343] (II) RADEON(0): Supported color encodings: RGB 4:4:4 
[     8.343] (II) RADEON(0): First detailed timing is preferred mode
[     8.343] (II) RADEON(0): Preferred mode is native pixel format and refresh rate
[     8.343] (II) RADEON(0): redX: 0.581 redY: 0.340   greenX: 0.326 greenY: 0.558
[     8.343] (II) RADEON(0): blueX: 0.153 blueY: 0.138   whiteX: 0.313 whiteY: 0.329
[     8.343] (II) RADEON(0): Manufacturer's mask: 0
[     8.343] (II) RADEON(0): Supported detailed timing:
[     8.343] (II) RADEON(0): clock: 71.2 MHz   Image Size:  216 x 135 mm
[     8.343] (II) RADEON(0): h_active: 1280  h_sync: 1288  h_sync_end 1298 h_blank_end 1464 h_border: 0
[     8.343] (II) RADEON(0): v_active: 800  v_sync: 803  v_sync_end 804 v_blanking: 808 v_border: 0
[     8.343] (II) RADEON(0): Unknown vendor-specific block f
[     8.343] (II) RADEON(0):  AUO
[     8.343] (II) RADEON(0):  B101EW05 V3
[     8.343] (II) RADEON(0): EDID (in hex):
[     8.343] (II) RADEON(0): 	00ffffffffffff0006afd45300000000
[     8.343] (II) RADEON(0): 	0014010490160e7802cb559457538e27
[     8.343] (II) RADEON(0): 	23505400000001010101010101010101
[     8.344] (II) RADEON(0): 	010101010101d01b00b850200830080a
[     8.344] (II) RADEON(0): 	3100d887000000180000000f00000000
[     8.344] (II) RADEON(0): 	00000000000000000020000000fe0041
[     8.344] (II) RADEON(0): 	554f0a202020202020202020000000fe
[     8.344] (II) RADEON(0): 	004231303145573035205633200a0012
[     8.344] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[     8.344] (II) RADEON(0): Printing DDC gathered Modelines:
[     8.344] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[     8.344] (II) RADEON(0): Printing probed modes for output LVDS
[     8.344] (II) RADEON(0): Modeline "1280x800"x60.2   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[     8.344] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[     8.344] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[     8.344] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[     8.344] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
[     8.344] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1056  480 483 493 500 -hsync +vsync (29.8 kHz)
[     8.344] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 896  480 483 493 500 -hsync +vsync (29.9 kHz)
[     8.344] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
[     8.348] (II) RADEON(0): EDID for output HDMI-0
[     8.348] (II) RADEON(0): Output LVDS connected
[     8.348] (II) RADEON(0): Output HDMI-0 disconnected
[     8.348] (II) RADEON(0): Using exact sizes for initial modes
[     8.349] (II) RADEON(0): Output LVDS using initial mode 1280x800
[     8.349] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[     8.349] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:18000000 visible:fbd8000
[     8.349] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[     8.349] (**) RADEON(0): Display dimensions: (220, 140) mm
[     8.349] (**) RADEON(0): DPI set to (147, 145)
[     8.349] (II) Loading sub module "fb"
[     8.349] (II) LoadModule: "fb"
[     8.349] (II) Loading /usr/lib/xorg/modules/libfb.so
[     8.353] (II) Module fb: vendor="X.Org Foundation"
[     8.353] 	compiled for 1.11.3, module version = 1.0.0
[     8.353] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     8.353] (II) Loading sub module "ramdac"
[     8.353] (II) LoadModule: "ramdac"
[     8.353] (II) Module "ramdac" already built-in
[     8.353] (--) Depth 24 pixmap format is 32 bpp
[     8.355] (II) RADEON(0): [DRI2] Setup complete
[     8.355] (II) RADEON(0): [DRI2]   DRI driver: r600
[     8.355] (II) RADEON(0): [DRI2]   VDPAU driver: r600
[     8.355] (II) RADEON(0): Front buffer size: 4000K
[     8.355] (II) RADEON(0): VRAM usage limit set to 228499K
[     8.358] (==) RADEON(0): Backing store disabled
[     8.358] (II) RADEON(0): Direct rendering enabled
[     8.359] (II) RADEON(0): Setting EXA maxPitchBytes
[     8.359] (II) EXA(0): Driver allocated offscreen pixmaps
[     8.359] (II) EXA(0): Driver registered support for the following operations:
[     8.359] (II)         Solid
[     8.359] (II)         Copy
[     8.359] (II)         Composite (RENDER acceleration)
[     8.359] (II)         UploadToScreen
[     8.360] (II)         DownloadFromScreen
[     8.360] (II) RADEON(0): Acceleration enabled
[     8.360] (==) RADEON(0): DPMS enabled
[     8.360] (==) RADEON(0): Silken mouse enabled
[     8.362] (II) RADEON(0): Set up textured video
[     8.362] (II) RADEON(0): [XvMC] Associated with Radeon Textured Video.
[     8.362] (II) RADEON(0): [XvMC] Extension initialized.
[     8.362] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[     8.362] (--) RandR disabled
[     8.362] (II) Initializing built-in extension Generic Event Extension
[     8.362] (II) Initializing built-in extension SHAPE
[     8.362] (II) Initializing built-in extension MIT-SHM
[     8.362] (II) Initializing built-in extension XInputExtension
[     8.362] (II) Initializing built-in extension XTEST
[     8.362] (II) Initializing built-in extension BIG-REQUESTS
[     8.362] (II) Initializing built-in extension SYNC
[     8.362] (II) Initializing built-in extension XKEYBOARD
[     8.362] (II) Initializing built-in extension XC-MISC
[     8.362] (II) Initializing built-in extension SECURITY
[     8.362] (II) Initializing built-in extension XINERAMA
[     8.362] (II) Initializing built-in extension XFIXES
[     8.362] (II) Initializing built-in extension RENDER
[     8.362] (II) Initializing built-in extension RANDR
[     8.362] (II) Initializing built-in extension COMPOSITE
[     8.362] (II) Initializing built-in extension DAMAGE
[     8.459] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[     8.459] (II) AIGLX: enabled GLX_INTEL_swap_event
[     8.459] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[     8.459] (II) AIGLX: enabled GLX_SGI_make_current_read
[     8.459] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[     8.460] (II) AIGLX: Loaded and initialized r600
[     8.460] (II) GLX: Initialized DRI2 GL provider for screen 0
[     8.464] (II) RADEON(0): Setting screen physical size to 338 x 211
[     8.614] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[     8.614] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     8.614] (II) LoadModule: "evdev"
[     8.614] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.616] (II) Module evdev: vendor="X.Org Foundation"
[     8.616] 	compiled for 1.10.99.902, module version = 2.6.0
[     8.616] 	Module class: X.Org XInput Driver
[     8.616] 	ABI class: X.Org XInput driver, version 13.0
[     8.616] (II) Using input driver 'evdev' for 'Power Button'
[     8.616] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.616] (**) Power Button: always reports core events
[     8.616] (**) Power Button: Device: "/dev/input/event3"
[     8.616] (--) Power Button: Found keys
[     8.616] (II) Power Button: Configuring as keyboard
[     8.616] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[     8.616] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[     8.616] (**) Option "xkb_rules" "evdev"
[     8.616] (**) Option "xkb_model" "evdev"
[     8.616] (**) Option "xkb_layout" "us"
[     8.696] (II) config/udev: Adding input device Video Bus (/dev/input/event4)
[     8.696] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[     8.696] (II) Using input driver 'evdev' for 'Video Bus'
[     8.697] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.697] (**) Video Bus: always reports core events
[     8.697] (**) Video Bus: Device: "/dev/input/event4"
[     8.697] (--) Video Bus: Found keys
[     8.697] (II) Video Bus: Configuring as keyboard
[     8.697] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4/event4"
[     8.697] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[     8.697] (**) Option "xkb_rules" "evdev"
[     8.697] (**) Option "xkb_model" "evdev"
[     8.697] (**) Option "xkb_layout" "us"
[     8.698] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[     8.698] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     8.698] (II) Using input driver 'evdev' for 'Power Button'
[     8.698] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.698] (**) Power Button: always reports core events
[     8.699] (**) Power Button: Device: "/dev/input/event1"
[     8.699] (--) Power Button: Found keys
[     8.699] (II) Power Button: Configuring as keyboard
[     8.699] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1/event1"
[     8.699] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 8)
[     8.699] (**) Option "xkb_rules" "evdev"
[     8.699] (**) Option "xkb_model" "evdev"
[     8.699] (**) Option "xkb_layout" "us"
[     8.700] (II) config/udev: Adding input device Lid Switch (/dev/input/event2)
[     8.700] (II) No input driver/identifier specified (ignoring)
[     8.701] (II) config/udev: Adding input device HD-Audio Generic HDMI/DP (/dev/input/event7)
[     8.701] (II) No input driver/identifier specified (ignoring)
[     8.702] (II) config/udev: Adding input device eGalax Inc. USB TouchController (/dev/input/event10)
[     8.702] (**) eGalax Inc. USB TouchController: Applying InputClass "evdev tablet catchall"
[     8.702] (**) eGalax Inc. USB TouchController: Applying InputClass "eGalax touch class"
[     8.702] (II) LoadModule: "void"
[     8.703] (WW) Warning, couldn't open module void
[     8.703] (II) UnloadModule: "void"
[     8.703] (II) Unloading void
[     8.703] (EE) Failed to load module "void" (module does not exist, 0)
[     8.703] (EE) No input driver matching `void'
[     8.704] (II) config/udev: Adding input device eGalax Inc. USB TouchController (/dev/input/mouse0)
[     8.704] (**) eGalax Inc. USB TouchController: Applying InputClass "eGalax mouse class"
[     8.704] (II) LoadModule: "void"
[     8.705] (WW) Warning, couldn't open module void
[     8.705] (II) UnloadModule: "void"
[     8.705] (II) Unloading void
[     8.705] (EE) Failed to load module "void" (module does not exist, 0)
[     8.705] (EE) No input driver matching `void'
[     8.706] (II) config/udev: Adding input device 1.3M Rear (/dev/input/event5)
[     8.706] (**) 1.3M Rear: Applying InputClass "evdev keyboard catchall"
[     8.706] (II) Using input driver 'evdev' for '1.3M Rear'
[     8.706] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.706] (**) 1.3M Rear: always reports core events
[     8.706] (**) 1.3M Rear: Device: "/dev/input/event5"
[     8.706] (--) 1.3M Rear: Found keys
[     8.706] (II) 1.3M Rear: Configuring as keyboard
[     8.706] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:13.2/usb2/2-3/2-3:1.0/input/input5/event5"
[     8.707] (II) XINPUT: Adding extended input device "1.3M Rear" (type: KEYBOARD, id 9)
[     8.707] (**) Option "xkb_rules" "evdev"
[     8.707] (**) Option "xkb_model" "evdev"
[     8.707] (**) Option "xkb_layout" "us"
[     8.708] (II) config/udev: Adding input device 1.3M Front (/dev/input/event6)
[     8.708] (**) 1.3M Front: Applying InputClass "evdev keyboard catchall"
[     8.708] (II) Using input driver 'evdev' for '1.3M Front'
[     8.708] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.708] (**) 1.3M Front: always reports core events
[     8.708] (**) 1.3M Front: Device: "/dev/input/event6"
[     8.709] (--) 1.3M Front: Found keys
[     8.709] (II) 1.3M Front: Configuring as keyboard
[     8.709] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4:1.0/input/input6/event6"
[     8.709] (II) XINPUT: Adding extended input device "1.3M Front" (type: KEYBOARD, id 10)
[     8.709] (**) Option "xkb_rules" "evdev"
[     8.709] (**) Option "xkb_model" "evdev"
[     8.709] (**) Option "xkb_layout" "us"
[     8.710] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event8)
[     8.710] (II) No input driver/identifier specified (ignoring)
[     8.711] (II) config/udev: Adding input device HDA ATI SB Headphone (/dev/input/event9)
[     8.711] (II) No input driver/identifier specified (ignoring)
[     8.712] (II) config/udev: Adding input device SONiX USB Keyboard (/dev/input/event11)
[     8.712] (**) SONiX USB Keyboard: Applying InputClass "evdev keyboard catchall"
[     8.712] (II) Using input driver 'evdev' for 'SONiX USB Keyboard'
[     8.712] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.712] (**) SONiX USB Keyboard: always reports core events
[     8.713] (**) SONiX USB Keyboard: Device: "/dev/input/event11"
[     8.713] (--) SONiX USB Keyboard: Found keys
[     8.713] (II) SONiX USB Keyboard: Configuring as keyboard
[     8.713] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:16.2/usb3/3-1/3-1.2/3-1.2:1.0/input/input11/event11"
[     8.713] (II) XINPUT: Adding extended input device "SONiX USB Keyboard" (type: KEYBOARD, id 11)
[     8.713] (**) Option "xkb_rules" "evdev"
[     8.713] (**) Option "xkb_model" "evdev"
[     8.713] (**) Option "xkb_layout" "us"
[     8.715] (II) config/udev: Adding input device SONiX USB Keyboard (/dev/input/event12)
[     8.715] (**) SONiX USB Keyboard: Applying InputClass "evdev pointer catchall"
[     8.715] (**) SONiX USB Keyboard: Applying InputClass "evdev keyboard catchall"
[     8.715] (II) Using input driver 'evdev' for 'SONiX USB Keyboard'
[     8.715] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.715] (**) SONiX USB Keyboard: always reports core events
[     8.715] (**) SONiX USB Keyboard: Device: "/dev/input/event12"
[     8.715] (--) SONiX USB Keyboard: Found 9 mouse buttons
[     8.715] (--) SONiX USB Keyboard: Found scroll wheel(s)
[     8.715] (--) SONiX USB Keyboard: Found relative axes
[     8.715] (--) SONiX USB Keyboard: Found x and y relative axes
[     8.715] (--) SONiX USB Keyboard: Found absolute axes
[     8.715] (--) SONiX USB Keyboard: Found keys
[     8.715] (II) SONiX USB Keyboard: Configuring as mouse
[     8.715] (II) SONiX USB Keyboard: Configuring as keyboard
[     8.715] (II) SONiX USB Keyboard: Adding scrollwheel support
[     8.715] (**) SONiX USB Keyboard: YAxisMapping: buttons 4 and 5
[     8.715] (**) SONiX USB Keyboard: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     8.715] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:16.2/usb3/3-1/3-1.2/3-1.2:1.1/input/input12/event12"
[     8.715] (II) XINPUT: Adding extended input device "SONiX USB Keyboard" (type: KEYBOARD, id 12)
[     8.715] (**) Option "xkb_rules" "evdev"
[     8.715] (**) Option "xkb_model" "evdev"
[     8.716] (**) Option "xkb_layout" "us"
[     8.716] (II) SONiX USB Keyboard: initialized for relative axes.
[     8.716] (WW) SONiX USB Keyboard: ignoring absolute axes.
[     8.717] (**) SONiX USB Keyboard: (accel) keeping acceleration scheme 1
[     8.717] (**) SONiX USB Keyboard: (accel) acceleration profile 0
[     8.717] (**) SONiX USB Keyboard: (accel) acceleration factor: 2.000
[     8.717] (**) SONiX USB Keyboard: (accel) acceleration threshold: 4
[     8.718] (II) config/udev: Adding input device SONiX USB Keyboard (/dev/input/mouse1)
[     8.718] (II) No input driver/identifier specified (ignoring)
[     8.719] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[     8.719] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[     8.719] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[     8.719] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.719] (**) AT Translated Set 2 keyboard: always reports core events
[     8.719] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[     8.719] (--) AT Translated Set 2 keyboard: Found keys
[     8.719] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[     8.719] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[     8.719] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 13)
[     8.719] (**) Option "xkb_rules" "evdev"
[     8.719] (**) Option "xkb_model" "evdev"
[     8.719] (**) Option "xkb_layout" "us"
[     8.781] (II) config/udev: Adding input device eGalaxTouch Virtual Device for Multi (/dev/input/event13)
[     8.782] (**) eGalaxTouch Virtual Device for Multi: Applying InputClass "evdev touchscreen catchall"
[     8.782] (**) eGalaxTouch Virtual Device for Multi: Applying InputClass "eGalax virtual class"
[     8.782] (II) Using input driver 'evdev' for 'eGalaxTouch Virtual Device for Multi'
[     8.782] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.782] (**) eGalaxTouch Virtual Device for Multi: always reports core events
[     8.782] (**) eGalaxTouch Virtual Device for Multi: Device: "/dev/input/event13"
[     8.782] (--) eGalaxTouch Virtual Device for Multi: Found absolute axes
[     8.782] (--) eGalaxTouch Virtual Device for Multi: Found x and y absolute axes
[     8.782] (--) eGalaxTouch Virtual Device for Multi: Found absolute touchscreen
[     8.782] (II) eGalaxTouch Virtual Device for Multi: Configuring as touchscreen
[     8.782] (**) eGalaxTouch Virtual Device for Multi: YAxisMapping: buttons 4 and 5
[     8.782] (**) eGalaxTouch Virtual Device for Multi: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     8.782] (**) Option "config_info" "udev:/sys/devices/virtual/input/input13/event13"
[     8.782] (II) XINPUT: Adding extended input device "eGalaxTouch Virtual Device for Multi" (type: TOUCHSCREEN, id 14)
[     8.782] (II) eGalaxTouch Virtual Device for Multi: initialized for absolute axes.
[     8.783] (**) eGalaxTouch Virtual Device for Multi: (accel) keeping acceleration scheme 1
[     8.783] (**) eGalaxTouch Virtual Device for Multi: (accel) acceleration profile 0
[     8.783] (**) eGalaxTouch Virtual Device for Multi: (accel) acceleration factor: 2.000
[     8.783] (**) eGalaxTouch Virtual Device for Multi: (accel) acceleration threshold: 4
[     8.789] (II) config/udev: Adding input device eGalaxTouch Virtual Device for Multi (/dev/input/mouse2)
[     8.789] (**) eGalaxTouch Virtual Device for Multi: Applying InputClass "eGalax mouse class"
[     8.789] (II) LoadModule: "void"
[     8.790] (WW) Warning, couldn't open module void
[     8.790] (II) UnloadModule: "void"
[     8.790] (II) Unloading void
[     8.790] (EE) Failed to load module "void" (module does not exist, 0)
[     8.790] (EE) No input driver matching `void'
[     8.791] (II) config/udev: Adding input device eGalaxTouch Virtual Device for Single (/dev/input/mouse3)
[     8.791] (**) eGalaxTouch Virtual Device for Single: Applying InputClass "eGalax mouse class"
[     8.791] (II) LoadModule: "void"
[     8.792] (WW) Warning, couldn't open module void
[     8.792] (II) UnloadModule: "void"
[     8.792] (II) Unloading void
[     8.792] (EE) Failed to load module "void" (module does not exist, 0)
[     8.792] (EE) No input driver matching `void'
[     8.792] (II) config/udev: Adding input device eGalaxTouch Virtual Device for Single (/dev/input/js0)
[     8.793] (**) eGalaxTouch Virtual Device for Single: Applying InputClass "eGalax joystick class"
[     8.793] (II) LoadModule: "void"
[     8.794] (WW) Warning, couldn't open module void
[     8.794] (II) UnloadModule: "void"
[     8.794] (II) Unloading void
[     8.794] (EE) Failed to load module "void" (module does not exist, 0)
[     8.794] (EE) No input driver matching `void'
[     8.794] (II) config/udev: Adding input device eGalaxTouch Virtual Device for Single (/dev/input/event14)
[     8.794] (**) eGalaxTouch Virtual Device for Single: Applying InputClass "evdev pointer catchall"
[     8.794] (**) eGalaxTouch Virtual Device for Single: Applying InputClass "eGalax virtual class"
[     8.794] (II) Using input driver 'evdev' for 'eGalaxTouch Virtual Device for Single'
[     8.794] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.794] (**) eGalaxTouch Virtual Device for Single: always reports core events
[     8.794] (**) eGalaxTouch Virtual Device for Single: Device: "/dev/input/event14"
[     8.795] (--) eGalaxTouch Virtual Device for Single: Found 3 mouse buttons
[     8.795] (--) eGalaxTouch Virtual Device for Single: Found absolute axes
[     8.795] (--) eGalaxTouch Virtual Device for Single: Found x and y absolute axes
[     8.795] (--) eGalaxTouch Virtual Device for Single: Found absolute touchpad.
[     8.795] (II) eGalaxTouch Virtual Device for Single: Configuring as touchpad
[     8.795] (**) eGalaxTouch Virtual Device for Single: YAxisMapping: buttons 4 and 5
[     8.795] (**) eGalaxTouch Virtual Device for Single: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     8.795] (**) Option "config_info" "udev:/sys/devices/virtual/input/input14/event14"
[     8.795] (II) XINPUT: Adding extended input device "eGalaxTouch Virtual Device for Single" (type: TOUCHPAD, id 15)
[     8.795] (II) eGalaxTouch Virtual Device for Single: initialized for absolute axes.
[     8.795] (**) eGalaxTouch Virtual Device for Single: (accel) keeping acceleration scheme 1
[     8.795] (**) eGalaxTouch Virtual Device for Single: (accel) acceleration profile 0
[     8.795] (**) eGalaxTouch Virtual Device for Single: (accel) acceleration factor: 2.000
[     8.795] (**) eGalaxTouch Virtual Device for Single: (accel) acceleration threshold: 4
[    19.692] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    19.692] (II) RADEON(0): Printing DDC gathered Modelines:
[    19.692] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    19.696] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    19.697] (II) RADEON(0): Printing DDC gathered Modelines:
[    19.697] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    20.238] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    20.239] (II) RADEON(0): Printing DDC gathered Modelines:
[    20.239] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    20.253] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    20.253] (II) RADEON(0): Printing DDC gathered Modelines:
[    20.253] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    20.261] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    20.261] (II) RADEON(0): Printing DDC gathered Modelines:
[    20.261] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    20.270] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    20.270] (II) RADEON(0): Printing DDC gathered Modelines:
[    20.270] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    25.330] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    25.330] (II) RADEON(0): Printing DDC gathered Modelines:
[    25.330] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)

--------------010008000905040203000307
Content-Type: text/plain;
 name="xorg.log.3.2.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xorg.log.3.2.1"

[     8.276] 
X.Org X Server 1.11.3
Release Date: 2011-12-16
[     8.276] X Protocol Version 11, Revision 0
[     8.276] Build Operating System: Linux 3.1.5-1-ARCH x86_64 
[     8.276] Current Operating System: Linux charlie 3.2.1-1-ARCH #1 SMP PREEMPT Fri Jan 13 06:50:31 CET 2012 x86_64
[     8.276] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=/dev/sda2 ro radeon.modeset=1 quiet resume=/dev/sda3 loglevel=3 logo.nologo console=tty1 splash=silent,fadein,fadeout,theme:archlinux-deep-aurora
[     8.276] Build Date: 17 December 2011  09:17:41AM
[     8.276]  
[     8.276] Current version of pixman: 0.24.0
[     8.276] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[     8.276] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[     8.277] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Jan 19 19:02:51 2012
[     8.284] (==) Using config directory: "/etc/X11/xorg.conf.d"
[     8.287] (==) No Layout section.  Using the first Screen section.
[     8.287] (==) No screen section available. Using defaults.
[     8.287] (**) |-->Screen "Default Screen Section" (0)
[     8.287] (**) |   |-->Monitor "<default monitor>"
[     8.289] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[     8.289] (==) Automatically adding devices
[     8.289] (==) Automatically enabling devices
[     8.299] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[     8.299] 	Entry deleted from font path.
[     8.307] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/100dpi/".
[     8.307] 	Entry deleted from font path.
[     8.307] 	(Run 'mkfontdir' on "/usr/share/fonts/100dpi/").
[     8.308] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/75dpi/".
[     8.308] 	Entry deleted from font path.
[     8.308] 	(Run 'mkfontdir' on "/usr/share/fonts/75dpi/").
[     8.308] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/
[     8.308] (==) ModulePath set to "/usr/lib/xorg/modules"
[     8.308] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[     8.308] (II) Loader magic: 0x7ccae0
[     8.308] (II) Module ABI versions:
[     8.308] 	X.Org ANSI C Emulation: 0.4
[     8.308] 	X.Org Video Driver: 11.0
[     8.308] 	X.Org XInput driver : 13.0
[     8.308] 	X.Org Server Extension : 6.0
[     8.310] (--) PCI:*(0:0:1:0) 1002:9807:1025:0577 rev 0, Mem @ 0x80000000/268435456, 0x90100000/262144, I/O @ 0x00002000/256
[     8.310] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[     8.310] (II) LoadModule: "extmod"
[     8.318] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[     8.322] (II) Module extmod: vendor="X.Org Foundation"
[     8.322] 	compiled for 1.11.3, module version = 1.0.0
[     8.322] 	Module class: X.Org Server Extension
[     8.322] 	ABI class: X.Org Server Extension, version 6.0
[     8.322] (II) Loading extension MIT-SCREEN-SAVER
[     8.322] (II) Loading extension XFree86-VidModeExtension
[     8.322] (II) Loading extension XFree86-DGA
[     8.322] (II) Loading extension DPMS
[     8.322] (II) Loading extension XVideo
[     8.322] (II) Loading extension XVideo-MotionCompensation
[     8.322] (II) Loading extension X-Resource
[     8.322] (II) LoadModule: "dbe"
[     8.323] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[     8.324] (II) Module dbe: vendor="X.Org Foundation"
[     8.325] 	compiled for 1.11.3, module version = 1.0.0
[     8.325] 	Module class: X.Org Server Extension
[     8.325] 	ABI class: X.Org Server Extension, version 6.0
[     8.325] (II) Loading extension DOUBLE-BUFFER
[     8.325] (II) LoadModule: "glx"
[     8.325] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[     8.330] (II) Module glx: vendor="X.Org Foundation"
[     8.330] 	compiled for 1.11.3, module version = 1.0.0
[     8.330] 	ABI class: X.Org Server Extension, version 6.0
[     8.330] (==) AIGLX enabled
[     8.330] (II) Loading extension GLX
[     8.331] (II) LoadModule: "record"
[     8.331] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[     8.333] (II) Module record: vendor="X.Org Foundation"
[     8.333] 	compiled for 1.11.3, module version = 1.13.0
[     8.333] 	Module class: X.Org Server Extension
[     8.333] 	ABI class: X.Org Server Extension, version 6.0
[     8.333] (II) Loading extension RECORD
[     8.333] (II) LoadModule: "dri"
[     8.334] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[     8.337] (II) Module dri: vendor="X.Org Foundation"
[     8.337] 	compiled for 1.11.3, module version = 1.0.0
[     8.337] 	ABI class: X.Org Server Extension, version 6.0
[     8.337] (II) Loading extension XFree86-DRI
[     8.337] (II) LoadModule: "dri2"
[     8.337] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[     8.339] (II) Module dri2: vendor="X.Org Foundation"
[     8.339] 	compiled for 1.11.3, module version = 1.2.0
[     8.339] 	ABI class: X.Org Server Extension, version 6.0
[     8.339] (II) Loading extension DRI2
[     8.339] (==) Matched ati as autoconfigured driver 0
[     8.339] (==) Matched vesa as autoconfigured driver 1
[     8.339] (==) Matched fbdev as autoconfigured driver 2
[     8.339] (==) Assigned the driver to the xf86ConfigLayout
[     8.339] (II) LoadModule: "ati"
[     8.340] (II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
[     8.341] (II) Module ati: vendor="X.Org Foundation"
[     8.341] 	compiled for 1.11.1.902, module version = 6.14.3
[     8.341] 	Module class: X.Org Video Driver
[     8.341] 	ABI class: X.Org Video Driver, version 11.0
[     8.341] (II) LoadModule: "radeon"
[     8.342] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     8.351] (II) Module radeon: vendor="X.Org Foundation"
[     8.352] 	compiled for 1.11.1.902, module version = 6.14.3
[     8.352] 	Module class: X.Org Video Driver
[     8.352] 	ABI class: X.Org Video Driver, version 11.0
[     8.354] (II) LoadModule: "vesa"
[     8.354] (WW) Warning, couldn't open module vesa
[     8.354] (II) UnloadModule: "vesa"
[     8.354] (II) Unloading vesa
[     8.354] (EE) Failed to load module "vesa" (module does not exist, 0)
[     8.354] (II) LoadModule: "fbdev"
[     8.355] (WW) Warning, couldn't open module fbdev
[     8.355] (II) UnloadModule: "fbdev"
[     8.355] (II) Unloading fbdev
[     8.355] (EE) Failed to load module "fbdev" (module does not exist, 0)
[     8.355] (II) RADEON: Driver for ATI Radeon chipsets:
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
	ATI Radeon 3000 Graphics, SUMO, SUMO, SUMO2, SUMO2, SUMO2, SUMO2,
	SUMO, SUMO, SUMO, SUMO, SUMO, ATI Radeon HD 4200, ATI Radeon 4100,
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
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS
[     8.367] (++) using VT number 7

[     8.367] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     8.367] (II) [KMS] Kernel modesetting enabled.
[     8.369] (II) RADEON(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[     8.369] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[     8.369] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[     8.369] (==) RADEON(0): Default visual is TrueColor
[     8.369] (==) RADEON(0): RGB weight 888
[     8.369] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[     8.369] (--) RADEON(0): Chipset: "AMD Radeon HD 6200 Series Graphics" (ChipID = 0x9807)
[     8.369] (II) RADEON(0): PCIE card detected
[     8.369] drmOpenDevice: node name is /dev/dri/card0
[     8.369] drmOpenDevice: open result is 11, (OK)
[     8.369] drmOpenByBusid: Searching for BusID pci:0000:00:01.0
[     8.369] drmOpenDevice: node name is /dev/dri/card0
[     8.369] drmOpenDevice: open result is 11, (OK)
[     8.369] drmOpenByBusid: drmOpenMinor returns 11
[     8.369] drmOpenByBusid: drmGetBusid reports pci:0000:00:01.0
[     8.370] (II) Loading sub module "exa"
[     8.370] (II) LoadModule: "exa"
[     8.370] (II) Loading /usr/lib/xorg/modules/libexa.so
[     8.372] (II) Module exa: vendor="X.Org Foundation"
[     8.372] 	compiled for 1.11.3, module version = 2.5.0
[     8.372] 	ABI class: X.Org Video Driver, version 11.0
[     8.372] (II) RADEON(0): KMS Color Tiling: enabled
[     8.372] (II) RADEON(0): KMS Pageflipping: enabled
[     8.372] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[     8.373] (II) RADEON(0): Output LVDS has no monitor section
[     8.377] (II) RADEON(0): Output HDMI-0 has no monitor section
[     8.377] (II) RADEON(0): EDID for output LVDS
[     8.377] (II) RADEON(0): Manufacturer: AUO  Model: 53d4  Serial#: 0
[     8.377] (II) RADEON(0): Year: 2010  Week: 0
[     8.378] (II) RADEON(0): EDID Version: 1.4
[     8.378] (II) RADEON(0): Digital Display Input
[     8.378] (II) RADEON(0): 6 bits per channel
[     8.378] (II) RADEON(0): Digital interface is undefined
[     8.378] (II) RADEON(0): Max Image Size [cm]: horiz.: 22  vert.: 14
[     8.378] (II) RADEON(0): Gamma: 2.20
[     8.378] (II) RADEON(0): No DPMS capabilities specified
[     8.378] (II) RADEON(0): Supported color encodings: RGB 4:4:4 
[     8.378] (II) RADEON(0): First detailed timing is preferred mode
[     8.378] (II) RADEON(0): Preferred mode is native pixel format and refresh rate
[     8.378] (II) RADEON(0): redX: 0.581 redY: 0.340   greenX: 0.326 greenY: 0.558
[     8.378] (II) RADEON(0): blueX: 0.153 blueY: 0.138   whiteX: 0.313 whiteY: 0.329
[     8.378] (II) RADEON(0): Manufacturer's mask: 0
[     8.378] (II) RADEON(0): Supported detailed timing:
[     8.378] (II) RADEON(0): clock: 71.2 MHz   Image Size:  216 x 135 mm
[     8.378] (II) RADEON(0): h_active: 1280  h_sync: 1288  h_sync_end 1298 h_blank_end 1464 h_border: 0
[     8.378] (II) RADEON(0): v_active: 800  v_sync: 803  v_sync_end 804 v_blanking: 808 v_border: 0
[     8.378] (II) RADEON(0): Unknown vendor-specific block f
[     8.378] (II) RADEON(0):  AUO
[     8.378] (II) RADEON(0):  B101EW05 V3
[     8.378] (II) RADEON(0): EDID (in hex):
[     8.378] (II) RADEON(0): 	00ffffffffffff0006afd45300000000
[     8.378] (II) RADEON(0): 	0014010490160e7802cb559457538e27
[     8.378] (II) RADEON(0): 	23505400000001010101010101010101
[     8.378] (II) RADEON(0): 	010101010101d01b00b850200830080a
[     8.378] (II) RADEON(0): 	3100d887000000180000000f00000000
[     8.378] (II) RADEON(0): 	00000000000000000020000000fe0041
[     8.378] (II) RADEON(0): 	554f0a202020202020202020000000fe
[     8.378] (II) RADEON(0): 	004231303145573035205633200a0012
[     8.378] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[     8.379] (II) RADEON(0): Printing DDC gathered Modelines:
[     8.379] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[     8.379] (II) RADEON(0): Printing probed modes for output LVDS
[     8.379] (II) RADEON(0): Modeline "1280x800"x60.2   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[     8.379] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[     8.379] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[     8.379] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[     8.379] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
[     8.379] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1056  480 483 493 500 -hsync +vsync (29.8 kHz)
[     8.379] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 896  480 483 493 500 -hsync +vsync (29.9 kHz)
[     8.379] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
[     8.383] (II) RADEON(0): EDID for output HDMI-0
[     8.383] (II) RADEON(0): Output LVDS connected
[     8.383] (II) RADEON(0): Output HDMI-0 disconnected
[     8.383] (II) RADEON(0): Using exact sizes for initial modes
[     8.383] (II) RADEON(0): Output LVDS using initial mode 1280x800
[     8.383] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[     8.383] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:18000000 visible:fbd8000
[     8.383] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[     8.384] (**) RADEON(0): Display dimensions: (220, 140) mm
[     8.384] (**) RADEON(0): DPI set to (147, 145)
[     8.384] (II) Loading sub module "fb"
[     8.384] (II) LoadModule: "fb"
[     8.384] (II) Loading /usr/lib/xorg/modules/libfb.so
[     8.387] (II) Module fb: vendor="X.Org Foundation"
[     8.387] 	compiled for 1.11.3, module version = 1.0.0
[     8.387] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     8.387] (II) Loading sub module "ramdac"
[     8.388] (II) LoadModule: "ramdac"
[     8.388] (II) Module "ramdac" already built-in
[     8.388] (--) Depth 24 pixmap format is 32 bpp
[     8.389] (II) RADEON(0): [DRI2] Setup complete
[     8.389] (II) RADEON(0): [DRI2]   DRI driver: r600
[     8.389] (II) RADEON(0): [DRI2]   VDPAU driver: r600
[     8.390] (II) RADEON(0): Front buffer size: 4000K
[     8.390] (II) RADEON(0): VRAM usage limit set to 228499K
[     8.392] (==) RADEON(0): Backing store disabled
[     8.392] (II) RADEON(0): Direct rendering enabled
[     8.394] (II) RADEON(0): Setting EXA maxPitchBytes
[     8.394] (II) EXA(0): Driver allocated offscreen pixmaps
[     8.394] (II) EXA(0): Driver registered support for the following operations:
[     8.394] (II)         Solid
[     8.394] (II)         Copy
[     8.394] (II)         Composite (RENDER acceleration)
[     8.394] (II)         UploadToScreen
[     8.394] (II)         DownloadFromScreen
[     8.394] (II) RADEON(0): Acceleration enabled
[     8.394] (==) RADEON(0): DPMS enabled
[     8.394] (==) RADEON(0): Silken mouse enabled
[     8.396] (II) RADEON(0): Set up textured video
[     8.396] (II) RADEON(0): [XvMC] Associated with Radeon Textured Video.
[     8.396] (II) RADEON(0): [XvMC] Extension initialized.
[     8.396] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[     8.397] (--) RandR disabled
[     8.397] (II) Initializing built-in extension Generic Event Extension
[     8.397] (II) Initializing built-in extension SHAPE
[     8.397] (II) Initializing built-in extension MIT-SHM
[     8.397] (II) Initializing built-in extension XInputExtension
[     8.397] (II) Initializing built-in extension XTEST
[     8.397] (II) Initializing built-in extension BIG-REQUESTS
[     8.397] (II) Initializing built-in extension SYNC
[     8.397] (II) Initializing built-in extension XKEYBOARD
[     8.397] (II) Initializing built-in extension XC-MISC
[     8.397] (II) Initializing built-in extension SECURITY
[     8.397] (II) Initializing built-in extension XINERAMA
[     8.397] (II) Initializing built-in extension XFIXES
[     8.397] (II) Initializing built-in extension RENDER
[     8.397] (II) Initializing built-in extension RANDR
[     8.397] (II) Initializing built-in extension COMPOSITE
[     8.397] (II) Initializing built-in extension DAMAGE
[     8.499] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[     8.499] (II) AIGLX: enabled GLX_INTEL_swap_event
[     8.499] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[     8.499] (II) AIGLX: enabled GLX_SGI_make_current_read
[     8.499] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[     8.500] (II) AIGLX: Loaded and initialized r600
[     8.500] (II) GLX: Initialized DRI2 GL provider for screen 0
[     8.505] (II) RADEON(0): Setting screen physical size to 338 x 211
[     8.677] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[     8.677] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     8.677] (II) LoadModule: "evdev"
[     8.677] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.679] (II) Module evdev: vendor="X.Org Foundation"
[     8.679] 	compiled for 1.10.99.902, module version = 2.6.0
[     8.679] 	Module class: X.Org XInput Driver
[     8.679] 	ABI class: X.Org XInput driver, version 13.0
[     8.679] (II) Using input driver 'evdev' for 'Power Button'
[     8.679] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.679] (**) Power Button: always reports core events
[     8.679] (**) Power Button: Device: "/dev/input/event3"
[     8.679] (--) Power Button: Found keys
[     8.679] (II) Power Button: Configuring as keyboard
[     8.680] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[     8.680] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[     8.680] (**) Option "xkb_rules" "evdev"
[     8.680] (**) Option "xkb_model" "evdev"
[     8.680] (**) Option "xkb_layout" "us"
[     8.760] (II) config/udev: Adding input device Video Bus (/dev/input/event4)
[     8.761] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[     8.761] (II) Using input driver 'evdev' for 'Video Bus'
[     8.761] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.761] (**) Video Bus: always reports core events
[     8.761] (**) Video Bus: Device: "/dev/input/event4"
[     8.761] (--) Video Bus: Found keys
[     8.761] (II) Video Bus: Configuring as keyboard
[     8.761] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4/event4"
[     8.761] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[     8.761] (**) Option "xkb_rules" "evdev"
[     8.761] (**) Option "xkb_model" "evdev"
[     8.761] (**) Option "xkb_layout" "us"
[     8.762] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[     8.762] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     8.762] (II) Using input driver 'evdev' for 'Power Button'
[     8.762] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.763] (**) Power Button: always reports core events
[     8.763] (**) Power Button: Device: "/dev/input/event1"
[     8.763] (--) Power Button: Found keys
[     8.763] (II) Power Button: Configuring as keyboard
[     8.763] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1/event1"
[     8.763] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 8)
[     8.763] (**) Option "xkb_rules" "evdev"
[     8.763] (**) Option "xkb_model" "evdev"
[     8.763] (**) Option "xkb_layout" "us"
[     8.764] (II) config/udev: Adding input device Lid Switch (/dev/input/event2)
[     8.764] (II) No input driver/identifier specified (ignoring)
[     8.765] (II) config/udev: Adding input device HD-Audio Generic HDMI/DP,pcm=3 (/dev/input/event7)
[     8.765] (II) No input driver/identifier specified (ignoring)
[     8.766] (II) config/udev: Adding input device 1.3M Rear (/dev/input/event5)
[     8.766] (**) 1.3M Rear: Applying InputClass "evdev keyboard catchall"
[     8.766] (II) Using input driver 'evdev' for '1.3M Rear'
[     8.766] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.766] (**) 1.3M Rear: always reports core events
[     8.766] (**) 1.3M Rear: Device: "/dev/input/event5"
[     8.766] (--) 1.3M Rear: Found keys
[     8.766] (II) 1.3M Rear: Configuring as keyboard
[     8.766] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:13.2/usb2/2-3/2-3:1.0/input/input5/event5"
[     8.767] (II) XINPUT: Adding extended input device "1.3M Rear" (type: KEYBOARD, id 9)
[     8.767] (**) Option "xkb_rules" "evdev"
[     8.767] (**) Option "xkb_model" "evdev"
[     8.767] (**) Option "xkb_layout" "us"
[     8.768] (II) config/udev: Adding input device 1.3M Front (/dev/input/event6)
[     8.768] (**) 1.3M Front: Applying InputClass "evdev keyboard catchall"
[     8.768] (II) Using input driver 'evdev' for '1.3M Front'
[     8.768] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.768] (**) 1.3M Front: always reports core events
[     8.768] (**) 1.3M Front: Device: "/dev/input/event6"
[     8.768] (--) 1.3M Front: Found keys
[     8.768] (II) 1.3M Front: Configuring as keyboard
[     8.769] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4:1.0/input/input7/event6"
[     8.769] (II) XINPUT: Adding extended input device "1.3M Front" (type: KEYBOARD, id 10)
[     8.769] (**) Option "xkb_rules" "evdev"
[     8.769] (**) Option "xkb_model" "evdev"
[     8.769] (**) Option "xkb_layout" "us"
[     8.770] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event8)
[     8.770] (II) No input driver/identifier specified (ignoring)
[     8.771] (II) config/udev: Adding input device HDA ATI SB Headphone (/dev/input/event9)
[     8.771] (II) No input driver/identifier specified (ignoring)
[     8.772] (II) config/udev: Adding input device SONiX USB Keyboard (/dev/input/event11)
[     8.772] (**) SONiX USB Keyboard: Applying InputClass "evdev keyboard catchall"
[     8.772] (II) Using input driver 'evdev' for 'SONiX USB Keyboard'
[     8.772] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.772] (**) SONiX USB Keyboard: always reports core events
[     8.772] (**) SONiX USB Keyboard: Device: "/dev/input/event11"
[     8.772] (--) SONiX USB Keyboard: Found keys
[     8.772] (II) SONiX USB Keyboard: Configuring as keyboard
[     8.772] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:16.2/usb3/3-1/3-1.2/3-1.2:1.0/input/input11/event11"
[     8.772] (II) XINPUT: Adding extended input device "SONiX USB Keyboard" (type: KEYBOARD, id 11)
[     8.772] (**) Option "xkb_rules" "evdev"
[     8.772] (**) Option "xkb_model" "evdev"
[     8.772] (**) Option "xkb_layout" "us"
[     8.774] (II) config/udev: Adding input device SONiX USB Keyboard (/dev/input/event12)
[     8.774] (**) SONiX USB Keyboard: Applying InputClass "evdev pointer catchall"
[     8.774] (**) SONiX USB Keyboard: Applying InputClass "evdev keyboard catchall"
[     8.774] (II) Using input driver 'evdev' for 'SONiX USB Keyboard'
[     8.774] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.774] (**) SONiX USB Keyboard: always reports core events
[     8.774] (**) SONiX USB Keyboard: Device: "/dev/input/event12"
[     8.775] (--) SONiX USB Keyboard: Found 9 mouse buttons
[     8.775] (--) SONiX USB Keyboard: Found scroll wheel(s)
[     8.775] (--) SONiX USB Keyboard: Found relative axes
[     8.775] (--) SONiX USB Keyboard: Found x and y relative axes
[     8.775] (--) SONiX USB Keyboard: Found absolute axes
[     8.775] (--) SONiX USB Keyboard: Found keys
[     8.775] (II) SONiX USB Keyboard: Configuring as mouse
[     8.775] (II) SONiX USB Keyboard: Configuring as keyboard
[     8.775] (II) SONiX USB Keyboard: Adding scrollwheel support
[     8.775] (**) SONiX USB Keyboard: YAxisMapping: buttons 4 and 5
[     8.775] (**) SONiX USB Keyboard: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     8.775] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:16.2/usb3/3-1/3-1.2/3-1.2:1.1/input/input12/event12"
[     8.775] (II) XINPUT: Adding extended input device "SONiX USB Keyboard" (type: KEYBOARD, id 12)
[     8.775] (**) Option "xkb_rules" "evdev"
[     8.775] (**) Option "xkb_model" "evdev"
[     8.775] (**) Option "xkb_layout" "us"
[     8.776] (II) SONiX USB Keyboard: initialized for relative axes.
[     8.776] (WW) SONiX USB Keyboard: ignoring absolute axes.
[     8.776] (**) SONiX USB Keyboard: (accel) keeping acceleration scheme 1
[     8.776] (**) SONiX USB Keyboard: (accel) acceleration profile 0
[     8.776] (**) SONiX USB Keyboard: (accel) acceleration factor: 2.000
[     8.776] (**) SONiX USB Keyboard: (accel) acceleration threshold: 4
[     8.777] (II) config/udev: Adding input device SONiX USB Keyboard (/dev/input/mouse0)
[     8.777] (II) No input driver/identifier specified (ignoring)
[     8.778] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[     8.778] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[     8.778] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[     8.778] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.778] (**) AT Translated Set 2 keyboard: always reports core events
[     8.778] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[     8.778] (--) AT Translated Set 2 keyboard: Found keys
[     8.778] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[     8.779] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[     8.779] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 13)
[     8.779] (**) Option "xkb_rules" "evdev"
[     8.779] (**) Option "xkb_model" "evdev"
[     8.779] (**) Option "xkb_layout" "us"
[     8.781] (II) config/udev: Adding input device Acer WMI hotkeys (/dev/input/event10)
[     8.781] (**) Acer WMI hotkeys: Applying InputClass "evdev keyboard catchall"
[     8.781] (II) Using input driver 'evdev' for 'Acer WMI hotkeys'
[     8.781] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.781] (**) Acer WMI hotkeys: always reports core events
[     8.781] (**) Acer WMI hotkeys: Device: "/dev/input/event10"
[     8.781] (--) Acer WMI hotkeys: Found keys
[     8.781] (II) Acer WMI hotkeys: Configuring as keyboard
[     8.781] (**) Option "config_info" "udev:/sys/devices/virtual/input/input10/event10"
[     8.781] (II) XINPUT: Adding extended input device "Acer WMI hotkeys" (type: KEYBOARD, id 14)
[     8.781] (**) Option "xkb_rules" "evdev"
[     8.781] (**) Option "xkb_model" "evdev"
[     8.781] (**) Option "xkb_layout" "us"
[    17.404] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    17.404] (II) RADEON(0): Printing DDC gathered Modelines:
[    17.404] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    17.409] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    17.409] (II) RADEON(0): Printing DDC gathered Modelines:
[    17.409] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    18.121] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    18.121] (II) RADEON(0): Printing DDC gathered Modelines:
[    18.121] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    18.130] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    18.131] (II) RADEON(0): Printing DDC gathered Modelines:
[    18.131] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    18.144] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    18.144] (II) RADEON(0): Printing DDC gathered Modelines:
[    18.144] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)
[    23.168] (II) RADEON(0): EDID vendor "AUO", prod id 21460
[    23.168] (II) RADEON(0): Printing DDC gathered Modelines:
[    23.168] (II) RADEON(0): Modeline "1280x800"x0.0   71.20  1280 1288 1298 1464  800 803 804 808 -hsync -vsync (48.6 kHz)

--------------010008000905040203000307--
