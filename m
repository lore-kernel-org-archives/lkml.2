Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1AaAbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 19:31:33 -0500
Received: from cicero-fbr1.cybercity.dk ([212.242.40.5]:61230 "EHLO
	cicero-fbr1.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1AaAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 19:31:31 -0500
X-Greylist: delayed 2226 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jan 2011 19:31:29 EST
Message-ID: <e6b09d97d6b4a7c0e5751934823fa30c.squirrel@webmail.telenor.dk>
Date: Mon, 31 Jan 2011 00:53:14 +0100
Subject: PROBLEM: in kernel 2.6.37 and 2.6.38-rc1, rc2. Suspend Fails
From: dsl6346@mail.telenor.dk
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi , Im sorry about the format. Ive have 2 bugs they may or not be related,

Ill try to make 2 reports in one mail, i took the format from here:'
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html

[1.] 2.6.38-rc1 and 2.6.38-rc2 hard shutdown when resuming
[2.] During resume after a suspend to memory the machine will immediately do hard shutdown. eg
when i open the lid on my laptop the systempowers off completely making me loose me session 
at best.

[3.] Keywords (i.e., modules, networking, kernel): kernel,resume,suspend-to-mem
[4.] Kernel version (from /proc/version): 2.6.38-rc2
[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt) none,  but im willing to try at get some
output
[6.] A small shell script or example program which triggers the
     problem (if possible) none , but im willing to help recreate it , its just suspend to mem
and resuming.
[7.] Environment:
Ubuntu 10.04 customer kernel , bleeding edge intel IGP driver, but i have confimered that the
problem does occur on a stable kernel.
[7.1.] Software (add the output of the ver_linux script here)

c@zeta:/usr/src/linux$ ./scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 (showed running from an older kernel since i NEED resume and suspend to mem)
Linux zeta 2.6.37 #1 SMP PREEMPT Fri Jan 7 02:07:07 CET 2011 i686 GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.11
pcmciautils            014
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         30
Modules Loaded         joydev usbhid hid ecryptfs binfmt_misc ipt_LOG ipt_REJECT iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables sha256_generic aes_i586
aes_generic ip6t_LOG xt_limit ip6t_REJECT xt_tcpudp ip6t_ah nf_conntrack_ipv6 nf_defrag_ipv6
xt_state ip6table_filter ip6_tables dm_crypt x_tables snd_hda_codec_hdmi
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss kvm_intel
snd_mixer_oss kvm snd_pcm arc4 thinkpad_acpi snd_seq_dummy iwlagn snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event iwlcore snd_seq mac80211 snd_timer snd_seq_device cfg80211 snd
tpm_tis nf_conntrack_ftp psmouse tpm serio_raw tpm_bios soundcore nvram nf_conntrack shpchp
snd_page_alloc ext4 mbcache jbd2 fbcon tileblit font bitblit softcursor i915 drm_kms_helper
drm i2c_algo_bit i2c_core intel_agp intel_gtt e1000e agpgart video output ahci libahci

[7.2.] Processor information (from /proc/cpuinfo):
its a i7 mobile so 2 cores + 2 virtual cores (hyperthreading) 4 locigal cores
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i7 CPU       L 640  @ 2.13GHz
stepping	: 2
cpu MHz		: 1199.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts
acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr
pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4256.37
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):
joydev 8169 0 - Live 0xface3000
usbhid 33685 0 - Live 0xfac60000
hid 66182 1 usbhid, Live 0xfac00000
ecryptfs 84674 1 - Live 0xf9a62000
binfmt_misc 6228 1 - Live 0xf85be000
ipt_LOG 6379 2 - Live 0xf94c3000
ipt_REJECT 1857 1 - Live 0xf94b0000
iptable_nat 3341 0 - Live 0xf8e7e000
nf_nat 14631 1 iptable_nat, Live 0xf8ea2000
nf_conntrack_ipv4 10377 5 iptable_nat,nf_nat, Live 0xf86cc000
nf_defrag_ipv4 1029 1 nf_conntrack_ipv4, Live 0xf8694000
iptable_filter 1214 1 - Live 0xf85e1000
ip_tables 9883 2 iptable_nat,iptable_filter, Live 0xf85cc000
sha256_generic 11147 2 - Live 0xf8545000
aes_i586 7224 363 - Live 0xf94c6000
aes_generic 26755 1 aes_i586, Live 0xf94ba000
ip6t_LOG 7178 2 - Live 0xf8ed8000
xt_limit 1210 4 - Live 0xf8ecd000
ip6t_REJECT 2405 1 - Live 0xf8ec3000
xt_tcpudp 1839 72 - Live 0xf8eb9000
ip6t_ah 949 1 - Live 0xf8eaf000
nf_conntrack_ipv6 5498 2 - Live 0xf8ea8000
nf_defrag_ipv6 4905 1 nf_conntrack_ipv6, Live 0xf89fd000
xt_state 926 4 - Live 0xf86c4000
ip6table_filter 1187 1 - Live 0xf85d1000
ip6_tables 11283 3 ip6t_LOG,ip6t_ah,ip6table_filter, Live 0xf8564000
dm_crypt 10576 1 - Live 0xf854a000
x_tables 15032 13
ipt_LOG,ipt_REJECT,iptable_nat,iptable_filter,ip_tables,ip6t_LOG,xt_limit,ip6t_REJECT,xt_tcpudp,ip6t_ah,xt_state,ip6table_filter,ip6_tables,
Live 0xf852c000
snd_hda_codec_hdmi 20232 1 - Live 0xf94f9000
snd_hda_codec_conexant 38131 1 - Live 0xf9434000
snd_hda_intel 21118 2 - Live 0xf86df000
snd_hda_codec 80723 3 snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live 0xf94c9000
snd_hwdep 5112 1 snd_hda_codec, Live 0xf85a2000
snd_pcm_oss 32939 0 - Live 0xf86b3000
kvm_intel 39855 0 - Live 0xf8575000
snd_mixer_oss 12736 1 snd_pcm_oss, Live 0xf84ce000
kvm 199478 1 kvm_intel, Live 0xf9479000
snd_pcm 68370 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf9421000
arc4 1077 2 - Live 0xf85af000
thinkpad_acpi 63407 0 - Live 0xf8e62000
snd_seq_dummy 1262 0 - Live 0xf8500000
iwlagn 172118 0 - Live 0xf93f4000
snd_seq_oss 24520 0 - Live 0xf85a7000
snd_seq_midi 4236 0 - Live 0xf84f5000
snd_rawmidi 17798 1 snd_seq_midi, Live 0xf848b000
snd_seq_midi_event 5703 2 snd_seq_oss,snd_seq_midi, Live 0xf84ca000
iwlcore 61627 1 iwlagn, Live 0xf8682000
snd_seq 44371 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf85b1000
mac80211 227001 2 iwlagn,iwlcore, Live 0xf943f000
snd_timer 17483 2 snd_pcm,snd_seq, Live 0xf8510000
snd_seq_device 5306 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf84e1000
cfg80211 136006 3 iwlagn,iwlcore,mac80211, Live 0xf89d9000
snd 51373 18
snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,thinkpad_acpi,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xf86d0000
tpm_tis 7250 0 - Live 0xf86c8000
nf_conntrack_ftp 5209 0 - Live 0xf85ea000
psmouse 48968 0 - Live 0xf8697000
tpm 13337 1 tpm_tis, Live 0xf85db000
serio_raw 3616 0 - Live 0xf84fa000
tpm_bios 4713 1 tpm, Live 0xf84f1000
soundcore 6140 1 snd, Live 0xf85c1000
nvram 5677 1 thinkpad_acpi, Live 0xf84a8000
nf_conntrack 62080 6
iptable_nat,nf_nat,nf_conntrack_ipv4,nf_conntrack_ipv6,xt_state,nf_conntrack_ftp, Live
0xf84ab000
shpchp 23866 0 - Live 0xf84d3000
snd_page_alloc 6968 2 snd_hda_intel,snd_pcm, Live 0xf8491000
ext4 245295 2 - Live 0xf8e02000
mbcache 5758 1 ext4, Live 0xf86f0000
jbd2 53005 1 ext4, Live 0xf85f0000
fbcon 34677 72 - Live 0xf856a000
tileblit 1891 1 fbcon, Live 0xf853b000
font 7481 1 fbcon, Live 0xf8528000
bitblit 4277 1 fbcon, Live 0xf851c000
softcursor 1113 1 bitblit, Live 0xf850d000
i915 339799 10 - Live 0xf8782000
drm_kms_helper 31157 1 i915, Live 0xf8494000
drm 162266 6 i915,drm_kms_helper, Live 0xf8461000
i2c_algo_bit 4520 1 i915, Live 0xf854e000
i2c_core 20880 4 i915,drm_kms_helper,drm,i2c_algo_bit, Live 0xf8533000
intel_agp 9690 1 i915, Live 0xf8540000
intel_gtt 12918 3 i915,intel_agp, Live 0xf8516000
e1000e 124992 0 - Live 0xf8439000
agpgart 29075 3 drm,intel_agp,intel_gtt, Live 0xf84c0000
video 10908 1 i915, Live 0xf8502000
output 1667 1 video, Live 0xf84a5000
ahci 18218 3 - Live 0xf84da000
libahci 18570 1 ahci, Live 0xf849e000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  0800-080f : pnp 00:03
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-107f : pnp 00:03
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-102f : ACPI GPE0_BLK
    1050-1050 : ACPI PM2_CNT_BLK
  1180-11ff : pnp 00:03
  15e0-15ef : pnp 00:03
  1600-1641 : pnp 00:03
  164e-164f : pnp 00:03
  1800-1807 : 0000:00:02.0
  1810-1813 : 0000:00:1f.2
    1810-1813 : ahci
  1814-1817 : 0000:00:1f.2
    1814-1817 : ahci
  1818-181f : 0000:00:1f.2
    1818-181f : ahci
  1820-183f : 0000:00:19.0
  1840-185f : 0000:00:1f.2
    1840-185f : ahci
  1860-1867 : 0000:00:1f.2
    1860-1867 : ahci
  1880-189f : 0000:00:1f.3
  2000-2fff : PCI Bus 0000:05

$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009e7ff : System RAM
0009e800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000d0000-000d0fff : Adapter ROM
000d1000-000d1fff : Adapter ROM
000d2000-000d3fff : reserved
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000fffff : reserved
  000e0000-000effff : Extension ROM
  000f0000-000fffff : System ROM
00100000-bb27bfff : System RAM
  00100000-004ba356 : Kernel code
  004ba357-0066b487 : Kernel data
  006dd000-0073d6cb : Kernel bss
bb27c000-bb281fff : reserved
bb282000-bb35efff : System RAM
bb35f000-bb370fff : reserved
bb371000-bb3f1fff : ACPI Non-volatile Storage
bb3f2000-bb40efff : reserved
bb40f000-bb46efff : System RAM
bb46f000-bb667fff : reserved
bb668000-bb6e7fff : ACPI Non-volatile Storage
bb6e8000-bb70efff : reserved
bb70f000-bb716fff : System RAM
bb717000-bb71efff : reserved
bb71f000-bb76afff : System RAM
bb76b000-bb776fff : ACPI Non-volatile Storage
bb777000-bb779fff : ACPI Tables
bb77a000-bb780fff : ACPI Non-volatile Storage
bb781000-bb781fff : ACPI Tables
bb782000-bb78afff : ACPI Non-volatile Storage
bb78b000-bb78bfff : ACPI Tables
bb78c000-bb79efff : ACPI Non-volatile Storage
bb79f000-bb7fefff : ACPI Tables
bb7ff000-bb7fffff : System RAM
bb800000-bfffffff : reserved
c0000000-febfffff : PCI Bus 0000:00
  c0000000-c0000fff : Intel Flush Page
  d0000000-dfffffff : 0000:00:02.0
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:03
  f0000000-f1ffffff : PCI Bus 0000:05
  f2000000-f23fffff : 0000:00:02.0
  f2400000-f24fffff : PCI Bus 0000:02
    f2400000-f2401fff : 0000:02:00.0
      f2400000-f2401fff : iwlagn
  f2500000-f251ffff : 0000:00:19.0
    f2500000-f251ffff : e1000e
  f2520000-f2523fff : 0000:00:1b.0
    f2520000-f2523fff : ICH HD audio
  f2525000-f2525fff : 0000:00:19.0
    f2525000-f2525fff : e1000e
  f2526000-f2526fff : 0000:00:1f.6
    f2526000-f2526fff : ips thermal sensor
  f2727000-f27277ff : 0000:00:1f.2
    f2727000-f27277ff : ahci
  f2727800-f272780f : 0000:00:16.0
  f2728000-f27283ff : 0000:00:1a.0
    f2728000-f27283ff : ehci_hcd
  f2728400-f27287ff : 0000:00:1d.0
    f2728400-f27287ff : ehci_hcd
  f2728800-f27288ff : 0000:00:1f.3
  f2800000-f28fffff : PCI Bus 0000:05
  feaff000-feafffff : reserved
    feaff000-feafffff : pnp 00:03
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed10000-fed13fff : pnp 00:03
fed18000-fed18fff : pnp 00:03
fed19000-fed19fff : pnp 00:03
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:03
  fed45000-fed4bfff : pnp 00:03
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
100000000-137ffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
	Subsystem: Lenovo Device 2193
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics
Controller (rev 02)
	Subsystem: Lenovo Device 215a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCIe advanced features <?>
	Kernel driver in use: i915
	Kernel modules: i915

00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI
Controller (rev 06)
	Subsystem: Lenovo Device 215f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2727800 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Connection (rev 06)
	Subsystem: Lenovo Device 2153
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f2500000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f2525000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1820 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0800c  Data: 41c2
	Capabilities: [e0] PCIe advanced features <?>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host
Controller (rev 06) (prog-if 20)
	Subsystem: Lenovo Device 2163
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at f2728000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio
(rev 06)
	Subsystem: Lenovo Device 215e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 41
	Region 0: Memory at f2520000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0f00c  Data: 41aa
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1
(rev 06)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 10.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Lenovo Device 2164
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4
(rev 06)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f0000000-f1ffffff
	Prefetchable memory behind bridge: 00000000f2800000-00000000f28fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 10.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Lenovo Device 2164
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5
(rev 06)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f2400000-f24fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  4, PowerLimit 10.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Lenovo Device 2164
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host
Controller (rev 06) (prog-if 20)
	Subsystem: Lenovo Device 2163
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f2728400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Lenovo Device 2165

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
	Subsystem: Lenovo Device 2166
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI
Controller (rev 06) (prog-if 01)
	Subsystem: Lenovo Device 2168
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 40
	Region 0: I/O ports at 1860 [size=8]
	Region 1: I/O ports at 1814 [size=4]
	Region 2: I/O ports at 1818 [size=8]
	Region 3: I/O ports at 1810 [size=4]
	Region 4: I/O ports at 1840 [size=32]
	Region 5: Memory at f2727000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0c00c  Data: 4159
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
	Subsystem: Lenovo Device 2167
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2728800 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1880 [size=32]
	Kernel modules: i2c-i801

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal
Subsystem (rev 06)
	Subsystem: Lenovo Device 2190
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f2526000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: intel ips

02:00.0 Network controller: Intel Corporation WiFi Link 6000 Series (rev 35)
	Subsystem: Intel Corporation Device 1311
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at f2400000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0100c  Data: 4171
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number 1c-e2-ab-ff-ff-14-23-00
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core
Registers (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address
Decoder (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0

ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0

ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
	Subsystem: Lenovo Device 2196
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
<PERR- INTx-
	Latency: 0

[7.6.] SCSI information (from /proc/scsi/scsi)
 cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: INTEL SSDSA2M080 Rev: 2CV1
  Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
As told in the beginning i have a similar problem on 2.6.37 suspend and resume seems complete
stable EXCEPT,, if i have a plugged in  a huawei usb modem THEN, the system wont suspend but
rather it flashes the suspend light and then hangs there forever untill i do a hard shutdown.



-----------------------------
dmesg :
[151547.516817] USB Mass Storage support registered.
[151547.682394] usb 1-1.1: USB disconnect, address 7
[151553.770222] usb 1-1.1: new high speed USB device using ehci_hcd and address 8
[151553.876178] scsi10 : usb-storage 1-1.1:1.2
[151553.877190] scsi11 : usb-storage 1-1.1:1.3
[151553.899216] usbcore: registered new interface driver usbserial
[151553.899303] USB Serial support registered for generic
[151553.956433] usbcore: registered new interface driver usbserial_generic
[151553.956439] usbserial: USB Serial Driver core
[151553.967904] USB Serial support registered for GSM modem (1-port)
[151553.967968] option 1-1.1:1.0: GSM modem (1-port) converter detected
[151553.968250] usb 1-1.1: GSM modem (1-port) converter now attached to ttyUSB0
[151553.968275] option 1-1.1:1.1: GSM modem (1-port) converter detected
[151553.968485] usb 1-1.1: GSM modem (1-port) converter now attached to ttyUSB1
[151553.968616] usbcore: registered new interface driver option
[151553.968621] option: v0.7.2:USB Driver for GSM modems
[151554.878075] scsi 10:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
[151554.879006] scsi 10:0:0:0: Attached scsi generic sg1 type 5
[151554.881553] scsi 11:0:0:0: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
[151554.884535] sd 11:0:0:0: Attached scsi generic sg2 type 0
[151554.895683] sd 11:0:0:0: [sdb] Attached SCSI removable disk
[151557.412611] sd 11:0:0:0: [sdb] 7744512 512-byte logical blocks: (3.96 GB/3.69 GiB)
[151557.415536] sd 11:0:0:0: [sdb] Assuming drive cache: write through
[151557.425555] sd 11:0:0:0: [sdb] Assuming drive cache: write through
[151557.429525]  sdb: sdb1

lsusb entry about the huawei device:
Bus 001 Device 008: ID 12d1:1003 Huawei Technologies Co., Ltd. E220 HSDPA Modem / E270
HSDPA/HSUPA Modem
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x12d1 Huawei Technologies Co., Ltd.
  idProduct          0x1003 E220 HSDPA Modem / E270 HSDPA/HSUPA Modem
  bcdDevice            0.00
  iManufacturer           2 HUAWEI Technology
  iProduct                1 HUAWEI Mobile
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          196
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 01 03 00
      ** UNRECOGNIZED:  05 24 06 00 00
      ** UNRECOGNIZED:  15 24 12 20 01 98 b0 6a 49 b0 9e 48 96 94 46 d9 9a 28 ca 4e 5d
      ** UNRECOGNIZED:  06 24 13 00 01 10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 15 00 01
      ** UNRECOGNIZED:  05 24 06 01 01
      ** UNRECOGNIZED:  15 24 12 20 01 98 b0 6a 49 b0 9e 48 96 94 46 d9 9a 28 ca 4e 5d
      ** UNRECOGNIZED:  06 24 13 00 01 10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled




