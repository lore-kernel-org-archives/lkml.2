Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965Ab1L0Fkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:40:55 -0500
Received: from zinan.dashjr.org ([173.242.112.54]:57787 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab1L0Fkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:40:49 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Dec 2011 00:40:48 EST
From: "Luke-Jr" <luke@dashjr.org>
To: Keith Packard <keithp@keithp.com>
Subject: PROBLEM: i915 system hang OR corrupt display
Date: Tue, 27 Dec 2011 00:34:37 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.5-gentoo; KDE/4.7.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112270034.38932.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [1.] One line summary of the problem:    
i915 system hang OR corrupt display

> [2.] Full description of the problem/report:
I am unsure which circumstance this kernel log came from:
1. KVM guest crashed, taking down the host (what was actually trying to debug)
  OR
2. i915 device 'remove'd and PCI bus rescanned; graphics were corrupt after

> [3.] Keywords (i.e., modules, networking, kernel):
i915 v3.1.5

> [4.] Kernel version (from /proc/version):
Linux version 3.1.5-gentoo (root@ishibashi) (gcc version 4.5.3 (Gentoo 4.5.3-
r2 p1.0, pie-0.4.6) ) #1 SMP PREEMPT Sun Dec 25 02:28:00 EST 2011

> [5.] Output of Oops.. message (if applicable)
vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
Console: switching to colour VGA+ 80x25
drm: unregistered panic notifier
DRHD: handling fault status reg 3
DMAR:[DMA Write] Request device [00:02.0] fault addr fffff000 
DMAR:[fault reason 02] Present bit in context entry is clear
pci 0000:00:02.0: [8086:0102] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xfe000000-0xfe3fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
pci 0000:00:02.0: BAR 2: assigned [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:02.0: BAR 2: set to [mem 0xc0000000-0xcfffffff 64bit pref] (PCI 
address [0xc0000000-0xcfffffff])
pci 0000:00:02.0: BAR 0: assigned [mem 0xbfc00000-0xbfffffff 64bit]
pci 0000:00:02.0: BAR 0: set to [mem 0xbfc00000-0xbfffffff 64bit] (PCI address 
[0xbfc00000-0xbfffffff])
pci 0000:00:02.0: BAR 4: assigned [io  0x0480-0x04bf]
pci 0000:00:02.0: BAR 4: set to [io  0x0480-0x04bf] (PCI address 
[0x480-0x4bf])
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[drm] MTRR allocation failed.  Graphics performance may suffer.
i915 0000:00:02.0: irq 53 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
DRHD: handling fault status reg 2
INTR-REMAP: Request device [[00:02.0] fault index 1f
INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
Console: switching to colour frame buffer device 240x67
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
No ACPI video bus found
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/i915_drv.c:354 
gen6_gt_force_wake_get+0x49/0x50 [i915]()
Hardware name:         
Modules linked in: pci_stub kvm_intel kvm netconsole configfs cfq_iosched 
blk_cgroup snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss bridge ipv6 stp llc snd_hda_codec firewire_ohci drm snd_hwdep 
[<ffffffff8128908a>] ? acpi_idle_enter_bm+0x229/0x262
 [<ffffffff81063ff1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff810011eb>] cpu_idle+0x6b/0xc0
 [<ffffffff8139fa4d>] rest_init+0x8d/0xa0
 [<ffffffff8166eb70>] start_kernel+0x351/0x35c
 [<ffffffff8166e322>] x86_64_start_reservations+0x132/0x136
 [<ffffffff8166e417>] x86_64_start_kernel+0xf1/0xf8
---[ end trace 5f7401b32a20e9ba ]---
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/i915_drv.c:354 
gen6_gt_force_wake_get+0x49/0x50 [i915]()
Hardware name:         
Modules linked in: pci_stub kvm_intel kvm netconsole configfs cfq_iosched 
blk_cgroup snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss bridge ipv6 stp llc button mii
Pid: 0, comm: swapper Tainted: G        WC  3.1.5-gentoo #1
 [<ffffffff810415da>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81041625>] warn_slowpath_null+0x15/0x20
 [<ffffffffa01d7649>] gen6_gt_force_wake_get+0x49/0x50 [i915]
 [<ffffffffa01dffd8>] i915_hangcheck_elapsed+0x2e8/0x350 [i915]
 [<ffffffff8104e050>] run_timer_softirq+0x140/0x280
 [<ffffffffa01dfcf0>] ? i915_vblank_swap+0x10/0x10 [i915]
 [<ffffffff810477b8>] __do_softirq+0x98/0x120
 [<ffffffff8106e16a>] ? tick_program_event+0x1a/0x20
 [<ffffffff813b3f2c>] call_softirq+0x1c/0x30
 [<ffffffff8100475d>] do_softirq+0x4d/0x80
 [<ffffffff81047b3e>] irq_exit+0x8e/0xb0
 [<ffffffff8101cb08>] smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff813b368b>] apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff812f57e6>] ? poll_idle+0x36/0x70
 [<ffffffff812f57be>] ? poll_idle+0xe/0x70
 [<ffffffff812f58e7>] cpuidle_idle_call+0xa7/0x100
 [<ffffffff81063ff1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff810011eb>] cpu_idle+0x6b/0xc0
 [<ffffffff8139fa4d>] rest_init+0x8d/0xa0
 [<ffffffff8166eb70>] start_kernel+0x351/0x35c
 [<ffffffff8166e322>] x86_64_start_reservations+0x132/0x136
 [<ffffffff8166e417>] x86_64_start_kernel+0xf1/0xf8
WARNING: at drivers/gpu/drm/i915/i915_drv.c:372 
gen6_gt_force_wake_put+0x53/0x60 [i915]()
Hardware name:         
Modules linked in: pci_stub kvm_intel kvm netconsole configfs cfq_iosched 
blk_cgroup snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss bridge ipv6 stp llc coretemp hwmon usblp usb_storage 
snd_hda_codec_hdmi snd_hda_codec_realtek i915 snd_hda_intel drm_kms_helper 
snd_hwdep snd_pcm firewire_core 8250_pci xhci_hcd ehci_hcd 8139tooWARNING: at 
drivers/gpu/drm/i915/i915_drv.c:354 gen6_gt_force_wake_get+0x49/0x50 [i915]()
 configfs cfq_iosched snd_seq_oss snd_seq_device snd_mixer_oss stp coretemp 
hwmon snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm 
firewire_core xhci_hcd snd_timer i2c_i801 8139too usbcore evdev 8250 tpm_tis 
snd tpm button serial_core mii sg mei(C) [<ffffffffa01d7649>] 
gen6_gt_force_wake_get+0x49/0x50 [i915]
 [<ffffffffa01dfcf0>] ? i915_vblank_swap+0x10/0x10 [i915]
 [<ffffffff8106e16a>] ? tick_program_event+0x1a/0x20
 [<ffffffff8100475d>] do_softirq+0x4d/0x80
 [<ffffffff8101cb08>] smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff813b368b>] apic_timer_interrupt+0x6b/0x70
 [<ffffffff812f57e6>] ? poll_idle+0x36/0x70
 [<ffffffff812f58e7>] cpuidle_idle_call+0xa7/0x100
 [<ffffffff81063ff1>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8166eb70>] start_kernel+0x351/0x35c
 [<ffffffff8166e417>] x86_64_start_kernel+0xf1/0xf8
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/i915_drv.c:372 
gen6_gt_force_wake_put+0x53/0x60 [i915]()
Hardware name:         
Modules linked in: pci_stub kvm_intel kvm netconsole configfs cfq_iosched 
blk_cgroup snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss bridge ipv6 stp llc[drm:i915_hangcheck_elapsed] *ERROR* 
Hangcheck timer elapsed... GPU hung
[drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 2 at 
0, next 3)
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 2
DMAR:[DMA Write] Request device [00:02.0] fault addr 151db38000 
DMAR:[fault reason 05] PTE Write access is not set

> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux ishibashi 3.1.5-gentoo #1 SMP PREEMPT Sun Dec 25 02:28:00 EST 2011 
x86_64 Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz GenuineIntel GNU/Linux
 
Gnu C                  4.5.3
Gnu make               3.82
binutils               2.21.1
util-linux             2.19.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.14
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60_p20110409135728
Kbd                    1.15.3wip
Sh-utils               8.7
Modules Loaded         netconsole configfs cfq_iosched blk_cgroup snd_seq_oss 
snd_seq_midi_event snd_seq bridge snd_seq_device ipv6 snd_pcm_oss 
snd_mixer_oss stp llc coretemp hwmon usblp snd_hda_codec_hdmi 
snd_hda_codec_realtek usb_storage snd_hda_intel snd_hda_codec usbhid hid 
snd_hwdep firewire_ohci i915 snd_pcm firewire_core 8250_pci 8250_pnp 8250 
snd_timer ata_generic drm_kms_helper psmouse evdev tpm_tis i2c_i801 8139too 
drm snd ehci_hcd i2c_algo_bit xhci_hcd tpm tpm_bios video pata_acpi button 
usbcore crc_itu_t mii serial_core rtc_cmos e1000e sg mei snd_page_alloc

> [7.2.] Processor information (from /proc/cpuinfo):
processor   : 0 (through 3)
vendor_id   : GenuineIntel
cpu family  : 6
model       : 42
model name  : Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz
stepping    : 7
cpu MHz     : 3099.611
cache size  : 6144 KB
physical id : 0
siblings    : 4
core id     : 0
cpu cores   : 4
apicid      : 0
initial apicid  : 0
fpu     : yes
fpu_exception   : yes
cpuid level : 13
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm 
constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni 
pclmulqdq dtes64 ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 
x2apic popcnt aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts 
tpr_shadow vnmi flexpriority ept vpid
bogomips    : 6199.22
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

> [7.3.] Module information (from /proc/modules):
netconsole 6478 0 - Live 0xffffffffa031f000
configfs 22546 2 netconsole, Live 0xffffffffa0314000
cfq_iosched 26392 5 - Live 0xffffffffa0308000
blk_cgroup 13552 1 cfq_iosched, Live 0xffffffffa0300000
snd_seq_oss 26488 0 - Live 0xffffffffa02f8000
snd_seq_midi_event 5220 1 snd_seq_oss, Live 0xffffffffa019f000
snd_seq 47010 4 snd_seq_oss,snd_seq_midi_event, Live 0xffffffffa021a000
bridge 73038 0 - Live 0xffffffffa02df000
snd_seq_device 4921 2 snd_seq_oss,snd_seq, Live 0xffffffffa0158000
ipv6 284279 53 bridge, Live 0xffffffffa0286000
snd_pcm_oss 36981 0 - Live 0xffffffffa0187000
snd_mixer_oss 13915 1 snd_pcm_oss, Live 0xffffffffa0148000
stp 1520 1 bridge, Live 0xffffffffa010d000
llc 3505 2 bridge,stp, Live 0xffffffffa0103000
coretemp 6027 0 - Live 0xffffffffa00f6000
hwmon 1377 1 coretemp, Live 0xffffffffa00a5000
usblp 10776 0 - Live 0xffffffffa0030000
snd_hda_codec_hdmi 21960 1 - Live 0xffffffffa00b7000
snd_hda_codec_realtek 278889 1 - Live 0xffffffffa0240000
usb_storage 42796 0 - Live 0xffffffffa0173000
snd_hda_intel 21741 2 - Live 0xffffffffa0097000
snd_hda_codec 76338 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, 
Live 0xffffffffa022c000
usbhid 25222 0 - Live 0xffffffffa0063000
hid 49264 1 usbhid, Live 0xffffffffa0165000
snd_hwdep 5670 1 snd_hda_codec, Live 0xffffffffa0060000
firewire_ohci 28824 0 - Live 0xffffffffa008e000
i915 364642 3 - Live 0xffffffffa01bf000
snd_pcm 69638 4 snd_pcm_oss,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, 
Live 0xffffffffa01a5000
firewire_core 47976 1 firewire_ohci, Live 0xffffffffa0192000
8250_pci 25484 0 - Live 0xffffffffa017f000
8250_pnp 4631 0 - Live 0xffffffffa0132000
8250 21753 2 8250_pnp,8250_pci, Live 0xffffffffa015e000
snd_timer 17769 2 snd_seq,snd_pcm, Live 0xffffffffa0152000
ata_generic 3399 0 - Live 0xffffffffa0019000
drm_kms_helper 24524 1 i915, Live 0xffffffffa0125000
psmouse 45882 0 - Live 0xffffffffa0118000
evdev 9146 6 - Live 0xffffffffa00be000
tpm_tis 9214 0 - Live 0xffffffffa0034000
i2c_i801 7998 0 - Live 0xffffffffa00fa000
8139too 19185 0 - Live 0xffffffffa00f0000
drm 168771 4 i915,drm_kms_helper, Live 0xffffffffa00c5000
snd 53346 16 
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer, 
Live 0xffffffffa00a8000
ehci_hcd 38168 0 - Live 0xffffffffa0025000
i2c_algo_bit 5024 1 i915, Live 0xffffffffa0007000
xhci_hcd 70091 0 - Live 0xffffffffa0135000
tpm 11099 1 tpm_tis, Live 0xffffffffa012e000
tpm_bios 4777 1 tpm, Live 0xffffffffa0115000
video 10927 1 i915, Live 0xffffffffa0109000
pata_acpi 3256 0 - Live 0xffffffffa0105000
button 4247 1 i915, Live 0xffffffffa00fe000
usbcore 136819 6 usblp,usb_storage,usbhid,ehci_hcd,xhci_hcd, Live 
0xffffffffa006b000
crc_itu_t 1241 1 firewire_core, Live 0xffffffffa0039000
mii 3779 1 8139too, Live 0xffffffffa001c000
serial_core 18257 1 8250, Live 0xffffffffa0013000
rtc_cmos 8450 0 - Live 0xffffffffa0003000
e1000e 140327 0 - Live 0xffffffffa003c000
sg 23860 0 - Live 0xffffffffa001e000
mei 29849 0 - Live 0xffffffffa000a000 (C)
snd_page_alloc 6713 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0000000

> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
# cat /proc/ioports 
0000-03af : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0290-029f : pnp 00:02
03b0-03df : PCI Bus 0000:00
  03c0-03df : vga+
03e0-0cf7 : PCI Bus 0000:00
  03f8-03ff : serial
  0400-0453 : pnp 00:0a
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:0b
  0458-047f : pnp 00:0a
  04d0-04d1 : pnp 00:06
  0500-057f : pnp 00:0a
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1180-119f : pnp 00:0a
  d000-dfff : PCI Bus 0000:04
    d000-d0ff : 0000:04:00.0
      d000-d0ff : 8139too
  e000-efff : PCI Bus 0000:01
  f000-f03f : 0000:00:02.0
  f040-f05f : 0000:00:1f.3
    f040-f05f : i801_smbus
  f060-f07f : 0000:00:1f.2
    f060-f07f : ahci
  f080-f09f : 0000:00:19.0
  f0a0-f0a3 : 0000:00:1f.2
    f0a0-f0a3 : ahci
  f0b0-f0b7 : 0000:00:1f.2
    f0b0-f0b7 : ahci
  f0c0-f0c3 : 0000:00:1f.2
    f0c0-f0c3 : ahci
  f0d0-f0d7 : 0000:00:1f.2
    f0d0-f0d7 : ahci
  f0e0-f0e7 : 0000:00:16.3
    f0e0-f0e7 : serial
  f0f0-f0ff : 0000:00:16.2
    f0f0-f0ff : ata_generic
  f100-f103 : 0000:00:16.2
    f100-f103 : ata_generic
  f110-f117 : 0000:00:16.2
    f110-f117 : ata_generic
  f120-f123 : 0000:00:16.2
    f120-f123 : ata_generic
  f130-f137 : 0000:00:16.2
    f130-f137 : ata_generic
# cat /proc/iomem 
00000000-0000ffff : reserved
00010000-0009abff : System RAM
0009ac00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
  000c0000-000cdbff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
  01000000-013b66f2 : Kernel code
  013b66f3-0165b47f : Kernel data
  016d0000-0174ffff : Kernel bss
20000000-201fffff : reserved
20200000-3fffffff : System RAM
40000000-401fffff : reserved
40200000-bc55afff : System RAM
bc55b000-bc563fff : ACPI Tables
bc564000-bc5aefff : ACPI Non-volatile Storage
bc5af000-bc5b6fff : System RAM
bc5b7000-bc8c4fff : reserved
bc8c5000-bc8c5fff : System RAM
bc8c6000-bc8d5fff : reserved
bc8d6000-bc8f4fff : ACPI Non-volatile Storage
bc8f5000-bc918fff : reserved
bc919000-bc95bfff : ACPI Non-volatile Storage
bc95c000-bcb7bfff : reserved
bcb7c000-bccfffff : System RAM
bcd00000-bcffffff : reserved
bd000000-bd7fffff : RAM buffer
bd800000-bf9fffff : reserved
bfa00000-ffffffff : PCI Bus 0000:00
  c0000000-cfffffff : 0000:00:02.0
  d0000000-dfffffff : PCI Bus 0000:01
  e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
    e0000000-e3ffffff : pnp 00:01
  fe000000-fe3fffff : 0000:00:02.0
  fe400000-fe4fffff : PCI Bus 0000:04
    fe400000-fe400fff : 0000:04:03.0
      fe400000-fe400fff : firewire_ohci
    fe401000-fe4010ff : 0000:04:00.0
      fe401000-fe4010ff : 8139too
  fe500000-fe5fffff : PCI Bus 0000:03
    fe500000-fe501fff : 0000:03:00.0
      fe500000-fe501fff : xhci_hcd
  fe600000-fe6fffff : PCI Bus 0000:01
  fe700000-fe71ffff : 0000:00:19.0
    fe700000-fe71ffff : e1000e
  fe720000-fe723fff : 0000:00:1b.0
    fe720000-fe723fff : ICH HD audio
  fe724000-fe7240ff : 0000:00:1f.3
  fe725000-fe7257ff : 0000:00:1f.2
    fe725000-fe7257ff : ahci
  fe726000-fe7263ff : 0000:00:1d.0
    fe726000-fe7263ff : ehci_hcd
  fe727000-fe7273ff : 0000:00:1a.0
    fe727000-fe7273ff : ehci_hcd
  fe728000-fe728fff : 0000:00:19.0
    fe728000-fe728fff : e1000e
  fe729000-fe729fff : 0000:00:16.3
  fe72a000-fe72a00f : 0000:00:16.0
    fe72a000-fe72a00f : mei
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : HPET 0
  fed08000-fed08fff : pnp 00:0a
  fed10000-fed19fff : pnp 00:01
  fed1c000-fed3ffff : reserved
    fed1c000-fed1ffff : pnp 00:0a
    fed20000-fed3ffff : pnp 00:01
  fed90000-fed93fff : pnp 00:01
  fee00000-fee0ffff : pnp 00:01
    fee00000-fee00fff : Local APIC
  ff000000-ffffffff : reserved
    ff000000-ffffffff : pnp 00:0a
100000000-43e5fffff : System RAM
43e600000-43fffffff : RAM buffer

> [7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family 
DRAM Controller (rev 09)
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core 
Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 0000e000-0000efff
    Memory behind bridge: fe600000-fe6fffff
    Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [88] Subsystem: Intel Corporation Device 2008
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee002b8  Data: 0000
    Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap: Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 
<256ns, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot+
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- 
BWMgmt+ ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #0, PowerLimit 75.000W; Interlock- NoCompl+
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet+ LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [100 v1] Virtual Channel
        Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:   ArbSelect=Fixed
        Status: InProgress-
        VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status: NegoPending- InProgress-
    Capabilities: [140 v1] Root Complex Link
        Desc:   PortNumber=02 ComponentID=01 EltType=Config
        Link0:  Desc:   TargetPort=00 TargetComponent=01 AssocRCRB- 
LinkType=MemMapped LinkValid+
            Addr:   00000000fed19000
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation Sandy Bridge Integrated 
Graphics Controller (rev 09) (prog-if 00 [VGA controller])
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 52
    Region 0: Memory at fe000000 (64-bit, non-prefetchable) [size=4M]
    Region 2: Memory at c0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at f000 [size=64]
    Expansion ROM at <unassigned> [disabled]
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee00018  Data: 0000
    Capabilities: [d0] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: i915
    Kernel modules: i915

00:16.0 Communication controller: Intel Corporation Cougar Point HECI 
Controller #1 (rev 04)
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at fe72a000 (64-bit, non-prefetchable) [size=16]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Kernel driver in use: mei
    Kernel modules: mei

00:16.2 IDE interface: Intel Corporation Cougar Point IDE-r Controller (rev 
04) (prog-if 85 [Master SecO PriO])
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 0: I/O ports at f130 [size=8]
    Region 1: I/O ports at f120 [size=4]
    Region 2: I/O ports at f110 [size=8]
    Region 3: I/O ports at f100 [size=4]
    Region 4: I/O ports at f0f0 [size=16]
    Capabilities: [c8] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Kernel driver in use: ata_generic

00:16.3 Serial controller: Intel Corporation Cougar Point KT Controller (rev 
04) (prog-if 02 [16550])
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 17
    Region 0: I/O ports at f0e0 [size=8]
    Region 1: Memory at fe729000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [c8] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Kernel driver in use: serial
    Kernel modules: 8250_pci

00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network 
Connection (rev 04)
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 46
    Region 0: Memory at fe700000 (32-bit, non-prefetchable) [size=128K]
    Region 1: Memory at fe728000 (32-bit, non-prefetchable) [size=4K]
    Region 2: I/O ports at f080 [size=32]
    Capabilities: [c8] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee00378  Data: 0000
    Capabilities: [e0] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: e1000e
    Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host 
Controller #2 (rev 04) (prog-if 20 [EHCI])
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at fe727000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation Cougar Point High Definition Audio 
Controller (rev 04)
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 53
    Region 0: Memory at fe720000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee003d8  Data: 0000
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE- FLReset+
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 
<64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- 
BWMgmt- ABWMgmt-
    Capabilities: [100 v1] Virtual Channel
        Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:   ArbSelect=Fixed
        Status: InProgress-
        VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status: NegoPending- InProgress-
        VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=22
            Status: NegoPending- InProgress-
    Capabilities: [130 v1] Root Complex Link
        Desc:   PortNumber=0f ComponentID=00 EltType=Config
        Link0:  Desc:   TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
            Addr:   00000000fed1c000
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 1 
(rev b4) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #1, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <1us, 
L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #0, PowerLimit 25.000W; Interlock- NoCompl+
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee002d8  Data: 0000
    Capabilities: [90] Subsystem: Intel Corporation Device 2008
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.6 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 7 
(rev b4) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fe500000-fe5fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap: Port #7, Speed 5GT/s, Width x1, ASPM unknown, Latency L0 
<512ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt+ ABWMgmt-
        SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #6, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee002f8  Data: 0000
    Capabilities: [90] Subsystem: Intel Corporation Device 2008
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host 
Controller #1 (rev 04) (prog-if 20 [EHCI])
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at fe726000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a4) (prog-if 01 
[Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
    I/O behind bridge: 0000d000-0000dfff
    Memory behind bridge: fe400000-fe4fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Subsystem: Intel Corporation Device 2008

00:1f.0 ISA bridge: Intel Corporation Q67 Express Chipset Family LPC 
Controller (rev 04)
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI 
Controller (rev 04) (prog-if 01 [AHCI 1.0])
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 45
    Region 0: I/O ports at f0d0 [size=8]
    Region 1: I/O ports at f0c0 [size=4]
    Region 2: I/O ports at f0b0 [size=8]
    Region 3: I/O ports at f0a0 [size=4]
    Region 4: I/O ports at f060 [size=32]
    Region 5: Memory at fe725000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee00338  Data: 0000
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
    Capabilities: [b0] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 04)
    Subsystem: Intel Corporation Device 2008
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at fe724000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at f040 [size=32]
    Kernel driver in use: i801_smbus
    Kernel modules: i2c-i801

03:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 
03) (prog-if 30)
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at fe500000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
        Vector table: BAR=0 offset=00001000
        PBA: BAR=0 offset=00001080
    Capabilities: [a0] Express (v2) Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 16384 bytes
        DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, 
L1 unlimited
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
    Capabilities: [150 v1] #18
    Kernel driver in use: xhci_hcd
    Kernel modules: xhci-hcd

04:00.0 Ethernet controller: Accton Technology Corporation SMC2-1211TX (rev 
10)
    Subsystem: Hewlett-Packard Company Device 9207
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 32 (8000ns min, 16000ns max)
    Interrupt: pin A routed to IRQ 16
    Region 0: I/O ports at d000 [size=256]
    Region 1: Memory at fe401000 (32-bit, non-prefetchable) [size=256]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1+,D2+,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: 8139too
    Kernel modules: 8139too

04:03.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70) (prog-if 10 
[OHCI])
    Subsystem: Intel Corporation Device 2008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
    Latency: 32 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 20
    Region 0: Memory at fe400000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
    Kernel driver in use: firewire_ohci
    Kernel modules: firewire-ohci

> [7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD20EARS-00M Rev: 51.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HDS5C302 Rev: ML6O
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG HD753LJ  Rev: 1AA0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3500630AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: Nokia    Model: N900             Rev:  031
  Type:   Direct-Access                    ANSI  SCSI revision: 02

