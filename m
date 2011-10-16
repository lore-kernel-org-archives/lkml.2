Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1JPSBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:01:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1JPSBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:01:11 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=tQ3YUUaTdcMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=b8VgSBC0AAAA:8 a=dj1SP1BiBiClPndyjHwA:9 a=k8WjzshU6VctoZgZhdAA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318788068.12224.125.camel@gandalf.stny.rr.com>
Subject: Problems with videos and i915 driver
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Cc: Keith Packard <keithp@keithp.com>
Date: Sun, 16 Oct 2011 14:01:08 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

I just upgraded my wife's computer with a new motherboard which has a
(lspci -vv):

Intel Corporation Sandy Bridge Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 45
        Region 0: Memory at fe000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at f000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0200c  Data: 4191
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915


With the standard F14 kernel, running any videos locked up the display.
I upgraded her kernel to 3.0.6 and now display no longer locks up but
the videos still do not play. Just sound, but the video is a blank
screen. Here's some of the dmesg:

[    1.777679] [drm] Initialized drm 1.1.0 20060810
[    1.780689] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.780693] i915 0000:00:02.0: setting latency timer to 64
[    1.810351] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    1.810355] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.810356] [drm] Driver supports precise vblank timestamp query.
[    1.810383] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem


[    2.151171] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    2.151197] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.151212] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


[  102.695526] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[  102.695538] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[  102.699680] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 1 at 0, next 2)
[  104.490507] ------------[ cut here ]------------
[  104.490529] WARNING: at drivers/gpu/drm/i915/i915_drv.c:322 gen6_gt_force_wake_get+0x29/0x48 [i915]()
[  104.490533] Hardware name: System Product Name
[  104.490535] Modules linked in: vfat fat fuse nfs lockd fscache auth_rpcgss nfs_acl sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm ppdev iTCO_wdt parport_pc r8169 pcspkr serio_raw snd_timer snd soundcore snd_page_alloc parport i2c_i801 iTCO_vendor_support xhci_hcd mii microcode usblp joydev pata_acpi ata_generic pata_via wmi usb_storage i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[  104.490579] Pid: 0, comm: swapper Not tainted 3.0.6 #1
[  104.490581] Call Trace:
[  104.490583]  <IRQ>  [<ffffffff8104a9de>] warn_slowpath_common+0x83/0x9b
[  104.490595]  [<ffffffff8104aa10>] warn_slowpath_null+0x1a/0x1c
[  104.490605]  [<ffffffffa006753a>] gen6_gt_force_wake_get+0x29/0x48 [i915]
[  104.490617]  [<ffffffffa006afd9>] i915_read32+0x33/0x6b [i915]
[  104.490629]  [<ffffffffa006dfdf>] i915_hangcheck_elapsed+0xbb/0x1eb [i915]
[  104.490634]  [<ffffffff8105781d>] run_timer_softirq+0x19b/0x280
[  104.490640]  [<ffffffff8100e95d>] ? paravirt_read_tsc+0x9/0xd
[  104.490651]  [<ffffffffa006df24>] ? i915_vblank_swap+0x10/0x10 [i915]
[  104.490657]  [<ffffffff81050645>] __do_softirq+0xc9/0x1b5
[  104.490661]  [<ffffffff8100e95d>] ? paravirt_read_tsc+0x9/0xd
[  104.490665]  [<ffffffff8147269c>] call_softirq+0x1c/0x30
[  104.490669]  [<ffffffff8100aba1>] do_softirq+0x46/0x81
[  104.490673]  [<ffffffff81050922>] irq_exit+0x52/0xaf
[  104.490677]  [<ffffffff81472fb1>] smp_apic_timer_interrupt+0x7c/0x8a
[  104.490682]  [<ffffffff81471e53>] apic_timer_interrupt+0x13/0x20
[  104.490684]  <EOI>  [<ffffffff8100e95d>] ? paravirt_read_tsc+0x9/0xd
[  104.490692]  [<ffffffff812664fc>] ? intel_idle+0xd8/0x100
[  104.490696]  [<ffffffff812664de>] ? intel_idle+0xba/0x100
[  104.490700]  [<ffffffff8138ad2d>] cpuidle_idle_call+0xd7/0x168
[  104.490705]  [<ffffffff81008307>] cpu_idle+0xa5/0xdf
[  104.490711]  [<ffffffff81449b7e>] rest_init+0x72/0x74
[  104.490716]  [<ffffffff81b5ab8b>] start_kernel+0x3ca/0x3d5
[  104.490720]  [<ffffffff81b5a2c4>] x86_64_start_reservations+0xaf/0xb3
[  104.490724]  [<ffffffff81b5a140>] ? early_idt_handlers+0x140/0x140
[  104.490728]  [<ffffffff81b5a3ca>] x86_64_start_kernel+0x102/0x111
[  104.490731] ---[ end trace 0adfc1fb6df717f1 ]---
[  104.490735] ------------[ cut here ]------------

The warning is coming from:

void gen6_gt_force_wake_get(struct drm_i915_private *dev_priv)
{
        WARN_ON(!mutex_is_locked(&dev_priv->dev->struct_mutex));

        /* Forcewake is atomic in case we get in here without the lock */
        if (atomic_add_return(1, &dev_priv->forcewake_count) == 1)
                __gen6_gt_force_wake_get(dev_priv);
}

The mutex isn't locked.

For the full dmesg:

http://rostedt.homelinux.com/private/vid-crash/dmesg

For the /debug/drm directory:

http://rostedt.homelinux.com/private/vid-crash/debugfs-i915.tar.bz2

-- Steve

