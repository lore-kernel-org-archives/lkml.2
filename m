Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1FFCPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 22:15:50 -0400
Received: from col0-omc1-s4.col0.hotmail.com ([65.55.34.14]:13336 "EHLO
	col0-omc1-s4.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075Ab1FFCPs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 22:15:48 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jun 2011 22:15:48 EDT
Message-ID: <COL116-W5CAEF822D4FC5E9AF152CA3600@phx.gbl>
X-Originating-IP: [70.31.51.74]
From: John Lumby <johnlumby@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: PROBLEM:  spinlock errors and system dies on 2.6.39
Date: Sun, 5 Jun 2011 22:09:37 -0400
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Jun 2011 02:09:38.0152 (UTC) FILETIME=[C9C98E80:01CC23EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PROBLEM:  spinlock errors and system dies on 2.6.39 when I plug in my Kingston Data Traveller USB mass storage device.

On 2.6.39 (built from source using GCC 4.5.3),    when I insert the stick,   the kernel displays BUG reports to the console and the system becomes unavailable.     I managed to gather to relevant console messages from a serial console,  attached below. 

I noticed one thing:   I have console timestamping enabled.    The bug always happens with this enabled. 
But if I turn off the console timestamping with printk.time=0,   it very occasionally does not happen (scsi device comes up as expected).   So it may be a timing problem.

The bug never happens on 2.6.38.4

console messages:   (I had to paste some information as the serial console garbled some pieces of some lines -  some addresses and offsets may be incorrect but the sequence is correct)

[  174.192721] scsi 2:0:0:0: Direct-Access     Kingston DataTraveler G3  1.00 PQ: 0 ANSI: 2
[  174.210226] scsi: killing requests for dead queue
[  174.212068] BUG: spinlock already unlocked on CPU#0, ksoftirqd/0/3
[  174.212068]  lock: f55dc5e8, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
[  174.212068] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-vnla #1
[  174.212068] Call Trace:
[  174.212068]  [<????????>] ? do_raw_spin_lock+0x75/0x170
[  174.212068]  [<c???????>] ? scsi_kill_request.clone.13+0x59/0xb0
[  174.212068]  [<c1??????>] ? scsi_request_fn+0x30c/0x380
[  174.212068]  [<c12bb3d4>] ? scsi_request_fn+0x84/0x380
[  174.212068]  [<????????>] ? blk_run_queue+0x28/0x40
[  174.212068]  [<c12b9fd1>] ? scsi_run_queue+0xb1/0x230
[  174.212068]  [<c12b????>] ? scsi_next_command+0x30/0x50
[  174.212068]  [<c12bbb??>] ? scsi_io_completion+0x148/0x550
[  174.212068]  [<????????>] ? blk_done_softirq+0x52/0x60
[  174.212068]  [<c103bd475] ? __do_softirq+0x54/0xf0
[  174.212068]  [<c1025c07>] ? __wake_up_common+0x47/0x70
[  174.212068]  [<c103be67>] ? run_ksoftirqd+0xa7/0x130
[  174.212068]  [<c103bdc0>] ? __do_softirq+0xf0/0xf0
[  174.212068]  [<c104e284>] ? kthread+0x74/0x80
[  174.212068]  [<c104e210>] ? __init_kthread_worker+0x30/0x30
[  174.212068]  [<c1419f76>] ? kernel_thread_helper+0x6/0xd
[  174.212068] BUG: spinlock lockup on CPU#0, ksoftirqd/0/3, f55dc5e8
[  174.212068] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.39-vnla #1
[  174.212068] Call Trace:
[  174.212068]  [<c1208647>] ? do_raw_spin_lock+0x157/0x170
[  174.212068]  [<c12bb328>] ? scsi_kill_request.clone.13+0x88/0xb0
[  174.212068]  [<c12bb65c>] ? scsi_request_fn+0x30c/0x380
[  174.212068]  [<c12bb3d4>] ? scsi_request_fn+0x84/0x380
[  174.212068]  [<c11eee28>] ? blk_run_queue+0x28/0x40
[  174.212068]  [<c12b9fd1>] ? scsi_run_queue+0xb1/0x230
[  174.212068]  [<c12bb9a0>] ? scsi_next_command+0x30/0x50
[  174.212068]  [<c12bbb48>] ? scsi_io_completion+0x148/0x550
[  174.212068]  [<c11f5362>] ? blk_done_softirq+0x52/0x60
[  174.212068]  [<c103bd45>] ? __do_softirq+0x75/0xf0
[  174.212068]  [<c1025c07>] ? __wake_up_common+0x47/0x70
[  174.212068]  [<c103be67>] ? run_ksoftirqd+0xa7/0x130
[  174.212068]  [<c103bdc0>] ? __do_softirq+0xf0/0xf0
[  174.212068]  [<c104e284>] ? kthread+0x74/0x80
[  174.212068]  [<c104e210>] ? __init_kthread_worker+0x30/0x30
[  174.212068]  [<c1419f76>] ? kernel_thread_helper+0x6/0xd

ver_linux output:
  (note ---   the 4 CPUs are 2 cores each with SMT enabled)
  (note  -- relevant scsi and usb mass-stg drivers are builtin)
 
Linux lumbyont.localdomain 2.6.39-vnla #1 SMP Tue May 31 13:55:29 EDT 2011 i686 GNU/Linux
 
Gnu C                  4.5.3
Gnu make               3.81
binutils               2.21
util-linux             2.13-pre7
mount                  support
module-init-tools      3.3-pre1
e2fsprogs              1.41.13
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
isdn4k-utils           3.9
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.7git
Sh-utils               8.9
udev                   095
wireless-tools         29
Modules Loaded         snd_hda_intel snd_hda_codec rtc_cmos rtc_core rtc_lib bridge stp llc i915 drm_kms_helper intel_agp intel_gtt tun xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 dm_mod parport_pc lp parport
============  /proc/cpuinfo =============
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 28
model name    : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
stepping    : 2
cpu MHz        : 1596.167
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips    : 3192.33
clflush size    : 64
cache_alignment    : 64
address sizes    : 32 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 28
model name    : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
stepping    : 2
cpu MHz        : 1596.167
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 2
initial apicid    : 2
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips    : 3191.98
clflush size    : 64
cache_alignment    : 64
address sizes    : 32 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 28
model name    : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
stepping    : 2
cpu MHz        : 1596.167
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips    : 3191.95
clflush size    : 64
cache_alignment    : 64
address sizes    : 32 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 28
model name    : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
stepping    : 2
cpu MHz        : 1596.167
cache size    : 512 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 3
initial apicid    : 3
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
bogomips    : 3191.85
clflush size    : 64
cache_alignment    : 64
address sizes    : 32 bits physical, 48 bits virtual
power management:

============  /proc/modules =============
snd_hda_intel 17288 0 - Live 0xf81e5000
snd_hda_codec 49964 1 snd_hda_intel, Live 0xf81ca000
rtc_cmos 6500 0 - Live 0xf8151000
rtc_core 13963 1 rtc_cmos, Live 0xf814b000
rtc_lib 1765 1 rtc_core, Live 0xf80d0000
bridge 56404 0 - Live 0xf80b9000
stp 1136 1 bridge, Live 0xf80b3000
llc 2864 2 bridge,stp, Live 0xf8005000
i915 297997 1 - Live 0xf80e5000
drm_kms_helper 24000 1 i915, Live 0xf80d8000
intel_agp 8367 1 i915, Live 0xf8c10000
intel_gtt 11161 3 i915,intel_agp, Live 0xf8bd7000
tun 12525 1 - Live 0xf8b98000
xt_state 867 26 - Live 0xf8b44000
ipt_MASQUERADE 1358 1 - Live 0xf8ae6000
iptable_nat 3543 1 - Live 0xf8aa6000
nf_nat 11151 2 ipt_MASQUERADE,iptable_nat, Live 0xf8a3a000
nf_conntrack_ipv4 8405 29 iptable_nat,nf_nat, Live 0xf8910000
nf_conntrack 40997 5 xt_state,ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 0xf8868000
nf_defrag_ipv4 887 1 nf_conntrack_ipv4, Live 0xf8696000
dm_mod 52766 0 - Live 0xf8350000
parport_pc 17355 1 - Live 0xf81de000
lp 6716 0 - Live 0xf802b000
parport 24631 2 parport_pc,lp, Live 0xf8159000
============  /proc/ioports =============
0000-0cf7 : PCI Bus 0000:00
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
  0170-0177 : 0000:00:1f.1
    0170-0177 : piix
  01f0-01f7 : 0000:00:1f.1
    01f0-01f7 : piix
  0376-0376 : 0000:00:1f.1
    0376-0376 : piix
  0378-037a : parport0
  037b-037f : parport0
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.1
    03f6-03f6 : piix
  03f8-03ff : serial
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0420 : ACPI PM2_CNT_BLK
    0428-042f : ACPI GPE0_BLK
  0500-053f : pnp 00:06
  0680-06ff : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1fff : PCI Bus 0000:04
    1000-10ff : 0000:04:00.0
  2000-2fff : PCI Bus 0000:01
    2000-20ff : 0000:01:00.0
  3000-301f : 0000:00:1f.3
    3000-301f : i801_smbus
  3020-303f : 0000:00:1d.3
  3040-305f : 0000:00:1d.2
  3060-307f : 0000:00:1d.1
  3080-309f : 0000:00:1d.0
  30a0-30af : 0000:00:1f.2
    30a0-30af : ata_piix
  30b0-30bf : 0000:00:1f.1
    30b0-30bf : piix
  30c0-30c7 : 0000:00:1f.2
    30c0-30c7 : ata_piix
  30c8-30cf : 0000:00:1f.2
    30c8-30cf : ata_piix
  30e0-30e7 : 0000:00:02.0
  30e8-30eb : 0000:00:1f.2
    30e8-30eb : ata_piix
  30ec-30ef : 0000:00:1f.2
    30ec-30ef : ata_piix
  4000-4fff : PCI Bus 0000:03
  5000-5fff : PCI Bus 0000:02
============  /proc/iomem =============
00000000-0000ffff : reserved
00010000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cb000-000cbfff : Adapter ROM
000e0000-000fffff : reserved
  000e0000-000effff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-7f531fff : System RAM
  01000000-0141a980 : Kernel code
  0141a981-0159cabf : Kernel data
  0160d000-0166cfff : Kernel bss
7f532000-7f539fff : reserved
7f53a000-7f5cafff : System RAM
7f5cb000-7f5cefff : reserved
7f5cf000-7f65ffff : System RAM
7f660000-7f6effff : ACPI Non-volatile Storage
7f6f0000-7f6f1fff : System RAM
7f6f2000-7f6fefff : ACPI Tables
7f6ff000-7f6fffff : System RAM
7f700000-7fffffff : reserved
80000000-ffffffff : reserved
  80000000-f0000000 : PCI Bus 0000:00
    80000000-8fffffff : 0000:00:02.0
    90000000-900fffff : PCI Bus 0000:01
      90000000-9000ffff : 0000:01:00.0
      90020000-9003ffff : 0000:01:00.0
    90100000-901fffff : PCI Bus 0000:04
      90100000-901000ff : 0000:04:00.0
    90200000-902fffff : PCI Bus 0000:01
      90200000-90200fff : 0000:01:00.0
    90300000-9037ffff : 0000:00:02.0
    90380000-903bffff : 0000:00:02.0
    903c0000-903c3fff : 0000:00:1b.0
      903c0000-903c3fff : ICH HD audio
    903c4000-903c43ff : 0000:00:1d.7
      903c4000-903c43ff : ehci_hcd
    90400000-904fffff : PCI Bus 0000:04
      90400000-9040ffff : 0000:04:00.0
    90500000-906fffff : PCI Bus 0000:03
    90700000-908fffff : PCI Bus 0000:03
    90900000-90afffff : PCI Bus 0000:02
    90b00000-90cfffff : PCI Bus 0000:02
  f8000000-febfffff : PCI Bus 0000:00
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : HPET 0
  fed13000-fed13fff : pnp 00:01
  fed14000-fed17fff : pnp 00:01
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
  fed1c000-fed1ffff : pnp 00:01
  fed20000-fed3ffff : pnp 00:01
  fed45000-fed99fff : pnp 00:01
  fee00000-fee00fff : Local APIC
============  /proc/scsi/scsi =============
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKS-6 Rev: 05.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKS-6 Rev: 05.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05

 		 	   		  