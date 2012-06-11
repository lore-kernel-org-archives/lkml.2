Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2FKOQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:16:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48801 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FKOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:16:40 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 11 Jun 2012 16:16:19 +0200
Message-ID: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
Subject: gma500: Cannot find any crtc or sizes - going 1024x768
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working with a custom/embedded device, which has the following device:

00:02.0 VGA compatible controller [0300]: Intel Corporation Atom
Processor E6xx Integrated Graphics Controller [8086:4108] (rev 05)
(prog-if 00 [VGA controller])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=1M]
        Region 1: I/O ports at f010 [size=8]
        Region 2: Memory at c0000000 (32-bit, non-prefetchable) [size=256M]
        Region 3: Memory at d04c0000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] Vendor Specific Information: Len=07 <?>
        Kernel driver in use: gma500
        Kernel modules: gma500_gfx


At the moment (kernel 3.2.20) I am using this device with the vesa
driver, but I tested 3.5-rc2+ on the
device with the gma500 driver.


[    7.885054] gma500 0000:00:02.0: setting latency timer to 64
[    7.885395] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[    7.885408] [drm:psb_intel_opregion_setup], ASLE supported
[    7.885435] gma500 0000:00:02.0: Enabling MSI failed!
[    7.885542] [drm] internal display is MIPI display
[    7.885658] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
[    7.885759] gma500 0000:00:02.0: Unable to read GCT!
[    7.895613] hub 6-0:1.0: USB hub found
[    7.895897] hub 6-0:1.0: 1 port detected
[    7.896700] ohci_hcd 0000:02:08.1: setting latency timer to 64
[    7.896721] ohci_hcd 0000:02:08.1: OHCI Host Controller
[    7.896837] ohci_hcd 0000:02:08.1: new USB bus registered, assigned
bus number 7
[    7.897221] ohci_hcd 0000:02:08.1: irq 16, io mem 0xd014e000
[    7.914951] gma500 0000:00:02.0: VBT signature missing
[    7.918090] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    7.952691] hub 7-0:1.0: USB hub found
[    7.952805] hub 7-0:1.0: 1 port detected
[    7.953218] ohci_hcd 0000:02:08.2: setting latency timer to 64
[    7.953238] ohci_hcd 0000:02:08.2: OHCI Host Controller
[    7.953358] ohci_hcd 0000:02:08.2: new USB bus registered, assigned
bus number 8
[    7.953520] ohci_hcd 0000:02:08.2: irq 16, io mem 0xd014d000
[    8.008855] hub 8-0:1.0: USB hub found
[    8.008969] hub 8-0:1.0: 1 port detected
[    8.033279] hub 1-1:1.0: USB hub found
[    8.033503] hub 1-1:1.0: 3 ports detected
[    8.063001] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.063127] [drm] No driver support for vblank timestamp query.
[    8.063369] gma500 0000:00:02.0: DSI is not supported
[    8.113473] No connectors reported connected with modes
[    8.113575] [drm:drm_setup_crtcs],
[    8.113591] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[    8.113601] [drm] Cannot find any crtc or sizes - going 1024x768
[    8.125973] fbcon: psbfb (fb0) is primary device
[    8.127827] [drm:drm_crtc_helper_set_config],
[    8.127835] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    8.168231] [drm:drm_crtc_helper_set_config],
[    8.168238] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB]
[    8.231312] Console: switching to colour frame buffer device 128x48
[    8.257610] fb0: psbfb frame buffer device
[    8.257807] drm: registered panic notifier
[    8.258049] [drm] Initialized gma500 1.0.0 2011-06-06 for
0000:00:02.0 on minor 0
[    8.353090] usb 6-1: new full-speed USB device number 2 using ohci_hcd
[    8.526496] usbcore: registered new interface driver usbhid
[    8.526757] usbhid: USB HID core driver
[    8.536574] input: DIALOGUE INC PenMount USB as
/devices/pci0000:00/0000:00:17.0/0000:01:00.0/0000:02:08.0/usb6/6-1/6-1:1.0/input/input0
[    8.537561] hid-generic 0003:14E1:6000.0001: input: USB HID v1.01
Mouse [DIALOGUE INC PenMount USB] on usb-0000:02:08.0-1/input0
[    8.770647] EXT3-fs (sda2): using internal journal
[    9.043119] kjournald starting.  Commit interval 5 seconds


An run into this problem - there may be some more:
Cannot find any crtc or sizes - going 1024x768

Depending on the connected display, there are two ways the panel is connected.

1) up to WVGA - LVDS
2) else SDVO

There is no EDID available.. it is only possible to read out the
defined display resolution
via an at24 eeprom found on the i2c bus of the device.


I tried my luck with following xorg.conf

Section "Monitor"
        Identifier      "OT display"
EndSection

Section "Device"
        Identifier      "OT graphic card"
        Driver          "fbdev"
EndSection

Section "Screen"
        Identifier      "OT screen"
        Device          "OT graphic card"
        Monitor         "OT display"
        DefaultDepth    16
        SubSection "Display"
                Depth   16
                Modes   "640x480"
        EndSubSection
EndSection

Section "ServerLayout"
       Identifier   "Base layout"
       Screen       "OT screen"
EndSection

Section "InputClass"
        Identifier "keyboard layout"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "XkbLayout" "us"
EndSection

Section "ServerFlags"
        Option  "Xinerama" "Off"
EndSection


(**) FBDEV(0): claimed PCI slot 0@0:2:0
(II) FBDEV(0): using default device
(WW) VGA arbiter: cannot open kernel arbiter, no multi-card support
(**) FBDEV(0): Depth 16, (--) framebuffer bpp 16
(==) FBDEV(0): RGB weight 565
(==) FBDEV(0): Default visual is TrueColor
(==) FBDEV(0): Using gamma correction (1.0, 1.0, 1.0)
(II) FBDEV(0): hardware: psbfb (video memory: 3072kB)
(II) FBDEV(0): checking modes against framebuffer device...
(EE) FBDEV(0): FBIOPUT_VSCREENINFO: Invalid argument
(II) FBDEV(0):  mode "640x480" test failed
(II) FBDEV(0): checking modes against monitor...
(--) FBDEV(0): Virtual size is 1024x768 (pitch 1024)
(**) FBDEV(0):  Built-in mode "current"
(==) FBDEV(0): DPI set to (96, 96)
(II) Loading sub module "fb"


So... what options do I have to fix my problems?

thanks
---
Christian Gmeiner, MSc
