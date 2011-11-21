Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1KUUgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:36:13 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60305 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1KUUgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:36:11 -0500
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 21:36:10 +0100
Message-ID: <CAJfGthSyZN7eLj1rSE=+bcbv55Hs-nZXtKtrTS2hm71Q7M1e2w@mail.gmail.com>
Subject: [bugreport] 3.2_rc2 and several previous versions: Intel 945GC blanks
 screen after trying to initialize KMS. Kernel trace is printed and X.org
 server does not find screen.
From: Xander Hover <lkml@hover.be>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know if I am directing this bug report to the right person but
here it goes.

I have just tried kernel 3.2_rc2 to find out if this problem still
holds, and it does.
I have a foxconn motherboard with an Atom 330 + 945GC onboard graphics.

I started to use the recent i915 driver with KMS, got a blank screen,
X.org finds no screen
when using the latest intel drivers and so on. However I noticed the
following during some experimentation:

1. If I add the kernel boot option: 'acpi=off', everything works
(except acpi obviously)
2. If I use 'acpi=ht' (I know it has been removed from the recent
kernels, but I reverted the patch in my local git clone for this
experiment)
    everything works.
3. If I use 'pci=noacpi', everything works
4. If I use 'acpi=noirq', I have the problem
5. If I use 'pnpacpi=off', or 'noapic' or 'nolapic', I also have the problem.

So for know, I stick with the 'pci=noacpi' to have a working KMS and X.org.

Also, an other atom 330 and i945 chipset based nettop, which has an
original Intel board instead of the foxconn, works flawless.
Below I have included the kernel trace that is dumped due to the bug.

Kind regards,

Xander Hover


Nov 21 20:41:16 Marge kernel: [    1.240640] Linux agpgart interface v0.103
Nov 21 20:41:16 Marge kernel: [    1.240825] agpgart-intel
0000:00:00.0: Intel 945G Chipset
Nov 21 20:41:16 Marge kernel: [    1.241150] agpgart-intel
0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
Nov 21 20:41:16 Marge kernel: [    1.241557] agpgart-intel
0000:00:00.0: detected 8192K stolen memory
Nov 21 20:41:16 Marge kernel: [    1.242064] agpgart-intel
0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Nov 21 20:41:16 Marge kernel: [    1.242498] [drm] Initialized drm
1.1.0 20060810
Nov 21 20:41:16 Marge kernel: [    1.242673] i915 0000:00:02.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Nov 21 20:41:16 Marge kernel: [    1.242796] i915 0000:00:02.0:
setting latency timer to 64
Nov 21 20:41:16 Marge kernel: [    1.287604] [drm] Supports vblank
timestamp caching Rev 1 (10.10.2010).
Nov 21 20:41:16 Marge kernel: [    1.287728] [drm] Driver supports
precise vblank timestamp query.
Nov 21 20:41:16 Marge kernel: [    1.293392] vgaarb: device changed
decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Nov 21 20:41:16 Marge kernel: [    1.304297] ------------[ cut here
]------------
Nov 21 20:41:16 Marge kernel: [    1.304419] WARNING: at
drivers/gpu/drm/i915/intel_display.c:930 assert_pipe+0x4e/0x58()
Nov 21 20:41:16 Marge kernel: [    1.304607] Hardware name: O.E.M
Nov 21 20:41:16 Marge kernel: [    1.304712] pipe A assertion failure
(expected off, current on)
Nov 21 20:41:16 Marge kernel: [    1.304821] Modules linked in:
Nov 21 20:41:16 Marge kernel: [    1.304951] Pid: 1, comm: swapper Not
tainted 3.2.0-rc2+ #1
Nov 21 20:41:16 Marge kernel: [    1.305080] Call Trace:
Nov 21 20:41:16 Marge kernel: [    1.305192]  [<c0231172>]
warn_slowpath_common+0x65/0x7a
Nov 21 20:41:16 Marge kernel: [    1.305304]  [<c0489ce5>] ?
assert_pipe+0x4e/0x58
Nov 21 20:41:16 Marge kernel: [    1.305416]  [<c02311eb>]
warn_slowpath_fmt+0x26/0x2a
Nov 21 20:41:16 Marge kernel: [    1.305528]  [<c0489ce5>] assert_pipe+0x4e/0x58
Nov 21 20:41:16 Marge kernel: [    1.305640]  [<c048debd>]
i9xx_crtc_disable+0x95/0xe0
Nov 21 20:41:16 Marge kernel: [    1.305752]  [<c048df27>]
i9xx_crtc_dpms+0x1f/0x21
Nov 21 20:41:16 Marge kernel: [    1.305862]  [<c0489bf4>]
intel_crtc_dpms+0x3e/0xe1
Nov 21 20:41:16 Marge kernel: [    1.305974]  [<c0488f8a>]
intel_crtc_disable+0x16/0x3c
Nov 21 20:41:16 Marge kernel: [    1.306108]  [<c045e77d>]
drm_helper_disable_unused_functions+0xb3/0xd7
Nov 21 20:41:16 Marge kernel: [    1.306224]  [<c0491e3b>]
intel_modeset_init+0xc59/0xd2d
Nov 21 20:41:16 Marge kernel: [    1.306337]  [<c0474acb>]
i915_driver_load+0x8c6/0xd03
Nov 21 20:41:16 Marge kernel: [    1.306449]  [<c04a671e>] ?
device_register+0x12/0x15
Nov 21 20:41:16 Marge kernel: [    1.306560]  [<c04672b6>] ?
drm_get_minor+0x1d9/0x220
Nov 21 20:41:16 Marge kernel: [    1.306673]  [<c0468b54>]
drm_get_pci_dev+0x12d/0x20c
Nov 21 20:41:16 Marge kernel: [    1.306785]  [<c0229737>] ?
sub_preempt_count+0x7c/0x89
Nov 21 20:41:16 Marge kernel: [    1.306898]  [<c06afc12>]
i915_pci_probe+0x18/0x1e
Nov 21 20:41:16 Marge kernel: [    1.307030]  [<c03f3cb5>]
local_pci_probe+0x3b/0x7e
Nov 21 20:41:16 Marge kernel: [    1.307142]  [<c03f4200>]
pci_device_probe+0x45/0x68
Nov 21 20:41:16 Marge kernel: [    1.307254]  [<c04a7f7f>]
driver_probe_device+0x8f/0x113
Nov 21 20:41:16 Marge kernel: [    1.307366]  [<c04a8046>]
__driver_attach+0x43/0x5f
Nov 21 20:41:16 Marge kernel: [    1.307478]  [<c04a7497>]
bus_for_each_dev+0x3d/0x60
Nov 21 20:41:16 Marge kernel: [    1.307589]  [<c04a7d05>]
driver_attach+0x14/0x16
Nov 21 20:41:16 Marge kernel: [    1.307699]  [<c04a8003>] ?
driver_probe_device+0x113/0x113
Nov 21 20:41:16 Marge kernel: [    1.307811]  [<c04a7a14>]
bus_add_driver+0x93/0x1cb
Nov 21 20:41:16 Marge kernel: [    1.307922]  [<c04a8435>]
driver_register+0x77/0xd6
Nov 21 20:41:16 Marge kernel: [    1.308054]  [<c02d0fd5>] ? dput+0xab/0x126
Nov 21 20:41:16 Marge kernel: [    1.308164]  [<c03f43d2>]
__pci_register_driver+0x37/0x94
Nov 21 20:41:16 Marge kernel: [    1.308277]  [<c0468ca2>]
drm_pci_init+0x6f/0xc7
Nov 21 20:41:16 Marge kernel: [    1.308390]  [<c0972725>] ?
start_kernel+0x313/0x313
Nov 21 20:41:16 Marge kernel: [    1.308502]  [<c0999dfe>] i915_init+0x7f/0x81
Nov 21 20:41:16 Marge kernel: [    1.308612]  [<c0201210>]
do_one_initcall+0x71/0x115
Nov 21 20:41:16 Marge kernel: [    1.308723]  [<c0999d7f>] ?
drm_core_init+0xfb/0xfb
Nov 21 20:41:16 Marge kernel: [    1.308833]  [<c0972725>] ?
start_kernel+0x313/0x313
Nov 21 20:41:16 Marge kernel: [    1.308944]  [<c09727a9>] kernel_init+0x84/0xfd
Nov 21 20:41:16 Marge kernel: [    1.309078]  [<c06bf2fe>]
kernel_thread_helper+0x6/0xd
Nov 21 20:41:16 Marge kernel: [    1.309199] ---[ end trace
2e08c15d09d549af ]---
Nov 21 20:41:16 Marge kernel: [    1.316562] ------------[ cut here
]------------
Nov 21 20:41:16 Marge kernel: [    1.316675] WARNING: at
drivers/gpu/drm/i915/intel_display.c:930 assert_pipe+0x4e/0x58()
Nov 21 20:41:16 Marge kernel: [    1.316860] Hardware name: O.E.M
Nov 21 20:41:16 Marge kernel: [    1.316964] pipe B assertion failure
(expected off, current on)
Nov 21 20:41:16 Marge kernel: [    1.317092] Modules linked in:
Nov 21 20:41:16 Marge kernel: [    1.317222] Pid: 1, comm: swapper
Tainted: G        W    3.2.0-rc2+ #1
Nov 21 20:41:16 Marge kernel: [    1.317332] Call Trace:
Nov 21 20:41:16 Marge kernel: [    1.317440]  [<c0231172>]
warn_slowpath_common+0x65/0x7a
Nov 21 20:41:16 Marge kernel: [    1.317553]  [<c0489ce5>] ?
assert_pipe+0x4e/0x58
Nov 21 20:41:16 Marge kernel: [    1.317664]  [<c02311eb>]
warn_slowpath_fmt+0x26/0x2a
Nov 21 20:41:16 Marge kernel: [    1.317775]  [<c0489ce5>] assert_pipe+0x4e/0x58
Nov 21 20:41:16 Marge kernel: [    1.317886]  [<c048debd>]
i9xx_crtc_disable+0x95/0xe0
Nov 21 20:41:16 Marge kernel: [    1.317997]  [<c048df27>]
i9xx_crtc_dpms+0x1f/0x21
Nov 21 20:41:16 Marge kernel: [    1.318126]  [<c0489bf4>]
intel_crtc_dpms+0x3e/0xe1
Nov 21 20:41:16 Marge kernel: [    1.318238]  [<c0488f8a>]
intel_crtc_disable+0x16/0x3c
Nov 21 20:41:16 Marge kernel: [    1.318350]  [<c045e77d>]
drm_helper_disable_unused_functions+0xb3/0xd7
Nov 21 20:41:16 Marge kernel: [    1.318465]  [<c0491e3b>]
intel_modeset_init+0xc59/0xd2d
Nov 21 20:41:16 Marge kernel: [    1.318579]  [<c0474acb>]
i915_driver_load+0x8c6/0xd03
Nov 21 20:41:16 Marge kernel: [    1.318690]  [<c04a671e>] ?
device_register+0x12/0x15
Nov 21 20:41:16 Marge kernel: [    1.318801]  [<c04672b6>] ?
drm_get_minor+0x1d9/0x220
Nov 21 20:41:16 Marge kernel: [    1.318915]  [<c0468b54>]
drm_get_pci_dev+0x12d/0x20c
Nov 21 20:41:16 Marge kernel: [    1.319042]  [<c0229737>] ?
sub_preempt_count+0x7c/0x89
Nov 21 20:41:16 Marge kernel: [    1.319155]  [<c06afc12>]
i915_pci_probe+0x18/0x1e
Nov 21 20:41:16 Marge kernel: [    1.319266]  [<c03f3cb5>]
local_pci_probe+0x3b/0x7e
Nov 21 20:41:16 Marge kernel: [    1.319376]  [<c03f4200>]
pci_device_probe+0x45/0x68
Nov 21 20:41:16 Marge kernel: [    1.319488]  [<c04a7f7f>]
driver_probe_device+0x8f/0x113
Nov 21 20:41:16 Marge kernel: [    1.319600]  [<c04a8046>]
__driver_attach+0x43/0x5f
Nov 21 20:41:16 Marge kernel: [    1.319711]  [<c04a7497>]
bus_for_each_dev+0x3d/0x60
Nov 21 20:41:16 Marge kernel: [    1.319823]  [<c04a7d05>]
driver_attach+0x14/0x16
Nov 21 20:41:16 Marge kernel: [    1.319933]  [<c04a8003>] ?
driver_probe_device+0x113/0x113
Nov 21 20:41:16 Marge kernel: [    1.320064]  [<c04a7a14>]
bus_add_driver+0x93/0x1cb
Nov 21 20:41:16 Marge kernel: [    1.320176]  [<c04a8435>]
driver_register+0x77/0xd6
Nov 21 20:41:16 Marge kernel: [    1.320287]  [<c02d0fd5>] ? dput+0xab/0x126
Nov 21 20:41:16 Marge kernel: [    1.320397]  [<c03f43d2>]
__pci_register_driver+0x37/0x94
Nov 21 20:41:16 Marge kernel: [    1.320510]  [<c0468ca2>]
drm_pci_init+0x6f/0xc7
Nov 21 20:41:16 Marge kernel: [    1.320620]  [<c0972725>] ?
start_kernel+0x313/0x313
Nov 21 20:41:16 Marge kernel: [    1.320731]  [<c0999dfe>] i915_init+0x7f/0x81
Nov 21 20:41:16 Marge kernel: [    1.320841]  [<c0201210>]
do_one_initcall+0x71/0x115
Nov 21 20:41:16 Marge kernel: [    1.320952]  [<c0999d7f>] ?
drm_core_init+0xfb/0xfb
Nov 21 20:41:16 Marge kernel: [    1.321081]  [<c0972725>] ?
start_kernel+0x313/0x313
Nov 21 20:41:16 Marge kernel: [    1.321192]  [<c09727a9>] kernel_init+0x84/0xfd
Nov 21 20:41:16 Marge kernel: [    1.321303]  [<c06bf2fe>]
kernel_thread_helper+0x6/0xd
Nov 21 20:41:16 Marge kernel: [    1.321412] ---[ end trace
2e08c15d09d549b0 ]---
Nov 21 20:41:16 Marge kernel: [    1.335754] [drm:init_ring_common]
*ERROR* failed to set render ring head to zero ctl ffffffff head
ffffffff tail ffffffff start ffffffff
Nov 21 20:41:16 Marge kernel: [    1.335962] [drm:init_ring_common]
*ERROR* render ring initialization failed ctl ffffffff head ffffffff
tail ffffffff start ffffffff
Nov 21 20:41:16 Marge kernel: [    1.336275] [drm:i915_driver_load]
*ERROR* failed to init modeset
Nov 21 20:41:16 Marge kernel: [    1.380780] i915 0000:00:02.0: PCI
INT A disabled
Nov 21 20:41:16 Marge kernel: [    1.380906] i915: probe of
0000:00:02.0 failed with error -5

My configuration: (ver_linux)

Linux Marge 3.2.0-rc2+ #1 SMP PREEMPT Mon Nov 21 20:37:58 CET 2011
i686 Intel(R) Atom(TM) CPU 330 @ 1.60GHz GenuineIntel GNU/Linux

Gnu C                  4.5.3
Gnu make               3.82
binutils               2.21.1
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42-WIP
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60_p20110820045617
Kbd                    1.15.3wip
Sh-utils               8.14
Modules Loaded         fuse i2c_i801

My configuration: lspci
00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory
Controller Hub (rev 02)
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=09 <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at ffe80000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at ffe40000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 40
        Region 0: Memory at ffe38000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 4159
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM
unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train-
SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: snd_hda_intel

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at d800 [size=32]
        Kernel driver in use: uhci_hcd
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at d880 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at dc00 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at e000 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at ffe3fc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: ffc00000-ffcfffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Foxconn International, Inc. Device 0d4d

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
Interface Bridge (rev 01)
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]
        Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at e880 [size=8]
        Region 1: I/O ports at e800 [size=4]
        Region 2: I/O ports at e480 [size=8]
        Region 3: I/O ports at e400 [size=4]
        Region 4: I/O ports at e080 [size=16]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 0400 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

01:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Foxconn International, Inc. Device 0d4d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at c800 [size=256]
        Region 1: Memory at ffcffc00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: 8139too
