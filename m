Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2KRKrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 05:47:12 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2KRKrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 05:47:09 -0500
Message-ID: <50A8BCA6.7080102@rkellis.com>
Date: Sun, 18 Nov 2012 18:47:02 +0800
From: Mark Ellis <m@rkellis.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: REGRESSION in drivers/platform/x86/dell-laptop.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. rfkill code removal causes hang

2. the rfkill code was removed from this driver in commit 
53039f222c548bfc119eea6df4dca2b57550e271 this results in my computer 
hanging (dell n5050) if booting with the wireless (hardware) disabled. 
downgrading this module to the version prior to this commit fixes the issue.

3. modules, laptop, dell-laptop, rfkill

4. Linux version 3.6-trunk-rt-amd64 (debian-kernel@lists.debian.org) 
(gcc version 4.6.3 (Debian 4.6.3-1) ) #1 SMP PREEMPT RT Debian 
3.6.6-1~experimental.1

5. n/a

6. n/a

7. dell laptop (n5050) with wireless disabled

7.1.
Linux laptop 3.6-trunk-rt-amd64 #1 SMP PREEMPT RT Debian 
3.6.6-1~experimental.1 x86_64 GNU/Linux

Gnu C                  4.7
Gnu make               3.81
binutils               2.22
util-linux             scripts/ver_linux: 23: scripts/ver_linux: 
fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.3.4
Kbd                    1.15.3
Sh-utils               8.20
Modules Loaded         cpufreq_userspace cpufreq_conservative 
cpufreq_powersave cpufreq_stats xt_tcpudp xt_conntrack iptable_filter 
iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_conntrack iptable_raw ip_tables x_tables pci_stub 
vboxpci vboxnetadp vboxnetflt vboxdrv snd_hda_codec_hdmi 
snd_hda_codec_idt iTCO_wdt iTCO_vendor_support joydev arc4 dell_laptop 
dcdbas brcmsmac cordic brcmutil mac80211 cfg80211 rfkill dell_wmi 
sparse_keymap coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel 
aesni_intel aes_x86_64 aes_generic ablk_helper cryptd evdev microcode 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
psmouse snd_page_alloc serio_raw snd_seq_midi snd_seq_midi_event lpc_ich 
i2c_i801 mfd_core snd_rawmidi snd_seq snd_seq_device i915 snd_timer 
acpi_cpufreq drm_kms_helper bcma video wmi mperf snd battery drm ac 
i2c_algo_bit soundcore i2c_core button processor loop fuse autofs4 ext4 
crc16 jbd2 mbcache sg sr_mod sd_mod crc_t10dif cdrom thermal ahci 
thermal_sys libahci ehci_hcd libata usbcore scsi_mod usb_common

7.2.
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2430M CPU @ 2.40GHz
stepping	: 7
microcode	: 0x1b
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology 
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer 
aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow 
vnmi flexpriority ept vpid
bogomips	: 4789.50
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2430M CPU @ 2.40GHz
stepping	: 7
microcode	: 0x1b
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology 
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer 
aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow 
vnmi flexpriority ept vpid
bogomips	: 4789.50
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2430M CPU @ 2.40GHz
stepping	: 7
microcode	: 0x1b
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology 
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer 
aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow 
vnmi flexpriority ept vpid
bogomips	: 4789.50
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2430M CPU @ 2.40GHz
stepping	: 7
microcode	: 0x1b
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology 
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer 
aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow 
vnmi flexpriority ept vpid
bogomips	: 4789.50
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

7.3.
cpufreq_userspace 12576 0 - Live 0xffffffffa0793000
cpufreq_conservative 13147 0 - Live 0xffffffffa078e000
cpufreq_powersave 12454 4 - Live 0xffffffffa0789000
cpufreq_stats 12866 0 - Live 0xffffffffa0784000
xt_tcpudp 12570 4 - Live 0xffffffffa077f000
xt_conntrack 12681 3 - Live 0xffffffffa077a000
iptable_filter 12536 1 - Live 0xffffffffa0775000
iptable_mangle 12536 0 - Live 0xffffffffa0770000
ipt_MASQUERADE 12594 3 - Live 0xffffffffa076b000
iptable_nat 12928 1 - Live 0xffffffffa075a000
nf_nat 18222 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffffa0765000
nf_conntrack_ipv4 18549 6 iptable_nat,nf_nat, Live 0xffffffffa0754000
nf_defrag_ipv4 12483 1 nf_conntrack_ipv4, Live 0xffffffffa0760000
nf_conntrack 62257 5 
xt_conntrack,ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 
0xffffffffa0743000
iptable_raw 12524 0 - Live 0xffffffffa05b1000
ip_tables 22042 4 iptable_filter,iptable_mangle,iptable_nat,iptable_raw, 
Live 0xffffffffa05b7000
x_tables 18998 8 
xt_tcpudp,xt_conntrack,iptable_filter,iptable_mangle,ipt_MASQUERADE,iptable_nat,iptable_raw,ip_tables, 
Live 0xffffffffa05ab000
pci_stub 12429 1 - Live 0xffffffffa049b000
vboxpci 19066 0 - Live 0xffffffffa05a5000 (O)
vboxnetadp 25443 0 - Live 0xffffffffa0346000 (O)
vboxnetflt 23571 0 - Live 0xffffffffa02a3000 (O)
vboxdrv 190101 3 vboxpci,vboxnetadp,vboxnetflt, Live 0xffffffffa0575000 (O)
snd_hda_codec_hdmi 31054 1 - Live 0xffffffffa02c6000
snd_hda_codec_idt 53728 1 - Live 0xffffffffa0294000
iTCO_wdt 12831 0 - Live 0xffffffffa028f000
iTCO_vendor_support 12704 1 iTCO_wdt, Live 0xffffffffa0222000
joydev 17190 0 - Live 0xffffffffa056f000
arc4 12543 2 - Live 0xffffffffa0496000
dell_laptop 21216 0 - Live 0xffffffffa0568000 (O)
dcdbas 13307 1 dell_laptop, Live 0xffffffffa0491000
brcmsmac 454647 0 - Live 0xffffffffa04f8000
cordic 12313 1 brcmsmac, Live 0xffffffffa0459000
brcmutil 12824 1 brcmsmac, Live 0xffffffffa0465000
mac80211 353465 1 brcmsmac, Live 0xffffffffa04a0000
cfg80211 151586 2 brcmsmac,mac80211, Live 0xffffffffa046a000
rfkill 18972 3 dell_laptop,cfg80211, Live 0xffffffffa045f000
dell_wmi 12477 0 - Live 0xffffffffa036b000
sparse_keymap 12760 1 dell_wmi, Live 0xffffffffa0366000
coretemp 12898 0 - Live 0xffffffffa038d000
kvm_intel 118157 0 - Live 0xffffffffa0416000
kvm 312876 1 kvm_intel, Live 0xffffffffa03a9000
crc32c_intel 12747 0 - Live 0xffffffffa0388000
ghash_clmulni_intel 12981 0 - Live 0xffffffffa0357000
aesni_intel 50249 2 - Live 0xffffffffa039b000
aes_x86_64 16796 1 aesni_intel, Live 0xffffffffa0370000
aes_generic 33026 2 aesni_intel,aes_x86_64, Live 0xffffffffa035c000
ablk_helper 12572 1 aesni_intel, Live 0xffffffffa0352000
cryptd 14561 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 
0xffffffffa0383000
evdev 17486 19 - Live 0xffffffffa0379000
microcode 25859 0 - Live 0xffffffffa033e000
snd_hda_intel 30560 7 - Live 0xffffffffa0319000
snd_hda_codec 87759 3 
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel, Live 0xffffffffa0327000
snd_hwdep 13150 1 snd_hda_codec, Live 0xffffffffa0322000
snd_pcm_oss 37023 0 - Live 0xffffffffa030e000
snd_mixer_oss 17879 3 snd_pcm_oss, Live 0xffffffffa02f4000
snd_pcm 64011 4 
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 
0xffffffffa02fd000
psmouse 69224 0 - Live 0xffffffffa02e2000
snd_page_alloc 12969 2 snd_hda_intel,snd_pcm, Live 0xffffffffa02d9000
serio_raw 12938 0 - Live 0xffffffffa02d4000
snd_seq_midi 12848 0 - Live 0xffffffffa02cf000
snd_seq_midi_event 13316 1 snd_seq_midi, Live 0xffffffffa01a1000
lpc_ich 16665 0 - Live 0xffffffffa02b8000
i2c_i801 16949 0 - Live 0xffffffffa01ff000
mfd_core 12601 1 lpc_ich, Live 0xffffffffa01f5000
snd_rawmidi 22945 1 snd_seq_midi, Live 0xffffffffa02bf000
snd_seq 45096 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa02ab000
snd_seq_device 13176 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0xffffffffa017b000
i915 421299 2 - Live 0xffffffffa0227000
snd_timer 22841 2 snd_pcm,snd_seq, Live 0xffffffffa0213000
acpi_cpufreq 12935 1 - Live 0xffffffffa01fa000
drm_kms_helper 27228 1 i915, Live 0xffffffffa01ed000
bcma 32685 1 brcmsmac, Live 0xffffffffa01a6000
video 17629 1 i915, Live 0xffffffffa0187000
wmi 13243 1 dell_wmi, Live 0xffffffffa0176000
mperf 12453 1 acpi_cpufreq, Live 0xffffffffa021d000
snd 53001 22 
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0xffffffffa0205000
battery 13109 0 - Live 0xffffffffa0182000
drm 197836 3 i915,drm_kms_helper, Live 0xffffffffa01bb000
ac 12624 0 - Live 0xffffffffa01b6000
i2c_algo_bit 12841 1 i915, Live 0xffffffffa0197000
soundcore 13026 3 snd, Live 0xffffffffa018e000
i2c_core 23958 5 i2c_i801,i915,drm_kms_helper,drm,i2c_algo_bit, Live 
0xffffffffa01af000
button 12937 1 i915, Live 0xffffffffa019c000
processor 28491 1 acpi_cpufreq, Live 0xffffffffa0167000
loop 22468 0 - Live 0xffffffffa016f000
fuse 66340 1 - Live 0xffffffffa0155000
autofs4 27604 2 - Live 0xffffffffa00d9000
ext4 370897 2 - Live 0xffffffffa00f9000
crc16 12343 1 ext4, Live 0xffffffffa0071000
jbd2 75311 1 ext4, Live 0xffffffffa00e5000
mbcache 13065 1 ext4, Live 0xffffffffa0082000
sg 25925 0 - Live 0xffffffffa00d1000
sr_mod 21944 0 - Live 0xffffffffa00ca000
sd_mod 36245 3 - Live 0xffffffffa00c0000
crc_t10dif 12348 1 sd_mod, Live 0xffffffffa00bb000
cdrom 35401 1 sr_mod, Live 0xffffffffa00b1000
thermal 17383 0 - Live 0xffffffffa00ab000
ahci 25008 2 - Live 0xffffffffa0069000
thermal_sys 18184 3 video,processor,thermal, Live 0xffffffffa003b000
libahci 22820 1 ahci, Live 0xffffffffa0030000
ehci_hcd 40382 0 - Live 0xffffffffa0077000
libata 141082 2 ahci,libahci, Live 0xffffffffa0087000
usbcore 129022 1 ehci_hcd, Live 0xffffffffa0044000
scsi_mod 162496 4 sg,sr_mod,sd_mod,libata, Live 0xffffffffa0007000
usb_common 12354 1 usbcore, Live 0xffffffffa0000000

7.5.
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor 
Family DRAM Controller (rev 09)
	Subsystem: Dell Device 0504
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core 
Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 
[VGA controller])
	Subsystem: Dell Device 0504
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at f6800000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at f000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4191
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: i915

00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series 
Chipset Family MEI Controller #1 (rev 04)
	Subsystem: Dell Device 0504
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f7e0a000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0504
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7e08000 (32-bit, non-prefetchable) [size=1K]
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

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset 
Family High Definition Audio Controller (rev 05)
	Subsystem: Dell Device 0504
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41c1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=22
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, 
L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0504
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=09, subordinate=0a, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f7d00000-f7dfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0504
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 8 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=11, subordinate=1f, sec-latency=0
	I/O behind bridge: 0000d000-0000efff
	Memory behind bridge: f6c00000-f7cfffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, 
L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4171
	Capabilities: [90] Subsystem: Dell Device 0504
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0504
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f7e07000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC 
Controller (rev 05)
	Subsystem: Dell Device 0504
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset 
Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 0504
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 41
	Region 0: I/O ports at f0b0 [size=8]
	Region 1: I/O ports at f0a0 [size=4]
	Region 2: I/O ports at f090 [size=8]
	Region 3: I/O ports at f080 [size=4]
	Region 4: I/O ports at f060 [size=32]
	Region 5: Memory at f7e06000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4181
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family 
SMBus Controller (rev 05)
	Subsystem: Dell Device 0504
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f7e05000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at f040 [size=32]

09:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n 
Wireless LAN Controller (rev 01)
	Subsystem: Dell Device 0012
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<4us, L1 <64us
			ClockPM+ Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-e5-ff-ff-db-94-39
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: bcma-pci-bridge

7.6. n/a

7.7. n/a

workaround, reverse patch dell-laptop.c and recompile

p.s. I hope this is ok, I've never sent a kernel bug report before, feel 
free to contact me if you need more info etc

Thanks,

Mark
