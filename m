Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2AURJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:09:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37848 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2AURJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:09:23 -0500
Message-ID: <4F1AF145.2090407@gmail.com>
Date: Sat, 21 Jan 2012 17:09:25 +0000
From: Chris Diamand <chris.diamand@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tiwai@suse.de, melchior.franz@gmail.com
Subject: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the problem described in the thread here 
(https://lkml.org/lkml/2011/4/29/217) where the backlight
values are reversed so although stuff is displayed on the screen, the 
backlight is off. This occurs with kernels from about 2.6.39 onwards.

After booting a "broken" kernel (>~2.6.39), the backlight can be lit 
temporarily with:
setpci -s 00:02.0 F4.B=0
and then turned off with:
setpci -s 00:02.0 F4.B=FF

Yesterday I tried this patch, https://lkml.org/lkml/2011/4/30/37 by 
manually applying it to the 3.2.1
kernel source - this fixes the problem.

** Unfortunately the LKML thread stops after this patch and given that 
the problem is still present in the latest source, this code wasn't 
pushed into the kernel. Is there a reason for this or was it just 
forgotten about? What can I do about this? I am happy to make a git 
patch with the latest source if this will help.

If it is relevant, the backlight brightness controls (Fn-left, Fn-right) 
have never worked on any kernel
version, although they are picked up by acpi_listen.

The machine is a Packard Bell XS butterfly laptop, 11.6", 1.3GHz celeron 
743, 2gb ram, etc.
As per the posting guidelines, here is loads of info about it:

# dmesg|grep acer

[    9.820622] acer_wmi: Acer Laptop ACPI-WMI Extras
[    9.821841] acer_wmi: Function bitmap for Communication Device: 0x81
[    9.822005] acer_wmi: Brightness must be controlled by generic video 
driver


# lspci -v

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory 
Controller Hub (rev 07)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, fast devsel, latency 0
         Capabilities: [e0] Vendor Specific Information: Len=0a <?>
         Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series 
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA 
controller])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, fast devsel, latency 0, IRQ 47
         Memory at 90000000 (64-bit, non-prefetchable) [size=4M]
         Memory at 80000000 (64-bit, prefetchable) [size=256M]
         I/O ports at 50d0 [size=8]
         Expansion ROM at <unassigned> [disabled]
         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Capabilities: [d0] Power Management version 3
         Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset 
Integrated Graphics Controller (rev 07)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, fast devsel, latency 0
         Memory at 93400000 (64-bit, non-prefetchable) [size=1M]
         Capabilities: [d0] Power Management version 3

00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, medium devsel, latency 0, IRQ 20
         I/O ports at 50a0 [size=32]
         Capabilities: [50] PCI Advanced Features
         Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 03) (prog-if 20 [EHCI])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, medium devsel, latency 0, IRQ 21
         Memory at 96705c00 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] PCI Advanced Features
         Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 03)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, fast devsel, latency 0, IRQ 45
         Memory at 96700000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
         Capabilities: [100] Virtual Channel
         Capabilities: [130] Root Complex Link
         Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 03) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
         I/O behind bridge: 00004000-00004fff
         Memory behind bridge: 95700000-966fffff
         Prefetchable memory behind bridge: 
0000000090400000-00000000913fffff
         Capabilities: [40] Express Root Port (Slot+), MSI 00
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 034b
         Capabilities: [a0] Power Management version 2
         Capabilities: [100] Virtual Channel
         Capabilities: [180] Root Complex Link
         Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 03) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
         I/O behind bridge: 00003000-00003fff
         Memory behind bridge: 94600000-956fffff
         Prefetchable memory behind bridge: 
0000000091400000-00000000923fffff
         Capabilities: [40] Express Root Port (Slot+), MSI 00
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 034b
         Capabilities: [a0] Power Management version 2
         Capabilities: [100] Virtual Channel
         Capabilities: [180] Root Complex Link
         Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 3 (rev 03) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
         I/O behind bridge: 00001000-00002fff
         Memory behind bridge: 93500000-945fffff
         Prefetchable memory behind bridge: 
0000000092400000-00000000933fffff
         Capabilities: [40] Express Root Port (Slot+), MSI 00
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 034b
         Capabilities: [a0] Power Management version 2
         Capabilities: [100] Virtual Channel
         Capabilities: [180] Root Complex Link
         Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: medium devsel, IRQ 23
         I/O ports at 5080 [size=32]
         Capabilities: [50] PCI Advanced Features
         Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: medium devsel, IRQ 19
         I/O ports at 5060 [size=32]
         Capabilities: [50] PCI Advanced Features
         Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, medium devsel, latency 0, IRQ 20
         I/O ports at 5040 [size=32]
         Capabilities: [50] PCI Advanced Features
         Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 03) (prog-if 20 [EHCI])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: medium devsel, IRQ 23
         Memory at 96705800 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] PCI Advanced Features
         Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) 
(prog-if 01 [Subtractive decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
         Capabilities: [50] Subsystem: Acer Incorporated [ALI] Device 034b

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller 
(rev 03)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, medium devsel, latency 0
         Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E) 
4 port SATA Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 43
         I/O ports at 50c8 [size=8]
         I/O ports at 50dc [size=4]
         I/O ports at 50c0 [size=8]
         I/O ports at 50d8 [size=4]
         I/O ports at 5020 [size=32]
         Memory at 96705000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
         Capabilities: [70] Power Management version 3
         Capabilities: [a8] SATA HBA v1.0
         Capabilities: [b0] PCI Advanced Features
         Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller 
(rev 03)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: medium devsel, IRQ 18
         Memory at 96706000 (64-bit, non-prefetchable) [size=256]
         I/O ports at 5000 [size=32]
         Kernel driver in use: i801_smbus

00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 
Family) Thermal Subsystem (rev 03)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: fast devsel, IRQ 11
         Memory at 96704000 (64-bit, non-prefetchable) [size=4K]
         Capabilities: [50] Power Management version 3

04:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
         Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
         Flags: bus master, fast devsel, latency 0, IRQ 44
         Memory at 94600000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [c8] Power Management version 3
         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Capabilities: [e0] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Device Serial Number 00-1e-64-ff-ff-3a-4c-ec
         Kernel driver in use: iwlwifi

05:00.0 Ethernet controller: Atheros Communications Inc. AR8131 Gigabit 
Ethernet (rev c0)
         Subsystem: Acer Incorporated [ALI] Device 034b
         Flags: bus master, fast devsel, latency 0, IRQ 46
         Memory at 93500000 (64-bit, non-prefetchable) [size=256K]
         I/O ports at 1000 [size=128]
         Capabilities: [40] Power Management version 3
         Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Capabilities: [58] Express Endpoint, MSI 00
         Capabilities: [6c] Vital Product Data
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [180] Device Serial Number ff-0b-61-4b-70-5a-b6-ff
         Kernel driver in use: atl1c


# cat /proc/cpuinfo

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Celeron(R) CPU          743  @ 1.30GHz
stepping        : 10
microcode       : 0xa07
cpu MHz         : 1296.810
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss tm pbe syscall 
nx lm constant_tsc up arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm dts
bogomips        : 2593.62
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


# cat /proc/modules

aes_x86_64 7760 3 - Live 0xffffffffa0089000
aes_generic 27055 1 aes_x86_64, Live 0xffffffffa007f000
mperf 1429 0 - Live 0xffffffffa0075000
cpufreq_userspace 2152 0 - Live 0xffffffffa0071000
cpufreq_powersave 994 0 - Live 0xffffffffa006d000
cpufreq_stats 3093 0 - Live 0xffffffffa0069000
cpufreq_conservative 5057 0 - Live 0xffffffffa0035000
bluetooth 78815 2 - Live 0xffffffffa0002000
i915 376275 2 - Live 0xffffffffa0721000
drm_kms_helper 28203 1 i915, Live 0xffffffffa0714000
drm 199595 3 i915,drm_kms_helper, Live 0xffffffffa06cd000
i2c_algo_bit 4834 1 i915, Live 0xffffffffa06c8000
uinput 6725 1 - Live 0xffffffffa06c3000
fuse 58861 1 - Live 0xffffffffa06ac000
nfsd 212927 2 - Live 0xffffffffa066a000
exportfs 3447 1 nfsd, Live 0xffffffffa0666000
nfs 264646 0 - Live 0xffffffffa0610000
lockd 66446 2 nfsd,nfs, Live 0xffffffffa05f7000
fscache 41009 1 nfs, Live 0xffffffffa05e4000
auth_rpcgss 37737 2 nfsd,nfs, Live 0xffffffffa05d4000
nfs_acl 2317 2 nfsd,nfs, Live 0xffffffffa05d0000
sunrpc 196478 6 nfsd,nfs,lockd,auth_rpcgss,nfs_acl, Live 0xffffffffa058a000
loop 15447 0 - Live 0xffffffffa0582000
joydev 9152 0 - Live 0xffffffffa057c000
snd_hda_codec_hdmi 22257 1 - Live 0xffffffffa0571000
snd_hda_codec_realtek 197108 1 - Live 0xffffffffa0536000
arc4 1353 2 - Live 0xffffffffa0532000
snd_hda_intel 23473 3 - Live 0xffffffffa0526000
snd_hda_codec 93483 3 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 
0xffffffffa0501000
snd_hwdep 5752 1 snd_hda_codec, Live 0xffffffffa04fb000
snd_pcm 73041 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 
0xffffffffa04df000
snd_seq 46164 0 - Live 0xffffffffa04cc000
snd_timer 18682 2 snd_pcm,snd_seq, Live 0xffffffffa04c2000
snd_seq_device 5829 1 snd_seq, Live 0xffffffffa04bd000
iwlwifi 165948 0 - Live 0xffffffffa0487000
snd 60683 15 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffffa046e000
uvcvideo 53221 0 - Live 0xffffffffa045c000
soundcore 6558 1 snd, Live 0xffffffffa0456000
videodev 79468 1 uvcvideo, Live 0xffffffffa0439000
mac80211 201126 1 iwlwifi, Live 0xffffffffa03f6000
i2c_i801 7770 0 - Live 0xffffffffa03f0000
psmouse 56724 0 - Live 0xffffffffa03da000
cfg80211 146500 2 iwlwifi,mac80211, Live 0xffffffffa03a8000
iTCO_wdt 12072 0 - Live 0xffffffffa03a0000
acer_wmi 20155 0 - Live 0xffffffffa0396000
v4l2_compat_ioctl32 7727 1 videodev, Live 0xffffffffa0391000
mxm_wmi 1851 0 - Live 0xffffffffa038d000
sparse_keymap 3594 1 acer_wmi, Live 0xffffffffa0389000
iTCO_vendor_support 2797 1 iTCO_wdt, Live 0xffffffffa0385000
pcspkr 1830 0 - Live 0xffffffffa0381000
evdev 8569 16 - Live 0xffffffffa0373000
serio_raw 4177 0 - Live 0xffffffffa036e000
i2c_core 23165 6 i915,drm_kms_helper,drm,i2c_algo_bit,videodev,i2c_i801, 
Live 0xffffffffa0362000
snd_page_alloc 7422 2 snd_hda_intel,snd_pcm, Live 0xffffffffa035c000
rfkill 16037 4 bluetooth,cfg80211,acer_wmi, Live 0xffffffffa0353000
wmi 9150 2 acer_wmi,mxm_wmi, Live 0xffffffffa0345000
battery 6802 0 - Live 0xffffffffa0340000
ac 2438 0 - Live 0xffffffffa033c000
button 5105 1 i915, Live 0xffffffffa032f000
video 12154 1 i915, Live 0xffffffffa0327000
processor 27867 1 - Live 0xffffffffa02f3000
ext4 386181 2 - Live 0xffffffffa0278000
mbcache 6317 1 ext4, Live 0xffffffffa0272000
jbd2 70425 1 ext4, Live 0xffffffffa0256000
crc16 1643 1 ext4, Live 0xffffffffa0252000
sr_mod 13275 0 - Live 0xffffffffa0246000
sd_mod 30692 4 - Live 0xffffffffa0239000
cdrom 33723 1 sr_mod, Live 0xffffffffa022b000
crc_t10dif 1499 1 sd_mod, Live 0xffffffffa0227000
uhci_hcd 18980 0 - Live 0xffffffffa021e000
ahci 19800 3 - Live 0xffffffffa0214000
libahci 20328 1 ahci, Live 0xffffffffa020a000
libata 169193 2 ahci,libahci, Live 0xffffffffa01ca000
scsi_mod 190814 3 sr_mod,sd_mod,libata, Live 0xffffffffa0142000
ehci_hcd 33755 0 - Live 0xffffffffa01bc000
thermal 8342 0 - Live 0xffffffffa0199000
thermal_sys 14742 3 video,processor,thermal, Live 0xffffffffa0191000
atl1c 27404 0 - Live 0xffffffffa0185000
usbcore 146444 4 uvcvideo,uhci_hcd,ehci_hcd, Live 0xffffffffa0039000
usb_common 1117 1 usbcore, Live 0xffffffffa0000000


# cat /proc/ioports

0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : EC cmd
   0070-0077 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   03c0-03df : vga+
   0400-047f : pnp 00:01
     0400-0403 : ACPI PM1a_EVT_BLK
     0404-0405 : ACPI PM1a_CNT_BLK
     0408-040b : ACPI PM_TMR
     0410-0415 : ACPI CPU throttle
     0420-042f : ACPI GPE0_BLK
     0430-0433 : iTCO_wdt
     0450-0450 : ACPI PM2_CNT_BLK
     0460-047f : iTCO_wdt
   0500-057f : pnp 00:01
   0600-060f : pnp 00:01
   0610-0610 : pnp 00:01
   0800-080f : pnp 00:01
   0810-0817 : pnp 00:01
   0820-0823 : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   1000-2fff : PCI Bus 0000:05
     1000-107f : 0000:05:00.0
       1000-107f : atl1c
   3000-3fff : PCI Bus 0000:04
   4000-4fff : PCI Bus 0000:02
   5000-501f : 0000:00:1f.3
     5000-501f : i801_smbus
   5020-503f : 0000:00:1f.2
     5020-503f : ahci
   5040-505f : 0000:00:1d.2
     5040-505f : uhci_hcd
   5060-507f : 0000:00:1d.1
     5060-507f : uhci_hcd
   5080-509f : 0000:00:1d.0
     5080-509f : uhci_hcd
   50a0-50bf : 0000:00:1a.0
     50a0-50bf : uhci_hcd
   50c0-50c7 : 0000:00:1f.2
     50c0-50c7 : ahci
   50c8-50cf : 0000:00:1f.2
     50c8-50cf : ahci
   50d0-50d7 : 0000:00:02.0
   50d8-50db : 0000:00:1f.2
     50d8-50db : ahci
   50dc-50df : 0000:00:1f.2
     50dc-50df : ahci
   ff2c-ff2f : pnp 00:01


I am new to all this kernel dev/mailing list stuff so I apologize in 
advance if I have done anything wrong by sending this.
Thanks for the help,
Chris.
