Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2FCR0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 13:26:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63743 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2FCR0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 13:26:37 -0400
MIME-Version: 1.0
X-Originating-IP: [41.212.116.88]
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Sun, 3 Jun 2012 20:26:15 +0300
Message-ID: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
Subject: [Regression] [Radeon] Stream command failures and render problems in
 Evergreen (Radeon HD 5600) in kernel 3.4
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>
Content-Type: multipart/mixed; boundary=20cf3074b3162a6b8504c194b87b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3074b3162a6b8504c194b87b
Content-Type: text/plain; charset=ISO-8859-1

Hello,

3.4 breaks rendering on my Radeon evergreen card. Immediately after
logging in into the desktop, I get the following errors in the kernel
log:

radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
575)
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
surf: (192 192) (0 4 1 0 0 0 0)
radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
[drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
575)
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
surf: (192 192) (0 4 1 0 0 0 0)
radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
[drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
small (layer size 798720, offset 0, max layer 1, bo size 794624, slice
3119)
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
surf: (384 520) (0 4 1 0 0 0 0)
radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
[drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
small (layer size 458752, offset 0, max layer 1, bo size 446464, slice
1791)
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
surf: (512 224) (0 4 1 0 0 0 0)
radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 7170
[drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
small (layer size 798720, offset 0, max layer 1, bo size 790528, slice
3119)
radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
surf: (384 520) (0 4 1 0 0 0 0)
radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
[drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !

Meanwhile, windows on the desktop are rendered incorrectly (with
certain regions covered by strange patterns or smudged) or not at all.
This makes the desktop unusable.

I can always reproduce this problem on 3.4

Kernels prior to 3.4 work fine.

I will try and find the time to bisect this issue but meanwhile here
are some further details:

Output of lspci -v
--------------------------

00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 18)
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16
Root Port (rev 18) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:16.0 Communication controller: Intel Corporation 5 Series/3400
Series Chipset HECI Controller (rev 06)
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0, IRQ 48
	Memory at fbf09000 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>
	Kernel driver in use: mei
	Kernel modules: mei

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0447
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at fbf08000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
High Definition Audio (rev 06)
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0, IRQ 50
	Memory at fbf00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=11, subordinate=11, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d1800000-d19fffff
	Prefetchable memory behind bridge: 00000000d1a00000-00000000d1bfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 2 (rev 06) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=12, subordinate=12, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000d1600000-00000000d17fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 3 (rev 06) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=13, subordinate=13, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fb300000-fbcfffff
	Prefetchable memory behind bridge: 00000000d0c00000-00000000d15fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 5 (rev 06) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=15, subordinate=15, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fa900000-fb2fffff
	Prefetchable memory behind bridge: 00000000d0100000-00000000d0afffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0447
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at fbf07000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
(prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=20, subordinate=20, sec-latency=32
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
Interface Controller (rev 06)
	Subsystem: Dell Device 0447
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series
Chipset 6 port SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 0447
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 46
	I/O ports at f070 [size=8]
	I/O ports at f060 [size=4]
	I/O ports at f050 [size=8]
	I/O ports at f040 [size=4]
	I/O ports at f020 [size=32]
	Memory at fbf06000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
Controller (rev 06)
	Subsystem: Dell Device 0447
	Flags: medium devsel, IRQ 3
	Memory at fbf05000 (64-bit, non-prefetchable) [size=256]
	I/O ports at f000 [size=32]
	Kernel modules: i2c-i801

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
Series Chipset Thermal Subsystem (rev 06)
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at fbf04000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel ips
	Kernel modules: intel_ips

01:00.0 VGA compatible controller: ATI Technologies Inc Redwood
[Radeon HD 5600 Series] (prog-if 00 [VGA controller])
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0, IRQ 47
	Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Memory at fbe20000 (64-bit, non-prefetchable) [size=128K]
	I/O ports at e000 [size=256]
	Expansion ROM at fbe00000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: radeon
	Kernel modules: radeon

01:00.1 Audio device: ATI Technologies Inc Redwood HDMI Audio [Radeon
HD 5600 Series]
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0, IRQ 51
	Memory at fbe40000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

12:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
	Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
	Flags: bus master, fast devsel, latency 0, IRQ 49
	Memory at fbd00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi

13:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
	Subsystem: Dell Device 0447
	Flags: bus master, fast devsel, latency 0, IRQ 45
	I/O ports at d000 [size=256]
	Memory at d0c10000 (64-bit, prefetchable) [size=4K]
	Memory at d0c00000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at fb300000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: r8169
	Kernel modules: r8169

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath
Architecture Generic Non-core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath
Architecture System Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

First stable kernel version exhibiting the problem
----------------------------------------------------------------------------

3.4.0 (From kernel.org)

Distribution
--------------------

Ubuntu 11.04

Xorg Packages/ Drivers
-------------------------------------

ii  xorg                                      1:7.6+4ubuntu3.2
                                 X.Org X Window System
ii  xorg-docs-core                            1:1.5.99.901-1ubuntu1
                                 Core documentation for the X.org X
Window System
ii  xorg-sgml-doctools                        1:1.6-1
                                 Common tools for building X.Org SGML
documentation
ii  xserver-xorg                              1:7.6+4ubuntu3.2
                                 the X.Org X server
ii  xserver-xorg-core                         2:1.10.1-1ubuntu1.3
                                 Xorg X server - core server
ii  xserver-xorg-core-dbg                     2:1.10.1-1ubuntu1.3
                                 Xorg - the X.Org X server (debugging
symbols)
ii  xserver-xorg-input-all                    1:7.6+4ubuntu3.2
                                 the X.Org X server -- input driver
metapackage
ii  xserver-xorg-input-evdev                  1:2.6.0-1ubuntu12
                                 X.Org X server -- evdev input driver
ii  xserver-xorg-input-mouse                  1:1.6.0-1ubuntu3
                                 X.Org X server -- mouse input driver
ii  xserver-xorg-input-synaptics
1.3.99+git20110116.0e27ce3a-0ubuntu12.1                   Synaptics
TouchPad driver for X.Org server
ii  xserver-xorg-input-vmmouse                1:12.6.99.901-1ubuntu2
                                 X.Org X server -- VMMouse input
driver to use with VMWare
ii  xserver-xorg-input-wacom                  1:0.10.11-0ubuntu4
                                 X.Org X server -- Wacom input driver
ii  xserver-xorg-video-all                    1:7.6+4ubuntu3.2
                                 the X.Org X server -- output driver
metapackage
ii  xserver-xorg-video-apm                    1:1.2.3-0ubuntu5
                                 X.Org X server -- APM display driver
ii  xserver-xorg-video-ark                    1:0.7.3-1ubuntu3
                                 X.Org X server -- ark display driver
ii  xserver-xorg-video-ati                    1:6.14.0-0ubuntu4.1
                                 X.Org X server -- AMD/ATI display
driver wrapper
ii  xserver-xorg-video-chips                  1:1.2.3-2ubuntu5
                                 X.Org X server -- Chips display
driver
ii  xserver-xorg-video-cirrus                 1:1.3.2-2ubuntu7
                                 X.Org X server -- Cirrus display
driver
ii  xserver-xorg-video-fbdev                  1:0.4.2-3ubuntu6
                                 X.Org X server -- fbdev display
driver
ii  xserver-xorg-video-i128                   1:1.3.4-1ubuntu3
                                 X.Org X server -- i128 display driver
ii  xserver-xorg-video-intel                  2:2.14.0-4ubuntu7.3
                                 X.Org X server -- Intel i8xx, i9xx
display driver
ii  xserver-xorg-video-mach64
6.8.2+git20101202.d60087f0-4ubuntu3                       X.Org X
server -- ATI Mach64 display driver
ii  xserver-xorg-video-mga                    1:1.4.13.dfsg-3build1
                                 X.Org X server -- MGA display driver
ii  xserver-xorg-video-neomagic               1:1.2.5-1ubuntu3
                                 X.Org X server -- Neomagic display
driver
ii  xserver-xorg-video-nouveau
1:0.0.16+git20110107+b795ca6e-0ubuntu7                    X.Org X
server -- Nouveau display driver (experimental)
ii  xserver-xorg-video-openchrome             1:0.2.904+svn916-1build1
                                 X.Org X server -- VIA display driver
ii  xserver-xorg-video-qxl                    0.0.12-1ubuntu4
                                 X.Org X server -- QXL display driver
ii  xserver-xorg-video-r128                   6.8.1-4ubuntu3
                                 X.Org X server -- ATI r128 display
driver
ii  xserver-xorg-video-radeon                 1:6.14.0-0ubuntu4.1
                                 X.Org X server -- AMD/ATI Radeon
display driver
ii  xserver-xorg-video-radeon-dbg             1:6.14.0-0ubuntu4.1
                                 X.Org X server -- AMD/ATI Radeon
display driver (debugging symbols)

Full dmesg output
-----------------------------

Please see attached.


'Please let me know if I should provide further details.

Thanks!

-- 
Brian Gitonga Marete
Toshnix Systems - http://toshnix.com

--20cf3074b3162a6b8504c194b87b
Content-Type: application/octet-stream; name=dmesg
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h30dq5l00

YXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2Rl
IDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMg
ZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCkVYVDQtZnMgKHNkYTEpOiByZS1tb3Vu
dGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD02MDAKYXRrYmQg
c2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQg
b24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8
a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkgcHJl
c3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4KYXRr
YmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0IGtu
b3duLgpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8s
dXNlcl94YXR0cixjb21taXQ9MAphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRy
YW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlv
MDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KYXRr
YmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4
OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAw
ZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCnVzYiAyLTEuMjogbmV3IGhpZ2gtc3BlZWQg
VVNCIGRldmljZSBudW1iZXIgNjIgdXNpbmcgZWhjaV9oY2QKc2NzaTI2IDogdXNiLXN0b3JhZ2Ug
Mi0xLjI6MS4wCnNjc2kgMjY6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgICAgICAgICAgIElkZW9z
ICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAyCnNjc2kgMjY6MDowOjE6IENELVJPTSAgICAg
ICAgICAgICAgICAgICAgIElkZW9zICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAyCnNkIDI2
OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cyIHR5cGUgMApzZCAyNjowOjA6MDogW3Nk
Yl0gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawpzcjE6IHNjc2kzLW1tYyBkcml2ZTogMHgv
MHggY2FkZHkKc3IgMjY6MDowOjE6IEF0dGFjaGVkIHNjc2kgQ0QtUk9NIHNyMQpzciAyNjowOjA6
MTogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMyB0eXBlIDUKdXNiIDItMS4yOiBVU0IgZGlzY29u
bmVjdCwgZGV2aWNlIG51bWJlciA2Mgp1c2IgMi0xLjI6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZp
Y2UgbnVtYmVyIDYzIHVzaW5nIGVoY2lfaGNkCnNjc2kyNyA6IHVzYi1zdG9yYWdlIDItMS4yOjEu
MApzY3NpIDI3OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICAgICAgICAgICBJZGVvcyAgICAgICAg
ICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzY3NpIDI3OjA6MDoxOiBDRC1ST00gICAgICAgICAgICAg
ICAgICAgICBJZGVvcyAgICAgICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzZCAyNzowOjA6MDog
QXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMiB0eXBlIDAKc3IxOiBzY3NpMy1tbWMgZHJpdmU6IDB4
LzB4IGNhZGR5CnNyIDI3OjA6MDoxOiBBdHRhY2hlZCBzY3NpIENELVJPTSBzcjEKc3IgMjc6MDow
OjE6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzMgdHlwZSA1CnNkIDI3OjA6MDowOiBbc2RiXSBB
dHRhY2hlZCBTQ1NJIHJlbW92YWJsZSBkaXNrCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogc2V0dGlu
ZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnVzYiAyLTEuMjogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBu
dW1iZXIgNjMKdXNiIDItMS4yOiBuZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA2NCB1
c2luZyBlaGNpX2hjZApzY3NpMjggOiB1c2Itc3RvcmFnZSAyLTEuMjoxLjAKc2NzaSAyODowOjA6
MDogRGlyZWN0LUFjY2VzcyAgICAgICAgICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAw
IEFOU0k6IDIKc2NzaSAyODowOjA6MTogQ0QtUk9NICAgICAgICAgICAgICAgICAgICAgSWRlb3Mg
ICAgICAgICAgICAwMDAwIFBROiAwIEFOU0k6IDIKc2QgMjg6MDowOjA6IEF0dGFjaGVkIHNjc2kg
Z2VuZXJpYyBzZzIgdHlwZSAwCnNyMTogc2NzaTMtbW1jIGRyaXZlOiAweC8weCBjYWRkeQpzZCAy
ODowOjA6MDogW3NkYl0gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawpzciAyODowOjA6MTog
QXR0YWNoZWQgc2NzaSBDRC1ST00gc3IxCnNyIDI4OjA6MDoxOiBBdHRhY2hlZCBzY3NpIGdlbmVy
aWMgc2czIHR5cGUgNQphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0
ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNl
ICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KRVhUNC1mcyAo
c2RhMSk6IHJlLW1vdW50ZWQuIE9wdHM6IGVycm9ycz1yZW1vdW50LXJvLHVzZXJfeGF0dHIsY29t
bWl0PTYwMApkZXZpY2UgdGFwMCBlbnRlcmVkIHByb21pc2N1b3VzIG1vZGUKRVhUNC1mcyAoc2Rh
MSk6IFVuYWxpZ25lZCBBSU8vRElPIG9uIGlub2RlIDI3NTI4ODgwIGJ5IFZpcnR1YWxCb3g7IHBl
cmZvcm1hbmNlIHdpbGwgYmUgcG9vci4Kd2xhbjA6IGRlYXV0aGVudGljYXRlZCBmcm9tIDAwOjE1
OmFmOjY2OjE1OjgzIChSZWFzb246IDcpCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkgcHJlc3Nl
ZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQg
c2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0IGtub3du
LgphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNv
ZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXljb2Rl
cyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KYXRrYmQgc2VyaW8wOiBVbmtub3du
IGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQgb24gaXNhMDA2MC9zZXJp
bzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1h
a2UgaXQga25vd24uCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRl
IDIKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6ODMgdG8gc3RhdGUgMQp3bGFuMDog
bW92aW5nIFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0byBzdGF0ZSAwCmNmZzgwMjExOiBBbGwgZGV2
aWNlcyBhcmUgZGlzY29ubmVjdGVkLCBnb2luZyB0byByZXN0b3JlIHJlZ3VsYXRvcnkgc2V0dGlu
Z3MKY2ZnODAyMTE6IFJlc3RvcmluZyByZWd1bGF0b3J5IHNldHRpbmdzCmNmZzgwMjExOiBDYWxs
aW5nIENSREEgdG8gdXBkYXRlIHdvcmxkIHJlZ3VsYXRvcnkgZG9tYWluCndsYW4wOiBhdXRoZW50
aWNhdGUgd2l0aCAwMDoxNTphZjo2NjoxNTo4MyAodHJ5IDEpCndsYW4wOiBhdXRoZW50aWNhdGVk
CndsYW4wOiBhc3NvY2lhdGUgd2l0aCAwMDoxNTphZjo2NjoxNTo4MyAodHJ5IDEpCndsYW4wOiBS
WCBBc3NvY1Jlc3AgZnJvbSAwMDoxNTphZjo2NjoxNTo4MyAoY2FwYWI9MHgxMSBzdGF0dXM9MCBh
aWQ9MSkKd2xhbjA6IGFzc29jaWF0ZWQKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6
ODMgdG8gc3RhdGUgMQp3bGFuMDogbW92aW5nIFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0byBzdGF0
ZSAyCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRlIDMKY2ZnODAy
MTE6IElnbm9yaW5nIHJlZ3VsYXRvcnkgcmVxdWVzdCBTZXQgYnkgY29yZSBzaW5jZSB0aGUgZHJp
dmVyIHVzZXMgaXRzIG93biBjdXN0b20gcmVndWxhdG9yeSBkb21haW4KY2ZnODAyMTE6IFdvcmxk
IHJlZ3VsYXRvcnkgZG9tYWluIHVwZGF0ZWQ6CmNmZzgwMjExOiAgIChzdGFydF9mcmVxIC0gZW5k
X2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2VpcnApCmNmZzgwMjEx
OiAgICgyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIw
MDAgbUJtKQpjZmc4MDIxMTogICAoMjQ1NzAwMCBLSHogLSAyNDgyMDAwIEtIeiBAIDIwMDAwIEtI
eiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDI0NzQwMDAgS0h6IC0gMjQ5NDAw
MCBLSHogQCAyMDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICg1MTcw
MDAwIEtIeiAtIDUyNTAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpj
Zmc4MDIxMTogICAoNTczNTAwMCBLSHogLSA1ODM1MDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAg
bUJpLCAyMDAwIG1CbSkKYXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xh
dGVkIHNldCAyLCBjb2RlIDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVz
ZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCmF0a2JkIHNl
cmlvMDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9u
IGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtl
eWNvZGU+JyB0byBtYWtlIGl0IGtub3duLgphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNz
ZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2Jk
IHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93
bi4KYXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBj
b2RlIDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29k
ZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCmF0a2JkIHNlcmlvMDogVW5rbm93
biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2Vy
aW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBt
YWtlIGl0IGtub3duLgphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0
ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNl
ICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KYXRrYmQgc2Vy
aW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQgb24g
aXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5
Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkgcHJlc3Nl
ZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQg
c2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0IGtub3du
LgpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8sdXNl
cl94YXR0cixjb21taXQ9MAphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5z
bGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDog
VXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KYXRrYmQg
c2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQg
b24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8
a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkgcHJl
c3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4KYXRr
YmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0IGtu
b3duLgphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIs
IGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXlj
b2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KZGV2aWNlIHRhcDAgbGVmdCBw
cm9taXNjdW91cyBtb2RlCnZib3huZXRmbHQ6IGRyb3BwZWQgMCBvdXQgb2YgMiBwYWNrZXRzCmRl
dl9yZW1vdmVfcGFjazogZmZmZjg4MDBiYTVjODZkOCBub3QgZm91bmQuCmVoY2lfaGNkIDAwMDA6
MDA6MWEuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnVzYiAxLTEuMjogbmV3IGhpZ2gt
c3BlZWQgVVNCIGRldmljZSBudW1iZXIgOCB1c2luZyBlaGNpX2hjZApzY3NpMjkgOiB1c2Itc3Rv
cmFnZSAxLTEuMjoxLjAKc2NzaSAyOTowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgSmV0Rmxhc2gg
VHJhbnNjZW5kIDRHQiAgICAxMTAwIFBROiAwIEFOU0k6IDAgQ0NTCnNkIDI5OjA6MDowOiBBdHRh
Y2hlZCBzY3NpIGdlbmVyaWMgc2c0IHR5cGUgMApzZCAyOTowOjA6MDogW3NkY10gNzkxMzQ3MiA1
MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDQuMDUgR0IvMy43NyBHaUIpCnNkIDI5OjA6MDowOiBb
c2RjXSBXcml0ZSBQcm90ZWN0IGlzIG9mZgpzZCAyOTowOjA6MDogW3NkY10gTW9kZSBTZW5zZTog
NDMgMDAgMDAgMDAKc2QgMjk6MDowOjA6IFtzZGNdIE5vIENhY2hpbmcgbW9kZSBwYWdlIHByZXNl
bnQKc2QgMjk6MDowOjA6IFtzZGNdIEFzc3VtaW5nIGRyaXZlIGNhY2hlOiB3cml0ZSB0aHJvdWdo
CnNkIDI5OjA6MDowOiBbc2RjXSBObyBDYWNoaW5nIG1vZGUgcGFnZSBwcmVzZW50CnNkIDI5OjA6
MDowOiBbc2RjXSBBc3N1bWluZyBkcml2ZSBjYWNoZTogd3JpdGUgdGhyb3VnaAogc2RjOiBzZGMx
CnNkIDI5OjA6MDowOiBbc2RjXSBObyBDYWNoaW5nIG1vZGUgcGFnZSBwcmVzZW50CnNkIDI5OjA6
MDowOiBbc2RjXSBBc3N1bWluZyBkcml2ZSBjYWNoZTogd3JpdGUgdGhyb3VnaApzZCAyOTowOjA6
MDogW3NkY10gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawphdGtiZCBzZXJpbzA6IFVua25v
d24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3Nl
cmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8g
bWFrZSBpdCBrbm93bi4KdXNiIDEtMS4yOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA4
CnVzYiAyLTEuMjogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgNjQKdXNiIDItMS4yOiBu
ZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA2NSB1c2luZyBlaGNpX2hjZApzY3NpMzAg
OiB1c2Itc3RvcmFnZSAyLTEuMjoxLjAKc2NzaSAzMDowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAg
ICAgICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAwIEFOU0k6IDIKc2NzaSAzMDowOjA6
MTogQ0QtUk9NICAgICAgICAgICAgICAgICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAw
IEFOU0k6IDIKc2QgMzA6MDowOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzIgdHlwZSAwCnNy
MTogc2NzaTMtbW1jIGRyaXZlOiAweC8weCBjYWRkeQpzciAzMDowOjA6MTogQXR0YWNoZWQgc2Nz
aSBDRC1ST00gc3IxCnNyIDMwOjA6MDoxOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2czIHR5cGUg
NQpzZCAzMDowOjA6MDogW3NkYl0gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawp1c2IgMi0x
LjI6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDY1CmF0a2JkIHNlcmlvMDogVW5rbm93
biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2Vy
aW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBt
YWtlIGl0IGtub3duLgpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJl
bW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9NjAwCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkg
cHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4K
YXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0
IGtub3duLgpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQt
cm8sdXNlcl94YXR0cixjb21taXQ9MAphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQg
KHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNl
cmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4K
YXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2Rl
IDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMg
ZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDog
c2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnVzYiAxLTEuMjogbmV3IGhpZ2gtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgOSB1c2luZyBlaGNpX2hjZApzY3NpMzEgOiB1c2Itc3RvcmFnZSAxLTEu
MjoxLjAKc2NzaSAzMTowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgICAgICAgICAgSWRlb3MgICAg
ICAgICAgICAwMDAwIFBROiAwIEFOU0k6IDIKc2NzaSAzMTowOjA6MTogQ0QtUk9NICAgICAgICAg
ICAgICAgICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAwIEFOU0k6IDIKc2QgMzE6MDow
OjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzIgdHlwZSAwCnNyMTogc2NzaTMtbW1jIGRyaXZl
OiAweC8weCBjYWRkeQpzciAzMTowOjA6MTogQXR0YWNoZWQgc2NzaSBDRC1ST00gc3IxCnNyIDMx
OjA6MDoxOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2czIHR5cGUgNQpzZCAzMTowOjA6MDogW3Nk
Yl0gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawp3bGFuMDogZGVhdXRoZW50aWNhdGluZyBm
cm9tIDAwOjE1OmFmOjY2OjE1OjgzIGJ5IGxvY2FsIGNob2ljZSAocmVhc29uPTMpCndsYW4wOiBt
b3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRlIDIKd2xhbjA6IG1vdmluZyBTVEEg
MDA6MTU6YWY6NjY6MTU6ODMgdG8gc3RhdGUgMQp3bGFuMDogbW92aW5nIFNUQSAwMDoxNTphZjo2
NjoxNTo4MyB0byBzdGF0ZSAwCmNmZzgwMjExOiBBbGwgZGV2aWNlcyBhcmUgZGlzY29ubmVjdGVk
LCBnb2luZyB0byByZXN0b3JlIHJlZ3VsYXRvcnkgc2V0dGluZ3MKY2ZnODAyMTE6IFJlc3Rvcmlu
ZyByZWd1bGF0b3J5IHNldHRpbmdzCmNmZzgwMjExOiBDYWxsaW5nIENSREEgdG8gdXBkYXRlIHdv
cmxkIHJlZ3VsYXRvcnkgZG9tYWluCmNmZzgwMjExOiBJZ25vcmluZyByZWd1bGF0b3J5IHJlcXVl
c3QgU2V0IGJ5IGNvcmUgc2luY2UgdGhlIGRyaXZlciB1c2VzIGl0cyBvd24gY3VzdG9tIHJlZ3Vs
YXRvcnkgZG9tYWluCmNmZzgwMjExOiBXb3JsZCByZWd1bGF0b3J5IGRvbWFpbiB1cGRhdGVkOgpj
Zmc4MDIxMTogICAoc3RhcnRfZnJlcSAtIGVuZF9mcmVxIEAgYmFuZHdpZHRoKSwgKG1heF9hbnRl
bm5hX2dhaW4sIG1heF9laXJwKQpjZmc4MDIxMTogICAoMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtI
eiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDI0NTcwMDAg
S0h6IC0gMjQ4MjAwMCBLSHogQCAyMDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgw
MjExOiAgICgyNDc0MDAwIEtIeiAtIDI0OTQwMDAgS0h6IEAgMjAwMDAgS0h6KSwgKDMwMCBtQmks
IDIwMDAgbUJtKQpjZmc4MDIxMTogICAoNTE3MDAwMCBLSHogLSA1MjUwMDAwIEtIeiBAIDQwMDAw
IEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDU3MzUwMDAgS0h6IC0gNTgz
NTAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCkVYVDQtZnMgKHNkYTEp
OiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0w
ClBNOiBTeW5jaW5nIGZpbGVzeXN0ZW1zIC4uLiBkb25lLgpQTTogUHJlcGFyaW5nIHN5c3RlbSBm
b3IgbWVtIHNsZWVwCkZyZWV6aW5nIHVzZXIgc3BhY2UgcHJvY2Vzc2VzIC4uLiAoZWxhcHNlZCAw
LjE1IHNlY29uZHMpIGRvbmUuCkZyZWV6aW5nIHJlbWFpbmluZyBmcmVlemFibGUgdGFza3MgLi4u
IChlbGFwc2VkIDAuMDEgc2Vjb25kcykgZG9uZS4KUE06IEVudGVyaW5nIG1lbSBzbGVlcApTdXNw
ZW5kaW5nIGNvbnNvbGUocykgKHVzZSBub19jb25zb2xlX3N1c3BlbmQgdG8gZGVidWcpCnNkIDA6
MDowOjA6IFtzZGFdIFN5bmNocm9uaXppbmcgU0NTSSBjYWNoZQpzZCAwOjA6MDowOiBbc2RhXSBT
dG9wcGluZyBkaXNrCnBjaWVocCAwMDAwOjAwOjFjLjQ6cGNpZTA0OiBwY2llaHBfc3VzcGVuZCBF
TlRSWQpBQ1BJIGhhbmRsZSBoYXMgbm8gY29udGV4dCEKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRl
eHQhCltkcm1dIERpc2FibGluZyBhdWRpbyBzdXBwb3J0ClBNOiBzdXNwZW5kIG9mIGRldmljZXMg
Y29tcGxldGUgYWZ0ZXIgNzY5LjU0NyBtc2VjcwpQTTogc3VzcGVuZCBkZXZpY2VzIHRvb2sgMC43
OTAgc2Vjb25kcwpwY2llcG9ydCAwMDAwOjAwOjFjLjI6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFi
bGVkIGJ5IEFDUEkKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5h
YmxlZCBieSBBQ1BJCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogd2FrZS11cCBjYXBhYmlsaXR5IGVu
YWJsZWQgYnkgQUNQSQpQTTogbGF0ZSBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIg
MTAwLjA5MSBtc2VjcwpBQ1BJOiBQcmVwYXJpbmcgdG8gZW50ZXIgc3lzdGVtIHNsZWVwIHN0YXRl
IFMzClBNOiBTYXZpbmcgcGxhdGZvcm0gTlZTIG1lbW9yeQpEaXNhYmxpbmcgbm9uLWJvb3QgQ1BV
cyAuLi4KQ1BVIDEgaXMgbm93IG9mZmxpbmUKQ1BVIDIgaXMgbm93IG9mZmxpbmUKQ1BVIDMgaXMg
bm93IG9mZmxpbmUKRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAwCkFDUEk6IExvdy1sZXZlbCByZXN1
bWUgY29tcGxldGUKUE06IFJlc3RvcmluZyBwbGF0Zm9ybSBOVlMgbWVtb3J5CkV4dGVuZGVkIENN
T1MgeWVhcjogMjAwMApFbmFibGluZyBub24tYm9vdCBDUFVzIC4uLgpCb290aW5nIE5vZGUgMCBQ
cm9jZXNzb3IgMSBBUElDIDB4NApzbXBib290IGNwdSAxOiBzdGFydF9pcCA9IDk4MDAwCkNhbGli
cmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0aGlzIENQVQpD
UFUxIGlzIHVwCkJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAyIEFQSUMgMHgxCnNtcGJvb3QgY3B1
IDI6IHN0YXJ0X2lwID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tpcHBlZCkgYWxy
ZWFkeSBjYWxpYnJhdGVkIHRoaXMgQ1BVCkNQVTIgaXMgdXAKQm9vdGluZyBOb2RlIDAgUHJvY2Vz
c29yIDMgQVBJQyAweDUKc21wYm9vdCBjcHUgMzogc3RhcnRfaXAgPSA5ODAwMApDYWxpYnJhdGlu
ZyBkZWxheSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNhbGlicmF0ZWQgdGhpcyBDUFUKQ1BVMyBp
cyB1cApBQ1BJOiBXYWtpbmcgdXAgZnJvbSBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMKZWhjaV9oY2Qg
MDAwMDowMDoxYS4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQSQplaGNpX2hj
ZCAwMDAwOjAwOjFkLjA6IHdha2UtdXAgY2FwYWJpbGl0eSBkaXNhYmxlZCBieSBBQ1BJClBNOiBl
YXJseSByZXN1bWUgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciA2Ljk5MiBtc2VjcwplaGNpX2hj
ZCAwMDAwOjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAptZWkgMDAwMDowMDox
Ni4wOiBpcnEgNDggZm9yIE1TSS9NU0ktWApzbmRfaGRhX2ludGVsIDAwMDA6MDA6MWIuMDogaXJx
IDUwIGZvciBNU0kvTVNJLVgKcGNpZWhwIDAwMDA6MDA6MWMuNDpwY2llMDQ6IHBjaWVocF9yZXN1
bWUgRU5UUlkKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8g
NjQKcGNpIDAwMDA6MDA6MWUuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CmFoY2kgMDAw
MDowMDoxZi4yOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKaXdsd2lmaSAwMDAwOjEyOjAw
LjA6IFJGX0tJTEwgYml0IHRvZ2dsZWQgdG8gZW5hYmxlIHJhZGlvLgpzbmRfaGRhX2ludGVsIDAw
MDA6MDE6MDAuMTogaXJxIDUxIGZvciBNU0kvTVNJLVgKcGNpZXBvcnQgMDAwMDowMDoxYy4yOiB3
YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQSQpbZHJtXSBQQ0lFIEdBUlQgb2YgNTEy
TSBlbmFibGVkICh0YWJsZSBhdCAweDAwMDAwMDAwMDAwNDAwMDApLgpyYWRlb24gMDAwMDowMTow
MC4wOiBXQiBlbmFibGVkCltkcm1dIGZlbmNlIGRyaXZlciBvbiByaW5nIDAgdXNlIGdwdSBhZGRy
IDB4NDAwMDBjMDAgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDExMGZkYWMwMApbZHJtXSByaW5nIHRl
c3Qgb24gMCBzdWNjZWVkZWQgaW4gMSB1c2VjcwpbZHJtXSBpYiB0ZXN0IG9uIHJpbmcgMCBzdWNj
ZWVkZWQgaW4gMCB1c2VjcwpbZHJtXSBFbmFibGluZyBhdWRpbyBzdXBwb3J0CnVzYiAyLTEuNjog
cmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA1MyB1c2luZyBlaGNpX2hjZAphdGEy
OiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNTdGF0dXMgMTEzIFNDb250cm9sIDMwMCkKYXRhMi4w
MDogY29uZmlndXJlZCBmb3IgVURNQS8xMDAKYXRhNTogU0FUQSBsaW5rIGRvd24gKFNTdGF0dXMg
MCBTQ29udHJvbCAzMDApCnVzYiAxLTEuNjogcmVzZXQgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51
bWJlciAzIHVzaW5nIGVoY2lfaGNkCnVzYiAyLTEuNi4xOiByZXNldCBmdWxsLXNwZWVkIFVTQiBk
ZXZpY2UgbnVtYmVyIDU0IHVzaW5nIGVoY2lfaGNkCnVzYiAyLTEuNi4yOiByZXNldCBmdWxsLXNw
ZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDU1IHVzaW5nIGVoY2lfaGNkCmF0YTE6IFNBVEEgbGluayB1
cCAzLjAgR2JwcyAoU1N0YXR1cyAxMjMgU0NvbnRyb2wgMzAwKQphdGExLjAwOiBjb25maWd1cmVk
IGZvciBVRE1BLzEzMwpzZCAwOjA6MDowOiBbc2RhXSBTdGFydGluZyBkaXNrClBNOiByZXN1bWUg
b2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciAzMjcyLjA3NCBtc2VjcwpQTTogcmVzdW1lIGRldmlj
ZXMgdG9vayAzLjMwMCBzZWNvbmRzClBNOiBGaW5pc2hpbmcgd2FrZXVwLgpSZXN0YXJ0aW5nIHRh
c2tzIC4uLiAKdXNiIDEtMS4yOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA5CmRvbmUu
CnZpZGVvIExOWFZJREVPOjAwOiBSZXN0b3JpbmcgYmFja2xpZ2h0IHN0YXRlCnVzYiAyLTEuNi4z
OiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA2MQppd2x3aWZpIDAwMDA6MTI6MDAuMDog
TDEgRGlzYWJsZWQ7IEVuYWJsaW5nIEwwUwpBRERSQ09ORihORVRERVZfVVApOiB3bGFuMDogbGlu
ayBpcyBub3QgcmVhZHkKcjgxNjkgMDAwMDoxMzowMC4wOiBldGgwOiBsaW5rIGRvd24KQUREUkNP
TkYoTkVUREVWX1VQKTogZXRoMDogbGluayBpcyBub3QgcmVhZHkKdXNiIDItMS42LjM6IG5ldyBm
dWxsLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDY2IHVzaW5nIGVoY2lfaGNkCndsYW4wOiBhdXRo
ZW50aWNhdGUgd2l0aCAwMDoxNDo2YzpmYTplMzoyMiAodHJ5IDEpCndsYW4wOiBhdXRoZW50aWNh
dGVkCndsYW4wOiBhc3NvY2lhdGUgd2l0aCAwMDoxNDo2YzpmYTplMzoyMiAodHJ5IDEpCndsYW4w
OiBSWCBBc3NvY1Jlc3AgZnJvbSAwMDoxNDo2YzpmYTplMzoyMiAoY2FwYWI9MHg0MTEgc3RhdHVz
PTAgYWlkPTMpCndsYW4wOiBhc3NvY2lhdGVkCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE0OjZjOmZh
OmUzOjIyIHRvIHN0YXRlIDEKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTQ6NmM6ZmE6ZTM6MjIgdG8g
c3RhdGUgMgp3bGFuMDogbW92aW5nIFNUQSAwMDoxNDo2YzpmYTplMzoyMiB0byBzdGF0ZSAzCkFE
RFJDT05GKE5FVERFVl9DSEFOR0UpOiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5CkVYVDQtZnMg
KHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNv
bW1pdD02MDAKRVhUNC1mcyAoc2RhMSk6IHJlLW1vdW50ZWQuIE9wdHM6IGVycm9ycz1yZW1vdW50
LXJvLHVzZXJfeGF0dHIsY29tbWl0PTYwMAp3bGFuMDogbm8gSVB2NiByb3V0ZXJzIHByZXNlbnQK
YXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2Rl
IDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMg
ZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCkVYVDQtZnMgKHNkYTEpOiByZS1tb3Vu
dGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0wCmF0a2JkIHNl
cmlvMDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9u
IGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtl
eWNvZGU+JyB0byBtYWtlIGl0IGtub3duLgp1c2IgMi0xLjI6IG5ldyBoaWdoLXNwZWVkIFVTQiBk
ZXZpY2UgbnVtYmVyIDY3IHVzaW5nIGVoY2lfaGNkCnNjc2kzMiA6IHVzYi1zdG9yYWdlIDItMS4y
OjEuMApzY3NpIDMyOjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICAgICAgICAgICBJZGVvcyAgICAg
ICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzY3NpIDMyOjA6MDoxOiBDRC1ST00gICAgICAgICAg
ICAgICAgICAgICBJZGVvcyAgICAgICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzZCAzMjowOjA6
MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMiB0eXBlIDAKc3IxOiBzY3NpMy1tbWMgZHJpdmU6
IDB4LzB4IGNhZGR5CnNkIDMyOjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIHJlbW92YWJsZSBk
aXNrCnNyIDMyOjA6MDoxOiBBdHRhY2hlZCBzY3NpIENELVJPTSBzcjEKc3IgMzI6MDowOjE6IEF0
dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzMgdHlwZSA1CmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogc2V0
dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnVzYiAyLTEuMjogVVNCIGRpc2Nvbm5lY3QsIGRldmlj
ZSBudW1iZXIgNjcKc2NzaSAzMjowOjA6MToga2lsbGluZyByZXF1ZXN0CmF0a2JkIHNlcmlvMDog
VW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAw
NjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+
JyB0byBtYWtlIGl0IGtub3duLgplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5j
eSB0aW1lciB0byA2NAp1c2IgMi0xLjI6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVy
IDY4IHVzaW5nIGVoY2lfaGNkCnNjc2kzMyA6IHVzYi1zdG9yYWdlIDItMS4yOjEuMApzY3NpIDMz
OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICAgICAgICAgICBJZGVvcyAgICAgICAgICAgIDAwMDAg
UFE6IDAgQU5TSTogMgpzY3NpIDMzOjA6MDoxOiBDRC1ST00gICAgICAgICAgICAgICAgICAgICBJ
ZGVvcyAgICAgICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzZCAzMzowOjA6MDogQXR0YWNoZWQg
c2NzaSBnZW5lcmljIHNnMiB0eXBlIDAKc2QgMzM6MDowOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kg
cmVtb3ZhYmxlIGRpc2sKc3IxOiBzY3NpMy1tbWMgZHJpdmU6IDB4LzB4IGNhZGR5CnNyIDMzOjA6
MDoxOiBBdHRhY2hlZCBzY3NpIENELVJPTSBzcjEKc3IgMzM6MDowOjE6IEF0dGFjaGVkIHNjc2kg
Z2VuZXJpYyBzZzMgdHlwZSA1CnR5cGU9MTQwMCBhdWRpdCgxMzM4Mjk1MjYxLjQwNTozMCk6IGFw
cGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9yZXBsYWNlIiBuYW1lPSIvdXNyL3Ni
aW4vbXlzcWxkIiBwaWQ9MzIzMDggY29tbT0iYXBwYXJtb3JfcGFyc2VyIgplaGNpX2hjZCAwMDAw
OjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAplaGNpX2hjZCAwMDAwOjAwOjFh
LjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNl
dHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApjb21waXpbMzI1OTRdIGdlbmVyYWwgcHJvdGVjdGlv
biBpcDo3ZjdhMDU3NDUzOTQgc3A6N2ZmZjgyYjQ3NTUwIGVycm9yOjAgaW4gbGlicHRocmVhZC0y
LjEzLnNvWzdmN2EwNTczYzAwMCsxODAwMF0Kd2xhbjA6IGRlYXV0aGVudGljYXRpbmcgZnJvbSAw
MDoxNDo2YzpmYTplMzoyMiBieSBsb2NhbCBjaG9pY2UgKHJlYXNvbj0zKQp3bGFuMDogbW92aW5n
IFNUQSAwMDoxNDo2YzpmYTplMzoyMiB0byBzdGF0ZSAyCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE0
OjZjOmZhOmUzOjIyIHRvIHN0YXRlIDEKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTQ6NmM6ZmE6ZTM6
MjIgdG8gc3RhdGUgMApjZmc4MDIxMTogQWxsIGRldmljZXMgYXJlIGRpc2Nvbm5lY3RlZCwgZ29p
bmcgdG8gcmVzdG9yZSByZWd1bGF0b3J5IHNldHRpbmdzCmNmZzgwMjExOiBSZXN0b3JpbmcgcmVn
dWxhdG9yeSBzZXR0aW5ncwpjZmc4MDIxMTogQ2FsbGluZyBDUkRBIHRvIHVwZGF0ZSB3b3JsZCBy
ZWd1bGF0b3J5IGRvbWFpbgpjZmc4MDIxMTogSWdub3JpbmcgcmVndWxhdG9yeSByZXF1ZXN0IFNl
dCBieSBjb3JlIHNpbmNlIHRoZSBkcml2ZXIgdXNlcyBpdHMgb3duIGN1c3RvbSByZWd1bGF0b3J5
IGRvbWFpbgpjZmc4MDIxMTogV29ybGQgcmVndWxhdG9yeSBkb21haW4gdXBkYXRlZDoKY2ZnODAy
MTE6ICAgKHN0YXJ0X2ZyZXEgLSBlbmRfZnJlcSBAIGJhbmR3aWR0aCksIChtYXhfYW50ZW5uYV9n
YWluLCBtYXhfZWlycCkKY2ZnODAyMTE6ICAgKDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0
MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICgyNDU3MDAwIEtIeiAt
IDI0ODIwMDAgS0h6IEAgMjAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTog
ICAoMjQ3NDAwMCBLSHogLSAyNDk0MDAwIEtIeiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAw
IG1CbSkKY2ZnODAyMTE6ICAgKDUxNzAwMDAgS0h6IC0gNTI1MDAwMCBLSHogQCA0MDAwMCBLSHop
LCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICg1NzM1MDAwIEtIeiAtIDU4MzUwMDAg
S0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpFWFQ0LWZzIChzZGExKTogcmUt
bW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9MApQTTog
U3luY2luZyBmaWxlc3lzdGVtcyAuLi4gZG9uZS4KUE06IFByZXBhcmluZyBzeXN0ZW0gZm9yIG1l
bSBzbGVlcApGcmVlemluZyB1c2VyIHNwYWNlIHByb2Nlc3NlcyAuLi4gKGVsYXBzZWQgMC4wMyBz
ZWNvbmRzKSBkb25lLgpGcmVlemluZyByZW1haW5pbmcgZnJlZXphYmxlIHRhc2tzIC4uLiAoZWxh
cHNlZCAwLjAxIHNlY29uZHMpIGRvbmUuClBNOiBFbnRlcmluZyBtZW0gc2xlZXAKU3VzcGVuZGlu
ZyBjb25zb2xlKHMpICh1c2Ugbm9fY29uc29sZV9zdXNwZW5kIHRvIGRlYnVnKQplaGNpX2hjZCAw
MDAwOjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApzZCAwOjA6MDowOiBbc2Rh
XSBTeW5jaHJvbml6aW5nIFNDU0kgY2FjaGUKc2QgMDowOjA6MDogW3NkYV0gU3RvcHBpbmcgZGlz
awpBQ1BJIGhhbmRsZSBoYXMgbm8gY29udGV4dCEKcGNpZWhwIDAwMDA6MDA6MWMuNDpwY2llMDQ6
IHBjaWVocF9zdXNwZW5kIEVOVFJZCkFDUEkgaGFuZGxlIGhhcyBubyBjb250ZXh0IQpbZHJtXSBE
aXNhYmxpbmcgYXVkaW8gc3VwcG9ydApQTTogc3VzcGVuZCBvZiBkZXZpY2VzIGNvbXBsZXRlIGFm
dGVyIDY0OS42MDAgbXNlY3MKUE06IHN1c3BlbmQgZGV2aWNlcyB0b29rIDAuNjkwIHNlY29uZHMK
cGNpZXBvcnQgMDAwMDowMDoxYy4yOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJ
CmVoY2lfaGNkIDAwMDA6MDA6MWQuMDogd2FrZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQ
SQplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFD
UEkKUE06IGxhdGUgc3VzcGVuZCBvZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDEwMC4wMzAgbXNl
Y3MKQUNQSTogUHJlcGFyaW5nIHRvIGVudGVyIHN5c3RlbSBzbGVlcCBzdGF0ZSBTMwpQTTogU2F2
aW5nIHBsYXRmb3JtIE5WUyBtZW1vcnkKRGlzYWJsaW5nIG5vbi1ib290IENQVXMgLi4uCkNQVSAx
IGlzIG5vdyBvZmZsaW5lCkNQVSAyIGlzIG5vdyBvZmZsaW5lCkNQVSAzIGlzIG5vdyBvZmZsaW5l
CkV4dGVuZGVkIENNT1MgeWVhcjogMjAwMApBQ1BJOiBMb3ctbGV2ZWwgcmVzdW1lIGNvbXBsZXRl
ClBNOiBSZXN0b3JpbmcgcGxhdGZvcm0gTlZTIG1lbW9yeQpFeHRlbmRlZCBDTU9TIHllYXI6IDIw
MDAKRW5hYmxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KQm9vdGluZyBOb2RlIDAgUHJvY2Vzc29yIDEg
QVBJQyAweDQKc21wYm9vdCBjcHUgMTogc3RhcnRfaXAgPSA5ODAwMApDYWxpYnJhdGluZyBkZWxh
eSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNhbGlicmF0ZWQgdGhpcyBDUFUKQ1BVMSBpcyB1cApC
b290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMiBBUElDIDB4MQpzbXBib290IGNwdSAyOiBzdGFydF9p
cCA9IDk4MDAwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpIGFscmVhZHkgY2FsaWJy
YXRlZCB0aGlzIENQVQpDUFUyIGlzIHVwCkJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAzIEFQSUMg
MHg1CnNtcGJvb3QgY3B1IDM6IHN0YXJ0X2lwID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkgbG9v
cCAoc2tpcHBlZCkgYWxyZWFkeSBjYWxpYnJhdGVkIHRoaXMgQ1BVCkNQVTMgaXMgdXAKQUNQSTog
V2FraW5nIHVwIGZyb20gc3lzdGVtIHNsZWVwIHN0YXRlIFMzCmVoY2lfaGNkIDAwMDA6MDA6MWEu
MDogd2FrZS11cCBjYXBhYmlsaXR5IGRpc2FibGVkIGJ5IEFDUEkKZWhjaV9oY2QgMDAwMDowMDox
ZC4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQSQpQTTogZWFybHkgcmVzdW1l
IG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgNi44OTUgbXNlY3MKZWhjaV9oY2QgMDAwMDowMDox
YS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKbWVpIDAwMDA6MDA6MTYuMDogaXJxIDQ4
IGZvciBNU0kvTVNJLVgKc25kX2hkYV9pbnRlbCAwMDAwOjAwOjFiLjA6IGlycSA1MCBmb3IgTVNJ
L01TSS1YCnBjaWVocCAwMDAwOjAwOjFjLjQ6cGNpZTA0OiBwY2llaHBfcmVzdW1lIEVOVFJZCmVo
Y2lfaGNkIDAwMDA6MDA6MWQuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnBjaSAwMDAw
OjAwOjFlLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAphaGNpIDAwMDA6MDA6MWYuMjog
c2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnBjaWVwb3J0IDAwMDA6MDA6MWMuMjogd2FrZS11
cCBjYXBhYmlsaXR5IGRpc2FibGVkIGJ5IEFDUEkKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IFJGX0tJ
TEwgYml0IHRvZ2dsZWQgdG8gZW5hYmxlIHJhZGlvLgpzbmRfaGRhX2ludGVsIDAwMDA6MDE6MDAu
MTogaXJxIDUxIGZvciBNU0kvTVNJLVgKW2RybV0gUENJRSBHQVJUIG9mIDUxMk0gZW5hYmxlZCAo
dGFibGUgYXQgMHgwMDAwMDAwMDAwMDQwMDAwKS4KcmFkZW9uIDAwMDA6MDE6MDAuMDogV0IgZW5h
YmxlZApbZHJtXSBmZW5jZSBkcml2ZXIgb24gcmluZyAwIHVzZSBncHUgYWRkciAweDQwMDAwYzAw
IGFuZCBjcHUgYWRkciAweGZmZmY4ODAxMTBmZGFjMDAKW2RybV0gcmluZyB0ZXN0IG9uIDAgc3Vj
Y2VlZGVkIGluIDAgdXNlY3MKW2RybV0gaWIgdGVzdCBvbiByaW5nIDAgc3VjY2VlZGVkIGluIDAg
dXNlY3MKW2RybV0gRW5hYmxpbmcgYXVkaW8gc3VwcG9ydAp1c2IgMS0xLjY6IHJlc2V0IGhpZ2gt
c3BlZWQgVVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBlaGNpX2hjZAphdGE1OiBTQVRBIGxpbmsg
ZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCkKYXRhMjogU0FUQSBsaW5rIHVwIDEuNSBHYnBz
IChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCmF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEv
MTAwCnVzYiAyLTEuNjogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA1MyB1c2lu
ZyBlaGNpX2hjZAp1c2IgMi0xLjYuMTogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJl
ciA1NCB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMjogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2
aWNlIG51bWJlciA1NSB1c2luZyBlaGNpX2hjZAphdGExOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMg
KFNTdGF0dXMgMTIzIFNDb250cm9sIDMwMCkKYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8x
MzMKc2QgMDowOjA6MDogW3NkYV0gU3RhcnRpbmcgZGlzawpQTTogcmVzdW1lIG9mIGRldmljZXMg
Y29tcGxldGUgYWZ0ZXIgMzI5NS42MjIgbXNlY3MKUE06IHJlc3VtZSBkZXZpY2VzIHRvb2sgMy4z
MjAgc2Vjb25kcwpQTTogRmluaXNoaW5nIHdha2V1cC4KUmVzdGFydGluZyB0YXNrcyAuLi4gZG9u
ZS4KdmlkZW8gTE5YVklERU86MDA6IFJlc3RvcmluZyBiYWNrbGlnaHQgc3RhdGUKdXNiIDEtMS4y
OiBuZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAxMCB1c2luZyBlaGNpX2hjZApzY3Np
MzQgOiB1c2Itc3RvcmFnZSAxLTEuMjoxLjAKdXNiIDItMS4yOiBVU0IgZGlzY29ubmVjdCwgZGV2
aWNlIG51bWJlciA2OApzY3NpIDMzOjA6MDowOiBraWxsaW5nIHJlcXVlc3QKdXNiIDItMS42LjM6
IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDY2CnNjc2kgMzQ6MDowOjA6IERpcmVjdC1B
Y2Nlc3MgICAgICAgICAgICAgIElkZW9zICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAyCnNj
c2kgMzQ6MDowOjE6IENELVJPTSAgICAgICAgICAgICAgICAgICAgIElkZW9zICAgICAgICAgICAg
MDAwMCBQUTogMCBBTlNJOiAyCnNkIDM0OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cy
IHR5cGUgMApzcjE6IHNjc2kzLW1tYyBkcml2ZTogMHgvMHggY2FkZHkKc3IgMzQ6MDowOjE6IEF0
dGFjaGVkIHNjc2kgQ0QtUk9NIHNyMQpzciAzNDowOjA6MTogQXR0YWNoZWQgc2NzaSBnZW5lcmlj
IHNnMyB0eXBlIDUKc2QgMzQ6MDowOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kgcmVtb3ZhYmxlIGRp
c2sKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IEwxIERpc2FibGVkOyBFbmFibGluZyBMMFMKQUREUkNP
TkYoTkVUREVWX1VQKTogd2xhbjA6IGxpbmsgaXMgbm90IHJlYWR5CnI4MTY5IDAwMDA6MTM6MDAu
MDogZXRoMDogbGluayBkb3duCkFERFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxpbmsgaXMgbm90
IHJlYWR5CnVzYiAyLTEuNi4zOiBuZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA2OSB1
c2luZyBlaGNpX2hjZApFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJl
bW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9MAppd2x3aWZpIDAwMDA6MTI6MDAuMDogUkZfS0lM
TCBiaXQgdG9nZ2xlZCB0byBkaXNhYmxlIHJhZGlvLgprZXlib2FyZDogY2FuJ3QgZW11bGF0ZSBy
YXdtb2RlIGZvciBrZXljb2RlIDI0MAprZXlib2FyZDogY2FuJ3QgZW11bGF0ZSByYXdtb2RlIGZv
ciBrZXljb2RlIDI0MAppd2x3aWZpIDAwMDA6MTI6MDAuMDogQ29tbWFuZCBSRVBMWV9SWE9OIGFi
b3J0ZWQ6IFJGIEtJTEwgU3dpdGNoCmdlbmVyaWMtdXNiIDAwMDM6NDEzQzo4MTYxLjAwMEQ6IGNh
bid0IHJlc2V0IGRldmljZSwgMDAwMDowMDoxZC4wLTEuNi4xL2lucHV0MCwgc3RhdHVzIC0zMgpn
ZW5lcmljLXVzYiAwMDAzOjQxM0M6ODE2MS4wMDBEOiBjYW4ndCByZXNldCBkZXZpY2UsIDAwMDA6
MDA6MWQuMC0xLjYuMS9pbnB1dDAsIHN0YXR1cyAtMzIKdXNiIDItMS42OiBVU0IgZGlzY29ubmVj
dCwgZGV2aWNlIG51bWJlciA1Mwp1c2IgMi0xLjYuMTogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBu
dW1iZXIgNTQKdXNiIDItMS42LjI6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDU1CnVz
YiAyLTEuNi4zOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA2OQp1c2IgMS0xLjI6IFVT
QiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDEwCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVk
LiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0wClBNOiBTeW5jaW5n
IGZpbGVzeXN0ZW1zIC4uLiBkb25lLgpQTTogUHJlcGFyaW5nIHN5c3RlbSBmb3IgbWVtIHNsZWVw
CkZyZWV6aW5nIHVzZXIgc3BhY2UgcHJvY2Vzc2VzIC4uLiAoZWxhcHNlZCAwLjAxIHNlY29uZHMp
IGRvbmUuCkZyZWV6aW5nIHJlbWFpbmluZyBmcmVlemFibGUgdGFza3MgLi4uIChlbGFwc2VkIDAu
MDEgc2Vjb25kcykgZG9uZS4KUE06IEVudGVyaW5nIG1lbSBzbGVlcApTdXNwZW5kaW5nIGNvbnNv
bGUocykgKHVzZSBub19jb25zb2xlX3N1c3BlbmQgdG8gZGVidWcpCmVoY2lfaGNkIDAwMDA6MDA6
MWQuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnNkIDA6MDowOjA6IFtzZGFdIFN5bmNo
cm9uaXppbmcgU0NTSSBjYWNoZQpzZCAwOjA6MDowOiBbc2RhXSBTdG9wcGluZyBkaXNrCkFDUEkg
aGFuZGxlIGhhcyBubyBjb250ZXh0IQpwY2llaHAgMDAwMDowMDoxYy40OnBjaWUwNDogcGNpZWhw
X3N1c3BlbmQgRU5UUlkKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCltkcm1dIERpc2FibGlu
ZyBhdWRpbyBzdXBwb3J0ClBNOiBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgNjE5
LjgxNyBtc2VjcwpQTTogc3VzcGVuZCBkZXZpY2VzIHRvb2sgMC42NjAgc2Vjb25kcwpwY2llcG9y
dCAwMDAwOjAwOjFjLjI6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkKZWhjaV9o
Y2QgMDAwMDowMDoxZC4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJCmVoY2lf
aGNkIDAwMDA6MDA6MWEuMDogd2FrZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQSQpQTTog
bGF0ZSBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgOTkuODI3IG1zZWNzCkFDUEk6
IFByZXBhcmluZyB0byBlbnRlciBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMKUE06IFNhdmluZyBwbGF0
Zm9ybSBOVlMgbWVtb3J5CkRpc2FibGluZyBub24tYm9vdCBDUFVzIC4uLgpDUFUgMSBpcyBub3cg
b2ZmbGluZQpDUFUgMiBpcyBub3cgb2ZmbGluZQpCcm9rZSBhZmZpbml0eSBmb3IgaXJxIDEyCkNQ
VSAzIGlzIG5vdyBvZmZsaW5lCkV4dGVuZGVkIENNT1MgeWVhcjogMjAwMApBQ1BJOiBMb3ctbGV2
ZWwgcmVzdW1lIGNvbXBsZXRlClBNOiBSZXN0b3JpbmcgcGxhdGZvcm0gTlZTIG1lbW9yeQpFeHRl
bmRlZCBDTU9TIHllYXI6IDIwMDAKRW5hYmxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KQm9vdGluZyBO
b2RlIDAgUHJvY2Vzc29yIDEgQVBJQyAweDQKc21wYm9vdCBjcHUgMTogc3RhcnRfaXAgPSA5ODAw
MApDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNhbGlicmF0ZWQgdGhp
cyBDUFUKQ1BVMSBpcyB1cApCb290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMiBBUElDIDB4MQpzbXBi
b290IGNwdSAyOiBzdGFydF9pcCA9IDk4MDAwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBw
ZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0aGlzIENQVQpDUFUyIGlzIHVwCkJvb3RpbmcgTm9kZSAw
IFByb2Nlc3NvciAzIEFQSUMgMHg1CnNtcGJvb3QgY3B1IDM6IHN0YXJ0X2lwID0gOTgwMDAKQ2Fs
aWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tpcHBlZCkgYWxyZWFkeSBjYWxpYnJhdGVkIHRoaXMgQ1BV
CkNQVTMgaXMgdXAKQUNQSTogV2FraW5nIHVwIGZyb20gc3lzdGVtIHNsZWVwIHN0YXRlIFMzCmVo
Y2lfaGNkIDAwMDA6MDA6MWEuMDogd2FrZS11cCBjYXBhYmlsaXR5IGRpc2FibGVkIGJ5IEFDUEkK
ZWhjaV9oY2QgMDAwMDowMDoxZC4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQ
SQpQTTogZWFybHkgcmVzdW1lIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgNi44MDIgbXNlY3MK
ZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKbWVpIDAw
MDA6MDA6MTYuMDogaXJxIDQ4IGZvciBNU0kvTVNJLVgKcGNpZWhwIDAwMDA6MDA6MWMuNDpwY2ll
MDQ6IHBjaWVocF9yZXN1bWUgRU5UUlkKc25kX2hkYV9pbnRlbCAwMDAwOjAwOjFiLjA6IGlycSA1
MCBmb3IgTVNJL01TSS1YCmVoY2lfaGNkIDAwMDA6MDA6MWQuMDogc2V0dGluZyBsYXRlbmN5IHRp
bWVyIHRvIDY0CnBjaSAwMDAwOjAwOjFlLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAph
aGNpIDAwMDA6MDA6MWYuMjogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnBjaWVwb3J0IDAw
MDA6MDA6MWMuMjogd2FrZS11cCBjYXBhYmlsaXR5IGRpc2FibGVkIGJ5IEFDUEkKaXdsd2lmaSAw
MDAwOjEyOjAwLjA6IFJGX0tJTEwgYml0IHRvZ2dsZWQgdG8gZGlzYWJsZSByYWRpby4Kc25kX2hk
YV9pbnRlbCAwMDAwOjAxOjAwLjE6IGlycSA1MSBmb3IgTVNJL01TSS1YCltkcm1dIFBDSUUgR0FS
VCBvZiA1MTJNIGVuYWJsZWQgKHRhYmxlIGF0IDB4MDAwMDAwMDAwMDA0MDAwMCkuCnJhZGVvbiAw
MDAwOjAxOjAwLjA6IFdCIGVuYWJsZWQKW2RybV0gZmVuY2UgZHJpdmVyIG9uIHJpbmcgMCB1c2Ug
Z3B1IGFkZHIgMHg0MDAwMGMwMCBhbmQgY3B1IGFkZHIgMHhmZmZmODgwMTEwZmRhYzAwCltkcm1d
IHJpbmcgdGVzdCBvbiAwIHN1Y2NlZWRlZCBpbiAxIHVzZWNzCltkcm1dIGliIHRlc3Qgb24gcmlu
ZyAwIHN1Y2NlZWRlZCBpbiAwIHVzZWNzCltkcm1dIEVuYWJsaW5nIGF1ZGlvIHN1cHBvcnQKdXNi
IDEtMS42OiByZXNldCBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDMgdXNpbmcgZWhjaV9o
Y2QKYXRhMjogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDAp
CmF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTAwCmF0YTU6IFNBVEEgbGluayBkb3duIChT
U3RhdHVzIDAgU0NvbnRyb2wgMzAwKQphdGExOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0
dXMgMTIzIFNDb250cm9sIDMwMCkKYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKc2Qg
MDowOjA6MDogW3NkYV0gU3RhcnRpbmcgZGlzawpQTTogcmVzdW1lIG9mIGRldmljZXMgY29tcGxl
dGUgYWZ0ZXIgMzI5My4yNTAgbXNlY3MKUE06IHJlc3VtZSBkZXZpY2VzIHRvb2sgMy4zMjAgc2Vj
b25kcwpQTTogRmluaXNoaW5nIHdha2V1cC4KUmVzdGFydGluZyB0YXNrcyAuLi4gZG9uZS4Kdmlk
ZW8gTE5YVklERU86MDA6IFJlc3RvcmluZyBiYWNrbGlnaHQgc3RhdGUKcjgxNjkgMDAwMDoxMzow
MC4wOiBldGgwOiBsaW5rIGRvd24KQUREUkNPTkYoTkVUREVWX1VQKTogZXRoMDogbGluayBpcyBu
b3QgcmVhZHkKRVhUNC1mcyAoc2RhMSk6IHJlLW1vdW50ZWQuIE9wdHM6IGVycm9ycz1yZW1vdW50
LXJvLHVzZXJfeGF0dHIsY29tbWl0PTYwMApFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0
czogZXJyb3JzPXJlbW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9NjAwCml3bHdpZmkgMDAwMDox
MjowMC4wOiBSRl9LSUxMIGJpdCB0b2dnbGVkIHRvIGVuYWJsZSByYWRpby4Ka2V5Ym9hcmQ6IGNh
bid0IGVtdWxhdGUgcmF3bW9kZSBmb3Iga2V5Y29kZSAyNDAKa2V5Ym9hcmQ6IGNhbid0IGVtdWxh
dGUgcmF3bW9kZSBmb3Iga2V5Y29kZSAyNDAKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBzZXR0aW5n
IGxhdGVuY3kgdGltZXIgdG8gNjQKdXNiIDItMS42OiBuZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNl
IG51bWJlciA3MCB1c2luZyBlaGNpX2hjZApodWIgMi0xLjY6MS4wOiBVU0IgaHViIGZvdW5kCmh1
YiAyLTEuNjoxLjA6IDMgcG9ydHMgZGV0ZWN0ZWQKdXNiIDItMS42LjE6IG5ldyBmdWxsLXNwZWVk
IFVTQiBkZXZpY2UgbnVtYmVyIDcxIHVzaW5nIGVoY2lfaGNkCml3bHdpZmkgMDAwMDoxMjowMC4w
OiBMMSBEaXNhYmxlZDsgRW5hYmxpbmcgTDBTCmlucHV0OiBISUQgNDEzYzo4MTYxIGFzIC9kZXZp
Y2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxZC4wL3VzYjIvMi0xLzItMS42LzItMS42LjEvMi0xLjYu
MToxLjAvaW5wdXQvaW5wdXQyNgpnZW5lcmljLXVzYiAwMDAzOjQxM0M6ODE2MS4wMDBGOiBpbnB1
dCxoaWRyYXcwOiBVU0IgSElEIHYxLjExIEtleWJvYXJkIFtISUQgNDEzYzo4MTYxXSBvbiB1c2It
MDAwMDowMDoxZC4wLTEuNi4xL2lucHV0MApBRERSQ09ORihORVRERVZfVVApOiB3bGFuMDogbGlu
ayBpcyBub3QgcmVhZHkKdXNiIDItMS42LjI6IG5ldyBmdWxsLXNwZWVkIFVTQiBkZXZpY2UgbnVt
YmVyIDcyIHVzaW5nIGVoY2lfaGNkCmlucHV0OiBISUQgNDEzYzo4MTYyIGFzIC9kZXZpY2VzL3Bj
aTAwMDA6MDAvMDAwMDowMDoxZC4wL3VzYjIvMi0xLzItMS42LzItMS42LjIvMi0xLjYuMjoxLjAv
aW5wdXQvaW5wdXQyNwpnZW5lcmljLXVzYiAwMDAzOjQxM0M6ODE2Mi4wMDEwOiBpbnB1dCxoaWRy
YXcxOiBVU0IgSElEIHYxLjExIE1vdXNlIFtISUQgNDEzYzo4MTYyXSBvbiB1c2ItMDAwMDowMDox
ZC4wLTEuNi4yL2lucHV0MApjZmc4MDIxMTogRm91bmQgbmV3IGJlYWNvbiBvbiBmcmVxdWVuY3k6
IDI0NzIgTUh6IChDaCAxMykgb24gcGh5MAp1c2IgMi0xLjYuMzogbmV3IGZ1bGwtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgNzMgdXNpbmcgZWhjaV9oY2QKd2xhbjA6IGF1dGhlbnRpY2F0ZSB3aXRo
IGI4OmM3OjVkOjA5OjUxOjUxICh0cnkgMSkKd2xhbjA6IGF1dGhlbnRpY2F0ZWQKd2xhbjA6IGFz
c29jaWF0ZSB3aXRoIGI4OmM3OjVkOjA5OjUxOjUxICh0cnkgMSkKd2xhbjA6IFJYIEFzc29jUmVz
cCBmcm9tIGI4OmM3OjVkOjA5OjUxOjUxIChjYXBhYj0weDQzMSBzdGF0dXM9MCBhaWQ9MjgpCnds
YW4wOiBhc3NvY2lhdGVkCndsYW4wOiBtb3ZpbmcgU1RBIGI4OmM3OjVkOjA5OjUxOjUxIHRvIHN0
YXRlIDEKd2xhbjA6IG1vdmluZyBTVEEgYjg6Yzc6NWQ6MDk6NTE6NTEgdG8gc3RhdGUgMgp3bGFu
MDogbW92aW5nIFNUQSBiODpjNzo1ZDowOTo1MTo1MSB0byBzdGF0ZSAzCkFERFJDT05GKE5FVERF
Vl9DSEFOR0UpOiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5CmNmZzgwMjExOiBDYWxsaW5nIENS
REEgZm9yIGNvdW50cnk6IFVTCmNmZzgwMjExOiBVcGRhdGluZyBpbmZvcm1hdGlvbiBvbiBmcmVx
dWVuY3kgMjQxMiBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5uZWwgd2l0aCByZWd1bGF0b3J5
IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6KSwg
KDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcgaW5mb3JtYXRpb24gb24gZnJl
cXVlbmN5IDI0MTcgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFubmVsIHdpdGggcmVndWxhdG9y
eSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAwIEtIeiks
ICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IFVwZGF0aW5nIGluZm9ybWF0aW9uIG9uIGZy
ZXF1ZW5jeSAyNDIyIE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hhbm5lbCB3aXRoIHJlZ3VsYXRv
cnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0MDAwMCBLSHop
LCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGluZyBpbmZvcm1hdGlvbiBvbiBm
cmVxdWVuY3kgMjQyNyBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5uZWwgd2l0aCByZWd1bGF0
b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6
KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcgaW5mb3JtYXRpb24gb24g
ZnJlcXVlbmN5IDI0MzIgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFubmVsIHdpdGggcmVndWxh
dG9yeSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAwIEtI
eiksICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IFVwZGF0aW5nIGluZm9ybWF0aW9uIG9u
IGZyZXF1ZW5jeSAyNDM3IE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hhbm5lbCB3aXRoIHJlZ3Vs
YXRvcnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0MDAwMCBL
SHopLCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGluZyBpbmZvcm1hdGlvbiBv
biBmcmVxdWVuY3kgMjQ0MiBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5uZWwgd2l0aCByZWd1
bGF0b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAg
S0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcgaW5mb3JtYXRpb24g
b24gZnJlcXVlbmN5IDI0NDcgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFubmVsIHdpdGggcmVn
dWxhdG9yeSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAw
IEtIeiksICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IFVwZGF0aW5nIGluZm9ybWF0aW9u
IG9uIGZyZXF1ZW5jeSAyNDUyIE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hhbm5lbCB3aXRoIHJl
Z3VsYXRvcnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0MDAw
MCBLSHopLCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGluZyBpbmZvcm1hdGlv
biBvbiBmcmVxdWVuY3kgMjQ1NyBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5uZWwgd2l0aCBy
ZWd1bGF0b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAw
MDAgS0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcgaW5mb3JtYXRp
b24gb24gZnJlcXVlbmN5IDI0NjIgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFubmVsIHdpdGgg
cmVndWxhdG9yeSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQw
MDAwIEtIeiksICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IERpc2FibGluZyBmcmVxIDI0
NjcgTUh6CmNmZzgwMjExOiBEaXNhYmxpbmcgZnJlcSAyNDcyIE1IegpjZmc4MDIxMTogUmVndWxh
dG9yeSBkb21haW4gY2hhbmdlZCB0byBjb3VudHJ5OiBVUwpjZmc4MDIxMTogICAoc3RhcnRfZnJl
cSAtIGVuZF9mcmVxIEAgYmFuZHdpZHRoKSwgKG1heF9hbnRlbm5hX2dhaW4sIG1heF9laXJwKQpj
Zmc4MDIxMTogICAoMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAg
bUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6ICAgKDUxNzAwMDAgS0h6IC0gNTI1MDAwMCBLSHogQCA0
MDAwMCBLSHopLCAoMzAwIG1CaSwgMTcwMCBtQm0pCmNmZzgwMjExOiAgICg1MjUwMDAwIEtIeiAt
IDUzMzAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTog
ICAoNTQ5MDAwMCBLSHogLSA1NjAwMDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAw
IG1CbSkKY2ZnODAyMTE6ICAgKDU2NTAwMDAgS0h6IC0gNTcxMDAwMCBLSHogQCA0MDAwMCBLSHop
LCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICg1NzM1MDAwIEtIeiAtIDU4MzUwMDAg
S0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDMwMDAgbUJtKQplaGNpX2hjZCAwMDAwOjAwOjFh
LjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNl
dHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNldHRpbmcg
bGF0ZW5jeSB0aW1lciB0byA2NAplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5j
eSB0aW1lciB0byA2NAp3bGFuMDogZGVhdXRoZW50aWNhdGVkIGZyb20gYjg6Yzc6NWQ6MDk6NTE6
NTEgKFJlYXNvbjogMTQpCndsYW4wOiBtb3ZpbmcgU1RBIGI4OmM3OjVkOjA5OjUxOjUxIHRvIHN0
YXRlIDIKd2xhbjA6IG1vdmluZyBTVEEgYjg6Yzc6NWQ6MDk6NTE6NTEgdG8gc3RhdGUgMQp3bGFu
MDogbW92aW5nIFNUQSBiODpjNzo1ZDowOTo1MTo1MSB0byBzdGF0ZSAwCmNmZzgwMjExOiBBbGwg
ZGV2aWNlcyBhcmUgZGlzY29ubmVjdGVkLCBnb2luZyB0byByZXN0b3JlIHJlZ3VsYXRvcnkgc2V0
dGluZ3MKY2ZnODAyMTE6IFJlc3RvcmluZyByZWd1bGF0b3J5IHNldHRpbmdzCmNmZzgwMjExOiBD
YWxsaW5nIENSREEgdG8gdXBkYXRlIHdvcmxkIHJlZ3VsYXRvcnkgZG9tYWluCmNmZzgwMjExOiBJ
Z25vcmluZyByZWd1bGF0b3J5IHJlcXVlc3QgU2V0IGJ5IGNvcmUgc2luY2UgdGhlIGRyaXZlciB1
c2VzIGl0cyBvd24gY3VzdG9tIHJlZ3VsYXRvcnkgZG9tYWluCmNmZzgwMjExOiBXb3JsZCByZWd1
bGF0b3J5IGRvbWFpbiB1cGRhdGVkOgpjZmc4MDIxMTogICAoc3RhcnRfZnJlcSAtIGVuZF9mcmVx
IEAgYmFuZHdpZHRoKSwgKG1heF9hbnRlbm5hX2dhaW4sIG1heF9laXJwKQpjZmc4MDIxMTogICAo
MjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1C
bSkKY2ZnODAyMTE6ICAgKDI0NTcwMDAgS0h6IC0gMjQ4MjAwMCBLSHogQCAyMDAwMCBLSHopLCAo
MzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICgyNDc0MDAwIEtIeiAtIDI0OTQwMDAgS0h6
IEAgMjAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoNTE3MDAwMCBL
SHogLSA1MjUwMDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAy
MTE6ICAgKDU3MzUwMDAgS0h6IC0gNTgzNTAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwg
MjAwMCBtQm0pCndsYW4wOiBhdXRoZW50aWNhdGUgd2l0aCBiODpjNzo1ZDowOTo1MTo1MSAodHJ5
IDEpCndsYW4wOiBhdXRoZW50aWNhdGUgd2l0aCBiODpjNzo1ZDowOTo1MTo1MSAodHJ5IDIpCnds
YW4wOiBhdXRoZW50aWNhdGUgd2l0aCBiODpjNzo1ZDowOTo1MTo1MSAodHJ5IDMpCndsYW4wOiBh
dXRoZW50aWNhdGlvbiB3aXRoIGI4OmM3OjVkOjA5OjUxOjUxIHRpbWVkIG91dAp3bGFuMDogYXV0
aGVudGljYXRlIHdpdGggYjg6Yzc6NWQ6MDk6NTE6NTEgKHRyeSAxKQp3bGFuMDogYXV0aGVudGlj
YXRlIHdpdGggYjg6Yzc6NWQ6MDk6NTE6NTEgKHRyeSAyKQp3bGFuMDogYXV0aGVudGljYXRlIHdp
dGggYjg6Yzc6NWQ6MDk6NTE6NTEgKHRyeSAzKQp3bGFuMDogYXV0aGVudGljYXRpb24gd2l0aCBi
ODpjNzo1ZDowOTo1MTo1MSB0aW1lZCBvdXQKd2xhbjA6IGF1dGhlbnRpY2F0ZSB3aXRoIGI4OmM3
OjVkOjA5OjUxOjUxICh0cnkgMSkKd2xhbjA6IGF1dGhlbnRpY2F0ZSB3aXRoIGI4OmM3OjVkOjA5
OjUxOjUxICh0cnkgMikKd2xhbjA6IGF1dGhlbnRpY2F0ZSB3aXRoIGI4OmM3OjVkOjA5OjUxOjUx
ICh0cnkgMykKd2xhbjA6IGF1dGhlbnRpY2F0aW9uIHdpdGggYjg6Yzc6NWQ6MDk6NTE6NTEgdGlt
ZWQgb3V0CndsYW4wOiBhdXRoZW50aWNhdGUgd2l0aCBiODpjNzo1ZDowOTo1MTo1MSAodHJ5IDEp
CndsYW4wOiBhdXRoZW50aWNhdGUgd2l0aCBiODpjNzo1ZDowOTo1MTo1MSAodHJ5IDIpCndsYW4w
OiBhdXRoZW50aWNhdGUgd2l0aCBiODpjNzo1ZDowOTo1MTo1MSAodHJ5IDMpCndsYW4wOiBhdXRo
ZW50aWNhdGlvbiB3aXRoIGI4OmM3OjVkOjA5OjUxOjUxIHRpbWVkIG91dAp3bGFuMDogYXV0aGVu
dGljYXRlIHdpdGggYjg6Yzc6NWQ6MDk6NTE6NTEgKHRyeSAxKQp3bGFuMDogYXV0aGVudGljYXRl
IHdpdGggYjg6Yzc6NWQ6MDk6NTE6NTEgKHRyeSAyKQp3bGFuMDogYXV0aGVudGljYXRlIHdpdGgg
Yjg6Yzc6NWQ6MDk6NTE6NTEgKHRyeSAzKQp3bGFuMDogYXV0aGVudGljYXRpb24gd2l0aCBiODpj
Nzo1ZDowOTo1MTo1MSB0aW1lZCBvdXQKd2xhbjA6IGF1dGhlbnRpY2F0ZSB3aXRoIGI4OmM3OjVk
OjA5OjUxOjUxICh0cnkgMSkKd2xhbjA6IGF1dGhlbnRpY2F0ZWQKd2xhbjA6IHdhaXRpbmcgZm9y
IGJlYWNvbiBmcm9tIGI4OmM3OjVkOjA5OjUxOjUxCndsYW4wOiBiZWFjb24gcmVjZWl2ZWQKd2xh
bjA6IGFzc29jaWF0ZSB3aXRoIGI4OmM3OjVkOjA5OjUxOjUxICh0cnkgMSkKd2xhbjA6IFJYIEFz
c29jUmVzcCBmcm9tIGI4OmM3OjVkOjA5OjUxOjUxIChjYXBhYj0weDQzMSBzdGF0dXM9MCBhaWQ9
NikKd2xhbjA6IGFzc29jaWF0ZWQKd2xhbjA6IG1vdmluZyBTVEEgYjg6Yzc6NWQ6MDk6NTE6NTEg
dG8gc3RhdGUgMQp3bGFuMDogbW92aW5nIFNUQSBiODpjNzo1ZDowOTo1MTo1MSB0byBzdGF0ZSAy
CndsYW4wOiBtb3ZpbmcgU1RBIGI4OmM3OjVkOjA5OjUxOjUxIHRvIHN0YXRlIDMKY2ZnODAyMTE6
IENhbGxpbmcgQ1JEQSBmb3IgY291bnRyeTogVVMKY2ZnODAyMTE6IFVwZGF0aW5nIGluZm9ybWF0
aW9uIG9uIGZyZXF1ZW5jeSAyNDEyIE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hhbm5lbCB3aXRo
IHJlZ3VsYXRvcnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0
MDAwMCBLSHopLCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGluZyBpbmZvcm1h
dGlvbiBvbiBmcmVxdWVuY3kgMjQxNyBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5uZWwgd2l0
aCByZWd1bGF0b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAg
NDAwMDAgS0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcgaW5mb3Jt
YXRpb24gb24gZnJlcXVlbmN5IDI0MjIgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFubmVsIHdp
dGggcmVndWxhdG9yeSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtIeiBA
IDQwMDAwIEtIeiksICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IFVwZGF0aW5nIGluZm9y
bWF0aW9uIG9uIGZyZXF1ZW5jeSAyNDI3IE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hhbm5lbCB3
aXRoIHJlZ3VsYXRvcnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHog
QCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGluZyBpbmZv
cm1hdGlvbiBvbiBmcmVxdWVuY3kgMjQzMiBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5uZWwg
d2l0aCByZWd1bGF0b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6
IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcgaW5m
b3JtYXRpb24gb24gZnJlcXVlbmN5IDI0MzcgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFubmVs
IHdpdGggcmVndWxhdG9yeSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAwIEtI
eiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IFVwZGF0aW5nIGlu
Zm9ybWF0aW9uIG9uIGZyZXF1ZW5jeSAyNDQyIE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hhbm5l
bCB3aXRoIHJlZ3VsYXRvcnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBL
SHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGluZyBp
bmZvcm1hdGlvbiBvbiBmcmVxdWVuY3kgMjQ0NyBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNoYW5u
ZWwgd2l0aCByZWd1bGF0b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIwMDAg
S0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogVXBkYXRpbmcg
aW5mb3JtYXRpb24gb24gZnJlcXVlbmN5IDI0NTIgTUh6IGZvciBhIDIwIE1IeiB3aWR0aCBjaGFu
bmVsIHdpdGggcmVndWxhdG9yeSBydWxlOgpjZmc4MDIxMTogMjQwMjAwMCBLSHogLSAyNDcyMDAw
IEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyNzAwIG1CbSkKY2ZnODAyMTE6IFVwZGF0aW5n
IGluZm9ybWF0aW9uIG9uIGZyZXF1ZW5jeSAyNDU3IE1IeiBmb3IgYSAyMCBNSHogd2lkdGggY2hh
bm5lbCB3aXRoIHJlZ3VsYXRvcnkgcnVsZToKY2ZnODAyMTE6IDI0MDIwMDAgS0h6IC0gMjQ3MjAw
MCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjcwMCBtQm0pCmNmZzgwMjExOiBVcGRhdGlu
ZyBpbmZvcm1hdGlvbiBvbiBmcmVxdWVuY3kgMjQ2MiBNSHogZm9yIGEgMjAgTUh6IHdpZHRoIGNo
YW5uZWwgd2l0aCByZWd1bGF0b3J5IHJ1bGU6CmNmZzgwMjExOiAyNDAyMDAwIEtIeiAtIDI0NzIw
MDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogRGlzYWJs
aW5nIGZyZXEgMjQ2NyBNSHoKY2ZnODAyMTE6IERpc2FibGluZyBmcmVxIDI0NzIgTUh6CmNmZzgw
MjExOiBSZWd1bGF0b3J5IGRvbWFpbiBjaGFuZ2VkIHRvIGNvdW50cnk6IFVTCmNmZzgwMjExOiAg
IChzdGFydF9mcmVxIC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2Fpbiwg
bWF4X2VpcnApCmNmZzgwMjExOiAgICgyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAg
S0h6KSwgKDMwMCBtQmksIDI3MDAgbUJtKQpjZmc4MDIxMTogICAoNTE3MDAwMCBLSHogLSA1MjUw
MDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAxNzAwIG1CbSkKY2ZnODAyMTE6ICAgKDUy
NTAwMDAgS0h6IC0gNTMzMDAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0p
CmNmZzgwMjExOiAgICg1NDkwMDAwIEtIeiAtIDU2MDAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMw
MCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoNTY1MDAwMCBLSHogLSA1NzEwMDAwIEtIeiBA
IDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDU3MzUwMDAgS0h6
IC0gNTgzNTAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMzAwMCBtQm0pCmF0a2JkIHNl
cmlvMDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9u
IGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtl
eWNvZGU+JyB0byBtYWtlIGl0IGtub3duLgphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNz
ZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2Jk
IHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93
bi4KYXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBj
b2RlIDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29k
ZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCkVYVDQtZnMgKHNkYTEpOiByZS1t
b3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0wCmVoY2lf
aGNkIDAwMDA6MDA6MWEuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CnVzYiAxLTEuMjog
bmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMTEgdXNpbmcgZWhjaV9oY2QKc2NzaTM1
IDogdXNiLXN0b3JhZ2UgMS0xLjI6MS4wCnNjc2kgMzU6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAg
ICAgICAgICAgIElkZW9zICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAyCnNjc2kgMzU6MDow
OjE6IENELVJPTSAgICAgICAgICAgICAgICAgICAgIElkZW9zICAgICAgICAgICAgMDAwMCBQUTog
MCBBTlNJOiAyCnNkIDM1OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cyIHR5cGUgMApz
ZCAzNTowOjA6MDogW3NkYl0gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawpzcjE6IHNjc2kz
LW1tYyBkcml2ZTogMHgvMHggY2FkZHkKc3IgMzU6MDowOjE6IEF0dGFjaGVkIHNjc2kgQ0QtUk9N
IHNyMQpzciAzNTowOjA6MTogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMyB0eXBlIDUKd2xhbjA6
IGRlYXV0aGVudGljYXRpbmcgZnJvbSBiODpjNzo1ZDowOTo1MTo1MSBieSBsb2NhbCBjaG9pY2Ug
KHJlYXNvbj0zKQp3bGFuMDogbW92aW5nIFNUQSBiODpjNzo1ZDowOTo1MTo1MSB0byBzdGF0ZSAy
CndsYW4wOiBtb3ZpbmcgU1RBIGI4OmM3OjVkOjA5OjUxOjUxIHRvIHN0YXRlIDEKd2xhbjA6IG1v
dmluZyBTVEEgYjg6Yzc6NWQ6MDk6NTE6NTEgdG8gc3RhdGUgMApjZmc4MDIxMTogQWxsIGRldmlj
ZXMgYXJlIGRpc2Nvbm5lY3RlZCwgZ29pbmcgdG8gcmVzdG9yZSByZWd1bGF0b3J5IHNldHRpbmdz
CmNmZzgwMjExOiBSZXN0b3JpbmcgcmVndWxhdG9yeSBzZXR0aW5ncwpjZmc4MDIxMTogQ2FsbGlu
ZyBDUkRBIHRvIHVwZGF0ZSB3b3JsZCByZWd1bGF0b3J5IGRvbWFpbgpjZmc4MDIxMTogSWdub3Jp
bmcgcmVndWxhdG9yeSByZXF1ZXN0IFNldCBieSBjb3JlIHNpbmNlIHRoZSBkcml2ZXIgdXNlcyBp
dHMgb3duIGN1c3RvbSByZWd1bGF0b3J5IGRvbWFpbgpjZmc4MDIxMTogV29ybGQgcmVndWxhdG9y
eSBkb21haW4gdXBkYXRlZDoKY2ZnODAyMTE6ICAgKHN0YXJ0X2ZyZXEgLSBlbmRfZnJlcSBAIGJh
bmR3aWR0aCksIChtYXhfYW50ZW5uYV9nYWluLCBtYXhfZWlycCkKY2ZnODAyMTE6ICAgKDI0MDIw
MDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNm
ZzgwMjExOiAgICgyNDU3MDAwIEtIeiAtIDI0ODIwMDAgS0h6IEAgMjAwMDAgS0h6KSwgKDMwMCBt
QmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoMjQ3NDAwMCBLSHogLSAyNDk0MDAwIEtIeiBAIDIw
MDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDUxNzAwMDAgS0h6IC0g
NTI1MDAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAg
ICg1NzM1MDAwIEtIeiAtIDU4MzUwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAg
bUJtKQpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8s
dXNlcl94YXR0cixjb21taXQ9MApQTTogU3luY2luZyBmaWxlc3lzdGVtcyAuLi4gZG9uZS4KUE06
IFByZXBhcmluZyBzeXN0ZW0gZm9yIG1lbSBzbGVlcApGcmVlemluZyB1c2VyIHNwYWNlIHByb2Nl
c3NlcyAuLi4gKGVsYXBzZWQgMC4wMSBzZWNvbmRzKSBkb25lLgpGcmVlemluZyByZW1haW5pbmcg
ZnJlZXphYmxlIHRhc2tzIC4uLiAoZWxhcHNlZCAwLjAxIHNlY29uZHMpIGRvbmUuClBNOiBFbnRl
cmluZyBtZW0gc2xlZXAKU3VzcGVuZGluZyBjb25zb2xlKHMpICh1c2Ugbm9fY29uc29sZV9zdXNw
ZW5kIHRvIGRlYnVnKQpzZCAwOjA6MDowOiBbc2RhXSBTeW5jaHJvbml6aW5nIFNDU0kgY2FjaGUK
c2QgMDowOjA6MDogW3NkYV0gU3RvcHBpbmcgZGlzawpwY2llaHAgMDAwMDowMDoxYy40OnBjaWUw
NDogcGNpZWhwX3N1c3BlbmQgRU5UUlkKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCkFDUEkg
aGFuZGxlIGhhcyBubyBjb250ZXh0IQpbZHJtXSBEaXNhYmxpbmcgYXVkaW8gc3VwcG9ydApQTTog
c3VzcGVuZCBvZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDYxOS42NzQgbXNlY3MKUE06IHN1c3Bl
bmQgZGV2aWNlcyB0b29rIDAuNjQwIHNlY29uZHMKcGNpZXBvcnQgMDAwMDowMDoxYy4yOiB3YWtl
LXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJCmVoY2lfaGNkIDAwMDA6MDA6MWQuMDogd2Fr
ZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQSQplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHdh
a2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkKUE06IGxhdGUgc3VzcGVuZCBvZiBkZXZp
Y2VzIGNvbXBsZXRlIGFmdGVyIDk5Ljk0OSBtc2VjcwpBQ1BJOiBQcmVwYXJpbmcgdG8gZW50ZXIg
c3lzdGVtIHNsZWVwIHN0YXRlIFMzClBNOiBTYXZpbmcgcGxhdGZvcm0gTlZTIG1lbW9yeQpEaXNh
Ymxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KQ1BVIDEgaXMgbm93IG9mZmxpbmUKQ1BVIDIgaXMgbm93
IG9mZmxpbmUKQ1BVIDMgaXMgbm93IG9mZmxpbmUKRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAwCkFD
UEk6IExvdy1sZXZlbCByZXN1bWUgY29tcGxldGUKUE06IFJlc3RvcmluZyBwbGF0Zm9ybSBOVlMg
bWVtb3J5CkV4dGVuZGVkIENNT1MgeWVhcjogMjAwMApFbmFibGluZyBub24tYm9vdCBDUFVzIC4u
LgpCb290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMSBBUElDIDB4NApzbXBib290IGNwdSAxOiBzdGFy
dF9pcCA9IDk4MDAwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpIGFscmVhZHkgY2Fs
aWJyYXRlZCB0aGlzIENQVQpDUFUxIGlzIHVwCkJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAyIEFQ
SUMgMHgxCnNtcGJvb3QgY3B1IDI6IHN0YXJ0X2lwID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkg
bG9vcCAoc2tpcHBlZCkgYWxyZWFkeSBjYWxpYnJhdGVkIHRoaXMgQ1BVCkNQVTIgaXMgdXAKQm9v
dGluZyBOb2RlIDAgUHJvY2Vzc29yIDMgQVBJQyAweDUKc21wYm9vdCBjcHUgMzogc3RhcnRfaXAg
PSA5ODAwMApDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNhbGlicmF0
ZWQgdGhpcyBDUFUKQ1BVMyBpcyB1cApBQ1BJOiBXYWtpbmcgdXAgZnJvbSBzeXN0ZW0gc2xlZXAg
c3RhdGUgUzMKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJs
ZWQgYnkgQUNQSQplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IHdha2UtdXAgY2FwYWJpbGl0eSBkaXNh
YmxlZCBieSBBQ1BJClBNOiBlYXJseSByZXN1bWUgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciA2
LjkwMCBtc2VjcwplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0
byA2NAptZWkgMDAwMDowMDoxNi4wOiBpcnEgNDggZm9yIE1TSS9NU0ktWApwY2llaHAgMDAwMDow
MDoxYy40OnBjaWUwNDogcGNpZWhwX3Jlc3VtZSBFTlRSWQpzbmRfaGRhX2ludGVsIDAwMDA6MDA6
MWIuMDogaXJxIDUwIGZvciBNU0kvTVNJLVgKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBzZXR0aW5n
IGxhdGVuY3kgdGltZXIgdG8gNjQKcGNpIDAwMDA6MDA6MWUuMDogc2V0dGluZyBsYXRlbmN5IHRp
bWVyIHRvIDY0Cml3bHdpZmkgMDAwMDoxMjowMC4wOiBSRl9LSUxMIGJpdCB0b2dnbGVkIHRvIGVu
YWJsZSByYWRpby4Kc25kX2hkYV9pbnRlbCAwMDAwOjAxOjAwLjE6IGlycSA1MSBmb3IgTVNJL01T
SS1YCmFoY2kgMDAwMDowMDoxZi4yOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKcGNpZXBv
cnQgMDAwMDowMDoxYy4yOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQSQpbZHJt
XSBQQ0lFIEdBUlQgb2YgNTEyTSBlbmFibGVkICh0YWJsZSBhdCAweDAwMDAwMDAwMDAwNDAwMDAp
LgpyYWRlb24gMDAwMDowMTowMC4wOiBXQiBlbmFibGVkCltkcm1dIGZlbmNlIGRyaXZlciBvbiBy
aW5nIDAgdXNlIGdwdSBhZGRyIDB4NDAwMDBjMDAgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDExMGZk
YWMwMApbZHJtXSByaW5nIHRlc3Qgb24gMCBzdWNjZWVkZWQgaW4gMCB1c2VjcwpbZHJtXSBpYiB0
ZXN0IG9uIHJpbmcgMCBzdWNjZWVkZWQgaW4gMCB1c2VjcwpbZHJtXSBFbmFibGluZyBhdWRpbyBz
dXBwb3J0CkV4dGVuZGVkIENNT1MgeWVhcjogMjAwMAp1c2IgMi0xLjY6IHJlc2V0IGZ1bGwtc3Bl
ZWQgVVNCIGRldmljZSBudW1iZXIgNzAgdXNpbmcgZWhjaV9oY2QKYXRhMjogU0FUQSBsaW5rIHVw
IDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCmF0YTIuMDA6IGNvbmZpZ3VyZWQg
Zm9yIFVETUEvMTAwCmF0YTU6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAw
KQp1c2IgMS0xLjY6IHJlc2V0IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBl
aGNpX2hjZAp1c2IgMS0xLjI6IHJlc2V0IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMTEg
dXNpbmcgZWhjaV9oY2QKdXNiIDItMS42LjE6IHJlc2V0IGZ1bGwtc3BlZWQgVVNCIGRldmljZSBu
dW1iZXIgNzEgdXNpbmcgZWhjaV9oY2QKdXNiIDItMS42LjI6IHJlc2V0IGZ1bGwtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgNzIgdXNpbmcgZWhjaV9oY2QKYXRhMTogU0FUQSBsaW5rIHVwIDMuMCBH
YnBzIChTU3RhdHVzIDEyMyBTQ29udHJvbCAzMDApCmF0YTEuMDA6IGNvbmZpZ3VyZWQgZm9yIFVE
TUEvMTMzCnNkIDA6MDowOjA6IFtzZGFdIFN0YXJ0aW5nIGRpc2sKUE06IHJlc3VtZSBvZiBkZXZp
Y2VzIGNvbXBsZXRlIGFmdGVyIDMzNTQuMjExIG1zZWNzClBNOiByZXN1bWUgZGV2aWNlcyB0b29r
IDMuMzgwIHNlY29uZHMKUE06IEZpbmlzaGluZyB3YWtldXAuClJlc3RhcnRpbmcgdGFza3MgLi4u
IAp1c2IgMi0xLjYuMzogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgNzMKZG9uZS4Kdmlk
ZW8gTE5YVklERU86MDA6IFJlc3RvcmluZyBiYWNrbGlnaHQgc3RhdGUKaXdsd2lmaSAwMDAwOjEy
OjAwLjA6IEwxIERpc2FibGVkOyBFbmFibGluZyBMMFMKQUREUkNPTkYoTkVUREVWX1VQKTogd2xh
bjA6IGxpbmsgaXMgbm90IHJlYWR5CnI4MTY5IDAwMDA6MTM6MDAuMDogZXRoMDogbGluayBkb3du
CkFERFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxpbmsgaXMgbm90IHJlYWR5CnVzYiAyLTEuNi4z
OiBuZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA3NCB1c2luZyBlaGNpX2hjZApFWFQ0
LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8sdXNlcl94YXR0
cixjb21taXQ9NjAwCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVt
b3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD02MDAKYXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBw
cmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgph
dGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQg
a25vd24uCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQg
MiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtl
eWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0IGtub3duLgphdGtiZCBzZXJpbzA6IFVu
a25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYw
L3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicg
dG8gbWFrZSBpdCBrbm93bi4KYXRrYmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFu
c2xhdGVkIHNldCAyLCBjb2RlIDB4OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6
IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCkVYVDQt
ZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRy
LGNvbW1pdD0wClBNOiBNYXJraW5nIG5vc2F2ZSBwYWdlczogMDAwMDAwMDAwMDA5ZDAwMCAtIDAw
MDAwMDAwMDAxMDAwMDAKUE06IE1hcmtpbmcgbm9zYXZlIHBhZ2VzOiAwMDAwMDAwMGJmNWE3MDAw
IC0gMDAwMDAwMDBiZjYyMDAwMApQTTogTWFya2luZyBub3NhdmUgcGFnZXM6IDAwMDAwMDAwYmY2
MjEwMDAgLSAwMDAwMDAwMGJmNjk0MDAwClBNOiBNYXJraW5nIG5vc2F2ZSBwYWdlczogMDAwMDAw
MDBiZjgwMDAwMCAtIDAwMDAwMDAxMDAwMDAwMDAKUE06IEJhc2ljIG1lbW9yeSBiaXRtYXBzIGNy
ZWF0ZWQKUE06IFN5bmNpbmcgZmlsZXN5c3RlbXMgLi4uIGRvbmUuCkZyZWV6aW5nIHVzZXIgc3Bh
Y2UgcHJvY2Vzc2VzIC4uLiAoZWxhcHNlZCAwLjAxIHNlY29uZHMpIGRvbmUuClBNOiBQcmVhbGxv
Y2F0aW5nIGltYWdlIG1lbW9yeS4uLiBkb25lIChhbGxvY2F0ZWQgNjIwNzM2IHBhZ2VzKQpQTTog
QWxsb2NhdGVkIDI0ODI5NDQga2J5dGVzIGluIDEyLjA4IHNlY29uZHMgKDIwNS41NCBNQi9zKQpG
cmVlemluZyByZW1haW5pbmcgZnJlZXphYmxlIHRhc2tzIC4uLiAoZWxhcHNlZCAwLjExIHNlY29u
ZHMpIGRvbmUuClN1c3BlbmRpbmcgY29uc29sZShzKSAodXNlIG5vX2NvbnNvbGVfc3VzcGVuZCB0
byBkZWJ1ZykKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCnBjaWVocCAwMDAwOjAwOjFjLjQ6
cGNpZTA0OiBwY2llaHBfc3VzcGVuZCBFTlRSWQpBQ1BJIGhhbmRsZSBoYXMgbm8gY29udGV4dCEK
W2RybV0gRGlzYWJsaW5nIGF1ZGlvIHN1cHBvcnQKc2QgMDowOjA6MDogW3NkYV0gU3luY2hyb25p
emluZyBTQ1NJIGNhY2hlCmF0YTU6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wg
MzAwKQpQTTogZnJlZXplIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgODQwLjM4NCBtc2VjcwpQ
TTogbGF0ZSBmcmVlemUgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciAwLjgxOCBtc2VjcwpBQ1BJ
OiBQcmVwYXJpbmcgdG8gZW50ZXIgc3lzdGVtIHNsZWVwIHN0YXRlIFM0ClBNOiBTYXZpbmcgcGxh
dGZvcm0gTlZTIG1lbW9yeQpEaXNhYmxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KQ1BVIDEgaXMgbm93
IG9mZmxpbmUKQ1BVIDIgaXMgbm93IG9mZmxpbmUKQ1BVIDMgaXMgbm93IG9mZmxpbmUKRXh0ZW5k
ZWQgQ01PUyB5ZWFyOiAyMDAwClBNOiBDcmVhdGluZyBoaWJlcm5hdGlvbiBpbWFnZToKUE06IE5l
ZWQgdG8gY29weSAzNzQyMzUgcGFnZXMKUE06IE5vcm1hbCBwYWdlcyBuZWVkZWQ6IDM3NDIzNSAr
IDEwMjQsIGF2YWlsYWJsZSBwYWdlczogNjM5MDkzClBNOiBSZXN0b3JpbmcgcGxhdGZvcm0gTlZT
IG1lbW9yeQpFeHRlbmRlZCBDTU9TIHllYXI6IDIwMDAKRW5hYmxpbmcgbm9uLWJvb3QgQ1BVcyAu
Li4KQm9vdGluZyBOb2RlIDAgUHJvY2Vzc29yIDEgQVBJQyAweDQKc21wYm9vdCBjcHUgMTogc3Rh
cnRfaXAgPSA5ODAwMApDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNh
bGlicmF0ZWQgdGhpcyBDUFUKQ1BVMSBpcyB1cApCb290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMiBB
UElDIDB4MQpzbXBib290IGNwdSAyOiBzdGFydF9pcCA9IDk4MDAwCkNhbGlicmF0aW5nIGRlbGF5
IGxvb3AgKHNraXBwZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0aGlzIENQVQpDUFUyIGlzIHVwCkJv
b3RpbmcgTm9kZSAwIFByb2Nlc3NvciAzIEFQSUMgMHg1CnNtcGJvb3QgY3B1IDM6IHN0YXJ0X2lw
ID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tpcHBlZCkgYWxyZWFkeSBjYWxpYnJh
dGVkIHRoaXMgQ1BVCkNQVTMgaXMgdXAKQUNQSTogV2FraW5nIHVwIGZyb20gc3lzdGVtIHNsZWVw
IHN0YXRlIFM0ClBNOiBlYXJseSByZXN0b3JlIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgMS4z
MjIgbXNlY3MKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8g
NjQKdXNiIHVzYjE6IHJvb3QgaHViIGxvc3QgcG93ZXIgb3Igd2FzIHJlc2V0Cm1laSAwMDAwOjAw
OjE2LjA6IGlycSA0OCBmb3IgTVNJL01TSS1YCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogY2FjaGUg
bGluZSBzaXplIG9mIDY0IGlzIG5vdCBzdXBwb3J0ZWQKc25kX2hkYV9pbnRlbCAwMDAwOjAwOjFi
LjA6IGlycSA1MCBmb3IgTVNJL01TSS1YCnBjaWVocCAwMDAwOjAwOjFjLjQ6cGNpZTA0OiBwY2ll
aHBfcmVzdW1lIEVOVFJZCmVoY2lfaGNkIDAwMDA6MDA6MWQuMDogc2V0dGluZyBsYXRlbmN5IHRp
bWVyIHRvIDY0CnBjaSAwMDAwOjAwOjFlLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAp1
c2IgdXNiMjogcm9vdCBodWIgbG9zdCBwb3dlciBvciB3YXMgcmVzZXQKYWhjaSAwMDAwOjAwOjFm
LjI6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IGNh
Y2hlIGxpbmUgc2l6ZSBvZiA2NCBpcyBub3Qgc3VwcG9ydGVkCml3bHdpZmkgMDAwMDoxMjowMC4w
OiBSRl9LSUxMIGJpdCB0b2dnbGVkIHRvIGVuYWJsZSByYWRpby4Kc25kX2hkYV9pbnRlbCAwMDAw
OjAxOjAwLjE6IGlycSA1MSBmb3IgTVNJL01TSS1YCltkcm1dIFBDSUUgR0FSVCBvZiA1MTJNIGVu
YWJsZWQgKHRhYmxlIGF0IDB4MDAwMDAwMDAwMDA0MDAwMCkuCnJhZGVvbiAwMDAwOjAxOjAwLjA6
IFdCIGVuYWJsZWQKW2RybV0gZmVuY2UgZHJpdmVyIG9uIHJpbmcgMCB1c2UgZ3B1IGFkZHIgMHg0
MDAwMGMwMCBhbmQgY3B1IGFkZHIgMHhmZmZmODgwMTEwZmRhYzAwCltkcm1dIHJpbmcgdGVzdCBv
biAwIHN1Y2NlZWRlZCBpbiAxIHVzZWNzCltkcm1dIGliIHRlc3Qgb24gcmluZyAwIHN1Y2NlZWRl
ZCBpbiAwIHVzZWNzCltkcm1dIEVuYWJsaW5nIGF1ZGlvIHN1cHBvcnQKYXRhMjogU0FUQSBsaW5r
IHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCmF0YTIuMDA6IGNvbmZpZ3Vy
ZWQgZm9yIFVETUEvMTAwCnVzYiAyLTE6IHJlc2V0IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1i
ZXIgMiB1c2luZyBlaGNpX2hjZAphdGExOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMg
MTIzIFNDb250cm9sIDMwMCkKYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKYXRhNTog
U0FUQSBsaW5rIGRvd24gKFNTdGF0dXMgMCBTQ29udHJvbCAzMDApCnNkIDA6MDowOjA6IFtzZGFd
IFN0YXJ0aW5nIGRpc2sKdXNiIDEtMTogcmVzZXQgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJl
ciAyIHVzaW5nIGVoY2lfaGNkCnVzYiAyLTEuNjogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNl
IG51bWJlciA3MCB1c2luZyBlaGNpX2hjZAp1c2IgMS0xLjY6IHJlc2V0IGhpZ2gtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgMyB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMjogcmVzZXQgZnVsbC1z
cGVlZCBVU0IgZGV2aWNlIG51bWJlciA3MiB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMTogcmVz
ZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA3MSB1c2luZyBlaGNpX2hjZApQTTogcmVz
dG9yZSBvZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDE2MDMuMjA5IG1zZWNzClBNOiBJbWFnZSBy
ZXN0b3JlZCBzdWNjZXNzZnVsbHkuClJlc3RhcnRpbmcgdGFza3MgLi4uIGRvbmUuClBNOiBCYXNp
YyBtZW1vcnkgYml0bWFwcyBmcmVlZAp1c2IgMS0xLjI6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2Ug
bnVtYmVyIDExCnVzYiAyLTEuNi4zOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA3NAp2
aWRlbyBMTlhWSURFTzowMDogUmVzdG9yaW5nIGJhY2tsaWdodCBzdGF0ZQplaGNpX2hjZCAwMDAw
OjAwOjFhLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAp1c2IgMS0xLjI6IG5ldyBoaWdo
LXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDEyIHVzaW5nIGVoY2lfaGNkCnNjc2kzNiA6IHVzYi1z
dG9yYWdlIDEtMS4yOjEuMApzY3NpIDM2OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICAgICAgICAg
ICBJZGVvcyAgICAgICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzY3NpIDM2OjA6MDoxOiBDRC1S
T00gICAgICAgICAgICAgICAgICAgICBJZGVvcyAgICAgICAgICAgIDAwMDAgUFE6IDAgQU5TSTog
MgpzZCAzNjowOjA6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMiB0eXBlIDAKc3IxOiBzY3Np
My1tbWMgZHJpdmU6IDB4LzB4IGNhZGR5CnNyIDM2OjA6MDoxOiBBdHRhY2hlZCBzY3NpIENELVJP
TSBzcjEKc3IgMzY6MDowOjE6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzMgdHlwZSA1CnNkIDM2
OjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIHJlbW92YWJsZSBkaXNrCnVzYiAyLTEuNi4zOiBu
ZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA3NSB1c2luZyBlaGNpX2hjZAp1c2IgMS0x
LjI6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDEyCnVzYiAxLTEuMjogbmV3IGhpZ2gt
c3BlZWQgVVNCIGRldmljZSBudW1iZXIgMTMgdXNpbmcgZWhjaV9oY2QKc2NzaTM3IDogdXNiLXN0
b3JhZ2UgMS0xLjI6MS4wCnNjc2kgMzc6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgICAgICAgICAg
IElkZW9zICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAyCnNjc2kgMzc6MDowOjE6IENELVJP
TSAgICAgICAgICAgICAgICAgICAgIElkZW9zICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAy
CnNkIDM3OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cyIHR5cGUgMApzcjE6IHNjc2kz
LW1tYyBkcml2ZTogMHgvMHggY2FkZHkKc3IgMzc6MDowOjE6IEF0dGFjaGVkIHNjc2kgQ0QtUk9N
IHNyMQpzciAzNzowOjA6MTogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMyB0eXBlIDUKc2QgMzc6
MDowOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kgcmVtb3ZhYmxlIGRpc2sKaXdsd2lmaSAwMDAwOjEy
OjAwLjA6IEwxIERpc2FibGVkOyBFbmFibGluZyBMMFMKQUREUkNPTkYoTkVUREVWX1VQKTogd2xh
bjA6IGxpbmsgaXMgbm90IHJlYWR5CnI4MTY5IDAwMDA6MTM6MDAuMDogZXRoMDogbGluayBkb3du
CkFERFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxpbmsgaXMgbm90IHJlYWR5CmF0a2JkIHNlcmlv
MDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlz
YTAwNjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNv
ZGU+JyB0byBtYWtlIGl0IGtub3duLgpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czog
ZXJyb3JzPXJlbW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9MApFWFQ0LWZzIChzZGExKTogcmUt
bW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9MAppd2x3
aWZpIDAwMDA6MTI6MDAuMDogUkZfS0lMTCBiaXQgdG9nZ2xlZCB0byBkaXNhYmxlIHJhZGlvLgpp
d2x3aWZpIDAwMDA6MTI6MDAuMDogQ29tbWFuZCBSRVBMWV9SWE9OIGFib3J0ZWQ6IFJGIEtJTEwg
U3dpdGNoCmtleWJvYXJkOiBjYW4ndCBlbXVsYXRlIHJhd21vZGUgZm9yIGtleWNvZGUgMjQwCmtl
eWJvYXJkOiBjYW4ndCBlbXVsYXRlIHJhd21vZGUgZm9yIGtleWNvZGUgMjQwCmdlbmVyaWMtdXNi
IDAwMDM6NDEzQzo4MTYxLjAwMEY6IGNhbid0IHJlc2V0IGRldmljZSwgMDAwMDowMDoxZC4wLTEu
Ni4xL2lucHV0MCwgc3RhdHVzIC0zMgpnZW5lcmljLXVzYiAwMDAzOjQxM0M6ODE2MS4wMDBGOiBj
YW4ndCByZXNldCBkZXZpY2UsIDAwMDA6MDA6MWQuMC0xLjYuMS9pbnB1dDAsIHN0YXR1cyAtMzIK
Z2VuZXJpYy11c2IgMDAwMzo0MTNDOjgxNjEuMDAwRjogY2FuJ3QgcmVzZXQgZGV2aWNlLCAwMDAw
OjAwOjFkLjAtMS42LjEvaW5wdXQwLCBzdGF0dXMgLTMyCmdlbmVyaWMtdXNiIDAwMDM6NDEzQzo4
MTYxLjAwMEY6IGNhbid0IHJlc2V0IGRldmljZSwgMDAwMDowMDoxZC4wLTEuNi4xL2lucHV0MCwg
c3RhdHVzIC0zMgpnZW5lcmljLXVzYiAwMDAzOjQxM0M6ODE2MS4wMDBGOiBjYW4ndCByZXNldCBk
ZXZpY2UsIDAwMDA6MDA6MWQuMC0xLjYuMS9pbnB1dDAsIHN0YXR1cyAtMzIKdXNiIDItMS42OiBV
U0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA3MAp1c2IgMi0xLjYuMTogVVNCIGRpc2Nvbm5l
Y3QsIGRldmljZSBudW1iZXIgNzEKdXNiIDItMS42LjI6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2Ug
bnVtYmVyIDcyCnVzYiAyLTEuNi4zOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA3NQph
dGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUg
MHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBl
MDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KYXRrYmQgc2VyaW8wOiBVbmtub3duIGtl
eSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQgb24gaXNhMDA2MC9zZXJpbzAp
LgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5Y29kZT4nIHRvIG1ha2Ug
aXQga25vd24uClNHSSBYRlMgd2l0aCBBQ0xzLCBzZWN1cml0eSBhdHRyaWJ1dGVzLCByZWFsdGlt
ZSwgbGFyZ2UgYmxvY2svaW5vZGUgbnVtYmVycywgbm8gZGVidWcgZW5hYmxlZApTR0kgWEZTIFF1
b3RhIE1hbmFnZW1lbnQgc3Vic3lzdGVtCkpGUzogblR4QmxvY2sgPSA4MTkyLCBuVHhMb2NrID0g
NjU1MzYKTlRGUyBkcml2ZXIgMi4xLjMwIFtGbGFnczogUi9PIE1PRFVMRV0uClFOWDQgZmlsZXN5
c3RlbSAwLjIuMyByZWdpc3RlcmVkLgpCdHJmcyBsb2FkZWQKTWF5IDMxIDIyOjU3OjI5IHBoeWxs
aXMga2VybmVsOiBLZXJuZWwgbG9nZ2luZyAocHJvYykgc3RvcHBlZC4KTWF5IDMxIDIyOjU4OjU1
IHBoeWxsaXMga2VybmVsOiBpbWtsb2cgNC42LjQsIGxvZyBzb3VyY2UgPSAvcHJvYy9rbXNnIHN0
YXJ0ZWQuCkluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGNwdXNldApJbml0aWFsaXppbmcgY2dy
b3VwIHN1YnN5cyBjcHUKTGludXggdmVyc2lvbiAzLjQuMCAobWFyZWJyaUBwaHlsbGlzKSAoZ2Nj
IHZlcnNpb24gNC41LjIgKFVidW50dS9MaW5hcm8gNC41LjItOHVidW50dTQpICkgIzEgU01QIFRo
dSBNYXkgMzEgMjI6MDM6NDQgRUFUIDIwMTIKQ29tbWFuZCBsaW5lOiBCT09UX0lNQUdFPS9ib290
L3ZtbGludXotMy40LjAgcm9vdD1VVUlEPTg5ZGE0Yzg3LTI1ODktNDc0MS05MTE1LWMzNGRlMTFi
M2FhNCBybyBjcmFzaGtlcm5lbD0zODRNLTJHOjY0TSwyRy06MTI4TSBxdWlldCBzcGxhc2gKQklP
Uy1wcm92aWRlZCBwaHlzaWNhbCBSQU0gbWFwOgogQklPUy1lODIwOiAwMDAwMDAwMDAwMDAwMDAw
IC0gMDAwMDAwMDAwMDA5ZDQwMCAodXNhYmxlKQogQklPUy1lODIwOiAwMDAwMDAwMDAwMDlkNDAw
IC0gMDAwMDAwMDAwMDBhMDAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6IDAwMDAwMDAwMDAwZTAw
MDAgLSAwMDAwMDAwMDAwMTAwMDAwIChyZXNlcnZlZCkKIEJJT1MtZTgyMDogMDAwMDAwMDAwMDEw
MDAwMCAtIDAwMDAwMDAwYmY1YTcwMDAgKHVzYWJsZSkKIEJJT1MtZTgyMDogMDAwMDAwMDBiZjVh
NzAwMCAtIDAwMDAwMDAwYmY1ZWYwMDAgKEFDUEkgTlZTKQogQklPUy1lODIwOiAwMDAwMDAwMGJm
NWVmMDAwIC0gMDAwMDAwMDBiZjVmOTAwMCAoQUNQSSBkYXRhKQogQklPUy1lODIwOiAwMDAwMDAw
MGJmNWY5MDAwIC0gMDAwMDAwMDBiZjVmYzAwMCAoQUNQSSBOVlMpCiBCSU9TLWU4MjA6IDAwMDAw
MDAwYmY1ZmMwMDAgLSAwMDAwMDAwMGJmNjIwMDAwIChyZXNlcnZlZCkKIEJJT1MtZTgyMDogMDAw
MDAwMDBiZjYyMDAwMCAtIDAwMDAwMDAwYmY2MjEwMDAgKHVzYWJsZSkKIEJJT1MtZTgyMDogMDAw
MDAwMDBiZjYyMTAwMCAtIDAwMDAwMDAwYmY2MjkwMDAgKEFDUEkgTlZTKQogQklPUy1lODIwOiAw
MDAwMDAwMGJmNjI5MDAwIC0gMDAwMDAwMDBiZjYyYzAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6
IDAwMDAwMDAwYmY2MmMwMDAgLSAwMDAwMDAwMGJmNjMxMDAwIChBQ1BJIE5WUykKIEJJT1MtZTgy
MDogMDAwMDAwMDBiZjYzMTAwMCAtIDAwMDAwMDAwYmY2NTEwMDAgKHJlc2VydmVkKQogQklPUy1l
ODIwOiAwMDAwMDAwMGJmNjUxMDAwIC0gMDAwMDAwMDBiZjY5NDAwMCAoQUNQSSBOVlMpCiBCSU9T
LWU4MjA6IDAwMDAwMDAwYmY2OTQwMDAgLSAwMDAwMDAwMGJmODAwMDAwICh1c2FibGUpCiBCSU9T
LWU4MjA6IDAwMDAwMDAwZTAwMDAwMDAgLSAwMDAwMDAwMGYwMDAwMDAwIChyZXNlcnZlZCkKIEJJ
T1MtZTgyMDogMDAwMDAwMDBmZWQxYzAwMCAtIDAwMDAwMDAwZmVkMjAwMDAgKHJlc2VydmVkKQog
QklPUy1lODIwOiAwMDAwMDAwMGZmMDAwMDAwIC0gMDAwMDAwMDEwMDAwMDAwMCAocmVzZXJ2ZWQp
CiBCSU9TLWU4MjA6IDAwMDAwMDAxMDAwMDAwMDAgLSAwMDAwMDAwMTM4MDAwMDAwICh1c2FibGUp
Ck5YIChFeGVjdXRlIERpc2FibGUpIHByb3RlY3Rpb246IGFjdGl2ZQpETUkgMi42IHByZXNlbnQu
CkRNSTogRGVsbCBJbmMuIEluc3Bpcm9uIE41MDEwLzBZWFhKSiwgQklPUyBBMTAgMTEvMTcvMjAx
MAplODIwIHVwZGF0ZSByYW5nZTogMDAwMDAwMDAwMDAwMDAwMCAtIDAwMDAwMDAwMDAwMTAwMDAg
KHVzYWJsZSkgPT0+IChyZXNlcnZlZCkKZTgyMCByZW1vdmUgcmFuZ2U6IDAwMDAwMDAwMDAwYTAw
MDAgLSAwMDAwMDAwMDAwMTAwMDAwICh1c2FibGUpCk5vIEFHUCBicmlkZ2UgZm91bmQKbGFzdF9w
Zm4gPSAweDEzODAwMCBtYXhfYXJjaF9wZm4gPSAweDQwMDAwMDAwMApNVFJSIGRlZmF1bHQgdHlw
ZTogdW5jYWNoYWJsZQpNVFJSIGZpeGVkIHJhbmdlcyBlbmFibGVkOgogIDAwMDAwLTlGRkZGIHdy
aXRlLWJhY2sKICBBMDAwMC1CRkZGRiB1bmNhY2hhYmxlCiAgQzAwMDAtQ0ZGRkYgd3JpdGUtcHJv
dGVjdAogIEQwMDAwLUU3RkZGIHVuY2FjaGFibGUKICBFODAwMC1GRkZGRiB3cml0ZS1wcm90ZWN0
Ck1UUlIgdmFyaWFibGUgcmFuZ2VzIGVuYWJsZWQ6CiAgMCBiYXNlIDAwMDAwMDAwMCBtYXNrIEYw
MDAwMDAwMCB3cml0ZS1iYWNrCiAgMSBiYXNlIDEwMDAwMDAwMCBtYXNrIEZDMDAwMDAwMCB3cml0
ZS1iYWNrCiAgMiBiYXNlIDBDMDAwMDAwMCBtYXNrIEZDMDAwMDAwMCB1bmNhY2hhYmxlCiAgMyBi
YXNlIDEzODAwMDAwMCBtYXNrIEZGODAwMDAwMCB1bmNhY2hhYmxlCiAgNCBkaXNhYmxlZAogIDUg
ZGlzYWJsZWQKICA2IGRpc2FibGVkCiAgNyBkaXNhYmxlZAp4ODYgUEFUIGVuYWJsZWQ6IGNwdSAw
LCBvbGQgMHg3MDQwNjAwMDcwNDA2LCBuZXcgMHg3MDEwNjAwMDcwMTA2CmU4MjAgdXBkYXRlIHJh
bmdlOiAwMDAwMDAwMGMwMDAwMDAwIC0gMDAwMDAwMDEwMDAwMDAwMCAodXNhYmxlKSA9PT4gKHJl
c2VydmVkKQpsYXN0X3BmbiA9IDB4YmY4MDAgbWF4X2FyY2hfcGZuID0gMHg0MDAwMDAwMDAKZm91
bmQgU01QIE1QLXRhYmxlIGF0IFtmZmZmODgwMDAwMGZjZGIwXSBmY2RiMAppbml0aWFsIG1lbW9y
eSBtYXBwZWQgOiAwIC0gMjAwMDAwMDAKQmFzZSBtZW1vcnkgdHJhbXBvbGluZSBhdCBbZmZmZjg4
MDAwMDA5ODAwMF0gOTgwMDAgc2l6ZSAyMDQ4MAppbml0X21lbW9yeV9tYXBwaW5nOiAwMDAwMDAw
MDAwMDAwMDAwLTAwMDAwMDAwYmY4MDAwMDAKIDAwMDAwMDAwMDAgLSAwMGJmODAwMDAwIHBhZ2Ug
Mk0Ka2VybmVsIGRpcmVjdCBtYXBwaW5nIHRhYmxlcyB1cCB0byBiZjgwMDAwMCBAIDFmZmZjMDAw
LTIwMDAwMDAwCmluaXRfbWVtb3J5X21hcHBpbmc6IDAwMDAwMDAxMDAwMDAwMDAtMDAwMDAwMDEz
ODAwMDAwMAogMDEwMDAwMDAwMCAtIDAxMzgwMDAwMDAgcGFnZSAyTQprZXJuZWwgZGlyZWN0IG1h
cHBpbmcgdGFibGVzIHVwIHRvIDEzODAwMDAwMCBAIGJmN2ZhMDAwLWJmODAwMDAwClJBTURJU0s6
IDI1NmRjMDAwIC0gMmViNjYwMDAKUmVzZXJ2aW5nIDEyOE1CIG9mIG1lbW9yeSBhdCA3NjhNQiBm
b3IgY3Jhc2hrZXJuZWwgKFN5c3RlbSBSQU06IDM5NThNQikKQUNQSTogUlNEUCAwMDAwMDAwMDAw
MGYwNDEwIDAwMDI0ICh2MDMgREVMTCAgKQpBQ1BJOiBYU0RUIDAwMDAwMDAwYmY1ZWYwODAgMDAw
NTQgKHYwMSBERUxMICAgIFdOMDkgICAgMDEwNzIwMDkgQU1JICAwMDAxMDAxMykKQUNQSTogRkFD
UCAwMDAwMDAwMGJmNWY4YTQ4IDAwMEY0ICh2MDQgREVMTCAgICBXTjA5ICAgIDAxMDcyMDA5IEFN
SSAgMDAwMTAwMTMpCkFDUEkgV2FybmluZzogMzIvNjQgRkFDUyBhZGRyZXNzIG1pc21hdGNoIGlu
IEZBRFQgLSB0d28gRkFDUyB0YWJsZXMhICgyMDEyMDMyMC90YmZhZHQtMzc4KQpBQ1BJIFdhcm5p
bmc6IDMyLzY0WCBGQUNTIGFkZHJlc3MgbWlzbWF0Y2ggaW4gRkFEVCAtIDB4QkY2MkNGNDAvMHgw
MDAwMDAwMEJGNjJDRjgwLCB1c2luZyAzMiAoMjAxMjAzMjAvdGJmYWR0LTUwMikKQUNQSTogRFNE
VCAwMDAwMDAwMGJmNWVmMTY4IDA5OERGICh2MDIgREVMTCAgICBXTjA5ICAgIDAwMDA1MDEwIElO
VEwgMjAwNTExMTcpCkFDUEk6IEZBQ1MgMDAwMDAwMDBiZjYyY2Y0MCAwMDA0MApBQ1BJOiBBUElD
IDAwMDAwMDAwYmY1ZjhiNDAgMDAwNzIgKHYwMSBERUxMICAgV04wOSAgICAgMDEwNzIwMDkgQU1J
ICAwMDAxMDAxMykKQUNQSTogU1NEVCAwMDAwMDAwMGJmNWY4YmI4IDAwMTRFICh2MDEgQU1JQ1BV
ICAgICBQUk9DIDAwMDAwMDAxIE1TRlQgMDMwMDAwMDEpCkFDUEk6IE1DRkcgMDAwMDAwMDBiZjVm
OGQwOCAwMDAzQyAodjAxICAgREVMTCAgICAgV04wOSAwMTA3MjAwOSBNU0ZUIDAwMDAwMDk3KQpB
Q1BJOiBIUEVUIDAwMDAwMDAwYmY1ZjhkNDggMDAwMzggKHYwMSAgIERFTEwgICAgIFdOMDkgMDEw
NzIwMDkgQU1JLiAwMDAwMDAwMykKQUNQSTogT1NGUiAwMDAwMDAwMGJmNWY4ZDgwIDAwMDhDICh2
MDEgREVMTCAgICBNMDggICAgIDA3REEwQjExIEFTTCAgMDAwMDAwNjEpCkFDUEk6IExvY2FsIEFQ
SUMgYWRkcmVzcyAweGZlZTAwMDAwCk5vIE5VTUEgY29uZmlndXJhdGlvbiBmb3VuZApGYWtpbmcg
YSBub2RlIGF0IDAwMDAwMDAwMDAwMDAwMDAtMDAwMDAwMDEzODAwMDAwMApJbml0bWVtIHNldHVw
IG5vZGUgMCAwMDAwMDAwMDAwMDAwMDAwLTAwMDAwMDAxMzgwMDAwMDAKICBOT0RFX0RBVEEgWzAw
MDAwMDAxMzdmZmMwMDAgLSAwMDAwMDAwMTM3ZmZmZmZmXQogW2ZmZmZlYTAwMDAwMDAwMDAtZmZm
ZmVhMDAwNGRmZmZmZl0gUE1EIC0+IFtmZmZmODgwMTMzODAwMDAwLWZmZmY4ODAxMzc1ZmZmZmZd
IG9uIG5vZGUgMApab25lIFBGTiByYW5nZXM6CiAgRE1BICAgICAgMHgwMDAwMDAxMCAtPiAweDAw
MDAxMDAwCiAgRE1BMzIgICAgMHgwMDAwMTAwMCAtPiAweDAwMTAwMDAwCiAgTm9ybWFsICAgMHgw
MDEwMDAwMCAtPiAweDAwMTM4MDAwCk1vdmFibGUgem9uZSBzdGFydCBQRk4gZm9yIGVhY2ggbm9k
ZQpFYXJseSBtZW1vcnkgUEZOIHJhbmdlcwogICAgMDogMHgwMDAwMDAxMCAtPiAweDAwMDAwMDlk
CiAgICAwOiAweDAwMDAwMTAwIC0+IDB4MDAwYmY1YTcKICAgIDA6IDB4MDAwYmY2MjAgLT4gMHgw
MDBiZjYyMQogICAgMDogMHgwMDBiZjY5NCAtPiAweDAwMGJmODAwCiAgICAwOiAweDAwMTAwMDAw
IC0+IDB4MDAxMzgwMDAKT24gbm9kZSAwIHRvdGFscGFnZXM6IDEwMTM0MDkKICBETUEgem9uZTog
NjQgcGFnZXMgdXNlZCBmb3IgbWVtbWFwCiAgRE1BIHpvbmU6IDUgcGFnZXMgcmVzZXJ2ZWQKICBE
TUEgem9uZTogMzkxMiBwYWdlcywgTElGTyBiYXRjaDowCiAgRE1BMzIgem9uZTogMTYzMjAgcGFn
ZXMgdXNlZCBmb3IgbWVtbWFwCiAgRE1BMzIgem9uZTogNzYzNzMyIHBhZ2VzLCBMSUZPIGJhdGNo
OjMxCiAgTm9ybWFsIHpvbmU6IDM1ODQgcGFnZXMgdXNlZCBmb3IgbWVtbWFwCiAgTm9ybWFsIHpv
bmU6IDIyNTc5MiBwYWdlcywgTElGTyBiYXRjaDozMQpBQ1BJOiBQTS1UaW1lciBJTyBQb3J0OiAw
eDQwOApBQ1BJOiBMb2NhbCBBUElDIGFkZHJlc3MgMHhmZWUwMDAwMApBQ1BJOiBMQVBJQyAoYWNw
aV9pZFsweDAxXSBsYXBpY19pZFsweDAwXSBlbmFibGVkKQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsw
eDAyXSBsYXBpY19pZFsweDA0XSBlbmFibGVkKQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDAzXSBs
YXBpY19pZFsweDAxXSBlbmFibGVkKQpBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDA0XSBsYXBpY19p
ZFsweDA1XSBlbmFibGVkKQpBQ1BJOiBMQVBJQ19OTUkgKGFjcGlfaWRbMHhmZl0gaGlnaCBlZGdl
IGxpbnRbMHgxXSkKQUNQSTogSU9BUElDIChpZFsweDAwXSBhZGRyZXNzWzB4ZmVjMDAwMDBdIGdz
aV9iYXNlWzBdKQpJT0FQSUNbMF06IGFwaWNfaWQgMCwgdmVyc2lvbiAzMiwgYWRkcmVzcyAweGZl
YzAwMDAwLCBHU0kgMC0yMwpBQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSAwIGdsb2Jh
bF9pcnEgMiBkZmwgZGZsKQpBQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSA5IGdsb2Jh
bF9pcnEgOSBoaWdoIGxldmVsKQpBQ1BJOiBJUlEwIHVzZWQgYnkgb3ZlcnJpZGUuCkFDUEk6IElS
UTIgdXNlZCBieSBvdmVycmlkZS4KQUNQSTogSVJROSB1c2VkIGJ5IG92ZXJyaWRlLgpVc2luZyBB
Q1BJIChNQURUKSBmb3IgU01QIGNvbmZpZ3VyYXRpb24gaW5mb3JtYXRpb24KQUNQSTogSFBFVCBp
ZDogMHg4MDg2YTcwMSBiYXNlOiAweGZlZDAwMDAwClNNUDogQWxsb3dpbmcgNCBDUFVzLCAwIGhv
dHBsdWcgQ1BVcwpucl9pcnFzX2dzaTogNDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTog
MDAwMDAwMDAwMDA5ZDAwMCAtIDAwMDAwMDAwMDAwOWUwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZl
IG1lbW9yeTogMDAwMDAwMDAwMDA5ZTAwMCAtIDAwMDAwMDAwMDAwYTAwMDAKUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAwMDBhMDAwMCAtIDAwMDAwMDAwMDAwZTAwMDAKUE06
IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAwMDBlMDAwMCAtIDAwMDAwMDAwMDAx
MDAwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBiZjVhNzAwMCAtIDAw
MDAwMDAwYmY1ZWYwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBiZjVl
ZjAwMCAtIDAwMDAwMDAwYmY1ZjkwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAw
MDAwMDBiZjVmOTAwMCAtIDAwMDAwMDAwYmY1ZmMwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1l
bW9yeTogMDAwMDAwMDBiZjVmYzAwMCAtIDAwMDAwMDAwYmY2MjAwMDAKUE06IFJlZ2lzdGVyZWQg
bm9zYXZlIG1lbW9yeTogMDAwMDAwMDBiZjYyMTAwMCAtIDAwMDAwMDAwYmY2MjkwMDAKUE06IFJl
Z2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBiZjYyOTAwMCAtIDAwMDAwMDAwYmY2MmMw
MDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBiZjYyYzAwMCAtIDAwMDAw
MDAwYmY2MzEwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBiZjYzMTAw
MCAtIDAwMDAwMDAwYmY2NTEwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAw
MDBiZjY1MTAwMCAtIDAwMDAwMDAwYmY2OTQwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9y
eTogMDAwMDAwMDBiZjgwMDAwMCAtIDAwMDAwMDAwZTAwMDAwMDAKUE06IFJlZ2lzdGVyZWQgbm9z
YXZlIG1lbW9yeTogMDAwMDAwMDBlMDAwMDAwMCAtIDAwMDAwMDAwZjAwMDAwMDAKUE06IFJlZ2lz
dGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmMDAwMDAwMCAtIDAwMDAwMDAwZmVkMWMwMDAK
UE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmZWQxYzAwMCAtIDAwMDAwMDAw
ZmVkMjAwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmZWQyMDAwMCAt
IDAwMDAwMDAwZmYwMDAwMDAKUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ZjAwMDAwMCAtIDAwMDAwMDAxMDAwMDAwMDAKQWxsb2NhdGluZyBQQ0kgcmVzb3VyY2VzIHN0YXJ0
aW5nIGF0IGJmODAwMDAwIChnYXA6IGJmODAwMDAwOjIwODAwMDAwKQpCb290aW5nIHBhcmF2aXJ0
dWFsaXplZCBrZXJuZWwgb24gYmFyZSBoYXJkd2FyZQpzZXR1cF9wZXJjcHU6IE5SX0NQVVM6NjQg
bnJfY3B1bWFza19iaXRzOjY0IG5yX2NwdV9pZHM6NCBucl9ub2RlX2lkczoxClBFUkNQVTogRW1i
ZWRkZWQgMjggcGFnZXMvY3B1IEBmZmZmODgwMTM3YzAwMDAwIHM4Mjc1MiByODE5MiBkMjM3NDQg
dTUyNDI4OApwY3B1LWFsbG9jOiBzODI3NTIgcjgxOTIgZDIzNzQ0IHU1MjQyODggYWxsb2M9MSoy
MDk3MTUyCnBjcHUtYWxsb2M6IFswXSAwIDEgMiAzIApCdWlsdCAxIHpvbmVsaXN0cyBpbiBOb2Rl
IG9yZGVyLCBtb2JpbGl0eSBncm91cGluZyBvbi4gIFRvdGFsIHBhZ2VzOiA5OTM0MzYKUG9saWN5
IHpvbmU6IE5vcm1hbApLZXJuZWwgY29tbWFuZCBsaW5lOiBCT09UX0lNQUdFPS9ib290L3ZtbGlu
dXotMy40LjAgcm9vdD1VVUlEPTg5ZGE0Yzg3LTI1ODktNDc0MS05MTE1LWMzNGRlMTFiM2FhNCBy
byBjcmFzaGtlcm5lbD0zODRNLTJHOjY0TSwyRy06MTI4TSBxdWlldCBzcGxhc2gKUElEIGhhc2gg
dGFibGUgZW50cmllczogNDA5NiAob3JkZXI6IDMsIDMyNzY4IGJ5dGVzKQpDaGVja2luZyBhcGVy
dHVyZS4uLgpObyBBR1AgYnJpZGdlIGZvdW5kCkNhbGdhcnk6IGRldGVjdGluZyBDYWxnYXJ5IHZp
YSBCSU9TIEVCREEgYXJlYQpDYWxnYXJ5OiBVbmFibGUgdG8gbG9jYXRlIFJpbyBHcmFuZGUgdGFi
bGUgaW4gRUJEQSAtIGJhaWxpbmchCk1lbW9yeTogMzYyNDk1MmsvNTExMTgwOGsgYXZhaWxhYmxl
ICg2MjU5ayBrZXJuZWwgY29kZSwgMTA1ODE3MmsgYWJzZW50LCA0Mjg2ODRrIHJlc2VydmVkLCA2
ODE4ayBkYXRhLCA4OTJrIGluaXQpClNMVUI6IEdlbnNsYWJzPTE1LCBIV2FsaWduPTY0LCBPcmRl
cj0wLTMsIE1pbk9iamVjdHM9MCwgQ1BVcz00LCBOb2Rlcz0xCkhpZXJhcmNoaWNhbCBSQ1UgaW1w
bGVtZW50YXRpb24uCiAgICAgICBSQ1UgZHludGljay1pZGxlIGdyYWNlLXBlcmlvZCBhY2NlbGVy
YXRpb24gaXMgZW5hYmxlZC4KTlJfSVJRUzo0MzUyIG5yX2lycXM6NzEyIDE2CkV4dGVuZGVkIENN
T1MgeWVhcjogMjAwMApDb25zb2xlOiBjb2xvdXIgVkdBKyA4MHgyNQpjb25zb2xlIFt0dHkwXSBl
bmFibGVkCmFsbG9jYXRlZCAxNjI1MjkyOCBieXRlcyBvZiBwYWdlX2Nncm91cApwbGVhc2UgdHJ5
ICdjZ3JvdXBfZGlzYWJsZT1tZW1vcnknIG9wdGlvbiBpZiB5b3UgZG9uJ3Qgd2FudCBtZW1vcnkg
Y2dyb3VwcwpocGV0IGNsb2NrZXZlbnQgcmVnaXN0ZXJlZApGYXN0IFRTQyBjYWxpYnJhdGlvbiB1
c2luZyBQSVQKRGV0ZWN0ZWQgMjUyNi45MTAgTUh6IHByb2Nlc3Nvci4KQ2FsaWJyYXRpbmcgZGVs
YXkgbG9vcCAoc2tpcHBlZCksIHZhbHVlIGNhbGN1bGF0ZWQgdXNpbmcgdGltZXIgZnJlcXVlbmN5
Li4gNTA1My44MiBCb2dvTUlQUyAobHBqPTI1MjY5MTAwKQpwaWRfbWF4OiBkZWZhdWx0OiAzMjc2
OCBtaW5pbXVtOiAzMDEKU2VjdXJpdHkgRnJhbWV3b3JrIGluaXRpYWxpemVkCkFwcEFybW9yOiBB
cHBBcm1vciBpbml0aWFsaXplZApEZW50cnkgY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA1MjQy
ODggKG9yZGVyOiAxMCwgNDE5NDMwNCBieXRlcykKSW5vZGUtY2FjaGUgaGFzaCB0YWJsZSBlbnRy
aWVzOiAyNjIxNDQgKG9yZGVyOiA5LCAyMDk3MTUyIGJ5dGVzKQpNb3VudC1jYWNoZSBoYXNoIHRh
YmxlIGVudHJpZXM6IDI1NgpJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBjcHVhY2N0CkluaXRp
YWxpemluZyBjZ3JvdXAgc3Vic3lzIG1lbW9yeQpJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBk
ZXZpY2VzCkluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGZyZWV6ZXIKSW5pdGlhbGl6aW5nIGNn
cm91cCBzdWJzeXMgbmV0X2NscwpJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBwZXJmX2V2ZW50
CkNQVTogUGh5c2ljYWwgUHJvY2Vzc29yIElEOiAwCkNQVTogUHJvY2Vzc29yIENvcmUgSUQ6IDAK
bWNlOiBDUFUgc3VwcG9ydHMgOSBNQ0UgYmFua3MKQ1BVMDogVGhlcm1hbCBtb25pdG9yaW5nIGVu
YWJsZWQgKFRNMSkKdXNpbmcgbXdhaXQgaW4gaWRsZSB0aHJlYWRzLgpBQ1BJOiBDb3JlIHJldmlz
aW9uIDIwMTIwMzIwCmZ0cmFjZTogYWxsb2NhdGluZyAyMzQyNSBlbnRyaWVzIGluIDkyIHBhZ2Vz
Ci4uVElNRVI6IHZlY3Rvcj0weDMwIGFwaWMxPTAgcGluMT0yIGFwaWMyPS0xIHBpbjI9LTEKQ1BV
MDogSW50ZWwoUikgQ29yZShUTSkgaTUgQ1BVICAgICAgIE0gNDYwICBAIDIuNTNHSHogc3RlcHBp
bmcgMDUKUGVyZm9ybWFuY2UgRXZlbnRzOiBQRUJTIGZtdDErLCAxNi1kZWVwIExCUiwgV2VzdG1l
cmUgZXZlbnRzLCBJbnRlbCBQTVUgZHJpdmVyLgpDUFVJRCBtYXJrZWQgZXZlbnQ6ICdidXMgY3lj
bGVzJyB1bmF2YWlsYWJsZQouLi4gdmVyc2lvbjogICAgICAgICAgICAgICAgMwouLi4gYml0IHdp
ZHRoOiAgICAgICAgICAgICAgNDgKLi4uIGdlbmVyaWMgcmVnaXN0ZXJzOiAgICAgIDQKLi4uIHZh
bHVlIG1hc2s6ICAgICAgICAgICAgIDAwMDBmZmZmZmZmZmZmZmYKLi4uIG1heCBwZXJpb2Q6ICAg
ICAgICAgICAgIDAwMDAwMDAwN2ZmZmZmZmYKLi4uIGZpeGVkLXB1cnBvc2UgZXZlbnRzOiAgIDMK
Li4uIGV2ZW50IG1hc2s6ICAgICAgICAgICAgIDAwMDAwMDA3MDAwMDAwMGYKQm9vdGluZyBOb2Rl
ICAgMCwgUHJvY2Vzc29ycyAgIzEgIzIgIzMgT2suCkJyb3VnaHQgdXAgNCBDUFVzClRvdGFsIG9m
IDQgcHJvY2Vzc29ycyBhY3RpdmF0ZWQgKDIwMjE1LjI4IEJvZ29NSVBTKS4KZGV2dG1wZnM6IGlu
aXRpYWxpemVkClBNOiBSZWdpc3RlcmluZyBBQ1BJIE5WUyByZWdpb24gW21lbSAweGJmNWE3MDAw
LTB4YmY1ZWVmZmZdICgyOTQ5MTIgYnl0ZXMpClBNOiBSZWdpc3RlcmluZyBBQ1BJIE5WUyByZWdp
b24gW21lbSAweGJmNWY5MDAwLTB4YmY1ZmJmZmZdICgxMjI4OCBieXRlcykKUE06IFJlZ2lzdGVy
aW5nIEFDUEkgTlZTIHJlZ2lvbiBbbWVtIDB4YmY2MjEwMDAtMHhiZjYyOGZmZl0gKDMyNzY4IGJ5
dGVzKQpQTTogUmVnaXN0ZXJpbmcgQUNQSSBOVlMgcmVnaW9uIFttZW0gMHhiZjYyYzAwMC0weGJm
NjMwZmZmXSAoMjA0ODAgYnl0ZXMpClBNOiBSZWdpc3RlcmluZyBBQ1BJIE5WUyByZWdpb24gW21l
bSAweGJmNjUxMDAwLTB4YmY2OTNmZmZdICgyNzQ0MzIgYnl0ZXMpCmR1bW15OiAKUlRDIHRpbWU6
IDE5OjU4OjM2LCBkYXRlOiAwNS8zMS8xMgpORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5
IDE2CkFDUEk6IGJ1cyB0eXBlIHBjaSByZWdpc3RlcmVkClBDSTogTU1DT05GSUcgZm9yIGRvbWFp
biAwMDAwIFtidXMgMDAtZmZdIGF0IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmXSAoYmFzZSAw
eGUwMDAwMDAwKQpQQ0k6IE1NQ09ORklHIGF0IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmXSBy
ZXNlcnZlZCBpbiBFODIwClBDSTogVXNpbmcgY29uZmlndXJhdGlvbiB0eXBlIDEgZm9yIGJhc2Ug
YWNjZXNzCmJpbzogY3JlYXRlIHNsYWIgPGJpby0wPiBhdCAwCkFDUEk6IEFkZGVkIF9PU0koTW9k
dWxlIERldmljZSkKQUNQSTogQWRkZWQgX09TSShQcm9jZXNzb3IgRGV2aWNlKQpBQ1BJOiBBZGRl
ZCBfT1NJKDMuMCBfU0NQIEV4dGVuc2lvbnMpCkFDUEk6IEFkZGVkIF9PU0koUHJvY2Vzc29yIEFn
Z3JlZ2F0b3IgRGV2aWNlKQpBQ1BJOiBFQzogTG9vayB1cCBFQyBpbiBEU0RUCkFDUEk6IEV4ZWN1
dGVkIDEgYmxvY2tzIG9mIG1vZHVsZS1sZXZlbCBleGVjdXRhYmxlIEFNTCBjb2RlCltGaXJtd2Fy
ZSBCdWddOiBBQ1BJOiBCSU9TIF9PU0koTGludXgpIHF1ZXJ5IGlnbm9yZWQKQUNQSTogU1NEVCAw
MDAwMDAwMGJmNjIxYzE4IDAwM0E0ICh2MDEgICAgQU1JICAgICAgSVNUIDAwMDAwMDAxIE1TRlQg
MDMwMDAwMDEpCkFDUEk6IER5bmFtaWMgT0VNIFRhYmxlIExvYWQ6CkFDUEk6IFNTRFQgICAgICAg
ICAgIChudWxsKSAwMDNBNCAodjAxICAgIEFNSSAgICAgIElTVCAwMDAwMDAwMSBNU0ZUIDAzMDAw
MDAxKQpBQ1BJOiBJbnRlcnByZXRlciBlbmFibGVkCkFDUEk6IChzdXBwb3J0cyBTMCBTMyBTNCBT
NSkKQUNQSTogVXNpbmcgSU9BUElDIGZvciBpbnRlcnJ1cHQgcm91dGluZwpBQ1BJOiBObyBkb2Nr
IGRldmljZXMgZm91bmQuClBDSTogVXNpbmcgaG9zdCBicmlkZ2Ugd2luZG93cyBmcm9tIEFDUEk7
IGlmIG5lY2Vzc2FyeSwgdXNlICJwY2k9bm9jcnMiIGFuZCByZXBvcnQgYSBidWcKQUNQSTogUENJ
IFJvb3QgQnJpZGdlIFtQQ0kwXSAoZG9tYWluIDAwMDAgW2J1cyAwMC1mZl0pCnBjaV9yb290IFBO
UDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbaW8gIDB4MDAwMC0weDBjZjddCnBjaV9yb290
IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbaW8gIDB4MGQwMC0weGZmZmZdCnBjaV9y
b290IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAwYTAwMDAtMHgwMDBi
ZmZmZl0KcGNpX3Jvb3QgUE5QMEEwODowMDogaG9zdCBicmlkZ2Ugd2luZG93IFttZW0gMHhjMDAw
MDAwMC0weGZmZmZmZmZmXQpQQ0kgaG9zdCBicmlkZ2UgdG8gYnVzIDAwMDA6MDAKcGNpX2J1cyAw
MDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbaW8gIDB4MDAwMC0weDBjZjddCnBjaV9idXMgMDAw
MDowMDogcm9vdCBidXMgcmVzb3VyY2UgW2lvICAweDBkMDAtMHhmZmZmXQpwY2lfYnVzIDAwMDA6
MDA6IHJvb3QgYnVzIHJlc291cmNlIFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmXQpwY2lfYnVz
IDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFttZW0gMHhjMDAwMDAwMC0weGZmZmZmZmZmXQpw
Y2kgMDAwMDowMDowMC4wOiBbODA4NjowMDQ0XSB0eXBlIDAwIGNsYXNzIDB4MDYwMDAwCnBjaSAw
MDAwOjAwOjAxLjA6IFs4MDg2OjAwNDVdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKcGNpIDAwMDA6
MDA6MDEuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKcGNpIDAwMDA6MDA6
MTYuMDogWzgwODY6M2I2NF0gdHlwZSAwMCBjbGFzcyAweDA3ODAwMApwY2kgMDAwMDowMDoxNi4w
OiByZWcgMTA6IFttZW0gMHhmYmYwOTAwMC0weGZiZjA5MDBmIDY0Yml0XQpwY2kgMDAwMDowMDox
Ni4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApwY2kgMDAwMDowMDoxYS4w
OiBbODA4NjozYjNjXSB0eXBlIDAwIGNsYXNzIDB4MGMwMzIwCnBjaSAwMDAwOjAwOjFhLjA6IHJl
ZyAxMDogW21lbSAweGZiZjA4MDAwLTB4ZmJmMDgzZmZdCnBjaSAwMDAwOjAwOjFhLjA6IFBNRSMg
c3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkCnBjaSAwMDAwOjAwOjFiLjA6IFs4MDg2OjNi
NTZdIHR5cGUgMDAgY2xhc3MgMHgwNDAzMDAKcGNpIDAwMDA6MDA6MWIuMDogcmVnIDEwOiBbbWVt
IDB4ZmJmMDAwMDAtMHhmYmYwM2ZmZiA2NGJpdF0KcGNpIDAwMDA6MDA6MWIuMDogUE1FIyBzdXBw
b3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKcGNpIDAwMDA6MDA6MWMuMDogWzgwODY6M2I0Ml0g
dHlwZSAwMSBjbGFzcyAweDA2MDQwMApwY2kgMDAwMDowMDoxYy4wOiBQTUUjIHN1cHBvcnRlZCBm
cm9tIEQwIEQzaG90IEQzY29sZApwY2kgMDAwMDowMDoxYy4xOiBbODA4NjozYjQ0XSB0eXBlIDAx
IGNsYXNzIDB4MDYwNDAwCnBjaSAwMDAwOjAwOjFjLjE6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAg
RDNob3QgRDNjb2xkCnBjaSAwMDAwOjAwOjFjLjI6IFs4MDg2OjNiNDZdIHR5cGUgMDEgY2xhc3Mg
MHgwNjA0MDAKcGNpIDAwMDA6MDA6MWMuMjogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBE
M2NvbGQKcGNpIDAwMDA6MDA6MWMuNDogWzgwODY6M2I0YV0gdHlwZSAwMSBjbGFzcyAweDA2MDQw
MApwY2kgMDAwMDowMDoxYy40OiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApw
Y2kgMDAwMDowMDoxZC4wOiBbODA4NjozYjM0XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzIwCnBjaSAw
MDAwOjAwOjFkLjA6IHJlZyAxMDogW21lbSAweGZiZjA3MDAwLTB4ZmJmMDczZmZdCnBjaSAwMDAw
OjAwOjFkLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkCnBjaSAwMDAwOjAw
OjFlLjA6IFs4MDg2OjI0NDhdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDEKcGNpIDAwMDA6MDA6MWYu
MDogWzgwODY6M2IwYl0gdHlwZSAwMCBjbGFzcyAweDA2MDEwMApwY2kgMDAwMDowMDoxZi4yOiBb
ODA4NjozYjJmXSB0eXBlIDAwIGNsYXNzIDB4MDEwNjAxCnBjaSAwMDAwOjAwOjFmLjI6IHJlZyAx
MDogW2lvICAweGYwNzAtMHhmMDc3XQpwY2kgMDAwMDowMDoxZi4yOiByZWcgMTQ6IFtpbyAgMHhm
MDYwLTB4ZjA2M10KcGNpIDAwMDA6MDA6MWYuMjogcmVnIDE4OiBbaW8gIDB4ZjA1MC0weGYwNTdd
CnBjaSAwMDAwOjAwOjFmLjI6IHJlZyAxYzogW2lvICAweGYwNDAtMHhmMDQzXQpwY2kgMDAwMDow
MDoxZi4yOiByZWcgMjA6IFtpbyAgMHhmMDIwLTB4ZjAzZl0KcGNpIDAwMDA6MDA6MWYuMjogcmVn
IDI0OiBbbWVtIDB4ZmJmMDYwMDAtMHhmYmYwNjdmZl0KcGNpIDAwMDA6MDA6MWYuMjogUE1FIyBz
dXBwb3J0ZWQgZnJvbSBEM2hvdApwY2kgMDAwMDowMDoxZi4zOiBbODA4NjozYjMwXSB0eXBlIDAw
IGNsYXNzIDB4MGMwNTAwCnBjaSAwMDAwOjAwOjFmLjM6IHJlZyAxMDogW21lbSAweGZiZjA1MDAw
LTB4ZmJmMDUwZmYgNjRiaXRdCnBjaSAwMDAwOjAwOjFmLjM6IHJlZyAyMDogW2lvICAweGYwMDAt
MHhmMDFmXQpwY2kgMDAwMDowMDoxZi42OiBbODA4NjozYjMyXSB0eXBlIDAwIGNsYXNzIDB4MTE4
MDAwCnBjaSAwMDAwOjAwOjFmLjY6IHJlZyAxMDogW21lbSAweGZiZjA0MDAwLTB4ZmJmMDRmZmYg
NjRiaXRdCnBjaSAwMDAwOjAxOjAwLjA6IFsxMDAyOjY4YzFdIHR5cGUgMDAgY2xhc3MgMHgwMzAw
MDAKcGNpIDAwMDA6MDE6MDAuMDogcmVnIDEwOiBbbWVtIDB4YzAwMDAwMDAtMHhjZmZmZmZmZiA2
NGJpdCBwcmVmXQpwY2kgMDAwMDowMTowMC4wOiByZWcgMTg6IFttZW0gMHhmYmUyMDAwMC0weGZi
ZTNmZmZmIDY0Yml0XQpwY2kgMDAwMDowMTowMC4wOiByZWcgMjA6IFtpbyAgMHhlMDAwLTB4ZTBm
Zl0KcGNpIDAwMDA6MDE6MDAuMDogcmVnIDMwOiBbbWVtIDB4ZmJlMDAwMDAtMHhmYmUxZmZmZiBw
cmVmXQpwY2kgMDAwMDowMTowMC4wOiBzdXBwb3J0cyBEMSBEMgpwY2kgMDAwMDowMTowMC4xOiBb
MTAwMjphYTYwXSB0eXBlIDAwIGNsYXNzIDB4MDQwMzAwCnBjaSAwMDAwOjAxOjAwLjE6IHJlZyAx
MDogW21lbSAweGZiZTQwMDAwLTB4ZmJlNDNmZmYgNjRiaXRdCnBjaSAwMDAwOjAxOjAwLjE6IHN1
cHBvcnRzIEQxIEQyCnBjaSAwMDAwOjAwOjAxLjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMS0wMV0K
cGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhlMDAwLTB4ZWZmZl0KcGNp
IDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYmUwMDAwMC0weGZiZWZmZmZm
XQpwY2kgMDAwMDowMDowMS4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGMwMDAwMDAwLTB4Y2Zm
ZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0byBbYnVzIDEx
LTExXQpwY2kgMDAwMDoxMjowMC4wOiBbODA4NjowMDgzXSB0eXBlIDAwIGNsYXNzIDB4MDI4MDAw
CnBjaSAwMDAwOjEyOjAwLjA6IHJlZyAxMDogW21lbSAweGZiZDAwMDAwLTB4ZmJkMDFmZmYgNjRi
aXRdCnBjaSAwMDAwOjEyOjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xk
CnBjaSAwMDAwOjAwOjFjLjE6IFBDSSBicmlkZ2UgdG8gW2J1cyAxMi0xMl0KcGNpIDAwMDA6MDA6
MWMuMTogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYmQwMDAwMC0weGZiZGZmZmZmXQpwY2kgMDAw
MDoxMzowMC4wOiBbMTBlYzo4MTM2XSB0eXBlIDAwIGNsYXNzIDB4MDIwMDAwCnBjaSAwMDAwOjEz
OjAwLjA6IHJlZyAxMDogW2lvICAweGQwMDAtMHhkMGZmXQpwY2kgMDAwMDoxMzowMC4wOiByZWcg
MTg6IFttZW0gMHhkMGMxMDAwMC0weGQwYzEwZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjEzOjAw
LjA6IHJlZyAyMDogW21lbSAweGQwYzAwMDAwLTB4ZDBjMGZmZmYgNjRiaXQgcHJlZl0KcGNpIDAw
MDA6MTM6MDAuMDogcmVnIDMwOiBbbWVtIDB4ZmIzMDAwMDAtMHhmYjMxZmZmZiBwcmVmXQpwY2kg
MDAwMDoxMzowMC4wOiBzdXBwb3J0cyBEMSBEMgpwY2kgMDAwMDoxMzowMC4wOiBQTUUjIHN1cHBv
cnRlZCBmcm9tIEQwIEQxIEQyIEQzaG90IEQzY29sZApwY2kgMDAwMDowMDoxYy4yOiBQQ0kgYnJp
ZGdlIHRvIFtidXMgMTMtMTNdCnBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbaW8g
IDB4ZDAwMC0weGRmZmZdCnBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4
ZmIzMDAwMDAtMHhmYmNmZmZmZl0KcGNpIDAwMDA6MDA6MWMuMjogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhkMGMwMDAwMC0weGQxNWZmZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjAwOjFjLjQ6IFBD
SSBicmlkZ2UgdG8gW2J1cyAxNS0xNV0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93
IFtpbyAgMHhjMDAwLTB4Y2ZmZl0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhmYTkwMDAwMC0weGZiMmZmZmZmXQpwY2kgMDAwMDowMDoxYy40OiAgIGJyaWRnZSB3aW5k
b3cgW21lbSAweGQwMTAwMDAwLTB4ZDBhZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWUu
MDogUENJIGJyaWRnZSB0byBbYnVzIDIwLTIwXSAoc3VidHJhY3RpdmUgZGVjb2RlKQpwY2kgMDAw
MDowMDoxZS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDAwMDAtMHgwY2Y3XSAoc3VidHJhY3Rp
dmUgZGVjb2RlKQpwY2kgMDAwMDowMDoxZS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDBkMDAt
MHhmZmZmXSAoc3VidHJhY3RpdmUgZGVjb2RlKQpwY2kgMDAwMDowMDoxZS4wOiAgIGJyaWRnZSB3
aW5kb3cgW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmZdIChzdWJ0cmFjdGl2ZSBkZWNvZGUpCnBj
aSAwMDAwOjAwOjFlLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4YzAwMDAwMDAtMHhmZmZmZmZm
Zl0gKHN1YnRyYWN0aXZlIGRlY29kZSkKQUNQSTogUENJIEludGVycnVwdCBSb3V0aW5nIFRhYmxl
IFtcX1NCXy5QQ0kwLl9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9T
Ql8uUENJMC5CUjIwLl9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9T
Ql8uUENJMC5QRVgwLl9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9T
Ql8uUENJMC5QRVgxLl9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9T
Ql8uUENJMC5QRVgyLl9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9T
Ql8uUENJMC5QRVg0Ll9QUlRdCiBwY2kwMDAwOjAwOiBSZXF1ZXN0aW5nIEFDUEkgX09TQyBjb250
cm9sICgweDFkKQogcGNpMDAwMDowMDogQUNQSSBfT1NDIGNvbnRyb2wgKDB4MTkpIGdyYW50ZWQK
QUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktBXSAoSVJRcyAzIDQgNSA2IDcgMTAgKjExIDEy
IDE0IDE1KQpBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0JdIChJUlFzIDMgNCA1IDYgNyAq
MTAgMTEgMTIgMTQgMTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQ10gKElSUXMgKjMg
NCA1IDYgMTAgMTEgMTIgMTQgMTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRF0gKElS
UXMgMyAqNCA1IDYgMTAgMTEgMTIgMTQgMTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5L
RV0gKElSUXMgMyA0IDUgNiA3IDEwIDExIDEyIDE0IDE1KSAqMApBQ1BJOiBQQ0kgSW50ZXJydXB0
IExpbmsgW0xOS0ZdIChJUlFzIDMgNCA1IDYgNyAxMCAxMSAxMiAxNCAxNSkgKjAKQUNQSTogUENJ
IEludGVycnVwdCBMaW5rIFtMTktHXSAoSVJRcyAzIDQgKjUgNiA3IDEwIDExIDEyIDE0IDE1KQpB
Q1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0hdIChJUlFzIDMgNCA1IDYgKjcgMTAgMTEgMTIg
MTQgMTUpCnZnYWFyYjogZGV2aWNlIGFkZGVkOiBQQ0k6MDAwMDowMTowMC4wLGRlY29kZXM9aW8r
bWVtLG93bnM9aW8rbWVtLGxvY2tzPW5vbmUKdmdhYXJiOiBsb2FkZWQKdmdhYXJiOiBicmlkZ2Ug
Y29udHJvbCBwb3NzaWJsZSAwMDAwOjAxOjAwLjAKU0NTSSBzdWJzeXN0ZW0gaW5pdGlhbGl6ZWQK
bGliYXRhIHZlcnNpb24gMy4wMCBsb2FkZWQuCnVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVy
ZmFjZSBkcml2ZXIgdXNiZnMKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZl
ciBodWIKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgZGV2aWNlIGRyaXZlciB1c2IKd21pOiBNYXBw
ZXIgbG9hZGVkClBDSTogVXNpbmcgQUNQSSBmb3IgSVJRIHJvdXRpbmcKUENJOiBEaXNjb3ZlcmVk
IHBlZXIgYnVzIGZmClBDSTogcm9vdCBidXMgZmY6IHVzaW5nIGRlZmF1bHQgcmVzb3VyY2VzClBD
SSBob3N0IGJyaWRnZSB0byBidXMgMDAwMDpmZgpwY2lfYnVzIDAwMDA6ZmY6IHJvb3QgYnVzIHJl
c291cmNlIFtpbyAgMHgwMDAwLTB4ZmZmZl0KcGNpX2J1cyAwMDAwOmZmOiByb290IGJ1cyByZXNv
dXJjZSBbbWVtIDB4MDAwMDAwMDAtMHhmZmZmZmZmZmZdCnBjaSAwMDAwOmZmOjAwLjA6IFs4MDg2
OjJjNjJdIHR5cGUgMDAgY2xhc3MgMHgwNjAwMDAKcGNpIDAwMDA6ZmY6MDAuMTogWzgwODY6MmQw
MV0gdHlwZSAwMCBjbGFzcyAweDA2MDAwMApwY2kgMDAwMDpmZjowMi4wOiBbODA4NjoyZDEwXSB0
eXBlIDAwIGNsYXNzIDB4MDYwMDAwCnBjaSAwMDAwOmZmOjAyLjE6IFs4MDg2OjJkMTFdIHR5cGUg
MDAgY2xhc3MgMHgwNjAwMDAKcGNpIDAwMDA6ZmY6MDIuMjogWzgwODY6MmQxMl0gdHlwZSAwMCBj
bGFzcyAweDA2MDAwMApwY2kgMDAwMDpmZjowMi4zOiBbODA4NjoyZDEzXSB0eXBlIDAwIGNsYXNz
IDB4MDYwMDAwClBDSTogcGNpX2NhY2hlX2xpbmVfc2l6ZSBzZXQgdG8gNjQgYnl0ZXMKcmVzZXJ2
ZSBSQU0gYnVmZmVyOiAwMDAwMDAwMDAwMDlkNDAwIC0gMDAwMDAwMDAwMDA5ZmZmZiAKcmVzZXJ2
ZSBSQU0gYnVmZmVyOiAwMDAwMDAwMGJmNWE3MDAwIC0gMDAwMDAwMDBiZmZmZmZmZiAKcmVzZXJ2
ZSBSQU0gYnVmZmVyOiAwMDAwMDAwMGJmNjIxMDAwIC0gMDAwMDAwMDBiZmZmZmZmZiAKcmVzZXJ2
ZSBSQU0gYnVmZmVyOiAwMDAwMDAwMGJmODAwMDAwIC0gMDAwMDAwMDBiZmZmZmZmZiAKTmV0TGFi
ZWw6IEluaXRpYWxpemluZwpOZXRMYWJlbDogIGRvbWFpbiBoYXNoIHNpemUgPSAxMjgKTmV0TGFi
ZWw6ICBwcm90b2NvbHMgPSBVTkxBQkVMRUQgQ0lQU092NApOZXRMYWJlbDogIHVubGFiZWxlZCB0
cmFmZmljIGFsbG93ZWQgYnkgZGVmYXVsdApocGV0MDogYXQgTU1JTyAweGZlZDAwMDAwLCBJUlFz
IDIsIDgsIDAsIDAsIDAsIDAsIDAsIDAKaHBldDA6IDggY29tcGFyYXRvcnMsIDY0LWJpdCAxNC4z
MTgxODAgTUh6IGNvdW50ZXIKU3dpdGNoaW5nIHRvIGNsb2Nrc291cmNlIGhwZXQKQXBwQXJtb3I6
IEFwcEFybW9yIEZpbGVzeXN0ZW0gRW5hYmxlZApwbnA6IFBuUCBBQ1BJIGluaXQKQUNQSTogYnVz
IHR5cGUgcG5wIHJlZ2lzdGVyZWQKcG5wIDAwOjAwOiBbYnVzIDAwLWZmXQpwbnAgMDA6MDA6IFtp
byAgMHgwY2Y4LTB4MGNmZl0KcG5wIDAwOjAwOiBbaW8gIDB4MDAwMC0weDBjZjcgd2luZG93XQpw
bnAgMDA6MDA6IFtpbyAgMHgwZDAwLTB4ZmZmZiB3aW5kb3ddCnBucCAwMDowMDogW21lbSAweDAw
MGEwMDAwLTB4MDAwYmZmZmYgd2luZG93XQpwbnAgMDA6MDA6IFttZW0gMHgwMDAwMDAwMCB3aW5k
b3ddCnBucCAwMDowMDogW21lbSAweGMwMDAwMDAwLTB4ZmZmZmZmZmYgd2luZG93XQpwbnAgMDA6
MDA6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYTA4IFBOUDBhMDMgKGFjdGl2
ZSkKcG5wIDAwOjAxOiBbbWVtIDB4ZmVkMTQwMDAtMHhmZWQxOWZmZl0KcG5wIDAwOjAxOiBbbWVt
IDB4ZTAwMDAwMDAtMHhlZmZmZmZmZl0KcG5wIDAwOjAxOiBbbWVtIDB4ZmVkOTAwMDAtMHhmZWQ5
M2ZmZl0KcG5wIDAwOjAxOiBbbWVtIDB4ZmVkMjAwMDAtMHhmZWQzZmZmZl0KcG5wIDAwOjAxOiBb
bWVtIDB4ZmVlMDAwMDAtMHhmZWUwZmZmZl0Kc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZmVkMTQwMDAt
MHhmZWQxOWZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZTAwMDAw
MDAtMHhlZmZmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZmVk
OTAwMDAtMHhmZWQ5M2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4
ZmVkMjAwMDAtMHhmZWQzZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVt
IDB4ZmVlMDAwMDAtMHhmZWUwZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBQ
bHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMGMwMSAoYWN0aXZlKQpwbnAgMDA6MDI6
IFtkbWEgNF0KcG5wIDAwOjAyOiBbaW8gIDB4MDAwMC0weDAwMGZdCnBucCAwMDowMjogW2lvICAw
eDAwODEtMHgwMDgzXQpwbnAgMDA6MDI6IFtpbyAgMHgwMDg3XQpwbnAgMDA6MDI6IFtpbyAgMHgw
MDg5LTB4MDA4Yl0KcG5wIDAwOjAyOiBbaW8gIDB4MDA4Zl0KcG5wIDAwOjAyOiBbaW8gIDB4MDBj
MC0weDAwZGZdCnBucCAwMDowMjogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDAy
MDAgKGFjdGl2ZSkKcG5wIDAwOjAzOiBbaW8gIDB4MDA3MC0weDAwNzFdCnBucCAwMDowMzogW2ly
cSA4XQpwbnAgMDA6MDM6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYjAwIChh
Y3RpdmUpCnBucCAwMDowNDogW2lvICAweDAwNjFdCnBucCAwMDowNDogUGx1ZyBhbmQgUGxheSBB
Q1BJIGRldmljZSwgSURzIFBOUDA4MDAgKGFjdGl2ZSkKcG5wIDAwOjA1OiBbaW8gIDB4MDBmMC0w
eDAwZmZdCnBucCAwMDowNTogW2lycSAxM10KcG5wIDAwOjA1OiBQbHVnIGFuZCBQbGF5IEFDUEkg
ZGV2aWNlLCBJRHMgUE5QMGMwNCAoYWN0aXZlKQpwbnAgMDA6MDY6IFtpbyAgMHgwMDEwLTB4MDAx
Zl0KcG5wIDAwOjA2OiBbaW8gIDB4MDAyMi0weDAwM2ZdCnBucCAwMDowNjogW2lvICAweDAwNDQt
MHgwMDVmXQpwbnAgMDA6MDY6IFtpbyAgMHgwMDY4LTB4MDA2Zl0KcG5wIDAwOjA2OiBbaW8gIDB4
MDA3Mi0weDAwN2ZdCnBucCAwMDowNjogW2lvICAweDAwODBdCnBucCAwMDowNjogW2lvICAweDAw
ODQtMHgwMDg2XQpwbnAgMDA6MDY6IFtpbyAgMHgwMDg4XQpwbnAgMDA6MDY6IFtpbyAgMHgwMDhj
LTB4MDA4ZV0KcG5wIDAwOjA2OiBbaW8gIDB4MDA5MC0weDAwOWZdCnBucCAwMDowNjogW2lvICAw
eDAwYTItMHgwMGJmXQpwbnAgMDA6MDY6IFtpbyAgMHgwMGUwLTB4MDBlZl0KcG5wIDAwOjA2OiBb
aW8gIDB4MDRkMC0weDA0ZDFdCnBucCAwMDowNjogW21lbSAweGZlODAwMDAwLTB4ZmU4MDAxZmZd
CnN5c3RlbSAwMDowNjogW2lvICAweDA0ZDAtMHgwNGQxXSBoYXMgYmVlbiByZXNlcnZlZApzeXN0
ZW0gMDA6MDY6IFttZW0gMHhmZTgwMDAwMC0weGZlODAwMWZmXSBoYXMgYmVlbiByZXNlcnZlZApz
eXN0ZW0gMDA6MDY6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChhY3Rp
dmUpCnBucCAwMDowNzogW2lycSAxMl0KcG5wIDAwOjA3OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2
aWNlLCBJRHMgRExMMDQ0NyBTWU4wNjAwIFNZTjAwMDIgUE5QMGYxMyAoYWN0aXZlKQpwbnAgMDA6
MDg6IFtpbyAgMHgwMDYwXQpwbnAgMDA6MDg6IFtpbyAgMHgwMDY0XQpwbnAgMDA6MDg6IFtpbyAg
MHgwMDYyXQpwbnAgMDA6MDg6IFtpbyAgMHgwMDY2XQpwbnAgMDA6MDg6IFtpcnEgMV0KcG5wIDAw
OjA4OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMDMwMyAoYWN0aXZlKQpwbnAg
MDA6MDk6IFtpbyAgMHgwNDAwLTB4MDQ3Zl0KcG5wIDAwOjA5OiBbaW8gIDB4MTE4MC0weDExOWZd
CnBucCAwMDowOTogW2lvICAweDA1MDAtMHgwNTdmXQpwbnAgMDA6MDk6IFttZW0gMHhmZWQxYzAw
MC0weGZlZDFmZmZmXQpwbnAgMDA6MDk6IFttZW0gMHhmZWMwMDAwMC0weGZlY2ZmZmZmXQpwbnAg
MDA6MDk6IFttZW0gMHhmZWQwODAwMC0weGZlZDA4ZmZmXQpwbnAgMDA6MDk6IFttZW0gMHhmZjAw
MDAwMC0weGZmZmZmZmZmXQpzeXN0ZW0gMDA6MDk6IFtpbyAgMHgwNDAwLTB4MDQ3Zl0gaGFzIGJl
ZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjA5OiBbaW8gIDB4MTE4MC0weDExOWZdIGhhcyBiZWVuIHJl
c2VydmVkCnN5c3RlbSAwMDowOTogW2lvICAweDA1MDAtMHgwNTdmXSBoYXMgYmVlbiByZXNlcnZl
ZApzeXN0ZW0gMDA6MDk6IFttZW0gMHhmZWQxYzAwMC0weGZlZDFmZmZmXSBoYXMgYmVlbiByZXNl
cnZlZApzeXN0ZW0gMDA6MDk6IFttZW0gMHhmZWMwMDAwMC0weGZlY2ZmZmZmXSBjb3VsZCBub3Qg
YmUgcmVzZXJ2ZWQKc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmVkMDgwMDAtMHhmZWQwOGZmZl0gaGFz
IGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmYwMDAwMDAtMHhmZmZmZmZmZl0g
aGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjA5OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNl
LCBJRHMgUE5QMGMwMSAoYWN0aXZlKQpwbnAgMDA6MGE6IFttZW0gMHhmZWQwMDAwMC0weGZlZDAw
M2ZmXQpwbnAgMDA6MGE6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwMTAzIChh
Y3RpdmUpCnBucDogUG5QIEFDUEk6IGZvdW5kIDExIGRldmljZXMKQUNQSTogQUNQSSBidXMgdHlw
ZSBwbnAgdW5yZWdpc3RlcmVkCnBjaSAwMDAwOjAwOjFjLjA6IGJyaWRnZSB3aW5kb3cgW2lvICAw
eDEwMDAtMHgwZmZmXSB0byBbYnVzIDExLTExXSBhZGRfc2l6ZSAxMDAwCnBjaSAwMDAwOjAwOjFj
LjA6IGJyaWRnZSB3aW5kb3cgW21lbSAweDAwMTAwMDAwLTB4MDAwZmZmZmYgNjRiaXQgcHJlZl0g
dG8gW2J1cyAxMS0xMV0gYWRkX3NpemUgMjAwMDAwCnBjaSAwMDAwOjAwOjFjLjA6IGJyaWRnZSB3
aW5kb3cgW21lbSAweDAwMTAwMDAwLTB4MDAwZmZmZmZdIHRvIFtidXMgMTEtMTFdIGFkZF9zaXpl
IDIwMDAwMApwY2kgMDAwMDowMDoxYy4xOiBicmlkZ2Ugd2luZG93IFtpbyAgMHgxMDAwLTB4MGZm
Zl0gdG8gW2J1cyAxMi0xMl0gYWRkX3NpemUgMTAwMApwY2kgMDAwMDowMDoxYy4xOiBicmlkZ2Ug
d2luZG93IFttZW0gMHgwMDEwMDAwMC0weDAwMGZmZmZmIDY0Yml0IHByZWZdIHRvIFtidXMgMTIt
MTJdIGFkZF9zaXplIDIwMDAwMApwY2kgMDAwMDowMDoxYy4wOiByZXNbMTRdPVttZW0gMHgwMDEw
MDAwMC0weDAwMGZmZmZmXSBnZXRfcmVzX2FkZF9zaXplIGFkZF9zaXplIDIwMDAwMApwY2kgMDAw
MDowMDoxYy4wOiByZXNbMTVdPVttZW0gMHgwMDEwMDAwMC0weDAwMGZmZmZmIDY0Yml0IHByZWZd
IGdldF9yZXNfYWRkX3NpemUgYWRkX3NpemUgMjAwMDAwCnBjaSAwMDAwOjAwOjFjLjE6IHJlc1sx
NV09W21lbSAweDAwMTAwMDAwLTB4MDAwZmZmZmYgNjRiaXQgcHJlZl0gZ2V0X3Jlc19hZGRfc2l6
ZSBhZGRfc2l6ZSAyMDAwMDAKcGNpIDAwMDA6MDA6MWMuMDogcmVzWzEzXT1baW8gIDB4MTAwMC0w
eDBmZmZdIGdldF9yZXNfYWRkX3NpemUgYWRkX3NpemUgMTAwMApwY2kgMDAwMDowMDoxYy4xOiBy
ZXNbMTNdPVtpbyAgMHgxMDAwLTB4MGZmZl0gZ2V0X3Jlc19hZGRfc2l6ZSBhZGRfc2l6ZSAxMDAw
CnBjaSAwMDAwOjAwOjFjLjA6IEJBUiAxNDogYXNzaWduZWQgW21lbSAweGQxNjAwMDAwLTB4ZDE3
ZmZmZmZdCnBjaSAwMDAwOjAwOjFjLjA6IEJBUiAxNTogYXNzaWduZWQgW21lbSAweGQxODAwMDAw
LTB4ZDE5ZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWMuMTogQkFSIDE1OiBhc3NpZ25l
ZCBbbWVtIDB4ZDFhMDAwMDAtMHhkMWJmZmZmZiA2NGJpdCBwcmVmXQpwY2kgMDAwMDowMDoxYy4w
OiBCQVIgMTM6IGFzc2lnbmVkIFtpbyAgMHgyMDAwLTB4MmZmZl0KcGNpIDAwMDA6MDA6MWMuMTog
QkFSIDEzOiBhc3NpZ25lZCBbaW8gIDB4MzAwMC0weDNmZmZdCnBjaSAwMDAwOjAwOjAxLjA6IFBD
SSBicmlkZ2UgdG8gW2J1cyAwMS0wMV0KcGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93
IFtpbyAgMHhlMDAwLTB4ZWZmZl0KcGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhmYmUwMDAwMC0weGZiZWZmZmZmXQpwY2kgMDAwMDowMDowMS4wOiAgIGJyaWRnZSB3aW5k
b3cgW21lbSAweGMwMDAwMDAwLTB4Y2ZmZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWMu
MDogUENJIGJyaWRnZSB0byBbYnVzIDExLTExXQpwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3
aW5kb3cgW2lvICAweDIwMDAtMHgyZmZmXQpwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3aW5k
b3cgW21lbSAweGQxNjAwMDAwLTB4ZDE3ZmZmZmZdCnBjaSAwMDAwOjAwOjFjLjA6ICAgYnJpZGdl
IHdpbmRvdyBbbWVtIDB4ZDE4MDAwMDAtMHhkMTlmZmZmZiA2NGJpdCBwcmVmXQpwY2kgMDAwMDow
MDoxYy4xOiBQQ0kgYnJpZGdlIHRvIFtidXMgMTItMTJdCnBjaSAwMDAwOjAwOjFjLjE6ICAgYnJp
ZGdlIHdpbmRvdyBbaW8gIDB4MzAwMC0weDNmZmZdCnBjaSAwMDAwOjAwOjFjLjE6ICAgYnJpZGdl
IHdpbmRvdyBbbWVtIDB4ZmJkMDAwMDAtMHhmYmRmZmZmZl0KcGNpIDAwMDA6MDA6MWMuMTogICBi
cmlkZ2Ugd2luZG93IFttZW0gMHhkMWEwMDAwMC0weGQxYmZmZmZmIDY0Yml0IHByZWZdCnBjaSAw
MDAwOjAwOjFjLjI6IFBDSSBicmlkZ2UgdG8gW2J1cyAxMy0xM10KcGNpIDAwMDA6MDA6MWMuMjog
ICBicmlkZ2Ugd2luZG93IFtpbyAgMHhkMDAwLTB4ZGZmZl0KcGNpIDAwMDA6MDA6MWMuMjogICBi
cmlkZ2Ugd2luZG93IFttZW0gMHhmYjMwMDAwMC0weGZiY2ZmZmZmXQpwY2kgMDAwMDowMDoxYy4y
OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGQwYzAwMDAwLTB4ZDE1ZmZmZmYgNjRiaXQgcHJlZl0K
cGNpIDAwMDA6MDA6MWMuNDogUENJIGJyaWRnZSB0byBbYnVzIDE1LTE1XQpwY2kgMDAwMDowMDox
Yy40OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGMwMDAtMHhjZmZmXQpwY2kgMDAwMDowMDoxYy40
OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZhOTAwMDAwLTB4ZmIyZmZmZmZdCnBjaSAwMDAwOjAw
OjFjLjQ6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZDAxMDAwMDAtMHhkMGFmZmZmZiA2NGJpdCBw
cmVmXQpwY2kgMDAwMDowMDoxZS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMjAtMjBdCnBjaSAwMDAw
OjAwOjFlLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApwY2lfYnVzIDAwMDA6MDA6IHJl
c291cmNlIDQgW2lvICAweDAwMDAtMHgwY2Y3XQpwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDUg
W2lvICAweDBkMDAtMHhmZmZmXQpwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDYgW21lbSAweDAw
MGEwMDAwLTB4MDAwYmZmZmZdCnBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgNyBbbWVtIDB4YzAw
MDAwMDAtMHhmZmZmZmZmZl0KcGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAwIFtpbyAgMHhlMDAw
LTB4ZWZmZl0KcGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAxIFttZW0gMHhmYmUwMDAwMC0weGZi
ZWZmZmZmXQpwY2lfYnVzIDAwMDA6MDE6IHJlc291cmNlIDIgW21lbSAweGMwMDAwMDAwLTB4Y2Zm
ZmZmZmYgNjRiaXQgcHJlZl0KcGNpX2J1cyAwMDAwOjExOiByZXNvdXJjZSAwIFtpbyAgMHgyMDAw
LTB4MmZmZl0KcGNpX2J1cyAwMDAwOjExOiByZXNvdXJjZSAxIFttZW0gMHhkMTYwMDAwMC0weGQx
N2ZmZmZmXQpwY2lfYnVzIDAwMDA6MTE6IHJlc291cmNlIDIgW21lbSAweGQxODAwMDAwLTB4ZDE5
ZmZmZmYgNjRiaXQgcHJlZl0KcGNpX2J1cyAwMDAwOjEyOiByZXNvdXJjZSAwIFtpbyAgMHgzMDAw
LTB4M2ZmZl0KcGNpX2J1cyAwMDAwOjEyOiByZXNvdXJjZSAxIFttZW0gMHhmYmQwMDAwMC0weGZi
ZGZmZmZmXQpwY2lfYnVzIDAwMDA6MTI6IHJlc291cmNlIDIgW21lbSAweGQxYTAwMDAwLTB4ZDFi
ZmZmZmYgNjRiaXQgcHJlZl0KcGNpX2J1cyAwMDAwOjEzOiByZXNvdXJjZSAwIFtpbyAgMHhkMDAw
LTB4ZGZmZl0KcGNpX2J1cyAwMDAwOjEzOiByZXNvdXJjZSAxIFttZW0gMHhmYjMwMDAwMC0weGZi
Y2ZmZmZmXQpwY2lfYnVzIDAwMDA6MTM6IHJlc291cmNlIDIgW21lbSAweGQwYzAwMDAwLTB4ZDE1
ZmZmZmYgNjRiaXQgcHJlZl0KcGNpX2J1cyAwMDAwOjE1OiByZXNvdXJjZSAwIFtpbyAgMHhjMDAw
LTB4Y2ZmZl0KcGNpX2J1cyAwMDAwOjE1OiByZXNvdXJjZSAxIFttZW0gMHhmYTkwMDAwMC0weGZi
MmZmZmZmXQpwY2lfYnVzIDAwMDA6MTU6IHJlc291cmNlIDIgW21lbSAweGQwMTAwMDAwLTB4ZDBh
ZmZmZmYgNjRiaXQgcHJlZl0KcGNpX2J1cyAwMDAwOjIwOiByZXNvdXJjZSA0IFtpbyAgMHgwMDAw
LTB4MGNmN10KcGNpX2J1cyAwMDAwOjIwOiByZXNvdXJjZSA1IFtpbyAgMHgwZDAwLTB4ZmZmZl0K
cGNpX2J1cyAwMDAwOjIwOiByZXNvdXJjZSA2IFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmXQpw
Y2lfYnVzIDAwMDA6MjA6IHJlc291cmNlIDcgW21lbSAweGMwMDAwMDAwLTB4ZmZmZmZmZmZdCnBj
aV9idXMgMDAwMDpmZjogcmVzb3VyY2UgNCBbaW8gIDB4MDAwMC0weGZmZmZdCnBjaV9idXMgMDAw
MDpmZjogcmVzb3VyY2UgNSBbbWVtIDB4MDAwMDAwMDAtMHhmZmZmZmZmZmZdCk5FVDogUmVnaXN0
ZXJlZCBwcm90b2NvbCBmYW1pbHkgMgpJUCByb3V0ZSBjYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6
IDEzMTA3MiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMpClRDUCBlc3RhYmxpc2hlZCBoYXNoIHRh
YmxlIGVudHJpZXM6IDUyNDI4OCAob3JkZXI6IDExLCA4Mzg4NjA4IGJ5dGVzKQpUQ1AgYmluZCBo
YXNoIHRhYmxlIGVudHJpZXM6IDY1NTM2IChvcmRlcjogOCwgMTA0ODU3NiBieXRlcykKVENQOiBI
YXNoIHRhYmxlcyBjb25maWd1cmVkIChlc3RhYmxpc2hlZCA1MjQyODggYmluZCA2NTUzNikKVENQ
OiByZW5vIHJlZ2lzdGVyZWQKVURQIGhhc2ggdGFibGUgZW50cmllczogMjA0OCAob3JkZXI6IDQs
IDY1NTM2IGJ5dGVzKQpVRFAtTGl0ZSBoYXNoIHRhYmxlIGVudHJpZXM6IDIwNDggKG9yZGVyOiA0
LCA2NTUzNiBieXRlcykKTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxCnBjaSAwMDAw
OjAxOjAwLjA6IEJvb3QgdmlkZW8gZGV2aWNlClBDSTogQ0xTIDY0IGJ5dGVzLCBkZWZhdWx0IDY0
ClRyeWluZyB0byB1bnBhY2sgcm9vdGZzIGltYWdlIGFzIGluaXRyYW1mcy4uLgpGcmVlaW5nIGlu
aXRyZCBtZW1vcnk6IDE1MjEwNGsgZnJlZWQKUENJLURNQTogVXNpbmcgc29mdHdhcmUgYm91bmNl
IGJ1ZmZlcmluZyBmb3IgSU8gKFNXSU9UTEIpClBsYWNpbmcgNjRNQiBzb2Z0d2FyZSBJTyBUTEIg
YmV0d2VlbiBmZmZmODgwMGJiNWE3MDAwIC0gZmZmZjg4MDBiZjVhNzAwMApzb2Z0d2FyZSBJTyBU
TEIgYXQgcGh5cyAweGJiNWE3MDAwIC0gMHhiZjVhNzAwMAphdWRpdDogaW5pdGlhbGl6aW5nIG5l
dGxpbmsgc29ja2V0IChkaXNhYmxlZCkKdHlwZT0yMDAwIGF1ZGl0KDEzMzg0OTQzMTkuMzYwOjEp
OiBpbml0aWFsaXplZApIdWdlVExCIHJlZ2lzdGVyZWQgMiBNQiBwYWdlIHNpemUsIHByZS1hbGxv
Y2F0ZWQgMCBwYWdlcwpWRlM6IERpc2sgcXVvdGFzIGRxdW90XzYuNS4yCkRxdW90LWNhY2hlIGhh
c2ggdGFibGUgZW50cmllczogNTEyIChvcmRlciAwLCA0MDk2IGJ5dGVzKQpmdXNlIGluaXQgKEFQ
SSB2ZXJzaW9uIDcuMTgpCm1zZ21uaSBoYXMgYmVlbiBzZXQgdG8gNzM3NwpCbG9jayBsYXllciBT
Q1NJIGdlbmVyaWMgKGJzZykgZHJpdmVyIHZlcnNpb24gMC40IGxvYWRlZCAobWFqb3IgMjUzKQpp
byBzY2hlZHVsZXIgbm9vcCByZWdpc3RlcmVkCmlvIHNjaGVkdWxlciBkZWFkbGluZSByZWdpc3Rl
cmVkCmlvIHNjaGVkdWxlciBjZnEgcmVnaXN0ZXJlZCAoZGVmYXVsdCkKcGNpZXBvcnQgMDAwMDow
MDowMS4wOiBpcnEgNDAgZm9yIE1TSS9NU0ktWApwY2llcG9ydCAwMDAwOjAwOjFjLjA6IGlycSA0
MSBmb3IgTVNJL01TSS1YCnBjaWVwb3J0IDAwMDA6MDA6MWMuMTogaXJxIDQyIGZvciBNU0kvTVNJ
LVgKcGNpZXBvcnQgMDAwMDowMDoxYy4yOiBpcnEgNDMgZm9yIE1TSS9NU0ktWApwY2llcG9ydCAw
MDAwOjAwOjFjLjQ6IGlycSA0NCBmb3IgTVNJL01TSS1YCnBjaV9ob3RwbHVnOiBQQ0kgSG90IFBs
dWcgUENJIENvcmUgdmVyc2lvbjogMC41CnBjaWVocDogVXNpbmcgQUNQSSBmb3Igc2xvdCBkZXRl
Y3Rpb24uCnBjaWVocCAwMDAwOjAwOjFjLjQ6cGNpZTA0OiBIUEMgdmVuZG9yX2lkIDgwODYgZGV2
aWNlX2lkIDNiNGEgc3NfdmlkIDEwMjggc3NfZGlkIDQ0NwpwY2llaHAgMDAwMDowMDoxYy40OnBj
aWUwNDogc2VydmljZSBkcml2ZXIgcGNpZWhwIGxvYWRlZApwY2llaHA6IFBDSSBFeHByZXNzIEhv
dCBQbHVnIENvbnRyb2xsZXIgRHJpdmVyIHZlcnNpb246IDAuNAppbnRlbF9pZGxlOiBNV0FJVCBz
dWJzdGF0ZXM6IDB4MTEyMAppbnRlbF9pZGxlOiB2MC40IG1vZGVsIDB4MjUKaW50ZWxfaWRsZTog
bGFwaWNfdGltZXJfcmVsaWFibGVfc3RhdGVzIDB4ZmZmZmZmZmYKQUNQSTogRGVwcmVjYXRlZCBw
cm9jZnMgSS9GIGZvciBBQyBpcyBsb2FkZWQsIHBsZWFzZSByZXRyeSB3aXRoIENPTkZJR19BQ1BJ
X1BST0NGU19QT1dFUiBjbGVhcmVkCkFDUEk6IEFDIEFkYXB0ZXIgW0FDXSAob24tbGluZSkKaW5w
dXQ6IFBvd2VyIEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9kZXZpY2U6MDAvUE5QMEMw
QzowMC9pbnB1dC9pbnB1dDAKQUNQSTogUG93ZXIgQnV0dG9uIFtQV1JCXQppbnB1dDogTGlkIFN3
aXRjaCBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9kZXZpY2U6MDAvUE5QMEMwRDowMC9pbnB1dC9p
bnB1dDEKQUNQSTogTGlkIFN3aXRjaCBbTElEMF0KaW5wdXQ6IFNsZWVwIEJ1dHRvbiBhcyAvZGV2
aWNlcy9MTlhTWVNUTTowMC9kZXZpY2U6MDAvUE5QMEMwRTowMC9pbnB1dC9pbnB1dDIKQUNQSTog
U2xlZXAgQnV0dG9uIFtTQlROXQppbnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZ
U1RNOjAwL0xOWFBXUkJOOjAwL2lucHV0L2lucHV0MwpBQ1BJOiBQb3dlciBCdXR0b24gW1BXUkZd
CkFDUEk6IFJlcXVlc3RpbmcgYWNwaV9jcHVmcmVxCnRoZXJtYWwgTE5YVEhFUk06MDA6IHJlZ2lz
dGVyZWQgYXMgdGhlcm1hbF96b25lMApBQ1BJOiBUaGVybWFsIFpvbmUgW1RITV0gKDUyIEMpCkdI
RVM6IEhFU1QgaXMgbm90IGVuYWJsZWQhClNlcmlhbDogODI1MC8xNjU1MCBkcml2ZXIsIDQgcG9y
dHMsIElSUSBzaGFyaW5nIGVuYWJsZWQKTGludXggYWdwZ2FydCBpbnRlcmZhY2UgdjAuMTAzCmJy
ZDogbW9kdWxlIGxvYWRlZApsb29wOiBtb2R1bGUgbG9hZGVkCkZpeGVkIE1ESU8gQnVzOiBwcm9i
ZWQKdHVuOiBVbml2ZXJzYWwgVFVOL1RBUCBkZXZpY2UgZHJpdmVyLCAxLjYKdHVuOiAoQykgMTk5
OS0yMDA0IE1heCBLcmFzbnlhbnNreSA8bWF4a0BxdWFsY29tbS5jb20+ClBQUCBnZW5lcmljIGRy
aXZlciB2ZXJzaW9uIDIuNC4yCmVoY2lfaGNkOiBVU0IgMi4wICdFbmhhbmNlZCcgSG9zdCBDb250
cm9sbGVyIChFSENJKSBEcml2ZXIKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVu
Y3kgdGltZXIgdG8gNjQKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBFSENJIEhvc3QgQ29udHJvbGxl
cgplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVk
IGJ1cyBudW1iZXIgMQplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IGRlYnVnIHBvcnQgMgplaGNpX2hj
ZCAwMDAwOjAwOjFhLjA6IGNhY2hlIGxpbmUgc2l6ZSBvZiA2NCBpcyBub3Qgc3VwcG9ydGVkCmVo
Y2lfaGNkIDAwMDA6MDA6MWEuMDogaXJxIDE2LCBpbyBtZW0gMHhmYmYwODAwMAplaGNpX2hjZCAw
MDAwOjAwOjFhLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwCmh1YiAxLTA6MS4wOiBVU0Ig
aHViIGZvdW5kCmh1YiAxLTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkCmVoY2lfaGNkIDAwMDA6MDA6
MWQuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CmVoY2lfaGNkIDAwMDA6MDA6MWQuMDog
RUhDSSBIb3N0IENvbnRyb2xsZXIKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBuZXcgVVNCIGJ1cyBy
ZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDIKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBk
ZWJ1ZyBwb3J0IDIKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBjYWNoZSBsaW5lIHNpemUgb2YgNjQg
aXMgbm90IHN1cHBvcnRlZAplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IGlycSAyMywgaW8gbWVtIDB4
ZmJmMDcwMDAKQUNQSTogRGVwcmVjYXRlZCBwcm9jZnMgSS9GIGZvciBiYXR0ZXJ5IGlzIGxvYWRl
ZCwgcGxlYXNlIHJldHJ5IHdpdGggQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSIGNsZWFyZWQKQUNQ
STogQmF0dGVyeSBTbG90IFtCQVQwXSAoYmF0dGVyeSBwcmVzZW50KQplaGNpX2hjZCAwMDAwOjAw
OjFkLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwCmh1YiAyLTA6MS4wOiBVU0IgaHViIGZv
dW5kCmh1YiAyLTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkCm9oY2lfaGNkOiBVU0IgMS4xICdPcGVu
JyBIb3N0IENvbnRyb2xsZXIgKE9IQ0kpIERyaXZlcgp1aGNpX2hjZDogVVNCIFVuaXZlcnNhbCBI
b3N0IENvbnRyb2xsZXIgSW50ZXJmYWNlIGRyaXZlcgppODA0MjogUE5QOiBQUy8yIENvbnRyb2xs
ZXIgW1BOUDAzMDM6S0JDLFBOUDBmMTM6UFMyXSBhdCAweDYwLDB4NjQgaXJxIDEsMTIKc2VyaW86
IGk4MDQyIEtCRCBwb3J0IGF0IDB4NjAsMHg2NCBpcnEgMQpzZXJpbzogaTgwNDIgQVVYIHBvcnQg
YXQgMHg2MCwweDY0IGlycSAxMgptb3VzZWRldjogUFMvMiBtb3VzZSBkZXZpY2UgY29tbW9uIGZv
ciBhbGwgbWljZQpydGNfY21vcyAwMDowMzogUlRDIGNhbiB3YWtlIGZyb20gUzQKcnRjX2Ntb3Mg
MDA6MDM6IHJ0YyBjb3JlOiByZWdpc3RlcmVkIHJ0Y19jbW9zIGFzIHJ0YzAKcnRjMDogYWxhcm1z
IHVwIHRvIG9uZSB5ZWFyLCB5M2ssIDExNCBieXRlcyBudnJhbSwgaHBldCBpcnFzCmRldmljZS1t
YXBwZXI6IHVldmVudDogdmVyc2lvbiAxLjAuMwpkZXZpY2UtbWFwcGVyOiBpb2N0bDogNC4yMi4w
LWlvY3RsICgyMDExLTEwLTE5KSBpbml0aWFsaXNlZDogZG0tZGV2ZWxAcmVkaGF0LmNvbQpkZXZp
Y2UtbWFwcGVyOiBtdWx0aXBhdGg6IHZlcnNpb24gMS4zLjAgbG9hZGVkCmRldmljZS1tYXBwZXI6
IG11bHRpcGF0aCByb3VuZC1yb2JpbjogdmVyc2lvbiAxLjAuMCBsb2FkZWQKY3B1aWRsZTogdXNp
bmcgZ292ZXJub3IgbGFkZGVyCmNwdWlkbGU6IHVzaW5nIGdvdmVybm9yIG1lbnUKRUZJIFZhcmlh
YmxlcyBGYWNpbGl0eSB2MC4wOCAyMDA0LU1heS0xNwpUQ1A6IGN1YmljIHJlZ2lzdGVyZWQKTkVU
OiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxMApORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wg
ZmFtaWx5IDE3ClJlZ2lzdGVyaW5nIHRoZSBkbnNfcmVzb2x2ZXIga2V5IHR5cGUKUE06IEhpYmVy
bmF0aW9uIGltYWdlIG5vdCBwcmVzZW50IG9yIGNvdWxkIG5vdCBiZSBsb2FkZWQuCnJlZ2lzdGVy
ZWQgdGFza3N0YXRzIHZlcnNpb24gMQogIE1hZ2ljIG51bWJlcjogMTI6NzgxOjEwMDIKcG5wIDAw
OjA0OiBoYXNoIG1hdGNoZXMKcnRjX2Ntb3MgMDA6MDM6IHNldHRpbmcgc3lzdGVtIGNsb2NrIHRv
IDIwMTItMDUtMzEgMTk6NTg6MzkgVVRDICgxMzM4NDk0MzE5KQpCSU9TIEVERCBmYWNpbGl0eSB2
MC4xNiAyMDA0LUp1bi0yNSwgMCBkZXZpY2VzIGZvdW5kCkVERCBpbmZvcm1hdGlvbiBub3QgYXZh
aWxhYmxlLgpGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiA4OTJrIGZyZWVkCldyaXRlIHBy
b3RlY3RpbmcgdGhlIGtlcm5lbCByZWFkLW9ubHkgZGF0YTogMTIyODhrCkZyZWVpbmcgdW51c2Vk
IGtlcm5lbCBtZW1vcnk6IDE5MTJrIGZyZWVkCkZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1vcnk6
IDEzODhrIGZyZWVkCmlucHV0OiBBVCBUcmFuc2xhdGVkIFNldCAyIGtleWJvYXJkIGFzIC9kZXZp
Y2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMC9pbnB1dC9pbnB1dDQKcjgxNjkgR2lnYWJpdCBFdGhl
cm5ldCBkcml2ZXIgMi4zTEstTkFQSSBsb2FkZWQKcjgxNjkgMDAwMDoxMzowMC4wOiBpcnEgNDUg
Zm9yIE1TSS9NU0ktWApyODE2OSAwMDAwOjEzOjAwLjA6IGV0aDA6IFJUTDgxMDJlIGF0IDB4ZmZm
ZmM5MDAwMDY3ZTAwMCwgZjA6NGQ6YTI6YmM6ZDg6ZDYsIFhJRCAwNGUwMDAwMCBJUlEgNDUKYWhj
aSAwMDAwOjAwOjFmLjI6IHZlcnNpb24gMy4wCmFoY2kgMDAwMDowMDoxZi4yOiBpcnEgNDYgZm9y
IE1TSS9NU0ktWAphaGNpIDAwMDA6MDA6MWYuMjogQUhDSSAwMDAxLjAzMDAgMzIgc2xvdHMgNiBw
b3J0cyAzIEdicHMgMHgxMyBpbXBsIFNBVEEgbW9kZQphaGNpIDAwMDA6MDA6MWYuMjogZmxhZ3M6
IDY0Yml0IG5jcSBzbnRmIGlsY2sgcG0gbGVkIGNsbyBwaW8gc2x1bSBwYXJ0IGVtcyBzeHMgYXBz
dCAKYWhjaSAwMDAwOjAwOjFmLjI6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApbZHJtXSBJ
bml0aWFsaXplZCBkcm0gMS4xLjAgMjAwNjA4MTAKQUNQSSBXYXJuaW5nOiBfQlFDIHJldHVybmVk
IGFuIGludmFsaWQgbGV2ZWwgKDIwMTIwMzIwL3ZpZGVvLTQ3MikKYWNwaSBkZXZpY2U6MDM6IHJl
Z2lzdGVyZWQgYXMgY29vbGluZ19kZXZpY2U0CmlucHV0OiBWaWRlbyBCdXMgYXMgL2RldmljZXMv
TE5YU1lTVE06MDAvZGV2aWNlOjAwL1BOUDBBMDg6MDAvZGV2aWNlOjAxL0xOWFZJREVPOjAwL2lu
cHV0L2lucHV0NQpBQ1BJOiBWaWRlbyBEZXZpY2UgW1BFR1BdIChtdWx0aS1oZWFkOiB5ZXMgIHJv
bTogbm8gIHBvc3Q6IG5vKQpzY3NpMCA6IGFoY2kKc2NzaTEgOiBhaGNpCnNjc2kyIDogYWhjaQpz
Y3NpMyA6IGFoY2kKc2NzaTQgOiBhaGNpCnNjc2k1IDogYWhjaQphdGExOiBTQVRBIG1heCBVRE1B
LzEzMyBhYmFyIG0yMDQ4QDB4ZmJmMDYwMDAgcG9ydCAweGZiZjA2MTAwIGlycSA0NgphdGEyOiBT
QVRBIG1heCBVRE1BLzEzMyBhYmFyIG0yMDQ4QDB4ZmJmMDYwMDAgcG9ydCAweGZiZjA2MTgwIGly
cSA0NgphdGEzOiBEVU1NWQphdGE0OiBEVU1NWQphdGE1OiBTQVRBIG1heCBVRE1BLzEzMyBhYmFy
IG0yMDQ4QDB4ZmJmMDYwMDAgcG9ydCAweGZiZjA2MzAwIGlycSA0NgphdGE2OiBEVU1NWQpbZHJt
XSByYWRlb24gZGVmYXVsdGluZyB0byBrZXJuZWwgbW9kZXNldHRpbmcuCltkcm1dIHJhZGVvbiBr
ZXJuZWwgbW9kZXNldHRpbmcgZW5hYmxlZC4KW2RybV0gaW5pdGlhbGl6aW5nIGtlcm5lbCBtb2Rl
c2V0dGluZyAoUkVEV09PRCAweDEwMDI6MHg2OEMxIDB4MTAyODoweDA0NDcpLgpbZHJtXSByZWdp
c3RlciBtbWlvIGJhc2U6IDB4RkJFMjAwMDAKW2RybV0gcmVnaXN0ZXIgbW1pbyBzaXplOiAxMzEw
NzIKQVRPTSBCSU9TOiBEZWxsCnJhZGVvbiAwMDAwOjAxOjAwLjA6IFZSQU06IDEwMjRNIDB4MDAw
MDAwMDAwMDAwMDAwMCAtIDB4MDAwMDAwMDAzRkZGRkZGRiAoMTAyNE0gdXNlZCkKcmFkZW9uIDAw
MDA6MDE6MDAuMDogR1RUOiA1MTJNIDB4MDAwMDAwMDA0MDAwMDAwMCAtIDB4MDAwMDAwMDA1RkZG
RkZGRgptdHJyOiB0eXBlIG1pc21hdGNoIGZvciBjMDAwMDAwMCwxMDAwMDAwMCBvbGQ6IHdyaXRl
LWJhY2sgbmV3OiB3cml0ZS1jb21iaW5pbmcKW2RybV0gRGV0ZWN0ZWQgVlJBTSBSQU09MTAyNE0s
IEJBUj0yNTZNCltkcm1dIFJBTSB3aWR0aCAxMjhiaXRzIEREUgpbVFRNXSBab25lICBrZXJuZWw6
IEF2YWlsYWJsZSBncmFwaGljcyBtZW1vcnk6IDE4OTA2MjQga2lCCltUVE1dIEluaXRpYWxpemlu
ZyBwb29sIGFsbG9jYXRvcgpbVFRNXSBJbml0aWFsaXppbmcgRE1BIHBvb2wgYWxsb2NhdG9yCltk
cm1dIHJhZGVvbjogMTAyNE0gb2YgVlJBTSBtZW1vcnkgcmVhZHkKW2RybV0gcmFkZW9uOiA1MTJN
IG9mIEdUVCBtZW1vcnkgcmVhZHkuCltkcm1dIFN1cHBvcnRzIHZibGFuayB0aW1lc3RhbXAgY2Fj
aGluZyBSZXYgMSAoMTAuMTAuMjAxMCkuCltkcm1dIERyaXZlciBzdXBwb3J0cyBwcmVjaXNlIHZi
bGFuayB0aW1lc3RhbXAgcXVlcnkuCnJhZGVvbiAwMDAwOjAxOjAwLjA6IGlycSA0NyBmb3IgTVNJ
L01TSS1YCnJhZGVvbiAwMDAwOjAxOjAwLjA6IHJhZGVvbjogdXNpbmcgTVNJLgpbZHJtXSByYWRl
b246IGlycSBpbml0aWFsaXplZC4KW2RybV0gR0FSVDogbnVtIGNwdSBwYWdlcyAxMzEwNzIsIG51
bSBncHUgcGFnZXMgMTMxMDcyCltkcm1dIHJhZGVvbjogaWIgcG9vbCByZWFkeS4KW2RybV0gTG9h
ZGluZyBSRURXT09EIE1pY3JvY29kZQpbZHJtXSBQQ0lFIEdBUlQgb2YgNTEyTSBlbmFibGVkICh0
YWJsZSBhdCAweDAwMDAwMDAwMDAwNDAwMDApLgpyYWRlb24gMDAwMDowMTowMC4wOiBXQiBlbmFi
bGVkCltkcm1dIGZlbmNlIGRyaXZlciBvbiByaW5nIDAgdXNlIGdwdSBhZGRyIDB4NDAwMDBjMDAg
YW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDEwZTRhMmMwMApbZHJtXSByaW5nIHRlc3Qgb24gMCBzdWNj
ZWVkZWQgaW4gMSB1c2VjcwpbZHJtXSBpYiB0ZXN0IG9uIHJpbmcgMCBzdWNjZWVkZWQgaW4gMCB1
c2VjcwpbZHJtXSBFbmFibGluZyBhdWRpbyBzdXBwb3J0Cltkcm1dIFJhZGVvbiBEaXNwbGF5IENv
bm5lY3RvcnMKW2RybV0gQ29ubmVjdG9yIDA6Cltkcm1dICAgTFZEUwpbZHJtXSAgIEREQzogMHg2
NTYwIDB4NjU2MCAweDY1NjQgMHg2NTY0IDB4NjU2OCAweDY1NjggMHg2NTZjIDB4NjU2YwpbZHJt
XSAgIEVuY29kZXJzOgpbZHJtXSAgICAgTENEMTogSU5URVJOQUxfVU5JUEhZCltkcm1dIENvbm5l
Y3RvciAxOgpbZHJtXSAgIEhETUktQQpbZHJtXSAgIEhQRDEKW2RybV0gICBEREM6IDB4NjQ0MCAw
eDY0NDAgMHg2NDQ0IDB4NjQ0NCAweDY0NDggMHg2NDQ4IDB4NjQ0YyAweDY0NGMKW2RybV0gICBF
bmNvZGVyczoKW2RybV0gICAgIERGUDE6IElOVEVSTkFMX1VOSVBIWTEKW2RybV0gQ29ubmVjdG9y
IDI6Cltkcm1dICAgVkdBCltkcm1dICAgRERDOiAweDY0MzAgMHg2NDMwIDB4NjQzNCAweDY0MzQg
MHg2NDM4IDB4NjQzOCAweDY0M2MgMHg2NDNjCltkcm1dICAgRW5jb2RlcnM6Cltkcm1dICAgICBD
UlQxOiBJTlRFUk5BTF9LTERTQ1BfREFDMQpbZHJtXSBJbnRlcm5hbCB0aGVybWFsIGNvbnRyb2xs
ZXIgd2l0aCBmYW4gY29udHJvbApbZHJtXSByYWRlb246IHBvd2VyIG1hbmFnZW1lbnQgaW5pdGlh
bGl6ZWQKdXNiIDEtMTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMiB1c2luZyBl
aGNpX2hjZApodWIgMS0xOjEuMDogVVNCIGh1YiBmb3VuZApodWIgMS0xOjEuMDogNiBwb3J0cyBk
ZXRlY3RlZAphdGE1OiBTQVRBIGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCkKYXRh
MjogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCmF0YTE6
IFNBVEEgbGluayB1cCAzLjAgR2JwcyAoU1N0YXR1cyAxMjMgU0NvbnRyb2wgMzAwKQphdGExLjAw
OiBBVEEtODogV0RDIFdENTAwMEJFS1QtNzVLQTlUMCwgMDEuMDFBMDEsIG1heCBVRE1BLzEzMwph
dGExLjAwOiA5NzY3NzMxNjggc2VjdG9ycywgbXVsdGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzEv
MzIpLCBBQQphdGEyLjAwOiBBVEFQSTogUExEUyBEVkQrLy1SVyBEUy04QTVTSCwgWEQxMiwgbWF4
IFVETUEvMTAwCmF0YTEuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzCmF0YTIuMDA6IGNvbmZp
Z3VyZWQgZm9yIFVETUEvMTAwCnNjc2kgMDowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQVRBICAg
ICAgV0RDIFdENTAwMEJFS1QtNyAwMS4wIFBROiAwIEFOU0k6IDUKc2QgMDowOjA6MDogQXR0YWNo
ZWQgc2NzaSBnZW5lcmljIHNnMCB0eXBlIDAKc2QgMDowOjA6MDogW3NkYV0gOTc2NzczMTY4IDUx
Mi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoNTAwIEdCLzQ2NSBHaUIpCnNkIDA6MDowOjA6IFtzZGFd
IFdyaXRlIFByb3RlY3QgaXMgb2ZmCnNkIDA6MDowOjA6IFtzZGFdIE1vZGUgU2Vuc2U6IDAwIDNh
IDAwIDAwCnNkIDA6MDowOjA6IFtzZGFdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hl
OiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQpzY3NpIDE6MDowOjA6IENELVJP
TSAgICAgICAgICAgIFBMRFMgICAgIERWRCstUlcgRFMtOEE1U0ggWEQxMiBQUTogMCBBTlNJOiA1
CnNyMDogc2NzaTMtbW1jIGRyaXZlOiAyNHgvOHggd3JpdGVyIGR2ZC1yYW0gY2QvcncgeGEvZm9y
bTIgY2RkYSB0cmF5CmNkcm9tOiBVbmlmb3JtIENELVJPTSBkcml2ZXIgUmV2aXNpb246IDMuMjAK
c3IgMTowOjA6MDogQXR0YWNoZWQgc2NzaSBDRC1ST00gc3IwCnNyIDE6MDowOjA6IEF0dGFjaGVk
IHNjc2kgZ2VuZXJpYyBzZzEgdHlwZSA1CiBzZGE6IHNkYTEgc2RhMiA8IHNkYTUgPgpzZCAwOjA6
MDowOiBbc2RhXSBBdHRhY2hlZCBTQ1NJIGRpc2sKdXNiIDItMTogbmV3IGhpZ2gtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgMiB1c2luZyBlaGNpX2hjZApodWIgMi0xOjEuMDogVVNCIGh1YiBmb3Vu
ZApodWIgMi0xOjEuMDogOCBwb3J0cyBkZXRlY3RlZAp1c2IgMS0xLjI6IG5ldyBoaWdoLXNwZWVk
IFVTQiBkZXZpY2UgbnVtYmVyIDMgdXNpbmcgZWhjaV9oY2QKW2RybV0gZmIgbWFwcGFibGUgYXQg
MHhDMDE0MjAwMApbZHJtXSB2cmFtIGFwcGVyIGF0IDB4QzAwMDAwMDAKW2RybV0gc2l6ZSA0MzI1
Mzc2Cltkcm1dIGZiIGRlcHRoIGlzIDI0Cltkcm1dICAgIHBpdGNoIGlzIDU2MzIKZmJjb246IHJh
ZGVvbmRybWZiIChmYjApIGlzIHByaW1hcnkgZGV2aWNlCkluaXRpYWxpemluZyBVU0IgTWFzcyBT
dG9yYWdlIGRyaXZlci4uLgpzY3NpNiA6IHVzYi1zdG9yYWdlIDEtMS4yOjEuMAp1c2Jjb3JlOiBy
ZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIHVzYi1zdG9yYWdlClVTQiBNYXNzIFN0b3Jh
Z2Ugc3VwcG9ydCByZWdpc3RlcmVkLgpSZWZpbmVkIFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJhdGlv
bjogMjUyNi45ODYgTUh6LgpTd2l0Y2hpbmcgdG8gY2xvY2tzb3VyY2UgdHNjCnVzYiAxLTEuNjog
bmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgNCB1c2luZyBlaGNpX2hjZApDb25zb2xl
OiBzd2l0Y2hpbmcgdG8gY29sb3VyIGZyYW1lIGJ1ZmZlciBkZXZpY2UgMTcweDQ4CmZiMDogcmFk
ZW9uZHJtZmIgZnJhbWUgYnVmZmVyIGRldmljZQpkcm06IHJlZ2lzdGVyZWQgcGFuaWMgbm90aWZp
ZXIKW2RybV0gSW5pdGlhbGl6ZWQgcmFkZW9uIDIuMTUuMCAyMDA4MDUyOCBmb3IgMDAwMDowMTow
MC4wIG9uIG1pbm9yIDAKc2NzaSA2OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICAgICAgICAgICBJ
ZGVvcyAgICAgICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzY3NpIDY6MDowOjE6IENELVJPTSAg
ICAgICAgICAgICAgICAgICAgIElkZW9zICAgICAgICAgICAgMDAwMCBQUTogMCBBTlNJOiAyCnNk
IDY6MDowOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzIgdHlwZSAwCnNyMTogc2NzaTMtbW1j
IGRyaXZlOiAweC8weCBjYWRkeQpzciA2OjA6MDoxOiBBdHRhY2hlZCBzY3NpIENELVJPTSBzcjEK
c3IgNjowOjA6MTogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMyB0eXBlIDUKc2QgNjowOjA6MDog
W3NkYl0gQXR0YWNoZWQgU0NTSSByZW1vdmFibGUgZGlzawpFWFQ0LWZzIChzZGExKTogbW91bnRl
ZCBmaWxlc3lzdGVtIHdpdGggb3JkZXJlZCBkYXRhIG1vZGUuIE9wdHM6IChudWxsKQpBZGRpbmcg
MTE0ODAwNjBrIHN3YXAgb24gL2Rldi9zZGE1LiAgUHJpb3JpdHk6LTEgZXh0ZW50czoxIGFjcm9z
czoxMTQ4MDA2MGsgCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVt
b3VudC1ybyx1c2VyX3hhdHRyCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0MzI5LjIyODoyKTogYXBw
YXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii9zYmluL2RoY2xp
ZW50IiBwaWQ9NzE5IGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0
OTQzMjkuMjI4OjMpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9hZCIg
bmFtZT0iL3Vzci9saWIvTmV0d29ya01hbmFnZXIvbm0tZGhjcC1jbGllbnQuYWN0aW9uIiBwaWQ9
NzE5IGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzMjkuMjI4
OjQpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9hZCIgbmFtZT0iL3Vz
ci9saWIvY29ubm1hbi9zY3JpcHRzL2RoY2xpZW50LXNjcmlwdCIgcGlkPTcxOSBjb21tPSJhcHBh
cm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0MzI5LjIyODo1KTogYXBwYXJtb3I9
IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii9zYmluL2RoY2xpZW50
IiBwaWQ9NjYxIGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQz
MjkuMjI4OjYpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIg
bmFtZT0iL3Vzci9saWIvTmV0d29ya01hbmFnZXIvbm0tZGhjcC1jbGllbnQuYWN0aW9uIiBwaWQ9
NjYxIGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzMjkuMjI4
OjcpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0i
L3Vzci9saWIvY29ubm1hbi9zY3JpcHRzL2RoY2xpZW50LXNjcmlwdCIgcGlkPTY2MSBjb21tPSJh
cHBhcm1vcl9wYXJzZXIiCmludGVsIGlwcyAwMDAwOjAwOjFmLjY6IENQVSBURFAgZG9lc24ndCBt
YXRjaCBleHBlY3RlZCB2YWx1ZSAoZm91bmQgMjUsIGV4cGVjdGVkIDI5KQppbnRlbCBpcHMgMDAw
MDowMDoxZi42OiBmYWlsZWQgdG8gZ2V0IGk5MTUgc3ltYm9scywgZ3JhcGhpY3MgdHVyYm8gZGlz
YWJsZWQgdW50aWwgaTkxNSBsb2FkcwppbnRlbCBpcHMgMDAwMDowMDoxZi42OiBJUFMgZHJpdmVy
IGluaXRpYWxpemVkLCBNQ1AgdGVtcCBsaW1pdCA5MAptaWNyb2NvZGU6IENQVTAgc2lnPTB4MjA2
NTUsIHBmPTB4MTAsIHJldmlzaW9uPTB4MgpkY2RiYXMgZGNkYmFzOiBEZWxsIFN5c3RlbXMgTWFu
YWdlbWVudCBCYXNlIERyaXZlciAodmVyc2lvbiA1LjYuMC0zLjIpCmxwOiBkcml2ZXIgbG9hZGVk
IGJ1dCBubyBkZXZpY2VzIGZvdW5kCmlucHV0OiBEZWxsIFdNSSBob3RrZXlzIGFzIC9kZXZpY2Vz
L3ZpcnR1YWwvaW5wdXQvaW5wdXQ2Cm1pY3JvY29kZTogQ1BVMSBzaWc9MHgyMDY1NSwgcGY9MHgx
MCwgcmV2aXNpb249MHgyCm1pY3JvY29kZTogQ1BVMiBzaWc9MHgyMDY1NSwgcGY9MHgxMCwgcmV2
aXNpb249MHgyCm1pY3JvY29kZTogQ1BVMyBzaWc9MHgyMDY1NSwgcGY9MHgxMCwgcmV2aXNpb249
MHgyCm1pY3JvY29kZTogTWljcm9jb2RlIFVwZGF0ZSBEcml2ZXI6IHYyLjAwIDx0aWdyYW5AYWl2
YXppYW4uZnNuZXQuY28udWs+LCBQZXRlciBPcnViYQptZWk6IG1vZHVsZSBpcyBmcm9tIHRoZSBz
dGFnaW5nIGRpcmVjdG9yeSwgdGhlIHF1YWxpdHkgaXMgdW5rbm93biwgeW91IGhhdmUgYmVlbiB3
YXJuZWQuCm1laSAwMDAwOjAwOjE2LjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAptZWkg
MDAwMDowMDoxNi4wOiBpcnEgNDggZm9yIE1TSS9NU0ktWAp0eXBlPTE0MDAgYXVkaXQoMTMzODQ5
NDMzMC43Mjg6OCk6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBu
YW1lPSIvdXNyL3NiaW4vbnRwZCIgcGlkPTc4OCBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9
MTQwMCBhdWRpdCgxMzM4NDk0MzMwLjczODo5KTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9u
PSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii91c3Ivc2Jpbi9udHBkIiBwaWQ9Nzg5IGNvbW09ImFw
cGFybW9yX3BhcnNlciIKcHNtb3VzZSBzZXJpbzE6IHN5bmFwdGljczogVG91Y2hwYWQgbW9kZWw6
IDEsIGZ3OiA3LjIsIGlkOiAweDFjMGIxLCBjYXBzOiAweGQwNDczMy8weGE0MDAwMC8weGEwMDAw
CkxpbnV4IG1lZGlhIGludGVyZmFjZTogdjAuMTAKaW5wdXQ6IFN5blBTLzIgU3luYXB0aWNzIFRv
dWNoUGFkIGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMS9pbnB1dC9pbnB1dDcKaXBf
dGFibGVzOiAoQykgMjAwMC0yMDA2IE5ldGZpbHRlciBDb3JlIFRlYW0KTGludXggdmlkZW8gY2Fw
dHVyZSBpbnRlcmZhY2U6IHYyLjAwCmNmZzgwMjExOiBDYWxsaW5nIENSREEgdG8gdXBkYXRlIHdv
cmxkIHJlZ3VsYXRvcnkgZG9tYWluCnV2Y3ZpZGVvOiBGb3VuZCBVVkMgMS4wMCBkZXZpY2UgTGFw
dG9wX0ludGVncmF0ZWRfV2ViY2FtXzEuM00gKDBjNDU6NjQ4MCkKaW5wdXQ6IExhcHRvcF9JbnRl
Z3JhdGVkX1dlYmNhbV8xLjNNIGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxYS4wL3Vz
YjEvMS0xLzEtMS42LzEtMS42OjEuMC9pbnB1dC9pbnB1dDgKdXNiY29yZTogcmVnaXN0ZXJlZCBu
ZXcgaW50ZXJmYWNlIGRyaXZlciB1dmN2aWRlbwpVU0IgVmlkZW8gQ2xhc3MgZHJpdmVyICgxLjEu
MSkKbmZfY29ubnRyYWNrIHZlcnNpb24gMC41LjAgKDE2Mzg0IGJ1Y2tldHMsIDY1NTM2IG1heCkK
Y2ZnODAyMTE6IFdvcmxkIHJlZ3VsYXRvcnkgZG9tYWluIHVwZGF0ZWQ6CmNmZzgwMjExOiAgIChz
dGFydF9mcmVxIC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4
X2VpcnApCmNmZzgwMjExOiAgICgyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6
KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoMjQ1NzAwMCBLSHogLSAyNDgyMDAw
IEtIeiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDI0NzQw
MDAgS0h6IC0gMjQ5NDAwMCBLSHogQCAyMDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNm
ZzgwMjExOiAgICg1MTcwMDAwIEtIeiAtIDUyNTAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBt
QmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoNTczNTAwMCBLSHogLSA1ODM1MDAwIEtIeiBAIDQw
MDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKc25kX2hkYV9pbnRlbCAwMDAwOjAwOjFiLjA6
IGlycSA0OSBmb3IgTVNJL01TSS1YCmlwNl90YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0ZmlsdGVy
IENvcmUgVGVhbQppbnB1dDogSERBIEludGVsIE1pYyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAw
MDA6MDA6MWIuMC9zb3VuZC9jYXJkMC9pbnB1dDkKaW5wdXQ6IEhEQSBJbnRlbCBIZWFkcGhvbmUg
YXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjFiLjAvc291bmQvY2FyZDAvaW5wdXQxMApz
bmRfaGRhX2ludGVsIDAwMDA6MDE6MDAuMTogaXJxIDUwIGZvciBNU0kvTVNJLVgKaW5wdXQ6IEhE
LUF1ZGlvIEdlbmVyaWMgSERNSS9EUCxwY209MyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6
MDA6MDEuMC8wMDAwOjAxOjAwLjEvc291bmQvY2FyZDEvaW5wdXQxMQpJbnRlbChSKSBXaXJlbGVz
cyBXaUZpIExpbmsgQUdOIGRyaXZlciBmb3IgTGludXgsIGluLXRyZWU6CkNvcHlyaWdodChjKSAy
MDAzLTIwMTIgSW50ZWwgQ29ycG9yYXRpb24KaXdsd2lmaSAwMDAwOjEyOjAwLjA6IHBjaV9yZXNv
dXJjZV9sZW4gPSAweDAwMDAyMDAwCml3bHdpZmkgMDAwMDoxMjowMC4wOiBwY2lfcmVzb3VyY2Vf
YmFzZSA9IGZmZmZjOTAwMTEwZjQwMDAKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IEhXIFJldmlzaW9u
IElEID0gMHgwCml3bHdpZmkgMDAwMDoxMjowMC4wOiBpcnEgNTEgZm9yIE1TSS9NU0ktWAppd2x3
aWZpIDAwMDA6MTI6MDAuMDogbG9hZGVkIGZpcm13YXJlIHZlcnNpb24gMzkuMzEuNS4xIGJ1aWxk
IDM1MTM4Cml3bHdpZmkgMDAwMDoxMjowMC4wOiBDT05GSUdfSVdMV0lGSV9ERUJVRyBkaXNhYmxl
ZAppd2x3aWZpIDAwMDA6MTI6MDAuMDogQ09ORklHX0lXTFdJRklfREVCVUdGUyBkaXNhYmxlZApp
d2x3aWZpIDAwMDA6MTI6MDAuMDogQ09ORklHX0lXTFdJRklfREVWSUNFX1RSQUNJTkcgZW5hYmxl
ZAppd2x3aWZpIDAwMDA6MTI6MDAuMDogQ09ORklHX0lXTFdJRklfREVWSUNFX1RFU1RNT0RFIGVu
YWJsZWQKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IENPTkZJR19JV0xXSUZJX1AyUCBlbmFibGVkCml3
bHdpZmkgMDAwMDoxMjowMC4wOiBEZXRlY3RlZCBJbnRlbChSKSBDZW50cmlubyhSKSBXaXJlbGVz
cy1OIDEwMDAgQkdOLCBSRVY9MHg2Qwppd2x3aWZpIDAwMDA6MTI6MDAuMDogTDEgRGlzYWJsZWQ7
IEVuYWJsaW5nIEwwUwppd2x3aWZpIDAwMDA6MTI6MDAuMDogZGV2aWNlIEVFUFJPTSBWRVI9MHgx
NWQsIENBTElCPTB4Ngppd2x3aWZpIDAwMDA6MTI6MDAuMDogRGV2aWNlIFNLVTogMHg1MAppd2x3
aWZpIDAwMDA6MTI6MDAuMDogVmFsaWQgVHggYW50OiAweDEsIFZhbGlkIFJ4IGFudDogMHgzCml3
bHdpZmkgMDAwMDoxMjowMC4wOiBUdW5hYmxlIGNoYW5uZWxzOiAxMyA4MDIuMTFiZywgMCA4MDIu
MTFhIGNoYW5uZWxzClJlZ2lzdGVyZWQgbGVkIGRldmljZTogcGh5MC1sZWQKY2ZnODAyMTE6IEln
bm9yaW5nIHJlZ3VsYXRvcnkgcmVxdWVzdCBTZXQgYnkgY29yZSBzaW5jZSB0aGUgZHJpdmVyIHVz
ZXMgaXRzIG93biBjdXN0b20gcmVndWxhdG9yeSBkb21haW4KaWVlZTgwMjExIHBoeTA6IFNlbGVj
dGVkIHJhdGUgY29udHJvbCBhbGdvcml0aG0gJ2l3bC1hZ24tcnMnCnBwZGV2OiB1c2VyLXNwYWNl
IHBhcmFsbGVsIHBvcnQgZHJpdmVyCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0MzM5Ljc4ODoxMCk6
IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL2xp
Yi9jdXBzL2JhY2tlbmQvY3Vwcy1wZGYiIHBpZD0xMTQ5IGNvbW09ImFwcGFybW9yX3BhcnNlciIK
dHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzMzkuNzg4OjExKTogYXBwYXJtb3I9IlNUQVRVUyIgb3Bl
cmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii91c3Ivc2Jpbi9jdXBzZCIgcGlkPTExNDkgY29t
bT0iYXBwYXJtb3JfcGFyc2VyIgpyODE2OSAwMDAwOjEzOjAwLjA6IGV0aDA6IGxpbmsgZG93bgpB
RERSQ09ORihORVRERVZfVVApOiBldGgwOiBsaW5rIGlzIG5vdCByZWFkeQp0eXBlPTE0MDAgYXVk
aXQoMTMzODQ5NDM0NC41Nzg6MTIpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2Zp
bGVfcmVwbGFjZSIgbmFtZT0iL3NiaW4vZGhjbGllbnQiIHBpZD0xMzY3IGNvbW09ImFwcGFybW9y
X3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzNDQuNTc4OjEzKTogYXBwYXJtb3I9IlNU
QVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii91c3IvbGliL05ldHdvcmtN
YW5hZ2VyL25tLWRoY3AtY2xpZW50LmFjdGlvbiIgcGlkPTEzNjcgY29tbT0iYXBwYXJtb3JfcGFy
c2VyIgp0eXBlPTE0MDAgYXVkaXQoMTMzODQ5NDM0NC41Nzg6MTQpOiBhcHBhcm1vcj0iU1RBVFVT
IiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3Vzci9saWIvY29ubm1hbi9zY3Jp
cHRzL2RoY2xpZW50LXNjcmlwdCIgcGlkPTEzNjcgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgp0eXBl
PTE0MDAgYXVkaXQoMTMzODQ5NDM0NC44Njg6MTUpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRp
b249InByb2ZpbGVfbG9hZCIgbmFtZT0iL3Vzci9zaGFyZS9nZG0vZ3Vlc3Qtc2Vzc2lvbi9Yc2Vz
c2lvbiIgcGlkPTEzNjYgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgp0eXBlPTE0MDAgYXVkaXQoMTMz
ODQ5NDM0NS4wNTg6MTYpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9h
ZCIgbmFtZT0iL3Vzci9iaW4vZnJlc2hjbGFtIiBwaWQ9MTM3MCBjb21tPSJhcHBhcm1vcl9wYXJz
ZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0MzQ1LjEyODoxNyk6IGFwcGFybW9yPSJTVEFUVVMi
IG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL2xpYi9saWJ2aXJ0L3ZpcnQtYWEt
aGVscGVyIiBwaWQ9MTM3MiBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgx
MzM4NDk0MzQ1LjI3ODoxOCk6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9s
b2FkIiBuYW1lPSIvdXNyL3NiaW4vbGlidmlydGQiIHBpZD0xMzc2IGNvbW09ImFwcGFybW9yX3Bh
cnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzNDUuNDI4OjE5KTogYXBwYXJtb3I9IlNUQVRV
UyIgb3BlcmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii91c3Ivc2Jpbi9teXNxbGQiIHBpZD0x
Mzc3IGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzNDUuNTE4
OjIwKTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii91
c3Ivc2Jpbi9uYW1lZCIgcGlkPTEzNzggY29tbT0iYXBwYXJtb3JfcGFyc2VyIgp0eXBlPTE0MDAg
YXVkaXQoMTMzODQ5NDM0NS42Njg6MjEpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InBy
b2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3Vzci9saWIvY3Vwcy9iYWNrZW5kL2N1cHMtcGRmIiBwaWQ9
MTM3NSBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0MzQ1LjY2
ODoyMik6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9yZXBsYWNlIiBuYW1l
PSIvdXNyL3NiaW4vY3Vwc2QiIHBpZD0xMzc1IGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0x
NDAwIGF1ZGl0KDEzMzg0OTQzNDUuNjk4OjIzKTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9u
PSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii91c3Ivc2Jpbi9udHBkIiBwaWQ9MTM3OSBjb21tPSJh
cHBhcm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0MzQ1Ljc4ODoyNCk6IGFwcGFy
bW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL3NiaW4vc2xh
cGQiIHBpZD0xMzgwIGNvbW09ImFwcGFybW9yX3BhcnNlciIKYXVkaXRfcHJpbnRrX3NrYjogMTIg
Y2FsbGJhY2tzIHN1cHByZXNzZWQKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQzNTEuMjY4OjI5KTog
YXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii91c3Iv
c2Jpbi9teXNxbGQiIHBpZD0xNTE4IGNvbW09ImFwcGFybW9yX3BhcnNlciIKa3ZtOiBWTV9FWElU
X0xPQURfSUEzMl9QRVJGX0dMT0JBTF9DVFJMIGRvZXMgbm90IHdvcmsgcHJvcGVybHkuIFVzaW5n
IHdvcmthcm91bmQKQnJpZGdlIGZpcmV3YWxsaW5nIHJlZ2lzdGVyZWQKQUREUkNPTkYoTkVUREVW
X1VQKTogdmlyYnIwOiBsaW5rIGlzIG5vdCByZWFkeQpoZGEtaW50ZWw6IElSUSB0aW1pbmcgd29y
a2Fyb3VuZCBpcyBhY3RpdmF0ZWQgZm9yIGNhcmQgIzEuIFN1Z2dlc3QgYSBiaWdnZXIgYmRsX3Bv
c19hZGouCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1y
byx1c2VyX3hhdHRyLGNvbW1pdD0wCkFERFJDT05GKE5FVERFVl9VUCk6IHRhcDA6IGxpbmsgaXMg
bm90IHJlYWR5Cml3bHdpZmkgMDAwMDoxMjowMC4wOiBSRl9LSUxMIGJpdCB0b2dnbGVkIHRvIGVu
YWJsZSByYWRpby4KdXNiIDItMS42OiBuZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAz
IHVzaW5nIGVoY2lfaGNkCmh1YiAyLTEuNjoxLjA6IFVTQiBodWIgZm91bmQKaHViIDItMS42OjEu
MDogMyBwb3J0cyBkZXRlY3RlZAp1c2IgMi0xLjYuMTogbmV3IGZ1bGwtc3BlZWQgVVNCIGRldmlj
ZSBudW1iZXIgNCB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMjogbmV3IGZ1bGwtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgNSB1c2luZyBlaGNpX2hjZAppd2x3aWZpIDAwMDA6MTI6MDAuMDogUkZf
S0lMTCBiaXQgdG9nZ2xlZCB0byBkaXNhYmxlIHJhZGlvLgp1c2IgMi0xLjY6IFVTQiBkaXNjb25u
ZWN0LCBkZXZpY2UgbnVtYmVyIDMKdXNiIDItMS42LjE6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2Ug
bnVtYmVyIDQKdXNiIDItMS42LjI6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDUKdXNi
Y29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1c2JoaWQKdXNiaGlkOiBVU0Ig
SElEIGNvcmUgZHJpdmVyCnJhZGVvbiAwMDAwOjAxOjAwLjA6IGV2ZXJncmVlbl9jc190cmFja192
YWxpZGF0ZV9jYjo0MzkgY2JbMF0gYm8gdG9vIHNtYWxsIChsYXllciBzaXplIDE0NzQ1Niwgb2Zm
c2V0IDAsIG1heCBsYXllciAxLCBibyBzaXplIDE0MzM2MCwgc2xpY2UgNTc1KQpyYWRlb24gMDAw
MDowMTowMC4wOiBldmVyZ3JlZW5fY3NfdHJhY2tfdmFsaWRhdGVfY2I6NDQzIHByb2JsZW1hdGlj
IHN1cmY6ICgxOTIgMTkyKSAoMCA0IDEgMCAwIDAgMCkKcmFkZW9uIDAwMDA6MDE6MDAuMDogZXZl
cmdyZWVuX3BhY2tldDNfY2hlY2s6MjA1NSBpbnZhbGlkIGNtZCBzdHJlYW0gNDYxCltkcm06cmFk
ZW9uX2NzX2liX2NodW5rXSAqRVJST1IqIEludmFsaWQgY29tbWFuZCBzdHJlYW0gIQpyYWRlb24g
MDAwMDowMTowMC4wOiBldmVyZ3JlZW5fY3NfdHJhY2tfdmFsaWRhdGVfY2I6NDM5IGNiWzBdIGJv
IHRvbyBzbWFsbCAobGF5ZXIgc2l6ZSAxNDc0NTYsIG9mZnNldCAwLCBtYXggbGF5ZXIgMSwgYm8g
c2l6ZSAxNDMzNjAsIHNsaWNlIDU3NSkKcmFkZW9uIDAwMDA6MDE6MDAuMDogZXZlcmdyZWVuX2Nz
X3RyYWNrX3ZhbGlkYXRlX2NiOjQ0MyBwcm9ibGVtYXRpYyBzdXJmOiAoMTkyIDE5MikgKDAgNCAx
IDAgMCAwIDApCnJhZGVvbiAwMDAwOjAxOjAwLjA6IGV2ZXJncmVlbl9wYWNrZXQzX2NoZWNrOjIw
NTUgaW52YWxpZCBjbWQgc3RyZWFtIDQ2MQpbZHJtOnJhZGVvbl9jc19pYl9jaHVua10gKkVSUk9S
KiBJbnZhbGlkIGNvbW1hbmQgc3RyZWFtICEKcmFkZW9uIDAwMDA6MDE6MDAuMDogZXZlcmdyZWVu
X2NzX3RyYWNrX3ZhbGlkYXRlX2NiOjQzOSBjYlswXSBibyB0b28gc21hbGwgKGxheWVyIHNpemUg
Nzk4NzIwLCBvZmZzZXQgMCwgbWF4IGxheWVyIDEsIGJvIHNpemUgNzk0NjI0LCBzbGljZSAzMTE5
KQpyYWRlb24gMDAwMDowMTowMC4wOiBldmVyZ3JlZW5fY3NfdHJhY2tfdmFsaWRhdGVfY2I6NDQz
IHByb2JsZW1hdGljIHN1cmY6ICgzODQgNTIwKSAoMCA0IDEgMCAwIDAgMCkKcmFkZW9uIDAwMDA6
MDE6MDAuMDogZXZlcmdyZWVuX3BhY2tldDNfY2hlY2s6MjA1NSBpbnZhbGlkIGNtZCBzdHJlYW0g
NDYxCltkcm06cmFkZW9uX2NzX2liX2NodW5rXSAqRVJST1IqIEludmFsaWQgY29tbWFuZCBzdHJl
YW0gIQpyYWRlb24gMDAwMDowMTowMC4wOiBldmVyZ3JlZW5fY3NfdHJhY2tfdmFsaWRhdGVfY2I6
NDM5IGNiWzBdIGJvIHRvbyBzbWFsbCAobGF5ZXIgc2l6ZSA0NTg3NTIsIG9mZnNldCAwLCBtYXgg
bGF5ZXIgMSwgYm8gc2l6ZSA0NDY0NjQsIHNsaWNlIDE3OTEpCnJhZGVvbiAwMDAwOjAxOjAwLjA6
IGV2ZXJncmVlbl9jc190cmFja192YWxpZGF0ZV9jYjo0NDMgcHJvYmxlbWF0aWMgc3VyZjogKDUx
MiAyMjQpICgwIDQgMSAwIDAgMCAwKQpyYWRlb24gMDAwMDowMTowMC4wOiBldmVyZ3JlZW5fcGFj
a2V0M19jaGVjazoyMDU1IGludmFsaWQgY21kIHN0cmVhbSA3MTcwCltkcm06cmFkZW9uX2NzX2li
X2NodW5rXSAqRVJST1IqIEludmFsaWQgY29tbWFuZCBzdHJlYW0gIQpyYWRlb24gMDAwMDowMTow
MC4wOiBldmVyZ3JlZW5fY3NfdHJhY2tfdmFsaWRhdGVfY2I6NDM5IGNiWzBdIGJvIHRvbyBzbWFs
bCAobGF5ZXIgc2l6ZSA3OTg3MjAsIG9mZnNldCAwLCBtYXggbGF5ZXIgMSwgYm8gc2l6ZSA3OTA1
MjgsIHNsaWNlIDMxMTkpCnJhZGVvbiAwMDAwOjAxOjAwLjA6IGV2ZXJncmVlbl9jc190cmFja192
YWxpZGF0ZV9jYjo0NDMgcHJvYmxlbWF0aWMgc3VyZjogKDM4NCA1MjApICgwIDQgMSAwIDAgMCAw
KQpyYWRlb24gMDAwMDowMTowMC4wOiBldmVyZ3JlZW5fcGFja2V0M19jaGVjazoyMDU1IGludmFs
aWQgY21kIHN0cmVhbSA0NjEKW2RybTpyYWRlb25fY3NfaWJfY2h1bmtdICpFUlJPUiogSW52YWxp
ZCBjb21tYW5kIHN0cmVhbSAhCk1heSAzMSAyMzowMzoxMyBwaHlsbGlzIGtlcm5lbDogS2VybmVs
IGxvZ2dpbmcgKHByb2MpIHN0b3BwZWQuCk1heSAzMSAyMzowMzo1OCBwaHlsbGlzIGtlcm5lbDog
aW1rbG9nIDQuNi40LCBsb2cgc291cmNlID0gL3Byb2Mva21zZyBzdGFydGVkLgpJbml0aWFsaXpp
bmcgY2dyb3VwIHN1YnN5cyBjcHVzZXQKSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1Ckxp
bnV4IHZlcnNpb24gMy4zLjYgKG1hcmVicmlAcGh5bGxpcykgKGdjYyB2ZXJzaW9uIDQuNS4yIChV
YnVudHUvTGluYXJvIDQuNS4yLTh1YnVudHU0KSApICMxIFNNUCBUdWUgTWF5IDE1IDAwOjIyOjU4
IEVBVCAyMDEyCkNvbW1hbmQgbGluZTogQk9PVF9JTUFHRT0vYm9vdC92bWxpbnV6LTMuMy42IHJv
b3Q9VVVJRD04OWRhNGM4Ny0yNTg5LTQ3NDEtOTExNS1jMzRkZTExYjNhYTQgcm8gY3Jhc2hrZXJu
ZWw9Mzg0TS0yRzo2NE0sMkctOjEyOE0gcXVpZXQgc3BsYXNoCkJJT1MtcHJvdmlkZWQgcGh5c2lj
YWwgUkFNIG1hcDoKIEJJT1MtZTgyMDogMDAwMDAwMDAwMDAwMDAwMCAtIDAwMDAwMDAwMDAwOWQ0
MDAgKHVzYWJsZSkKIEJJT1MtZTgyMDogMDAwMDAwMDAwMDA5ZDQwMCAtIDAwMDAwMDAwMDAwYTAw
MDAgKHJlc2VydmVkKQogQklPUy1lODIwOiAwMDAwMDAwMDAwMGUwMDAwIC0gMDAwMDAwMDAwMDEw
MDAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6IDAwMDAwMDAwMDAxMDAwMDAgLSAwMDAwMDAwMGJm
NWE3MDAwICh1c2FibGUpCiBCSU9TLWU4MjA6IDAwMDAwMDAwYmY1YTcwMDAgLSAwMDAwMDAwMGJm
NWVmMDAwIChBQ1BJIE5WUykKIEJJT1MtZTgyMDogMDAwMDAwMDBiZjVlZjAwMCAtIDAwMDAwMDAw
YmY1ZjkwMDAgKEFDUEkgZGF0YSkKIEJJT1MtZTgyMDogMDAwMDAwMDBiZjVmOTAwMCAtIDAwMDAw
MDAwYmY1ZmMwMDAgKEFDUEkgTlZTKQogQklPUy1lODIwOiAwMDAwMDAwMGJmNWZjMDAwIC0gMDAw
MDAwMDBiZjYyMDAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6IDAwMDAwMDAwYmY2MjAwMDAgLSAw
MDAwMDAwMGJmNjIxMDAwICh1c2FibGUpCiBCSU9TLWU4MjA6IDAwMDAwMDAwYmY2MjEwMDAgLSAw
MDAwMDAwMGJmNjI5MDAwIChBQ1BJIE5WUykKIEJJT1MtZTgyMDogMDAwMDAwMDBiZjYyOTAwMCAt
IDAwMDAwMDAwYmY2MmMwMDAgKHJlc2VydmVkKQogQklPUy1lODIwOiAwMDAwMDAwMGJmNjJjMDAw
IC0gMDAwMDAwMDBiZjYzMTAwMCAoQUNQSSBOVlMpCiBCSU9TLWU4MjA6IDAwMDAwMDAwYmY2MzEw
MDAgLSAwMDAwMDAwMGJmNjUxMDAwIChyZXNlcnZlZCkKIEJJT1MtZTgyMDogMDAwMDAwMDBiZjY1
MTAwMCAtIDAwMDAwMDAwYmY2OTQwMDAgKEFDUEkgTlZTKQogQklPUy1lODIwOiAwMDAwMDAwMGJm
Njk0MDAwIC0gMDAwMDAwMDBiZjgwMDAwMCAodXNhYmxlKQogQklPUy1lODIwOiAwMDAwMDAwMGUw
MDAwMDAwIC0gMDAwMDAwMDBmMDAwMDAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6IDAwMDAwMDAw
ZmVkMWMwMDAgLSAwMDAwMDAwMGZlZDIwMDAwIChyZXNlcnZlZCkKIEJJT1MtZTgyMDogMDAwMDAw
MDBmZjAwMDAwMCAtIDAwMDAwMDAxMDAwMDAwMDAgKHJlc2VydmVkKQogQklPUy1lODIwOiAwMDAw
MDAwMTAwMDAwMDAwIC0gMDAwMDAwMDEzODAwMDAwMCAodXNhYmxlKQpOWCAoRXhlY3V0ZSBEaXNh
YmxlKSBwcm90ZWN0aW9uOiBhY3RpdmUKRE1JIDIuNiBwcmVzZW50LgpETUk6IERlbGwgSW5jLiBJ
bnNwaXJvbiBONTAxMC8wWVhYSkosIEJJT1MgQTEwIDExLzE3LzIwMTAKZTgyMCB1cGRhdGUgcmFu
Z2U6IDAwMDAwMDAwMDAwMDAwMDAgLSAwMDAwMDAwMDAwMDEwMDAwICh1c2FibGUpID09PiAocmVz
ZXJ2ZWQpCmU4MjAgcmVtb3ZlIHJhbmdlOiAwMDAwMDAwMDAwMGEwMDAwIC0gMDAwMDAwMDAwMDEw
MDAwMCAodXNhYmxlKQpObyBBR1AgYnJpZGdlIGZvdW5kCmxhc3RfcGZuID0gMHgxMzgwMDAgbWF4
X2FyY2hfcGZuID0gMHg0MDAwMDAwMDAKTVRSUiBkZWZhdWx0IHR5cGU6IHVuY2FjaGFibGUKTVRS
UiBmaXhlZCByYW5nZXMgZW5hYmxlZDoKICAwMDAwMC05RkZGRiB3cml0ZS1iYWNrCiAgQTAwMDAt
QkZGRkYgdW5jYWNoYWJsZQogIEMwMDAwLUNGRkZGIHdyaXRlLXByb3RlY3QKICBEMDAwMC1FN0ZG
RiB1bmNhY2hhYmxlCiAgRTgwMDAtRkZGRkYgd3JpdGUtcHJvdGVjdApNVFJSIHZhcmlhYmxlIHJh
bmdlcyBlbmFibGVkOgogIDAgYmFzZSAwMDAwMDAwMDAgbWFzayBGMDAwMDAwMDAgd3JpdGUtYmFj
awogIDEgYmFzZSAxMDAwMDAwMDAgbWFzayBGQzAwMDAwMDAgd3JpdGUtYmFjawogIDIgYmFzZSAw
QzAwMDAwMDAgbWFzayBGQzAwMDAwMDAgdW5jYWNoYWJsZQogIDMgYmFzZSAxMzgwMDAwMDAgbWFz
ayBGRjgwMDAwMDAgdW5jYWNoYWJsZQogIDQgZGlzYWJsZWQKICA1IGRpc2FibGVkCiAgNiBkaXNh
YmxlZAogIDcgZGlzYWJsZWQKeDg2IFBBVCBlbmFibGVkOiBjcHUgMCwgb2xkIDB4NzA0MDYwMDA3
MDQwNiwgbmV3IDB4NzAxMDYwMDA3MDEwNgplODIwIHVwZGF0ZSByYW5nZTogMDAwMDAwMDBjMDAw
MDAwMCAtIDAwMDAwMDAxMDAwMDAwMDAgKHVzYWJsZSkgPT0+IChyZXNlcnZlZCkKbGFzdF9wZm4g
PSAweGJmODAwIG1heF9hcmNoX3BmbiA9IDB4NDAwMDAwMDAwCmZvdW5kIFNNUCBNUC10YWJsZSBh
dCBbZmZmZjg4MDAwMDBmY2RiMF0gZmNkYjAKaW5pdGlhbCBtZW1vcnkgbWFwcGVkIDogMCAtIDIw
MDAwMDAwCkJhc2UgbWVtb3J5IHRyYW1wb2xpbmUgYXQgW2ZmZmY4ODAwMDAwOTgwMDBdIDk4MDAw
IHNpemUgMjA0ODAKaW5pdF9tZW1vcnlfbWFwcGluZzogMDAwMDAwMDAwMDAwMDAwMC0wMDAwMDAw
MGJmODAwMDAwCiAwMDAwMDAwMDAwIC0gMDBiZjgwMDAwMCBwYWdlIDJNCmtlcm5lbCBkaXJlY3Qg
bWFwcGluZyB0YWJsZXMgdXAgdG8gYmY4MDAwMDAgQCAxZmZmYzAwMC0yMDAwMDAwMAppbml0X21l
bW9yeV9tYXBwaW5nOiAwMDAwMDAwMTAwMDAwMDAwLTAwMDAwMDAxMzgwMDAwMDAKIDAxMDAwMDAw
MDAgLSAwMTM4MDAwMDAwIHBhZ2UgMk0Ka2VybmVsIGRpcmVjdCBtYXBwaW5nIHRhYmxlcyB1cCB0
byAxMzgwMDAwMDAgQCBiZjdmYTAwMC1iZjgwMDAwMApSQU1ESVNLOiAyNTkzYzAwMCAtIDJlYzk2
MDAwClJlc2VydmluZyAxMjhNQiBvZiBtZW1vcnkgYXQgNzY4TUIgZm9yIGNyYXNoa2VybmVsIChT
eXN0ZW0gUkFNOiA0OTkyTUIpCkFDUEk6IFJTRFAgMDAwMDAwMDAwMDBmMDQxMCAwMDAyNCAodjAz
IERFTEwgICkKQUNQSTogWFNEVCAwMDAwMDAwMGJmNWVmMDgwIDAwMDU0ICh2MDEgREVMTCAgICBX
TjA5ICAgIDAxMDcyMDA5IEFNSSAgMDAwMTAwMTMpCkFDUEk6IEZBQ1AgMDAwMDAwMDBiZjVmOGE0
OCAwMDBGNCAodjA0IERFTEwgICAgV04wOSAgICAwMTA3MjAwOSBBTUkgIDAwMDEwMDEzKQpBQ1BJ
IFdhcm5pbmc6IDMyLzY0IEZBQ1MgYWRkcmVzcyBtaXNtYXRjaCBpbiBGQURUIC0gdHdvIEZBQ1Mg
dGFibGVzISAoMjAxMjAxMTEvdGJmYWR0LTM3OCkKQUNQSSBXYXJuaW5nOiAzMi82NFggRkFDUyBh
ZGRyZXNzIG1pc21hdGNoIGluIEZBRFQgLSAweEJGNjJDRjQwLzB4MDAwMDAwMDBCRjYyQ0Y4MCwg
dXNpbmcgMzIgKDIwMTIwMTExL3RiZmFkdC01MDIpCkFDUEk6IERTRFQgMDAwMDAwMDBiZjVlZjE2
OCAwOThERiAodjAyIERFTEwgICAgV04wOSAgICAwMDAwNTAxMCBJTlRMIDIwMDUxMTE3KQpBQ1BJ
OiBGQUNTIDAwMDAwMDAwYmY2MmNmNDAgMDAwNDAKQUNQSTogQVBJQyAwMDAwMDAwMGJmNWY4YjQw
IDAwMDcyICh2MDEgREVMTCAgIFdOMDkgICAgIDAxMDcyMDA5IEFNSSAgMDAwMTAwMTMpCkFDUEk6
IFNTRFQgMDAwMDAwMDBiZjVmOGJiOCAwMDE0RSAodjAxIEFNSUNQVSAgICAgUFJPQyAwMDAwMDAw
MSBNU0ZUIDAzMDAwMDAxKQpBQ1BJOiBNQ0ZHIDAwMDAwMDAwYmY1ZjhkMDggMDAwM0MgKHYwMSAg
IERFTEwgICAgIFdOMDkgMDEwNzIwMDkgTVNGVCAwMDAwMDA5NykKQUNQSTogSFBFVCAwMDAwMDAw
MGJmNWY4ZDQ4IDAwMDM4ICh2MDEgICBERUxMICAgICBXTjA5IDAxMDcyMDA5IEFNSS4gMDAwMDAw
MDMpCkFDUEk6IE9TRlIgMDAwMDAwMDBiZjVmOGQ4MCAwMDA4QyAodjAxIERFTEwgICAgTTA4ICAg
ICAwN0RBMEIxMSBBU0wgIDAwMDAwMDYxKQpBQ1BJOiBMb2NhbCBBUElDIGFkZHJlc3MgMHhmZWUw
MDAwMApObyBOVU1BIGNvbmZpZ3VyYXRpb24gZm91bmQKRmFraW5nIGEgbm9kZSBhdCAwMDAwMDAw
MDAwMDAwMDAwLTAwMDAwMDAxMzgwMDAwMDAKSW5pdG1lbSBzZXR1cCBub2RlIDAgMDAwMDAwMDAw
MDAwMDAwMC0wMDAwMDAwMTM4MDAwMDAwCiAgTk9ERV9EQVRBIFswMDAwMDAwMTM3ZmZiMDAwIC0g
MDAwMDAwMDEzN2ZmZmZmZl0KIFtmZmZmZWEwMDAwMDAwMDAwLWZmZmZlYTAwMDRkZmZmZmZdIFBN
RCAtPiBbZmZmZjg4MDEzMzgwMDAwMC1mZmZmODgwMTM3NWZmZmZmXSBvbiBub2RlIDAKWm9uZSBQ
Rk4gcmFuZ2VzOgogIERNQSAgICAgIDB4MDAwMDAwMTAgLT4gMHgwMDAwMTAwMAogIERNQTMyICAg
IDB4MDAwMDEwMDAgLT4gMHgwMDEwMDAwMAogIE5vcm1hbCAgIDB4MDAxMDAwMDAgLT4gMHgwMDEz
ODAwMApNb3ZhYmxlIHpvbmUgc3RhcnQgUEZOIGZvciBlYWNoIG5vZGUKRWFybHkgbWVtb3J5IFBG
TiByYW5nZXMKICAgIDA6IDB4MDAwMDAwMTAgLT4gMHgwMDAwMDA5ZAogICAgMDogMHgwMDAwMDEw
MCAtPiAweDAwMGJmNWE3CiAgICAwOiAweDAwMGJmNjIwIC0+IDB4MDAwYmY2MjEKICAgIDA6IDB4
MDAwYmY2OTQgLT4gMHgwMDBiZjgwMAogICAgMDogMHgwMDEwMDAwMCAtPiAweDAwMTM4MDAwCk9u
IG5vZGUgMCB0b3RhbHBhZ2VzOiAxMDEzNDA5CiAgRE1BIHpvbmU6IDY0IHBhZ2VzIHVzZWQgZm9y
IG1lbW1hcAogIERNQSB6b25lOiA1IHBhZ2VzIHJlc2VydmVkCiAgRE1BIHpvbmU6IDM5MTIgcGFn
ZXMsIExJRk8gYmF0Y2g6MAogIERNQTMyIHpvbmU6IDE2MzIwIHBhZ2VzIHVzZWQgZm9yIG1lbW1h
cAogIERNQTMyIHpvbmU6IDc2MzczMiBwYWdlcywgTElGTyBiYXRjaDozMQogIE5vcm1hbCB6b25l
OiAzNTg0IHBhZ2VzIHVzZWQgZm9yIG1lbW1hcAogIE5vcm1hbCB6b25lOiAyMjU3OTIgcGFnZXMs
IExJRk8gYmF0Y2g6MzEKQUNQSTogUE0tVGltZXIgSU8gUG9ydDogMHg0MDgKQUNQSTogTG9jYWwg
QVBJQyBhZGRyZXNzIDB4ZmVlMDAwMDAKQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwMV0gbGFwaWNf
aWRbMHgwMF0gZW5hYmxlZCkKQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwMl0gbGFwaWNfaWRbMHgw
NF0gZW5hYmxlZCkKQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwM10gbGFwaWNfaWRbMHgwMV0gZW5h
YmxlZCkKQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwNF0gbGFwaWNfaWRbMHgwNV0gZW5hYmxlZCkK
QUNQSTogTEFQSUNfTk1JIChhY3BpX2lkWzB4ZmZdIGhpZ2ggZWRnZSBsaW50WzB4MV0pCkFDUEk6
IElPQVBJQyAoaWRbMHgwMF0gYWRkcmVzc1sweGZlYzAwMDAwXSBnc2lfYmFzZVswXSkKSU9BUElD
WzBdOiBhcGljX2lkIDAsIHZlcnNpb24gMzIsIGFkZHJlc3MgMHhmZWMwMDAwMCwgR1NJIDAtMjMK
QUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgMCBnbG9iYWxfaXJxIDIgZGZsIGRmbCkK
QUNQSTogSU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgOSBnbG9iYWxfaXJxIDkgaGlnaCBsZXZl
bCkKQUNQSTogSVJRMCB1c2VkIGJ5IG92ZXJyaWRlLgpBQ1BJOiBJUlEyIHVzZWQgYnkgb3ZlcnJp
ZGUuCkFDUEk6IElSUTkgdXNlZCBieSBvdmVycmlkZS4KVXNpbmcgQUNQSSAoTUFEVCkgZm9yIFNN
UCBjb25maWd1cmF0aW9uIGluZm9ybWF0aW9uCkFDUEk6IEhQRVQgaWQ6IDB4ODA4NmE3MDEgYmFz
ZTogMHhmZWQwMDAwMApTTVA6IEFsbG93aW5nIDQgQ1BVcywgMCBob3RwbHVnIENQVXMKbnJfaXJx
c19nc2k6IDQwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwMDAwOWQwMDAg
LSAwMDAwMDAwMDAwMDllMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAw
MDAwOWUwMDAgLSAwMDAwMDAwMDAwMGEwMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6
IDAwMDAwMDAwMDAwYTAwMDAgLSAwMDAwMDAwMDAwMGUwMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2
ZSBtZW1vcnk6IDAwMDAwMDAwMDAwZTAwMDAgLSAwMDAwMDAwMDAwMTAwMDAwClBNOiBSZWdpc3Rl
cmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY1YTcwMDAgLSAwMDAwMDAwMGJmNWVmMDAwClBN
OiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY1ZWYwMDAgLSAwMDAwMDAwMGJm
NWY5MDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY1ZjkwMDAgLSAw
MDAwMDAwMGJmNWZjMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY1
ZmMwMDAgLSAwMDAwMDAwMGJmNjIwMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAw
MDAwMDAwYmY2MjEwMDAgLSAwMDAwMDAwMGJmNjI5MDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBt
ZW1vcnk6IDAwMDAwMDAwYmY2MjkwMDAgLSAwMDAwMDAwMGJmNjJjMDAwClBNOiBSZWdpc3RlcmVk
IG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY2MmMwMDAgLSAwMDAwMDAwMGJmNjMxMDAwClBNOiBS
ZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY2MzEwMDAgLSAwMDAwMDAwMGJmNjUx
MDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY2NTEwMDAgLSAwMDAw
MDAwMGJmNjk0MDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwYmY4MDAw
MDAgLSAwMDAwMDAwMGUwMDAwMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAw
MDAwZTAwMDAwMDAgLSAwMDAwMDAwMGYwMDAwMDAwClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1v
cnk6IDAwMDAwMDAwZjAwMDAwMDAgLSAwMDAwMDAwMGZlZDFjMDAwClBNOiBSZWdpc3RlcmVkIG5v
c2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMWMwMDAgLSAwMDAwMDAwMGZlZDIwMDAwClBNOiBSZWdp
c3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMjAwMDAgLSAwMDAwMDAwMGZmMDAwMDAw
ClBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmYwMDAwMDAgLSAwMDAwMDAw
MTAwMDAwMDAwCkFsbG9jYXRpbmcgUENJIHJlc291cmNlcyBzdGFydGluZyBhdCBiZjgwMDAwMCAo
Z2FwOiBiZjgwMDAwMDoyMDgwMDAwMCkKQm9vdGluZyBwYXJhdmlydHVhbGl6ZWQga2VybmVsIG9u
IGJhcmUgaGFyZHdhcmUKc2V0dXBfcGVyY3B1OiBOUl9DUFVTOjY0IG5yX2NwdW1hc2tfYml0czo2
NCBucl9jcHVfaWRzOjQgbnJfbm9kZV9pZHM6MQpQRVJDUFU6IEVtYmVkZGVkIDI4IHBhZ2VzL2Nw
dSBAZmZmZjg4MDEzN2MwMDAwMCBzODIxNzYgcjgxOTIgZDI0MzIwIHU1MjQyODgKcGNwdS1hbGxv
YzogczgyMTc2IHI4MTkyIGQyNDMyMCB1NTI0Mjg4IGFsbG9jPTEqMjA5NzE1MgpwY3B1LWFsbG9j
OiBbMF0gMCAxIDIgMyAKQnVpbHQgMSB6b25lbGlzdHMgaW4gTm9kZSBvcmRlciwgbW9iaWxpdHkg
Z3JvdXBpbmcgb24uICBUb3RhbCBwYWdlczogOTkzNDM2ClBvbGljeSB6b25lOiBOb3JtYWwKS2Vy
bmVsIGNvbW1hbmQgbGluZTogQk9PVF9JTUFHRT0vYm9vdC92bWxpbnV6LTMuMy42IHJvb3Q9VVVJ
RD04OWRhNGM4Ny0yNTg5LTQ3NDEtOTExNS1jMzRkZTExYjNhYTQgcm8gY3Jhc2hrZXJuZWw9Mzg0
TS0yRzo2NE0sMkctOjEyOE0gcXVpZXQgc3BsYXNoClBJRCBoYXNoIHRhYmxlIGVudHJpZXM6IDQw
OTYgKG9yZGVyOiAzLCAzMjc2OCBieXRlcykKQ2hlY2tpbmcgYXBlcnR1cmUuLi4KTm8gQUdQIGJy
aWRnZSBmb3VuZApDYWxnYXJ5OiBkZXRlY3RpbmcgQ2FsZ2FyeSB2aWEgQklPUyBFQkRBIGFyZWEK
Q2FsZ2FyeTogVW5hYmxlIHRvIGxvY2F0ZSBSaW8gR3JhbmRlIHRhYmxlIGluIEVCREEgLSBiYWls
aW5nIQpNZW1vcnk6IDM2MjYxODRrLzUxMTE4MDhrIGF2YWlsYWJsZSAoNjIyMmsga2VybmVsIGNv
ZGUsIDEwNTgxNzJrIGFic2VudCwgNDI3NDUyayByZXNlcnZlZCwgNjgzNGsgZGF0YSwgODkyayBp
bml0KQpTTFVCOiBHZW5zbGFicz0xNSwgSFdhbGlnbj02NCwgT3JkZXI9MC0zLCBNaW5PYmplY3Rz
PTAsIENQVXM9NCwgTm9kZXM9MQpIaWVyYXJjaGljYWwgUkNVIGltcGxlbWVudGF0aW9uLgogICAg
ICAgUkNVIGR5bnRpY2staWRsZSBncmFjZS1wZXJpb2QgYWNjZWxlcmF0aW9uIGlzIGVuYWJsZWQu
Ck5SX0lSUVM6NDM1MiBucl9pcnFzOjcxMiAxNgpFeHRlbmRlZCBDTU9TIHllYXI6IDIwMDAKQ29u
c29sZTogY29sb3VyIFZHQSsgODB4MjUKY29uc29sZSBbdHR5MF0gZW5hYmxlZAphbGxvY2F0ZWQg
MTYyNTI5MjggYnl0ZXMgb2YgcGFnZV9jZ3JvdXAKcGxlYXNlIHRyeSAnY2dyb3VwX2Rpc2FibGU9
bWVtb3J5JyBvcHRpb24gaWYgeW91IGRvbid0IHdhbnQgbWVtb3J5IGNncm91cHMKaHBldCBjbG9j
a2V2ZW50IHJlZ2lzdGVyZWQKRmFzdCBUU0MgY2FsaWJyYXRpb24gdXNpbmcgUElUCkRldGVjdGVk
IDI1MjYuODEyIE1IeiBwcm9jZXNzb3IuCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQp
LCB2YWx1ZSBjYWxjdWxhdGVkIHVzaW5nIHRpbWVyIGZyZXF1ZW5jeS4uIDUwNTMuNjIgQm9nb01J
UFMgKGxwaj0yNTI2ODEyMCkKcGlkX21heDogZGVmYXVsdDogMzI3NjggbWluaW11bTogMzAxClNl
Y3VyaXR5IEZyYW1ld29yayBpbml0aWFsaXplZApBcHBBcm1vcjogQXBwQXJtb3IgaW5pdGlhbGl6
ZWQKRGVudHJ5IGNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNTI0Mjg4IChvcmRlcjogMTAsIDQx
OTQzMDQgYnl0ZXMpCklub2RlLWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMjYyMTQ0IChvcmRl
cjogOSwgMjA5NzE1MiBieXRlcykKTW91bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyNTYK
SW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1YWNjdApJbml0aWFsaXppbmcgY2dyb3VwIHN1
YnN5cyBtZW1vcnkKSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgZGV2aWNlcwpJbml0aWFsaXpp
bmcgY2dyb3VwIHN1YnN5cyBmcmVlemVyCkluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIG5ldF9j
bHMKSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgcGVyZl9ldmVudApDUFU6IFBoeXNpY2FsIFBy
b2Nlc3NvciBJRDogMApDUFU6IFByb2Nlc3NvciBDb3JlIElEOiAwCm1jZTogQ1BVIHN1cHBvcnRz
IDkgTUNFIGJhbmtzCkNQVTA6IFRoZXJtYWwgbW9uaXRvcmluZyBlbmFibGVkIChUTTEpCnVzaW5n
IG13YWl0IGluIGlkbGUgdGhyZWFkcy4KQUNQSTogQ29yZSByZXZpc2lvbiAyMDEyMDExMQpmdHJh
Y2U6IGFsbG9jYXRpbmcgMjMxNDIgZW50cmllcyBpbiA5MSBwYWdlcwouLlRJTUVSOiB2ZWN0b3I9
MHgzMCBhcGljMT0wIHBpbjE9MiBhcGljMj0tMSBwaW4yPS0xCkNQVTA6IEludGVsKFIpIENvcmUo
VE0pIGk1IENQVSAgICAgICBNIDQ2MCAgQCAyLjUzR0h6IHN0ZXBwaW5nIDA1ClBlcmZvcm1hbmNl
IEV2ZW50czogUEVCUyBmbXQxKywgV2VzdG1lcmUgZXZlbnRzLCBJbnRlbCBQTVUgZHJpdmVyLgpD
UFVJRCBtYXJrZWQgZXZlbnQ6ICdidXMgY3ljbGVzJyB1bmF2YWlsYWJsZQouLi4gdmVyc2lvbjog
ICAgICAgICAgICAgICAgMwouLi4gYml0IHdpZHRoOiAgICAgICAgICAgICAgNDgKLi4uIGdlbmVy
aWMgcmVnaXN0ZXJzOiAgICAgIDQKLi4uIHZhbHVlIG1hc2s6ICAgICAgICAgICAgIDAwMDBmZmZm
ZmZmZmZmZmYKLi4uIG1heCBwZXJpb2Q6ICAgICAgICAgICAgIDAwMDAwMDAwN2ZmZmZmZmYKLi4u
IGZpeGVkLXB1cnBvc2UgZXZlbnRzOiAgIDMKLi4uIGV2ZW50IG1hc2s6ICAgICAgICAgICAgIDAw
MDAwMDA3MDAwMDAwMGYKQm9vdGluZyBOb2RlICAgMCwgUHJvY2Vzc29ycyAgIzEKc21wYm9vdCBj
cHUgMTogc3RhcnRfaXAgPSA5ODAwMAogIzIKc21wYm9vdCBjcHUgMjogc3RhcnRfaXAgPSA5ODAw
MAogIzMgT2suCnNtcGJvb3QgY3B1IDM6IHN0YXJ0X2lwID0gOTgwMDAKQnJvdWdodCB1cCA0IENQ
VXMKVG90YWwgb2YgNCBwcm9jZXNzb3JzIGFjdGl2YXRlZCAoMjAyMTQuNDkgQm9nb01JUFMpLgpk
ZXZ0bXBmczogaW5pdGlhbGl6ZWQKUE06IFJlZ2lzdGVyaW5nIEFDUEkgTlZTIHJlZ2lvbiBhdCBi
ZjVhNzAwMCAoMjk0OTEyIGJ5dGVzKQpQTTogUmVnaXN0ZXJpbmcgQUNQSSBOVlMgcmVnaW9uIGF0
IGJmNWY5MDAwICgxMjI4OCBieXRlcykKUE06IFJlZ2lzdGVyaW5nIEFDUEkgTlZTIHJlZ2lvbiBh
dCBiZjYyMTAwMCAoMzI3NjggYnl0ZXMpClBNOiBSZWdpc3RlcmluZyBBQ1BJIE5WUyByZWdpb24g
YXQgYmY2MmMwMDAgKDIwNDgwIGJ5dGVzKQpQTTogUmVnaXN0ZXJpbmcgQUNQSSBOVlMgcmVnaW9u
IGF0IGJmNjUxMDAwICgyNzQ0MzIgYnl0ZXMpCnByaW50X2NvbnN0cmFpbnRzOiBkdW1teTogClJU
QyB0aW1lOiAyMDowMzo0MywgZGF0ZTogMDUvMzEvMTIKTkVUOiBSZWdpc3RlcmVkIHByb3RvY29s
IGZhbWlseSAxNgpBQ1BJOiBidXMgdHlwZSBwY2kgcmVnaXN0ZXJlZApQQ0k6IE1NQ09ORklHIGZv
ciBkb21haW4gMDAwMCBbYnVzIDAwLWZmXSBhdCBbbWVtIDB4ZTAwMDAwMDAtMHhlZmZmZmZmZl0g
KGJhc2UgMHhlMDAwMDAwMCkKUENJOiBNTUNPTkZJRyBhdCBbbWVtIDB4ZTAwMDAwMDAtMHhlZmZm
ZmZmZl0gcmVzZXJ2ZWQgaW4gRTgyMApQQ0k6IFVzaW5nIGNvbmZpZ3VyYXRpb24gdHlwZSAxIGZv
ciBiYXNlIGFjY2VzcwpiaW86IGNyZWF0ZSBzbGFiIDxiaW8tMD4gYXQgMApBQ1BJOiBBZGRlZCBf
T1NJKE1vZHVsZSBEZXZpY2UpCkFDUEk6IEFkZGVkIF9PU0koUHJvY2Vzc29yIERldmljZSkKQUNQ
STogQWRkZWQgX09TSSgzLjAgX1NDUCBFeHRlbnNpb25zKQpBQ1BJOiBBZGRlZCBfT1NJKFByb2Nl
c3NvciBBZ2dyZWdhdG9yIERldmljZSkKQUNQSTogRUM6IExvb2sgdXAgRUMgaW4gRFNEVApBQ1BJ
OiBFeGVjdXRlZCAxIGJsb2NrcyBvZiBtb2R1bGUtbGV2ZWwgZXhlY3V0YWJsZSBBTUwgY29kZQpb
RmlybXdhcmUgQnVnXTogQUNQSTogQklPUyBfT1NJKExpbnV4KSBxdWVyeSBpZ25vcmVkCkFDUEk6
IFNTRFQgMDAwMDAwMDBiZjYyMWMxOCAwMDNBNCAodjAxICAgIEFNSSAgICAgIElTVCAwMDAwMDAw
MSBNU0ZUIDAzMDAwMDAxKQpBQ1BJOiBEeW5hbWljIE9FTSBUYWJsZSBMb2FkOgpBQ1BJOiBTU0RU
ICAgICAgICAgICAobnVsbCkgMDAzQTQgKHYwMSAgICBBTUkgICAgICBJU1QgMDAwMDAwMDEgTVNG
VCAwMzAwMDAwMSkKQUNQSTogSW50ZXJwcmV0ZXIgZW5hYmxlZApBQ1BJOiAoc3VwcG9ydHMgUzAg
UzMgUzQgUzUpCkFDUEk6IFVzaW5nIElPQVBJQyBmb3IgaW50ZXJydXB0IHJvdXRpbmcKQUNQSTog
Tm8gZG9jayBkZXZpY2VzIGZvdW5kLgpQQ0k6IFVzaW5nIGhvc3QgYnJpZGdlIHdpbmRvd3MgZnJv
bSBBQ1BJOyBpZiBuZWNlc3NhcnksIHVzZSAicGNpPW5vY3JzIiBhbmQgcmVwb3J0IGEgYnVnCkFD
UEk6IFBDSSBSb290IEJyaWRnZSBbUENJMF0gKGRvbWFpbiAwMDAwIFtidXMgMDAtZmZdKQpwY2lf
cm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW2lvICAweDAwMDAtMHgwY2Y3XQpw
Y2lfcm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW2lvICAweDBkMDAtMHhmZmZm
XQpwY2lfcm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW21lbSAweDAwMGEwMDAw
LTB4MDAwYmZmZmZdCnBjaV9yb290IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbbWVt
IDB4YzAwMDAwMDAtMHhmZmZmZmZmZl0KUENJIGhvc3QgYnJpZGdlIHRvIGJ1cyAwMDAwOjAwCnBj
aV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW2lvICAweDAwMDAtMHgwY2Y3XQpwY2lf
YnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtpbyAgMHgwZDAwLTB4ZmZmZl0KcGNpX2J1
cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4MDAwYTAwMDAtMHgwMDBiZmZmZl0K
cGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4YzAwMDAwMDAtMHhmZmZm
ZmZmZl0KcGNpIDAwMDA6MDA6MDAuMDogWzgwODY6MDA0NF0gdHlwZSAwIGNsYXNzIDB4MDAwNjAw
CnBjaSAwMDAwOjAwOjAxLjA6IFs4MDg2OjAwNDVdIHR5cGUgMSBjbGFzcyAweDAwMDYwNApwY2kg
MDAwMDowMDowMS4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApwY2kgMDAw
MDowMDoxNi4wOiBbODA4NjozYjY0XSB0eXBlIDAgY2xhc3MgMHgwMDA3ODAKcGNpIDAwMDA6MDA6
MTYuMDogcmVnIDEwOiBbbWVtIDB4ZmJmMDkwMDAtMHhmYmYwOTAwZiA2NGJpdF0KcGNpIDAwMDA6
MDA6MTYuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKcGNpIDAwMDA6MDA6
MWEuMDogWzgwODY6M2IzY10gdHlwZSAwIGNsYXNzIDB4MDAwYzAzCnBjaSAwMDAwOjAwOjFhLjA6
IHJlZyAxMDogW21lbSAweGZiZjA4MDAwLTB4ZmJmMDgzZmZdCnBjaSAwMDAwOjAwOjFhLjA6IFBN
RSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkCnBjaSAwMDAwOjAwOjFiLjA6IFs4MDg2
OjNiNTZdIHR5cGUgMCBjbGFzcyAweDAwMDQwMwpwY2kgMDAwMDowMDoxYi4wOiByZWcgMTA6IFtt
ZW0gMHhmYmYwMDAwMC0weGZiZjAzZmZmIDY0Yml0XQpwY2kgMDAwMDowMDoxYi4wOiBQTUUjIHN1
cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApwY2kgMDAwMDowMDoxYy4wOiBbODA4NjozYjQy
XSB0eXBlIDEgY2xhc3MgMHgwMDA2MDQKcGNpIDAwMDA6MDA6MWMuMDogUE1FIyBzdXBwb3J0ZWQg
ZnJvbSBEMCBEM2hvdCBEM2NvbGQKcGNpIDAwMDA6MDA6MWMuMTogWzgwODY6M2I0NF0gdHlwZSAx
IGNsYXNzIDB4MDAwNjA0CnBjaSAwMDAwOjAwOjFjLjE6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAg
RDNob3QgRDNjb2xkCnBjaSAwMDAwOjAwOjFjLjI6IFs4MDg2OjNiNDZdIHR5cGUgMSBjbGFzcyAw
eDAwMDYwNApwY2kgMDAwMDowMDoxYy4yOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQz
Y29sZApwY2kgMDAwMDowMDoxYy40OiBbODA4NjozYjRhXSB0eXBlIDEgY2xhc3MgMHgwMDA2MDQK
cGNpIDAwMDA6MDA6MWMuNDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKcGNp
IDAwMDA6MDA6MWQuMDogWzgwODY6M2IzNF0gdHlwZSAwIGNsYXNzIDB4MDAwYzAzCnBjaSAwMDAw
OjAwOjFkLjA6IHJlZyAxMDogW21lbSAweGZiZjA3MDAwLTB4ZmJmMDczZmZdCnBjaSAwMDAwOjAw
OjFkLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkCnBjaSAwMDAwOjAwOjFl
LjA6IFs4MDg2OjI0NDhdIHR5cGUgMSBjbGFzcyAweDAwMDYwNApwY2kgMDAwMDowMDoxZi4wOiBb
ODA4NjozYjBiXSB0eXBlIDAgY2xhc3MgMHgwMDA2MDEKcGNpIDAwMDA6MDA6MWYuMjogWzgwODY6
M2IyZl0gdHlwZSAwIGNsYXNzIDB4MDAwMTA2CnBjaSAwMDAwOjAwOjFmLjI6IHJlZyAxMDogW2lv
ICAweGYwNzAtMHhmMDc3XQpwY2kgMDAwMDowMDoxZi4yOiByZWcgMTQ6IFtpbyAgMHhmMDYwLTB4
ZjA2M10KcGNpIDAwMDA6MDA6MWYuMjogcmVnIDE4OiBbaW8gIDB4ZjA1MC0weGYwNTddCnBjaSAw
MDAwOjAwOjFmLjI6IHJlZyAxYzogW2lvICAweGYwNDAtMHhmMDQzXQpwY2kgMDAwMDowMDoxZi4y
OiByZWcgMjA6IFtpbyAgMHhmMDIwLTB4ZjAzZl0KcGNpIDAwMDA6MDA6MWYuMjogcmVnIDI0OiBb
bWVtIDB4ZmJmMDYwMDAtMHhmYmYwNjdmZl0KcGNpIDAwMDA6MDA6MWYuMjogUE1FIyBzdXBwb3J0
ZWQgZnJvbSBEM2hvdApwY2kgMDAwMDowMDoxZi4zOiBbODA4NjozYjMwXSB0eXBlIDAgY2xhc3Mg
MHgwMDBjMDUKcGNpIDAwMDA6MDA6MWYuMzogcmVnIDEwOiBbbWVtIDB4ZmJmMDUwMDAtMHhmYmYw
NTBmZiA2NGJpdF0KcGNpIDAwMDA6MDA6MWYuMzogcmVnIDIwOiBbaW8gIDB4ZjAwMC0weGYwMWZd
CnBjaSAwMDAwOjAwOjFmLjY6IFs4MDg2OjNiMzJdIHR5cGUgMCBjbGFzcyAweDAwMTE4MApwY2kg
MDAwMDowMDoxZi42OiByZWcgMTA6IFttZW0gMHhmYmYwNDAwMC0weGZiZjA0ZmZmIDY0Yml0XQpw
Y2kgMDAwMDowMTowMC4wOiBbMTAwMjo2OGMxXSB0eXBlIDAgY2xhc3MgMHgwMDAzMDAKcGNpIDAw
MDA6MDE6MDAuMDogcmVnIDEwOiBbbWVtIDB4YzAwMDAwMDAtMHhjZmZmZmZmZiA2NGJpdCBwcmVm
XQpwY2kgMDAwMDowMTowMC4wOiByZWcgMTg6IFttZW0gMHhmYmUyMDAwMC0weGZiZTNmZmZmIDY0
Yml0XQpwY2kgMDAwMDowMTowMC4wOiByZWcgMjA6IFtpbyAgMHhlMDAwLTB4ZTBmZl0KcGNpIDAw
MDA6MDE6MDAuMDogcmVnIDMwOiBbbWVtIDB4ZmJlMDAwMDAtMHhmYmUxZmZmZiBwcmVmXQpwY2kg
MDAwMDowMTowMC4wOiBzdXBwb3J0cyBEMSBEMgpwY2kgMDAwMDowMTowMC4xOiBbMTAwMjphYTYw
XSB0eXBlIDAgY2xhc3MgMHgwMDA0MDMKcGNpIDAwMDA6MDE6MDAuMTogcmVnIDEwOiBbbWVtIDB4
ZmJlNDAwMDAtMHhmYmU0M2ZmZiA2NGJpdF0KcGNpIDAwMDA6MDE6MDAuMTogc3VwcG9ydHMgRDEg
RDIKcGNpIDAwMDA6MDA6MDEuMDogUENJIGJyaWRnZSB0byBbYnVzIDAxLTAxXQpwY2kgMDAwMDow
MDowMS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGUwMDAtMHhlZmZmXQpwY2kgMDAwMDowMDow
MS4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZiZTAwMDAwLTB4ZmJlZmZmZmZdCnBjaSAwMDAw
OjAwOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4YzAwMDAwMDAtMHhjZmZmZmZmZiA2NGJp
dCBwcmVmXQpwY2kgMDAwMDowMDoxYy4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMTEtMTFdCnBjaSAw
MDAwOjEyOjAwLjA6IFs4MDg2OjAwODNdIHR5cGUgMCBjbGFzcyAweDAwMDI4MApwY2kgMDAwMDox
MjowMC4wOiByZWcgMTA6IFttZW0gMHhmYmQwMDAwMC0weGZiZDAxZmZmIDY0Yml0XQpwY2kgMDAw
MDoxMjowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApwY2kgMDAwMDow
MDoxYy4xOiBQQ0kgYnJpZGdlIHRvIFtidXMgMTItMTJdCnBjaSAwMDAwOjAwOjFjLjE6ICAgYnJp
ZGdlIHdpbmRvdyBbbWVtIDB4ZmJkMDAwMDAtMHhmYmRmZmZmZl0KcGNpIDAwMDA6MTM6MDAuMDog
WzEwZWM6ODEzNl0gdHlwZSAwIGNsYXNzIDB4MDAwMjAwCnBjaSAwMDAwOjEzOjAwLjA6IHJlZyAx
MDogW2lvICAweGQwMDAtMHhkMGZmXQpwY2kgMDAwMDoxMzowMC4wOiByZWcgMTg6IFttZW0gMHhk
MGMxMDAwMC0weGQwYzEwZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjEzOjAwLjA6IHJlZyAyMDog
W21lbSAweGQwYzAwMDAwLTB4ZDBjMGZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MTM6MDAuMDog
cmVnIDMwOiBbbWVtIDB4ZmIzMDAwMDAtMHhmYjMxZmZmZiBwcmVmXQpwY2kgMDAwMDoxMzowMC4w
OiBzdXBwb3J0cyBEMSBEMgpwY2kgMDAwMDoxMzowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQw
IEQxIEQyIEQzaG90IEQzY29sZApwY2kgMDAwMDowMDoxYy4yOiBQQ0kgYnJpZGdlIHRvIFtidXMg
MTMtMTNdCnBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4ZDAwMC0weGRm
ZmZdCnBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmIzMDAwMDAtMHhm
YmNmZmZmZl0KcGNpIDAwMDA6MDA6MWMuMjogICBicmlkZ2Ugd2luZG93IFttZW0gMHhkMGMwMDAw
MC0weGQxNWZmZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjAwOjFjLjQ6IFBDSSBicmlkZ2UgdG8g
W2J1cyAxNS0xNV0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhjMDAw
LTB4Y2ZmZl0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYTkwMDAw
MC0weGZiMmZmZmZmXQpwY2kgMDAwMDowMDoxYy40OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGQw
MTAwMDAwLTB4ZDBhZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWUuMDogUENJIGJyaWRn
ZSB0byBbYnVzIDIwLTIwXSAoc3VidHJhY3RpdmUgZGVjb2RlKQpwY2kgMDAwMDowMDoxZS4wOiAg
IGJyaWRnZSB3aW5kb3cgW2lvICAweDAwMDAtMHgwY2Y3XSAoc3VidHJhY3RpdmUgZGVjb2RlKQpw
Y2kgMDAwMDowMDoxZS4wOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDBkMDAtMHhmZmZmXSAoc3Vi
dHJhY3RpdmUgZGVjb2RlKQpwY2kgMDAwMDowMDoxZS4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAw
eDAwMGEwMDAwLTB4MDAwYmZmZmZdIChzdWJ0cmFjdGl2ZSBkZWNvZGUpCnBjaSAwMDAwOjAwOjFl
LjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4YzAwMDAwMDAtMHhmZmZmZmZmZl0gKHN1YnRyYWN0
aXZlIGRlY29kZSkKQUNQSTogUENJIEludGVycnVwdCBSb3V0aW5nIFRhYmxlIFtcX1NCXy5QQ0kw
Ll9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJMC5CUjIw
Ll9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJMC5QRVgw
Ll9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJMC5QRVgx
Ll9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJMC5QRVgy
Ll9QUlRdCkFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJMC5QRVg0
Ll9QUlRdCiBwY2kwMDAwOjAwOiBSZXF1ZXN0aW5nIEFDUEkgX09TQyBjb250cm9sICgweDFkKQog
cGNpMDAwMDowMDogQUNQSSBfT1NDIGNvbnRyb2wgKDB4MTkpIGdyYW50ZWQKQUNQSTogUENJIElu
dGVycnVwdCBMaW5rIFtMTktBXSAoSVJRcyAzIDQgNSA2IDcgMTAgKjExIDEyIDE0IDE1KQpBQ1BJ
OiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0JdIChJUlFzIDMgNCA1IDYgNyAqMTAgMTEgMTIgMTQg
MTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQ10gKElSUXMgKjMgNCA1IDYgMTAgMTEg
MTIgMTQgMTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRF0gKElSUXMgMyAqNCA1IDYg
MTAgMTEgMTIgMTQgMTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRV0gKElSUXMgMyA0
IDUgNiA3IDEwIDExIDEyIDE0IDE1KSAqMApBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0Zd
IChJUlFzIDMgNCA1IDYgNyAxMCAxMSAxMiAxNCAxNSkgKjAKQUNQSTogUENJIEludGVycnVwdCBM
aW5rIFtMTktHXSAoSVJRcyAzIDQgKjUgNiA3IDEwIDExIDEyIDE0IDE1KQpBQ1BJOiBQQ0kgSW50
ZXJydXB0IExpbmsgW0xOS0hdIChJUlFzIDMgNCA1IDYgKjcgMTAgMTEgMTIgMTQgMTUpCnZnYWFy
YjogZGV2aWNlIGFkZGVkOiBQQ0k6MDAwMDowMTowMC4wLGRlY29kZXM9aW8rbWVtLG93bnM9aW8r
bWVtLGxvY2tzPW5vbmUKdmdhYXJiOiBsb2FkZWQKdmdhYXJiOiBicmlkZ2UgY29udHJvbCBwb3Nz
aWJsZSAwMDAwOjAxOjAwLjAKU0NTSSBzdWJzeXN0ZW0gaW5pdGlhbGl6ZWQKbGliYXRhIHZlcnNp
b24gMy4wMCBsb2FkZWQuCnVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIg
dXNiZnMKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBodWIKdXNiY29y
ZTogcmVnaXN0ZXJlZCBuZXcgZGV2aWNlIGRyaXZlciB1c2IKd21pOiBNYXBwZXIgbG9hZGVkClBD
STogVXNpbmcgQUNQSSBmb3IgSVJRIHJvdXRpbmcKUENJOiBEaXNjb3ZlcmVkIHBlZXIgYnVzIGZm
ClBDSTogcm9vdCBidXMgZmY6IHVzaW5nIGRlZmF1bHQgcmVzb3VyY2VzClBDSSBob3N0IGJyaWRn
ZSB0byBidXMgMDAwMDpmZgpwY2lfYnVzIDAwMDA6ZmY6IHJvb3QgYnVzIHJlc291cmNlIFtpbyAg
MHgwMDAwLTB4ZmZmZl0KcGNpX2J1cyAwMDAwOmZmOiByb290IGJ1cyByZXNvdXJjZSBbbWVtIDB4
MDAwMDAwMDAtMHhmZmZmZmZmZmZdCnBjaSAwMDAwOmZmOjAwLjA6IFs4MDg2OjJjNjJdIHR5cGUg
MCBjbGFzcyAweDAwMDYwMApwY2kgMDAwMDpmZjowMC4xOiBbODA4NjoyZDAxXSB0eXBlIDAgY2xh
c3MgMHgwMDA2MDAKcGNpIDAwMDA6ZmY6MDIuMDogWzgwODY6MmQxMF0gdHlwZSAwIGNsYXNzIDB4
MDAwNjAwCnBjaSAwMDAwOmZmOjAyLjE6IFs4MDg2OjJkMTFdIHR5cGUgMCBjbGFzcyAweDAwMDYw
MApwY2kgMDAwMDpmZjowMi4yOiBbODA4NjoyZDEyXSB0eXBlIDAgY2xhc3MgMHgwMDA2MDAKcGNp
IDAwMDA6ZmY6MDIuMzogWzgwODY6MmQxM10gdHlwZSAwIGNsYXNzIDB4MDAwNjAwClBDSTogcGNp
X2NhY2hlX2xpbmVfc2l6ZSBzZXQgdG8gNjQgYnl0ZXMKcmVzZXJ2ZSBSQU0gYnVmZmVyOiAwMDAw
MDAwMDAwMDlkNDAwIC0gMDAwMDAwMDAwMDA5ZmZmZiAKcmVzZXJ2ZSBSQU0gYnVmZmVyOiAwMDAw
MDAwMGJmNWE3MDAwIC0gMDAwMDAwMDBiZmZmZmZmZiAKcmVzZXJ2ZSBSQU0gYnVmZmVyOiAwMDAw
MDAwMGJmNjIxMDAwIC0gMDAwMDAwMDBiZmZmZmZmZiAKcmVzZXJ2ZSBSQU0gYnVmZmVyOiAwMDAw
MDAwMGJmODAwMDAwIC0gMDAwMDAwMDBiZmZmZmZmZiAKTmV0TGFiZWw6IEluaXRpYWxpemluZwpO
ZXRMYWJlbDogIGRvbWFpbiBoYXNoIHNpemUgPSAxMjgKTmV0TGFiZWw6ICBwcm90b2NvbHMgPSBV
TkxBQkVMRUQgQ0lQU092NApOZXRMYWJlbDogIHVubGFiZWxlZCB0cmFmZmljIGFsbG93ZWQgYnkg
ZGVmYXVsdApocGV0MDogYXQgTU1JTyAweGZlZDAwMDAwLCBJUlFzIDIsIDgsIDAsIDAsIDAsIDAs
IDAsIDAKaHBldDA6IDggY29tcGFyYXRvcnMsIDY0LWJpdCAxNC4zMTgxODAgTUh6IGNvdW50ZXIK
U3dpdGNoaW5nIHRvIGNsb2Nrc291cmNlIGhwZXQKQXBwQXJtb3I6IEFwcEFybW9yIEZpbGVzeXN0
ZW0gRW5hYmxlZApwbnA6IFBuUCBBQ1BJIGluaXQKQUNQSTogYnVzIHR5cGUgcG5wIHJlZ2lzdGVy
ZWQKcG5wIDAwOjAwOiBbYnVzIDAwLWZmXQpwbnAgMDA6MDA6IFtpbyAgMHgwY2Y4LTB4MGNmZl0K
cG5wIDAwOjAwOiBbaW8gIDB4MDAwMC0weDBjZjcgd2luZG93XQpwbnAgMDA6MDA6IFtpbyAgMHgw
ZDAwLTB4ZmZmZiB3aW5kb3ddCnBucCAwMDowMDogW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmYg
d2luZG93XQpwbnAgMDA6MDA6IFttZW0gMHgwMDAwMDAwMCB3aW5kb3ddCnBucCAwMDowMDogW21l
bSAweGMwMDAwMDAwLTB4ZmZmZmZmZmYgd2luZG93XQpwbnAgMDA6MDA6IFBsdWcgYW5kIFBsYXkg
QUNQSSBkZXZpY2UsIElEcyBQTlAwYTA4IFBOUDBhMDMgKGFjdGl2ZSkKcG5wIDAwOjAxOiBbbWVt
IDB4ZmVkMTQwMDAtMHhmZWQxOWZmZl0KcG5wIDAwOjAxOiBbbWVtIDB4ZTAwMDAwMDAtMHhlZmZm
ZmZmZl0KcG5wIDAwOjAxOiBbbWVtIDB4ZmVkOTAwMDAtMHhmZWQ5M2ZmZl0KcG5wIDAwOjAxOiBb
bWVtIDB4ZmVkMjAwMDAtMHhmZWQzZmZmZl0KcG5wIDAwOjAxOiBbbWVtIDB4ZmVlMDAwMDAtMHhm
ZWUwZmZmZl0Kc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZmVkMTQwMDAtMHhmZWQxOWZmZl0gaGFzIGJl
ZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZTAwMDAwMDAtMHhlZmZmZmZmZl0gaGFz
IGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZmVkOTAwMDAtMHhmZWQ5M2ZmZl0g
aGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZmVkMjAwMDAtMHhmZWQzZmZm
Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBbbWVtIDB4ZmVlMDAwMDAtMHhmZWUw
ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVtIDAwOjAxOiBQbHVnIGFuZCBQbGF5IEFDUEkg
ZGV2aWNlLCBJRHMgUE5QMGMwMSAoYWN0aXZlKQpwbnAgMDA6MDI6IFtkbWEgNF0KcG5wIDAwOjAy
OiBbaW8gIDB4MDAwMC0weDAwMGZdCnBucCAwMDowMjogW2lvICAweDAwODEtMHgwMDgzXQpwbnAg
MDA6MDI6IFtpbyAgMHgwMDg3XQpwbnAgMDA6MDI6IFtpbyAgMHgwMDg5LTB4MDA4Yl0KcG5wIDAw
OjAyOiBbaW8gIDB4MDA4Zl0KcG5wIDAwOjAyOiBbaW8gIDB4MDBjMC0weDAwZGZdCnBucCAwMDow
MjogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDAyMDAgKGFjdGl2ZSkKcG5wIDAw
OjAzOiBbaW8gIDB4MDA3MC0weDAwNzFdCnBucCAwMDowMzogW2lycSA4XQpwbnAgMDA6MDM6IFBs
dWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYjAwIChhY3RpdmUpCnBucCAwMDowNDog
W2lvICAweDAwNjFdCnBucCAwMDowNDogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBO
UDA4MDAgKGFjdGl2ZSkKcG5wIDAwOjA1OiBbaW8gIDB4MDBmMC0weDAwZmZdCnBucCAwMDowNTog
W2lycSAxM10KcG5wIDAwOjA1OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMGMw
NCAoYWN0aXZlKQpwbnAgMDA6MDY6IFtpbyAgMHgwMDEwLTB4MDAxZl0KcG5wIDAwOjA2OiBbaW8g
IDB4MDAyMi0weDAwM2ZdCnBucCAwMDowNjogW2lvICAweDAwNDQtMHgwMDVmXQpwbnAgMDA6MDY6
IFtpbyAgMHgwMDY4LTB4MDA2Zl0KcG5wIDAwOjA2OiBbaW8gIDB4MDA3Mi0weDAwN2ZdCnBucCAw
MDowNjogW2lvICAweDAwODBdCnBucCAwMDowNjogW2lvICAweDAwODQtMHgwMDg2XQpwbnAgMDA6
MDY6IFtpbyAgMHgwMDg4XQpwbnAgMDA6MDY6IFtpbyAgMHgwMDhjLTB4MDA4ZV0KcG5wIDAwOjA2
OiBbaW8gIDB4MDA5MC0weDAwOWZdCnBucCAwMDowNjogW2lvICAweDAwYTItMHgwMGJmXQpwbnAg
MDA6MDY6IFtpbyAgMHgwMGUwLTB4MDBlZl0KcG5wIDAwOjA2OiBbaW8gIDB4MDRkMC0weDA0ZDFd
CnBucCAwMDowNjogW21lbSAweGZlODAwMDAwLTB4ZmU4MDAxZmZdCnN5c3RlbSAwMDowNjogW2lv
ICAweDA0ZDAtMHgwNGQxXSBoYXMgYmVlbiByZXNlcnZlZApzeXN0ZW0gMDA6MDY6IFttZW0gMHhm
ZTgwMDAwMC0weGZlODAwMWZmXSBoYXMgYmVlbiByZXNlcnZlZApzeXN0ZW0gMDA6MDY6IFBsdWcg
YW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChhY3RpdmUpCnBucCAwMDowNzogW2ly
cSAxMl0KcG5wIDAwOjA3OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgRExMMDQ0NyBT
WU4wNjAwIFNZTjAwMDIgUE5QMGYxMyAoYWN0aXZlKQpwbnAgMDA6MDg6IFtpbyAgMHgwMDYwXQpw
bnAgMDA6MDg6IFtpbyAgMHgwMDY0XQpwbnAgMDA6MDg6IFtpbyAgMHgwMDYyXQpwbnAgMDA6MDg6
IFtpbyAgMHgwMDY2XQpwbnAgMDA6MDg6IFtpcnEgMV0KcG5wIDAwOjA4OiBQbHVnIGFuZCBQbGF5
IEFDUEkgZGV2aWNlLCBJRHMgUE5QMDMwMyAoYWN0aXZlKQpwbnAgMDA6MDk6IFtpbyAgMHgwNDAw
LTB4MDQ3Zl0KcG5wIDAwOjA5OiBbaW8gIDB4MTE4MC0weDExOWZdCnBucCAwMDowOTogW2lvICAw
eDA1MDAtMHgwNTdmXQpwbnAgMDA6MDk6IFttZW0gMHhmZWQxYzAwMC0weGZlZDFmZmZmXQpwbnAg
MDA6MDk6IFttZW0gMHhmZWMwMDAwMC0weGZlY2ZmZmZmXQpwbnAgMDA6MDk6IFttZW0gMHhmZWQw
ODAwMC0weGZlZDA4ZmZmXQpwbnAgMDA6MDk6IFttZW0gMHhmZjAwMDAwMC0weGZmZmZmZmZmXQpz
eXN0ZW0gMDA6MDk6IFtpbyAgMHgwNDAwLTB4MDQ3Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lzdGVt
IDAwOjA5OiBbaW8gIDB4MTE4MC0weDExOWZdIGhhcyBiZWVuIHJlc2VydmVkCnN5c3RlbSAwMDow
OTogW2lvICAweDA1MDAtMHgwNTdmXSBoYXMgYmVlbiByZXNlcnZlZApzeXN0ZW0gMDA6MDk6IFtt
ZW0gMHhmZWQxYzAwMC0weGZlZDFmZmZmXSBoYXMgYmVlbiByZXNlcnZlZApzeXN0ZW0gMDA6MDk6
IFttZW0gMHhmZWMwMDAwMC0weGZlY2ZmZmZmXSBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQKc3lzdGVt
IDAwOjA5OiBbbWVtIDB4ZmVkMDgwMDAtMHhmZWQwOGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKc3lz
dGVtIDAwOjA5OiBbbWVtIDB4ZmYwMDAwMDAtMHhmZmZmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQK
c3lzdGVtIDAwOjA5OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMGMwMSAoYWN0
aXZlKQpwbnAgMDA6MGE6IFttZW0gMHhmZWQwMDAwMC0weGZlZDAwM2ZmXQpwbnAgMDA6MGE6IFBs
dWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwMTAzIChhY3RpdmUpCnBucDogUG5QIEFD
UEk6IGZvdW5kIDExIGRldmljZXMKQUNQSTogQUNQSSBidXMgdHlwZSBwbnAgdW5yZWdpc3RlcmVk
ClBDSTogbWF4IGJ1cyBkZXB0aDogMSBwY2lfdHJ5X251bTogMgpwY2kgMDAwMDowMDoxYy4xOiBC
QVIgMTU6IGFzc2lnbmVkIFttZW0gMHhkMTYwMDAwMC0weGQxN2ZmZmZmIDY0Yml0IHByZWZdCnBj
aSAwMDAwOjAwOjFjLjE6IEJBUiAxMzogYXNzaWduZWQgW2lvICAweDIwMDAtMHgyZmZmXQpwY2kg
MDAwMDowMDoxYy4wOiBCQVIgMTQ6IGFzc2lnbmVkIFttZW0gMHhkMTgwMDAwMC0weGQxOWZmZmZm
XQpwY2kgMDAwMDowMDoxYy4wOiBCQVIgMTU6IGFzc2lnbmVkIFttZW0gMHhkMWEwMDAwMC0weGQx
YmZmZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjAwOjFjLjA6IEJBUiAxMzogYXNzaWduZWQgW2lv
ICAweDMwMDAtMHgzZmZmXQpwY2kgMDAwMDowMDowMS4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDEt
MDFdCnBjaSAwMDAwOjAwOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4ZTAwMC0weGVmZmZd
CnBjaSAwMDAwOjAwOjAxLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmJlMDAwMDAtMHhmYmVm
ZmZmZl0KcGNpIDAwMDA6MDA6MDEuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhjMDAwMDAwMC0w
eGNmZmZmZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjAwOjFjLjA6IFBDSSBicmlkZ2UgdG8gW2J1
cyAxMS0xMV0KcGNpIDAwMDA6MDA6MWMuMDogICBicmlkZ2Ugd2luZG93IFtpbyAgMHgzMDAwLTB4
M2ZmZl0KcGNpIDAwMDA6MDA6MWMuMDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhkMTgwMDAwMC0w
eGQxOWZmZmZmXQpwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGQxYTAw
MDAwLTB4ZDFiZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWMuMTogUENJIGJyaWRnZSB0
byBbYnVzIDEyLTEyXQpwY2kgMDAwMDowMDoxYy4xOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDIw
MDAtMHgyZmZmXQpwY2kgMDAwMDowMDoxYy4xOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZiZDAw
MDAwLTB4ZmJkZmZmZmZdCnBjaSAwMDAwOjAwOjFjLjE6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4
ZDE2MDAwMDAtMHhkMTdmZmZmZiA2NGJpdCBwcmVmXQpwY2kgMDAwMDowMDoxYy4yOiBQQ0kgYnJp
ZGdlIHRvIFtidXMgMTMtMTNdCnBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbaW8g
IDB4ZDAwMC0weGRmZmZdCnBjaSAwMDAwOjAwOjFjLjI6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4
ZmIzMDAwMDAtMHhmYmNmZmZmZl0KcGNpIDAwMDA6MDA6MWMuMjogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhkMGMwMDAwMC0weGQxNWZmZmZmIDY0Yml0IHByZWZdCnBjaSAwMDAwOjAwOjFjLjQ6IFBD
SSBicmlkZ2UgdG8gW2J1cyAxNS0xNV0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93
IFtpbyAgMHhjMDAwLTB4Y2ZmZl0KcGNpIDAwMDA6MDA6MWMuNDogICBicmlkZ2Ugd2luZG93IFtt
ZW0gMHhmYTkwMDAwMC0weGZiMmZmZmZmXQpwY2kgMDAwMDowMDoxYy40OiAgIGJyaWRnZSB3aW5k
b3cgW21lbSAweGQwMTAwMDAwLTB4ZDBhZmZmZmYgNjRiaXQgcHJlZl0KcGNpIDAwMDA6MDA6MWUu
MDogUENJIGJyaWRnZSB0byBbYnVzIDIwLTIwXQpwY2kgMDAwMDowMDoxZS4wOiBzZXR0aW5nIGxh
dGVuY3kgdGltZXIgdG8gNjQKcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA0IFtpbyAgMHgwMDAw
LTB4MGNmN10KcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA1IFtpbyAgMHgwZDAwLTB4ZmZmZl0K
cGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA2IFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmXQpw
Y2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDcgW21lbSAweGMwMDAwMDAwLTB4ZmZmZmZmZmZdCnBj
aV9idXMgMDAwMDowMTogcmVzb3VyY2UgMCBbaW8gIDB4ZTAwMC0weGVmZmZdCnBjaV9idXMgMDAw
MDowMTogcmVzb3VyY2UgMSBbbWVtIDB4ZmJlMDAwMDAtMHhmYmVmZmZmZl0KcGNpX2J1cyAwMDAw
OjAxOiByZXNvdXJjZSAyIFttZW0gMHhjMDAwMDAwMC0weGNmZmZmZmZmIDY0Yml0IHByZWZdCnBj
aV9idXMgMDAwMDoxMTogcmVzb3VyY2UgMCBbaW8gIDB4MzAwMC0weDNmZmZdCnBjaV9idXMgMDAw
MDoxMTogcmVzb3VyY2UgMSBbbWVtIDB4ZDE4MDAwMDAtMHhkMTlmZmZmZl0KcGNpX2J1cyAwMDAw
OjExOiByZXNvdXJjZSAyIFttZW0gMHhkMWEwMDAwMC0weGQxYmZmZmZmIDY0Yml0IHByZWZdCnBj
aV9idXMgMDAwMDoxMjogcmVzb3VyY2UgMCBbaW8gIDB4MjAwMC0weDJmZmZdCnBjaV9idXMgMDAw
MDoxMjogcmVzb3VyY2UgMSBbbWVtIDB4ZmJkMDAwMDAtMHhmYmRmZmZmZl0KcGNpX2J1cyAwMDAw
OjEyOiByZXNvdXJjZSAyIFttZW0gMHhkMTYwMDAwMC0weGQxN2ZmZmZmIDY0Yml0IHByZWZdCnBj
aV9idXMgMDAwMDoxMzogcmVzb3VyY2UgMCBbaW8gIDB4ZDAwMC0weGRmZmZdCnBjaV9idXMgMDAw
MDoxMzogcmVzb3VyY2UgMSBbbWVtIDB4ZmIzMDAwMDAtMHhmYmNmZmZmZl0KcGNpX2J1cyAwMDAw
OjEzOiByZXNvdXJjZSAyIFttZW0gMHhkMGMwMDAwMC0weGQxNWZmZmZmIDY0Yml0IHByZWZdCnBj
aV9idXMgMDAwMDoxNTogcmVzb3VyY2UgMCBbaW8gIDB4YzAwMC0weGNmZmZdCnBjaV9idXMgMDAw
MDoxNTogcmVzb3VyY2UgMSBbbWVtIDB4ZmE5MDAwMDAtMHhmYjJmZmZmZl0KcGNpX2J1cyAwMDAw
OjE1OiByZXNvdXJjZSAyIFttZW0gMHhkMDEwMDAwMC0weGQwYWZmZmZmIDY0Yml0IHByZWZdCnBj
aV9idXMgMDAwMDoyMDogcmVzb3VyY2UgNCBbaW8gIDB4MDAwMC0weDBjZjddCnBjaV9idXMgMDAw
MDoyMDogcmVzb3VyY2UgNSBbaW8gIDB4MGQwMC0weGZmZmZdCnBjaV9idXMgMDAwMDoyMDogcmVz
b3VyY2UgNiBbbWVtIDB4MDAwYTAwMDAtMHgwMDBiZmZmZl0KcGNpX2J1cyAwMDAwOjIwOiByZXNv
dXJjZSA3IFttZW0gMHhjMDAwMDAwMC0weGZmZmZmZmZmXQpwY2lfYnVzIDAwMDA6ZmY6IHJlc291
cmNlIDQgW2lvICAweDAwMDAtMHhmZmZmXQpwY2lfYnVzIDAwMDA6ZmY6IHJlc291cmNlIDUgW21l
bSAweDAwMDAwMDAwLTB4ZmZmZmZmZmZmXQpORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5
IDIKSVAgcm91dGUgY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAxMzEwNzIgKG9yZGVyOiA4LCAx
MDQ4NTc2IGJ5dGVzKQpUQ1AgZXN0YWJsaXNoZWQgaGFzaCB0YWJsZSBlbnRyaWVzOiA1MjQyODgg
KG9yZGVyOiAxMSwgODM4ODYwOCBieXRlcykKVENQIGJpbmQgaGFzaCB0YWJsZSBlbnRyaWVzOiA2
NTUzNiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMpClRDUDogSGFzaCB0YWJsZXMgY29uZmlndXJl
ZCAoZXN0YWJsaXNoZWQgNTI0Mjg4IGJpbmQgNjU1MzYpClRDUCByZW5vIHJlZ2lzdGVyZWQKVURQ
IGhhc2ggdGFibGUgZW50cmllczogMjA0OCAob3JkZXI6IDQsIDY1NTM2IGJ5dGVzKQpVRFAtTGl0
ZSBoYXNoIHRhYmxlIGVudHJpZXM6IDIwNDggKG9yZGVyOiA0LCA2NTUzNiBieXRlcykKTkVUOiBS
ZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxCnBjaSAwMDAwOjAxOjAwLjA6IEJvb3QgdmlkZW8g
ZGV2aWNlClBDSTogQ0xTIDY0IGJ5dGVzLCBkZWZhdWx0IDY0ClRyeWluZyB0byB1bnBhY2sgcm9v
dGZzIGltYWdlIGFzIGluaXRyYW1mcy4uLgpGcmVlaW5nIGluaXRyZCBtZW1vcnk6IDE1MDg4OGsg
ZnJlZWQKUENJLURNQTogVXNpbmcgc29mdHdhcmUgYm91bmNlIGJ1ZmZlcmluZyBmb3IgSU8gKFNX
SU9UTEIpClBsYWNpbmcgNjRNQiBzb2Z0d2FyZSBJTyBUTEIgYmV0d2VlbiBmZmZmODgwMGJiNWE3
MDAwIC0gZmZmZjg4MDBiZjVhNzAwMApzb2Z0d2FyZSBJTyBUTEIgYXQgcGh5cyAweGJiNWE3MDAw
IC0gMHhiZjVhNzAwMAphdWRpdDogaW5pdGlhbGl6aW5nIG5ldGxpbmsgc29ja2V0IChkaXNhYmxl
ZCkKdHlwZT0yMDAwIGF1ZGl0KDEzMzg0OTQ2MjUuMzcwOjEpOiBpbml0aWFsaXplZApIdWdlVExC
IHJlZ2lzdGVyZWQgMiBNQiBwYWdlIHNpemUsIHByZS1hbGxvY2F0ZWQgMCBwYWdlcwpWRlM6IERp
c2sgcXVvdGFzIGRxdW90XzYuNS4yCkRxdW90LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNTEy
IChvcmRlciAwLCA0MDk2IGJ5dGVzKQpmdXNlIGluaXQgKEFQSSB2ZXJzaW9uIDcuMTgpCm1zZ21u
aSBoYXMgYmVlbiBzZXQgdG8gNzM3NwpCbG9jayBsYXllciBTQ1NJIGdlbmVyaWMgKGJzZykgZHJp
dmVyIHZlcnNpb24gMC40IGxvYWRlZCAobWFqb3IgMjUzKQppbyBzY2hlZHVsZXIgbm9vcCByZWdp
c3RlcmVkCmlvIHNjaGVkdWxlciBkZWFkbGluZSByZWdpc3RlcmVkCmlvIHNjaGVkdWxlciBjZnEg
cmVnaXN0ZXJlZCAoZGVmYXVsdCkKcGNpZXBvcnQgMDAwMDowMDowMS4wOiBpcnEgNDAgZm9yIE1T
SS9NU0ktWApwY2llcG9ydCAwMDAwOjAwOjFjLjA6IGlycSA0MSBmb3IgTVNJL01TSS1YCnBjaWVw
b3J0IDAwMDA6MDA6MWMuMTogaXJxIDQyIGZvciBNU0kvTVNJLVgKcGNpZXBvcnQgMDAwMDowMDox
Yy4yOiBpcnEgNDMgZm9yIE1TSS9NU0ktWApwY2llcG9ydCAwMDAwOjAwOjFjLjQ6IGlycSA0NCBm
b3IgTVNJL01TSS1YCnBjaV9ob3RwbHVnOiBQQ0kgSG90IFBsdWcgUENJIENvcmUgdmVyc2lvbjog
MC41CnBjaWVocDogVXNpbmcgQUNQSSBmb3Igc2xvdCBkZXRlY3Rpb24uCnBjaWVocCAwMDAwOjAw
OjFjLjQ6cGNpZTA0OiBIUEMgdmVuZG9yX2lkIDgwODYgZGV2aWNlX2lkIDNiNGEgc3NfdmlkIDEw
Mjggc3NfZGlkIDQ0NwpwY2llaHAgMDAwMDowMDoxYy40OnBjaWUwNDogc2VydmljZSBkcml2ZXIg
cGNpZWhwIGxvYWRlZApwY2llaHA6IFBDSSBFeHByZXNzIEhvdCBQbHVnIENvbnRyb2xsZXIgRHJp
dmVyIHZlcnNpb246IDAuNAppbnRlbF9pZGxlOiBNV0FJVCBzdWJzdGF0ZXM6IDB4MTEyMAppbnRl
bF9pZGxlOiB2MC40IG1vZGVsIDB4MjUKaW50ZWxfaWRsZTogbGFwaWNfdGltZXJfcmVsaWFibGVf
c3RhdGVzIDB4ZmZmZmZmZmYKQUNQSTogRGVwcmVjYXRlZCBwcm9jZnMgSS9GIGZvciBBQyBpcyBs
b2FkZWQsIHBsZWFzZSByZXRyeSB3aXRoIENPTkZJR19BQ1BJX1BST0NGU19QT1dFUiBjbGVhcmVk
CkFDUEk6IEFDIEFkYXB0ZXIgW0FDXSAob24tbGluZSkKaW5wdXQ6IFBvd2VyIEJ1dHRvbiBhcyAv
ZGV2aWNlcy9MTlhTWVNUTTowMC9kZXZpY2U6MDAvUE5QMEMwQzowMC9pbnB1dC9pbnB1dDAKQUNQ
STogUG93ZXIgQnV0dG9uIFtQV1JCXQppbnB1dDogTGlkIFN3aXRjaCBhcyAvZGV2aWNlcy9MTlhT
WVNUTTowMC9kZXZpY2U6MDAvUE5QMEMwRDowMC9pbnB1dC9pbnB1dDEKQUNQSTogTGlkIFN3aXRj
aCBbTElEMF0KaW5wdXQ6IFNsZWVwIEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9kZXZp
Y2U6MDAvUE5QMEMwRTowMC9pbnB1dC9pbnB1dDIKQUNQSTogU2xlZXAgQnV0dG9uIFtTQlROXQpp
bnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZU1RNOjAwL0xOWFBXUkJOOjAwL2lu
cHV0L2lucHV0MwpBQ1BJOiBQb3dlciBCdXR0b24gW1BXUkZdCnRoZXJtYWwgTE5YVEhFUk06MDA6
IHJlZ2lzdGVyZWQgYXMgdGhlcm1hbF96b25lMApBQ1BJOiBUaGVybWFsIFpvbmUgW1RITV0gKDU0
IEMpCkdIRVM6IEhFU1QgaXMgbm90IGVuYWJsZWQhClNlcmlhbDogODI1MC8xNjU1MCBkcml2ZXIs
IDQgcG9ydHMsIElSUSBzaGFyaW5nIGVuYWJsZWQKTGludXggYWdwZ2FydCBpbnRlcmZhY2UgdjAu
MTAzCmJyZDogbW9kdWxlIGxvYWRlZApsb29wOiBtb2R1bGUgbG9hZGVkCkZpeGVkIE1ESU8gQnVz
OiBwcm9iZWQKdHVuOiBVbml2ZXJzYWwgVFVOL1RBUCBkZXZpY2UgZHJpdmVyLCAxLjYKdHVuOiAo
QykgMTk5OS0yMDA0IE1heCBLcmFzbnlhbnNreSA8bWF4a0BxdWFsY29tbS5jb20+ClBQUCBnZW5l
cmljIGRyaXZlciB2ZXJzaW9uIDIuNC4yCmVoY2lfaGNkOiBVU0IgMi4wICdFbmhhbmNlZCcgSG9z
dCBDb250cm9sbGVyIChFSENJKSBEcml2ZXIKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0aW5n
IGxhdGVuY3kgdGltZXIgdG8gNjQKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBFSENJIEhvc3QgQ29u
dHJvbGxlcgplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFz
c2lnbmVkIGJ1cyBudW1iZXIgMQplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IGRlYnVnIHBvcnQgMgpl
aGNpX2hjZCAwMDAwOjAwOjFhLjA6IGNhY2hlIGxpbmUgc2l6ZSBvZiA2NCBpcyBub3Qgc3VwcG9y
dGVkCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogaXJxIDE2LCBpbyBtZW0gMHhmYmYwODAwMAplaGNp
X2hjZCAwMDAwOjAwOjFhLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwCmh1YiAxLTA6MS4w
OiBVU0IgaHViIGZvdW5kCmh1YiAxLTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkCmVoY2lfaGNkIDAw
MDA6MDA6MWQuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CmVoY2lfaGNkIDAwMDA6MDA6
MWQuMDogRUhDSSBIb3N0IENvbnRyb2xsZXIKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBuZXcgVVNC
IGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDIKZWhjaV9oY2QgMDAwMDowMDox
ZC4wOiBkZWJ1ZyBwb3J0IDIKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBjYWNoZSBsaW5lIHNpemUg
b2YgNjQgaXMgbm90IHN1cHBvcnRlZAplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IGlycSAyMywgaW8g
bWVtIDB4ZmJmMDcwMDAKQUNQSTogRGVwcmVjYXRlZCBwcm9jZnMgSS9GIGZvciBiYXR0ZXJ5IGlz
IGxvYWRlZCwgcGxlYXNlIHJldHJ5IHdpdGggQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSIGNsZWFy
ZWQKQUNQSTogQmF0dGVyeSBTbG90IFtCQVQwXSAoYmF0dGVyeSBwcmVzZW50KQplaGNpX2hjZCAw
MDAwOjAwOjFkLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwCmh1YiAyLTA6MS4wOiBVU0Ig
aHViIGZvdW5kCmh1YiAyLTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkCm9oY2lfaGNkOiBVU0IgMS4x
ICdPcGVuJyBIb3N0IENvbnRyb2xsZXIgKE9IQ0kpIERyaXZlcgp1aGNpX2hjZDogVVNCIFVuaXZl
cnNhbCBIb3N0IENvbnRyb2xsZXIgSW50ZXJmYWNlIGRyaXZlcgppODA0MjogUE5QOiBQUy8yIENv
bnRyb2xsZXIgW1BOUDAzMDM6S0JDLFBOUDBmMTM6UFMyXSBhdCAweDYwLDB4NjQgaXJxIDEsMTIK
c2VyaW86IGk4MDQyIEtCRCBwb3J0IGF0IDB4NjAsMHg2NCBpcnEgMQpzZXJpbzogaTgwNDIgQVVY
IHBvcnQgYXQgMHg2MCwweDY0IGlycSAxMgptb3VzZWRldjogUFMvMiBtb3VzZSBkZXZpY2UgY29t
bW9uIGZvciBhbGwgbWljZQpydGNfY21vcyAwMDowMzogUlRDIGNhbiB3YWtlIGZyb20gUzQKcnRj
X2Ntb3MgMDA6MDM6IHJ0YyBjb3JlOiByZWdpc3RlcmVkIHJ0Y19jbW9zIGFzIHJ0YzAKcnRjMDog
YWxhcm1zIHVwIHRvIG9uZSB5ZWFyLCB5M2ssIDExNCBieXRlcyBudnJhbSwgaHBldCBpcnFzCmRl
dmljZS1tYXBwZXI6IHVldmVudDogdmVyc2lvbiAxLjAuMwpkZXZpY2UtbWFwcGVyOiBpb2N0bDog
NC4yMi4wLWlvY3RsICgyMDExLTEwLTE5KSBpbml0aWFsaXNlZDogZG0tZGV2ZWxAcmVkaGF0LmNv
bQpkZXZpY2UtbWFwcGVyOiBtdWx0aXBhdGg6IHZlcnNpb24gMS4zLjAgbG9hZGVkCmRldmljZS1t
YXBwZXI6IG11bHRpcGF0aCByb3VuZC1yb2JpbjogdmVyc2lvbiAxLjAuMCBsb2FkZWQKY3B1aWRs
ZTogdXNpbmcgZ292ZXJub3IgbGFkZGVyCmNwdWlkbGU6IHVzaW5nIGdvdmVybm9yIG1lbnUKRUZJ
IFZhcmlhYmxlcyBGYWNpbGl0eSB2MC4wOCAyMDA0LU1heS0xNwpUQ1AgY3ViaWMgcmVnaXN0ZXJl
ZApORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDEwCk5FVDogUmVnaXN0ZXJlZCBwcm90
b2NvbCBmYW1pbHkgMTcKUmVnaXN0ZXJpbmcgdGhlIGRuc19yZXNvbHZlciBrZXkgdHlwZQpQTTog
SGliZXJuYXRpb24gaW1hZ2Ugbm90IHByZXNlbnQgb3IgY291bGQgbm90IGJlIGxvYWRlZC4KcmVn
aXN0ZXJlZCB0YXNrc3RhdHMgdmVyc2lvbiAxCiAgTWFnaWMgbnVtYmVyOiAxMjo5NTc6OTQKcnRj
X2Ntb3MgMDA6MDM6IHNldHRpbmcgc3lzdGVtIGNsb2NrIHRvIDIwMTItMDUtMzEgMjA6MDM6NDYg
VVRDICgxMzM4NDk0NjI2KQpCSU9TIEVERCBmYWNpbGl0eSB2MC4xNiAyMDA0LUp1bi0yNSwgMCBk
ZXZpY2VzIGZvdW5kCkVERCBpbmZvcm1hdGlvbiBub3QgYXZhaWxhYmxlLgpGcmVlaW5nIHVudXNl
ZCBrZXJuZWwgbWVtb3J5OiA4OTJrIGZyZWVkCldyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCBy
ZWFkLW9ubHkgZGF0YTogMTIyODhrCkZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1vcnk6IDE5NTJr
IGZyZWVkCkZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1vcnk6IDE0MTJrIGZyZWVkCmlucHV0OiBB
VCBUcmFuc2xhdGVkIFNldCAyIGtleWJvYXJkIGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3Nl
cmlvMC9pbnB1dC9pbnB1dDQKQUNQSSBXYXJuaW5nOiBfQlFDIHJldHVybmVkIGFuIGludmFsaWQg
bGV2ZWwgKDIwMTIwMTExL3ZpZGVvLTQ3MikKYWNwaSBkZXZpY2U6MDM6IHJlZ2lzdGVyZWQgYXMg
Y29vbGluZ19kZXZpY2U0CmlucHV0OiBWaWRlbyBCdXMgYXMgL2RldmljZXMvTE5YU1lTVE06MDAv
ZGV2aWNlOjAwL1BOUDBBMDg6MDAvZGV2aWNlOjAxL0xOWFZJREVPOjAwL2lucHV0L2lucHV0NQpB
Q1BJOiBWaWRlbyBEZXZpY2UgW1BFR1BdIChtdWx0aS1oZWFkOiB5ZXMgIHJvbTogbm8gIHBvc3Q6
IG5vKQpyODE2OSBHaWdhYml0IEV0aGVybmV0IGRyaXZlciAyLjNMSy1OQVBJIGxvYWRlZApyODE2
OSAwMDAwOjEzOjAwLjA6IGlycSA0NSBmb3IgTVNJL01TSS1YCnI4MTY5IDAwMDA6MTM6MDAuMDog
ZXRoMDogUlRMODEwMmUgYXQgMHhmZmZmYzkwMDAwNjdlMDAwLCBmMDo0ZDphMjpiYzpkODpkNiwg
WElEIDA0ZTAwMDAwIElSUSA0NQphaGNpIDAwMDA6MDA6MWYuMjogdmVyc2lvbiAzLjAKYWhjaSAw
MDAwOjAwOjFmLjI6IGlycSA0NiBmb3IgTVNJL01TSS1YCmFoY2kgMDAwMDowMDoxZi4yOiBBSENJ
IDAwMDEuMDMwMCAzMiBzbG90cyA2IHBvcnRzIDMgR2JwcyAweDEzIGltcGwgU0FUQSBtb2RlCmFo
Y2kgMDAwMDowMDoxZi4yOiBmbGFnczogNjRiaXQgbmNxIHNudGYgaWxjayBwbSBsZWQgY2xvIHBp
byBzbHVtIHBhcnQgZW1zIHN4cyBhcHN0IAphaGNpIDAwMDA6MDA6MWYuMjogc2V0dGluZyBsYXRl
bmN5IHRpbWVyIHRvIDY0Cltkcm1dIEluaXRpYWxpemVkIGRybSAxLjEuMCAyMDA2MDgxMApbZHJt
XSByYWRlb24gZGVmYXVsdGluZyB0byBrZXJuZWwgbW9kZXNldHRpbmcuCltkcm1dIHJhZGVvbiBr
ZXJuZWwgbW9kZXNldHRpbmcgZW5hYmxlZC4KW2RybV0gaW5pdGlhbGl6aW5nIGtlcm5lbCBtb2Rl
c2V0dGluZyAoUkVEV09PRCAweDEwMDI6MHg2OEMxIDB4MTAyODoweDA0NDcpLgpbZHJtXSByZWdp
c3RlciBtbWlvIGJhc2U6IDB4RkJFMjAwMDAKW2RybV0gcmVnaXN0ZXIgbW1pbyBzaXplOiAxMzEw
NzIKQVRPTSBCSU9TOiBEZWxsCnJhZGVvbiAwMDAwOjAxOjAwLjA6IFZSQU06IDEwMjRNIDB4MDAw
MDAwMDAwMDAwMDAwMCAtIDB4MDAwMDAwMDAzRkZGRkZGRiAoMTAyNE0gdXNlZCkKcmFkZW9uIDAw
MDA6MDE6MDAuMDogR1RUOiA1MTJNIDB4MDAwMDAwMDA0MDAwMDAwMCAtIDB4MDAwMDAwMDA1RkZG
RkZGRgptdHJyOiB0eXBlIG1pc21hdGNoIGZvciBjMDAwMDAwMCwxMDAwMDAwMCBvbGQ6IHdyaXRl
LWJhY2sgbmV3OiB3cml0ZS1jb21iaW5pbmcKW2RybV0gRGV0ZWN0ZWQgVlJBTSBSQU09MTAyNE0s
IEJBUj0yNTZNCltkcm1dIFJBTSB3aWR0aCAxMjhiaXRzIEREUgpbVFRNXSBab25lICBrZXJuZWw6
IEF2YWlsYWJsZSBncmFwaGljcyBtZW1vcnk6IDE4OTA2NjQga2lCLgpbVFRNXSBJbml0aWFsaXpp
bmcgcG9vbCBhbGxvY2F0b3IuCltUVE1dIEluaXRpYWxpemluZyBETUEgcG9vbCBhbGxvY2F0b3Iu
Cltkcm1dIHJhZGVvbjogMTAyNE0gb2YgVlJBTSBtZW1vcnkgcmVhZHkKW2RybV0gcmFkZW9uOiA1
MTJNIG9mIEdUVCBtZW1vcnkgcmVhZHkuCltkcm1dIFN1cHBvcnRzIHZibGFuayB0aW1lc3RhbXAg
Y2FjaGluZyBSZXYgMSAoMTAuMTAuMjAxMCkuCltkcm1dIERyaXZlciBzdXBwb3J0cyBwcmVjaXNl
IHZibGFuayB0aW1lc3RhbXAgcXVlcnkuCnJhZGVvbiAwMDAwOjAxOjAwLjA6IGlycSA0NyBmb3Ig
TVNJL01TSS1YCnJhZGVvbiAwMDAwOjAxOjAwLjA6IHJhZGVvbjogdXNpbmcgTVNJLgpbZHJtXSBy
YWRlb246IGlycSBpbml0aWFsaXplZC4KW2RybV0gR0FSVDogbnVtIGNwdSBwYWdlcyAxMzEwNzIs
IG51bSBncHUgcGFnZXMgMTMxMDcyCltkcm1dIHJhZGVvbjogaWIgcG9vbCByZWFkeS4KW2RybV0g
TG9hZGluZyBSRURXT09EIE1pY3JvY29kZQpbZHJtXSBQQ0lFIEdBUlQgb2YgNTEyTSBlbmFibGVk
ICh0YWJsZSBhdCAweDAwMDAwMDAwMDAwNDAwMDApLgpyYWRlb24gMDAwMDowMTowMC4wOiBXQiBl
bmFibGVkCltkcm1dIGZlbmNlIGRyaXZlciBvbiByaW5nIDAgdXNlIGdwdSBhZGRyIDB4NDAwMDBj
MDAgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDEwZjA0NGMwMApzY3NpMCA6IGFoY2kKc2NzaTEgOiBh
aGNpCnNjc2kyIDogYWhjaQpzY3NpMyA6IGFoY2kKc2NzaTQgOiBhaGNpCnNjc2k1IDogYWhjaQph
dGExOiBTQVRBIG1heCBVRE1BLzEzMyBhYmFyIG0yMDQ4QDB4ZmJmMDYwMDAgcG9ydCAweGZiZjA2
MTAwIGlycSA0NgphdGEyOiBTQVRBIG1heCBVRE1BLzEzMyBhYmFyIG0yMDQ4QDB4ZmJmMDYwMDAg
cG9ydCAweGZiZjA2MTgwIGlycSA0NgphdGEzOiBEVU1NWQphdGE0OiBEVU1NWQphdGE1OiBTQVRB
IG1heCBVRE1BLzEzMyBhYmFyIG0yMDQ4QDB4ZmJmMDYwMDAgcG9ydCAweGZiZjA2MzAwIGlycSA0
NgphdGE2OiBEVU1NWQpbZHJtXSByaW5nIHRlc3Qgb24gMCBzdWNjZWVkZWQgaW4gMSB1c2Vjcwpb
ZHJtXSBpYiB0ZXN0IG9uIHJpbmcgMCBzdWNjZWVkZWQgaW4gMCB1c2VjcwpbZHJtXSBFbmFibGlu
ZyBhdWRpbyBzdXBwb3J0Cltkcm1dIFJhZGVvbiBEaXNwbGF5IENvbm5lY3RvcnMKW2RybV0gQ29u
bmVjdG9yIDA6Cltkcm1dICAgTFZEUwpbZHJtXSAgIEREQzogMHg2NTYwIDB4NjU2MCAweDY1NjQg
MHg2NTY0IDB4NjU2OCAweDY1NjggMHg2NTZjIDB4NjU2YwpbZHJtXSAgIEVuY29kZXJzOgpbZHJt
XSAgICAgTENEMTogSU5URVJOQUxfVU5JUEhZCltkcm1dIENvbm5lY3RvciAxOgpbZHJtXSAgIEhE
TUktQQpbZHJtXSAgIEhQRDEKW2RybV0gICBEREM6IDB4NjQ0MCAweDY0NDAgMHg2NDQ0IDB4NjQ0
NCAweDY0NDggMHg2NDQ4IDB4NjQ0YyAweDY0NGMKW2RybV0gICBFbmNvZGVyczoKW2RybV0gICAg
IERGUDE6IElOVEVSTkFMX1VOSVBIWTEKW2RybV0gQ29ubmVjdG9yIDI6Cltkcm1dICAgVkdBCltk
cm1dICAgRERDOiAweDY0MzAgMHg2NDMwIDB4NjQzNCAweDY0MzQgMHg2NDM4IDB4NjQzOCAweDY0
M2MgMHg2NDNjCltkcm1dICAgRW5jb2RlcnM6Cltkcm1dICAgICBDUlQxOiBJTlRFUk5BTF9LTERT
Q1BfREFDMQpbZHJtXSBJbnRlcm5hbCB0aGVybWFsIGNvbnRyb2xsZXIgd2l0aCBmYW4gY29udHJv
bApbZHJtXSByYWRlb246IHBvd2VyIG1hbmFnZW1lbnQgaW5pdGlhbGl6ZWQKdXNiIDEtMTogbmV3
IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMiB1c2luZyBlaGNpX2hjZApodWIgMS0xOjEu
MDogVVNCIGh1YiBmb3VuZApodWIgMS0xOjEuMDogNiBwb3J0cyBkZXRlY3RlZAphdGExOiBTQVRB
IGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9sIDMwMCkKYXRhNTogU0FUQSBs
aW5rIGRvd24gKFNTdGF0dXMgMCBTQ29udHJvbCAzMDApCmF0YTI6IFNBVEEgbGluayB1cCAxLjUg
R2JwcyAoU1N0YXR1cyAxMTMgU0NvbnRyb2wgMzAwKQphdGExLjAwOiBBVEEtODogV0RDIFdENTAw
MEJFS1QtNzVLQTlUMCwgMDEuMDFBMDEsIG1heCBVRE1BLzEzMwphdGExLjAwOiA5NzY3NzMxNjgg
c2VjdG9ycywgbXVsdGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzEvMzIpLCBBQQphdGEyLjAwOiBB
VEFQSTogUExEUyBEVkQrLy1SVyBEUy04QTVTSCwgWEQxMiwgbWF4IFVETUEvMTAwCmF0YTEuMDA6
IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzCmF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTAw
CnNjc2kgMDowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQVRBICAgICAgV0RDIFdENTAwMEJFS1Qt
NyAwMS4wIFBROiAwIEFOU0k6IDUKc2QgMDowOjA6MDogW3NkYV0gOTc2NzczMTY4IDUxMi1ieXRl
IGxvZ2ljYWwgYmxvY2tzOiAoNTAwIEdCLzQ2NSBHaUIpCnNkIDA6MDowOjA6IEF0dGFjaGVkIHNj
c2kgZ2VuZXJpYyBzZzAgdHlwZSAwCnNkIDA6MDowOjA6IFtzZGFdIFdyaXRlIFByb3RlY3QgaXMg
b2ZmCnNkIDA6MDowOjA6IFtzZGFdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwCnNkIDA6MDowOjA6
IFtzZGFdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0
IHN1cHBvcnQgRFBPIG9yIEZVQQpzY3NpIDE6MDowOjA6IENELVJPTSAgICAgICAgICAgIFBMRFMg
ICAgIERWRCstUlcgRFMtOEE1U0ggWEQxMiBQUTogMCBBTlNJOiA1CnNyMDogc2NzaTMtbW1jIGRy
aXZlOiAyNHgvOHggd3JpdGVyIGR2ZC1yYW0gY2QvcncgeGEvZm9ybTIgY2RkYSB0cmF5CmNkcm9t
OiBVbmlmb3JtIENELVJPTSBkcml2ZXIgUmV2aXNpb246IDMuMjAKc3IgMTowOjA6MDogQXR0YWNo
ZWQgc2NzaSBDRC1ST00gc3IwCnNyIDE6MDowOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzEg
dHlwZSA1CnVzYiAyLTE6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDIgdXNpbmcg
ZWhjaV9oY2QKIHNkYTogc2RhMSBzZGEyIDwgc2RhNSA+CnNkIDA6MDowOjA6IFtzZGFdIEF0dGFj
aGVkIFNDU0kgZGlzawpodWIgMi0xOjEuMDogVVNCIGh1YiBmb3VuZApodWIgMi0xOjEuMDogOCBw
b3J0cyBkZXRlY3RlZAp1c2IgMS0xLjI6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVy
IDMgdXNpbmcgZWhjaV9oY2QKUmVmaW5lZCBUU0MgY2xvY2tzb3VyY2UgY2FsaWJyYXRpb246IDI1
MjYuOTg1IE1Iei4KU3dpdGNoaW5nIHRvIGNsb2Nrc291cmNlIHRzYwpJbml0aWFsaXppbmcgVVNC
IE1hc3MgU3RvcmFnZSBkcml2ZXIuLi4Kc2NzaTYgOiB1c2Itc3RvcmFnZSAxLTEuMjoxLjAKdXNi
Y29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1c2Itc3RvcmFnZQpVU0IgTWFz
cyBTdG9yYWdlIHN1cHBvcnQgcmVnaXN0ZXJlZC4KdXNiIDEtMS42OiBuZXcgaGlnaC1zcGVlZCBV
U0IgZGV2aWNlIG51bWJlciA0IHVzaW5nIGVoY2lfaGNkCnNjc2kgNjowOjA6MDogRGlyZWN0LUFj
Y2VzcyAgICAgICAgICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAwIEFOU0k6IDIKc2Nz
aSA2OjA6MDoxOiBDRC1ST00gICAgICAgICAgICAgICAgICAgICBJZGVvcyAgICAgICAgICAgIDAw
MDAgUFE6IDAgQU5TSTogMgpzZCA2OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cyIHR5
cGUgMApzcjE6IHNjc2kzLW1tYyBkcml2ZTogMHgvMHggY2FkZHkKc3IgNjowOjA6MTogQXR0YWNo
ZWQgc2NzaSBDRC1ST00gc3IxCnNyIDY6MDowOjE6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzMg
dHlwZSA1CnNkIDY6MDowOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kgcmVtb3ZhYmxlIGRpc2sKW2Ry
bV0gZmIgbWFwcGFibGUgYXQgMHhDMDE0MjAwMApbZHJtXSB2cmFtIGFwcGVyIGF0IDB4QzAwMDAw
MDAKW2RybV0gc2l6ZSA0MzI1Mzc2Cltkcm1dIGZiIGRlcHRoIGlzIDI0Cltkcm1dICAgIHBpdGNo
IGlzIDU2MzIKZmJjb246IHJhZGVvbmRybWZiIChmYjApIGlzIHByaW1hcnkgZGV2aWNlCkNvbnNv
bGU6IHN3aXRjaGluZyB0byBjb2xvdXIgZnJhbWUgYnVmZmVyIGRldmljZSAxNzB4NDgKZmIwOiBy
YWRlb25kcm1mYiBmcmFtZSBidWZmZXIgZGV2aWNlCmRybTogcmVnaXN0ZXJlZCBwYW5pYyBub3Rp
ZmllcgpbZHJtXSBJbml0aWFsaXplZCByYWRlb24gMi4xMy4wIDIwMDgwNTI4IGZvciAwMDAwOjAx
OjAwLjAgb24gbWlub3IgMApFWFQ0LWZzIChzZGExKTogbW91bnRlZCBmaWxlc3lzdGVtIHdpdGgg
b3JkZXJlZCBkYXRhIG1vZGUuIE9wdHM6IChudWxsKQpBZGRpbmcgMTE0ODAwNjBrIHN3YXAgb24g
L2Rldi9zZGE1LiAgUHJpb3JpdHk6LTEgZXh0ZW50czoxIGFjcm9zczoxMTQ4MDA2MGsgCkVYVDQt
ZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRy
CnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0NjQyLjIyMjoyKTogYXBwYXJtb3I9IlNUQVRVUyIgb3Bl
cmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii9zYmluL2RoY2xpZW50IiBwaWQ9NjkyIGNvbW09
ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NDIuMjIyOjMpOiBhcHBh
cm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9hZCIgbmFtZT0iL3Vzci9saWIvTmV0
d29ya01hbmFnZXIvbm0tZGhjcC1jbGllbnQuYWN0aW9uIiBwaWQ9NjkyIGNvbW09ImFwcGFybW9y
X3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NDIuMjIyOjQpOiBhcHBhcm1vcj0iU1RB
VFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9hZCIgbmFtZT0iL3Vzci9saWIvY29ubm1hbi9zY3Jp
cHRzL2RoY2xpZW50LXNjcmlwdCIgcGlkPTY5MiBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9
MTQwMCBhdWRpdCgxMzM4NDk0NjQyLjI0Mjo1KTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9u
PSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii9zYmluL2RoY2xpZW50IiBwaWQ9NjgxIGNvbW09ImFw
cGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NDIuMjQyOjYpOiBhcHBhcm1v
cj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3Vzci9saWIvTmV0
d29ya01hbmFnZXIvbm0tZGhjcC1jbGllbnQuYWN0aW9uIiBwaWQ9NjgxIGNvbW09ImFwcGFybW9y
X3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NDIuMjQyOjcpOiBhcHBhcm1vcj0iU1RB
VFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3Vzci9saWIvY29ubm1hbi9z
Y3JpcHRzL2RoY2xpZW50LXNjcmlwdCIgcGlkPTY4MSBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCmxw
OiBkcml2ZXIgbG9hZGVkIGJ1dCBubyBkZXZpY2VzIGZvdW5kCmNmZzgwMjExOiBDYWxsaW5nIENS
REEgdG8gdXBkYXRlIHdvcmxkIHJlZ3VsYXRvcnkgZG9tYWluCnR5cGU9MTQwMCBhdWRpdCgxMzM4
NDk0NjQyLjg2Mjo4KTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX2xvYWQi
IG5hbWU9Ii91c3Ivc2Jpbi9udHBkIiBwaWQ9ODYxIGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlw
ZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NDIuODYyOjkpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRp
b249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3Vzci9zYmluL250cGQiIHBpZD04NjIgY29tbT0i
YXBwYXJtb3JfcGFyc2VyIgp0eXBlPTE0MDAgYXVkaXQoMTMzODQ5NDY0My4xMzI6MTApOiBhcHBh
cm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3NiaW4vZGhj
bGllbnQiIHBpZD04ODkgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgp0eXBlPTE0MDAgYXVkaXQoMTMz
ODQ5NDY0My4xMzI6MTEpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVw
bGFjZSIgbmFtZT0iL3Vzci9saWIvTmV0d29ya01hbmFnZXIvbm0tZGhjcC1jbGllbnQuYWN0aW9u
IiBwaWQ9ODg5IGNvbW09ImFwcGFybW9yX3BhcnNlciIKY2ZnODAyMTE6IFdvcmxkIHJlZ3VsYXRv
cnkgZG9tYWluIHVwZGF0ZWQ6CmNmZzgwMjExOiAgIChzdGFydF9mcmVxIC0gZW5kX2ZyZXEgQCBi
YW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2VpcnApCmNmZzgwMjExOiAgICgyNDAy
MDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpj
Zmc4MDIxMTogICAoMjQ1NzAwMCBLSHogLSAyNDgyMDAwIEtIeiBAIDIwMDAwIEtIeiksICgzMDAg
bUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDI0NzQwMDAgS0h6IC0gMjQ5NDAwMCBLSHogQCAy
MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICg1MTcwMDAwIEtIeiAt
IDUyNTAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTog
ICAoNTczNTAwMCBLSHogLSA1ODM1MDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAw
IG1CbSkKZGNkYmFzIGRjZGJhczogRGVsbCBTeXN0ZW1zIE1hbmFnZW1lbnQgQmFzZSBEcml2ZXIg
KHZlcnNpb24gNS42LjAtMy4yKQppcF90YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0ZmlsdGVyIENv
cmUgVGVhbQppbnRlbCBpcHMgMDAwMDowMDoxZi42OiBDUFUgVERQIGRvZXNuJ3QgbWF0Y2ggZXhw
ZWN0ZWQgdmFsdWUgKGZvdW5kIDI1LCBleHBlY3RlZCAyOSkKaW50ZWwgaXBzIDAwMDA6MDA6MWYu
NjogZmFpbGVkIHRvIGdldCBpOTE1IHN5bWJvbHMsIGdyYXBoaWNzIHR1cmJvIGRpc2FibGVkCmlu
dGVsIGlwcyAwMDAwOjAwOjFmLjY6IElQUyBkcml2ZXIgaW5pdGlhbGl6ZWQsIE1DUCB0ZW1wIGxp
bWl0IDkwCmlucHV0OiBEZWxsIFdNSSBob3RrZXlzIGFzIC9kZXZpY2VzL3ZpcnR1YWwvaW5wdXQv
aW5wdXQ2Cm1laTogbW9kdWxlIGlzIGZyb20gdGhlIHN0YWdpbmcgZGlyZWN0b3J5LCB0aGUgcXVh
bGl0eSBpcyB1bmtub3duLCB5b3UgaGF2ZSBiZWVuIHdhcm5lZC4KbWVpIDAwMDA6MDA6MTYuMDog
c2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0Cm1laSAwMDAwOjAwOjE2LjA6IGlycSA0OCBmb3Ig
TVNJL01TSS1YCkxpbnV4IG1lZGlhIGludGVyZmFjZTogdjAuMTAKTGludXggdmlkZW8gY2FwdHVy
ZSBpbnRlcmZhY2U6IHYyLjAwCm5mX2Nvbm50cmFjayB2ZXJzaW9uIDAuNS4wICgxNjM4NCBidWNr
ZXRzLCA2NTUzNiBtYXgpCnV2Y3ZpZGVvOiBGb3VuZCBVVkMgMS4wMCBkZXZpY2UgTGFwdG9wX0lu
dGVncmF0ZWRfV2ViY2FtXzEuM00gKDBjNDU6NjQ4MCkKaW5wdXQ6IExhcHRvcF9JbnRlZ3JhdGVk
X1dlYmNhbV8xLjNNIGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxYS4wL3VzYjEvMS0x
LzEtMS42LzEtMS42OjEuMC9pbnB1dC9pbnB1dDcKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50
ZXJmYWNlIGRyaXZlciB1dmN2aWRlbwpVU0IgVmlkZW8gQ2xhc3MgZHJpdmVyICgxLjEuMSkKcHNt
b3VzZSBzZXJpbzE6IHN5bmFwdGljczogVG91Y2hwYWQgbW9kZWw6IDEsIGZ3OiA3LjIsIGlkOiAw
eDFjMGIxLCBjYXBzOiAweGQwNDczMy8weGE0MDAwMC8weGEwMDAwCmlucHV0OiBTeW5QUy8yIFN5
bmFwdGljcyBUb3VjaFBhZCBhcyAvZGV2aWNlcy9wbGF0Zm9ybS9pODA0Mi9zZXJpbzEvaW5wdXQv
aW5wdXQ4CkludGVsKFIpIFdpcmVsZXNzIFdpRmkgTGluayBBR04gZHJpdmVyIGZvciBMaW51eCwg
aW4tdHJlZToKQ29weXJpZ2h0KGMpIDIwMDMtMjAxMSBJbnRlbCBDb3Jwb3JhdGlvbgppd2x3aWZp
IDAwMDA6MTI6MDAuMDogcGNpX3Jlc291cmNlX2xlbiA9IDB4MDAwMDIwMDAKaXdsd2lmaSAwMDAw
OjEyOjAwLjA6IHBjaV9yZXNvdXJjZV9iYXNlID0gZmZmZmM5MDAxMTBjYzAwMAppd2x3aWZpIDAw
MDA6MTI6MDAuMDogSFcgUmV2aXNpb24gSUQgPSAweDAKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IGly
cSA0OSBmb3IgTVNJL01TSS1YCml3bHdpZmkgMDAwMDoxMjowMC4wOiBDT05GSUdfSVdMV0lGSV9E
RUJVRyBkaXNhYmxlZAppd2x3aWZpIDAwMDA6MTI6MDAuMDogQ09ORklHX0lXTFdJRklfREVCVUdG
UyBkaXNhYmxlZAppd2x3aWZpIDAwMDA6MTI6MDAuMDogQ09ORklHX0lXTFdJRklfREVWSUNFX1RS
QUNJTkcgZW5hYmxlZAppd2x3aWZpIDAwMDA6MTI6MDAuMDogQ09ORklHX0lXTFdJRklfREVWSUNF
X1RFU1RNT0RFIGVuYWJsZWQKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IENPTkZJR19JV0xXSUZJX1Ay
UCBlbmFibGVkCml3bHdpZmkgMDAwMDoxMjowMC4wOiBEZXRlY3RlZCBJbnRlbChSKSBDZW50cmlu
byhSKSBXaXJlbGVzcy1OIDEwMDAgQkdOLCBSRVY9MHg2Qwppd2x3aWZpIDAwMDA6MTI6MDAuMDog
TDEgRGlzYWJsZWQ7IEVuYWJsaW5nIEwwUwppd2x3aWZpIDAwMDA6MTI6MDAuMDogZGV2aWNlIEVF
UFJPTSBWRVI9MHgxNWQsIENBTElCPTB4Ngppd2x3aWZpIDAwMDA6MTI6MDAuMDogRGV2aWNlIFNL
VTogMHg1MAppd2x3aWZpIDAwMDA6MTI6MDAuMDogVmFsaWQgVHggYW50OiAweDEsIFZhbGlkIFJ4
IGFudDogMHgzCml3bHdpZmkgMDAwMDoxMjowMC4wOiBUdW5hYmxlIGNoYW5uZWxzOiAxMyA4MDIu
MTFiZywgMCA4MDIuMTFhIGNoYW5uZWxzCml3bHdpZmkgMDAwMDoxMjowMC4wOiBSRl9LSUxMIGJp
dCB0b2dnbGVkIHRvIGRpc2FibGUgcmFkaW8uCmlwNl90YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0
ZmlsdGVyIENvcmUgVGVhbQppd2x3aWZpIDAwMDA6MTI6MDAuMDogbG9hZGVkIGZpcm13YXJlIHZl
cnNpb24gMzkuMzEuNS4xIGJ1aWxkIDM1MTM4ClJlZ2lzdGVyZWQgbGVkIGRldmljZTogcGh5MC1s
ZWQKY2ZnODAyMTE6IElnbm9yaW5nIHJlZ3VsYXRvcnkgcmVxdWVzdCBTZXQgYnkgY29yZSBzaW5j
ZSB0aGUgZHJpdmVyIHVzZXMgaXRzIG93biBjdXN0b20gcmVndWxhdG9yeSBkb21haW4KaWVlZTgw
MjExIHBoeTA6IFNlbGVjdGVkIHJhdGUgY29udHJvbCBhbGdvcml0aG0gJ2l3bC1hZ24tcnMnCnNu
ZF9oZGFfaW50ZWwgMDAwMDowMDoxYi4wOiBpcnEgNTAgZm9yIE1TSS9NU0ktWApyODE2OSAwMDAw
OjEzOjAwLjA6IGV0aDA6IGxpbmsgZG93bgpBRERSQ09ORihORVRERVZfVVApOiBldGgwOiBsaW5r
IGlzIG5vdCByZWFkeQppbnB1dDogSERBIEludGVsIE1pYyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAw
LzAwMDA6MDA6MWIuMC9zb3VuZC9jYXJkMC9pbnB1dDkKaW5wdXQ6IEhEQSBJbnRlbCBIZWFkcGhv
bmUgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjFiLjAvc291bmQvY2FyZDAvaW5wdXQx
MApzbmRfaGRhX2ludGVsIDAwMDA6MDE6MDAuMTogaXJxIDUxIGZvciBNU0kvTVNJLVgKSERNSSBz
dGF0dXM6IENvZGVjPTAgUGluPTMgUHJlc2VuY2VfRGV0ZWN0PTEgRUxEX1ZhbGlkPTEKaW5wdXQ6
IEhELUF1ZGlvIEdlbmVyaWMgSERNSS9EUCxwY209MyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAw
MDA6MDA6MDEuMC8wMDAwOjAxOjAwLjEvc291bmQvY2FyZDEvaW5wdXQxMQpwcGRldjogdXNlci1z
cGFjZSBwYXJhbGxlbCBwb3J0IGRyaXZlcgphdWRpdF9wcmludGtfc2tiOiA2IGNhbGxiYWNrcyBz
dXBwcmVzc2VkCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0NjU0LjA2MjoxNCk6IGFwcGFybW9yPSJT
VEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL2xpYi9jdXBzL2JhY2tl
bmQvY3Vwcy1wZGYiIHBpZD0xMjcyIGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1
ZGl0KDEzMzg0OTQ2NTQuMDYyOjE1KTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9m
aWxlX2xvYWQiIG5hbWU9Ii91c3Ivc2Jpbi9jdXBzZCIgcGlkPTEyNzIgY29tbT0iYXBwYXJtb3Jf
cGFyc2VyIgp0eXBlPTE0MDAgYXVkaXQoMTMzODQ5NDY1NC42NjI6MTYpOiBhcHBhcm1vcj0iU1RB
VFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9hZCIgbmFtZT0iL3Vzci9zaGFyZS9nZG0vZ3Vlc3Qt
c2Vzc2lvbi9Yc2Vzc2lvbiIgcGlkPTEzMTcgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgp0eXBlPTE0
MDAgYXVkaXQoMTMzODQ5NDY1NC42NzI6MTcpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249
InByb2ZpbGVfbG9hZCIgbmFtZT0iL3Vzci9iaW4vZnJlc2hjbGFtIiBwaWQ9MTMyMSBjb21tPSJh
cHBhcm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0NjU0LjkyMjoxOCk6IGFwcGFy
bW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL2xpYi9saWJ2
aXJ0L3ZpcnQtYWEtaGVscGVyIiBwaWQ9MTMyMyBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9
MTQwMCBhdWRpdCgxMzM4NDk0NjU0LjkzMjoxOSk6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlv
bj0icHJvZmlsZV9yZXBsYWNlIiBuYW1lPSIvc2Jpbi9kaGNsaWVudCIgcGlkPTEzMTggY29tbT0i
YXBwYXJtb3JfcGFyc2VyIgp0eXBlPTE0MDAgYXVkaXQoMTMzODQ5NDY1NC45MzI6MjApOiBhcHBh
cm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVwbGFjZSIgbmFtZT0iL3Vzci9saWIv
TmV0d29ya01hbmFnZXIvbm0tZGhjcC1jbGllbnQuYWN0aW9uIiBwaWQ9MTMxOCBjb21tPSJhcHBh
cm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0NjU0LjkzMjoyMSk6IGFwcGFybW9y
PSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9yZXBsYWNlIiBuYW1lPSIvdXNyL2xpYi9jb25u
bWFuL3NjcmlwdHMvZGhjbGllbnQtc2NyaXB0IiBwaWQ9MTMxOCBjb21tPSJhcHBhcm1vcl9wYXJz
ZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0NjU1LjA3MjoyMik6IGFwcGFybW9yPSJTVEFUVVMi
IG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL3NiaW4vbGlidmlydGQiIHBpZD0x
MzI1IGNvbW09ImFwcGFybW9yX3BhcnNlciIKdHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NTUuMzEy
OjIzKTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii91
c3Ivc2Jpbi9uYW1lZCIgcGlkPTEzMjcgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgphdWRpdF9wcmlu
dGtfc2tiOiAxOCBjYWxsYmFja3Mgc3VwcHJlc3NlZAp0eXBlPTE0MDAgYXVkaXQoMTMzODQ5NDY2
MC4wNTI6MzApOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfbG9hZCIgbmFt
ZT0iL3Vzci9iaW4vZXZpbmNlIiBwaWQ9MTMxOSBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9
MTQwMCBhdWRpdCgxMzM4NDk0NjYwLjA1MjozMSk6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlv
bj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL2Jpbi9ldmluY2UtcHJldmlld2VyIiBwaWQ9MTMx
OSBjb21tPSJhcHBhcm1vcl9wYXJzZXIiCnR5cGU9MTQwMCBhdWRpdCgxMzM4NDk0NjYwLjA1Mjoz
Mik6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNy
L2Jpbi9ldmluY2UtdGh1bWJuYWlsZXIiIHBpZD0xMzE5IGNvbW09ImFwcGFybW9yX3BhcnNlciIK
dHlwZT0xNDAwIGF1ZGl0KDEzMzg0OTQ2NjEuMjkyOjMzKTogYXBwYXJtb3I9IlNUQVRVUyIgb3Bl
cmF0aW9uPSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii91c3Ivc2Jpbi9teXNxbGQiIHBpZD0xNDQ5
IGNvbW09ImFwcGFybW9yX3BhcnNlciIKa3ZtOiBWTV9FWElUX0xPQURfSUEzMl9QRVJGX0dMT0JB
TF9DVFJMIGRvZXMgbm90IHdvcmsgcHJvcGVybHkuIFVzaW5nIHdvcmthcm91bmQKQnJpZGdlIGZp
cmV3YWxsaW5nIHJlZ2lzdGVyZWQKQUREUkNPTkYoTkVUREVWX1VQKTogdmlyYnIwOiBsaW5rIGlz
IG5vdCByZWFkeQpoZGEtaW50ZWw6IElSUSB0aW1pbmcgd29ya2Fyb3VuZCBpcyBhY3RpdmF0ZWQg
Zm9yIGNhcmQgIzEuIFN1Z2dlc3QgYSBiaWdnZXIgYmRsX3Bvc19hZGouCkVYVDQtZnMgKHNkYTEp
OiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0w
CnZib3hkcnY6IEZvdW5kIDQgcHJvY2Vzc29yIGNvcmVzLgpWQm94RHJ2OiBkYmcgLSBnX2FiRXhl
Y01lbW9yeT1mZmZmZmZmZmEwNTA2NzAwCnZib3hkcnY6IGZBc3luYz0wIG9mZk1pbj0weDI0MyBv
ZmZNYXg9MHgxZTA0CnZib3hkcnY6IFRTQyBtb2RlIGlzICdzeW5jaHJvbm91cycsIGtlcm5lbCB0
aW1lciBtb2RlIGlzICdub3JtYWwnLgp2Ym94ZHJ2OiBTdWNjZXNzZnVsbHkgbG9hZGVkIHZlcnNp
b24gNC4xLjE0IChpbnRlcmZhY2UgMHgwMDE5MDAwMCkuCnZib3hwY2k6IElPTU1VIG5vdCBmb3Vu
ZCAobm90IHJlZ2lzdGVyZWQpCkFERFJDT05GKE5FVERFVl9VUCk6IHRhcDA6IGxpbmsgaXMgbm90
IHJlYWR5CmhkYS1pbnRlbDogSVJRIHRpbWluZyB3b3JrYXJvdW5kIGlzIGFjdGl2YXRlZCBmb3Ig
Y2FyZCAjMC4gU3VnZ2VzdCBhIGJpZ2dlciBiZGxfcG9zX2Fkai4KdXNiIDEtMS4yOiBVU0IgZGlz
Y29ubmVjdCwgZGV2aWNlIG51bWJlciAzCnVzYiAxLTEuMjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRl
dmljZSBudW1iZXIgNSB1c2luZyBlaGNpX2hjZApzY3NpNyA6IHVzYi1zdG9yYWdlIDEtMS4yOjEu
MApzY3NpIDc6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgICAgICAgICAgIElkZW9zICAgICAgICAg
ICAgMDAwMCBQUTogMCBBTlNJOiAyCnNjc2kgNzowOjA6MTogQ0QtUk9NICAgICAgICAgICAgICAg
ICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAwIEFOU0k6IDIKc2QgNzowOjA6MDogQXR0
YWNoZWQgc2NzaSBnZW5lcmljIHNnMiB0eXBlIDAKc3IxOiBzY3NpMy1tbWMgZHJpdmU6IDB4LzB4
IGNhZGR5CnNyIDc6MDowOjE6IEF0dGFjaGVkIHNjc2kgQ0QtUk9NIHNyMQpzciA3OjA6MDoxOiBB
dHRhY2hlZCBzY3NpIGdlbmVyaWMgc2czIHR5cGUgNQpzZCA3OjA6MDowOiBbc2RiXSBBdHRhY2hl
ZCBTQ1NJIHJlbW92YWJsZSBkaXNrCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBl
cnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0wClBNOiBTeW5jaW5nIGZpbGVzeXN0
ZW1zIC4uLiBkb25lLgpQTTogUHJlcGFyaW5nIHN5c3RlbSBmb3IgbWVtIHNsZWVwCkZyZWV6aW5n
IHVzZXIgc3BhY2UgcHJvY2Vzc2VzIC4uLiAoZWxhcHNlZCAwLjA3IHNlY29uZHMpIGRvbmUuCkZy
ZWV6aW5nIHJlbWFpbmluZyBmcmVlemFibGUgdGFza3MgLi4uIChlbGFwc2VkIDAuMDEgc2Vjb25k
cykgZG9uZS4KUE06IEVudGVyaW5nIG1lbSBzbGVlcApTdXNwZW5kaW5nIGNvbnNvbGUocykgKHVz
ZSBub19jb25zb2xlX3N1c3BlbmQgdG8gZGVidWcpCnNkIDA6MDowOjA6IFtzZGFdIFN5bmNocm9u
aXppbmcgU0NTSSBjYWNoZQpzZCAwOjA6MDowOiBbc2RhXSBTdG9wcGluZyBkaXNrCnBjaWVocCAw
MDAwOjAwOjFjLjQ6cGNpZTA0OiBwY2llaHBfc3VzcGVuZCBFTlRSWQpBQ1BJIGhhbmRsZSBoYXMg
bm8gY29udGV4dCEKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCltkcm1dIERpc2FibGluZyBh
dWRpbyBzdXBwb3J0ClBNOiBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgNzA5LjY4
MSBtc2VjcwpQTTogc3VzcGVuZCBkZXZpY2VzIHRvb2sgMC43MTAgc2Vjb25kcwpwY2llcG9ydCAw
MDAwOjAwOjFjLjI6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkKZWhjaV9oY2Qg
MDAwMDowMDoxZC4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJCmVoY2lfaGNk
IDAwMDA6MDA6MWEuMDogd2FrZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQSQpQTTogbGF0
ZSBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgMTAwLjA4OSBtc2VjcwpBQ1BJOiBQ
cmVwYXJpbmcgdG8gZW50ZXIgc3lzdGVtIHNsZWVwIHN0YXRlIFMzClBNOiBTYXZpbmcgcGxhdGZv
cm0gTlZTIG1lbW9yeQpEaXNhYmxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4KQ1BVIDEgaXMgbm93IG9m
ZmxpbmUKQ1BVIDIgaXMgbm93IG9mZmxpbmUKQ1BVIDMgaXMgbm93IG9mZmxpbmUKRXh0ZW5kZWQg
Q01PUyB5ZWFyOiAyMDAwCkFDUEk6IExvdy1sZXZlbCByZXN1bWUgY29tcGxldGUKUE06IFJlc3Rv
cmluZyBwbGF0Zm9ybSBOVlMgbWVtb3J5CkV4dGVuZGVkIENNT1MgeWVhcjogMjAwMApFbmFibGlu
ZyBub24tYm9vdCBDUFVzIC4uLgpCb290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMSBBUElDIDB4NApz
bXBib290IGNwdSAxOiBzdGFydF9pcCA9IDk4MDAwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNr
aXBwZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0aGlzIENQVQpDUFUxIGlzIHVwCkJvb3RpbmcgTm9k
ZSAwIFByb2Nlc3NvciAyIEFQSUMgMHgxCnNtcGJvb3QgY3B1IDI6IHN0YXJ0X2lwID0gOTgwMDAK
Q2FsaWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tpcHBlZCkgYWxyZWFkeSBjYWxpYnJhdGVkIHRoaXMg
Q1BVCkNQVTIgaXMgdXAKQm9vdGluZyBOb2RlIDAgUHJvY2Vzc29yIDMgQVBJQyAweDUKc21wYm9v
dCBjcHUgMzogc3RhcnRfaXAgPSA5ODAwMApDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVk
KSBhbHJlYWR5IGNhbGlicmF0ZWQgdGhpcyBDUFUKQ1BVMyBpcyB1cApBQ1BJOiBXYWtpbmcgdXAg
ZnJvbSBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiB3YWtlLXVw
IGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQSQplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IHdha2Ut
dXAgY2FwYWJpbGl0eSBkaXNhYmxlZCBieSBBQ1BJClBNOiBlYXJseSByZXN1bWUgb2YgZGV2aWNl
cyBjb21wbGV0ZSBhZnRlciA2Ljg3MSBtc2VjcwplaGNpX2hjZCAwMDAwOjAwOjFhLjA6IHNldHRp
bmcgbGF0ZW5jeSB0aW1lciB0byA2NApwY2llaHAgMDAwMDowMDoxYy40OnBjaWUwNDogcGNpZWhw
X3Jlc3VtZSBFTlRSWQplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1l
ciB0byA2NAptZWkgMDAwMDowMDoxNi4wOiBpcnEgNDggZm9yIE1TSS9NU0ktWApwY2kgMDAwMDow
MDoxZS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKc25kX2hkYV9pbnRlbCAwMDAwOjAw
OjFiLjA6IGlycSA1MCBmb3IgTVNJL01TSS1YCmFoY2kgMDAwMDowMDoxZi4yOiBzZXR0aW5nIGxh
dGVuY3kgdGltZXIgdG8gNjQKc25kX2hkYV9pbnRlbCAwMDAwOjAxOjAwLjE6IGlycSA1MSBmb3Ig
TVNJL01TSS1YCnBjaWVwb3J0IDAwMDA6MDA6MWMuMjogd2FrZS11cCBjYXBhYmlsaXR5IGRpc2Fi
bGVkIGJ5IEFDUEkKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IFJGX0tJTEwgYml0IHRvZ2dsZWQgdG8g
ZGlzYWJsZSByYWRpby4KW2RybV0gUENJRSBHQVJUIG9mIDUxMk0gZW5hYmxlZCAodGFibGUgYXQg
MHgwMDAwMDAwMDAwMDQwMDAwKS4KcmFkZW9uIDAwMDA6MDE6MDAuMDogV0IgZW5hYmxlZApbZHJt
XSBmZW5jZSBkcml2ZXIgb24gcmluZyAwIHVzZSBncHUgYWRkciAweDQwMDAwYzAwIGFuZCBjcHUg
YWRkciAweGZmZmY4ODAxMGYwNDRjMDAKRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAwCltkcm1dIHJp
bmcgdGVzdCBvbiAwIHN1Y2NlZWRlZCBpbiAxIHVzZWNzCltkcm1dIGliIHRlc3Qgb24gcmluZyAw
IHN1Y2NlZWRlZCBpbiAwIHVzZWNzCltkcm1dIEVuYWJsaW5nIGF1ZGlvIHN1cHBvcnQKdXNiIDEt
MS42OiByZXNldCBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDQgdXNpbmcgZWhjaV9oY2QK
YXRhMjogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCmF0
YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTAwCmF0YTU6IFNBVEEgbGluayBkb3duIChTU3Rh
dHVzIDAgU0NvbnRyb2wgMzAwKQphdGExOiBTQVRBIGxpbmsgdXAgMy4wIEdicHMgKFNTdGF0dXMg
MTIzIFNDb250cm9sIDMwMCkKYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKc2QgMDow
OjA6MDogW3NkYV0gU3RhcnRpbmcgZGlzawpQTTogcmVzdW1lIG9mIGRldmljZXMgY29tcGxldGUg
YWZ0ZXIgMzc1MS43MTkgbXNlY3MKUE06IHJlc3VtZSBkZXZpY2VzIHRvb2sgMy43NTAgc2Vjb25k
cwpQTTogRmluaXNoaW5nIHdha2V1cC4KUmVzdGFydGluZyB0YXNrcyAuLi4gCnVzYiAxLTEuMjog
VVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgNQpkb25lLgp2aWRlbyBMTlhWSURFTzowMDog
UmVzdG9yaW5nIGJhY2tsaWdodCBzdGF0ZQpyODE2OSAwMDAwOjEzOjAwLjA6IGV0aDA6IGxpbmsg
ZG93bgpBRERSQ09ORihORVRERVZfVVApOiBldGgwOiBsaW5rIGlzIG5vdCByZWFkeQpFWFQ0LWZz
IChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8sdXNlcl94YXR0cixj
b21taXQ9NjAwCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3Vu
dC1ybyx1c2VyX3hhdHRyLGNvbW1pdD02MDAKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IFJGX0tJTEwg
Yml0IHRvZ2dsZWQgdG8gZW5hYmxlIHJhZGlvLgprZXlib2FyZDogY2FuJ3QgZW11bGF0ZSByYXdt
b2RlIGZvciBrZXljb2RlIDI0MAprZXlib2FyZDogY2FuJ3QgZW11bGF0ZSByYXdtb2RlIGZvciBr
ZXljb2RlIDI0MAphdGtiZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQg
c2V0IDIsIGNvZGUgMHg4ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdz
ZXRrZXljb2RlcyBlMDBkIDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KdXNiIDItMS42OiBu
ZXcgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAzIHVzaW5nIGVoY2lfaGNkCmh1YiAyLTEu
NjoxLjA6IFVTQiBodWIgZm91bmQKaHViIDItMS42OjEuMDogMyBwb3J0cyBkZXRlY3RlZAp1c2Ig
Mi0xLjYuMTogbmV3IGZ1bGwtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgNCB1c2luZyBlaGNpX2hj
ZAp1c2IgMi0xLjYuMjogbmV3IGZ1bGwtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgNSB1c2luZyBl
aGNpX2hjZAppbnB1dDogSElEIDQxM2M6ODE2MSBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6
MDA6MWQuMC91c2IyLzItMS8yLTEuNi8yLTEuNi4xLzItMS42LjE6MS4wL2lucHV0L2lucHV0MTIK
Z2VuZXJpYy11c2IgMDAwMzo0MTNDOjgxNjEuMDAwMTogaW5wdXQsaGlkcmF3MDogVVNCIEhJRCB2
MS4xMSBLZXlib2FyZCBbSElEIDQxM2M6ODE2MV0gb24gdXNiLTAwMDA6MDA6MWQuMC0xLjYuMS9p
bnB1dDAKaW5wdXQ6IEhJRCA0MTNjOjgxNjIgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAw
OjFkLjAvdXNiMi8yLTEvMi0xLjYvMi0xLjYuMi8yLTEuNi4yOjEuMC9pbnB1dC9pbnB1dDEzCmdl
bmVyaWMtdXNiIDAwMDM6NDEzQzo4MTYyLjAwMDI6IGlucHV0LGhpZHJhdzE6IFVTQiBISUQgdjEu
MTEgTW91c2UgW0hJRCA0MTNjOjgxNjJdIG9uIHVzYi0wMDAwOjAwOjFkLjAtMS42LjIvaW5wdXQw
CnVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkCnVzYmhpZDog
VVNCIEhJRCBjb3JlIGRyaXZlcgppd2x3aWZpIDAwMDA6MTI6MDAuMDogTDEgRGlzYWJsZWQ7IEVu
YWJsaW5nIEwwUwppd2x3aWZpIDAwMDA6MTI6MDAuMDogTDEgRGlzYWJsZWQ7IEVuYWJsaW5nIEww
UwpBRERSQ09ORihORVRERVZfVVApOiB3bGFuMDogbGluayBpcyBub3QgcmVhZHkKdXNiIDItMS42
LjM6IG5ldyBmdWxsLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDYgdXNpbmcgZWhjaV9oY2QKQmx1
ZXRvb3RoOiBDb3JlIHZlciAyLjE2Ck5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMzEK
Qmx1ZXRvb3RoOiBIQ0kgZGV2aWNlIGFuZCBjb25uZWN0aW9uIG1hbmFnZXIgaW5pdGlhbGl6ZWQK
Qmx1ZXRvb3RoOiBIQ0kgc29ja2V0IGxheWVyIGluaXRpYWxpemVkCkJsdWV0b290aDogTDJDQVAg
c29ja2V0IGxheWVyIGluaXRpYWxpemVkCkJsdWV0b290aDogU0NPIHNvY2tldCBsYXllciBpbml0
aWFsaXplZAp1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGJ0dXNiCkJs
dWV0b290aDogQk5FUCAoRXRoZXJuZXQgRW11bGF0aW9uKSB2ZXIgMS4zCkJsdWV0b290aDogQk5F
UCBmaWx0ZXJzOiBwcm90b2NvbCBtdWx0aWNhc3QKQmx1ZXRvb3RoOiBSRkNPTU0gVFRZIGxheWVy
IGluaXRpYWxpemVkCkJsdWV0b290aDogUkZDT01NIHNvY2tldCBsYXllciBpbml0aWFsaXplZApC
bHVldG9vdGg6IFJGQ09NTSB2ZXIgMS4xMQp3bGFuMDogYXV0aGVudGljYXRlIHdpdGggMDA6MTU6
YWY6NjY6MTU6ODMgKHRyeSAxKQp3bGFuMDogYXV0aGVudGljYXRlZAp3bGFuMDogYXNzb2NpYXRl
IHdpdGggMDA6MTU6YWY6NjY6MTU6ODMgKHRyeSAxKQp3bGFuMDogUlggQXNzb2NSZXNwIGZyb20g
MDA6MTU6YWY6NjY6MTU6ODMgKGNhcGFiPTB4MTEgc3RhdHVzPTAgYWlkPTMpCndsYW4wOiBhc3Nv
Y2lhdGVkCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRlIDEKd2xh
bjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6ODMgdG8gc3RhdGUgMgp3bGFuMDogbW92aW5n
IFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0byBzdGF0ZSAzCkFERFJDT05GKE5FVERFVl9DSEFOR0Up
OiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5CklQdjYgb3ZlciBJUHY0IHR1bm5lbGluZyBkcml2
ZXIKd2xhbjA6IGRlYXV0aGVudGljYXRpbmcgZnJvbSAwMDoxNTphZjo2NjoxNTo4MyBieSBsb2Nh
bCBjaG9pY2UgKHJlYXNvbj0zKQp3bGFuMDogbW92aW5nIFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0
byBzdGF0ZSAyCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRlIDEK
d2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6ODMgdG8gc3RhdGUgMApjZmc4MDIxMTog
QWxsIGRldmljZXMgYXJlIGRpc2Nvbm5lY3RlZCwgZ29pbmcgdG8gcmVzdG9yZSByZWd1bGF0b3J5
IHNldHRpbmdzCmNmZzgwMjExOiBSZXN0b3JpbmcgcmVndWxhdG9yeSBzZXR0aW5ncwpjZmc4MDIx
MTogQ2FsbGluZyBDUkRBIHRvIHVwZGF0ZSB3b3JsZCByZWd1bGF0b3J5IGRvbWFpbgpjZmc4MDIx
MTogSWdub3JpbmcgcmVndWxhdG9yeSByZXF1ZXN0IFNldCBieSBjb3JlIHNpbmNlIHRoZSBkcml2
ZXIgdXNlcyBpdHMgb3duIGN1c3RvbSByZWd1bGF0b3J5IGRvbWFpbgpjZmc4MDIxMTogV29ybGQg
cmVndWxhdG9yeSBkb21haW4gdXBkYXRlZDoKY2ZnODAyMTE6ICAgKHN0YXJ0X2ZyZXEgLSBlbmRf
ZnJlcSBAIGJhbmR3aWR0aCksIChtYXhfYW50ZW5uYV9nYWluLCBtYXhfZWlycCkKY2ZnODAyMTE6
ICAgKDI0MDIwMDAgS0h6IC0gMjQ3MjAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAw
MCBtQm0pCmNmZzgwMjExOiAgICgyNDU3MDAwIEtIeiAtIDI0ODIwMDAgS0h6IEAgMjAwMDAgS0h6
KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoMjQ3NDAwMCBLSHogLSAyNDk0MDAw
IEtIeiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDUxNzAw
MDAgS0h6IC0gNTI1MDAwMCBLSHogQCA0MDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNm
ZzgwMjExOiAgICg1NzM1MDAwIEtIeiAtIDU4MzUwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBt
QmksIDIwMDAgbUJtKQpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJl
bW91bnQtcm8sdXNlcl94YXR0cixjb21taXQ9MApQTTogU3luY2luZyBmaWxlc3lzdGVtcyAuLi4g
ZG9uZS4KUE06IFByZXBhcmluZyBzeXN0ZW0gZm9yIG1lbSBzbGVlcApGcmVlemluZyB1c2VyIHNw
YWNlIHByb2Nlc3NlcyAuLi4gKGVsYXBzZWQgMC4wMSBzZWNvbmRzKSBkb25lLgpGcmVlemluZyBy
ZW1haW5pbmcgZnJlZXphYmxlIHRhc2tzIC4uLiAoZWxhcHNlZCAwLjAxIHNlY29uZHMpIGRvbmUu
ClBNOiBFbnRlcmluZyBtZW0gc2xlZXAKU3VzcGVuZGluZyBjb25zb2xlKHMpICh1c2Ugbm9fY29u
c29sZV9zdXNwZW5kIHRvIGRlYnVnKQpzZCAwOjA6MDowOiBbc2RhXSBTeW5jaHJvbml6aW5nIFND
U0kgY2FjaGUKc2QgMDowOjA6MDogW3NkYV0gU3RvcHBpbmcgZGlzawpwY2llaHAgMDAwMDowMDox
Yy40OnBjaWUwNDogcGNpZWhwX3N1c3BlbmQgRU5UUlkKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRl
eHQhCkFDUEkgaGFuZGxlIGhhcyBubyBjb250ZXh0IQpbZHJtXSBEaXNhYmxpbmcgYXVkaW8gc3Vw
cG9ydApQTTogc3VzcGVuZCBvZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDYxOS43OTUgbXNlY3MK
UE06IHN1c3BlbmQgZGV2aWNlcyB0b29rIDAuNjIwIHNlY29uZHMKcGNpZXBvcnQgMDAwMDowMDox
Yy4yOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJCmVoY2lfaGNkIDAwMDA6MDA6
MWQuMDogd2FrZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQSQplaGNpX2hjZCAwMDAwOjAw
OjFhLjA6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkKUE06IGxhdGUgc3VzcGVu
ZCBvZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDEwMC4wMDEgbXNlY3MKQUNQSTogUHJlcGFyaW5n
IHRvIGVudGVyIHN5c3RlbSBzbGVlcCBzdGF0ZSBTMwpQTTogU2F2aW5nIHBsYXRmb3JtIE5WUyBt
ZW1vcnkKRGlzYWJsaW5nIG5vbi1ib290IENQVXMgLi4uCkNQVSAxIGlzIG5vdyBvZmZsaW5lCkNQ
VSAyIGlzIG5vdyBvZmZsaW5lCkNQVSAzIGlzIG5vdyBvZmZsaW5lCkV4dGVuZGVkIENNT1MgeWVh
cjogMjAwMApBQ1BJOiBMb3ctbGV2ZWwgcmVzdW1lIGNvbXBsZXRlClBNOiBSZXN0b3JpbmcgcGxh
dGZvcm0gTlZTIG1lbW9yeQpFeHRlbmRlZCBDTU9TIHllYXI6IDIwMDAKRW5hYmxpbmcgbm9uLWJv
b3QgQ1BVcyAuLi4KQm9vdGluZyBOb2RlIDAgUHJvY2Vzc29yIDEgQVBJQyAweDQKc21wYm9vdCBj
cHUgMTogc3RhcnRfaXAgPSA5ODAwMApDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBh
bHJlYWR5IGNhbGlicmF0ZWQgdGhpcyBDUFUKQ1BVMSBpcyB1cApCb290aW5nIE5vZGUgMCBQcm9j
ZXNzb3IgMiBBUElDIDB4MQpzbXBib290IGNwdSAyOiBzdGFydF9pcCA9IDk4MDAwCkNhbGlicmF0
aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0aGlzIENQVQpDUFUy
IGlzIHVwCkJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAzIEFQSUMgMHg1CnNtcGJvb3QgY3B1IDM6
IHN0YXJ0X2lwID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tpcHBlZCkgYWxyZWFk
eSBjYWxpYnJhdGVkIHRoaXMgQ1BVCkNQVTMgaXMgdXAKQUNQSTogV2FraW5nIHVwIGZyb20gc3lz
dGVtIHNsZWVwIHN0YXRlIFMzCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogd2FrZS11cCBjYXBhYmls
aXR5IGRpc2FibGVkIGJ5IEFDUEkKZWhjaV9oY2QgMDAwMDowMDoxZC4wOiB3YWtlLXVwIGNhcGFi
aWxpdHkgZGlzYWJsZWQgYnkgQUNQSQpQTTogZWFybHkgcmVzdW1lIG9mIGRldmljZXMgY29tcGxl
dGUgYWZ0ZXIgNi43NjQgbXNlY3MKZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVu
Y3kgdGltZXIgdG8gNjQKcGNpZWhwIDAwMDA6MDA6MWMuNDpwY2llMDQ6IHBjaWVocF9yZXN1bWUg
RU5UUlkKbWVpIDAwMDA6MDA6MTYuMDogaXJxIDQ4IGZvciBNU0kvTVNJLVgKZWhjaV9oY2QgMDAw
MDowMDoxZC4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKcGNpIDAwMDA6MDA6MWUuMDog
c2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0CmFoY2kgMDAwMDowMDoxZi4yOiBzZXR0aW5nIGxh
dGVuY3kgdGltZXIgdG8gNjQKc25kX2hkYV9pbnRlbCAwMDAwOjAwOjFiLjA6IGlycSA1MCBmb3Ig
TVNJL01TSS1YCml3bHdpZmkgMDAwMDoxMjowMC4wOiBSRl9LSUxMIGJpdCB0b2dnbGVkIHRvIGVu
YWJsZSByYWRpby4KcGNpZXBvcnQgMDAwMDowMDoxYy4yOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlz
YWJsZWQgYnkgQUNQSQpzbmRfaGRhX2ludGVsIDAwMDA6MDE6MDAuMTogaXJxIDUxIGZvciBNU0kv
TVNJLVgKW2RybV0gUENJRSBHQVJUIG9mIDUxMk0gZW5hYmxlZCAodGFibGUgYXQgMHgwMDAwMDAw
MDAwMDQwMDAwKS4KcmFkZW9uIDAwMDA6MDE6MDAuMDogV0IgZW5hYmxlZApbZHJtXSBmZW5jZSBk
cml2ZXIgb24gcmluZyAwIHVzZSBncHUgYWRkciAweDQwMDAwYzAwIGFuZCBjcHUgYWRkciAweGZm
ZmY4ODAxMGYwNDRjMDAKW2RybV0gcmluZyB0ZXN0IG9uIDAgc3VjY2VlZGVkIGluIDEgdXNlY3MK
W2RybV0gaWIgdGVzdCBvbiByaW5nIDAgc3VjY2VlZGVkIGluIDAgdXNlY3MKW2RybV0gRW5hYmxp
bmcgYXVkaW8gc3VwcG9ydApFeHRlbmRlZCBDTU9TIHllYXI6IDIwMDAKdXNiIDEtMS42OiByZXNl
dCBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDQgdXNpbmcgZWhjaV9oY2QKYXRhMjogU0FU
QSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJvbCAzMDApCmF0YTIuMDA6IGNv
bmZpZ3VyZWQgZm9yIFVETUEvMTAwCmF0YTU6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0Nv
bnRyb2wgMzAwKQp1c2IgMi0xLjY6IHJlc2V0IGZ1bGwtc3BlZWQgVVNCIGRldmljZSBudW1iZXIg
MyB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMjogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNl
IG51bWJlciA1IHVzaW5nIGVoY2lfaGNkCnVzYiAyLTEuNi4xOiByZXNldCBmdWxsLXNwZWVkIFVT
QiBkZXZpY2UgbnVtYmVyIDQgdXNpbmcgZWhjaV9oY2QKYXRhMTogU0FUQSBsaW5rIHVwIDMuMCBH
YnBzIChTU3RhdHVzIDEyMyBTQ29udHJvbCAzMDApCmF0YTEuMDA6IGNvbmZpZ3VyZWQgZm9yIFVE
TUEvMTMzCnNkIDA6MDowOjA6IFtzZGFdIFN0YXJ0aW5nIGRpc2sKUE06IHJlc3VtZSBvZiBkZXZp
Y2VzIGNvbXBsZXRlIGFmdGVyIDMyOTMuNzUzIG1zZWNzClBNOiByZXN1bWUgZGV2aWNlcyB0b29r
IDMuMzAwIHNlY29uZHMKUE06IEZpbmlzaGluZyB3YWtldXAuClJlc3RhcnRpbmcgdGFza3MgLi4u
IGRvbmUuCnVzYiAyLTEuNi4zOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA2CnZpZGVv
IExOWFZJREVPOjAwOiBSZXN0b3JpbmcgYmFja2xpZ2h0IHN0YXRlCnVzYiAyLTEuNi4zOiBuZXcg
ZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA3IHVzaW5nIGVoY2lfaGNkCml3bHdpZmkgMDAw
MDoxMjowMC4wOiBMMSBEaXNhYmxlZDsgRW5hYmxpbmcgTDBTCkFERFJDT05GKE5FVERFVl9VUCk6
IHdsYW4wOiBsaW5rIGlzIG5vdCByZWFkeQpyODE2OSAwMDAwOjEzOjAwLjA6IGV0aDA6IGxpbmsg
ZG93bgpBRERSQ09ORihORVRERVZfVVApOiBldGgwOiBsaW5rIGlzIG5vdCByZWFkeQp3bGFuMDog
YXV0aGVudGljYXRlIHdpdGggMDA6MTU6YWY6NjY6MTU6ODMgKHRyeSAxKQp3bGFuMDogYXV0aGVu
dGljYXRlZAp3bGFuMDogYXNzb2NpYXRlIHdpdGggMDA6MTU6YWY6NjY6MTU6ODMgKHRyeSAxKQp3
bGFuMDogUlggQXNzb2NSZXNwIGZyb20gMDA6MTU6YWY6NjY6MTU6ODMgKGNhcGFiPTB4MTEgc3Rh
dHVzPTAgYWlkPTIpCndsYW4wOiBhc3NvY2lhdGVkCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFm
OjY2OjE1OjgzIHRvIHN0YXRlIDEKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6ODMg
dG8gc3RhdGUgMgp3bGFuMDogbW92aW5nIFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0byBzdGF0ZSAz
CkFERFJDT05GKE5FVERFVl9DSEFOR0UpOiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5CkVYVDQt
ZnMgKHNkYTEpOiByZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRy
LGNvbW1pdD02MDAKd2xhbjA6IG5vIElQdjYgcm91dGVycyBwcmVzZW50CndsYW4wOiBkZWF1dGhl
bnRpY2F0aW5nIGZyb20gMDA6MTU6YWY6NjY6MTU6ODMgYnkgbG9jYWwgY2hvaWNlIChyZWFzb249
MykKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6ODMgdG8gc3RhdGUgMgp3bGFuMDog
bW92aW5nIFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0byBzdGF0ZSAxCndsYW4wOiBtb3ZpbmcgU1RB
IDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRlIDAKY2ZnODAyMTE6IEFsbCBkZXZpY2VzIGFyZSBk
aXNjb25uZWN0ZWQsIGdvaW5nIHRvIHJlc3RvcmUgcmVndWxhdG9yeSBzZXR0aW5ncwpjZmc4MDIx
MTogUmVzdG9yaW5nIHJlZ3VsYXRvcnkgc2V0dGluZ3MKY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0
byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBkb21haW4KY2ZnODAyMTE6IElnbm9yaW5nIHJlZ3Vs
YXRvcnkgcmVxdWVzdCBTZXQgYnkgY29yZSBzaW5jZSB0aGUgZHJpdmVyIHVzZXMgaXRzIG93biBj
dXN0b20gcmVndWxhdG9yeSBkb21haW4KY2ZnODAyMTE6IFdvcmxkIHJlZ3VsYXRvcnkgZG9tYWlu
IHVwZGF0ZWQ6CmNmZzgwMjExOiAgIChzdGFydF9mcmVxIC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgp
LCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2VpcnApCmNmZzgwMjExOiAgICgyNDAyMDAwIEtIeiAt
IDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTog
ICAoMjQ1NzAwMCBLSHogLSAyNDgyMDAwIEtIeiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAw
IG1CbSkKY2ZnODAyMTE6ICAgKDI0NzQwMDAgS0h6IC0gMjQ5NDAwMCBLSHogQCAyMDAwMCBLSHop
LCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgwMjExOiAgICg1MTcwMDAwIEtIeiAtIDUyNTAwMDAg
S0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoNTczNTAw
MCBLSHogLSA1ODM1MDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKYXRr
YmQgc2VyaW8wOiBVbmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4
OGQgb24gaXNhMDA2MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAw
ZCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uCkVYVDQtZnMgKHNkYTEpOiByZS1tb3VudGVk
LiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0wClBNOiBTeW5jaW5n
IGZpbGVzeXN0ZW1zIC4uLiBkb25lLgpQTTogUHJlcGFyaW5nIHN5c3RlbSBmb3IgbWVtIHNsZWVw
CkZyZWV6aW5nIHVzZXIgc3BhY2UgcHJvY2Vzc2VzIC4uLiAoZWxhcHNlZCAwLjAxIHNlY29uZHMp
IGRvbmUuCkZyZWV6aW5nIHJlbWFpbmluZyBmcmVlemFibGUgdGFza3MgLi4uIChlbGFwc2VkIDAu
MDEgc2Vjb25kcykgZG9uZS4KUE06IEVudGVyaW5nIG1lbSBzbGVlcApTdXNwZW5kaW5nIGNvbnNv
bGUocykgKHVzZSBub19jb25zb2xlX3N1c3BlbmQgdG8gZGVidWcpCnNkIDA6MDowOjA6IFtzZGFd
IFN5bmNocm9uaXppbmcgU0NTSSBjYWNoZQpzZCAwOjA6MDowOiBbc2RhXSBTdG9wcGluZyBkaXNr
CkFDUEkgaGFuZGxlIGhhcyBubyBjb250ZXh0IQpwY2llaHAgMDAwMDowMDoxYy40OnBjaWUwNDog
cGNpZWhwX3N1c3BlbmQgRU5UUlkKQUNQSSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCltkcm1dIERp
c2FibGluZyBhdWRpbyBzdXBwb3J0ClBNOiBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0
ZXIgNjE5Ljc4NiBtc2VjcwpQTTogc3VzcGVuZCBkZXZpY2VzIHRvb2sgMC42MjAgc2Vjb25kcwpw
Y2llcG9ydCAwMDAwOjAwOjFjLjI6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkK
ZWhjaV9oY2QgMDAwMDowMDoxZC4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJ
CmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogd2FrZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQ
SQpQTTogbGF0ZSBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgOTkuOTA1IG1zZWNz
CkFDUEk6IFByZXBhcmluZyB0byBlbnRlciBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMKUE06IFNhdmlu
ZyBwbGF0Zm9ybSBOVlMgbWVtb3J5CkRpc2FibGluZyBub24tYm9vdCBDUFVzIC4uLgpDUFUgMSBp
cyBub3cgb2ZmbGluZQpDUFUgMiBpcyBub3cgb2ZmbGluZQpDUFUgMyBpcyBub3cgb2ZmbGluZQpF
eHRlbmRlZCBDTU9TIHllYXI6IDIwMDAKQUNQSTogTG93LWxldmVsIHJlc3VtZSBjb21wbGV0ZQpQ
TTogUmVzdG9yaW5nIHBsYXRmb3JtIE5WUyBtZW1vcnkKRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAw
CkVuYWJsaW5nIG5vbi1ib290IENQVXMgLi4uCkJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAxIEFQ
SUMgMHg0CnNtcGJvb3QgY3B1IDE6IHN0YXJ0X2lwID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkg
bG9vcCAoc2tpcHBlZCkgYWxyZWFkeSBjYWxpYnJhdGVkIHRoaXMgQ1BVCkNQVTEgaXMgdXAKQm9v
dGluZyBOb2RlIDAgUHJvY2Vzc29yIDIgQVBJQyAweDEKc21wYm9vdCBjcHUgMjogc3RhcnRfaXAg
PSA5ODAwMApDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNhbGlicmF0
ZWQgdGhpcyBDUFUKQ1BVMiBpcyB1cApCb290aW5nIE5vZGUgMCBQcm9jZXNzb3IgMyBBUElDIDB4
NQpzbXBib290IGNwdSAzOiBzdGFydF9pcCA9IDk4MDAwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3Ag
KHNraXBwZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0aGlzIENQVQpDUFUzIGlzIHVwCkFDUEk6IFdh
a2luZyB1cCBmcm9tIHN5c3RlbSBzbGVlcCBzdGF0ZSBTMwplaGNpX2hjZCAwMDAwOjAwOjFhLjA6
IHdha2UtdXAgY2FwYWJpbGl0eSBkaXNhYmxlZCBieSBBQ1BJCmVoY2lfaGNkIDAwMDA6MDA6MWQu
MDogd2FrZS11cCBjYXBhYmlsaXR5IGRpc2FibGVkIGJ5IEFDUEkKUE06IGVhcmx5IHJlc3VtZSBv
ZiBkZXZpY2VzIGNvbXBsZXRlIGFmdGVyIDYuODgxIG1zZWNzCm1laSAwMDAwOjAwOjE2LjA6IGly
cSA0OCBmb3IgTVNJL01TSS1YCmVoY2lfaGNkIDAwMDA6MDA6MWEuMDogc2V0dGluZyBsYXRlbmN5
IHRpbWVyIHRvIDY0CnNuZF9oZGFfaW50ZWwgMDAwMDowMDoxYi4wOiBpcnEgNTAgZm9yIE1TSS9N
U0ktWApwY2llaHAgMDAwMDowMDoxYy40OnBjaWUwNDogcGNpZWhwX3Jlc3VtZSBFTlRSWQplaGNp
X2hjZCAwMDAwOjAwOjFkLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApwY2kgMDAwMDow
MDoxZS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKYWhjaSAwMDAwOjAwOjFmLjI6IHNl
dHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApzbmRfaGRhX2ludGVsIDAwMDA6MDE6MDAuMTogaXJx
IDUxIGZvciBNU0kvTVNJLVgKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IFJGX0tJTEwgYml0IHRvZ2ds
ZWQgdG8gZW5hYmxlIHJhZGlvLgpwY2llcG9ydCAwMDAwOjAwOjFjLjI6IHdha2UtdXAgY2FwYWJp
bGl0eSBkaXNhYmxlZCBieSBBQ1BJCltkcm1dIFBDSUUgR0FSVCBvZiA1MTJNIGVuYWJsZWQgKHRh
YmxlIGF0IDB4MDAwMDAwMDAwMDA0MDAwMCkuCnJhZGVvbiAwMDAwOjAxOjAwLjA6IFdCIGVuYWJs
ZWQKW2RybV0gZmVuY2UgZHJpdmVyIG9uIHJpbmcgMCB1c2UgZ3B1IGFkZHIgMHg0MDAwMGMwMCBh
bmQgY3B1IGFkZHIgMHhmZmZmODgwMTBmMDQ0YzAwCltkcm1dIHJpbmcgdGVzdCBvbiAwIHN1Y2Nl
ZWRlZCBpbiAxIHVzZWNzCltkcm1dIGliIHRlc3Qgb24gcmluZyAwIHN1Y2NlZWRlZCBpbiAwIHVz
ZWNzCltkcm1dIEVuYWJsaW5nIGF1ZGlvIHN1cHBvcnQKRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAw
CnVzYiAyLTEuNjogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAzIHVzaW5nIGVo
Y2lfaGNkCmF0YTU6IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAwKQphdGEy
OiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNTdGF0dXMgMTEzIFNDb250cm9sIDMwMCkKYXRhMi4w
MDogY29uZmlndXJlZCBmb3IgVURNQS8xMDAKdXNiIDEtMS42OiByZXNldCBoaWdoLXNwZWVkIFVT
QiBkZXZpY2UgbnVtYmVyIDQgdXNpbmcgZWhjaV9oY2QKdXNiIDItMS42LjE6IHJlc2V0IGZ1bGwt
c3BlZWQgVVNCIGRldmljZSBudW1iZXIgNCB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMjogcmVz
ZXQgZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA1IHVzaW5nIGVoY2lfaGNkCmF0YTE6IFNB
VEEgbGluayB1cCAzLjAgR2JwcyAoU1N0YXR1cyAxMjMgU0NvbnRyb2wgMzAwKQphdGExLjAwOiBj
b25maWd1cmVkIGZvciBVRE1BLzEzMwpzZCAwOjA6MDowOiBbc2RhXSBTdGFydGluZyBkaXNrClBN
OiByZXN1bWUgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciAzMzA1LjA2MyBtc2VjcwpQTTogcmVz
dW1lIGRldmljZXMgdG9vayAzLjMxMCBzZWNvbmRzClBNOiBGaW5pc2hpbmcgd2FrZXVwLgpSZXN0
YXJ0aW5nIHRhc2tzIC4uLiBkb25lLgp2aWRlbyBMTlhWSURFTzowMDogUmVzdG9yaW5nIGJhY2ts
aWdodCBzdGF0ZQp1c2IgMi0xLjI6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDgg
dXNpbmcgZWhjaV9oY2QKc2NzaTggOiB1c2Itc3RvcmFnZSAyLTEuMjoxLjAKdXNiIDItMS42LjM6
IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDcKdXNiIDItMS42LjM6IG5ldyBmdWxsLXNw
ZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDkgdXNpbmcgZWhjaV9oY2QKaXdsd2lmaSAwMDAwOjEyOjAw
LjA6IEwxIERpc2FibGVkOyBFbmFibGluZyBMMFMKQUREUkNPTkYoTkVUREVWX1VQKTogd2xhbjA6
IGxpbmsgaXMgbm90IHJlYWR5CnI4MTY5IDAwMDA6MTM6MDAuMDogZXRoMDogbGluayBkb3duCkFE
RFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxpbmsgaXMgbm90IHJlYWR5CnNjc2kgODowOjA6MDog
RGlyZWN0LUFjY2VzcyAgICAgICAgICAgICAgSWRlb3MgICAgICAgICAgICAwMDAwIFBROiAwIEFO
U0k6IDIKc2NzaSA4OjA6MDoxOiBDRC1ST00gICAgICAgICAgICAgICAgICAgICBJZGVvcyAgICAg
ICAgICAgIDAwMDAgUFE6IDAgQU5TSTogMgpzZCA4OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVy
aWMgc2cyIHR5cGUgMApzcjE6IHNjc2kzLW1tYyBkcml2ZTogMHgvMHggY2FkZHkKc3IgODowOjA6
MTogQXR0YWNoZWQgc2NzaSBDRC1ST00gc3IxCnNyIDg6MDowOjE6IEF0dGFjaGVkIHNjc2kgZ2Vu
ZXJpYyBzZzMgdHlwZSA1CnNkIDg6MDowOjA6IFtzZGJdIEF0dGFjaGVkIFNDU0kgcmVtb3ZhYmxl
IGRpc2sKd2xhbjA6IGF1dGhlbnRpY2F0ZSB3aXRoIDAwOjE1OmFmOjY2OjE1OjgzICh0cnkgMSkK
d2xhbjA6IGF1dGhlbnRpY2F0ZWQKd2xhbjA6IGFzc29jaWF0ZSB3aXRoIDAwOjE1OmFmOjY2OjE1
OjgzICh0cnkgMSkKd2xhbjA6IFJYIEFzc29jUmVzcCBmcm9tIDAwOjE1OmFmOjY2OjE1OjgzIChj
YXBhYj0weDExIHN0YXR1cz0wIGFpZD0yKQp3bGFuMDogYXNzb2NpYXRlZAp3bGFuMDogbW92aW5n
IFNUQSAwMDoxNTphZjo2NjoxNTo4MyB0byBzdGF0ZSAxCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1
OmFmOjY2OjE1OjgzIHRvIHN0YXRlIDIKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6YWY6NjY6MTU6
ODMgdG8gc3RhdGUgMwpBRERSQ09ORihORVRERVZfQ0hBTkdFKTogd2xhbjA6IGxpbmsgYmVjb21l
cyByZWFkeQpFWFQ0LWZzIChzZGExKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQt
cm8sdXNlcl94YXR0cixjb21taXQ9NjAwCndsYW4wOiBubyBJUHY2IHJvdXRlcnMgcHJlc2VudApb
RmlybXdhcmUgQnVnXTogYmF0dGVyeTogKGRpcyljaGFyZ2UgcmF0ZSBpbnZhbGlkLgphdGtiZCBz
ZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4ZCBv
biBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBkIDxr
ZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KRVhUNC1mcyAoc2RhMSk6IHJlLW1vdW50ZWQuIE9w
dHM6IGVycm9ycz1yZW1vdW50LXJvLHVzZXJfeGF0dHIsY29tbWl0PTAKYXRrYmQgc2VyaW8wOiBV
bmtub3duIGtleSBwcmVzc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4OGQgb24gaXNhMDA2
MC9zZXJpbzApLgphdGtiZCBzZXJpbzA6IFVzZSAnc2V0a2V5Y29kZXMgZTAwZCA8a2V5Y29kZT4n
IHRvIG1ha2UgaXQga25vd24uCmF0a2JkIHNlcmlvMDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJh
bnNsYXRlZCBzZXQgMiwgY29kZSAweDhkIG9uIGlzYTAwNjAvc2VyaW8wKS4KYXRrYmQgc2VyaW8w
OiBVc2UgJ3NldGtleWNvZGVzIGUwMGQgPGtleWNvZGU+JyB0byBtYWtlIGl0IGtub3duLgphdGti
ZCBzZXJpbzA6IFVua25vd24ga2V5IHByZXNzZWQgKHRyYW5zbGF0ZWQgc2V0IDIsIGNvZGUgMHg4
ZCBvbiBpc2EwMDYwL3NlcmlvMCkuCmF0a2JkIHNlcmlvMDogVXNlICdzZXRrZXljb2RlcyBlMDBk
IDxrZXljb2RlPicgdG8gbWFrZSBpdCBrbm93bi4KdXNiIDItMS4yOiBVU0IgZGlzY29ubmVjdCwg
ZGV2aWNlIG51bWJlciA4CndsYW4wOiBkZWF1dGhlbnRpY2F0aW5nIGZyb20gMDA6MTU6YWY6NjY6
MTU6ODMgYnkgbG9jYWwgY2hvaWNlIChyZWFzb249MykKd2xhbjA6IG1vdmluZyBTVEEgMDA6MTU6
YWY6NjY6MTU6ODMgdG8gc3RhdGUgMgp3bGFuMDogbW92aW5nIFNUQSAwMDoxNTphZjo2NjoxNTo4
MyB0byBzdGF0ZSAxCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1OjgzIHRvIHN0YXRl
IDAKY2ZnODAyMTE6IEFsbCBkZXZpY2VzIGFyZSBkaXNjb25uZWN0ZWQsIGdvaW5nIHRvIHJlc3Rv
cmUgcmVndWxhdG9yeSBzZXR0aW5ncwpjZmc4MDIxMTogUmVzdG9yaW5nIHJlZ3VsYXRvcnkgc2V0
dGluZ3MKY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBk
b21haW4KY2ZnODAyMTE6IElnbm9yaW5nIHJlZ3VsYXRvcnkgcmVxdWVzdCBTZXQgYnkgY29yZSBz
aW5jZSB0aGUgZHJpdmVyIHVzZXMgaXRzIG93biBjdXN0b20gcmVndWxhdG9yeSBkb21haW4KY2Zn
ODAyMTE6IFdvcmxkIHJlZ3VsYXRvcnkgZG9tYWluIHVwZGF0ZWQ6CmNmZzgwMjExOiAgIChzdGFy
dF9mcmVxIC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2Vp
cnApCmNmZzgwMjExOiAgICgyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAgNDAwMDAgS0h6KSwg
KDMwMCBtQmksIDIwMDAgbUJtKQpjZmc4MDIxMTogICAoMjQ1NzAwMCBLSHogLSAyNDgyMDAwIEtI
eiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKY2ZnODAyMTE6ICAgKDI0NzQwMDAg
S0h6IC0gMjQ5NDAwMCBLSHogQCAyMDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pCmNmZzgw
MjExOiAgICg1MTcwMDAwIEtIeiAtIDUyNTAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmks
IDIwMDAgbUJtKQpjZmc4MDIxMTogICAoNTczNTAwMCBLSHogLSA1ODM1MDAwIEtIeiBAIDQwMDAw
IEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKRVhUNC1mcyAoc2RhMSk6IHJlLW1vdW50ZWQuIE9w
dHM6IGVycm9ycz1yZW1vdW50LXJvLHVzZXJfeGF0dHIsY29tbWl0PTAKUE06IFN5bmNpbmcgZmls
ZXN5c3RlbXMgLi4uIGRvbmUuClBNOiBQcmVwYXJpbmcgc3lzdGVtIGZvciBtZW0gc2xlZXAKRnJl
ZXppbmcgdXNlciBzcGFjZSBwcm9jZXNzZXMgLi4uIChlbGFwc2VkIDAuMjMgc2Vjb25kcykgZG9u
ZS4KRnJlZXppbmcgcmVtYWluaW5nIGZyZWV6YWJsZSB0YXNrcyAuLi4gKGVsYXBzZWQgMC4wMSBz
ZWNvbmRzKSBkb25lLgpQTTogRW50ZXJpbmcgbWVtIHNsZWVwClN1c3BlbmRpbmcgY29uc29sZShz
KSAodXNlIG5vX2NvbnNvbGVfc3VzcGVuZCB0byBkZWJ1ZykKc2QgMDowOjA6MDogW3NkYV0gU3lu
Y2hyb25pemluZyBTQ1NJIGNhY2hlCnNkIDA6MDowOjA6IFtzZGFdIFN0b3BwaW5nIGRpc2sKQUNQ
SSBoYW5kbGUgaGFzIG5vIGNvbnRleHQhCnBjaWVocCAwMDAwOjAwOjFjLjQ6cGNpZTA0OiBwY2ll
aHBfc3VzcGVuZCBFTlRSWQpBQ1BJIGhhbmRsZSBoYXMgbm8gY29udGV4dCEKW2RybV0gRGlzYWJs
aW5nIGF1ZGlvIHN1cHBvcnQKUE06IHN1c3BlbmQgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciA2
NzkuODU4IG1zZWNzClBNOiBzdXNwZW5kIGRldmljZXMgdG9vayAwLjY4MCBzZWNvbmRzCnBjaWVw
b3J0IDAwMDA6MDA6MWMuMjogd2FrZS11cCBjYXBhYmlsaXR5IGVuYWJsZWQgYnkgQUNQSQplaGNp
X2hjZCAwMDAwOjAwOjFkLjA6IHdha2UtdXAgY2FwYWJpbGl0eSBlbmFibGVkIGJ5IEFDUEkKZWhj
aV9oY2QgMDAwMDowMDoxYS4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZW5hYmxlZCBieSBBQ1BJClBN
OiBsYXRlIHN1c3BlbmQgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciA5OS44NjkgbXNlY3MKQUNQ
STogUHJlcGFyaW5nIHRvIGVudGVyIHN5c3RlbSBzbGVlcCBzdGF0ZSBTMwpQTTogU2F2aW5nIHBs
YXRmb3JtIE5WUyBtZW1vcnkKRGlzYWJsaW5nIG5vbi1ib290IENQVXMgLi4uCkNQVSAxIGlzIG5v
dyBvZmZsaW5lCkNQVSAyIGlzIG5vdyBvZmZsaW5lCkJyb2tlIGFmZmluaXR5IGZvciBpcnEgNDcK
Q1BVIDMgaXMgbm93IG9mZmxpbmUKRXh0ZW5kZWQgQ01PUyB5ZWFyOiAyMDAwCkFDUEk6IExvdy1s
ZXZlbCByZXN1bWUgY29tcGxldGUKUE06IFJlc3RvcmluZyBwbGF0Zm9ybSBOVlMgbWVtb3J5CkV4
dGVuZGVkIENNT1MgeWVhcjogMjAwMApFbmFibGluZyBub24tYm9vdCBDUFVzIC4uLgpCb290aW5n
IE5vZGUgMCBQcm9jZXNzb3IgMSBBUElDIDB4NApzbXBib290IGNwdSAxOiBzdGFydF9pcCA9IDk4
MDAwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpIGFscmVhZHkgY2FsaWJyYXRlZCB0
aGlzIENQVQpDUFUxIGlzIHVwCkJvb3RpbmcgTm9kZSAwIFByb2Nlc3NvciAyIEFQSUMgMHgxCnNt
cGJvb3QgY3B1IDI6IHN0YXJ0X2lwID0gOTgwMDAKQ2FsaWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tp
cHBlZCkgYWxyZWFkeSBjYWxpYnJhdGVkIHRoaXMgQ1BVCkNQVTIgaXMgdXAKQm9vdGluZyBOb2Rl
IDAgUHJvY2Vzc29yIDMgQVBJQyAweDUKc21wYm9vdCBjcHUgMzogc3RhcnRfaXAgPSA5ODAwMApD
YWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBhbHJlYWR5IGNhbGlicmF0ZWQgdGhpcyBD
UFUKQ1BVMyBpcyB1cApBQ1BJOiBXYWtpbmcgdXAgZnJvbSBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMK
ZWhjaV9oY2QgMDAwMDowMDoxYS4wOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQ
SQplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IHdha2UtdXAgY2FwYWJpbGl0eSBkaXNhYmxlZCBieSBB
Q1BJClBNOiBlYXJseSByZXN1bWUgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciA2LjcwOSBtc2Vj
cwptZWkgMDAwMDowMDoxNi4wOiBpcnEgNDggZm9yIE1TSS9NU0ktWAplaGNpX2hjZCAwMDAwOjAw
OjFhLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApwY2llaHAgMDAwMDowMDoxYy40OnBj
aWUwNDogcGNpZWhwX3Jlc3VtZSBFTlRSWQplaGNpX2hjZCAwMDAwOjAwOjFkLjA6IHNldHRpbmcg
bGF0ZW5jeSB0aW1lciB0byA2NApwY2kgMDAwMDowMDoxZS4wOiBzZXR0aW5nIGxhdGVuY3kgdGlt
ZXIgdG8gNjQKYWhjaSAwMDAwOjAwOjFmLjI6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApz
bmRfaGRhX2ludGVsIDAwMDA6MDA6MWIuMDogaXJxIDUwIGZvciBNU0kvTVNJLVgKcGNpZXBvcnQg
MDAwMDowMDoxYy4yOiB3YWtlLXVwIGNhcGFiaWxpdHkgZGlzYWJsZWQgYnkgQUNQSQppd2x3aWZp
IDAwMDA6MTI6MDAuMDogUkZfS0lMTCBiaXQgdG9nZ2xlZCB0byBlbmFibGUgcmFkaW8uCnNuZF9o
ZGFfaW50ZWwgMDAwMDowMTowMC4xOiBpcnEgNTEgZm9yIE1TSS9NU0ktWApbZHJtXSBQQ0lFIEdB
UlQgb2YgNTEyTSBlbmFibGVkICh0YWJsZSBhdCAweDAwMDAwMDAwMDAwNDAwMDApLgpyYWRlb24g
MDAwMDowMTowMC4wOiBXQiBlbmFibGVkCltkcm1dIGZlbmNlIGRyaXZlciBvbiByaW5nIDAgdXNl
IGdwdSBhZGRyIDB4NDAwMDBjMDAgYW5kIGNwdSBhZGRyIDB4ZmZmZjg4MDEwZjA0NGMwMApbZHJt
XSByaW5nIHRlc3Qgb24gMCBzdWNjZWVkZWQgaW4gMSB1c2VjcwpbZHJtXSBpYiB0ZXN0IG9uIHJp
bmcgMCBzdWNjZWVkZWQgaW4gMCB1c2VjcwpbZHJtXSBFbmFibGluZyBhdWRpbyBzdXBwb3J0CnVz
YiAxLTEuNjogcmVzZXQgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA0IHVzaW5nIGVoY2lf
aGNkCmF0YTI6IFNBVEEgbGluayB1cCAxLjUgR2JwcyAoU1N0YXR1cyAxMTMgU0NvbnRyb2wgMzAw
KQphdGEyLjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEwMAphdGE1OiBTQVRBIGxpbmsgZG93biAo
U1N0YXR1cyAwIFNDb250cm9sIDMwMCkKdXNiIDItMS42OiByZXNldCBmdWxsLXNwZWVkIFVTQiBk
ZXZpY2UgbnVtYmVyIDMgdXNpbmcgZWhjaV9oY2QKdXNiIDItMS42LjE6IHJlc2V0IGZ1bGwtc3Bl
ZWQgVVNCIGRldmljZSBudW1iZXIgNCB1c2luZyBlaGNpX2hjZAp1c2IgMi0xLjYuMjogcmVzZXQg
ZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA1IHVzaW5nIGVoY2lfaGNkCmF0YTE6IFNBVEEg
bGluayB1cCAzLjAgR2JwcyAoU1N0YXR1cyAxMjMgU0NvbnRyb2wgMzAwKQphdGExLjAwOiBjb25m
aWd1cmVkIGZvciBVRE1BLzEzMwpzZCAwOjA6MDowOiBbc2RhXSBTdGFydGluZyBkaXNrClBNOiBy
ZXN1bWUgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciAzNDE2LjM2MiBtc2VjcwpQTTogcmVzdW1l
IGRldmljZXMgdG9vayAzLjQyMCBzZWNvbmRzClBNOiBGaW5pc2hpbmcgd2FrZXVwLgpSZXN0YXJ0
aW5nIHRhc2tzIC4uLiBkb25lLgp1c2IgMi0xLjYuMzogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBu
dW1iZXIgOQp2aWRlbyBMTlhWSURFTzowMDogUmVzdG9yaW5nIGJhY2tsaWdodCBzdGF0ZQp1c2Ig
Mi0xLjYuMzogbmV3IGZ1bGwtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMTAgdXNpbmcgZWhjaV9o
Y2QKaXdsd2lmaSAwMDAwOjEyOjAwLjA6IEwxIERpc2FibGVkOyBFbmFibGluZyBMMFMKQUREUkNP
TkYoTkVUREVWX1VQKTogd2xhbjA6IGxpbmsgaXMgbm90IHJlYWR5CnI4MTY5IDAwMDA6MTM6MDAu
MDogZXRoMDogbGluayBkb3duCkFERFJDT05GKE5FVERFVl9VUCk6IGV0aDA6IGxpbmsgaXMgbm90
IHJlYWR5CndsYW4wOiBhdXRoZW50aWNhdGUgd2l0aCAwMDoxNTphZjo2NjoxNTo4MyAodHJ5IDEp
CndsYW4wOiBhdXRoZW50aWNhdGVkCndsYW4wOiBhc3NvY2lhdGUgd2l0aCAwMDoxNTphZjo2Njox
NTo4MyAodHJ5IDEpCndsYW4wOiBSWCBBc3NvY1Jlc3AgZnJvbSAwMDoxNTphZjo2NjoxNTo4MyAo
Y2FwYWI9MHgxMSBzdGF0dXM9MCBhaWQ9MikKd2xhbjA6IGFzc29jaWF0ZWQKd2xhbjA6IG1vdmlu
ZyBTVEEgMDA6MTU6YWY6NjY6MTU6ODMgdG8gc3RhdGUgMQp3bGFuMDogbW92aW5nIFNUQSAwMDox
NTphZjo2NjoxNTo4MyB0byBzdGF0ZSAyCndsYW4wOiBtb3ZpbmcgU1RBIDAwOjE1OmFmOjY2OjE1
OjgzIHRvIHN0YXRlIDMKQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IHdsYW4wOiBsaW5rIGJlY29t
ZXMgcmVhZHkKd2xhbjA6IG5vIElQdjYgcm91dGVycyBwcmVzZW50CkVYVDQtZnMgKHNkYTEpOiBy
ZS1tb3VudGVkLiBPcHRzOiBlcnJvcnM9cmVtb3VudC1ybyx1c2VyX3hhdHRyLGNvbW1pdD0wCg==
--20cf3074b3162a6b8504c194b87b--
