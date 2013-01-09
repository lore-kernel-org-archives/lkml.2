Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3AIJ3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:29:13 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:64871 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3AIJ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:28:54 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 04:28:52 EST
Message-ID: <50ED371A.3080903@gmail.com>
Date: Wed, 09 Jan 2013 10:23:38 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
Content-Type: multipart/mixed;
 boundary="------------060806000304070006020108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060806000304070006020108
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello!

I want to report a bug resulting in kernel panic.
It happens always when I plug in AC adapter, at least happened 3 times
in a row - I didn't test it further.
Spotted on a vanilla 3.7.1 kernel. Kernel config attached.

Pictures of 2 screens with kernel panic:
http://postimage.org/image/wg80pi5e3/
http://postimage.org/image/obzwkriyz/


adrian:~$ cat /proc/version
Linux version 3.7.1 (root@adrian-lap) (gcc version 4.7.2 (Debian
4.7.2-4) ) #10 SMP PREEMPT Thu Dec 27 23:27:04 CET 2012


adrian:~/linux/kernel/linux-stable$ ./scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux adrian-lap 3.7.1 #10 SMP PREEMPT Thu Dec 27 23:27:04 CET 2012
x86_64 GNU/Linux

Gnu C                  4.7
Gnu make               3.81
binutils               2.22
util-linux             ./scripts/ver_linux: 23: ./scripts/ver_linux:
fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.3.3
Kbd                    1.15.3
Sh-utils               8.13
Modules Loaded         usb_storage hid_generic usbhid hid bnep rfcomm
binfmt_misc i8k uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc
nls_utf8 nls_cp437 vfat fat joydev loop firewire_sbp2 firewire_core
crc_itu_t arc4 snd_hda_codec_hdmi snd_hda_codec_conexant ath9k
snd_hda_intel ath9k_common snd_hda_codec ath9k_hw snd_hwdep coretemp ath
snd_pcm mac80211 uvcvideo crc32c_intel radeon snd_page_alloc snd_seq
ghash_clmulni_intel ath3k snd_seq_device videobuf2_vmalloc btusb
videobuf2_memops aesni_intel snd_timer iTCO_wdt videobuf2_core bluetooth
aes_x86_64 iTCO_vendor_support cfg80211 videodev acpi_cpufreq psmouse
ablk_helper mperf snd lpc_ich cryptd dell_wmi dell_laptop rts5139 media
sparse_keymap xts lrw dcdbas gf128mul rfkill i2c_i801 pcspkr serio_raw
soundcore mei mfd_core ttm wmi battery ac evdev processor ext4 crc16
jbd2 mbcache sg sr_mod cdrom ahci i915 microcode libahci r8169 mii
ehci_hcd xhci_hcd usbcore usb_common drm_kms_helper video thermal_sys button


adrian:~/linux/kernel/linux-stable$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 4
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 5
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 6
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
stepping        : 9
microcode       : 0x15
cpu MHz         : 1200.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips        : 4190.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


adrian:~/linux/kernel/linux-stable$ cat /proc/modules
usb_storage 51993 1 - Live 0xffffffffa078f000
hid_generic 12386 0 - Live 0xffffffffa0759000
usbhid 44588 0 - Live 0xffffffffa0783000
hid 93561 2 hid_generic,usbhid, Live 0xffffffffa0765000
bnep 17429 2 - Live 0xffffffffa075f000
rfcomm 37039 12 - Live 0xffffffffa074e000
binfmt_misc 16982 1 - Live 0xffffffffa0748000
i8k 13059 0 - Live 0xffffffffa073e000
uinput 17362 1 - Live 0xffffffffa06d9000
nfsd 237022 2 - Live 0xffffffffa0703000
auth_rpcgss 37162 1 nfsd, Live 0xffffffffa0651000
nfs_acl 12512 1 nfsd, Live 0xffffffffa049b000
nfs 131531 0 - Live 0xffffffffa06e1000
lockd 71225 2 nfsd,nfs, Live 0xffffffffa06c6000
fscache 40128 1 nfs, Live 0xffffffffa04a8000
sunrpc 190277 6 nfsd,auth_rpcgss,nfs_acl,nfs,lockd, Live 0xffffffffa0696000
nls_utf8 12457 2 - Live 0xffffffffa0496000
nls_cp437 16554 2 - Live 0xffffffffa0460000
vfat 17186 2 - Live 0xffffffffa0466000
fat 53501 1 vfat, Live 0xffffffffa0451000
joydev 17109 0 - Live 0xffffffffa038c000
loop 26561 0 - Live 0xffffffffa0449000
firewire_sbp2 21754 0 - Live 0xffffffffa0310000
firewire_core 56646 1 firewire_sbp2, Live 0xffffffffa0377000
crc_itu_t 12348 1 firewire_core, Live 0xffffffffa02e9000
arc4 12544 2 - Live 0xffffffffa02cc000
snd_hda_codec_hdmi 35497 1 - Live 0xffffffffa0427000
snd_hda_codec_conexant 53557 1 - Live 0xffffffffa0418000
ath9k 103329 0 - Live 0xffffffffa067b000
snd_hda_intel 30563 3 - Live 0xffffffffa0278000
ath9k_common 12729 1 ath9k, Live 0xffffffffa01e1000
snd_hda_codec 103985 3
snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live
0xffffffffa0660000
ath9k_hw 356764 2 ath9k,ath9k_common, Live 0xffffffffa05f8000
snd_hwdep 13149 1 snd_hda_codec, Live 0xffffffffa0431000
coretemp 12855 0 - Live 0xffffffffa02ba000
ath 21418 3 ath9k,ath9k_common,ath9k_hw, Live 0xffffffffa04a1000
snd_pcm 79843 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa0481000
mac80211 432417 1 ath9k, Live 0xffffffffa058d000
uvcvideo 78915 0 - Live 0xffffffffa046c000
crc32c_intel 12748 0 - Live 0xffffffffa036d000
radeon 850561 0 - Live 0xffffffffa04bc000
snd_page_alloc 17115 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0386000
snd_seq 52931 0 - Live 0xffffffffa040a000
ghash_clmulni_intel 13022 0 - Live 0xffffffffa0372000
ath3k 12686 0 - Live 0xffffffffa028c000
snd_seq_device 13133 1 snd_seq, Live 0xffffffffa025e000
videobuf2_vmalloc 12621 1 uvcvideo, Live 0xffffffffa0259000
btusb 17301 0 - Live 0xffffffffa01db000
videobuf2_memops 12563 1 videobuf2_vmalloc, Live 0xffffffffa04b7000
aesni_intel 54761 1 - Live 0xffffffffa043a000
snd_timer 26607 2 snd_pcm,snd_seq, Live 0xffffffffa02c4000
iTCO_wdt 12832 0 - Live 0xffffffffa030b000
videobuf2_core 30729 1 uvcvideo, Live 0xffffffffa02e0000
bluetooth 192117 25 bnep,rfcomm,ath3k,btusb, Live 0xffffffffa03da000
aes_x86_64 16844 1 aesni_intel, Live 0xffffffffa0305000
iTCO_vendor_support 12650 1 iTCO_wdt, Live 0xffffffffa0220000
cfg80211 179218 3 ath9k,ath,mac80211, Live 0xffffffffa0392000
videodev 104105 2 uvcvideo,videobuf2_core, Live 0xffffffffa03bf000
acpi_cpufreq 13055 1 - Live 0xffffffffa0217000
psmouse 76664 0 - Live 0xffffffffa023b000
ablk_helper 12573 1 aesni_intel, Live 0xffffffffa0203000
mperf 12412 1 acpi_cpufreq, Live 0xffffffffa0208000
snd 60885 15
snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffa022b000
lpc_ich 16666 0 - Live 0xffffffffa01fd000
cryptd 14560 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0xffffffffa0106000
dell_wmi 12478 0 - Live 0xffffffffa01f4000
dell_laptop 16724 0 - Live 0xffffffffa0225000
rts5139 341121 0 - Live 0xffffffffa0318000 (C)
media 18110 2 uvcvideo,videodev, Live 0xffffffffa02f9000
sparse_keymap 12761 1 dell_wmi, Live 0xffffffffa02d4000
xts 12680 1 aesni_intel, Live 0xffffffffa02db000
lrw 12758 1 aesni_intel, Live 0xffffffffa0300000
dcdbas 13257 1 dell_laptop, Live 0xffffffffa02f0000
gf128mul 12971 2 xts,lrw, Live 0xffffffffa02bf000
rfkill 19021 4 bluetooth,cfg80211, Live 0xffffffffa02b4000
i2c_i801 16965 0 - Live 0xffffffffa02aa000
pcspkr 12596 0 - Live 0xffffffffa02a2000
serio_raw 12850 0 - Live 0xffffffffa029a000
soundcore 13027 1 snd, Live 0xffffffffa0291000
mei 35676 0 - Live 0xffffffffa0282000
mfd_core 12602 1 lpc_ich, Live 0xffffffffa0150000
ttm 65441 1 radeon, Live 0xffffffffa0267000
wmi 17340 1 dell_wmi, Live 0xffffffffa01ee000
battery 13147 0 - Live 0xffffffffa01e9000
ac 12625 0 - Live 0xffffffffa0124000
evdev 17445 22 - Live 0xffffffffa0253000
processor 28153 1 acpi_cpufreq, Live 0xffffffffa020f000
ext4 443202 3 - Live 0xffffffffa016d000
crc16 12344 2 bluetooth,ext4, Live 0xffffffffa0032000
jbd2 82210 1 ext4, Live 0xffffffffa00f0000
mbcache 13035 1 ext4, Live 0xffffffffa0028000
sg 30003 0 - Live 0xffffffffa0164000
sr_mod 21856 0 - Live 0xffffffffa015d000
cdrom 39233 1 sr_mod, Live 0xffffffffa0137000
ahci 25009 4 - Live 0xffffffffa0155000
i915 518772 3 - Live 0xffffffffa0070000
microcode 17706 0 - Live 0xffffffffa014a000
libahci 26891 1 ahci, Live 0xffffffffa0142000
r8169 60215 0 - Live 0xffffffffa005e000
mii 12676 1 r8169, Live 0xffffffffa0019000
ehci_hcd 48662 0 - Live 0xffffffffa012a000
xhci_hcd 89723 0 - Live 0xffffffffa010d000
usbcore 152905 8
usb_storage,usbhid,uvcvideo,ath3k,btusb,rts5139,ehci_hcd,xhci_hcd, Live
0xffffffffa0037000
usb_common 12355 1 usbcore, Live 0xffffffffa002d000
drm_kms_helper 35296 2 radeon,i915, Live 0xffffffffa001e000
video 17687 1 i915, Live 0xffffffffa0013000
thermal_sys 22264 2 processor,video, Live 0xffffffffa0008000
button 12945 1 i915, Live 0xffffffffa0000000


adrian:~/linux/kernel/linux-stable$ cat /proc/ioports
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
  0400-0453 : pnp 00:05
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
      0430-0433 : iTCO_wdt
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:07
  0458-047f : pnp 00:05
    0460-047f : iTCO_wdt
      0460-047f : iTCO_wdt
  0500-057f : pnp 00:05
  0680-069f : pnp 00:05
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-100f : pnp 00:05
  164e-164f : pnp 00:05
  2000-2fff : PCI Bus 0000:09
  3000-3fff : PCI Bus 0000:07
    3000-30ff : 0000:07:00.0
      3000-30ff : r8169
  4000-4fff : PCI Bus 0000:01
    4000-40ff : 0000:01:00.0
  5000-503f : 0000:00:02.0
  5040-505f : 0000:00:1f.3
  5060-507f : 0000:00:1f.2
    5060-507f : ahci
  5080-5087 : 0000:00:1f.2
    5080-5087 : ahci
  5088-508f : 0000:00:1f.2
    5088-508f : ahci
  5090-5093 : 0000:00:1f.2
    5090-5093 : ahci
  5094-5097 : 0000:00:1f.2
    5094-5097 : ahci
  fd60-fd63 : pnp 00:05
  ffff-ffff : pnp 00:05
    ffff-ffff : pnp 00:05


adrian:~/linux/kernel/linux-stable$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-00087fff : System RAM
00088000-000bffff : reserved
  000a0000-000bffff : PCI Bus 0000:00
000c0000-000c3fff : PCI Bus 0000:00
000c4000-000c7fff : PCI Bus 0000:00
000c8000-000cbfff : PCI Bus 0000:00
000cc000-000cffff : PCI Bus 0000:00
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000e3fff : PCI Bus 0000:00
000e4000-000e7fff : PCI Bus 0000:00
000e8000-000ebfff : PCI Bus 0000:00
000ec000-000effff : PCI Bus 0000:00
000f0000-000fffff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
  01000000-01476aaf : Kernel code
  01476ab0-0188a3ff : Kernel data
  01925000-019f4fff : Kernel bss
20000000-201fffff : reserved
  20000000-201fffff : pnp 00:0c
20200000-40003fff : System RAM
40004000-40004fff : reserved
  40004000-40004fff : pnp 00:0c
40005000-8ffaffff : System RAM
8ffb0000-913affff : reserved
913b0000-99dbefff : System RAM
99dbf000-9aebefff : reserved
9aebf000-9afbefff : ACPI Non-volatile Storage
9afbf000-9affefff : ACPI Tables
9afff000-9affffff : System RAM
9b000000-9f9fffff : reserved
9fa00000-feafffff : PCI Bus 0000:00
  9fa00000-9fa00fff : pnp 00:0b
  9fb00000-9fbfffff : PCI Bus 0000:08
    9fb00000-9fb0ffff : 0000:08:00.0
  a0000000-afffffff : PCI Bus 0000:01
    a0000000-afffffff : 0000:01:00.0
  b0000000-bfffffff : 0000:00:02.0
  c0000000-c0ffffff : PCI Bus 0000:09
  c1000000-c1ffffff : PCI Bus 0000:09
  c2000000-c2ffffff : PCI Bus 0000:01
    c2000000-c201ffff : 0000:01:00.0
    c2020000-c203ffff : 0000:01:00.0
  c3000000-c33fffff : 0000:00:02.0
  c3400000-c34fffff : PCI Bus 0000:07
    c3400000-c3403fff : 0000:07:00.0
      c3400000-c3403fff : r8169
    c3404000-c3404fff : 0000:07:00.0
      c3404000-c3404fff : r8169
  c3500000-c35fffff : PCI Bus 0000:08
    c3500000-c357ffff : 0000:08:00.0
      c3500000-c357ffff : ath9k
  c3600000-c360ffff : 0000:00:14.0
    c3600000-c360ffff : xhci_hcd
  c3610000-c3613fff : 0000:00:1b.0
    c3610000-c3613fff : ICH HD audio
  c3614000-c361400f : 0000:00:16.0
    c3614000-c361400f : mei
  c3615000-c36150ff : 0000:00:1f.3
  c3617000-c36177ff : 0000:00:1f.2
    c3617000-c36177ff : ahci
  c3618000-c36183ff : 0000:00:1d.0
    c3618000-c36183ff : ehci_hcd
  c3619000-c36193ff : 0000:00:1a.0
    c3619000-c36193ff : ehci_hcd
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:0b
feb00000-feb03fff : reserved
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed10000-fed19fff : reserved
  fed10000-fed17fff : pnp 00:0b
  fed18000-fed18fff : pnp 00:0b
  fed19000-fed19fff : pnp 00:0b
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:0b
    fed1f410-fed1f414 : iTCO_wdt
      fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:0b
fed90000-fed93fff : pnp 00:0b
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ff000fff : pnp 00:0b
ffb80000-ffffffff : reserved
100000000-35f5fffff : System RAM
35f600000-35fffffff : RAM buffer


root:/home/adrian/linux/kernel/linux-stable# lspci -vvv
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
        Subsystem: Dell Device 056e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: c2000000-c2ffffff
        Prefetchable memory behind bridge: 00000000a0000000-00000000afffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: Dell Device 056e
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: feeff00c  Data: 41a1
        Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 256 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #2, Speed 8GT/s, Width x8, ASPM L0s L1, Latency L0 <256ns, L1 <8us
                        ClockPM- Surprise- LLActRep- BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
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
                Link0:  Desc:   TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed19000
        Capabilities: [d94 v1] #19
        Kernel driver in use: pcieport

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Dell Device 056e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 44
        Region 0: Memory at c3000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 5000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: feeff00c  Data: 4122
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
        Subsystem: Dell Device 056e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 41
        Region 0: Memory at c3600000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 41b1
        Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
        Subsystem: Dell Device 056e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 45
        Region 0: Memory at c3614000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000feeff00c  Data: 4182
        Kernel driver in use: mei

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
        Subsystem: Dell Device 056e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at c3619000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
        Subsystem: Dell Device 056e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at c3610000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000feeff00c  Data: 4192
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
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
                Link0:  Desc:   TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000c3400000-00000000c34fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Dell Device 056e
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: c3500000-c35fffff
        Prefetchable memory behind bridge: 000000009fb00000-000000009fbfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Dell Device 056e
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=09, subordinate=0e, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: c1000000-c1ffffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000c0ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Dell Device 056e
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
        Subsystem: Dell Device 056e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at c3618000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
        Subsystem: Dell Device 056e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
        Subsystem: Dell Device 056e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 43
        Region 0: I/O ports at 5088 [size=8]
        Region 1: I/O ports at 5094 [size=4]
        Region 2: I/O ports at 5080 [size=8]
        Region 3: I/O ports at 5090 [size=4]
        Region 4: I/O ports at 5060 [size=32]
        Region 5: Memory at c3617000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0100c  Data: 41e1
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Capabilities: [b0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
        Subsystem: Dell Device 056e
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 19
        Region 0: Memory at c3615000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 5040 [size=32]

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Thames XT/GL [Radeon HD 7600M Series] (rev ff) (prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: radeon

07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)
        Subsystem: Dell Device 056e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 42
        Region 0: I/O ports at 3000 [size=256]
        Region 2: Memory at c3404000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at c3400000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000feeff00c  Data: 41c1
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                No end tag found
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 01-08-00-00-68-4c-e0-00
        Kernel driver in use: r8169

08:00.0 Network controller: Atheros Communications Inc. AR9485 Wireless Network Adapter (rev 01)
        Subsystem: Dell Device 0209
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at c3500000 (64-bit, non-prefetchable) [size=512K]
        Expansion ROM at 9fb00000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: ath9k


root:/home/adrian/linux/kernel/linux-stable# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.1 (root@adrian-lap) (gcc version 4.7.2 (Debian 4.7.2-4) ) #10 SMP PREEMPT Thu Dec 27 23:27:04 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.7.1 root=UUID=0bf20693-75cd-440a-b2f2-e8bedb062a3f ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000087fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000088000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008ffaffff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ffb0000-0x00000000913affff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000913b0000-0x0000000099dbefff] usable
[    0.000000] BIOS-e820: [mem 0x0000000099dbf000-0x000000009aebefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009aebf000-0x000000009afbefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009afbf000-0x000000009affefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009afff000-0x000000009affffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009b000000-0x000000009f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000035f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by INSYDE Corp.
[    0.000000] efi:  ACPI=0x9affe000  ACPI 2.0=0x9affe014  SMBIOS=0x9aebef98 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000006f000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000006f000-0x0000000000070000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000070000-0x0000000000088000) (0MB)
[    0.000000] efi: mem04: type=6, attr=0x800000000000000f, range=[0x0000000000088000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000393000) (2MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000393000-0x0000000020000000) (508MB)
[    0.000000] efi: mem07: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000020200000-0x0000000036a72000) (360MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000036a72000-0x0000000037531000) (10MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000037531000-0x0000000040004000) (138MB)
[    0.000000] efi: mem11: type=0, attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000040005000-0x0000000069392000) (659MB)
[    0.000000] efi: mem13: type=2, attr=0xf, range=[0x0000000069392000-0x000000008e3c0000) (592MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000008e3c0000-0x000000008e3e0000) (0MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x000000008e3e0000-0x000000008efcc000) (11MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x000000008efcc000-0x000000008ffb0000) (15MB)
[    0.000000] efi: mem17: type=0, attr=0xf, range=[0x000000008ffb0000-0x00000000913b0000) (20MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x00000000913b0000-0x00000000915a2000) (1MB)
[    0.000000] efi: mem19: type=1, attr=0xf, range=[0x00000000915a2000-0x00000000915bf000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x00000000915bf000-0x0000000095bba000) (69MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x0000000095bba000-0x00000000963fc000) (8MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000963fc000-0x0000000096410000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x0000000096410000-0x0000000096a2d000) (6MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x0000000096a2d000-0x0000000097092000) (6MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x0000000097092000-0x00000000970ea000) (0MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x00000000970ea000-0x00000000971bf000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x00000000971bf000-0x0000000097301000) (1MB)
[    0.000000] efi: mem28: type=7, attr=0xf, range=[0x0000000097301000-0x0000000097308000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x0000000097308000-0x0000000097335000) (0MB)
[    0.000000] efi: mem30: type=7, attr=0xf, range=[0x0000000097335000-0x0000000097336000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x0000000097336000-0x0000000097338000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x0000000097338000-0x0000000097339000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x0000000097339000-0x0000000097442000) (1MB)
[    0.000000] efi: mem34: type=7, attr=0xf, range=[0x0000000097442000-0x0000000097443000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x0000000097443000-0x000000009747d000) (0MB)
[    0.000000] efi: mem36: type=7, attr=0xf, range=[0x000000009747d000-0x0000000097481000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf, range=[0x0000000097481000-0x0000000097484000) (0MB)
[    0.000000] efi: mem38: type=7, attr=0xf, range=[0x0000000097484000-0x0000000097486000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x0000000097486000-0x00000000978c2000) (4MB)
[    0.000000] efi: mem40: type=7, attr=0xf, range=[0x00000000978c2000-0x00000000978c3000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x00000000978c3000-0x00000000978da000) (0MB)
[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x00000000978da000-0x00000000978e6000) (0MB)
[    0.000000] efi: mem43: type=4, attr=0xf, range=[0x00000000978e6000-0x00000000978e7000) (0MB)
[    0.000000] efi: mem44: type=7, attr=0xf, range=[0x00000000978e7000-0x00000000978e8000) (0MB)
[    0.000000] efi: mem45: type=4, attr=0xf, range=[0x00000000978e8000-0x00000000995bf000) (28MB)
[    0.000000] efi: mem46: type=7, attr=0xf, range=[0x00000000995bf000-0x00000000999c2000) (4MB)
[    0.000000] efi: mem47: type=2, attr=0xf, range=[0x00000000999c2000-0x00000000999c8000) (0MB)
[    0.000000] efi: mem48: type=3, attr=0xf, range=[0x00000000999c8000-0x0000000099dbf000) (3MB)
[    0.000000] efi: mem49: type=5, attr=0x800000000000000f, range=[0x0000000099dbf000-0x0000000099f2d000) (1MB)
[    0.000000] efi: mem50: type=5, attr=0x800000000000000f, range=[0x0000000099f2d000-0x0000000099f32000) (0MB)
[    0.000000] efi: mem51: type=6, attr=0x800000000000000f, range=[0x0000000099f32000-0x000000009a0b8000) (1MB)
[    0.000000] efi: mem52: type=5, attr=0x800000000000000f, range=[0x000000009a0b8000-0x000000009a1bf000) (1MB)
[    0.000000] efi: mem53: type=6, attr=0x800000000000000f, range=[0x000000009a1bf000-0x000000009a2af000) (0MB)
[    0.000000] efi: mem54: type=6, attr=0x800000000000000f, range=[0x000000009a2af000-0x000000009a3bf000) (1MB)
[    0.000000] efi: mem55: type=0, attr=0xf, range=[0x000000009a3bf000-0x000000009add3000) (10MB)
[    0.000000] efi: mem56: type=0, attr=0xf, range=[0x000000009add3000-0x000000009aebf000) (0MB)
[    0.000000] efi: mem57: type=10, attr=0xf, range=[0x000000009aebf000-0x000000009af91000) (0MB)
[    0.000000] efi: mem58: type=10, attr=0xf, range=[0x000000009af91000-0x000000009afbf000) (0MB)
[    0.000000] efi: mem59: type=9, attr=0xf, range=[0x000000009afbf000-0x000000009afe1000) (0MB)
[    0.000000] efi: mem60: type=9, attr=0xf, range=[0x000000009afe1000-0x000000009afff000) (0MB)
[    0.000000] efi: mem61: type=4, attr=0xf, range=[0x000000009afff000-0x000000009b000000) (0MB)
[    0.000000] efi: mem62: type=7, attr=0xf, range=[0x0000000100000000-0x000000035f600000) (9718MB)
[    0.000000] efi: mem63: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem64: type=0, attr=0x0, range=[0x000000009b000000-0x000000009fa00000) (74MB)
[    0.000000] efi: mem65: type=11, attr=0x8000000000000001, range=[0x00000000e0000000-0x00000000f0000000) (256MB)
[    0.000000] efi: mem66: type=11, attr=0x8000000000000001, range=[0x00000000feb00000-0x00000000feb04000) (0MB)
[    0.000000] efi: mem67: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem68: type=11, attr=0x8000000000000001, range=[0x00000000fed10000-0x00000000fed1a000) (0MB)
[    0.000000] efi: mem69: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem70: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem71: type=11, attr=0x8000000000000000, range=[0x00000000ffb80000-0x00000000fff00000) (3MB)
[    0.000000] efi: mem72: type=11, attr=0x8000000000000000, range=[0x00000000fff00000-0x00000000fff40000) (0MB)
[    0.000000] efi: mem73: type=11, attr=0x8000000000000000, range=[0x00000000fff40000-0x0000000100000000) (0MB)
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: Dell Inc. Vostro 3560/0C05GV, BIOS A11 10/03/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x35f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-combining
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 09B000000 mask FFF000000 uncachable
[    0.000000]   3 base 09C000000 mask FFC000000 uncachable
[    0.000000]   4 base 0FFA00000 mask FFFE00000 write-protect
[    0.000000]   5 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask E00000000 write-back
[    0.000000]   8 base 35F600000 mask FFFE00000 uncachable
[    0.000000]   9 base 35F800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x9b000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000080000] 80000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x9affffff]
[    0.000000]  [mem 0x00000000-0x9affffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x9affffff @ [mem 0x1fffc000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x35f5fffff]
[    0.000000]  [mem 0x100000000-0x35f5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x35f5fffff @ [mem 0x999bd000-0x999c7fff]
[    0.000000] RAMDISK: [mem 0x36a72000-0x37530fff]
[    0.000000] ACPI: RSDP 000000009affe014 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 000000009affe210 0009C (v01 DELL    CL09    00000001      01000013)
[    0.000000] ACPI: FACP 000000009affb000 0010C (v05 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: DSDT 000000009afee000 09692 (v01 DELL    CL09    00000000 ASL  00040000)
[    0.000000] ACPI: FACS 000000009afb9000 00040
[    0.000000] ACPI: UEFI 000000009affd000 00236 (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: ASF! 000000009affc000 000A5 (v32 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: HPET 000000009affa000 00038 (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: APIC 000000009aff9000 0008C (v03 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: MCFG 000000009aff8000 0003C (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: SSDT 000000009afed000 006FE (v01 COMPAL CRV ORB  00001000 ACPI 00040000)
[    0.000000] ACPI: BOOT 000000009afeb000 00028 (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: ASPT 000000009afe9000 00034 (v07 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: DBGP 000000009afe8000 00034 (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: FPDT 000000009afe6000 00044 (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: SSDT 000000009afe5000 00860 (v01 COMPAL CRV ORB  00003000 ACPI 00040000)
[    0.000000] ACPI: SSDT 000000009afe4000 00A92 (v01 COMPAL CRV ORB  00003000 ACPI 00040000)
[    0.000000] ACPI: SSDT 000000009afe1000 01EED (v01 COMPAL CRV ORB  00001000 ACPI 00040000)
[    0.000000] ACPI: BGRT 000000009afe3000 00038 (v01 DELL    CL09    00000001 ASL  00040000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000035f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x35f5fffff]
[    0.000000]   NODE_DATA [mem 0x35f5fc000-0x35f5fffff]
[    0.000000]  [ffffea0000000000-ffffea000d7fffff] PMD -> [ffff880352c00000-ffff88035ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x35f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00087fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0x8ffaffff]
[    0.000000]   node   0: [mem 0x913b0000-0x99dbefff]
[    0.000000]   node   0: [mem 0x9afff000-0x9affffff]
[    0.000000]   node   0: [mem 0x100000000-0x35f5fffff]
[    0.000000] On node 0 totalpages: 3112247
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 8 pages reserved
[    0.000000]   DMA zone: 3888 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 604159 pages, LIFO batch:31
[    0.000000]   Normal zone: 38872 pages used for memmap
[    0.000000]   Normal zone: 2448936 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000088000 - 00000000000c0000
[    0.000000] PM: Registered nosave memory: 00000000000c0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 000000008ffb0000 - 00000000913b0000
[    0.000000] PM: Registered nosave memory: 0000000099dbf000 - 000000009aebf000
[    0.000000] PM: Registered nosave memory: 000000009aebf000 - 000000009afbf000
[    0.000000] PM: Registered nosave memory: 000000009afbf000 - 000000009afff000
[    0.000000] PM: Registered nosave memory: 000000009b000000 - 000000009fa00000
[    0.000000] PM: Registered nosave memory: 000000009fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb80000
[    0.000000] PM: Registered nosave memory: 00000000ffb80000 - 0000000100000000
[    0.000000] e820: [mem 0x9fa00000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88035f200000 s79616 r8192 d22784 u262144
[    0.000000] pcpu-alloc: s79616 r8192 d22784 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3056983
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.7.1 root=UUID=0bf20693-75cd-440a-b2f2-e8bedb062a3f ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 12091732k/14145536k available (4570k kernel code, 1696548k absent, 357256k reserved, 4174k data, 592k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 50331648 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2095.154 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4190.30 BogoMIPS (lpj=2095154)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.045104] Security Framework initialized
[    0.046069] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.050643] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.052697] Mount-cache hash table entries: 256
[    0.052873] Initializing cgroup subsys cpuacct
[    0.052875] Initializing cgroup subsys memory
[    0.052881] Initializing cgroup subsys devices
[    0.052883] Initializing cgroup subsys freezer
[    0.052884] Initializing cgroup subsys net_cls
[    0.052885] Initializing cgroup subsys blkio
[    0.052886] Initializing cgroup subsys perf_event
[    0.052889] Initializing cgroup subsys hugetlb
[    0.052912] CPU: Physical Processor ID: 0
[    0.052913] CPU: Processor Core ID: 0
[    0.052918] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.052918] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.053343] mce: CPU supports 9 MCE banks
[    0.053357] CPU0: Thermal monitoring enabled (TM1)
[    0.053366] process: using mwait in idle threads
[    0.053369] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.053369] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.053369] tlb_flushall_shift: 1
[    0.053512] Freeing SMP alternatives: 16k freed
[    0.053519] ACPI: Core revision 20120913
[    0.074065] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.084053] smpboot: CPU0: Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz (fam: 06, model: 3a, stepping: 09)
[    0.185661] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.185667] ... version:                3
[    0.185668] ... bit width:              48
[    0.185669] ... generic registers:      4
[    0.185670] ... value mask:             0000ffffffffffff
[    0.185671] ... max period:             000000007fffffff
[    0.185672] ... fixed-purpose events:   3
[    0.185673] ... event mask:             000000070000000f
[    0.207513] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.193703] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.297175] Brought up 8 CPUs
[    0.297179] smpboot: Total of 8 processors activated (33522.46 BogoMIPS)
[    0.304277] devtmpfs: initialized
[    0.304412] PM: Registering ACPI NVS region [mem 0x9aebf000-0x9afbefff] (1048576 bytes)
[    0.304517] regulator-dummy: no parameters
[    0.304549] RTC time: 16:36:25, date: 01/08/13
[    0.304585] NET: Registered protocol family 16
[    0.304680] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.304682] ACPI: bus type pci registered
[    0.304748] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.304751] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.334222] PCI: Using configuration type 1 for base access
[    0.334358] dmi type 0xB1 record - unknown flag
[    0.334890] bio: create slab <bio-0> at 0
[    0.334937] ACPI: Added _OSI(Module Device)
[    0.334939] ACPI: Added _OSI(Processor Device)
[    0.334940] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.334942] ACPI: Added _OSI(Processor Aggregator Device)
[    0.336533] ACPI: EC: Look up EC in DSDT
[    0.338137] ACPI: Executed 1 blocks of module-level executable AML code
[    0.344586] ACPI: SSDT 000000009adf7018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20111123)
[    0.344992] ACPI: Dynamic OEM Table Load:
[    0.344995] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20111123)
[    0.350315] ACPI: SSDT 000000009adf8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20111123)
[    0.350746] ACPI: Dynamic OEM Table Load:
[    0.350748] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20111123)
[    0.356185] ACPI: SSDT 000000009adf6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20111123)
[    0.356584] ACPI: Dynamic OEM Table Load:
[    0.356586] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20111123)
[    0.363253] ACPI: Interpreter enabled
[    0.363256] ACPI: (supports S0 S3 S4 S5)
[    0.363275] ACPI: Using IOAPIC for interrupt routing
[    0.487091] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.487119] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.487377] \_SB_.PCI0:_OSC invalid UUID
[    0.487378] _OSC request data:1 8 1f 
[    0.487382] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.487652] PCI host bridge to bus 0000:00
[    0.487655] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.487657] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.487659] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.487661] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.487662] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.487664] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.487665] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.487667] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.487668] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.487670] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.487672] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.487673] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.487675] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.487676] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.487678] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.487679] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.487681] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.487683] pci_bus 0000:00: root bus resource [mem 0x9fa00000-0xfeafffff]
[    0.487691] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.487730] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.487764] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.487785] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.487797] pci 0000:00:02.0: reg 10: [mem 0xc3000000-0xc33fffff 64bit]
[    0.487804] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.487810] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.487874] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.487898] pci 0000:00:14.0: reg 10: [mem 0xc3600000-0xc360ffff 64bit]
[    0.487974] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.488000] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.488025] pci 0000:00:16.0: reg 10: [mem 0xc3614000-0xc361400f 64bit]
[    0.488106] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.488141] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.488165] pci 0000:00:1a.0: reg 10: [mem 0xc3619000-0xc36193ff]
[    0.488261] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.488289] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.488306] pci 0000:00:1b.0: reg 10: [mem 0xc3610000-0xc3613fff 64bit]
[    0.488378] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.488402] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.488486] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.488515] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.488598] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.488626] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.488708] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.488748] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.488772] pci 0000:00:1d.0: reg 10: [mem 0xc3618000-0xc36183ff]
[    0.488872] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.488900] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
[    0.489033] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.489053] pci 0000:00:1f.2: reg 10: [io  0x5088-0x508f]
[    0.489062] pci 0000:00:1f.2: reg 14: [io  0x5094-0x5097]
[    0.489070] pci 0000:00:1f.2: reg 18: [io  0x5080-0x5087]
[    0.489079] pci 0000:00:1f.2: reg 1c: [io  0x5090-0x5093]
[    0.489087] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.489096] pci 0000:00:1f.2: reg 24: [mem 0xc3617000-0xc36177ff]
[    0.489144] pci 0000:00:1f.2: PME# supported from D3hot
[    0.489164] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.489180] pci 0000:00:1f.3: reg 10: [mem 0xc3615000-0xc36150ff 64bit]
[    0.489203] pci 0000:00:1f.3: reg 20: [io  0x5040-0x505f]
[    0.489267] pci 0000:01:00.0: [1002:6840] type 00 class 0x030000
[    0.489280] pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.489291] pci 0000:01:00.0: reg 18: [mem 0xc2000000-0xc201ffff 64bit]
[    0.489299] pci 0000:01:00.0: reg 20: [io  0x4000-0x40ff]
[    0.489312] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.489345] pci 0000:01:00.0: supports D1 D2
[    0.491864] pci 0000:00:01.0: PCI bridge to [bus 01-06]
[    0.491868] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    0.491887] pci 0000:00:01.0:   bridge window [mem 0xc2000000-0xc2ffffff]
[    0.491890] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.492019] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.492089] pci 0000:07:00.0: reg 10: [io  0x3000-0x30ff]
[    0.492213] pci 0000:07:00.0: reg 18: [mem 0xc3404000-0xc3404fff 64bit pref]
[    0.492289] pci 0000:07:00.0: reg 20: [mem 0xc3400000-0xc3403fff 64bit pref]
[    0.492629] pci 0000:07:00.0: supports D1 D2
[    0.492631] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.494916] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    0.494920] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.494929] pci 0000:00:1c.0:   bridge window [mem 0xc3400000-0xc34fffff 64bit pref]
[    0.495014] pci 0000:08:00.0: [168c:0032] type 00 class 0x028000
[    0.495058] pci 0000:08:00.0: reg 10: [mem 0xc3500000-0xc357ffff 64bit]
[    0.495147] pci 0000:08:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.495236] pci 0000:08:00.0: supports D1 D2
[    0.495238] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.497883] pci 0000:00:1c.1: PCI bridge to [bus 08]
[    0.497890] pci 0000:00:1c.1:   bridge window [mem 0xc3500000-0xc35fffff]
[    0.497943] pci 0000:00:1c.2: PCI bridge to [bus 09-0e]
[    0.497947] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.497952] pci 0000:00:1c.2:   bridge window [mem 0xc1000000-0xc1ffffff]
[    0.497958] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc0ffffff 64bit pref]
[    0.497979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.498097] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.498124] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.498148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.498178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.498266] \_SB_.PCI0:_OSC invalid UUID
[    0.498267] _OSC request data:1 1f 1f 
[    0.498271]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.498272]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.500826] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.500873] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.500913] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.500951] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.500989] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.501028] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.501066] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.501103] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.501168] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.501173] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.501174] vgaarb: loaded
[    0.501175] vgaarb: bridge control possible 0000:01:00.0
[    0.501176] vgaarb: no bridge control possible 0000:00:02.0
[    0.501222] SCSI subsystem initialized
[    0.501223] ACPI: bus type scsi registered
[    0.501253] libata version 3.00 loaded.
[    0.501279] PCI: Using ACPI for IRQ routing
[    0.508092] PCI: pci_cache_line_size set to 64 bytes
[    0.508171] e820: reserve RAM buffer [mem 0x00088000-0x0008ffff]
[    0.508173] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.508175] e820: reserve RAM buffer [mem 0x8ffb0000-0x8fffffff]
[    0.508176] e820: reserve RAM buffer [mem 0x99dbf000-0x9bffffff]
[    0.508178] e820: reserve RAM buffer [mem 0x9b000000-0x9bffffff]
[    0.508179] e820: reserve RAM buffer [mem 0x35f600000-0x35fffffff]
[    0.508266] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.508272] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.510282] Switching to clocksource hpet
[    0.511407] pnp: PnP ACPI init
[    0.511415] ACPI: bus type pnp registered
[    0.511560] pnp 00:00: [bus 00-fe]
[    0.511563] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.511565] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.511566] pnp 00:00: [io  0x0d00-0xffff window]
[    0.511568] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.511570] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.511571] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.511573] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.511574] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.511576] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.511577] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.511579] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.511580] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.511582] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.511585] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.511587] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.511588] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.511590] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.511592] pnp 00:00: [mem 0x9fa00000-0xfeafffff window]
[    0.511593] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.511617] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.511628] pnp 00:01: [io  0x0000-0x001f]
[    0.511629] pnp 00:01: [io  0x0081-0x0091]
[    0.511631] pnp 00:01: [io  0x0093-0x009f]
[    0.511632] pnp 00:01: [io  0x00c0-0x00df]
[    0.511634] pnp 00:01: [dma 4]
[    0.511649] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.511656] pnp 00:02: [mem 0xff010000-0xffffffff]
[    0.511668] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.511729] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.511742] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.511750] pnp 00:04: [io  0x00f0]
[    0.511758] pnp 00:04: [irq 13]
[    0.511772] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.511780] pnp 00:05: [io  0x002e-0x002f]
[    0.511782] pnp 00:05: [io  0x004e-0x004f]
[    0.511783] pnp 00:05: [io  0x0061]
[    0.511784] pnp 00:05: [io  0x0063]
[    0.511786] pnp 00:05: [io  0x0065]
[    0.511787] pnp 00:05: [io  0x0067]
[    0.511788] pnp 00:05: [io  0x0070]
[    0.511790] pnp 00:05: [io  0x0080]
[    0.511791] pnp 00:05: [io  0x0092]
[    0.511793] pnp 00:05: [io  0x00b2-0x00b3]
[    0.511794] pnp 00:05: [io  0x0680-0x069f]
[    0.511796] pnp 00:05: [io  0x1000-0x100f]
[    0.511797] pnp 00:05: [io  0xffff]
[    0.511798] pnp 00:05: [io  0xffff]
[    0.511800] pnp 00:05: [io  0x0400-0x0453]
[    0.511801] pnp 00:05: [io  0x0458-0x047f]
[    0.511803] pnp 00:05: [io  0x0500-0x057f]
[    0.511804] pnp 00:05: [io  0x164e-0x164f]
[    0.511805] pnp 00:05: [io  0xfd60-0xfd63]
[    0.511831] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.511833] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.511834] system 00:05: [io  0xffff] has been reserved
[    0.511836] system 00:05: [io  0xffff] has been reserved
[    0.511838] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.511840] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.511842] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.511843] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.511845] system 00:05: [io  0xfd60-0xfd63] has been reserved
[    0.511847] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.511854] pnp 00:06: [io  0x0070-0x0077]
[    0.511859] pnp 00:06: [irq 8]
[    0.511872] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.511893] pnp 00:07: [io  0x0454-0x0457]
[    0.511911] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.511914] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.511925] pnp 00:08: [io  0x0060]
[    0.511927] pnp 00:08: [io  0x0064]
[    0.511931] pnp 00:08: [irq 1]
[    0.511951] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.511964] pnp 00:09: [irq 12]
[    0.511977] pnp 00:09: Plug and Play ACPI device, IDs DLL056e PNP0f13 (active)
[    0.571258] pnp 00:0a: [irq 20]
[    0.571276] pnp 00:0a: Plug and Play ACPI device, IDs SMO8810 (active)
[    0.571359] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.571361] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    0.571362] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    0.571364] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    0.571365] pnp 00:0b: [mem 0xe0000000-0xefffffff]
[    0.571367] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.571368] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    0.571370] pnp 00:0b: [mem 0xff000000-0xff000fff]
[    0.571371] pnp 00:0b: [mem 0xff010000-0xffffffff]
[    0.571372] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    0.571374] pnp 00:0b: [mem 0x9fa00000-0x9fa00fff]
[    0.571400] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.571402] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.571404] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.571405] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.571407] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.571409] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.571411] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.571413] system 00:0b: [mem 0xff000000-0xff000fff] has been reserved
[    0.571415] system 00:0b: [mem 0xff010000-0xffffffff] could not be reserved
[    0.571417] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.571419] system 00:0b: [mem 0x9fa00000-0x9fa00fff] has been reserved
[    0.571421] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.571717] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.571719] pnp 00:0c: [mem 0x40004000-0x40004fff]
[    0.571743] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.571745] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.571747] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.571762] pnp: PnP ACPI: found 13 devices
[    0.571763] ACPI: ACPI bus type pnp unregistered
[    0.578132] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.578134] pci 0000:08:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.578170] pci 0000:00:1c.1: BAR 15: assigned [mem 0x9fb00000-0x9fbfffff pref]
[    0.578173] pci 0000:01:00.0: BAR 6: assigned [mem 0xc2020000-0xc203ffff pref]
[    0.578175] pci 0000:00:01.0: PCI bridge to [bus 01-06]
[    0.578178] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    0.578181] pci 0000:00:01.0:   bridge window [mem 0xc2000000-0xc2ffffff]
[    0.578184] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.578187] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    0.578191] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.578204] pci 0000:00:1c.0:   bridge window [mem 0xc3400000-0xc34fffff 64bit pref]
[    0.578212] pci 0000:08:00.0: BAR 6: assigned [mem 0x9fb00000-0x9fb0ffff pref]
[    0.578214] pci 0000:00:1c.1: PCI bridge to [bus 08]
[    0.578219] pci 0000:00:1c.1:   bridge window [mem 0xc3500000-0xc35fffff]
[    0.578224] pci 0000:00:1c.1:   bridge window [mem 0x9fb00000-0x9fbfffff pref]
[    0.578230] pci 0000:00:1c.2: PCI bridge to [bus 09-0e]
[    0.578234] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.578239] pci 0000:00:1c.2:   bridge window [mem 0xc1000000-0xc1ffffff]
[    0.578244] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc0ffffff 64bit pref]
[    0.578277] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.578279] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.578281] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.578282] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.578284] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.578286] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.578287] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.578289] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.578291] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.578292] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.578294] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.578295] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.578297] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.578299] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.578300] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.578302] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    0.578304] pci_bus 0000:00: resource 20 [mem 0x9fa00000-0xfeafffff]
[    0.578305] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    0.578307] pci_bus 0000:01: resource 1 [mem 0xc2000000-0xc2ffffff]
[    0.578309] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
[    0.578311] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    0.578312] pci_bus 0000:07: resource 2 [mem 0xc3400000-0xc34fffff 64bit pref]
[    0.578314] pci_bus 0000:08: resource 1 [mem 0xc3500000-0xc35fffff]
[    0.578316] pci_bus 0000:08: resource 2 [mem 0x9fb00000-0x9fbfffff pref]
[    0.578317] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
[    0.578319] pci_bus 0000:09: resource 1 [mem 0xc1000000-0xc1ffffff]
[    0.578321] pci_bus 0000:09: resource 2 [mem 0xc0000000-0xc0ffffff 64bit pref]
[    0.578347] NET: Registered protocol family 2
[    0.578932] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.580086] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.580218] TCP: Hash tables configured (established 524288 bind 65536)
[    0.580242] TCP: reno registered
[    0.580263] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.580315] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.580416] NET: Registered protocol family 1
[    0.580430] pci 0000:00:02.0: Boot video device
[    0.603219] PCI: CLS 64 bytes, default 64
[    0.603256] Unpacking initramfs...
[    0.820991] Freeing initrd memory: 11004k freed
[    0.822369] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.822374] software IO TLB [mem 0x91bba000-0x95bb9fff] (64MB) mapped at [ffff880091bba000-ffff880095bb9fff]
[    0.822400] Simple Boot Flag at 0x44 set to 0x1
[    0.822777] audit: initializing netlink socket (disabled)
[    0.822793] type=2000 audit(1357662985.683:1): initialized
[    0.838155] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.839508] VFS: Disk quotas dquot_6.5.2
[    0.839546] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.839630] msgmni has been set to 23779
[    0.839904] alg: No test for stdrng (krng)
[    0.839946] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.839948] io scheduler noop registered
[    0.839949] io scheduler deadline registered
[    0.839969] io scheduler cfq registered (default)
[    0.840040] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.840213] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.840228] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.840229] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.840420] acpiphp: Slot [1] registered
[    0.840522] efifb: probing for efifb
[    0.841671] efifb: framebuffer at 0xb0000000, mapped to 0xffffc90022780000, using 8128k, total 8128k
[    0.841672] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    0.841673] efifb: scrolling: redraw
[    0.841675] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.847927] Console: switching to colour frame buffer device 240x67
[    0.853774] fb0: EFI VGA frame buffer device
[    0.853780] intel_idle: MWAIT substates: 0x21120
[    0.853789] intel_idle: v0.4 model 0x3A
[    0.853791] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.853831] GHES: HEST is not enabled!
[    0.853867] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.854246] Linux agpgart interface v0.103
[    0.854266] [drm] Initialized drm 1.1.0 20060810
[    0.854329] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.872670] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.872697] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.872780] mousedev: PS/2 mouse device common for all mice
[    0.873074] rtc_cmos 00:06: RTC can wake from S4
[    0.873193] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.873221] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.873337] cpuidle: using governor ladder
[    0.873495] cpuidle: using governor menu
[    0.873532] drop_monitor: Initializing network drop monitor service
[    0.873596] TCP: cubic registered
[    0.873668] NET: Registered protocol family 10
[    0.873823] mip6: Mobile IPv6
[    0.873826] NET: Registered protocol family 17
[    0.873833] Key type dns_resolver registered
[    0.874340] PM: Hibernation image not present or could not be loaded.
[    0.874350] registered taskstats version 1
[    0.875047]   Magic number: 13:845:640
[    0.875142] rtc_cmos 00:06: setting system clock to 2013-01-08 16:36:26 UTC (1357662986)
[    0.876230] Freeing unused kernel memory: 592k freed
[    0.876313] Write protecting the kernel read-only data: 8192k
[    0.880170] Freeing unused kernel memory: 1564k freed
[    0.881569] Freeing unused kernel memory: 476k freed
[    0.893070] udevd[92]: starting version 175
[    0.897556] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.903312] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0C:00/input/input1
[    0.903319] ACPI: Power Button [PWRB]
[    0.903400] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    0.903452] ACPI: Lid Switch [LID0]
[    0.903505] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.903509] ACPI: Power Button [PWRF]
[    0.916022] ACPI: bus type usb registered
[    0.916047] usbcore: registered new interface driver usbfs
[    0.916055] usbcore: registered new interface driver hub
[    0.916745] usbcore: registered new device driver usb
[    0.917383] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    0.917391] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.917401] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.917404] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.917819] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.917850] xhci_hcd 0000:00:14.0: irq 21, io mem 0xc3600000
[    0.917912] xhci_hcd 0000:00:14.0: irq 41 for MSI/MSI-X
[    0.917977] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.917981] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.917984] usb usb1: Product: xHCI Host Controller
[    0.917986] usb usb1: Manufacturer: Linux 3.7.1 xhci_hcd
[    0.917988] usb usb1: SerialNumber: 0000:00:14.0
[    0.918112] xHCI xhci_add_endpoint called for root hub
[    0.918115] xHCI xhci_check_bandwidth called for root hub
[    0.918152] hub 1-0:1.0: USB hub found
[    0.918161] hub 1-0:1.0: 4 ports detected
[    0.918601] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.918854] r8169 0000:07:00.0: irq 42 for MSI/MSI-X
[    0.918960] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
[    0.919001] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.919007] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
[    0.919009] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.919038] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    0.919042] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.919045] usb usb2: Product: xHCI Host Controller
[    0.919048] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
[    0.919049] usb usb2: Manufacturer: Linux 3.7.1 xhci_hcd
[    0.919051] usb usb2: SerialNumber: 0000:00:14.0
[    0.919095] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
[    0.919132] microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x15
[    0.919136] r8169 0000:07:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000060000, d4:be:d9:62:91:a0, XID 0c900880 IRQ 42
[    0.919139] r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    0.919162] xHCI xhci_add_endpoint called for root hub
[    0.919165] xHCI xhci_check_bandwidth called for root hub
[    0.919186] microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x15
[    0.919201] hub 2-0:1.0: USB hub found
[    0.919212] hub 2-0:1.0: 4 ports detected
[    0.919234] microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x15
[    0.919280] microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x15
[    0.919468] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.925058] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.925065] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.925072] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.928990] ehci_hcd 0000:00:1a.0: debug port 2
[    0.929000] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.929017] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xc3619000
[    0.934714] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.934735] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.934737] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.934739] usb usb3: Product: EHCI Host Controller
[    0.934741] usb usb3: Manufacturer: Linux 3.7.1 ehci_hcd
[    0.934742] usb usb3: SerialNumber: 0000:00:1a.0
[    0.934919] hub 3-0:1.0: USB hub found
[    0.934924] hub 3-0:1.0: 2 ports detected
[    0.935074] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.935079] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.935084] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    0.938982] ehci_hcd 0000:00:1d.0: debug port 2
[    0.938990] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.939003] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xc3618000
[    0.944698] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.944718] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    0.944721] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.944723] usb usb4: Product: EHCI Host Controller
[    0.944725] usb usb4: Manufacturer: Linux 3.7.1 ehci_hcd
[    0.944727] usb usb4: SerialNumber: 0000:00:1d.0
[    0.944893] hub 4-0:1.0: USB hub found
[    0.944897] hub 4-0:1.0: 2 ports detected
[    0.945038] ahci 0000:00:1f.2: version 3.0
[    0.945131] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.955696] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x5 impl SATA mode
[    0.955700] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.955706] ahci 0000:00:1f.2: setting latency timer to 64
[    0.958112] scsi0 : ahci
[    0.958263] scsi1 : ahci
[    0.958407] scsi2 : ahci
[    0.958549] scsi3 : ahci
[    0.958686] scsi4 : ahci
[    0.958830] scsi5 : ahci
[    0.958884] ata1: SATA max UDMA/133 abar m2048@0xc3617000 port 0xc3617100 irq 43
[    0.958886] ata2: DUMMY
[    0.958889] ata3: SATA max UDMA/133 abar m2048@0xc3617000 port 0xc3617200 irq 43
[    0.958890] ata4: DUMMY
[    0.958891] ata5: DUMMY
[    0.958892] ata6: DUMMY
[    0.959201] pci 0000:00:00.0: Intel Ivybridge Chipset
[    0.959326] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.960705] pci 0000:00:00.0: detected 65536K stolen memory
[    0.960751] checking generic (b0000000 7f0000) vs hw (b0000000 10000000)
[    0.960753] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
[    0.960774] Console: switching to colour dummy device 80x25
[    0.960915] i915 0000:00:02.0: setting latency timer to 64
[    1.000568] [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[    1.000691] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    1.000698] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.000699] [drm] Driver supports precise vblank timestamp query.
[    1.000778] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    1.000780] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    1.081142] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    1.146423] fbcon: inteldrmfb (fb0) is primary device
[    1.236311] usb 3-1: new high-speed USB device number 2 using ehci_hcd
[    1.263263] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.263285] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.264479] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.264542] ata1.00: ATA-9: OCZ-VERTEX4, 1.5, max UDMA/133
[    1.264544] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.265399] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.265473] ata1.00: configured for UDMA/133
[    1.267459] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX4      1.5  PQ: 0 ANSI: 5
[    1.267708] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.267771] sd 0:0:0:0: [sda] Write Protect is off
[    1.267774] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.267794] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.269704]  sda: sda1 sda2 sda3 sda4 sda5
[    1.270264] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.278693] ata3.00: ATAPI: MATSHITA DVD+/-RW UJ8D1, D.02, max UDMA/100
[    1.297024] ata3.00: configured for UDMA/100
[    1.308868] scsi 2:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ8D1    D.02 PQ: 0 ANSI: 5
[    1.309232] ACPI: Invalid Power Resource to register!
[    1.313893] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.313929] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    1.318407] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.318409] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.318564] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.350489] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
[    1.350491] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.350739] hub 3-1:1.0: USB hub found
[    1.350816] hub 3-1:1.0: 6 ports detected
[    1.453928] usb 4-1: new high-speed USB device number 2 using ehci_hcd
[    1.568163] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
[    1.568165] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.568421] hub 4-1:1.0: USB hub found
[    1.568491] hub 4-1:1.0: 8 ports detected
[    1.642759] usb 3-1.1: new full-speed USB device number 3 using ehci_hcd
[    1.731445] usb 3-1.1: New USB device found, idVendor=138a, idProduct=0011
[    1.731447] usb 3-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    1.731449] usb 3-1.1: SerialNumber: 5db29fbb9f4c
[    1.804560] usb 3-1.3: new high-speed USB device number 4 using ehci_hcd
[    1.822412] tsc: Refined TSC clocksource calibration: 2095.240 MHz
[    1.822415] Switching to clocksource tsc
[    1.831430] ACPI: Invalid Power Resource to register!
[    1.831431] Console: switching to colour frame buffer device 240x67
[    1.837649] fb0: inteldrmfb frame buffer device
[    1.837650] drm: registered panic notifier
[    1.837831] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[    1.838744] acpi device:32: registered as cooling_device0
[    1.838906] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
[    1.838959] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:30/LNXVIDEO:00/input/input4
[    1.838980] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
[    1.839688] acpi device:41: registered as cooling_device1
[    1.839811] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.839847] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:02/input/input5
[    1.839864] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.861142] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    1.861146] EXT4-fs (sda2): write access will be enabled during recovery
[    1.879339] EXT4-fs (sda2): recovery complete
[    1.881583] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    1.890126] usb 3-1.3: New USB device found, idVendor=0bda, idProduct=0129
[    1.890131] usb 3-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.890133] usb 3-1.3: Product: USB2.0-CRW
[    1.890135] usb 3-1.3: Manufacturer: Generic
[    1.890136] usb 3-1.3: SerialNumber: 20100201396000000
[    1.963271] usb 3-1.5: new high-speed USB device number 5 using ehci_hcd
[    2.051983] udevd[395]: starting version 175
[    2.104301] ACPI: Requesting acpi_cpufreq
[    2.107970] ACPI: AC Adapter [ACAD] (on-line)
[    2.120282] usb 3-1.5: New USB device found, idVendor=0c45, idProduct=648b
[    2.120286] usb 3-1.5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    2.120289] usb 3-1.5: Product: Laptop_Integrated_Webcam_E4HD
[    2.120290] usb 3-1.5: Manufacturer: CNFB183I3620100005L2
[    2.120408] wmi: Mapper loaded
[    2.124274] mei 0000:00:16.0: setting latency timer to 64
[    2.124348] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[    2.127270] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    2.128371] ACPI Warning: 0x0000000000005040-0x000000000000505f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
[    2.128380] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.129998] mei 0000:00:16.0: wd: failed to find the client
[    2.135574] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.199916] usb 4-1.5: new full-speed USB device number 3 using ehci_hcd
[    2.207439] media: Linux media interface: v0.10
[    2.214444] rts5139: module is from the staging directory, the quality is unknown, you have been warned.
[    2.218219] scsi6 : SCSI emulation for RTS5139 USB card reader
[    2.218377] usbcore: registered new interface driver rts5139
[    2.218696] scsi 6:0:0:0: Direct-Access     Generic- xD/SD/M.S.       1.00 PQ: 0 ANSI: 0 CCS
[    2.219511] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    2.222269] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    2.286677] usb 4-1.5: New USB device found, idVendor=0cf3, idProduct=e004
[    2.286682] usb 4-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.286685] usb 4-1.5: Product: Bluetooth USB Host Controller
[    2.286688] usb 4-1.5: Manufacturer: Atheros Communications
[    2.286691] usb 4-1.5: SerialNumber: Alaska Day 2006
[    2.312704] ACPI: Battery Slot [BAT1] (battery present)
[    2.568155] Registered led device: dell-laptop::touchpad
[    2.568374] input: Dell WMI hotkeys as /devices/virtual/input/input7
[    2.568543] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
[    2.568551] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.568556] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 1 (20120913/utaddress-251)
[    2.568562] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
[    2.568567] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.568569] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 1 (20120913/utaddress-251)
[    2.568573] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
[    2.568578] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.568579] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    2.572626] Linux video capture interface: v2.00
[    2.572631] iTCO_vendor_support: vendor-support=0
[    2.572696] cfg80211: Calling CRDA to update world regulatory domain
[    2.573936] Bluetooth: Core ver 2.16
[    2.573945] NET: Registered protocol family 31
[    2.573947] Bluetooth: HCI device and connection manager initialized
[    2.573952] Bluetooth: HCI socket layer initialized
[    2.573953] Bluetooth: L2CAP socket layer initialized
[    2.573957] Bluetooth: SCO socket layer initialized
[    2.574177] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    2.574210] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    2.574317] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.577419] usbcore: registered new interface driver btusb
[    2.577668] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.582981] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_E4HD (0c45:648b)
[    2.583068] [drm] radeon kernel modesetting enabled.
[    2.583082] VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
[    2.586470] ata1.00: configured for UDMA/133
[    2.586475] ata1: EH complete
[    2.593260] radeon 0000:01:00.0: enabling device (0000 -> 0003)
[    2.593397] [drm] initializing kernel modesetting (TURKS 0x1002:0x6840 0x1028:0x056E).
[    2.593827] [drm] register mmio base: 0xC2000000
[    2.593829] [drm] register mmio size: 131072
[    2.593830] vga_switcheroo: enabled
[    2.593927] ATPX version 1
[    2.595391] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    2.604824] cfg80211: World regulatory domain updated:
[    2.604827] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    2.604831] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    2.604833] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    2.604836] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    2.604838] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    2.604841] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    2.608942] input: Laptop_Integrated_Webcam_E4HD as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.5/3-1.5:1.0/input/input8
[    2.609010] usbcore: registered new interface driver uvcvideo
[    2.609011] USB Video Class driver (1.1.1)
[    2.609328] hda_codec: CX20590: BIOS auto-probing.
[    2.610175] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[    2.616226] ath: phy0: ASPM enabled: 0x43
[    2.616230] ath: EEPROM regdomain: 0x60
[    2.616232] ath: EEPROM indicates we should expect a direct regpair map
[    2.616235] ath: Country alpha2 being used: 00
[    2.616237] ath: Regpair used: 0x60
[    2.616985] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    2.617146] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    2.617373] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    2.621002] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[    2.621228] Registered led device: ath9k-phy0
[    2.621235] ieee80211 phy0: Atheros AR9485 Rev:1 mem=0xffffc90022900000, irq=17
[    2.626014] cfg80211: Calling CRDA for country: PL
[    2.628746] cfg80211: Regulatory domain changed to country: PL
[    2.628750] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    2.628753] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    2.628755] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    2.628757] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    2.628759] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[    2.633426] usbcore: registered new interface driver ath3k
[    2.730667] usb 4-1.5: USB disconnect, device number 3
[    2.907868] usb 4-1.5: new full-speed USB device number 4 using ehci_hcd
[    2.994859] usb 4-1.5: New USB device found, idVendor=0cf3, idProduct=e004
[    2.994868] usb 4-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.994873] usb 4-1.5: Product: Bluetooth USB Host Controller
[    2.994878] usb 4-1.5: Manufacturer: Atheros Communications
[    2.994882] usb 4-1.5: SerialNumber: Alaska Day 2006
[    3.038993] ATOM BIOS: Dell/Compal
[    3.039022] [drm] GPU not posted. posting now...
[    3.042795] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    3.042800] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    3.042812] mtrr: no more MTRRs available
[    3.042815] [drm] Detected VRAM RAM=1024M, BAR=256M
[    3.042817] [drm] RAM width 128bits DDR
[    3.042972] [TTM] Zone  kernel: Available graphics memory: 6088832 kiB
[    3.042976] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    3.042978] [TTM] Initializing pool allocator
[    3.042984] [TTM] Initializing DMA pool allocator
[    3.043021] [drm] radeon: 1024M of VRAM memory ready
[    3.043023] [drm] radeon: 512M of GTT memory ready.
[    3.043043] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.043045] [drm] Driver supports precise vblank timestamp query.
[    3.043099] radeon 0000:01:00.0: irq 47 for MSI/MSI-X
[    3.043113] radeon 0000:01:00.0: radeon: using MSI.
[    3.043162] [drm] radeon: irq initialized.
[    3.043170] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.043873] [drm] probing gen 2 caps for device 8086:151 = 3/e
[    3.043878] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    3.044066] [drm] Loading TURKS Microcode
[    3.047923] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    3.048094] radeon 0000:01:00.0: WB enabled
[    3.048099] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88034b6efc00
[    3.064893] [drm] ring test on 0 succeeded in 1 usecs
[    3.065082] [drm] ib test on ring 0 succeeded in 0 usecs
[    3.065190] [drm] Radeon Display Connectors
[    3.067701] [drm] Internal thermal controller with fan control
[    3.068566] [drm] radeon: power management initialized
[    3.068667] No connectors reported connected with modes
[    3.068669] [drm] Cannot find any crtc or sizes - going 1024x768
[    3.070113] [drm] fb mappable at 0xA0142000
[    3.070114] [drm] vram apper at 0xA0000000
[    3.070115] [drm] size 3145728
[    3.070117] [drm] fb depth is 24
[    3.070118] [drm]    pitch is 4096
[    3.070222] fb1: radeondrmfb frame buffer device
[    3.070242] [drm] Initialized radeon 2.24.0 20080528 for 0000:01:00.0 on minor 1
[    3.348920] EXT4-fs (sda2): re-mounted. Opts: (null)
[    3.391412] EXT4-fs (sda2): re-mounted. Opts: discard,user_xattr,errors=remount-ro
[    3.427091] loop: module loaded
[    3.515014] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f02)
[    3.546317] psmouse serio1: elantech: Synaptics capabilities query result 0x79, 0x17, 0x0c.
[    3.706748] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input13
[    3.961227] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: discard
[    3.970949] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: user_xattr,discard
[    3.975743] FAT-fs (sda5): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[    4.369198] RPC: Registered named UNIX socket transport module.
[    4.369202] RPC: Registered udp transport module.
[    4.369204] RPC: Registered tcp transport module.
[    4.369206] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.373352] FS-Cache: Loaded
[    4.379657] FS-Cache: Netfs 'nfs' registered for caching
[    4.387749] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.131652] i8k: unable to get SMM BIOS version
[    5.131865] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
[    5.254200] Bluetooth: RFCOMM TTY layer initialized
[    5.254212] Bluetooth: RFCOMM socket layer initialized
[    5.254213] Bluetooth: RFCOMM ver 1.11
[    5.254440] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.254445] Bluetooth: BNEP filters: protocol multicast
[    5.254448] Bluetooth: BNEP socket layer initialized
[    5.500983] r8169 0000:07:00.0 eth1: link down
[    5.501030] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    5.511732] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[    6.134390] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input14
[    6.155793] radeon: switched off
[    6.507796] EXT4-fs (sda2): re-mounted. Opts: discard,errors=remount-ro,data=ordered,commit=360
[    6.512504] EXT4-fs (sda1): re-mounted. Opts: discard,data=ordered,commit=360
[    6.516752] ata1.00: configured for UDMA/133
[    6.516758] ata1: EH complete
[    6.528987] EXT4-fs (sda3): re-mounted. Opts: discard,data=ordered,commit=360
[    7.652058] wlan1: authenticate with 00:0f:3d:df:42:fe
[    7.660605] wlan1: send auth to 00:0f:3d:df:42:fe (try 1/3)
[    7.662884] wlan1: authenticated
[    7.662975] ath9k 0000:08:00.0 wlan1: disabling HT as WMM/QoS is not supported by the AP
[    7.662978] ath9k 0000:08:00.0 wlan1: disabling VHT as WMM/QoS is not supported by the AP
[    7.663629] wlan1: associate with 00:0f:3d:df:42:fe (try 1/3)
[    7.666152] wlan1: RX AssocResp from 00:0f:3d:df:42:fe (capab=0x431 status=0 aid=4)
[    7.666199] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[    7.666249] wlan1: associated
[    7.666270] cfg80211: Calling CRDA for country: GB
[    7.668925] ath: regdomain 0x833a updated by CountryIE
[    7.668928] ath: EEPROM regdomain: 0x833a
[    7.668929] ath: EEPROM indicates we should expect a country code
[    7.668930] ath: doing EEPROM country->regdmn map search
[    7.668931] ath: country maps to regdmn code: 0x37
[    7.668932] ath: Country alpha2 being used: GB
[    7.668933] ath: Regpair used: 0x37
[    7.668951] cfg80211: Regulatory domain changed to country: GB
[    7.668952] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    7.668953] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    7.668954] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    7.668955] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    7.668956] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  530.566393] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
[  530.581089] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
[  530.595712] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
[  530.610841] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
[  530.625458] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
[  530.625465] psmouse serio1: issuing reconnect request


--------------060806000304070006020108
Content-Type: text/plain; charset=UTF-8;
 name="config-3.7.1"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config-3.7.1"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4
L3g4Nl82NCAzLjcuMSBLZXJuZWwgQ29uZmlndXJhdGlvbgojCkNPTkZJR182NEJJVD15CkNP
TkZJR19YODZfNjQ9eQpDT05GSUdfWDg2PXkKQ09ORklHX0lOU1RSVUNUSU9OX0RFQ09ERVI9
eQpDT05GSUdfT1VUUFVUX0ZPUk1BVD0iZWxmNjQteDg2LTY0IgpDT05GSUdfQVJDSF9ERUZD
T05GSUc9ImFyY2gveDg2L2NvbmZpZ3MveDg2XzY0X2RlZmNvbmZpZyIKQ09ORklHX0xPQ0tE
RVBfU1VQUE9SVD15CkNPTkZJR19TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9M
QVRFTkNZVE9QX1NVUFBPUlQ9eQpDT05GSUdfTU1VPXkKQ09ORklHX05FRURfRE1BX01BUF9T
VEFURT15CkNPTkZJR19ORUVEX1NHX0RNQV9MRU5HVEg9eQpDT05GSUdfR0VORVJJQ19JU0Ff
RE1BPXkKQ09ORklHX0dFTkVSSUNfQlVHPXkKQ09ORklHX0dFTkVSSUNfQlVHX1JFTEFUSVZF
X1BPSU5URVJTPXkKQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15CkNPTkZJR19HRU5FUklDX0dQ
SU89eQpDT05GSUdfQVJDSF9NQVlfSEFWRV9QQ19GREM9eQpDT05GSUdfUldTRU1fWENIR0FE
RF9BTEdPUklUSE09eQpDT05GSUdfR0VORVJJQ19DQUxJQlJBVEVfREVMQVk9eQpDT05GSUdf
QVJDSF9IQVNfQ1BVX1JFTEFYPXkKQ09ORklHX0FSQ0hfSEFTX0RFRkFVTFRfSURMRT15CkNP
TkZJR19BUkNIX0hBU19DQUNIRV9MSU5FX1NJWkU9eQpDT05GSUdfQVJDSF9IQVNfQ1BVX0FV
VE9QUk9CRT15CkNPTkZJR19IQVZFX1NFVFVQX1BFUl9DUFVfQVJFQT15CkNPTkZJR19ORUVE
X1BFUl9DUFVfRU1CRURfRklSU1RfQ0hVTks9eQpDT05GSUdfTkVFRF9QRVJfQ1BVX1BBR0Vf
RklSU1RfQ0hVTks9eQpDT05GSUdfQVJDSF9ISUJFUk5BVElPTl9QT1NTSUJMRT15CkNPTkZJ
R19BUkNIX1NVU1BFTkRfUE9TU0lCTEU9eQpDT05GSUdfWk9ORV9ETUEzMj15CkNPTkZJR19B
VURJVF9BUkNIPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkK
Q09ORklHX0FSQ0hfU1VQUE9SVFNfREVCVUdfUEFHRUFMTE9DPXkKQ09ORklHX0hBVkVfSU5U
RUxfVFhUPXkKQ09ORklHX1g4Nl82NF9TTVA9eQpDT05GSUdfWDg2X0hUPXkKQ09ORklHX0FS
Q0hfSFdFSUdIVF9DRkxBR1M9Ii1mY2FsbC1zYXZlZC1yZGkgLWZjYWxsLXNhdmVkLXJzaSAt
ZmNhbGwtc2F2ZWQtcmR4IC1mY2FsbC1zYXZlZC1yY3ggLWZjYWxsLXNhdmVkLXI4IC1mY2Fs
bC1zYXZlZC1yOSAtZmNhbGwtc2F2ZWQtcjEwIC1mY2FsbC1zYXZlZC1yMTEiCkNPTkZJR19B
UkNIX0NQVV9QUk9CRV9SRUxFQVNFPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfVVBST0JFUz15
CkNPTkZJR19ERUZDT05GSUdfTElTVD0iL2xpYi9tb2R1bGVzLyRVTkFNRV9SRUxFQVNFLy5j
b25maWciCkNPTkZJR19IQVZFX0lSUV9XT1JLPXkKQ09ORklHX0lSUV9XT1JLPXkKQ09ORklH
X0JVSUxEVElNRV9FWFRBQkxFX1NPUlQ9eQoKIwojIEdlbmVyYWwgc2V0dXAKIwpDT05GSUdf
RVhQRVJJTUVOVEFMPXkKQ09ORklHX0lOSVRfRU5WX0FSR19MSU1JVD0zMgpDT05GSUdfQ1JP
U1NfQ09NUElMRT0iIgpDT05GSUdfTE9DQUxWRVJTSU9OPSIiCiMgQ09ORklHX0xPQ0FMVkVS
U0lPTl9BVVRPIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfS0VSTkVMX0daSVA9eQpDT05GSUdf
SEFWRV9LRVJORUxfQlpJUDI9eQpDT05GSUdfSEFWRV9LRVJORUxfTFpNQT15CkNPTkZJR19I
QVZFX0tFUk5FTF9YWj15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk89eQojIENPTkZJR19LRVJO
RUxfR1pJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFUk5FTF9MWk1BIGlzIG5vdCBzZXQKQ09ORklHX0tFUk5FTF9YWj15CiMgQ09O
RklHX0tFUk5FTF9MWk8gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9IT1NUTkFNRT0iKG5v
bmUpIgpDT05GSUdfU1dBUD15CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZU1ZJUENfU1lT
Q1RMPXkKQ09ORklHX1BPU0lYX01RVUVVRT15CkNPTkZJR19QT1NJWF9NUVVFVUVfU1lTQ1RM
PXkKQ09ORklHX0ZIQU5ETEU9eQpDT05GSUdfQVVESVQ9eQpDT05GSUdfQVVESVRTWVNDQUxM
PXkKQ09ORklHX0FVRElUX1dBVENIPXkKQ09ORklHX0FVRElUX1RSRUU9eQpDT05GSUdfQVVE
SVRfTE9HSU5VSURfSU1NVVRBQkxFPXkKQ09ORklHX0hBVkVfR0VORVJJQ19IQVJESVJRUz15
CgojCiMgSVJRIHN1YnN5c3RlbQojCkNPTkZJR19HRU5FUklDX0hBUkRJUlFTPXkKQ09ORklH
X0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfSVJRX1NIT1c9eQpDT05GSUdf
R0VORVJJQ19QRU5ESU5HX0lSUT15CkNPTkZJR19HRU5FUklDX0lSUV9DSElQPXkKQ09ORklH
X0lSUV9ET01BSU49eQpDT05GSUdfSVJRX0RPTUFJTl9ERUJVRz15CkNPTkZJR19JUlFfRk9S
Q0VEX1RIUkVBRElORz15CkNPTkZJR19TUEFSU0VfSVJRPXkKQ09ORklHX0NMT0NLU09VUkNF
X1dBVENIRE9HPXkKQ09ORklHX0FSQ0hfQ0xPQ0tTT1VSQ0VfREFUQT15CkNPTkZJR19HRU5F
UklDX1RJTUVfVlNZU0NBTEw9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJ
R19HRU5FUklDX0NMT0NLRVZFTlRTX0JVSUxEPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVO
VFNfQlJPQURDQVNUPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfTUlOX0FESlVTVD15
CkNPTkZJR19HRU5FUklDX0NNT1NfVVBEQVRFPXkKCiMKIyBUaW1lcnMgc3Vic3lzdGVtCiMK
Q09ORklHX1RJQ0tfT05FU0hPVD15CkNPTkZJR19OT19IWj15CkNPTkZJR19ISUdIX1JFU19U
SU1FUlM9eQoKIwojIENQVS9UYXNrIHRpbWUgYW5kIHN0YXRzIGFjY291bnRpbmcKIwpDT05G
SUdfVElDS19DUFVfQUNDT1VOVElORz15CiMgQ09ORklHX0lSUV9USU1FX0FDQ09VTlRJTkcg
aXMgbm90IHNldApDT05GSUdfQlNEX1BST0NFU1NfQUNDVD15CkNPTkZJR19CU0RfUFJPQ0VT
U19BQ0NUX1YzPXkKQ09ORklHX1RBU0tTVEFUUz15CkNPTkZJR19UQVNLX0RFTEFZX0FDQ1Q9
eQpDT05GSUdfVEFTS19YQUNDVD15CkNPTkZJR19UQVNLX0lPX0FDQ09VTlRJTkc9eQoKIwoj
IFJDVSBTdWJzeXN0ZW0KIwpDT05GSUdfVFJFRV9QUkVFTVBUX1JDVT15CkNPTkZJR19QUkVF
TVBUX1JDVT15CiMgQ09ORklHX1JDVV9VU0VSX1FTIGlzIG5vdCBzZXQKQ09ORklHX1JDVV9G
QU5PVVQ9NjQKQ09ORklHX1JDVV9GQU5PVVRfTEVBRj0xNgojIENPTkZJR19SQ1VfRkFOT1VU
X0VYQUNUIGlzIG5vdCBzZXQKQ09ORklHX1JDVV9GQVNUX05PX0haPXkKIyBDT05GSUdfVFJF
RV9SQ1VfVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19SQ1VfQk9PU1QgaXMgbm90IHNldApD
T05GSUdfSUtDT05GSUc9eQpDT05GSUdfSUtDT05GSUdfUFJPQz15CkNPTkZJR19MT0dfQlVG
X1NISUZUPTE3CkNPTkZJR19IQVZFX1VOU1RBQkxFX1NDSEVEX0NMT0NLPXkKQ09ORklHX0NH
Uk9VUFM9eQojIENPTkZJR19DR1JPVVBfREVCVUcgaXMgbm90IHNldApDT05GSUdfQ0dST1VQ
X0ZSRUVaRVI9eQpDT05GSUdfQ0dST1VQX0RFVklDRT15CkNPTkZJR19DUFVTRVRTPXkKQ09O
RklHX1BST0NfUElEX0NQVVNFVD15CkNPTkZJR19DR1JPVVBfQ1BVQUNDVD15CkNPTkZJR19S
RVNPVVJDRV9DT1VOVEVSUz15CkNPTkZJR19NRU1DRz15CiMgQ09ORklHX01FTUNHX1NXQVAg
aXMgbm90IHNldAojIENPTkZJR19NRU1DR19LTUVNIGlzIG5vdCBzZXQKQ09ORklHX0NHUk9V
UF9IVUdFVExCPXkKQ09ORklHX0NHUk9VUF9QRVJGPXkKQ09ORklHX0NHUk9VUF9TQ0hFRD15
CkNPTkZJR19GQUlSX0dST1VQX1NDSEVEPXkKIyBDT05GSUdfQ0ZTX0JBTkRXSURUSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUX0dST1VQX1NDSEVEIGlzIG5vdCBzZXQKQ09ORklHX0JMS19D
R1JPVVA9eQojIENPTkZJR19ERUJVR19CTEtfQ0dST1VQIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q0hFQ0tQT0lOVF9SRVNUT1JFIGlzIG5vdCBzZXQKQ09ORklHX05BTUVTUEFDRVM9eQpDT05G
SUdfVVRTX05TPXkKQ09ORklHX0lQQ19OUz15CkNPTkZJR19QSURfTlM9eQpDT05GSUdfTkVU
X05TPXkKQ09ORklHX1NDSEVEX0FVVE9HUk9VUD15CkNPTkZJR19NTV9PV05FUj15CiMgQ09O
RklHX1NZU0ZTX0RFUFJFQ0FURUQgaXMgbm90IHNldApDT05GSUdfUkVMQVk9eQpDT05GSUdf
QkxLX0RFVl9JTklUUkQ9eQpDT05GSUdfSU5JVFJBTUZTX1NPVVJDRT0iIgpDT05GSUdfUkRf
R1pJUD15CkNPTkZJR19SRF9CWklQMj15CkNPTkZJR19SRF9MWk1BPXkKQ09ORklHX1JEX1ha
PXkKQ09ORklHX1JEX0xaTz15CiMgQ09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFIGlzIG5v
dCBzZXQKQ09ORklHX1NZU0NUTD15CkNPTkZJR19BTk9OX0lOT0RFUz15CiMgQ09ORklHX0VY
UEVSVCBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX1VJRDE2PXkKQ09ORklHX1VJRDE2PXkKIyBD
T05GSUdfU1lTQ1RMX1NZU0NBTEwgaXMgbm90IHNldApDT05GSUdfU1lTQ1RMX0VYQ0VQVElP
Tl9UUkFDRT15CkNPTkZJR19LQUxMU1lNUz15CiMgQ09ORklHX0tBTExTWU1TX0FMTCBpcyBu
b3Qgc2V0CkNPTkZJR19IT1RQTFVHPXkKQ09ORklHX1BSSU5USz15CkNPTkZJR19CVUc9eQpD
T05GSUdfRUxGX0NPUkU9eQpDT05GSUdfUENTUEtSX1BMQVRGT1JNPXkKQ09ORklHX0hBVkVf
UENTUEtSX1BMQVRGT1JNPXkKQ09ORklHX0JBU0VfRlVMTD15CkNPTkZJR19GVVRFWD15CkNP
TkZJR19FUE9MTD15CkNPTkZJR19TSUdOQUxGRD15CkNPTkZJR19USU1FUkZEPXkKQ09ORklH
X0VWRU5URkQ9eQpDT05GSUdfU0hNRU09eQpDT05GSUdfQUlPPXkKIyBDT05GSUdfRU1CRURE
RUQgaXMgbm90IHNldApDT05GSUdfSEFWRV9QRVJGX0VWRU5UUz15CgojCiMgS2VybmVsIFBl
cmZvcm1hbmNlIEV2ZW50cyBBbmQgQ291bnRlcnMKIwpDT05GSUdfUEVSRl9FVkVOVFM9eQoj
IENPTkZJR19ERUJVR19QRVJGX1VTRV9WTUFMTE9DIGlzIG5vdCBzZXQKQ09ORklHX1ZNX0VW
RU5UX0NPVU5URVJTPXkKQ09ORklHX1BDSV9RVUlSS1M9eQpDT05GSUdfU0xVQl9ERUJVRz15
CiMgQ09ORklHX0NPTVBBVF9CUksgaXMgbm90IHNldAojIENPTkZJR19TTEFCIGlzIG5vdCBz
ZXQKQ09ORklHX1NMVUI9eQpDT05GSUdfUFJPRklMSU5HPXkKQ09ORklHX1RSQUNFUE9JTlRT
PXkKQ09ORklHX09QUk9GSUxFPW0KIyBDT05GSUdfT1BST0ZJTEVfRVZFTlRfTVVMVElQTEVY
IGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfT1BST0ZJTEU9eQpDT05GSUdfT1BST0ZJTEVfTk1J
X1RJTUVSPXkKQ09ORklHX0tQUk9CRVM9eQpDT05GSUdfSlVNUF9MQUJFTD15CkNPTkZJR19I
QVZFX0VGRklDSUVOVF9VTkFMSUdORURfQUNDRVNTPXkKQ09ORklHX0tSRVRQUk9CRVM9eQpD
T05GSUdfSEFWRV9JT1JFTUFQX1BST1Q9eQpDT05GSUdfSEFWRV9LUFJPQkVTPXkKQ09ORklH
X0hBVkVfS1JFVFBST0JFUz15CkNPTkZJR19IQVZFX09QVFBST0JFUz15CkNPTkZJR19IQVZF
X0FSQ0hfVFJBQ0VIT09LPXkKQ09ORklHX0hBVkVfRE1BX0FUVFJTPXkKQ09ORklHX1VTRV9H
RU5FUklDX1NNUF9IRUxQRVJTPXkKQ09ORklHX0dFTkVSSUNfU01QX0lETEVfVEhSRUFEPXkK
Q09ORklHX0hBVkVfUkVHU19BTkRfU1RBQ0tfQUNDRVNTX0FQST15CkNPTkZJR19IQVZFX0RN
QV9BUElfREVCVUc9eQpDT05GSUdfSEFWRV9IV19CUkVBS1BPSU5UPXkKQ09ORklHX0hBVkVf
TUlYRURfQlJFQUtQT0lOVFNfUkVHUz15CkNPTkZJR19IQVZFX1VTRVJfUkVUVVJOX05PVElG
SUVSPXkKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFNfTk1JPXkKQ09ORklHX0hBVkVfUEVSRl9S
RUdTPXkKQ09ORklHX0hBVkVfUEVSRl9VU0VSX1NUQUNLX0RVTVA9eQpDT05GSUdfSEFWRV9B
UkNIX0pVTVBfTEFCRUw9eQpDT05GSUdfQVJDSF9IQVZFX05NSV9TQUZFX0NNUFhDSEc9eQpD
T05GSUdfSEFWRV9BTElHTkVEX1NUUlVDVF9QQUdFPXkKQ09ORklHX0hBVkVfQ01QWENIR19M
T0NBTD15CkNPTkZJR19IQVZFX0NNUFhDSEdfRE9VQkxFPXkKQ09ORklHX0FSQ0hfV0FOVF9D
T01QQVRfSVBDX1BBUlNFX1ZFUlNJT049eQpDT05GSUdfQVJDSF9XQU5UX09MRF9DT01QQVRf
SVBDPXkKQ09ORklHX0dFTkVSSUNfS0VSTkVMX1RIUkVBRD15CkNPTkZJR19HRU5FUklDX0tF
Uk5FTF9FWEVDVkU9eQpDT05GSUdfSEFWRV9BUkNIX1NFQ0NPTVBfRklMVEVSPXkKQ09ORklH
X1NFQ0NPTVBfRklMVEVSPXkKQ09ORklHX0hBVkVfUkNVX1VTRVJfUVM9eQpDT05GSUdfSEFW
RV9JUlFfVElNRV9BQ0NPVU5USU5HPXkKQ09ORklHX0hBVkVfQVJDSF9UUkFOU1BBUkVOVF9I
VUdFUEFHRT15CkNPTkZJR19NT0RVTEVTX1VTRV9FTEZfUkVMQT15CgojCiMgR0NPVi1iYXNl
ZCBrZXJuZWwgcHJvZmlsaW5nCiMKIyBDT05GSUdfR0NPVl9LRVJORUwgaXMgbm90IHNldAoj
IENPTkZJR19IQVZFX0dFTkVSSUNfRE1BX0NPSEVSRU5UIGlzIG5vdCBzZXQKQ09ORklHX1NM
QUJJTkZPPXkKQ09ORklHX1JUX01VVEVYRVM9eQpDT05GSUdfQkFTRV9TTUFMTD0wCkNPTkZJ
R19NT0RVTEVTPXkKQ09ORklHX01PRFVMRV9GT1JDRV9MT0FEPXkKQ09ORklHX01PRFVMRV9V
TkxPQUQ9eQpDT05GSUdfTU9EVUxFX0ZPUkNFX1VOTE9BRD15CkNPTkZJR19NT0RWRVJTSU9O
Uz15CiMgQ09ORklHX01PRFVMRV9TUkNWRVJTSU9OX0FMTCBpcyBub3Qgc2V0CiMgQ09ORklH
X01PRFVMRV9TSUcgaXMgbm90IHNldApDT05GSUdfU1RPUF9NQUNISU5FPXkKQ09ORklHX0JM
T0NLPXkKQ09ORklHX0JMS19ERVZfQlNHPXkKQ09ORklHX0JMS19ERVZfQlNHTElCPXkKQ09O
RklHX0JMS19ERVZfSU5URUdSSVRZPXkKIyBDT05GSUdfQkxLX0RFVl9USFJPVFRMSU5HIGlz
IG5vdCBzZXQKCiMKIyBQYXJ0aXRpb24gVHlwZXMKIwpDT05GSUdfUEFSVElUSU9OX0FEVkFO
Q0VEPXkKIyBDT05GSUdfQUNPUk5fUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfT1NG
X1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FNSUdBX1BBUlRJVElPTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0FUQVJJX1BBUlRJVElPTiBpcyBub3Qgc2V0CkNPTkZJR19NQUNfUEFS
VElUSU9OPXkKQ09ORklHX01TRE9TX1BBUlRJVElPTj15CkNPTkZJR19CU0RfRElTS0xBQkVM
PXkKIyBDT05GSUdfTUlOSVhfU1VCUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfU09M
QVJJU19YODZfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVU5JWFdBUkVfRElTS0xB
QkVMIGlzIG5vdCBzZXQKQ09ORklHX0xETV9QQVJUSVRJT049eQojIENPTkZJR19MRE1fREVC
VUcgaXMgbm90IHNldAojIENPTkZJR19TR0lfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05G
SUdfVUxUUklYX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NVTl9QQVJUSVRJT04g
aXMgbm90IHNldAojIENPTkZJR19LQVJNQV9QQVJUSVRJT04gaXMgbm90IHNldApDT05GSUdf
RUZJX1BBUlRJVElPTj15CiMgQ09ORklHX1NZU1Y2OF9QQVJUSVRJT04gaXMgbm90IHNldApD
T05GSUdfQkxPQ0tfQ09NUEFUPXkKCiMKIyBJTyBTY2hlZHVsZXJzCiMKQ09ORklHX0lPU0NI
RURfTk9PUD15CkNPTkZJR19JT1NDSEVEX0RFQURMSU5FPXkKQ09ORklHX0lPU0NIRURfQ0ZR
PXkKQ09ORklHX0NGUV9HUk9VUF9JT1NDSEVEPXkKIyBDT05GSUdfREVGQVVMVF9ERUFETElO
RSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfTk9P
UCBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0lPU0NIRUQ9ImNmcSIKQ09ORklHX1BBREFU
QT15CkNPTkZJR19BU04xPW0KQ09ORklHX1VOSU5MSU5FX1NQSU5fVU5MT0NLPXkKQ09ORklH
X01VVEVYX1NQSU5fT05fT1dORVI9eQpDT05GSUdfRlJFRVpFUj15CgojCiMgUHJvY2Vzc29y
IHR5cGUgYW5kIGZlYXR1cmVzCiMKQ09ORklHX1pPTkVfRE1BPXkKQ09ORklHX1NNUD15CkNP
TkZJR19YODZfWDJBUElDPXkKQ09ORklHX1g4Nl9NUFBBUlNFPXkKIyBDT05GSUdfWDg2X0VY
VEVOREVEX1BMQVRGT1JNIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9TVVBQT1JUU19NRU1PUllf
RkFJTFVSRT15CkNPTkZJR19TQ0hFRF9PTUlUX0ZSQU1FX1BPSU5URVI9eQpDT05GSUdfUEFS
QVZJUlRfR1VFU1Q9eQojIENPTkZJR19QQVJBVklSVF9USU1FX0FDQ09VTlRJTkcgaXMgbm90
IHNldAojIENPTkZJR19YRU4gaXMgbm90IHNldAojIENPTkZJR19YRU5fUFJJVklMRUdFRF9H
VUVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0tWTV9HVUVTVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBUkFWSVJUIGlzIG5vdCBzZXQKQ09ORklHX05PX0JPT1RNRU09eQpDT05GSUdfTUVNVEVT
VD15CiMgQ09ORklHX01LOCBpcyBub3Qgc2V0CiMgQ09ORklHX01QU0MgaXMgbm90IHNldApD
T05GSUdfTUNPUkUyPXkKIyBDT05GSUdfTUFUT00gaXMgbm90IHNldAojIENPTkZJR19HRU5F
UklDX0NQVSBpcyBub3Qgc2V0CkNPTkZJR19YODZfSU5URVJOT0RFX0NBQ0hFX1NISUZUPTYK
Q09ORklHX1g4Nl9DTVBYQ0hHPXkKQ09ORklHX1g4Nl9MMV9DQUNIRV9TSElGVD02CkNPTkZJ
R19YODZfWEFERD15CkNPTkZJR19YODZfV1BfV09SS1NfT0s9eQpDT05GSUdfWDg2X0lOVEVM
X1VTRVJDT1BZPXkKQ09ORklHX1g4Nl9VU0VfUFBST19DSEVDS1NVTT15CkNPTkZJR19YODZf
UDZfTk9QPXkKQ09ORklHX1g4Nl9UU0M9eQpDT05GSUdfWDg2X0NNUFhDSEc2ND15CkNPTkZJ
R19YODZfQ01PVj15CkNPTkZJR19YODZfTUlOSU1VTV9DUFVfRkFNSUxZPTY0CkNPTkZJR19Y
ODZfREVCVUdDVExNU1I9eQpDT05GSUdfQ1BVX1NVUF9JTlRFTD15CkNPTkZJR19DUFVfU1VQ
X0FNRD15CkNPTkZJR19DUFVfU1VQX0NFTlRBVVI9eQpDT05GSUdfSFBFVF9USU1FUj15CkNP
TkZJR19IUEVUX0VNVUxBVEVfUlRDPXkKQ09ORklHX0RNST15CkNPTkZJR19HQVJUX0lPTU1V
PXkKIyBDT05GSUdfQ0FMR0FSWV9JT01NVSBpcyBub3Qgc2V0CkNPTkZJR19TV0lPVExCPXkK
Q09ORklHX0lPTU1VX0hFTFBFUj15CiMgQ09ORklHX01BWFNNUCBpcyBub3Qgc2V0CkNPTkZJ
R19OUl9DUFVTPTgKQ09ORklHX1NDSEVEX1NNVD15CkNPTkZJR19TQ0hFRF9NQz15CiMgQ09O
RklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0CiMgQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZ
IGlzIG5vdCBzZXQKQ09ORklHX1BSRUVNUFQ9eQpDT05GSUdfUFJFRU1QVF9DT1VOVD15CkNP
TkZJR19YODZfTE9DQUxfQVBJQz15CkNPTkZJR19YODZfSU9fQVBJQz15CkNPTkZJR19YODZf
UkVST1VURV9GT1JfQlJPS0VOX0JPT1RfSVJRUz15CkNPTkZJR19YODZfTUNFPXkKQ09ORklH
X1g4Nl9NQ0VfSU5URUw9eQpDT05GSUdfWDg2X01DRV9BTUQ9eQpDT05GSUdfWDg2X01DRV9U
SFJFU0hPTEQ9eQpDT05GSUdfWDg2X01DRV9JTkpFQ1Q9bQpDT05GSUdfWDg2X1RIRVJNQUxf
VkVDVE9SPXkKQ09ORklHX0k4Sz1tCkNPTkZJR19NSUNST0NPREU9bQpDT05GSUdfTUlDUk9D
T0RFX0lOVEVMPXkKQ09ORklHX01JQ1JPQ09ERV9BTUQ9eQpDT05GSUdfTUlDUk9DT0RFX09M
RF9JTlRFUkZBQ0U9eQpDT05GSUdfWDg2X01TUj1tCkNPTkZJR19YODZfQ1BVSUQ9bQpDT05G
SUdfQVJDSF9QSFlTX0FERFJfVF82NEJJVD15CkNPTkZJR19BUkNIX0RNQV9BRERSX1RfNjRC
SVQ9eQpDT05GSUdfRElSRUNUX0dCUEFHRVM9eQpDT05GSUdfTlVNQT15CkNPTkZJR19BTURf
TlVNQT15CkNPTkZJR19YODZfNjRfQUNQSV9OVU1BPXkKQ09ORklHX05PREVTX1NQQU5fT1RI
RVJfTk9ERVM9eQpDT05GSUdfTlVNQV9FTVU9eQpDT05GSUdfTk9ERVNfU0hJRlQ9NgpDT05G
SUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxFPXkKQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0RFRkFV
TFQ9eQpDT05GSUdfQVJDSF9TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09ORklHX0FSQ0hfUFJP
Q19LQ09SRV9URVhUPXkKQ09ORklHX0lMTEVHQUxfUE9JTlRFUl9WQUxVRT0weGRlYWQwMDAw
MDAwMDAwMDAKQ09ORklHX1NFTEVDVF9NRU1PUllfTU9ERUw9eQpDT05GSUdfU1BBUlNFTUVN
X01BTlVBTD15CkNPTkZJR19TUEFSU0VNRU09eQpDT05GSUdfTkVFRF9NVUxUSVBMRV9OT0RF
Uz15CkNPTkZJR19IQVZFX01FTU9SWV9QUkVTRU5UPXkKQ09ORklHX1NQQVJTRU1FTV9FWFRS
RU1FPXkKQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQX0VOQUJMRT15CkNPTkZJR19TUEFSU0VN
RU1fQUxMT0NfTUVNX01BUF9UT0dFVEhFUj15CkNPTkZJR19TUEFSU0VNRU1fVk1FTU1BUD15
CkNPTkZJR19IQVZFX01FTUJMT0NLPXkKQ09ORklHX0hBVkVfTUVNQkxPQ0tfTk9ERV9NQVA9
eQpDT05GSUdfQVJDSF9ESVNDQVJEX01FTUJMT0NLPXkKQ09ORklHX01FTU9SWV9JU09MQVRJ
T049eQojIENPTkZJR19NRU1PUllfSE9UUExVRyBpcyBub3Qgc2V0CkNPTkZJR19QQUdFRkxB
R1NfRVhURU5ERUQ9eQpDT05GSUdfU1BMSVRfUFRMT0NLX0NQVVM9NApDT05GSUdfQ09NUEFD
VElPTj15CkNPTkZJR19NSUdSQVRJT049eQpDT05GSUdfUEhZU19BRERSX1RfNjRCSVQ9eQpD
T05GSUdfWk9ORV9ETUFfRkxBRz0xCkNPTkZJR19CT1VOQ0U9eQpDT05GSUdfVklSVF9UT19C
VVM9eQpDT05GSUdfTU1VX05PVElGSUVSPXkKQ09ORklHX0tTTT15CkNPTkZJR19ERUZBVUxU
X01NQVBfTUlOX0FERFI9NjU1MzYKQ09ORklHX0FSQ0hfU1VQUE9SVFNfTUVNT1JZX0ZBSUxV
UkU9eQpDT05GSUdfTUVNT1JZX0ZBSUxVUkU9eQpDT05GSUdfSFdQT0lTT05fSU5KRUNUPW0K
Q09ORklHX1RSQU5TUEFSRU5UX0hVR0VQQUdFPXkKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVH
RVBBR0VfQUxXQVlTIGlzIG5vdCBzZXQKQ09ORklHX1RSQU5TUEFSRU5UX0hVR0VQQUdFX01B
RFZJU0U9eQpDT05GSUdfQ1JPU1NfTUVNT1JZX0FUVEFDSD15CkNPTkZJR19DTEVBTkNBQ0hF
PXkKQ09ORklHX0ZST05UU1dBUD15CiMgQ09ORklHX1g4Nl9DSEVDS19CSU9TX0NPUlJVUFRJ
T04gaXMgbm90IHNldApDT05GSUdfWDg2X1JFU0VSVkVfTE9XPTY0CkNPTkZJR19NVFJSPXkK
Q09ORklHX01UUlJfU0FOSVRJWkVSPXkKQ09ORklHX01UUlJfU0FOSVRJWkVSX0VOQUJMRV9E
RUZBVUxUPTAKQ09ORklHX01UUlJfU0FOSVRJWkVSX1NQQVJFX1JFR19OUl9ERUZBVUxUPTEK
Q09ORklHX1g4Nl9QQVQ9eQpDT05GSUdfQVJDSF9VU0VTX1BHX1VOQ0FDSEVEPXkKQ09ORklH
X0FSQ0hfUkFORE9NPXkKQ09ORklHX1g4Nl9TTUFQPXkKQ09ORklHX0VGST15CkNPTkZJR19F
RklfU1RVQj15CkNPTkZJR19TRUNDT01QPXkKQ09ORklHX0NDX1NUQUNLUFJPVEVDVE9SPXkK
IyBDT05GSUdfSFpfMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMjUwIGlzIG5vdCBzZXQK
IyBDT05GSUdfSFpfMzAwIGlzIG5vdCBzZXQKQ09ORklHX0haXzEwMDA9eQpDT05GSUdfSFo9
MTAwMApDT05GSUdfU0NIRURfSFJUSUNLPXkKIyBDT05GSUdfS0VYRUMgaXMgbm90IHNldApD
T05GSUdfQ1JBU0hfRFVNUD15CkNPTkZJR19QSFlTSUNBTF9TVEFSVD0weDEwMDAwMDAKQ09O
RklHX1JFTE9DQVRBQkxFPXkKQ09ORklHX1BIWVNJQ0FMX0FMSUdOPTB4MTAwMDAwMApDT05G
SUdfSE9UUExVR19DUFU9eQojIENPTkZJR19DT01QQVRfVkRTTyBpcyBub3Qgc2V0CiMgQ09O
RklHX0NNRExJTkVfQk9PTCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0VOQUJMRV9NRU1PUllf
SE9UUExVRz15CkNPTkZJR19VU0VfUEVSQ1BVX05VTUFfTk9ERV9JRD15CgojCiMgUG93ZXIg
bWFuYWdlbWVudCBhbmQgQUNQSSBvcHRpb25zCiMKQ09ORklHX0FSQ0hfSElCRVJOQVRJT05f
SEVBREVSPXkKQ09ORklHX1NVU1BFTkQ9eQpDT05GSUdfU1VTUEVORF9GUkVFWkVSPXkKQ09O
RklHX0hJQkVSTkFURV9DQUxMQkFDS1M9eQpDT05GSUdfSElCRVJOQVRJT049eQpDT05GSUdf
UE1fU1REX1BBUlRJVElPTj0iIgpDT05GSUdfUE1fU0xFRVA9eQpDT05GSUdfUE1fU0xFRVBf
U01QPXkKIyBDT05GSUdfUE1fQVVUT1NMRUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1fV0FL
RUxPQ0tTIGlzIG5vdCBzZXQKQ09ORklHX1BNX1JVTlRJTUU9eQpDT05GSUdfUE09eQpDT05G
SUdfUE1fREVCVUc9eQpDT05GSUdfUE1fQURWQU5DRURfREVCVUc9eQojIENPTkZJR19QTV9U
RVNUX1NVU1BFTkQgaXMgbm90IHNldApDT05GSUdfUE1fU0xFRVBfREVCVUc9eQpDT05GSUdf
UE1fVFJBQ0U9eQpDT05GSUdfUE1fVFJBQ0VfUlRDPXkKQ09ORklHX0FDUEk9eQpDT05GSUdf
QUNQSV9TTEVFUD15CiMgQ09ORklHX0FDUElfUFJPQ0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
QUNQSV9QUk9DRlNfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX0VDX0RFQlVHRlMg
aXMgbm90IHNldAojIENPTkZJR19BQ1BJX1BST0NfRVZFTlQgaXMgbm90IHNldApDT05GSUdf
QUNQSV9BQz1tCkNPTkZJR19BQ1BJX0JBVFRFUlk9bQpDT05GSUdfQUNQSV9CVVRUT049bQpD
T05GSUdfQUNQSV9WSURFTz1tCkNPTkZJR19BQ1BJX0ZBTj1tCiMgQ09ORklHX0FDUElfRE9D
SyBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1BST0NFU1NPUj1tCkNPTkZJR19BQ1BJX0lQTUk9
bQpDT05GSUdfQUNQSV9IT1RQTFVHX0NQVT15CkNPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dS
RUdBVE9SPW0KQ09ORklHX0FDUElfVEhFUk1BTD1tCkNPTkZJR19BQ1BJX05VTUE9eQojIENP
TkZJR19BQ1BJX0NVU1RPTV9EU0RUIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQkxBQ0tMSVNU
X1lFQVI9MAojIENPTkZJR19BQ1BJX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfUENJ
X1NMT1Q9bQpDT05GSUdfWDg2X1BNX1RJTUVSPXkKQ09ORklHX0FDUElfQ09OVEFJTkVSPW0K
Q09ORklHX0FDUElfU0JTPW0KQ09ORklHX0FDUElfSEVEPXkKIyBDT05GSUdfQUNQSV9DVVNU
T01fTUVUSE9EIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQkdSVD15CkNPTkZJR19BQ1BJX0FQ
RUk9eQpDT05GSUdfQUNQSV9BUEVJX0dIRVM9eQpDT05GSUdfQUNQSV9BUEVJX1BDSUVBRVI9
eQpDT05GSUdfQUNQSV9BUEVJX01FTU9SWV9GQUlMVVJFPXkKIyBDT05GSUdfQUNQSV9BUEVJ
X0VJTkogaXMgbm90IHNldAojIENPTkZJR19BQ1BJX0FQRUlfRVJTVF9ERUJVRyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NGSSBpcyBub3Qgc2V0CgojCiMgQ1BVIEZyZXF1ZW5jeSBzY2FsaW5n
CiMKQ09ORklHX0NQVV9GUkVRPXkKQ09ORklHX0NQVV9GUkVRX1RBQkxFPXkKQ09ORklHX0NQ
VV9GUkVRX1NUQVQ9bQojIENPTkZJR19DUFVfRlJFUV9TVEFUX0RFVEFJTFMgaXMgbm90IHNl
dAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1VTRVJTUEFDRSBpcyBub3Qgc2V0CkNP
TkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9PTkRFTUFORD15CiMgQ09ORklHX0NQVV9GUkVR
X0RFRkFVTFRfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9H
T1ZfUEVSRk9STUFOQ0U9eQpDT05GSUdfQ1BVX0ZSRVFfR09WX1BPV0VSU0FWRT1tCkNPTkZJ
R19DUFVfRlJFUV9HT1ZfVVNFUlNQQUNFPW0KQ09ORklHX0NQVV9GUkVRX0dPVl9PTkRFTUFO
RD15CkNPTkZJR19DUFVfRlJFUV9HT1ZfQ09OU0VSVkFUSVZFPW0KCiMKIyB4ODYgQ1BVIGZy
ZXF1ZW5jeSBzY2FsaW5nIGRyaXZlcnMKIwpDT05GSUdfWDg2X1BDQ19DUFVGUkVRPW0KQ09O
RklHX1g4Nl9BQ1BJX0NQVUZSRVE9bQojIENPTkZJR19YODZfQUNQSV9DUFVGUkVRX0NQQiBp
cyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QT1dFUk5PV19LOCBpcyBub3Qgc2V0CiMgQ09ORklH
X1g4Nl9TUEVFRFNURVBfQ0VOVFJJTk8gaXMgbm90IHNldAojIENPTkZJR19YODZfUDRfQ0xP
Q0tNT0QgaXMgbm90IHNldAoKIwojIHNoYXJlZCBvcHRpb25zCiMKIyBDT05GSUdfWDg2X1NQ
RUVEU1RFUF9MSUIgaXMgbm90IHNldApDT05GSUdfQ1BVX0lETEU9eQpDT05GSUdfQ1BVX0lE
TEVfR09WX0xBRERFUj15CkNPTkZJR19DUFVfSURMRV9HT1ZfTUVOVT15CiMgQ09ORklHX0FS
Q0hfTkVFRFNfQ1BVX0lETEVfQ09VUExFRCBpcyBub3Qgc2V0CkNPTkZJR19JTlRFTF9JRExF
PXkKCiMKIyBNZW1vcnkgcG93ZXIgc2F2aW5ncwojCkNPTkZJR19JNzMwMF9JRExFX0lPQVRf
Q0hBTk5FTD15CkNPTkZJR19JNzMwMF9JRExFPW0KCiMKIyBCdXMgb3B0aW9ucyAoUENJIGV0
Yy4pCiMKQ09ORklHX1BDST15CkNPTkZJR19QQ0lfRElSRUNUPXkKQ09ORklHX1BDSV9NTUNP
TkZJRz15CkNPTkZJR19QQ0lfRE9NQUlOUz15CkNPTkZJR19QQ0lFUE9SVEJVUz15CkNPTkZJ
R19IT1RQTFVHX1BDSV9QQ0lFPXkKQ09ORklHX1BDSUVBRVI9eQojIENPTkZJR19QQ0lFX0VD
UkMgaXMgbm90IHNldApDT05GSUdfUENJRUFFUl9JTkpFQ1Q9bQpDT05GSUdfUENJRUFTUE09
eQojIENPTkZJR19QQ0lFQVNQTV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19QQ0lFQVNQTV9E
RUZBVUxUPXkKIyBDT05GSUdfUENJRUFTUE1fUE9XRVJTQVZFIGlzIG5vdCBzZXQKIyBDT05G
SUdfUENJRUFTUE1fUEVSRk9STUFOQ0UgaXMgbm90IHNldApDT05GSUdfUENJRV9QTUU9eQpD
T05GSUdfQVJDSF9TVVBQT1JUU19NU0k9eQpDT05GSUdfUENJX01TST15CiMgQ09ORklHX1BD
SV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9SRUFMTE9DX0VOQUJMRV9BVVRPIGlz
IG5vdCBzZXQKIyBDT05GSUdfUENJX1NUVUIgaXMgbm90IHNldApDT05GSUdfSFRfSVJRPXkK
Q09ORklHX1BDSV9BVFM9eQpDT05GSUdfUENJX0lPVj15CkNPTkZJR19QQ0lfUFJJPXkKQ09O
RklHX1BDSV9QQVNJRD15CkNPTkZJR19QQ0lfSU9BUElDPXkKQ09ORklHX1BDSV9MQUJFTD15
CkNPTkZJR19JU0FfRE1BX0FQST15CkNPTkZJR19BTURfTkI9eQojIENPTkZJR19QQ0NBUkQg
aXMgbm90IHNldApDT05GSUdfSE9UUExVR19QQ0k9eQpDT05GSUdfSE9UUExVR19QQ0lfQUNQ
ST15CkNPTkZJR19IT1RQTFVHX1BDSV9BQ1BJX0lCTT1tCkNPTkZJR19IT1RQTFVHX1BDSV9D
UENJPXkKQ09ORklHX0hPVFBMVUdfUENJX0NQQ0lfWlQ1NTUwPW0KQ09ORklHX0hPVFBMVUdf
UENJX0NQQ0lfR0VORVJJQz1tCkNPTkZJR19IT1RQTFVHX1BDSV9TSFBDPW0KIyBDT05GSUdf
UkFQSURJTyBpcyBub3Qgc2V0CgojCiMgRXhlY3V0YWJsZSBmaWxlIGZvcm1hdHMgLyBFbXVs
YXRpb25zCiMKQ09ORklHX0JJTkZNVF9FTEY9eQpDT05GSUdfQ09NUEFUX0JJTkZNVF9FTEY9
eQpDT05GSUdfQVJDSF9CSU5GTVRfRUxGX1JBTkRPTUlaRV9QSUU9eQpDT05GSUdfQ09SRV9E
VU1QX0RFRkFVTFRfRUxGX0hFQURFUlM9eQojIENPTkZJR19IQVZFX0FPVVQgaXMgbm90IHNl
dApDT05GSUdfQklORk1UX01JU0M9bQpDT05GSUdfQ09SRURVTVA9eQpDT05GSUdfSUEzMl9F
TVVMQVRJT049eQojIENPTkZJR19JQTMyX0FPVVQgaXMgbm90IHNldAojIENPTkZJR19YODZf
WDMyIGlzIG5vdCBzZXQKQ09ORklHX0NPTVBBVD15CkNPTkZJR19DT01QQVRfRk9SX1U2NF9B
TElHTk1FTlQ9eQpDT05GSUdfU1lTVklQQ19DT01QQVQ9eQpDT05GSUdfS0VZU19DT01QQVQ9
eQpDT05GSUdfSEFWRV9URVhUX1BPS0VfU01QPXkKQ09ORklHX1g4Nl9ERVZfRE1BX09QUz15
CkNPTkZJR19ORVQ9eQpDT05GSUdfQ09NUEFUX05FVExJTktfTUVTU0FHRVM9eQoKIwojIE5l
dHdvcmtpbmcgb3B0aW9ucwojCkNPTkZJR19QQUNLRVQ9eQpDT05GSUdfUEFDS0VUX0RJQUc9
eQpDT05GSUdfVU5JWD15CiMgQ09ORklHX1VOSVhfRElBRyBpcyBub3Qgc2V0CkNPTkZJR19Y
RlJNPXkKQ09ORklHX1hGUk1fQUxHTz1tCkNPTkZJR19YRlJNX1VTRVI9bQpDT05GSUdfWEZS
TV9TVUJfUE9MSUNZPXkKQ09ORklHX1hGUk1fTUlHUkFURT15CiMgQ09ORklHX1hGUk1fU1RB
VElTVElDUyBpcyBub3Qgc2V0CkNPTkZJR19YRlJNX0lQQ09NUD1tCkNPTkZJR19ORVRfS0VZ
PW0KQ09ORklHX05FVF9LRVlfTUlHUkFURT15CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX01V
TFRJQ0FTVD15CkNPTkZJR19JUF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfSVBfRklCX1RS
SUVfU1RBVFM9eQpDT05GSUdfSVBfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRF
X01VTFRJUEFUSD15CkNPTkZJR19JUF9ST1VURV9WRVJCT1NFPXkKQ09ORklHX0lQX1JPVVRF
X0NMQVNTSUQ9eQojIENPTkZJR19JUF9QTlAgaXMgbm90IHNldApDT05GSUdfTkVUX0lQSVA9
bQpDT05GSUdfTkVUX0lQR1JFX0RFTVVYPW0KQ09ORklHX05FVF9JUEdSRT1tCkNPTkZJR19O
RVRfSVBHUkVfQlJPQURDQVNUPXkKQ09ORklHX0lQX01ST1VURT15CkNPTkZJR19JUF9NUk9V
VEVfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1BJTVNNX1YxPXkKQ09ORklHX0lQX1BJ
TVNNX1YyPXkKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CkNPTkZJR19TWU5fQ09PS0lFUz15
CiMgQ09ORklHX05FVF9JUFZUSSBpcyBub3Qgc2V0CkNPTkZJR19JTkVUX0FIPW0KQ09ORklH
X0lORVRfRVNQPW0KQ09ORklHX0lORVRfSVBDT01QPW0KQ09ORklHX0lORVRfWEZSTV9UVU5O
RUw9bQpDT05GSUdfSU5FVF9UVU5ORUw9bQpDT05GSUdfSU5FVF9YRlJNX01PREVfVFJBTlNQ
T1JUPW0KQ09ORklHX0lORVRfWEZSTV9NT0RFX1RVTk5FTD1tCkNPTkZJR19JTkVUX1hGUk1f
TU9ERV9CRUVUPW0KQ09ORklHX0lORVRfTFJPPW0KQ09ORklHX0lORVRfRElBRz1tCkNPTkZJ
R19JTkVUX1RDUF9ESUFHPW0KIyBDT05GSUdfSU5FVF9VRFBfRElBRyBpcyBub3Qgc2V0CkNP
TkZJR19UQ1BfQ09OR19BRFZBTkNFRD15CkNPTkZJR19UQ1BfQ09OR19CSUM9bQpDT05GSUdf
VENQX0NPTkdfQ1VCSUM9eQpDT05GSUdfVENQX0NPTkdfV0VTVFdPT0Q9bQpDT05GSUdfVENQ
X0NPTkdfSFRDUD1tCkNPTkZJR19UQ1BfQ09OR19IU1RDUD1tCkNPTkZJR19UQ1BfQ09OR19I
WUJMQT1tCkNPTkZJR19UQ1BfQ09OR19WRUdBUz1tCkNPTkZJR19UQ1BfQ09OR19TQ0FMQUJM
RT1tCkNPTkZJR19UQ1BfQ09OR19MUD1tCkNPTkZJR19UQ1BfQ09OR19WRU5PPW0KQ09ORklH
X1RDUF9DT05HX1lFQUg9bQpDT05GSUdfVENQX0NPTkdfSUxMSU5PSVM9bQpDT05GSUdfREVG
QVVMVF9DVUJJQz15CiMgQ09ORklHX0RFRkFVTFRfUkVOTyBpcyBub3Qgc2V0CkNPTkZJR19E
RUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKQ09ORklHX1RDUF9NRDVTSUc9eQpDT05GSUdfSVBW
Nj15CkNPTkZJR19JUFY2X1BSSVZBQ1k9eQpDT05GSUdfSVBWNl9ST1VURVJfUFJFRj15CkNP
TkZJR19JUFY2X1JPVVRFX0lORk89eQpDT05GSUdfSVBWNl9PUFRJTUlTVElDX0RBRD15CkNP
TkZJR19JTkVUNl9BSD1tCkNPTkZJR19JTkVUNl9FU1A9bQpDT05GSUdfSU5FVDZfSVBDT01Q
PW0KQ09ORklHX0lQVjZfTUlQNj15CkNPTkZJR19JTkVUNl9YRlJNX1RVTk5FTD1tCkNPTkZJ
R19JTkVUNl9UVU5ORUw9bQpDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1RSQU5TUE9SVD1tCkNP
TkZJR19JTkVUNl9YRlJNX01PREVfVFVOTkVMPW0KQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9C
RUVUPW0KQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9ST1VURU9QVElNSVpBVElPTj1tCkNPTkZJ
R19JUFY2X1NJVD1tCkNPTkZJR19JUFY2X1NJVF82UkQ9eQpDT05GSUdfSVBWNl9ORElTQ19O
T0RFVFlQRT15CkNPTkZJR19JUFY2X1RVTk5FTD1tCkNPTkZJR19JUFY2X0dSRT1tCkNPTkZJ
R19JUFY2X01VTFRJUExFX1RBQkxFUz15CkNPTkZJR19JUFY2X1NVQlRSRUVTPXkKQ09ORklH
X0lQVjZfTVJPVVRFPXkKQ09ORklHX0lQVjZfTVJPVVRFX01VTFRJUExFX1RBQkxFUz15CkNP
TkZJR19JUFY2X1BJTVNNX1YyPXkKIyBDT05GSUdfTkVUTEFCRUwgaXMgbm90IHNldApDT05G
SUdfTkVUV09SS19TRUNNQVJLPXkKIyBDT05GSUdfTkVUV09SS19QSFlfVElNRVNUQU1QSU5H
IGlzIG5vdCBzZXQKQ09ORklHX05FVEZJTFRFUj15CiMgQ09ORklHX05FVEZJTFRFUl9ERUJV
RyBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfQURWQU5DRUQ9eQpDT05GSUdfQlJJREdF
X05FVEZJTFRFUj15CgojCiMgQ29yZSBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJ
R19ORVRGSUxURVJfTkVUTElOSz1tCiMgQ09ORklHX05FVEZJTFRFUl9ORVRMSU5LX0FDQ1Qg
aXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUU9bQpDT05GSUdfTkVU
RklMVEVSX05FVExJTktfTE9HPW0KQ09ORklHX05GX0NPTk5UUkFDSz1tCkNPTkZJR19ORl9D
T05OVFJBQ0tfTUFSSz15CkNPTkZJR19ORl9DT05OVFJBQ0tfU0VDTUFSSz15CkNPTkZJR19O
Rl9DT05OVFJBQ0tfWk9ORVM9eQpDT05GSUdfTkZfQ09OTlRSQUNLX1BST0NGUz15CkNPTkZJ
R19ORl9DT05OVFJBQ0tfRVZFTlRTPXkKIyBDT05GSUdfTkZfQ09OTlRSQUNLX1RJTUVPVVQg
aXMgbm90IHNldApDT05GSUdfTkZfQ09OTlRSQUNLX1RJTUVTVEFNUD15CkNPTkZJR19ORl9D
VF9QUk9UT19EQ0NQPW0KQ09ORklHX05GX0NUX1BST1RPX0dSRT1tCkNPTkZJR19ORl9DVF9Q
Uk9UT19TQ1RQPW0KQ09ORklHX05GX0NUX1BST1RPX1VEUExJVEU9bQpDT05GSUdfTkZfQ09O
TlRSQUNLX0FNQU5EQT1tCkNPTkZJR19ORl9DT05OVFJBQ0tfRlRQPW0KQ09ORklHX05GX0NP
Tk5UUkFDS19IMzIzPW0KQ09ORklHX05GX0NPTk5UUkFDS19JUkM9bQpDT05GSUdfTkZfQ09O
TlRSQUNLX0JST0FEQ0FTVD1tCkNPTkZJR19ORl9DT05OVFJBQ0tfTkVUQklPU19OUz1tCkNP
TkZJR19ORl9DT05OVFJBQ0tfU05NUD1tCkNPTkZJR19ORl9DT05OVFJBQ0tfUFBUUD1tCkNP
TkZJR19ORl9DT05OVFJBQ0tfU0FORT1tCkNPTkZJR19ORl9DT05OVFJBQ0tfU0lQPW0KQ09O
RklHX05GX0NPTk5UUkFDS19URlRQPW0KQ09ORklHX05GX0NUX05FVExJTks9bQojIENPTkZJ
R19ORl9DVF9ORVRMSU5LX1RJTUVPVVQgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJf
TkVUTElOS19RVUVVRV9DVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfVFBST1hZPW0K
Q09ORklHX05FVEZJTFRFUl9YVEFCTEVTPW0KCiMKIyBYdGFibGVzIGNvbWJpbmVkIG1vZHVs
ZXMKIwpDT05GSUdfTkVURklMVEVSX1hUX01BUks9bQpDT05GSUdfTkVURklMVEVSX1hUX0NP
Tk5NQVJLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9TRVQ9bQoKIwojIFh0YWJsZXMgdGFyZ2V0
cwojCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0FVRElUPW0KQ09ORklHX05FVEZJTFRF
Ul9YVF9UQVJHRVRfQ0hFQ0tTVU09bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9DTEFT
U0lGWT1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0NPTk5NQVJLPW0KQ09ORklHX05F
VEZJTFRFUl9YVF9UQVJHRVRfQ09OTlNFQ01BUks9bQpDT05GSUdfTkVURklMVEVSX1hUX1RB
UkdFVF9DVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0RTQ1A9bQpDT05GSUdfTkVU
RklMVEVSX1hUX1RBUkdFVF9ITD1tCiMgQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfSE1B
UksgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9JRExFVElNRVI9bQpD
T05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9MRUQ9bQojIENPTkZJR19ORVRGSUxURVJfWFRf
VEFSR0VUX0xPRyBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX01BUks9
bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORkxPRz1tCkNPTkZJR19ORVRGSUxURVJf
WFRfVEFSR0VUX05GUVVFVUU9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9SQVRFRVNU
PW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVEVFPW0KQ09ORklHX05FVEZJTFRFUl9Y
VF9UQVJHRVRfVFBST1hZPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVFJBQ0U9bQpD
T05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9TRUNNQVJLPW0KQ09ORklHX05FVEZJTFRFUl9Y
VF9UQVJHRVRfVENQTVNTPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVENQT1BUU1RS
SVA9bQoKIwojIFh0YWJsZXMgbWF0Y2hlcwojCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
QUREUlRZUEU9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NMVVNURVI9bQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX0NPTU1FTlQ9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X0NPTk5CWVRFUz1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkxJTUlUPW0KQ09O
RklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSz1tCkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfQ09OTlRSQUNLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DUFU9bQpDT05G
SUdfTkVURklMVEVSX1hUX01BVENIX0RDQ1A9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X0RFVkdST1VQPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9EU0NQPW0KQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9FQ049bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0VTUD1t
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEFTSExJTUlUPW0KQ09ORklHX05FVEZJTFRF
Ul9YVF9NQVRDSF9IRUxQRVI9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hMPW0KQ09O
RklHX05FVEZJTFRFUl9YVF9NQVRDSF9JUFJBTkdFPW0KQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9JUFZTPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MRU5HVEg9bQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX0xJTUlUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9N
QUM9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX01BUks9bQpDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX01VTFRJUE9SVD1tCiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9ORkFD
Q1QgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUX01BVENIX09TRj1tCkNPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfT1dORVI9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1BP
TElDWT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUEhZU0RFVj1tCkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfUEtUVFlQRT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUVVP
VEE9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JBVEVFU1Q9bQpDT05GSUdfTkVURklM
VEVSX1hUX01BVENIX1JFQUxNPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9SRUNFTlQ9
bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NDVFA9bQpDT05GSUdfTkVURklMVEVSX1hU
X01BVENIX1NPQ0tFVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVEU9bQpDT05G
SUdfTkVURklMVEVSX1hUX01BVENIX1NUQVRJU1RJQz1tCkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfU1RSSU5HPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9UQ1BNU1M9bQpDT05G
SUdfTkVURklMVEVSX1hUX01BVENIX1RJTUU9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X1UzMj1tCkNPTkZJR19JUF9TRVQ9bQpDT05GSUdfSVBfU0VUX01BWD0yNTYKQ09ORklHX0lQ
X1NFVF9CSVRNQVBfSVA9bQpDT05GSUdfSVBfU0VUX0JJVE1BUF9JUE1BQz1tCkNPTkZJR19J
UF9TRVRfQklUTUFQX1BPUlQ9bQpDT05GSUdfSVBfU0VUX0hBU0hfSVA9bQpDT05GSUdfSVBf
U0VUX0hBU0hfSVBQT1JUPW0KQ09ORklHX0lQX1NFVF9IQVNIX0lQUE9SVElQPW0KQ09ORklH
X0lQX1NFVF9IQVNIX0lQUE9SVE5FVD1tCkNPTkZJR19JUF9TRVRfSEFTSF9ORVQ9bQpDT05G
SUdfSVBfU0VUX0hBU0hfTkVUUE9SVD1tCkNPTkZJR19JUF9TRVRfSEFTSF9ORVRJRkFDRT1t
CkNPTkZJR19JUF9TRVRfTElTVF9TRVQ9bQpDT05GSUdfSVBfVlM9bQpDT05GSUdfSVBfVlNf
SVBWNj15CiMgQ09ORklHX0lQX1ZTX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0lQX1ZTX1RB
Ql9CSVRTPTEyCgojCiMgSVBWUyB0cmFuc3BvcnQgcHJvdG9jb2wgbG9hZCBiYWxhbmNpbmcg
c3VwcG9ydAojCkNPTkZJR19JUF9WU19QUk9UT19UQ1A9eQpDT05GSUdfSVBfVlNfUFJPVE9f
VURQPXkKQ09ORklHX0lQX1ZTX1BST1RPX0FIX0VTUD15CkNPTkZJR19JUF9WU19QUk9UT19F
U1A9eQpDT05GSUdfSVBfVlNfUFJPVE9fQUg9eQpDT05GSUdfSVBfVlNfUFJPVE9fU0NUUD15
CgojCiMgSVBWUyBzY2hlZHVsZXIKIwpDT05GSUdfSVBfVlNfUlI9bQpDT05GSUdfSVBfVlNf
V1JSPW0KQ09ORklHX0lQX1ZTX0xDPW0KQ09ORklHX0lQX1ZTX1dMQz1tCkNPTkZJR19JUF9W
U19MQkxDPW0KQ09ORklHX0lQX1ZTX0xCTENSPW0KQ09ORklHX0lQX1ZTX0RIPW0KQ09ORklH
X0lQX1ZTX1NIPW0KQ09ORklHX0lQX1ZTX1NFRD1tCkNPTkZJR19JUF9WU19OUT1tCgojCiMg
SVBWUyBTSCBzY2hlZHVsZXIKIwpDT05GSUdfSVBfVlNfU0hfVEFCX0JJVFM9OAoKIwojIElQ
VlMgYXBwbGljYXRpb24gaGVscGVyCiMKQ09ORklHX0lQX1ZTX05GQ1Q9eQpDT05GSUdfSVBf
VlNfUEVfU0lQPW0KCiMKIyBJUDogTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpDT05GSUdf
TkZfREVGUkFHX0lQVjQ9bQpDT05GSUdfTkZfQ09OTlRSQUNLX0lQVjQ9bQpDT05GSUdfTkZf
Q09OTlRSQUNLX1BST0NfQ09NUEFUPXkKQ09ORklHX0lQX05GX1FVRVVFPW0KQ09ORklHX0lQ
X05GX0lQVEFCTEVTPW0KQ09ORklHX0lQX05GX01BVENIX0FIPW0KQ09ORklHX0lQX05GX01B
VENIX0VDTj1tCiMgQ09ORklHX0lQX05GX01BVENIX1JQRklMVEVSIGlzIG5vdCBzZXQKQ09O
RklHX0lQX05GX01BVENIX1RUTD1tCkNPTkZJR19JUF9ORl9GSUxURVI9bQpDT05GSUdfSVBf
TkZfVEFSR0VUX1JFSkVDVD1tCkNPTkZJR19JUF9ORl9UQVJHRVRfVUxPRz1tCiMgQ09ORklH
X05GX05BVF9JUFY0IGlzIG5vdCBzZXQKQ09ORklHX0lQX05GX01BTkdMRT1tCkNPTkZJR19J
UF9ORl9UQVJHRVRfQ0xVU1RFUklQPW0KQ09ORklHX0lQX05GX1RBUkdFVF9FQ049bQpDT05G
SUdfSVBfTkZfVEFSR0VUX1RUTD1tCkNPTkZJR19JUF9ORl9SQVc9bQpDT05GSUdfSVBfTkZf
U0VDVVJJVFk9bQpDT05GSUdfSVBfTkZfQVJQVEFCTEVTPW0KQ09ORklHX0lQX05GX0FSUEZJ
TFRFUj1tCkNPTkZJR19JUF9ORl9BUlBfTUFOR0xFPW0KCiMKIyBJUHY2OiBOZXRmaWx0ZXIg
Q29uZmlndXJhdGlvbgojCkNPTkZJR19ORl9ERUZSQUdfSVBWNj1tCkNPTkZJR19ORl9DT05O
VFJBQ0tfSVBWNj1tCkNPTkZJR19JUDZfTkZfSVBUQUJMRVM9bQpDT05GSUdfSVA2X05GX01B
VENIX0FIPW0KQ09ORklHX0lQNl9ORl9NQVRDSF9FVUk2ND1tCkNPTkZJR19JUDZfTkZfTUFU
Q0hfRlJBRz1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfT1BUUz1tCkNPTkZJR19JUDZfTkZfTUFU
Q0hfSEw9bQpDT05GSUdfSVA2X05GX01BVENIX0lQVjZIRUFERVI9bQpDT05GSUdfSVA2X05G
X01BVENIX01IPW0KIyBDT05GSUdfSVA2X05GX01BVENIX1JQRklMVEVSIGlzIG5vdCBzZXQK
Q09ORklHX0lQNl9ORl9NQVRDSF9SVD1tCkNPTkZJR19JUDZfTkZfVEFSR0VUX0hMPW0KQ09O
RklHX0lQNl9ORl9GSUxURVI9bQpDT05GSUdfSVA2X05GX1RBUkdFVF9SRUpFQ1Q9bQpDT05G
SUdfSVA2X05GX01BTkdMRT1tCkNPTkZJR19JUDZfTkZfUkFXPW0KQ09ORklHX0lQNl9ORl9T
RUNVUklUWT1tCiMgQ09ORklHX05GX05BVF9JUFY2IGlzIG5vdCBzZXQKCiMKIyBERUNuZXQ6
IE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKQ09ORklHX0RFQ05FVF9ORl9HUkFCVUxBVE9S
PW0KQ09ORklHX0JSSURHRV9ORl9FQlRBQkxFUz1tCkNPTkZJR19CUklER0VfRUJUX0JST1VU
RT1tCkNPTkZJR19CUklER0VfRUJUX1RfRklMVEVSPW0KQ09ORklHX0JSSURHRV9FQlRfVF9O
QVQ9bQpDT05GSUdfQlJJREdFX0VCVF84MDJfMz1tCkNPTkZJR19CUklER0VfRUJUX0FNT05H
PW0KQ09ORklHX0JSSURHRV9FQlRfQVJQPW0KQ09ORklHX0JSSURHRV9FQlRfSVA9bQpDT05G
SUdfQlJJREdFX0VCVF9JUDY9bQpDT05GSUdfQlJJREdFX0VCVF9MSU1JVD1tCkNPTkZJR19C
UklER0VfRUJUX01BUks9bQpDT05GSUdfQlJJREdFX0VCVF9QS1RUWVBFPW0KQ09ORklHX0JS
SURHRV9FQlRfU1RQPW0KQ09ORklHX0JSSURHRV9FQlRfVkxBTj1tCkNPTkZJR19CUklER0Vf
RUJUX0FSUFJFUExZPW0KQ09ORklHX0JSSURHRV9FQlRfRE5BVD1tCkNPTkZJR19CUklER0Vf
RUJUX01BUktfVD1tCkNPTkZJR19CUklER0VfRUJUX1JFRElSRUNUPW0KQ09ORklHX0JSSURH
RV9FQlRfU05BVD1tCkNPTkZJR19CUklER0VfRUJUX0xPRz1tCkNPTkZJR19CUklER0VfRUJU
X1VMT0c9bQpDT05GSUdfQlJJREdFX0VCVF9ORkxPRz1tCkNPTkZJR19JUF9EQ0NQPW0KQ09O
RklHX0lORVRfRENDUF9ESUFHPW0KCiMKIyBEQ0NQIENDSURzIENvbmZpZ3VyYXRpb24gKEVY
UEVSSU1FTlRBTCkKIwojIENPTkZJR19JUF9EQ0NQX0NDSUQyX0RFQlVHIGlzIG5vdCBzZXQK
Q09ORklHX0lQX0RDQ1BfQ0NJRDM9eQojIENPTkZJR19JUF9EQ0NQX0NDSUQzX0RFQlVHIGlz
IG5vdCBzZXQKQ09ORklHX0lQX0RDQ1BfVEZSQ19MSUI9eQoKIwojIERDQ1AgS2VybmVsIEhh
Y2tpbmcKIwojIENPTkZJR19JUF9EQ0NQX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX05FVF9E
Q0NQUFJPQkU9bQpDT05GSUdfSVBfU0NUUD1tCkNPTkZJR19ORVRfU0NUUFBST0JFPW0KIyBD
T05GSUdfU0NUUF9EQkdfTVNHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9EQkdfT0JKQ05U
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9ITUFDX05PTkUgaXMgbm90IHNldAojIENPTkZJ
R19TQ1RQX0hNQUNfU0hBMSBpcyBub3Qgc2V0CkNPTkZJR19TQ1RQX0hNQUNfTUQ1PXkKQ09O
RklHX1JEUz1tCkNPTkZJR19SRFNfUkRNQT1tCkNPTkZJR19SRFNfVENQPW0KIyBDT05GSUdf
UkRTX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1RJUEM9bQpDT05GSUdfVElQQ19BRFZBTkNF
RD15CkNPTkZJR19USVBDX1BPUlRTPTgxOTEKQ09ORklHX0FUTT1tCkNPTkZJR19BVE1fQ0xJ
UD1tCiMgQ09ORklHX0FUTV9DTElQX05PX0lDTVAgaXMgbm90IHNldApDT05GSUdfQVRNX0xB
TkU9bQpDT05GSUdfQVRNX01QT0E9bQpDT05GSUdfQVRNX0JSMjY4ND1tCiMgQ09ORklHX0FU
TV9CUjI2ODRfSVBGSUxURVIgaXMgbm90IHNldApDT05GSUdfTDJUUD1tCkNPTkZJR19MMlRQ
X0RFQlVHRlM9bQpDT05GSUdfTDJUUF9WMz15CkNPTkZJR19MMlRQX0lQPW0KQ09ORklHX0wy
VFBfRVRIPW0KQ09ORklHX1NUUD1tCkNPTkZJR19HQVJQPW0KQ09ORklHX0JSSURHRT1tCkNP
TkZJR19CUklER0VfSUdNUF9TTk9PUElORz15CiMgQ09ORklHX05FVF9EU0EgaXMgbm90IHNl
dApDT05GSUdfVkxBTl84MDIxUT1tCkNPTkZJR19WTEFOXzgwMjFRX0dWUlA9eQpDT05GSUdf
REVDTkVUPW0KIyBDT05GSUdfREVDTkVUX1JPVVRFUiBpcyBub3Qgc2V0CkNPTkZJR19MTEM9
bQpDT05GSUdfTExDMj1tCkNPTkZJR19JUFg9bQojIENPTkZJR19JUFhfSU5URVJOIGlzIG5v
dCBzZXQKQ09ORklHX0FUQUxLPW0KQ09ORklHX0RFVl9BUFBMRVRBTEs9bQpDT05GSUdfSVBE
RFA9bQpDT05GSUdfSVBERFBfRU5DQVA9eQpDT05GSUdfSVBERFBfREVDQVA9eQojIENPTkZJ
R19YMjUgaXMgbm90IHNldApDT05GSUdfTEFQQj1tCkNPTkZJR19XQU5fUk9VVEVSPW0KQ09O
RklHX1BIT05FVD1tCkNPTkZJR19JRUVFODAyMTU0PW0KQ09ORklHX0lFRUU4MDIxNTRfNkxP
V1BBTj1tCiMgQ09ORklHX01BQzgwMjE1NCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfU0NIRUQ9
eQoKIwojIFF1ZXVlaW5nL1NjaGVkdWxpbmcKIwpDT05GSUdfTkVUX1NDSF9DQlE9bQpDT05G
SUdfTkVUX1NDSF9IVEI9bQpDT05GSUdfTkVUX1NDSF9IRlNDPW0KQ09ORklHX05FVF9TQ0hf
QVRNPW0KQ09ORklHX05FVF9TQ0hfUFJJTz1tCkNPTkZJR19ORVRfU0NIX01VTFRJUT1tCkNP
TkZJR19ORVRfU0NIX1JFRD1tCkNPTkZJR19ORVRfU0NIX1NGQj1tCkNPTkZJR19ORVRfU0NI
X1NGUT1tCkNPTkZJR19ORVRfU0NIX1RFUUw9bQpDT05GSUdfTkVUX1NDSF9UQkY9bQpDT05G
SUdfTkVUX1NDSF9HUkVEPW0KQ09ORklHX05FVF9TQ0hfRFNNQVJLPW0KQ09ORklHX05FVF9T
Q0hfTkVURU09bQpDT05GSUdfTkVUX1NDSF9EUlI9bQpDT05GSUdfTkVUX1NDSF9NUVBSSU89
bQpDT05GSUdfTkVUX1NDSF9DSE9LRT1tCkNPTkZJR19ORVRfU0NIX1FGUT1tCkNPTkZJR19O
RVRfU0NIX0NPREVMPW0KQ09ORklHX05FVF9TQ0hfRlFfQ09ERUw9bQpDT05GSUdfTkVUX1ND
SF9JTkdSRVNTPW0KIyBDT05GSUdfTkVUX1NDSF9QTFVHIGlzIG5vdCBzZXQKCiMKIyBDbGFz
c2lmaWNhdGlvbgojCkNPTkZJR19ORVRfQ0xTPXkKQ09ORklHX05FVF9DTFNfQkFTSUM9bQpD
T05GSUdfTkVUX0NMU19UQ0lOREVYPW0KQ09ORklHX05FVF9DTFNfUk9VVEU0PW0KQ09ORklH
X05FVF9DTFNfRlc9bQpDT05GSUdfTkVUX0NMU19VMzI9bQpDT05GSUdfQ0xTX1UzMl9QRVJG
PXkKQ09ORklHX0NMU19VMzJfTUFSSz15CkNPTkZJR19ORVRfQ0xTX1JTVlA9bQpDT05GSUdf
TkVUX0NMU19SU1ZQNj1tCkNPTkZJR19ORVRfQ0xTX0ZMT1c9bQpDT05GSUdfTkVUX0NMU19D
R1JPVVA9eQpDT05GSUdfTkVUX0VNQVRDSD15CkNPTkZJR19ORVRfRU1BVENIX1NUQUNLPTMy
CkNPTkZJR19ORVRfRU1BVENIX0NNUD1tCkNPTkZJR19ORVRfRU1BVENIX05CWVRFPW0KQ09O
RklHX05FVF9FTUFUQ0hfVTMyPW0KQ09ORklHX05FVF9FTUFUQ0hfTUVUQT1tCkNPTkZJR19O
RVRfRU1BVENIX1RFWFQ9bQojIENPTkZJR19ORVRfRU1BVENIX0NBTklEIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX0VNQVRDSF9JUFNFVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfQ0xTX0FD
VD15CkNPTkZJR19ORVRfQUNUX1BPTElDRT1tCkNPTkZJR19ORVRfQUNUX0dBQ1Q9bQpDT05G
SUdfR0FDVF9QUk9CPXkKQ09ORklHX05FVF9BQ1RfTUlSUkVEPW0KQ09ORklHX05FVF9BQ1Rf
SVBUPW0KQ09ORklHX05FVF9BQ1RfTkFUPW0KQ09ORklHX05FVF9BQ1RfUEVESVQ9bQpDT05G
SUdfTkVUX0FDVF9TSU1QPW0KQ09ORklHX05FVF9BQ1RfU0tCRURJVD1tCkNPTkZJR19ORVRf
QUNUX0NTVU09bQpDT05GSUdfTkVUX0NMU19JTkQ9eQpDT05GSUdfTkVUX1NDSF9GSUZPPXkK
Q09ORklHX0RDQj15CkNPTkZJR19ETlNfUkVTT0xWRVI9eQpDT05GSUdfQkFUTUFOX0FEVj1t
CkNPTkZJR19CQVRNQU5fQURWX0JMQT15CiMgQ09ORklHX0JBVE1BTl9BRFZfREVCVUcgaXMg
bm90IHNldAojIENPTkZJR19PUEVOVlNXSVRDSCBpcyBub3Qgc2V0CkNPTkZJR19SUFM9eQpD
T05GSUdfUkZTX0FDQ0VMPXkKQ09ORklHX1hQUz15CiMgQ09ORklHX05FVFBSSU9fQ0dST1VQ
IGlzIG5vdCBzZXQKQ09ORklHX0JRTD15CkNPTkZJR19CUEZfSklUPXkKCiMKIyBOZXR3b3Jr
IHRlc3RpbmcKIwpDT05GSUdfTkVUX1BLVEdFTj1tCiMgQ09ORklHX05FVF9UQ1BQUk9CRSBp
cyBub3Qgc2V0CkNPTkZJR19ORVRfRFJPUF9NT05JVE9SPXkKQ09ORklHX0hBTVJBRElPPXkK
CiMKIyBQYWNrZXQgUmFkaW8gcHJvdG9jb2xzCiMKQ09ORklHX0FYMjU9bQojIENPTkZJR19B
WDI1X0RBTUFfU0xBVkUgaXMgbm90IHNldApDT05GSUdfTkVUUk9NPW0KQ09ORklHX1JPU0U9
bQoKIwojIEFYLjI1IG5ldHdvcmsgZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfTUtJU1M9bQpD
T05GSUdfNlBBQ0s9bQpDT05GSUdfQlBRRVRIRVI9bQpDT05GSUdfQkFZQ09NX1NFUl9GRFg9
bQpDT05GSUdfQkFZQ09NX1NFUl9IRFg9bQpDT05GSUdfWUFNPW0KQ09ORklHX0NBTj1tCkNP
TkZJR19DQU5fUkFXPW0KQ09ORklHX0NBTl9CQ009bQpDT05GSUdfQ0FOX0dXPW0KCiMKIyBD
QU4gRGV2aWNlIERyaXZlcnMKIwpDT05GSUdfQ0FOX1ZDQU49bQpDT05GSUdfQ0FOX1NMQ0FO
PW0KQ09ORklHX0NBTl9ERVY9bQpDT05GSUdfQ0FOX0NBTENfQklUVElNSU5HPXkKQ09ORklH
X0NBTl9NQ1AyNTFYPW0KQ09ORklHX1BDSF9DQU49bQpDT05GSUdfQ0FOX1NKQTEwMDA9bQoj
IENPTkZJR19DQU5fU0pBMTAwMF9JU0EgaXMgbm90IHNldAojIENPTkZJR19DQU5fU0pBMTAw
MF9QTEFURk9STSBpcyBub3Qgc2V0CkNPTkZJR19DQU5fRU1TX1BDST1tCkNPTkZJR19DQU5f
UEVBS19QQ0k9bQpDT05GSUdfQ0FOX1BFQUtfUENJRUM9eQpDT05GSUdfQ0FOX0tWQVNFUl9Q
Q0k9bQpDT05GSUdfQ0FOX1BMWF9QQ0k9bQojIENPTkZJR19DQU5fQ19DQU4gaXMgbm90IHNl
dAojIENPTkZJR19DQU5fQ0M3NzAgaXMgbm90IHNldAoKIwojIENBTiBVU0IgaW50ZXJmYWNl
cwojCkNPTkZJR19DQU5fRU1TX1VTQj1tCkNPTkZJR19DQU5fRVNEX1VTQjI9bQojIENPTkZJ
R19DQU5fUEVBS19VU0IgaXMgbm90IHNldApDT05GSUdfQ0FOX1NPRlRJTkc9bQojIENPTkZJ
R19DQU5fREVCVUdfREVWSUNFUyBpcyBub3Qgc2V0CkNPTkZJR19JUkRBPW0KCiMKIyBJckRB
IHByb3RvY29scwojCkNPTkZJR19JUkxBTj1tCkNPTkZJR19JUk5FVD1tCkNPTkZJR19JUkNP
TU09bQojIENPTkZJR19JUkRBX1VMVFJBIGlzIG5vdCBzZXQKCiMKIyBJckRBIG9wdGlvbnMK
IwpDT05GSUdfSVJEQV9DQUNIRV9MQVNUX0xTQVA9eQpDT05GSUdfSVJEQV9GQVNUX1JSPXkK
IyBDT05GSUdfSVJEQV9ERUJVRyBpcyBub3Qgc2V0CgojCiMgSW5mcmFyZWQtcG9ydCBkZXZp
Y2UgZHJpdmVycwojCgojCiMgU0lSIGRldmljZSBkcml2ZXJzCiMKQ09ORklHX0lSVFRZX1NJ
Uj1tCgojCiMgRG9uZ2xlIHN1cHBvcnQKIwpDT05GSUdfRE9OR0xFPXkKQ09ORklHX0VTSV9E
T05HTEU9bQpDT05GSUdfQUNUSVNZU19ET05HTEU9bQpDT05GSUdfVEVLUkFNX0RPTkdMRT1t
CkNPTkZJR19UT0lNMzIzMl9ET05HTEU9bQpDT05GSUdfTElURUxJTktfRE9OR0xFPW0KQ09O
RklHX01BNjAwX0RPTkdMRT1tCkNPTkZJR19HSVJCSUxfRE9OR0xFPW0KQ09ORklHX01DUDIx
MjBfRE9OR0xFPW0KQ09ORklHX09MRF9CRUxLSU5fRE9OR0xFPW0KQ09ORklHX0FDVDIwMExf
RE9OR0xFPW0KQ09ORklHX0tJTkdTVU5fRE9OR0xFPW0KQ09ORklHX0tTREFaWkxFX0RPTkdM
RT1tCkNPTkZJR19LUzk1OV9ET05HTEU9bQoKIwojIEZJUiBkZXZpY2UgZHJpdmVycwojCkNP
TkZJR19VU0JfSVJEQT1tCkNPTkZJR19TSUdNQVRFTF9GSVI9bQpDT05GSUdfTlNDX0ZJUj1t
CkNPTkZJR19XSU5CT05EX0ZJUj1tCkNPTkZJR19TTUNfSVJDQ19GSVI9bQpDT05GSUdfQUxJ
X0ZJUj1tCkNPTkZJR19WTFNJX0ZJUj1tCkNPTkZJR19WSUFfRklSPW0KQ09ORklHX01DU19G
SVI9bQpDT05GSUdfQlQ9bQpDT05GSUdfQlRfUkZDT01NPW0KQ09ORklHX0JUX1JGQ09NTV9U
VFk9eQpDT05GSUdfQlRfQk5FUD1tCkNPTkZJR19CVF9CTkVQX01DX0ZJTFRFUj15CkNPTkZJ
R19CVF9CTkVQX1BST1RPX0ZJTFRFUj15CkNPTkZJR19CVF9DTVRQPW0KQ09ORklHX0JUX0hJ
RFA9bQoKIwojIEJsdWV0b290aCBkZXZpY2UgZHJpdmVycwojCkNPTkZJR19CVF9IQ0lCVFVT
Qj1tCkNPTkZJR19CVF9IQ0lCVFNESU89bQpDT05GSUdfQlRfSENJVUFSVD1tCkNPTkZJR19C
VF9IQ0lVQVJUX0g0PXkKQ09ORklHX0JUX0hDSVVBUlRfQkNTUD15CkNPTkZJR19CVF9IQ0lV
QVJUX0FUSDNLPXkKQ09ORklHX0JUX0hDSVVBUlRfTEw9eQpDT05GSUdfQlRfSENJVUFSVF8z
V0lSRT15CkNPTkZJR19CVF9IQ0lCQ00yMDNYPW0KQ09ORklHX0JUX0hDSUJQQTEwWD1tCkNP
TkZJR19CVF9IQ0lCRlVTQj1tCkNPTkZJR19CVF9IQ0lWSENJPW0KQ09ORklHX0JUX01SVkw9
bQpDT05GSUdfQlRfTVJWTF9TRElPPW0KQ09ORklHX0JUX0FUSDNLPW0KQ09ORklHX0FGX1JY
UlBDPW0KIyBDT05GSUdfQUZfUlhSUENfREVCVUcgaXMgbm90IHNldApDT05GSUdfUlhLQUQ9
bQpDT05GSUdfRklCX1JVTEVTPXkKQ09ORklHX1dJUkVMRVNTPXkKQ09ORklHX1dJUkVMRVNT
X0VYVD15CkNPTkZJR19XRVhUX0NPUkU9eQpDT05GSUdfV0VYVF9QUk9DPXkKQ09ORklHX1dF
WFRfU1BZPXkKQ09ORklHX1dFWFRfUFJJVj15CkNPTkZJR19DRkc4MDIxMT1tCiMgQ09ORklH
X05MODAyMTFfVEVTVE1PREUgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9ERVZFTE9Q
RVJfV0FSTklOR1MgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9SRUdfREVCVUcgaXMg
bm90IHNldApDT05GSUdfQ0ZHODAyMTFfREVGQVVMVF9QUz15CiMgQ09ORklHX0NGRzgwMjEx
X0RFQlVHRlMgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9JTlRFUk5BTF9SRUdEQiBp
cyBub3Qgc2V0CkNPTkZJR19DRkc4MDIxMV9XRVhUPXkKQ09ORklHX0xJQjgwMjExPW0KQ09O
RklHX0xJQjgwMjExX0NSWVBUX1dFUD1tCkNPTkZJR19MSUI4MDIxMV9DUllQVF9DQ01QPW0K
Q09ORklHX0xJQjgwMjExX0NSWVBUX1RLSVA9bQojIENPTkZJR19MSUI4MDIxMV9ERUJVRyBp
cyBub3Qgc2V0CkNPTkZJR19NQUM4MDIxMT1tCkNPTkZJR19NQUM4MDIxMV9IQVNfUkM9eQpD
T05GSUdfTUFDODAyMTFfUkNfTUlOU1RSRUw9eQpDT05GSUdfTUFDODAyMTFfUkNfTUlOU1RS
RUxfSFQ9eQpDT05GSUdfTUFDODAyMTFfUkNfREVGQVVMVF9NSU5TVFJFTD15CkNPTkZJR19N
QUM4MDIxMV9SQ19ERUZBVUxUPSJtaW5zdHJlbF9odCIKQ09ORklHX01BQzgwMjExX01FU0g9
eQpDT05GSUdfTUFDODAyMTFfTEVEUz15CiMgQ09ORklHX01BQzgwMjExX0RFQlVHRlMgaXMg
bm90IHNldAojIENPTkZJR19NQUM4MDIxMV9NRVNTQUdFX1RSQUNJTkcgaXMgbm90IHNldAoj
IENPTkZJR19NQUM4MDIxMV9ERUJVR19NRU5VIGlzIG5vdCBzZXQKQ09ORklHX1dJTUFYPW0K
Q09ORklHX1dJTUFYX0RFQlVHX0xFVkVMPTgKQ09ORklHX1JGS0lMTD1tCkNPTkZJR19SRktJ
TExfTEVEUz15CkNPTkZJR19SRktJTExfSU5QVVQ9eQojIENPTkZJR19SRktJTExfUkVHVUxB
VE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUXzlQIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FJ
RiBpcyBub3Qgc2V0CkNPTkZJR19DRVBIX0xJQj1tCiMgQ09ORklHX0NFUEhfTElCX1BSRVRU
WURFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0VQSF9MSUJfVVNFX0ROU19SRVNPTFZFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX05GQyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0JQRl9KSVQ9
eQoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5lcmljIERyaXZlciBPcHRpb25zCiMK
Q09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iIgpDT05GSUdfREVWVE1QRlM9eQojIENPTkZJ
R19ERVZUTVBGU19NT1VOVCBpcyBub3Qgc2V0CkNPTkZJR19TVEFOREFMT05FPXkKQ09ORklH
X1BSRVZFTlRfRklSTVdBUkVfQlVJTEQ9eQpDT05GSUdfRldfTE9BREVSPXkKIyBDT05GSUdf
RklSTVdBUkVfSU5fS0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0VYVFJBX0ZJUk1XQVJFPSIi
CiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0RFVlJF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKIyBDT05G
SUdfR0VORVJJQ19DUFVfREVWSUNFUyBpcyBub3Qgc2V0CkNPTkZJR19SRUdNQVA9eQpDT05G
SUdfUkVHTUFQX0kyQz1tCkNPTkZJR19SRUdNQVBfU1BJPW0KQ09ORklHX0RNQV9TSEFSRURf
QlVGRkVSPXkKCiMKIyBCdXMgZGV2aWNlcwojCiMgQ09ORklHX09NQVBfT0NQMlNDUCBpcyBu
b3Qgc2V0CkNPTkZJR19DT05ORUNUT1I9bQpDT05GSUdfTVREPW0KIyBDT05GSUdfTVREX1RF
U1RTIGlzIG5vdCBzZXQKQ09ORklHX01URF9SRURCT09UX1BBUlRTPW0KQ09ORklHX01URF9S
RURCT09UX0RJUkVDVE9SWV9CTE9DSz0tMQojIENPTkZJR19NVERfUkVEQk9PVF9QQVJUU19V
TkFMTE9DQVRFRCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9SRURCT09UX1BBUlRTX1JFQURP
TkxZIGlzIG5vdCBzZXQKQ09ORklHX01URF9BUjdfUEFSVFM9bQoKIwojIFVzZXIgTW9kdWxl
cyBBbmQgVHJhbnNsYXRpb24gTGF5ZXJzCiMKQ09ORklHX01URF9DSEFSPW0KQ09ORklHX01U
RF9CTEtERVZTPW0KQ09ORklHX01URF9CTE9DSz1tCkNPTkZJR19NVERfQkxPQ0tfUk89bQpD
T05GSUdfRlRMPW0KQ09ORklHX05GVEw9bQpDT05GSUdfTkZUTF9SVz15CkNPTkZJR19JTkZU
TD1tCkNPTkZJR19SRkRfRlRMPW0KQ09ORklHX1NTRkRDPW0KIyBDT05GSUdfU01fRlRMIGlz
IG5vdCBzZXQKQ09ORklHX01URF9PT1BTPW0KQ09ORklHX01URF9TV0FQPW0KCiMKIyBSQU0v
Uk9NL0ZsYXNoIGNoaXAgZHJpdmVycwojCkNPTkZJR19NVERfQ0ZJPW0KQ09ORklHX01URF9K
RURFQ1BST0JFPW0KQ09ORklHX01URF9HRU5fUFJPQkU9bQojIENPTkZJR19NVERfQ0ZJX0FE
Vl9PUFRJT05TIGlzIG5vdCBzZXQKQ09ORklHX01URF9NQVBfQkFOS19XSURUSF8xPXkKQ09O
RklHX01URF9NQVBfQkFOS19XSURUSF8yPXkKQ09ORklHX01URF9NQVBfQkFOS19XSURUSF80
PXkKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzggaXMgbm90IHNldAojIENPTkZJR19N
VERfTUFQX0JBTktfV0lEVEhfMTYgaXMgbm90IHNldAojIENPTkZJR19NVERfTUFQX0JBTktf
V0lEVEhfMzIgaXMgbm90IHNldApDT05GSUdfTVREX0NGSV9JMT15CkNPTkZJR19NVERfQ0ZJ
X0kyPXkKIyBDT05GSUdfTVREX0NGSV9JNCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9DRklf
STggaXMgbm90IHNldApDT05GSUdfTVREX0NGSV9JTlRFTEVYVD1tCkNPTkZJR19NVERfQ0ZJ
X0FNRFNURD1tCkNPTkZJR19NVERfQ0ZJX1NUQUE9bQpDT05GSUdfTVREX0NGSV9VVElMPW0K
Q09ORklHX01URF9SQU09bQpDT05GSUdfTVREX1JPTT1tCkNPTkZJR19NVERfQUJTRU5UPW0K
CiMKIyBNYXBwaW5nIGRyaXZlcnMgZm9yIGNoaXAgYWNjZXNzCiMKQ09ORklHX01URF9DT01Q
TEVYX01BUFBJTkdTPXkKQ09ORklHX01URF9QSFlTTUFQPW0KIyBDT05GSUdfTVREX1BIWVNN
QVBfQ09NUEFUIGlzIG5vdCBzZXQKQ09ORklHX01URF9TQzUyMENEUD1tCkNPTkZJR19NVERf
TkVUU0M1MjA9bQpDT05GSUdfTVREX1RTNTUwMD1tCkNPTkZJR19NVERfU0JDX0dYWD1tCiMg
Q09ORklHX01URF9BTUQ3NlhST00gaXMgbm90IHNldAojIENPTkZJR19NVERfSUNIWFJPTSBp
cyBub3Qgc2V0CiMgQ09ORklHX01URF9FU0IyUk9NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRE
X0NLODA0WFJPTSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9TQ0IyX0ZMQVNIIGlzIG5vdCBz
ZXQKQ09ORklHX01URF9ORVR0ZWw9bQojIENPTkZJR19NVERfTDQ0MEdYIGlzIG5vdCBzZXQK
Q09ORklHX01URF9QQ0k9bQojIENPTkZJR19NVERfR1BJT19BRERSIGlzIG5vdCBzZXQKQ09O
RklHX01URF9JTlRFTF9WUl9OT1I9bQpDT05GSUdfTVREX1BMQVRSQU09bQojIENPTkZJR19N
VERfTEFUQ0hfQUREUiBpcyBub3Qgc2V0CgojCiMgU2VsZi1jb250YWluZWQgTVREIGRldmlj
ZSBkcml2ZXJzCiMKQ09ORklHX01URF9QTUM1NTE9bQojIENPTkZJR19NVERfUE1DNTUxX0JV
R0ZJWCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9QTUM1NTFfREVCVUcgaXMgbm90IHNldApD
T05GSUdfTVREX0RBVEFGTEFTSD1tCiMgQ09ORklHX01URF9EQVRBRkxBU0hfV1JJVEVfVkVS
SUZZIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0RBVEFGTEFTSF9PVFAgaXMgbm90IHNldApD
T05GSUdfTVREX00yNVA4MD1tCkNPTkZJR19NMjVQWFhfVVNFX0ZBU1RfUkVBRD15CkNPTkZJ
R19NVERfU1NUMjVMPW0KQ09ORklHX01URF9TTFJBTT1tCkNPTkZJR19NVERfUEhSQU09bQpD
T05GSUdfTVREX01URFJBTT1tCkNPTkZJR19NVERSQU1fVE9UQUxfU0laRT00MDk2CkNPTkZJ
R19NVERSQU1fRVJBU0VfU0laRT0xMjgKQ09ORklHX01URF9CTE9DSzJNVEQ9bQoKIwojIERp
c2stT24tQ2hpcCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19NVERfRE9DMjAwMD1tCkNPTkZJ
R19NVERfRE9DMjAwMT1tCkNPTkZJR19NVERfRE9DMjAwMVBMVVM9bQojIENPTkZJR19NVERf
RE9DRzMgaXMgbm90IHNldApDT05GSUdfTVREX0RPQ1BST0JFPW0KQ09ORklHX01URF9ET0NF
Q0M9bQojIENPTkZJR19NVERfRE9DUFJPQkVfQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdf
TVREX0RPQ1BST0JFX0FERFJFU1M9MHgwCkNPTkZJR19NVERfTkFORF9FQ0M9bQojIENPTkZJ
R19NVERfTkFORF9FQ0NfU01DIGlzIG5vdCBzZXQKQ09ORklHX01URF9OQU5EPW0KIyBDT05G
SUdfTVREX05BTkRfRUNDX0JDSCBpcyBub3Qgc2V0CkNPTkZJR19NVERfU01fQ09NTU9OPW0K
IyBDT05GSUdfTVREX05BTkRfTVVTRVVNX0lEUyBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9O
QU5EX0RFTkFMSSBpcyBub3Qgc2V0CkNPTkZJR19NVERfTkFORF9JRFM9bQpDT05GSUdfTVRE
X05BTkRfUklDT0g9bQpDT05GSUdfTVREX05BTkRfRElTS09OQ0hJUD1tCiMgQ09ORklHX01U
RF9OQU5EX0RJU0tPTkNISVBfUFJPQkVfQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdfTVRE
X05BTkRfRElTS09OQ0hJUF9QUk9CRV9BRERSRVNTPTAKIyBDT05GSUdfTVREX05BTkRfRElT
S09OQ0hJUF9CQlRXUklURSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9OQU5EX0RPQ0c0IGlz
IG5vdCBzZXQKQ09ORklHX01URF9OQU5EX0NBRkU9bQpDT05GSUdfTVREX05BTkRfTkFORFNJ
TT1tCkNPTkZJR19NVERfTkFORF9QTEFURk9STT1tCkNPTkZJR19NVERfQUxBVURBPW0KQ09O
RklHX01URF9PTkVOQU5EPW0KQ09ORklHX01URF9PTkVOQU5EX1ZFUklGWV9XUklURT15CkNP
TkZJR19NVERfT05FTkFORF9HRU5FUklDPW0KIyBDT05GSUdfTVREX09ORU5BTkRfT1RQIGlz
IG5vdCBzZXQKQ09ORklHX01URF9PTkVOQU5EXzJYX1BST0dSQU09eQpDT05GSUdfTVREX09O
RU5BTkRfU0lNPW0KCiMKIyBMUEREUiBmbGFzaCBtZW1vcnkgZHJpdmVycwojCkNPTkZJR19N
VERfTFBERFI9bQpDT05GSUdfTVREX1FJTkZPX1BST0JFPW0KQ09ORklHX01URF9VQkk9bQpD
T05GSUdfTVREX1VCSV9XTF9USFJFU0hPTEQ9NDA5NgpDT05GSUdfTVREX1VCSV9CRUJfTElN
SVQ9MjAKIyBDT05GSUdfTVREX1VCSV9GQVNUTUFQIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRE
X1VCSV9HTFVFQkkgaXMgbm90IHNldAojIENPTkZJR19QQVJQT1JUIGlzIG5vdCBzZXQKQ09O
RklHX1BOUD15CiMgQ09ORklHX1BOUF9ERUJVR19NRVNTQUdFUyBpcyBub3Qgc2V0CgojCiMg
UHJvdG9jb2xzCiMKQ09ORklHX1BOUEFDUEk9eQpDT05GSUdfQkxLX0RFVj15CiMgQ09ORklH
X0JMS19ERVZfRkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1BDSUVTU0RfTVRJUDMy
WFggaXMgbm90IHNldAojIENPTkZJR19CTEtfQ1BRX0RBIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkxLX0NQUV9DSVNTX0RBIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9EQUM5NjAgaXMg
bm90IHNldAojIENPTkZJR19CTEtfREVWX1VNRU0gaXMgbm90IHNldAojIENPTkZJR19CTEtf
REVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9MT09QPW0KQ09ORklH
X0JMS19ERVZfTE9PUF9NSU5fQ09VTlQ9OAojIENPTkZJR19CTEtfREVWX0NSWVBUT0xPT1Ag
aXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9EUkJEPW0KIyBDT05GSUdfRFJCRF9GQVVMVF9J
TkpFQ1RJT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9OQkQ9bQojIENPTkZJR19CTEtf
REVWX05WTUUgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX09TRCBpcyBub3Qgc2V0CiMg
Q09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfUkFNPW0KQ09O
RklHX0JMS19ERVZfUkFNX0NPVU5UPTE2CkNPTkZJR19CTEtfREVWX1JBTV9TSVpFPTY1NTM2
CiMgQ09ORklHX0JMS19ERVZfWElQIGlzIG5vdCBzZXQKQ09ORklHX0NEUk9NX1BLVENEVkQ9
bQpDT05GSUdfQ0RST01fUEtUQ0RWRF9CVUZGRVJTPTgKIyBDT05GSUdfQ0RST01fUEtUQ0RW
RF9XQ0FDSEUgaXMgbm90IHNldAojIENPTkZJR19BVEFfT1ZFUl9FVEggaXMgbm90IHNldApD
T05GSUdfVklSVElPX0JMSz1tCiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldAojIENP
TkZJR19CTEtfREVWX1JCRCBpcyBub3Qgc2V0CgojCiMgTWlzYyBkZXZpY2VzCiMKQ09ORklH
X1NFTlNPUlNfTElTM0xWMDJEPW0KQ09ORklHX0FENTI1WF9EUE9UPW0KQ09ORklHX0FENTI1
WF9EUE9UX0kyQz1tCkNPTkZJR19BRDUyNVhfRFBPVF9TUEk9bQpDT05GSUdfSUJNX0FTTT1t
CkNPTkZJR19QSEFOVE9NPW0KIyBDT05GSUdfSU5URUxfTUlEX1BUSSBpcyBub3Qgc2V0CkNP
TkZJR19TR0lfSU9DND1tCkNPTkZJR19USUZNX0NPUkU9bQpDT05GSUdfVElGTV83WFgxPW0K
Q09ORklHX0lDUzkzMlM0MDE9bQpDT05GSUdfRU5DTE9TVVJFX1NFUlZJQ0VTPW0KQ09ORklH
X0hQX0lMTz1tCkNPTkZJR19BUERTOTgwMkFMUz1tCkNPTkZJR19JU0wyOTAwMz1tCkNPTkZJ
R19JU0wyOTAyMD1tCkNPTkZJR19TRU5TT1JTX1RTTDI1NTA9bQpDT05GSUdfU0VOU09SU19C
SDE3ODA9bQpDT05GSUdfU0VOU09SU19CSDE3NzA9bQpDT05GSUdfU0VOU09SU19BUERTOTkw
WD1tCkNPTkZJR19ITUM2MzUyPW0KQ09ORklHX0RTMTY4Mj1tCkNPTkZJR19USV9EQUM3NTEy
PW0KQ09ORklHX1ZNV0FSRV9CQUxMT09OPW0KQ09ORklHX0JNUDA4NT15CiMgQ09ORklHX0JN
UDA4NV9JMkMgaXMgbm90IHNldApDT05GSUdfQk1QMDg1X1NQST1tCkNPTkZJR19QQ0hfUEhV
Qj1tCiMgQ09ORklHX1VTQl9TV0lUQ0hfRlNBOTQ4MCBpcyBub3Qgc2V0CkNPTkZJR19DMlBP
UlQ9bQpDT05GSUdfQzJQT1JUX0RVUkFNQVJfMjE1MD1tCgojCiMgRUVQUk9NIHN1cHBvcnQK
IwpDT05GSUdfRUVQUk9NX0FUMjQ9bQpDT05GSUdfRUVQUk9NX0FUMjU9bQpDT05GSUdfRUVQ
Uk9NX0xFR0FDWT1tCkNPTkZJR19FRVBST01fTUFYNjg3NT1tCkNPTkZJR19FRVBST01fOTND
WDY9bQojIENPTkZJR19FRVBST01fOTNYWDQ2IGlzIG5vdCBzZXQKQ09ORklHX0NCNzEwX0NP
UkU9bQojIENPTkZJR19DQjcxMF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19DQjcxMF9ERUJV
R19BU1NVTVBUSU9OUz15CgojCiMgVGV4YXMgSW5zdHJ1bWVudHMgc2hhcmVkIHRyYW5zcG9y
dCBsaW5lIGRpc2NpcGxpbmUKIwojIENPTkZJR19USV9TVCBpcyBub3Qgc2V0CkNPTkZJR19T
RU5TT1JTX0xJUzNfSTJDPW0KCiMKIyBBbHRlcmEgRlBHQSBmaXJtd2FyZSBkb3dubG9hZCBt
b2R1bGUKIwpDT05GSUdfQUxURVJBX1NUQVBMPW0KQ09ORklHX0lOVEVMX01FST1tCkNPTkZJ
R19IQVZFX0lERT15CiMgQ09ORklHX0lERSBpcyBub3Qgc2V0CgojCiMgU0NTSSBkZXZpY2Ug
c3VwcG9ydAojCkNPTkZJR19TQ1NJX01PRD15CkNPTkZJR19SQUlEX0FUVFJTPW0KQ09ORklH
X1NDU0k9eQpDT05GSUdfU0NTSV9ETUE9eQpDT05GSUdfU0NTSV9UR1Q9bQpDT05GSUdfU0NT
SV9ORVRMSU5LPXkKIyBDT05GSUdfU0NTSV9QUk9DX0ZTIGlzIG5vdCBzZXQKCiMKIyBTQ1NJ
IHN1cHBvcnQgdHlwZSAoZGlzaywgdGFwZSwgQ0QtUk9NKQojCkNPTkZJR19CTEtfREVWX1NE
PXkKIyBDT05GSUdfQ0hSX0RFVl9TVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NIUl9ERVZfT1NT
VCBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1NSPW0KQ09ORklHX0JMS19ERVZfU1JfVkVO
RE9SPXkKQ09ORklHX0NIUl9ERVZfU0c9bQpDT05GSUdfQ0hSX0RFVl9TQ0g9bQojIENPTkZJ
R19TQ1NJX0VOQ0xPU1VSRSBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX01VTFRJX0xVTj15CkNP
TkZJR19TQ1NJX0NPTlNUQU5UUz15CkNPTkZJR19TQ1NJX0xPR0dJTkc9eQpDT05GSUdfU0NT
SV9TQ0FOX0FTWU5DPXkKCiMKIyBTQ1NJIFRyYW5zcG9ydHMKIwpDT05GSUdfU0NTSV9TUElf
QVRUUlM9bQpDT05GSUdfU0NTSV9GQ19BVFRSUz1tCkNPTkZJR19TQ1NJX0ZDX1RHVF9BVFRS
Uz15CkNPTkZJR19TQ1NJX0lTQ1NJX0FUVFJTPW0KQ09ORklHX1NDU0lfU0FTX0FUVFJTPW0K
Q09ORklHX1NDU0lfU0FTX0xJQlNBUz1tCkNPTkZJR19TQ1NJX1NBU19BVEE9eQpDT05GSUdf
U0NTSV9TQVNfSE9TVF9TTVA9eQpDT05GSUdfU0NTSV9TUlBfQVRUUlM9bQpDT05GSUdfU0NT
SV9TUlBfVEdUX0FUVFJTPXkKQ09ORklHX1NDU0lfTE9XTEVWRUw9eQpDT05GSUdfSVNDU0lf
VENQPW0KQ09ORklHX0lTQ1NJX0JPT1RfU1lTRlM9bQpDT05GSUdfU0NTSV9DWEdCM19JU0NT
ST1tCkNPTkZJR19TQ1NJX0NYR0I0X0lTQ1NJPW0KQ09ORklHX1NDU0lfQk5YMl9JU0NTST1t
CkNPTkZJR19TQ1NJX0JOWDJYX0ZDT0U9bQpDT05GSUdfQkUySVNDU0k9bQpDT05GSUdfQkxL
X0RFVl8zV19YWFhYX1JBSUQ9bQpDT05GSUdfU0NTSV9IUFNBPW0KQ09ORklHX1NDU0lfM1df
OVhYWD1tCkNPTkZJR19TQ1NJXzNXX1NBUz1tCkNPTkZJR19TQ1NJX0FDQVJEPW0KQ09ORklH
X1NDU0lfQUFDUkFJRD1tCkNPTkZJR19TQ1NJX0FJQzdYWFg9bQpDT05GSUdfQUlDN1hYWF9D
TURTX1BFUl9ERVZJQ0U9OApDT05GSUdfQUlDN1hYWF9SRVNFVF9ERUxBWV9NUz0xNTAwMApD
T05GSUdfQUlDN1hYWF9ERUJVR19FTkFCTEU9eQpDT05GSUdfQUlDN1hYWF9ERUJVR19NQVNL
PTAKQ09ORklHX0FJQzdYWFhfUkVHX1BSRVRUWV9QUklOVD15CkNPTkZJR19TQ1NJX0FJQzdY
WFhfT0xEPW0KQ09ORklHX1NDU0lfQUlDNzlYWD1tCkNPTkZJR19BSUM3OVhYX0NNRFNfUEVS
X0RFVklDRT0zMgpDT05GSUdfQUlDNzlYWF9SRVNFVF9ERUxBWV9NUz0xNTAwMApDT05GSUdf
QUlDNzlYWF9ERUJVR19FTkFCTEU9eQpDT05GSUdfQUlDNzlYWF9ERUJVR19NQVNLPTAKQ09O
RklHX0FJQzc5WFhfUkVHX1BSRVRUWV9QUklOVD15CkNPTkZJR19TQ1NJX0FJQzk0WFg9bQoj
IENPTkZJR19BSUM5NFhYX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfTVZTQVM9bQoj
IENPTkZJR19TQ1NJX01WU0FTX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9NVlNB
U19UQVNLTEVUIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfTVZVTUk9bQpDT05GSUdfU0NTSV9E
UFRfSTJPPW0KQ09ORklHX1NDU0lfQURWQU5TWVM9bQpDT05GSUdfU0NTSV9BUkNNU1I9bQpD
T05GSUdfTUVHQVJBSURfTkVXR0VOPXkKQ09ORklHX01FR0FSQUlEX01NPW0KQ09ORklHX01F
R0FSQUlEX01BSUxCT1g9bQpDT05GSUdfTUVHQVJBSURfTEVHQUNZPW0KQ09ORklHX01FR0FS
QUlEX1NBUz1tCkNPTkZJR19TQ1NJX01QVDJTQVM9bQpDT05GSUdfU0NTSV9NUFQyU0FTX01B
WF9TR0U9MTI4CiMgQ09ORklHX1NDU0lfTVBUMlNBU19MT0dHSU5HIGlzIG5vdCBzZXQKQ09O
RklHX1NDU0lfVUZTSENEPW0KQ09ORklHX1NDU0lfSFBUSU9QPW0KQ09ORklHX1NDU0lfQlVT
TE9HSUM9bQpDT05GSUdfVk1XQVJFX1BWU0NTST1tCkNPTkZJR19IWVBFUlZfU1RPUkFHRT1t
CkNPTkZJR19MSUJGQz1tCkNPTkZJR19MSUJGQ09FPW0KQ09ORklHX0ZDT0U9bQpDT05GSUdf
RkNPRV9GTklDPW0KQ09ORklHX1NDU0lfRE1YMzE5MUQ9bQpDT05GSUdfU0NTSV9FQVRBPW0K
Q09ORklHX1NDU0lfRUFUQV9UQUdHRURfUVVFVUU9eQpDT05GSUdfU0NTSV9FQVRBX0xJTktF
RF9DT01NQU5EUz15CkNPTkZJR19TQ1NJX0VBVEFfTUFYX1RBR1M9MTYKQ09ORklHX1NDU0lf
RlVUVVJFX0RPTUFJTj1tCkNPTkZJR19TQ1NJX0dEVEg9bQpDT05GSUdfU0NTSV9JU0NJPW0K
Q09ORklHX1NDU0lfSVBTPW0KQ09ORklHX1NDU0lfSU5JVElPPW0KQ09ORklHX1NDU0lfSU5J
QTEwMD1tCkNPTkZJR19TQ1NJX1NURVg9bQpDT05GSUdfU0NTSV9TWU01M0M4WFhfMj1tCkNP
TkZJR19TQ1NJX1NZTTUzQzhYWF9ETUFfQUREUkVTU0lOR19NT0RFPTEKQ09ORklHX1NDU0lf
U1lNNTNDOFhYX0RFRkFVTFRfVEFHUz0xNgpDT05GSUdfU0NTSV9TWU01M0M4WFhfTUFYX1RB
R1M9NjQKQ09ORklHX1NDU0lfU1lNNTNDOFhYX01NSU89eQpDT05GSUdfU0NTSV9JUFI9bQoj
IENPTkZJR19TQ1NJX0lQUl9UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVBSX0RV
TVAgaXMgbm90IHNldApDT05GSUdfU0NTSV9RTE9HSUNfMTI4MD1tCkNPTkZJR19TQ1NJX1FM
QV9GQz1tCkNPTkZJR19UQ01fUUxBMlhYWD1tCkNPTkZJR19TQ1NJX1FMQV9JU0NTST1tCkNP
TkZJR19TQ1NJX0xQRkM9bQojIENPTkZJR19TQ1NJX0xQRkNfREVCVUdfRlMgaXMgbm90IHNl
dApDT05GSUdfU0NTSV9EQzM5NXg9bQpDT05GSUdfU0NTSV9EQzM5MFQ9bQpDT05GSUdfU0NT
SV9ERUJVRz1tCkNPTkZJR19TQ1NJX1BNQ1JBSUQ9bQpDT05GSUdfU0NTSV9QTTgwMDE9bQpD
T05GSUdfU0NTSV9TUlA9bQpDT05GSUdfU0NTSV9CRkFfRkM9bQpDT05GSUdfU0NTSV9WSVJU
SU89bQpDT05GSUdfU0NTSV9ESD1tCkNPTkZJR19TQ1NJX0RIX1JEQUM9bQpDT05GSUdfU0NT
SV9ESF9IUF9TVz1tCkNPTkZJR19TQ1NJX0RIX0VNQz1tCkNPTkZJR19TQ1NJX0RIX0FMVUE9
bQpDT05GSUdfU0NTSV9PU0RfSU5JVElBVE9SPW0KQ09ORklHX1NDU0lfT1NEX1VMRD1tCkNP
TkZJR19TQ1NJX09TRF9EUFJJTlRfU0VOU0U9MQojIENPTkZJR19TQ1NJX09TRF9ERUJVRyBp
cyBub3Qgc2V0CkNPTkZJR19BVEE9eQojIENPTkZJR19BVEFfTk9OU1RBTkRBUkQgaXMgbm90
IHNldApDT05GSUdfQVRBX1ZFUkJPU0VfRVJST1I9eQpDT05GSUdfQVRBX0FDUEk9eQpDT05G
SUdfU0FUQV9QTVA9eQoKIwojIENvbnRyb2xsZXJzIHdpdGggbm9uLVNGRiBuYXRpdmUgaW50
ZXJmYWNlCiMKQ09ORklHX1NBVEFfQUhDST1tCkNPTkZJR19TQVRBX0FIQ0lfUExBVEZPUk09
bQojIENPTkZJR19TQVRBX0lOSUMxNjJYIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9BQ0FS
RF9BSENJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSUwyNCBpcyBub3Qgc2V0CkNPTkZJ
R19BVEFfU0ZGPXkKCiMKIyBTRkYgY29udHJvbGxlcnMgd2l0aCBjdXN0b20gRE1BIGludGVy
ZmFjZQojCiMgQ09ORklHX1BEQ19BRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9RU1RP
UiBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfU1g0IGlzIG5vdCBzZXQKQ09ORklHX0FUQV9C
TURNQT15CgojCiMgU0FUQSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURNQQojCkNPTkZJR19B
VEFfUElJWD1tCiMgQ09ORklHX1NBVEFfSElHSEJBTksgaXMgbm90IHNldApDT05GSUdfU0FU
QV9NVj1tCkNPTkZJR19TQVRBX05WPW0KIyBDT05GSUdfU0FUQV9QUk9NSVNFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0FUQV9TSUwgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NJUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NBVEFfU1ZXIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9VTEkg
aXMgbm90IHNldAojIENPTkZJR19TQVRBX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFf
VklURVNTRSBpcyBub3Qgc2V0CgojCiMgUEFUQSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURN
QQojCiMgQ09ORklHX1BBVEFfQUxJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BTUQgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX0FSQVNBTl9DRiBpcyBub3Qgc2V0CiMgQ09ORklHX1BB
VEFfQVJUT1AgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FUSUlYUCBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfQVRQODY3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ01ENjRYIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1MjAgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X0NTNTUzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTM2IGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9DWVBSRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9FRkFSIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzNjYgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQ
VDM3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSFBUM1gyTiBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfSFBUM1gzIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9JVDgyMTMgaXMgbm90
IHNldAojIENPTkZJR19QQVRBX0lUODIxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSk1J
Q1JPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTUFSVkVMTCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfTkVUQ0VMTCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTklOSkEzMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
T0xEUElJWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfT1BUSURNQSBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfUERDMjAyN1ggaXMgbm90IHNldAojIENPTkZJR19QQVRBX1BEQ19PTEQg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX1JBRElTWVMgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX1JEQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0MxMjAwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9TQ0ggaXMgbm90IHNldAojIENPTkZJR19QQVRBX1NFUlZFUldPUktTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TSUw2ODAgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X1NJUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfVE9TSElCQSBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfVFJJRkxFWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfVklBIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEFUQV9XSU5CT05EIGlzIG5vdCBzZXQKCiMKIyBQSU8tb25seSBTRkYg
Y29udHJvbGxlcnMKIwojIENPTkZJR19QQVRBX0NNRDY0MF9QQ0kgaXMgbm90IHNldAojIENP
TkZJR19QQVRBX01QSUlYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9OUzg3NDEwIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9PUFRJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SWjEw
MDAgaXMgbm90IHNldAoKIwojIEdlbmVyaWMgZmFsbGJhY2sgLyBsZWdhY3kgZHJpdmVycwoj
CkNPTkZJR19QQVRBX0FDUEk9bQpDT05GSUdfQVRBX0dFTkVSSUM9bQojIENPTkZJR19QQVRB
X0xFR0FDWSBpcyBub3Qgc2V0CkNPTkZJR19NRD15CkNPTkZJR19CTEtfREVWX01EPW0KQ09O
RklHX01EX0xJTkVBUj1tCkNPTkZJR19NRF9SQUlEMD1tCkNPTkZJR19NRF9SQUlEMT1tCkNP
TkZJR19NRF9SQUlEMTA9bQpDT05GSUdfTURfUkFJRDQ1Nj1tCiMgQ09ORklHX01VTFRJQ09S
RV9SQUlENDU2IGlzIG5vdCBzZXQKQ09ORklHX01EX01VTFRJUEFUSD1tCkNPTkZJR19NRF9G
QVVMVFk9bQpDT05GSUdfQkxLX0RFVl9ETT1tCiMgQ09ORklHX0RNX0RFQlVHIGlzIG5vdCBz
ZXQKQ09ORklHX0RNX0JVRklPPW0KQ09ORklHX0RNX0JJT19QUklTT049bQpDT05GSUdfRE1f
UEVSU0lTVEVOVF9EQVRBPW0KQ09ORklHX0RNX0NSWVBUPW0KQ09ORklHX0RNX1NOQVBTSE9U
PW0KQ09ORklHX0RNX1RISU5fUFJPVklTSU9OSU5HPW0KIyBDT05GSUdfRE1fREVCVUdfQkxP
Q0tfU1RBQ0tfVFJBQ0lORyBpcyBub3Qgc2V0CkNPTkZJR19ETV9NSVJST1I9bQpDT05GSUdf
RE1fUkFJRD1tCkNPTkZJR19ETV9MT0dfVVNFUlNQQUNFPW0KQ09ORklHX0RNX1pFUk89bQpD
T05GSUdfRE1fTVVMVElQQVRIPW0KQ09ORklHX0RNX01VTFRJUEFUSF9RTD1tCkNPTkZJR19E
TV9NVUxUSVBBVEhfU1Q9bQpDT05GSUdfRE1fREVMQVk9bQpDT05GSUdfRE1fVUVWRU5UPXkK
Q09ORklHX0RNX0ZMQUtFWT1tCkNPTkZJR19ETV9WRVJJVFk9bQpDT05GSUdfVEFSR0VUX0NP
UkU9bQpDT05GSUdfVENNX0lCTE9DSz1tCkNPTkZJR19UQ01fRklMRUlPPW0KQ09ORklHX1RD
TV9QU0NTST1tCkNPTkZJR19MT09QQkFDS19UQVJHRVQ9bQpDT05GSUdfVENNX0ZDPW0KQ09O
RklHX0lTQ1NJX1RBUkdFVD1tCkNPTkZJR19TQlBfVEFSR0VUPW0KQ09ORklHX0ZVU0lPTj15
CkNPTkZJR19GVVNJT05fU1BJPW0KQ09ORklHX0ZVU0lPTl9GQz1tCkNPTkZJR19GVVNJT05f
U0FTPW0KQ09ORklHX0ZVU0lPTl9NQVhfU0dFPTEyOApDT05GSUdfRlVTSU9OX0NUTD1tCkNP
TkZJR19GVVNJT05fTEFOPW0KIyBDT05GSUdfRlVTSU9OX0xPR0dJTkcgaXMgbm90IHNldAoK
IwojIElFRUUgMTM5NCAoRmlyZVdpcmUpIHN1cHBvcnQKIwpDT05GSUdfRklSRVdJUkU9bQpD
T05GSUdfRklSRVdJUkVfT0hDST1tCkNPTkZJR19GSVJFV0lSRV9TQlAyPW0KQ09ORklHX0ZJ
UkVXSVJFX05FVD1tCkNPTkZJR19GSVJFV0lSRV9OT1NZPW0KQ09ORklHX0kyTz1tCkNPTkZJ
R19JMk9fTENUX05PVElGWV9PTl9DSEFOR0VTPXkKQ09ORklHX0kyT19FWFRfQURBUFRFQz15
CkNPTkZJR19JMk9fRVhUX0FEQVBURUNfRE1BNjQ9eQpDT05GSUdfSTJPX0NPTkZJRz1tCkNP
TkZJR19JMk9fQ09ORklHX09MRF9JT0NUTD15CkNPTkZJR19JMk9fQlVTPW0KQ09ORklHX0ky
T19CTE9DSz1tCkNPTkZJR19JMk9fU0NTST1tCkNPTkZJR19JMk9fUFJPQz1tCkNPTkZJR19N
QUNJTlRPU0hfRFJJVkVSUz15CkNPTkZJR19NQUNfRU1VTU9VU0VCVE49eQpDT05GSUdfTkVU
REVWSUNFUz15CkNPTkZJR19ORVRfQ09SRT15CkNPTkZJR19CT05ESU5HPW0KQ09ORklHX0RV
TU1ZPW0KQ09ORklHX0VRVUFMSVpFUj1tCkNPTkZJR19ORVRfRkM9eQpDT05GSUdfTUlJPW0K
Q09ORklHX0lGQj1tCkNPTkZJR19ORVRfVEVBTT1tCkNPTkZJR19ORVRfVEVBTV9NT0RFX0JS
T0FEQ0FTVD1tCkNPTkZJR19ORVRfVEVBTV9NT0RFX1JPVU5EUk9CSU49bQpDT05GSUdfTkVU
X1RFQU1fTU9ERV9BQ1RJVkVCQUNLVVA9bQpDT05GSUdfTkVUX1RFQU1fTU9ERV9MT0FEQkFM
QU5DRT1tCkNPTkZJR19NQUNWTEFOPW0KQ09ORklHX01BQ1ZUQVA9bQojIENPTkZJR19WWExB
TiBpcyBub3Qgc2V0CkNPTkZJR19ORVRDT05TT0xFPW0KQ09ORklHX05FVENPTlNPTEVfRFlO
QU1JQz15CkNPTkZJR19ORVRQT0xMPXkKIyBDT05GSUdfTkVUUE9MTF9UUkFQIGlzIG5vdCBz
ZXQKQ09ORklHX05FVF9QT0xMX0NPTlRST0xMRVI9eQpDT05GSUdfVFVOPW0KQ09ORklHX1ZF
VEg9bQpDT05GSUdfVklSVElPX05FVD1tCkNPTkZJR19TVU5HRU1fUEhZPW0KIyBDT05GSUdf
QVJDTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0RSSVZFUlMgaXMgbm90IHNldAoKIwoj
IENBSUYgdHJhbnNwb3J0IGRyaXZlcnMKIwpDT05GSUdfRVRIRVJORVQ9eQpDT05GSUdfTURJ
Tz1tCkNPTkZJR19ORVRfVkVORE9SXzNDT009eQpDT05GSUdfVk9SVEVYPW0KQ09ORklHX1RZ
UEhPT049bQpDT05GSUdfTkVUX1ZFTkRPUl9BREFQVEVDPXkKQ09ORklHX0FEQVBURUNfU1RB
UkZJUkU9bQpDT05GSUdfTkVUX1ZFTkRPUl9BTFRFT049eQpDT05GSUdfQUNFTklDPW0KIyBD
T05GSUdfQUNFTklDX09NSVRfVElHT05fSSBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9S
X0FNRD15CkNPTkZJR19BTUQ4MTExX0VUSD1tCkNPTkZJR19QQ05FVDMyPW0KQ09ORklHX05F
VF9WRU5ET1JfQVRIRVJPUz15CkNPTkZJR19BVEwyPW0KQ09ORklHX0FUTDE9bQpDT05GSUdf
QVRMMUU9bQpDT05GSUdfQVRMMUM9bQpDT05GSUdfTkVUX1ZFTkRPUl9CUk9BRENPTT15CkNP
TkZJR19CNDQ9bQpDT05GSUdfQjQ0X1BDSV9BVVRPU0VMRUNUPXkKQ09ORklHX0I0NF9QQ0lD
T1JFX0FVVE9TRUxFQ1Q9eQpDT05GSUdfQjQ0X1BDST15CkNPTkZJR19CTlgyPW0KQ09ORklH
X0NOSUM9bQpDT05GSUdfVElHT04zPW0KQ09ORklHX0JOWDJYPW0KQ09ORklHX05FVF9WRU5E
T1JfQlJPQ0FERT15CkNPTkZJR19CTkE9bQpDT05GSUdfTkVUX0NBTFhFREFfWEdNQUM9bQpD
T05GSUdfTkVUX1ZFTkRPUl9DSEVMU0lPPXkKQ09ORklHX0NIRUxTSU9fVDE9bQpDT05GSUdf
Q0hFTFNJT19UMV8xRz15CkNPTkZJR19DSEVMU0lPX1QzPW0KQ09ORklHX0NIRUxTSU9fVDQ9
bQpDT05GSUdfQ0hFTFNJT19UNFZGPW0KQ09ORklHX05FVF9WRU5ET1JfQ0lTQ089eQpDT05G
SUdfRU5JQz1tCkNPTkZJR19ETkVUPW0KQ09ORklHX05FVF9WRU5ET1JfREVDPXkKQ09ORklH
X05FVF9UVUxJUD15CkNPTkZJR19ERTIxMDRYPW0KQ09ORklHX0RFMjEwNFhfRFNMPTAKQ09O
RklHX1RVTElQPW0KIyBDT05GSUdfVFVMSVBfTVdJIGlzIG5vdCBzZXQKIyBDT05GSUdfVFVM
SVBfTU1JTyBpcyBub3Qgc2V0CkNPTkZJR19UVUxJUF9OQVBJPXkKQ09ORklHX1RVTElQX05B
UElfSFdfTUlUSUdBVElPTj15CiMgQ09ORklHX0RFNFg1IGlzIG5vdCBzZXQKQ09ORklHX1dJ
TkJPTkRfODQwPW0KQ09ORklHX0RNOTEwMj1tCkNPTkZJR19VTEk1MjZYPW0KQ09ORklHX05F
VF9WRU5ET1JfRExJTks9eQpDT05GSUdfREwySz1tCkNPTkZJR19TVU5EQU5DRT1tCiMgQ09O
RklHX1NVTkRBTkNFX01NSU8gaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9FTVVMRVg9
eQpDT05GSUdfQkUyTkVUPW0KQ09ORklHX05FVF9WRU5ET1JfRVhBUj15CkNPTkZJR19TMklP
PW0KQ09ORklHX1ZYR0U9bQojIENPTkZJR19WWEdFX0RFQlVHX1RSQUNFX0FMTCBpcyBub3Qg
c2V0CkNPTkZJR19ORVRfVkVORE9SX0hQPXkKQ09ORklHX0hQMTAwPW0KQ09ORklHX05FVF9W
RU5ET1JfSU5URUw9eQpDT05GSUdfRTEwMD1tCkNPTkZJR19FMTAwMD1tCkNPTkZJR19FMTAw
MEU9bQpDT05GSUdfSUdCPW0KQ09ORklHX0lHQl9EQ0E9eQpDT05GSUdfSUdCX1BUUD15CkNP
TkZJR19JR0JWRj1tCkNPTkZJR19JWEdCPW0KQ09ORklHX0lYR0JFPW0KQ09ORklHX0lYR0JF
X0hXTU9OPXkKQ09ORklHX0lYR0JFX0RDQT15CkNPTkZJR19JWEdCRV9EQ0I9eQpDT05GSUdf
SVhHQkVfUFRQPXkKQ09ORklHX0lYR0JFVkY9bQpDT05GSUdfTkVUX1ZFTkRPUl9JODI1WFg9
eQojIENPTkZJR19aTkVUIGlzIG5vdCBzZXQKQ09ORklHX0lQMTAwMD1tCkNPTkZJR19KTUU9
bQpDT05GSUdfTkVUX1ZFTkRPUl9NQVJWRUxMPXkKQ09ORklHX1NLR0U9bQojIENPTkZJR19T
S0dFX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NLR0VfR0VORVNJUz15CkNPTkZJR19TS1ky
PW0KIyBDT05GSUdfU0tZMl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX01F
TExBTk9YPXkKQ09ORklHX01MWDRfRU49bQpDT05GSUdfTUxYNF9FTl9EQ0I9eQpDT05GSUdf
TUxYNF9DT1JFPW0KQ09ORklHX01MWDRfREVCVUc9eQpDT05GSUdfTkVUX1ZFTkRPUl9NSUNS
RUw9eQpDT05GSUdfS1M4ODQyPW0KQ09ORklHX0tTODg1MT1tCkNPTkZJR19LUzg4NTFfTUxM
PW0KQ09ORklHX0tTWjg4NFhfUENJPW0KQ09ORklHX05FVF9WRU5ET1JfTUlDUk9DSElQPXkK
Q09ORklHX0VOQzI4SjYwPW0KIyBDT05GSUdfRU5DMjhKNjBfV1JJVEVWRVJJRlkgaXMgbm90
IHNldApDT05GSUdfTkVUX1ZFTkRPUl9NWVJJPXkKQ09ORklHX01ZUkkxMEdFPW0KQ09ORklH
X01ZUkkxMEdFX0RDQT15CkNPTkZJR19GRUFMTlg9bQpDT05GSUdfTkVUX1ZFTkRPUl9OQVRT
RU1JPXkKQ09ORklHX05BVFNFTUk9bQpDT05GSUdfTlM4MzgyMD1tCkNPTkZJR19ORVRfVkVO
RE9SXzgzOTA9eQpDT05GSUdfTkUyS19QQ0k9bQpDT05GSUdfTkVUX1ZFTkRPUl9OVklESUE9
eQpDT05GSUdfRk9SQ0VERVRIPW0KQ09ORklHX05FVF9WRU5ET1JfT0tJPXkKQ09ORklHX1BD
SF9HQkU9bQpDT05GSUdfUENIX1BUUD15CkNPTkZJR19FVEhPQz1tCkNPTkZJR19ORVRfUEFD
S0VUX0VOR0lORT15CkNPTkZJR19IQU1BQ0hJPW0KQ09ORklHX1lFTExPV0ZJTj1tCkNPTkZJ
R19ORVRfVkVORE9SX1FMT0dJQz15CkNPTkZJR19RTEEzWFhYPW0KQ09ORklHX1FMQ05JQz1t
CkNPTkZJR19RTEdFPW0KQ09ORklHX05FVFhFTl9OSUM9bQpDT05GSUdfTkVUX1ZFTkRPUl9S
RUFMVEVLPXkKQ09ORklHXzgxMzlDUD1tCkNPTkZJR184MTM5VE9PPW0KIyBDT05GSUdfODEz
OVRPT19QSU8gaXMgbm90IHNldApDT05GSUdfODEzOVRPT19UVU5FX1RXSVNURVI9eQpDT05G
SUdfODEzOVRPT184MTI5PXkKIyBDT05GSUdfODEzOV9PTERfUlhfUkVTRVQgaXMgbm90IHNl
dApDT05GSUdfUjgxNjk9bQpDT05GSUdfTkVUX1ZFTkRPUl9SREM9eQpDT05GSUdfUjYwNDA9
bQpDT05GSUdfTkVUX1ZFTkRPUl9TRUVRPXkKIyBDT05GSUdfU0VFUTgwMDUgaXMgbm90IHNl
dApDT05GSUdfTkVUX1ZFTkRPUl9TSUxBTj15CkNPTkZJR19TQzkyMDMxPW0KQ09ORklHX05F
VF9WRU5ET1JfU0lTPXkKQ09ORklHX1NJUzkwMD1tCkNPTkZJR19TSVMxOTA9bQpDT05GSUdf
U0ZDPW0KQ09ORklHX1NGQ19NVEQ9eQpDT05GSUdfU0ZDX01DRElfTU9OPXkKQ09ORklHX1NG
Q19TUklPVj15CkNPTkZJR19TRkNfUFRQPXkKQ09ORklHX05FVF9WRU5ET1JfU01TQz15CkNP
TkZJR19FUElDMTAwPW0KQ09ORklHX1NNU0M5NDIwPW0KQ09ORklHX05FVF9WRU5ET1JfU1RN
SUNSTz15CiMgQ09ORklHX1NUTU1BQ19FVEggaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRP
Ul9TVU49eQpDT05GSUdfSEFQUFlNRUFMPW0KQ09ORklHX1NVTkdFTT1tCkNPTkZJR19DQVNT
SU5JPW0KQ09ORklHX05JVT1tCkNPTkZJR19ORVRfVkVORE9SX1RFSFVUST15CkNPTkZJR19U
RUhVVEk9bQpDT05GSUdfTkVUX1ZFTkRPUl9UST15CkNPTkZJR19UTEFOPW0KQ09ORklHX05F
VF9WRU5ET1JfVklBPXkKQ09ORklHX1ZJQV9SSElORT1tCiMgQ09ORklHX1ZJQV9SSElORV9N
TUlPIGlzIG5vdCBzZXQKQ09ORklHX1ZJQV9WRUxPQ0lUWT1tCkNPTkZJR19ORVRfVkVORE9S
X1dJWk5FVD15CkNPTkZJR19XSVpORVRfVzUxMDA9bQpDT05GSUdfV0laTkVUX1c1MzAwPW0K
IyBDT05GSUdfV0laTkVUX0JVU19ESVJFQ1QgaXMgbm90IHNldAojIENPTkZJR19XSVpORVRf
QlVTX0lORElSRUNUIGlzIG5vdCBzZXQKQ09ORklHX1dJWk5FVF9CVVNfQU5ZPXkKIyBDT05G
SUdfRkRESSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJUFBJIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX1NCMTAwMCBpcyBub3Qgc2V0CkNPTkZJR19QSFlMSUI9bQoKIwojIE1JSSBQSFkgZGV2
aWNlIGRyaXZlcnMKIwojIENPTkZJR19BVDgwM1hfUEhZIGlzIG5vdCBzZXQKQ09ORklHX0FN
RF9QSFk9bQpDT05GSUdfTUFSVkVMTF9QSFk9bQpDT05GSUdfREFWSUNPTV9QSFk9bQpDT05G
SUdfUVNFTUlfUEhZPW0KQ09ORklHX0xYVF9QSFk9bQpDT05GSUdfQ0lDQURBX1BIWT1tCkNP
TkZJR19WSVRFU1NFX1BIWT1tCkNPTkZJR19TTVNDX1BIWT1tCkNPTkZJR19CUk9BRENPTV9Q
SFk9bQpDT05GSUdfQkNNODdYWF9QSFk9bQpDT05GSUdfSUNQTFVTX1BIWT1tCkNPTkZJR19S
RUFMVEVLX1BIWT1tCkNPTkZJR19OQVRJT05BTF9QSFk9bQpDT05GSUdfU1RFMTBYUD1tCkNP
TkZJR19MU0lfRVQxMDExQ19QSFk9bQpDT05GSUdfTUlDUkVMX1BIWT1tCkNPTkZJR19NRElP
X0JJVEJBTkc9bQojIENPTkZJR19NRElPX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19NSUNS
RUxfS1M4OTk1TUEgaXMgbm90IHNldApDT05GSUdfUFBQPW0KQ09ORklHX1BQUF9CU0RDT01Q
PW0KQ09ORklHX1BQUF9ERUZMQVRFPW0KQ09ORklHX1BQUF9GSUxURVI9eQpDT05GSUdfUFBQ
X01QUEU9bQpDT05GSUdfUFBQX01VTFRJTElOSz15CkNPTkZJR19QUFBPQVRNPW0KQ09ORklH
X1BQUE9FPW0KQ09ORklHX1BQVFA9bQpDT05GSUdfUFBQT0wyVFA9bQpDT05GSUdfUFBQX0FT
WU5DPW0KQ09ORklHX1BQUF9TWU5DX1RUWT1tCkNPTkZJR19TTElQPW0KQ09ORklHX1NMSEM9
bQpDT05GSUdfU0xJUF9DT01QUkVTU0VEPXkKQ09ORklHX1NMSVBfU01BUlQ9eQpDT05GSUdf
U0xJUF9NT0RFX1NMSVA2PXkKCiMKIyBVU0IgTmV0d29yayBBZGFwdGVycwojCkNPTkZJR19V
U0JfQ0FUQz1tCkNPTkZJR19VU0JfS0FXRVRIPW0KQ09ORklHX1VTQl9QRUdBU1VTPW0KQ09O
RklHX1VTQl9SVEw4MTUwPW0KQ09ORklHX1VTQl9VU0JORVQ9bQpDT05GSUdfVVNCX05FVF9B
WDg4MTdYPW0KQ09ORklHX1VTQl9ORVRfQ0RDRVRIRVI9bQpDT05GSUdfVVNCX05FVF9DRENf
RUVNPW0KQ09ORklHX1VTQl9ORVRfQ0RDX05DTT1tCkNPTkZJR19VU0JfTkVUX0RNOTYwMT1t
CkNPTkZJR19VU0JfTkVUX1NNU0M3NVhYPW0KQ09ORklHX1VTQl9ORVRfU01TQzk1WFg9bQpD
T05GSUdfVVNCX05FVF9HTDYyMEE9bQpDT05GSUdfVVNCX05FVF9ORVQxMDgwPW0KQ09ORklH
X1VTQl9ORVRfUExVU0I9bQpDT05GSUdfVVNCX05FVF9NQ1M3ODMwPW0KQ09ORklHX1VTQl9O
RVRfUk5ESVNfSE9TVD1tCkNPTkZJR19VU0JfTkVUX0NEQ19TVUJTRVQ9bQpDT05GSUdfVVNC
X0FMSV9NNTYzMj15CkNPTkZJR19VU0JfQU4yNzIwPXkKQ09ORklHX1VTQl9CRUxLSU49eQpD
T05GSUdfVVNCX0FSTUxJTlVYPXkKQ09ORklHX1VTQl9FUFNPTjI4ODg9eQpDT05GSUdfVVNC
X0tDMjE5MD15CkNPTkZJR19VU0JfTkVUX1pBVVJVUz1tCkNPTkZJR19VU0JfTkVUX0NYODIz
MTBfRVRIPW0KQ09ORklHX1VTQl9ORVRfS0FMTUlBPW0KQ09ORklHX1VTQl9ORVRfUU1JX1dX
QU49bQpDT05GSUdfVVNCX0hTTz1tCkNPTkZJR19VU0JfTkVUX0lOVDUxWDE9bQpDT05GSUdf
VVNCX0NEQ19QSE9ORVQ9bQpDT05GSUdfVVNCX0lQSEVUSD1tCkNPTkZJR19VU0JfU0lFUlJB
X05FVD1tCkNPTkZJR19VU0JfVkw2MDA9bQpDT05GSUdfV0xBTj15CkNPTkZJR19MSUJFUlRB
U19USElORklSTT1tCiMgQ09ORklHX0xJQkVSVEFTX1RISU5GSVJNX0RFQlVHIGlzIG5vdCBz
ZXQKQ09ORklHX0xJQkVSVEFTX1RISU5GSVJNX1VTQj1tCkNPTkZJR19BSVJPPW0KQ09ORklH
X0FUTUVMPW0KQ09ORklHX1BDSV9BVE1FTD1tCkNPTkZJR19BVDc2QzUwWF9VU0I9bQojIENP
TkZJR19QUklTTTU0IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9aRDEyMDE9bQpDT05GSUdfVVNC
X05FVF9STkRJU19XTEFOPW0KQ09ORklHX1JUTDgxODA9bQpDT05GSUdfUlRMODE4Nz1tCkNP
TkZJR19SVEw4MTg3X0xFRFM9eQpDT05GSUdfQURNODIxMT1tCkNPTkZJR19NQUM4MDIxMV9I
V1NJTT1tCkNPTkZJR19NV0w4Sz1tCkNPTkZJR19BVEhfQ09NTU9OPW0KIyBDT05GSUdfQVRI
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0FUSDVLPW0KIyBDT05GSUdfQVRINUtfREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19BVEg1S19UUkFDRVIgaXMgbm90IHNldApDT05GSUdfQVRI
NUtfUENJPXkKQ09ORklHX0FUSDlLX0hXPW0KQ09ORklHX0FUSDlLX0NPTU1PTj1tCkNPTkZJ
R19BVEg5S19CVENPRVhfU1VQUE9SVD15CkNPTkZJR19BVEg5Sz1tCkNPTkZJR19BVEg5S19Q
Q0k9eQojIENPTkZJR19BVEg5S19BSEIgaXMgbm90IHNldAojIENPTkZJR19BVEg5S19ERUJV
R0ZTIGlzIG5vdCBzZXQKQ09ORklHX0FUSDlLX1JBVEVfQ09OVFJPTD15CkNPTkZJR19BVEg5
S19IVEM9bQojIENPTkZJR19BVEg5S19IVENfREVCVUdGUyBpcyBub3Qgc2V0CkNPTkZJR19D
QVJMOTE3MD1tCkNPTkZJR19DQVJMOTE3MF9MRURTPXkKQ09ORklHX0NBUkw5MTcwX1dQQz15
CiMgQ09ORklHX0NBUkw5MTcwX0hXUk5HIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRINktMIGlz
IG5vdCBzZXQKQ09ORklHX0I0Mz1tCkNPTkZJR19CNDNfQkNNQT15CkNPTkZJR19CNDNfQkNN
QV9FWFRSQT15CkNPTkZJR19CNDNfU1NCPXkKQ09ORklHX0I0M19QQ0lfQVVUT1NFTEVDVD15
CkNPTkZJR19CNDNfUENJQ09SRV9BVVRPU0VMRUNUPXkKQ09ORklHX0I0M19TRElPPXkKQ09O
RklHX0I0M19CQ01BX1BJTz15CkNPTkZJR19CNDNfUElPPXkKQ09ORklHX0I0M19QSFlfTj15
CkNPTkZJR19CNDNfUEhZX0xQPXkKQ09ORklHX0I0M19QSFlfSFQ9eQpDT05GSUdfQjQzX0xF
RFM9eQpDT05GSUdfQjQzX0hXUk5HPXkKIyBDT05GSUdfQjQzX0RFQlVHIGlzIG5vdCBzZXQK
Q09ORklHX0I0M0xFR0FDWT1tCkNPTkZJR19CNDNMRUdBQ1lfUENJX0FVVE9TRUxFQ1Q9eQpD
T05GSUdfQjQzTEVHQUNZX1BDSUNPUkVfQVVUT1NFTEVDVD15CkNPTkZJR19CNDNMRUdBQ1lf
TEVEUz15CkNPTkZJR19CNDNMRUdBQ1lfSFdSTkc9eQpDT05GSUdfQjQzTEVHQUNZX0RFQlVH
PXkKQ09ORklHX0I0M0xFR0FDWV9ETUE9eQpDT05GSUdfQjQzTEVHQUNZX1BJTz15CkNPTkZJ
R19CNDNMRUdBQ1lfRE1BX0FORF9QSU9fTU9ERT15CiMgQ09ORklHX0I0M0xFR0FDWV9ETUFf
TU9ERSBpcyBub3Qgc2V0CiMgQ09ORklHX0I0M0xFR0FDWV9QSU9fTU9ERSBpcyBub3Qgc2V0
CkNPTkZJR19CUkNNVVRJTD1tCkNPTkZJR19CUkNNU01BQz1tCiMgQ09ORklHX0JSQ01GTUFD
IGlzIG5vdCBzZXQKIyBDT05GSUdfQlJDTURCRyBpcyBub3Qgc2V0CkNPTkZJR19IT1NUQVA9
bQpDT05GSUdfSE9TVEFQX0ZJUk1XQVJFPXkKIyBDT05GSUdfSE9TVEFQX0ZJUk1XQVJFX05W
UkFNIGlzIG5vdCBzZXQKQ09ORklHX0hPU1RBUF9QTFg9bQpDT05GSUdfSE9TVEFQX1BDST1t
CiMgQ09ORklHX0lQVzIxMDAgaXMgbm90IHNldApDT05GSUdfSVBXMjIwMD1tCkNPTkZJR19J
UFcyMjAwX01PTklUT1I9eQpDT05GSUdfSVBXMjIwMF9SQURJT1RBUD15CkNPTkZJR19JUFcy
MjAwX1BST01JU0NVT1VTPXkKQ09ORklHX0lQVzIyMDBfUU9TPXkKIyBDT05GSUdfSVBXMjIw
MF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19MSUJJUFc9bQojIENPTkZJR19MSUJJUFdfREVC
VUcgaXMgbm90IHNldApDT05GSUdfSVdMV0lGST1tCkNPTkZJR19JV0xEVk09bQoKIwojIERl
YnVnZ2luZyBPcHRpb25zCiMKIyBDT05GSUdfSVdMV0lGSV9ERUJVRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lXTFdJRklfREVWSUNFX1RSQUNJTkcgaXMgbm90IHNldApDT05GSUdfSVdMV0lG
SV9QMlA9eQojIENPTkZJR19JV0xXSUZJX0VYUEVSSU1FTlRBTF9NRlAgaXMgbm90IHNldApD
T05GSUdfSVdMRUdBQ1k9bQpDT05GSUdfSVdMNDk2NT1tCkNPTkZJR19JV0wzOTQ1PW0KCiMK
IyBpd2wzOTQ1IC8gaXdsNDk2NSBEZWJ1Z2dpbmcgT3B0aW9ucwojCiMgQ09ORklHX0lXTEVH
QUNZX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0xJQkVSVEFTPW0KQ09ORklHX0xJQkVSVEFT
X1VTQj1tCkNPTkZJR19MSUJFUlRBU19TRElPPW0KQ09ORklHX0xJQkVSVEFTX1NQST1tCiMg
Q09ORklHX0xJQkVSVEFTX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0xJQkVSVEFTX01FU0g9
eQpDT05GSUdfSEVSTUVTPW0KIyBDT05GSUdfSEVSTUVTX1BSSVNNIGlzIG5vdCBzZXQKQ09O
RklHX0hFUk1FU19DQUNIRV9GV19PTl9JTklUPXkKQ09ORklHX1BMWF9IRVJNRVM9bQpDT05G
SUdfVE1EX0hFUk1FUz1tCkNPTkZJR19OT1JURUxfSEVSTUVTPW0KQ09ORklHX09SSU5PQ09f
VVNCPW0KQ09ORklHX1A1NF9DT01NT049bQpDT05GSUdfUDU0X1VTQj1tCkNPTkZJR19QNTRf
UENJPW0KQ09ORklHX1A1NF9TUEk9bQojIENPTkZJR19QNTRfU1BJX0RFRkFVTFRfRUVQUk9N
IGlzIG5vdCBzZXQKQ09ORklHX1A1NF9MRURTPXkKQ09ORklHX1JUMlgwMD1tCkNPTkZJR19S
VDI0MDBQQ0k9bQpDT05GSUdfUlQyNTAwUENJPW0KQ09ORklHX1JUNjFQQ0k9bQpDT05GSUdf
UlQyODAwUENJPW0KQ09ORklHX1JUMjgwMFBDSV9SVDMzWFg9eQpDT05GSUdfUlQyODAwUENJ
X1JUMzVYWD15CkNPTkZJR19SVDI4MDBQQ0lfUlQ1M1hYPXkKQ09ORklHX1JUMjgwMFBDSV9S
VDMyOTA9eQpDT05GSUdfUlQyNTAwVVNCPW0KQ09ORklHX1JUNzNVU0I9bQpDT05GSUdfUlQy
ODAwVVNCPW0KQ09ORklHX1JUMjgwMFVTQl9SVDMzWFg9eQpDT05GSUdfUlQyODAwVVNCX1JU
MzVYWD15CkNPTkZJR19SVDI4MDBVU0JfUlQ1M1hYPXkKIyBDT05GSUdfUlQyODAwVVNCX1VO
S05PV04gaXMgbm90IHNldApDT05GSUdfUlQyODAwX0xJQj1tCkNPTkZJR19SVDJYMDBfTElC
X1BDST1tCkNPTkZJR19SVDJYMDBfTElCX1VTQj1tCkNPTkZJR19SVDJYMDBfTElCPW0KQ09O
RklHX1JUMlgwMF9MSUJfRklSTVdBUkU9eQpDT05GSUdfUlQyWDAwX0xJQl9DUllQVE89eQpD
T05GSUdfUlQyWDAwX0xJQl9MRURTPXkKIyBDT05GSUdfUlQyWDAwX0RFQlVHIGlzIG5vdCBz
ZXQKQ09ORklHX1JUTDgxOTJDRT1tCkNPTkZJR19SVEw4MTkyU0U9bQpDT05GSUdfUlRMODE5
MkRFPW0KQ09ORklHX1JUTDgxOTJDVT1tCkNPTkZJR19SVExXSUZJPW0KIyBDT05GSUdfUlRM
V0lGSV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19SVEw4MTkyQ19DT01NT049bQpDT05GSUdf
V0xfVEk9eQpDT05GSUdfV0wxMjUxPW0KQ09ORklHX1dMMTI1MV9TUEk9bQpDT05GSUdfV0wx
MjUxX1NESU89bQpDT05GSUdfV0wxMlhYPW0KQ09ORklHX1dMMThYWD1tCkNPTkZJR19XTENP
UkU9bQpDT05GSUdfV0xDT1JFX1NQST1tCkNPTkZJR19XTENPUkVfU0RJTz1tCkNPTkZJR19X
TDEyWFhfUExBVEZPUk1fREFUQT15CkNPTkZJR19aRDEyMTFSVz1tCiMgQ09ORklHX1pEMTIx
MVJXX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX01XSUZJRVg9bQpDT05GSUdfTVdJRklFWF9T
RElPPW0KQ09ORklHX01XSUZJRVhfUENJRT1tCkNPTkZJR19NV0lGSUVYX1VTQj1tCgojCiMg
V2lNQVggV2lyZWxlc3MgQnJvYWRiYW5kIGRldmljZXMKIwpDT05GSUdfV0lNQVhfSTI0MDBN
PW0KQ09ORklHX1dJTUFYX0kyNDAwTV9VU0I9bQpDT05GSUdfV0lNQVhfSTI0MDBNX0RFQlVH
X0xFVkVMPTgKQ09ORklHX1dBTj15CiMgQ09ORklHX0xBTk1FRElBIGlzIG5vdCBzZXQKQ09O
RklHX0hETEM9bQpDT05GSUdfSERMQ19SQVc9bQpDT05GSUdfSERMQ19SQVdfRVRIPW0KQ09O
RklHX0hETENfQ0lTQ089bQpDT05GSUdfSERMQ19GUj1tCkNPTkZJR19IRExDX1BQUD1tCiMg
Q09ORklHX0hETENfWDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfUENJMjAwU1lOIGlzIG5vdCBz
ZXQKIyBDT05GSUdfV0FOWEwgaXMgbm90IHNldAojIENPTkZJR19QQzMwMFRPTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZBUlNZTkMgaXMgbm90IHNldAojIENPTkZJR19EU0NDNCBpcyBub3Qg
c2V0CkNPTkZJR19ETENJPW0KQ09ORklHX0RMQ0lfTUFYPTgKQ09ORklHX1dBTl9ST1VURVJf
RFJJVkVSUz1tCiMgQ09ORklHX0NZQ0xBREVTX1NZTkMgaXMgbm90IHNldAojIENPTkZJR19T
Qk5JIGlzIG5vdCBzZXQKQ09ORklHX0lFRUU4MDIxNTRfRFJJVkVSUz1tCkNPTkZJR19JRUVF
ODAyMTU0X0ZBS0VIQVJEPW0KQ09ORklHX1ZNWE5FVDM9bQpDT05GSUdfSFlQRVJWX05FVD1t
CkNPTkZJR19JU0ROPXkKIyBDT05GSUdfSVNETl9JNEwgaXMgbm90IHNldApDT05GSUdfSVNE
Tl9DQVBJPW0KQ09ORklHX0lTRE5fRFJWX0FWTUIxX1ZFUkJPU0VfUkVBU09OPXkKQ09ORklH
X0NBUElfVFJBQ0U9eQpDT05GSUdfSVNETl9DQVBJX01JRERMRVdBUkU9eQpDT05GSUdfSVNE
Tl9DQVBJX0NBUEkyMD1tCgojCiMgQ0FQSSBoYXJkd2FyZSBkcml2ZXJzCiMKQ09ORklHX0NB
UElfQVZNPXkKQ09ORklHX0lTRE5fRFJWX0FWTUIxX0IxUENJPW0KQ09ORklHX0lTRE5fRFJW
X0FWTUIxX0IxUENJVjQ9eQpDT05GSUdfSVNETl9EUlZfQVZNQjFfVDFQQ0k9bQpDT05GSUdf
SVNETl9EUlZfQVZNQjFfQzQ9bQpDT05GSUdfQ0FQSV9FSUNPTj15CkNPTkZJR19JU0ROX0RJ
VkFTPW0KQ09ORklHX0lTRE5fRElWQVNfQlJJUENJPXkKQ09ORklHX0lTRE5fRElWQVNfUFJJ
UENJPXkKQ09ORklHX0lTRE5fRElWQVNfRElWQUNBUEk9bQpDT05GSUdfSVNETl9ESVZBU19V
U0VSSURJPW0KQ09ORklHX0lTRE5fRElWQVNfTUFJTlQ9bQpDT05GSUdfSVNETl9EUlZfR0lH
QVNFVD1tCkNPTkZJR19HSUdBU0VUX0NBUEk9eQojIENPTkZJR19HSUdBU0VUX0RVTU1ZTEwg
aXMgbm90IHNldApDT05GSUdfR0lHQVNFVF9CQVNFPW0KQ09ORklHX0dJR0FTRVRfTTEwNT1t
CkNPTkZJR19HSUdBU0VUX00xMDE9bQojIENPTkZJR19HSUdBU0VUX0RFQlVHIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSFlTRE4gaXMgbm90IHNldApDT05GSUdfTUlTRE49bQpDT05GSUdfTUlT
RE5fRFNQPW0KQ09ORklHX01JU0ROX0wxT0lQPW0KCiMKIyBtSVNETiBoYXJkd2FyZSBkcml2
ZXJzCiMKQ09ORklHX01JU0ROX0hGQ1BDST1tCkNPTkZJR19NSVNETl9IRkNNVUxUST1tCkNP
TkZJR19NSVNETl9IRkNVU0I9bQpDT05GSUdfTUlTRE5fQVZNRlJJVFo9bQpDT05GSUdfTUlT
RE5fU1BFRURGQVg9bQpDT05GSUdfTUlTRE5fSU5GSU5FT049bQpDT05GSUdfTUlTRE5fVzY2
OTI9bQojIENPTkZJR19NSVNETl9ORVRKRVQgaXMgbm90IHNldApDT05GSUdfTUlTRE5fSVBB
Qz1tCkNPTkZJR19NSVNETl9JU0FSPW0KCiMKIyBJbnB1dCBkZXZpY2Ugc3VwcG9ydAojCkNP
TkZJR19JTlBVVD15CkNPTkZJR19JTlBVVF9GRl9NRU1MRVNTPW0KQ09ORklHX0lOUFVUX1BP
TExERVY9bQpDT05GSUdfSU5QVVRfU1BBUlNFS01BUD1tCkNPTkZJR19JTlBVVF9NQVRSSVhL
TUFQPW0KCiMKIyBVc2VybGFuZCBpbnRlcmZhY2VzCiMKQ09ORklHX0lOUFVUX01PVVNFREVW
PXkKQ09ORklHX0lOUFVUX01PVVNFREVWX1BTQVVYPXkKQ09ORklHX0lOUFVUX01PVVNFREVW
X1NDUkVFTl9YPTEwMjQKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9ZPTc2OApDT05G
SUdfSU5QVVRfSk9ZREVWPW0KQ09ORklHX0lOUFVUX0VWREVWPW0KIyBDT05GSUdfSU5QVVRf
RVZCVUcgaXMgbm90IHNldAoKIwojIElucHV0IERldmljZSBEcml2ZXJzCiMKQ09ORklHX0lO
UFVUX0tFWUJPQVJEPXkKQ09ORklHX0tFWUJPQVJEX0FEUDU1ODg9bQojIENPTkZJR19LRVlC
T0FSRF9BRFA1NTg5IGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0FUS0JEPXkKIyBDT05G
SUdfS0VZQk9BUkRfUVQxMDcwIGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX1FUMjE2MD1t
CkNPTkZJR19LRVlCT0FSRF9MS0tCRD1tCiMgQ09ORklHX0tFWUJPQVJEX0dQSU8gaXMgbm90
IHNldAojIENPTkZJR19LRVlCT0FSRF9HUElPX1BPTExFRCBpcyBub3Qgc2V0CiMgQ09ORklH
X0tFWUJPQVJEX1RDQTY0MTYgaXMgbm90IHNldApDT05GSUdfS0VZQk9BUkRfVENBODQxOD1t
CiMgQ09ORklHX0tFWUJPQVJEX01BVFJJWCBpcyBub3Qgc2V0CkNPTkZJR19LRVlCT0FSRF9M
TTgzMjM9bQpDT05GSUdfS0VZQk9BUkRfTE04MzMzPW0KQ09ORklHX0tFWUJPQVJEX01BWDcz
NTk9bQojIENPTkZJR19LRVlCT0FSRF9NQ1MgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FS
RF9NUFIxMjEgaXMgbm90IHNldApDT05GSUdfS0VZQk9BUkRfTkVXVE9OPW0KQ09ORklHX0tF
WUJPQVJEX09QRU5DT1JFUz1tCkNPTkZJR19LRVlCT0FSRF9TVE9XQVdBWT1tCkNPTkZJR19L
RVlCT0FSRF9TVU5LQkQ9bQpDT05GSUdfS0VZQk9BUkRfT01BUDQ9bQpDT05GSUdfS0VZQk9B
UkRfWFRLQkQ9bQpDT05GSUdfSU5QVVRfTU9VU0U9eQpDT05GSUdfTU9VU0VfUFMyPW0KQ09O
RklHX01PVVNFX1BTMl9BTFBTPXkKQ09ORklHX01PVVNFX1BTMl9MT0dJUFMyUFA9eQpDT05G
SUdfTU9VU0VfUFMyX1NZTkFQVElDUz15CkNPTkZJR19NT1VTRV9QUzJfTElGRUJPT0s9eQpD
T05GSUdfTU9VU0VfUFMyX1RSQUNLUE9JTlQ9eQpDT05GSUdfTU9VU0VfUFMyX0VMQU5URUNI
PXkKQ09ORklHX01PVVNFX1BTMl9TRU5URUxJQz15CiMgQ09ORklHX01PVVNFX1BTMl9UT1VD
SEtJVCBpcyBub3Qgc2V0CkNPTkZJR19NT1VTRV9TRVJJQUw9bQpDT05GSUdfTU9VU0VfQVBQ
TEVUT1VDSD1tCkNPTkZJR19NT1VTRV9CQ001OTc0PW0KQ09ORklHX01PVVNFX1ZTWFhYQUE9
bQojIENPTkZJR19NT1VTRV9HUElPIGlzIG5vdCBzZXQKQ09ORklHX01PVVNFX1NZTkFQVElD
U19JMkM9bQpDT05GSUdfTU9VU0VfU1lOQVBUSUNTX1VTQj1tCkNPTkZJR19JTlBVVF9KT1lT
VElDSz15CkNPTkZJR19KT1lTVElDS19BTkFMT0c9bQpDT05GSUdfSk9ZU1RJQ0tfQTNEPW0K
Q09ORklHX0pPWVNUSUNLX0FEST1tCkNPTkZJR19KT1lTVElDS19DT0JSQT1tCkNPTkZJR19K
T1lTVElDS19HRjJLPW0KQ09ORklHX0pPWVNUSUNLX0dSSVA9bQpDT05GSUdfSk9ZU1RJQ0tf
R1JJUF9NUD1tCkNPTkZJR19KT1lTVElDS19HVUlMTEVNT1Q9bQpDT05GSUdfSk9ZU1RJQ0tf
SU5URVJBQ1Q9bQpDT05GSUdfSk9ZU1RJQ0tfU0lERVdJTkRFUj1tCkNPTkZJR19KT1lTVElD
S19UTURDPW0KQ09ORklHX0pPWVNUSUNLX0lGT1JDRT1tCkNPTkZJR19KT1lTVElDS19JRk9S
Q0VfVVNCPXkKQ09ORklHX0pPWVNUSUNLX0lGT1JDRV8yMzI9eQpDT05GSUdfSk9ZU1RJQ0tf
V0FSUklPUj1tCkNPTkZJR19KT1lTVElDS19NQUdFTExBTj1tCkNPTkZJR19KT1lTVElDS19T
UEFDRU9SQj1tCkNPTkZJR19KT1lTVElDS19TUEFDRUJBTEw9bQpDT05GSUdfSk9ZU1RJQ0tf
U1RJTkdFUj1tCkNPTkZJR19KT1lTVElDS19UV0lESk9ZPW0KQ09ORklHX0pPWVNUSUNLX1pI
RU5IVUE9bQojIENPTkZJR19KT1lTVElDS19BUzUwMTEgaXMgbm90IHNldApDT05GSUdfSk9Z
U1RJQ0tfSk9ZRFVNUD1tCkNPTkZJR19KT1lTVElDS19YUEFEPW0KQ09ORklHX0pPWVNUSUNL
X1hQQURfRkY9eQpDT05GSUdfSk9ZU1RJQ0tfWFBBRF9MRURTPXkKQ09ORklHX0lOUFVUX1RB
QkxFVD15CkNPTkZJR19UQUJMRVRfVVNCX0FDRUNBRD1tCkNPTkZJR19UQUJMRVRfVVNCX0FJ
UFRFSz1tCkNPTkZJR19UQUJMRVRfVVNCX0dUQ089bQpDT05GSUdfVEFCTEVUX1VTQl9IQU5X
QU5HPW0KQ09ORklHX1RBQkxFVF9VU0JfS0JUQUI9bQpDT05GSUdfVEFCTEVUX1VTQl9XQUNP
TT1tCkNPTkZJR19JTlBVVF9UT1VDSFNDUkVFTj15CkNPTkZJR19UT1VDSFNDUkVFTl9BRFM3
ODQ2PW0KQ09ORklHX1RPVUNIU0NSRUVOX0FENzg3Nz1tCkNPTkZJR19UT1VDSFNDUkVFTl9B
RDc4Nzk9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5X0kyQz1tCiMgQ09ORklHX1RPVUNI
U0NSRUVOX0FENzg3OV9TUEkgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9BVE1F
TF9NWFQgaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fQVVPX1BJWENJUj1tCiMgQ09O
RklHX1RPVUNIU0NSRUVOX0JVMjEwMTMgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVF
Tl9DWThDVE1HMTEwIGlzIG5vdCBzZXQKQ09ORklHX1RPVUNIU0NSRUVOX0NZVFRTUF9DT1JF
PW0KQ09ORklHX1RPVUNIU0NSRUVOX0NZVFRTUF9JMkM9bQpDT05GSUdfVE9VQ0hTQ1JFRU5f
Q1lUVFNQX1NQST1tCkNPTkZJR19UT1VDSFNDUkVFTl9EWU5BUFJPPW0KQ09ORklHX1RPVUNI
U0NSRUVOX0hBTVBTSElSRT1tCkNPTkZJR19UT1VDSFNDUkVFTl9FRVRJPW0KQ09ORklHX1RP
VUNIU0NSRUVOX0ZVSklUU1U9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fSUxJMjEwWD1tCkNPTkZJ
R19UT1VDSFNDUkVFTl9HVU5aRT1tCkNPTkZJR19UT1VDSFNDUkVFTl9FTE89bQpDT05GSUdf
VE9VQ0hTQ1JFRU5fV0FDT01fVzgwMDE9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fSTJD
PW0KIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTUFYMTE4MDEgaXMgbm90IHNldApDT05GSUdfVE9V
Q0hTQ1JFRU5fTUNTNTAwMD1tCkNPTkZJR19UT1VDSFNDUkVFTl9NTVMxMTQ9bQpDT05GSUdf
VE9VQ0hTQ1JFRU5fTVRPVUNIPW0KQ09ORklHX1RPVUNIU0NSRUVOX0lORVhJTz1tCkNPTkZJ
R19UT1VDSFNDUkVFTl9NSzcxMj1tCkNPTkZJR19UT1VDSFNDUkVFTl9QRU5NT1VOVD1tCkNP
TkZJR19UT1VDSFNDUkVFTl9FRFRfRlQ1WDA2PW0KQ09ORklHX1RPVUNIU0NSRUVOX1RPVUNI
UklHSFQ9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU49bQpDT05GSUdfVE9VQ0hTQ1JF
RU5fUElYQ0lSPW0KQ09ORklHX1RPVUNIU0NSRUVOX1dNOTdYWD1tCkNPTkZJR19UT1VDSFND
UkVFTl9XTTk3MDU9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fV005NzEyPXkKQ09ORklHX1RPVUNI
U0NSRUVOX1dNOTcxMz15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfQ09NUE9TSVRFPW0KQ09O
RklHX1RPVUNIU0NSRUVOX1VTQl9FR0FMQVg9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX1BB
TkpJVD15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfM009eQpDT05GSUdfVE9VQ0hTQ1JFRU5f
VVNCX0lUTT15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfRVRVUkJPPXkKQ09ORklHX1RPVUNI
U0NSRUVOX1VTQl9HVU5aRT15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfRE1DX1RTQzEwPXkK
Q09ORklHX1RPVUNIU0NSRUVOX1VTQl9JUlRPVUNIPXkKQ09ORklHX1RPVUNIU0NSRUVOX1VT
Ql9JREVBTFRFSz15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfR0VORVJBTF9UT1VDSD15CkNP
TkZJR19UT1VDSFNDUkVFTl9VU0JfR09UT1A9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0pB
U1RFQz15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfRUxPPXkKQ09ORklHX1RPVUNIU0NSRUVO
X1VTQl9FMkk9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX1pZVFJPTklDPXkKQ09ORklHX1RP
VUNIU0NSRUVOX1VTQl9FVFRfVEM0NVVTQj15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfTkVY
SU89eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0VBU1lUT1VDSD15CkNPTkZJR19UT1VDSFND
UkVFTl9UT1VDSElUMjEzPW0KIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDX1NFUklPIGlzIG5v
dCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDMjAwNSBpcyBub3Qgc2V0CkNPTkZJR19U
T1VDSFNDUkVFTl9UU0MyMDA3PW0KIyBDT05GSUdfVE9VQ0hTQ1JFRU5fU1QxMjMyIGlzIG5v
dCBzZXQKQ09ORklHX1RPVUNIU0NSRUVOX1RQUzY1MDdYPW0KQ09ORklHX0lOUFVUX01JU0M9
eQojIENPTkZJR19JTlBVVF9BRDcxNFggaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9CTUEx
NTAgaXMgbm90IHNldApDT05GSUdfSU5QVVRfUENTUEtSPW0KIyBDT05GSUdfSU5QVVRfTU1B
ODQ1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01QVTMwNTAgaXMgbm90IHNldApDT05G
SUdfSU5QVVRfQVBBTkVMPW0KQ09ORklHX0lOUFVUX0dQMkE9bQpDT05GSUdfSU5QVVRfR1BJ
T19USUxUX1BPTExFRD1tCkNPTkZJR19JTlBVVF9BVExBU19CVE5TPW0KQ09ORklHX0lOUFVU
X0FUSV9SRU1PVEUyPW0KQ09ORklHX0lOUFVUX0tFWVNQQU5fUkVNT1RFPW0KIyBDT05GSUdf
SU5QVVRfS1hUSjkgaXMgbm90IHNldApDT05GSUdfSU5QVVRfUE9XRVJNQVRFPW0KQ09ORklH
X0lOUFVUX1lFQUxJTks9bQpDT05GSUdfSU5QVVRfQ00xMDk9bQpDT05GSUdfSU5QVVRfVUlO
UFVUPW0KQ09ORklHX0lOUFVUX1BDRjUwNjMzX1BNVT1tCiMgQ09ORklHX0lOUFVUX1BDRjg1
NzQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9HUElPX1JPVEFSWV9FTkNPREVSIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5QVVRfQURYTDM0WCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVU
X0NNQTMwMDAgaXMgbm90IHNldAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19T
RVJJTz15CkNPTkZJR19TRVJJT19JODA0Mj15CkNPTkZJR19TRVJJT19TRVJQT1JUPW0KQ09O
RklHX1NFUklPX0NUODJDNzEwPW0KQ09ORklHX1NFUklPX1BDSVBTMj1tCkNPTkZJR19TRVJJ
T19MSUJQUzI9eQpDT05GSUdfU0VSSU9fUkFXPW0KQ09ORklHX1NFUklPX0FMVEVSQV9QUzI9
bQojIENPTkZJR19TRVJJT19QUzJNVUxUIGlzIG5vdCBzZXQKQ09ORklHX0dBTUVQT1JUPW0K
Q09ORklHX0dBTUVQT1JUX05TNTU4PW0KQ09ORklHX0dBTUVQT1JUX0w0PW0KQ09ORklHX0dB
TUVQT1JUX0VNVTEwSzE9bQpDT05GSUdfR0FNRVBPUlRfRk04MDE9bQoKIwojIENoYXJhY3Rl
ciBkZXZpY2VzCiMKQ09ORklHX1ZUPXkKQ09ORklHX0NPTlNPTEVfVFJBTlNMQVRJT05TPXkK
Q09ORklHX1ZUX0NPTlNPTEU9eQpDT05GSUdfVlRfQ09OU09MRV9TTEVFUD15CkNPTkZJR19I
V19DT05TT0xFPXkKQ09ORklHX1ZUX0hXX0NPTlNPTEVfQklORElORz15CkNPTkZJR19VTklY
OThfUFRZUz15CkNPTkZJR19ERVZQVFNfTVVMVElQTEVfSU5TVEFOQ0VTPXkKIyBDT05GSUdf
TEVHQUNZX1BUWVMgaXMgbm90IHNldApDT05GSUdfU0VSSUFMX05PTlNUQU5EQVJEPXkKQ09O
RklHX1JPQ0tFVFBPUlQ9bQpDT05GSUdfQ1lDTEFERVM9bQojIENPTkZJR19DWVpfSU5UUiBp
cyBub3Qgc2V0CkNPTkZJR19NT1hBX0lOVEVMTElPPW0KQ09ORklHX01PWEFfU01BUlRJTz1t
CkNPTkZJR19TWU5DTElOSz1tCkNPTkZJR19TWU5DTElOS01QPW0KQ09ORklHX1NZTkNMSU5L
X0dUPW0KQ09ORklHX05PWk9NST1tCkNPTkZJR19JU0k9bQpDT05GSUdfTl9IRExDPW0KQ09O
RklHX05fR1NNPW0KIyBDT05GSUdfVFJBQ0VfU0lOSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
VktNRU0gaXMgbm90IHNldApDT05GSUdfU1RBTERSVj15CgojCiMgU2VyaWFsIGRyaXZlcnMK
IwpDT05GSUdfU0VSSUFMXzgyNTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfUE5QPXkKQ09ORklH
X1NFUklBTF84MjUwX0NPTlNPTEU9eQpDT05GSUdfRklYX0VBUkxZQ09OX01FTT15CkNPTkZJ
R19TRVJJQUxfODI1MF9QQ0k9eQpDT05GSUdfU0VSSUFMXzgyNTBfTlJfVUFSVFM9MzIKQ09O
RklHX1NFUklBTF84MjUwX1JVTlRJTUVfVUFSVFM9NApDT05GSUdfU0VSSUFMXzgyNTBfRVhU
RU5ERUQ9eQpDT05GSUdfU0VSSUFMXzgyNTBfTUFOWV9QT1JUUz15CkNPTkZJR19TRVJJQUxf
ODI1MF9TSEFSRV9JUlE9eQojIENPTkZJR19TRVJJQUxfODI1MF9ERVRFQ1RfSVJRIGlzIG5v
dCBzZXQKQ09ORklHX1NFUklBTF84MjUwX1JTQT15CgojCiMgTm9uLTgyNTAgc2VyaWFsIHBv
cnQgc3VwcG9ydAojCkNPTkZJR19TRVJJQUxfTUFYMzEwMD1tCiMgQ09ORklHX1NFUklBTF9N
QVgzMTBYIGlzIG5vdCBzZXQKQ09ORklHX1NFUklBTF9NRkRfSFNVPW0KQ09ORklHX1NFUklB
TF9DT1JFPXkKQ09ORklHX1NFUklBTF9DT1JFX0NPTlNPTEU9eQpDT05GSUdfU0VSSUFMX0pT
TT1tCiMgQ09ORklHX1NFUklBTF9TQ0NOWFAgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxf
VElNQkVSREFMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BTFRFUkFfSlRBR1VBUlQg
aXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfQUxURVJBX1VBUlQgaXMgbm90IHNldAojIENP
TkZJR19TRVJJQUxfSUZYNlg2MCBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfUENIX1VBUlQ9
bQojIENPTkZJR19TRVJJQUxfWElMSU5YX1BTX1VBUlQgaXMgbm90IHNldApDT05GSUdfSFZD
X0RSSVZFUj15CkNPTkZJR19WSVJUSU9fQ09OU09MRT1tCkNPTkZJR19JUE1JX0hBTkRMRVI9
bQojIENPTkZJR19JUE1JX1BBTklDX0VWRU5UIGlzIG5vdCBzZXQKQ09ORklHX0lQTUlfREVW
SUNFX0lOVEVSRkFDRT1tCkNPTkZJR19JUE1JX1NJPW0KQ09ORklHX0lQTUlfV0FUQ0hET0c9
bQpDT05GSUdfSVBNSV9QT1dFUk9GRj1tCkNPTkZJR19IV19SQU5ET009bQpDT05GSUdfSFdf
UkFORE9NX1RJTUVSSU9NRU09bQpDT05GSUdfSFdfUkFORE9NX0lOVEVMPW0KQ09ORklHX0hX
X1JBTkRPTV9BTUQ9bQpDT05GSUdfSFdfUkFORE9NX1ZJQT1tCkNPTkZJR19IV19SQU5ET01f
VklSVElPPW0KQ09ORklHX0hXX1JBTkRPTV9UUE09bQpDT05GSUdfTlZSQU09bQpDT05GSUdf
UjM5NjQ9bQpDT05GSUdfQVBQTElDT009bQpDT05GSUdfTVdBVkU9bQpDT05GSUdfUkFXX0RS
SVZFUj1tCkNPTkZJR19NQVhfUkFXX0RFVlM9MjU2CkNPTkZJR19IUEVUPXkKQ09ORklHX0hQ
RVRfTU1BUD15CkNPTkZJR19IQU5HQ0hFQ0tfVElNRVI9bQpDT05GSUdfVENHX1RQTT1tCkNP
TkZJR19UQ0dfVElTPW0KQ09ORklHX1RDR19USVNfSTJDX0lORklORU9OPW0KQ09ORklHX1RD
R19OU0M9bQpDT05GSUdfVENHX0FUTUVMPW0KQ09ORklHX1RDR19JTkZJTkVPTj1tCkNPTkZJ
R19URUxDTE9DSz1tCkNPTkZJR19ERVZQT1JUPXkKQ09ORklHX0kyQz15CkNPTkZJR19JMkNf
Qk9BUkRJTkZPPXkKQ09ORklHX0kyQ19DT01QQVQ9eQpDT05GSUdfSTJDX0NIQVJERVY9bQoj
IENPTkZJR19JMkNfTVVYIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CkNP
TkZJR19JMkNfU01CVVM9bQpDT05GSUdfSTJDX0FMR09CSVQ9eQpDT05GSUdfSTJDX0FMR09Q
Q0E9bQoKIwojIEkyQyBIYXJkd2FyZSBCdXMgc3VwcG9ydAojCgojCiMgUEMgU01CdXMgaG9z
dCBjb250cm9sbGVyIGRyaXZlcnMKIwpDT05GSUdfSTJDX0FMSTE1MzU9bQpDT05GSUdfSTJD
X0FMSTE1NjM9bQpDT05GSUdfSTJDX0FMSTE1WDM9bQpDT05GSUdfSTJDX0FNRDc1Nj1tCkNP
TkZJR19JMkNfQU1ENzU2X1M0ODgyPW0KQ09ORklHX0kyQ19BTUQ4MTExPW0KQ09ORklHX0ky
Q19JODAxPW0KQ09ORklHX0kyQ19JU0NIPW0KQ09ORklHX0kyQ19QSUlYND1tCkNPTkZJR19J
MkNfTkZPUkNFMj1tCkNPTkZJR19JMkNfTkZPUkNFMl9TNDk4NT1tCkNPTkZJR19JMkNfU0lT
NTU5NT1tCkNPTkZJR19JMkNfU0lTNjMwPW0KQ09ORklHX0kyQ19TSVM5Nlg9bQpDT05GSUdf
STJDX1ZJQT1tCkNPTkZJR19JMkNfVklBUFJPPW0KCiMKIyBBQ1BJIGRyaXZlcnMKIwpDT05G
SUdfSTJDX1NDTUk9bQoKIwojIEkyQyBzeXN0ZW0gYnVzIGRyaXZlcnMgKG1vc3RseSBlbWJl
ZGRlZCAvIHN5c3RlbS1vbi1jaGlwKQojCiMgQ09ORklHX0kyQ19ERVNJR05XQVJFX1BDSSBp
cyBub3Qgc2V0CkNPTkZJR19JMkNfRUcyMFQ9bQojIENPTkZJR19JMkNfR1BJTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19JTlRFTF9NSUQgaXMgbm90IHNldApDT05GSUdfSTJDX09DT1JF
Uz1tCkNPTkZJR19JMkNfUENBX1BMQVRGT1JNPW0KIyBDT05GSUdfSTJDX1BYQV9QQ0kgaXMg
bm90IHNldApDT05GSUdfSTJDX1NJTVRFQz1tCiMgQ09ORklHX0kyQ19YSUxJTlggaXMgbm90
IHNldAoKIwojIEV4dGVybmFsIEkyQy9TTUJ1cyBhZGFwdGVyIGRyaXZlcnMKIwpDT05GSUdf
STJDX0RJT0xBTl9VMkM9bQpDT05GSUdfSTJDX1BBUlBPUlRfTElHSFQ9bQpDT05GSUdfSTJD
X1RBT1NfRVZNPW0KQ09ORklHX0kyQ19USU5ZX1VTQj1tCgojCiMgT3RoZXIgSTJDL1NNQnVz
IGJ1cyBkcml2ZXJzCiMKQ09ORklHX0kyQ19TVFVCPW0KIyBDT05GSUdfSTJDX0RFQlVHX0NP
UkUgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQUxHTyBpcyBub3Qgc2V0CiMgQ09O
RklHX0kyQ19ERUJVR19CVVMgaXMgbm90IHNldApDT05GSUdfU1BJPXkKIyBDT05GSUdfU1BJ
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NQSV9NQVNURVI9eQoKIwojIFNQSSBNYXN0ZXIg
Q29udHJvbGxlciBEcml2ZXJzCiMKIyBDT05GSUdfU1BJX0FMVEVSQSBpcyBub3Qgc2V0CkNP
TkZJR19TUElfQklUQkFORz1tCiMgQ09ORklHX1NQSV9HUElPIGlzIG5vdCBzZXQKIyBDT05G
SUdfU1BJX09DX1RJTlkgaXMgbm90IHNldAojIENPTkZJR19TUElfUFhBMlhYX1BDSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NQSV9TQzE4SVM2MDIgaXMgbm90IHNldApDT05GSUdfU1BJX1RP
UENMSUZGX1BDSD1tCkNPTkZJR19TUElfWENPTU09bQojIENPTkZJR19TUElfWElMSU5YIGlz
IG5vdCBzZXQKIyBDT05GSUdfU1BJX0RFU0lHTldBUkUgaXMgbm90IHNldAoKIwojIFNQSSBQ
cm90b2NvbCBNYXN0ZXJzCiMKIyBDT05GSUdfU1BJX1NQSURFViBpcyBub3Qgc2V0CkNPTkZJ
R19TUElfVExFNjJYMD1tCkNPTkZJR19IU0k9bQpDT05GSUdfSFNJX0JPQVJESU5GTz15Cgoj
CiMgSFNJIGNsaWVudHMKIwpDT05GSUdfSFNJX0NIQVI9bQoKIwojIFBQUyBzdXBwb3J0CiMK
Q09ORklHX1BQUz1tCiMgQ09ORklHX1BQU19ERUJVRyBpcyBub3Qgc2V0CgojCiMgUFBTIGNs
aWVudHMgc3VwcG9ydAojCiMgQ09ORklHX1BQU19DTElFTlRfS1RJTUVSIGlzIG5vdCBzZXQK
Q09ORklHX1BQU19DTElFTlRfTERJU0M9bQojIENPTkZJR19QUFNfQ0xJRU5UX0dQSU8gaXMg
bm90IHNldAoKIwojIFBQUyBnZW5lcmF0b3JzIHN1cHBvcnQKIwoKIwojIFBUUCBjbG9jayBz
dXBwb3J0CiMKQ09ORklHX1BUUF8xNTg4X0NMT0NLPW0KCiMKIyBFbmFibGUgUEhZTElCIGFu
ZCBORVRXT1JLX1BIWV9USU1FU1RBTVBJTkcgdG8gc2VlIHRoZSBhZGRpdGlvbmFsIGNsb2Nr
cy4KIwpDT05GSUdfUFRQXzE1ODhfQ0xPQ0tfUENIPW0KQ09ORklHX0FSQ0hfV0FOVF9PUFRJ
T05BTF9HUElPTElCPXkKQ09ORklHX0dQSU9MSUI9eQojIENPTkZJR19ERUJVR19HUElPIGlz
IG5vdCBzZXQKIyBDT05GSUdfR1BJT19TWVNGUyBpcyBub3Qgc2V0CkNPTkZJR19HUElPX0dF
TkVSSUM9bQoKIwojIE1lbW9yeSBtYXBwZWQgR1BJTyBkcml2ZXJzOgojCkNPTkZJR19HUElP
X0dFTkVSSUNfUExBVEZPUk09bQpDT05GSUdfR1BJT19JVDg3NjFFPW0KIyBDT05GSUdfR1BJ
T19TQ0ggaXMgbm90IHNldApDT05GSUdfR1BJT19JQ0g9bQojIENPTkZJR19HUElPX1ZYODU1
IGlzIG5vdCBzZXQKCiMKIyBJMkMgR1BJTyBleHBhbmRlcnM6CiMKIyBDT05GSUdfR1BJT19N
QVg3MzAwIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19NQVg3MzJYIGlzIG5vdCBzZXQKIyBD
T05GSUdfR1BJT19QQ0E5NTNYIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19QQ0Y4NTdYIGlz
IG5vdCBzZXQKIyBDT05GSUdfR1BJT19TWDE1MFggaXMgbm90IHNldAojIENPTkZJR19HUElP
X0FEUDU1ODggaXMgbm90IHNldAoKIwojIFBDSSBHUElPIGV4cGFuZGVyczoKIwpDT05GSUdf
R1BJT19BTUQ4MTExPW0KIyBDT05GSUdfR1BJT19MQU5HV0VMTCBpcyBub3Qgc2V0CkNPTkZJ
R19HUElPX1BDSD1tCiMgQ09ORklHX0dQSU9fTUxfSU9IIGlzIG5vdCBzZXQKIyBDT05GSUdf
R1BJT19SREMzMjFYIGlzIG5vdCBzZXQKCiMKIyBTUEkgR1BJTyBleHBhbmRlcnM6CiMKIyBD
T05GSUdfR1BJT19NQVg3MzAxIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19NQ1AyM1MwOCBp
cyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUMzMzg4MCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQ
SU9fNzRYMTY0IGlzIG5vdCBzZXQKCiMKIyBBQzk3IEdQSU8gZXhwYW5kZXJzOgojCgojCiMg
TU9EVUxidXMgR1BJTyBleHBhbmRlcnM6CiMKQ09ORklHX1cxPW0KQ09ORklHX1cxX0NPTj15
CgojCiMgMS13aXJlIEJ1cyBNYXN0ZXJzCiMKQ09ORklHX1cxX01BU1RFUl9NQVRST1g9bQpD
T05GSUdfVzFfTUFTVEVSX0RTMjQ5MD1tCkNPTkZJR19XMV9NQVNURVJfRFMyNDgyPW0KIyBD
T05GSUdfVzFfTUFTVEVSX0RTMVdNIGlzIG5vdCBzZXQKIyBDT05GSUdfVzFfTUFTVEVSX0dQ
SU8gaXMgbm90IHNldAojIENPTkZJR19IRFFfTUFTVEVSX09NQVAgaXMgbm90IHNldAoKIwoj
IDEtd2lyZSBTbGF2ZXMKIwpDT05GSUdfVzFfU0xBVkVfVEhFUk09bQpDT05GSUdfVzFfU0xB
VkVfU01FTT1tCiMgQ09ORklHX1cxX1NMQVZFX0RTMjQwOCBpcyBub3Qgc2V0CiMgQ09ORklH
X1cxX1NMQVZFX0RTMjQyMyBpcyBub3Qgc2V0CkNPTkZJR19XMV9TTEFWRV9EUzI0MzE9bQpD
T05GSUdfVzFfU0xBVkVfRFMyNDMzPW0KIyBDT05GSUdfVzFfU0xBVkVfRFMyNDMzX0NSQyBp
cyBub3Qgc2V0CkNPTkZJR19XMV9TTEFWRV9EUzI3NjA9bQojIENPTkZJR19XMV9TTEFWRV9E
UzI3ODAgaXMgbm90IHNldApDT05GSUdfVzFfU0xBVkVfRFMyNzgxPW0KQ09ORklHX1cxX1NM
QVZFX0RTMjhFMDQ9bQpDT05GSUdfVzFfU0xBVkVfQlEyNzAwMD1tCkNPTkZJR19QT1dFUl9T
VVBQTFk9eQojIENPTkZJR19QT1dFUl9TVVBQTFlfREVCVUcgaXMgbm90IHNldApDT05GSUdf
UERBX1BPV0VSPW0KIyBDT05GSUdfVEVTVF9QT1dFUiBpcyBub3Qgc2V0CkNPTkZJR19CQVRU
RVJZX0RTMjc2MD1tCiMgQ09ORklHX0JBVFRFUllfRFMyNzgwIGlzIG5vdCBzZXQKQ09ORklH
X0JBVFRFUllfRFMyNzgxPW0KQ09ORklHX0JBVFRFUllfRFMyNzgyPW0KQ09ORklHX0JBVFRF
UllfU0JTPW0KQ09ORklHX0JBVFRFUllfQlEyN3gwMD1tCkNPTkZJR19CQVRURVJZX0JRMjdY
MDBfSTJDPXkKQ09ORklHX0JBVFRFUllfQlEyN1gwMF9QTEFURk9STT15CkNPTkZJR19CQVRU
RVJZX01BWDE3MDQwPW0KIyBDT05GSUdfQkFUVEVSWV9NQVgxNzA0MiBpcyBub3Qgc2V0CkNP
TkZJR19DSEFSR0VSX1BDRjUwNjMzPW0KIyBDT05GSUdfQ0hBUkdFUl9JU1AxNzA0IGlzIG5v
dCBzZXQKIyBDT05GSUdfQ0hBUkdFUl9NQVg4OTAzIGlzIG5vdCBzZXQKQ09ORklHX0NIQVJH
RVJfTFA4NzI3PW0KIyBDT05GSUdfQ0hBUkdFUl9HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q0hBUkdFUl9NQU5BR0VSIGlzIG5vdCBzZXQKQ09ORklHX0NIQVJHRVJfU01CMzQ3PW0KIyBD
T05GSUdfUE9XRVJfQVZTIGlzIG5vdCBzZXQKQ09ORklHX0hXTU9OPXkKQ09ORklHX0hXTU9O
X1ZJRD1tCiMgQ09ORklHX0hXTU9OX0RFQlVHX0NISVAgaXMgbm90IHNldAoKIwojIE5hdGl2
ZSBkcml2ZXJzCiMKIyBDT05GSUdfU0VOU09SU19BQklUVUdVUlUgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0FCSVRVR1VSVTMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FE
NzMxNCBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0FENzQxND1tCkNPTkZJR19TRU5TT1JT
X0FENzQxOD1tCkNPTkZJR19TRU5TT1JTX0FEQ1hYPW0KQ09ORklHX1NFTlNPUlNfQURNMTAy
MT1tCkNPTkZJR19TRU5TT1JTX0FETTEwMjU9bQpDT05GSUdfU0VOU09SU19BRE0xMDI2PW0K
Q09ORklHX1NFTlNPUlNfQURNMTAyOT1tCkNPTkZJR19TRU5TT1JTX0FETTEwMzE9bQpDT05G
SUdfU0VOU09SU19BRE05MjQwPW0KQ09ORklHX1NFTlNPUlNfQURUNzQxMD1tCkNPTkZJR19T
RU5TT1JTX0FEVDc0MTE9bQpDT05GSUdfU0VOU09SU19BRFQ3NDYyPW0KQ09ORklHX1NFTlNP
UlNfQURUNzQ3MD1tCkNPTkZJR19TRU5TT1JTX0FEVDc0NzU9bQpDT05GSUdfU0VOU09SU19B
U0M3NjIxPW0KQ09ORklHX1NFTlNPUlNfSzhURU1QPW0KQ09ORklHX1NFTlNPUlNfSzEwVEVN
UD1tCkNPTkZJR19TRU5TT1JTX0ZBTTE1SF9QT1dFUj1tCkNPTkZJR19TRU5TT1JTX0FTQjEw
MD1tCkNPTkZJR19TRU5TT1JTX0FUWFAxPW0KQ09ORklHX1NFTlNPUlNfRFM2MjA9bQpDT05G
SUdfU0VOU09SU19EUzE2MjE9bQpDT05GSUdfU0VOU09SU19JNUtfQU1CPW0KQ09ORklHX1NF
TlNPUlNfRjcxODA1Rj1tCkNPTkZJR19TRU5TT1JTX0Y3MTg4MkZHPW0KQ09ORklHX1NFTlNP
UlNfRjc1Mzc1Uz1tCkNPTkZJR19TRU5TT1JTX0ZTQ0hNRD1tCkNPTkZJR19TRU5TT1JTX0c3
NjBBPW0KQ09ORklHX1NFTlNPUlNfR0w1MThTTT1tCkNPTkZJR19TRU5TT1JTX0dMNTIwU009
bQojIENPTkZJR19TRU5TT1JTX0dQSU9fRkFOIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNf
SElINjEzMD1tCkNPTkZJR19TRU5TT1JTX0NPUkVURU1QPW0KQ09ORklHX1NFTlNPUlNfSUJN
QUVNPW0KQ09ORklHX1NFTlNPUlNfSUJNUEVYPW0KQ09ORklHX1NFTlNPUlNfSVQ4Nz1tCiMg
Q09ORklHX1NFTlNPUlNfSkM0MiBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0xJTkVBR0U9
bQpDT05GSUdfU0VOU09SU19MTTYzPW0KQ09ORklHX1NFTlNPUlNfTE03MD1tCkNPTkZJR19T
RU5TT1JTX0xNNzM9bQpDT05GSUdfU0VOU09SU19MTTc1PW0KQ09ORklHX1NFTlNPUlNfTE03
Nz1tCkNPTkZJR19TRU5TT1JTX0xNNzg9bQpDT05GSUdfU0VOU09SU19MTTgwPW0KQ09ORklH
X1NFTlNPUlNfTE04Mz1tCkNPTkZJR19TRU5TT1JTX0xNODU9bQpDT05GSUdfU0VOU09SU19M
TTg3PW0KQ09ORklHX1NFTlNPUlNfTE05MD1tCkNPTkZJR19TRU5TT1JTX0xNOTI9bQpDT05G
SUdfU0VOU09SU19MTTkzPW0KQ09ORklHX1NFTlNPUlNfTFRDNDE1MT1tCkNPTkZJR19TRU5T
T1JTX0xUQzQyMTU9bQpDT05GSUdfU0VOU09SU19MVEM0MjQ1PW0KQ09ORklHX1NFTlNPUlNf
TFRDNDI2MT1tCkNPTkZJR19TRU5TT1JTX0xNOTUyNDE9bQpDT05GSUdfU0VOU09SU19MTTk1
MjQ1PW0KQ09ORklHX1NFTlNPUlNfTUFYMTExMT1tCkNPTkZJR19TRU5TT1JTX01BWDE2MDY1
PW0KQ09ORklHX1NFTlNPUlNfTUFYMTYxOT1tCkNPTkZJR19TRU5TT1JTX01BWDE2Njg9bQpD
T05GSUdfU0VOU09SU19NQVgxOTc9bQpDT05GSUdfU0VOU09SU19NQVg2NjM5PW0KQ09ORklH
X1NFTlNPUlNfTUFYNjY0Mj1tCkNPTkZJR19TRU5TT1JTX01BWDY2NTA9bQojIENPTkZJR19T
RU5TT1JTX01DUDMwMjEgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19OVENfVEhFUk1JU1RP
Uj1tCkNPTkZJR19TRU5TT1JTX1BDODczNjA9bQpDT05GSUdfU0VOU09SU19QQzg3NDI3PW0K
Q09ORklHX1NFTlNPUlNfUENGODU5MT1tCiMgQ09ORklHX1BNQlVTIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19TSFQxNSBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX1NIVDIxPW0K
Q09ORklHX1NFTlNPUlNfU0lTNTU5NT1tCkNPTkZJR19TRU5TT1JTX1NNTTY2NT1tCkNPTkZJ
R19TRU5TT1JTX0RNRTE3Mzc9bQpDT05GSUdfU0VOU09SU19FTUMxNDAzPW0KQ09ORklHX1NF
TlNPUlNfRU1DMjEwMz1tCkNPTkZJR19TRU5TT1JTX0VNQzZXMjAxPW0KQ09ORklHX1NFTlNP
UlNfU01TQzQ3TTE9bQpDT05GSUdfU0VOU09SU19TTVNDNDdNMTkyPW0KQ09ORklHX1NFTlNP
UlNfU01TQzQ3QjM5Nz1tCkNPTkZJR19TRU5TT1JTX1NDSDU2WFhfQ09NTU9OPW0KQ09ORklH
X1NFTlNPUlNfU0NINTYyNz1tCkNPTkZJR19TRU5TT1JTX1NDSDU2MzY9bQpDT05GSUdfU0VO
U09SU19BRFMxMDE1PW0KQ09ORklHX1NFTlNPUlNfQURTNzgyOD1tCkNPTkZJR19TRU5TT1JT
X0FEUzc4NzE9bQpDT05GSUdfU0VOU09SU19BTUM2ODIxPW0KIyBDT05GSUdfU0VOU09SU19J
TkEyWFggaXMgbm90IHNldApDT05GSUdfU0VOU09SU19USE1DNTA9bQpDT05GSUdfU0VOU09S
U19UTVAxMDI9bQpDT05GSUdfU0VOU09SU19UTVA0MDE9bQpDT05GSUdfU0VOU09SU19UTVA0
MjE9bQpDT05GSUdfU0VOU09SU19WSUFfQ1BVVEVNUD1tCkNPTkZJR19TRU5TT1JTX1ZJQTY4
NkE9bQpDT05GSUdfU0VOU09SU19WVDEyMTE9bQpDT05GSUdfU0VOU09SU19WVDgyMzE9bQpD
T05GSUdfU0VOU09SU19XODM3ODFEPW0KQ09ORklHX1NFTlNPUlNfVzgzNzkxRD1tCkNPTkZJ
R19TRU5TT1JTX1c4Mzc5MkQ9bQpDT05GSUdfU0VOU09SU19XODM3OTM9bQpDT05GSUdfU0VO
U09SU19XODM3OTU9bQojIENPTkZJR19TRU5TT1JTX1c4Mzc5NV9GQU5DVFJMIGlzIG5vdCBz
ZXQKQ09ORklHX1NFTlNPUlNfVzgzTDc4NVRTPW0KQ09ORklHX1NFTlNPUlNfVzgzTDc4Nk5H
PW0KQ09ORklHX1NFTlNPUlNfVzgzNjI3SEY9bQpDT05GSUdfU0VOU09SU19XODM2MjdFSEY9
bQpDT05GSUdfU0VOU09SU19BUFBMRVNNQz1tCgojCiMgQUNQSSBkcml2ZXJzCiMKQ09ORklH
X1NFTlNPUlNfQUNQSV9QT1dFUj1tCkNPTkZJR19TRU5TT1JTX0FUSzAxMTA9bQpDT05GSUdf
VEhFUk1BTD1tCkNPTkZJR19USEVSTUFMX0hXTU9OPXkKIyBDT05GSUdfQ1BVX1RIRVJNQUwg
aXMgbm90IHNldApDT05GSUdfV0FUQ0hET0c9eQpDT05GSUdfV0FUQ0hET0dfQ09SRT15CiMg
Q09ORklHX1dBVENIRE9HX05PV0FZT1VUIGlzIG5vdCBzZXQKCiMKIyBXYXRjaGRvZyBEZXZp
Y2UgRHJpdmVycwojCkNPTkZJR19TT0ZUX1dBVENIRE9HPW0KQ09ORklHX0FDUVVJUkVfV0RU
PW0KQ09ORklHX0FEVkFOVEVDSF9XRFQ9bQpDT05GSUdfQUxJTTE1MzVfV0RUPW0KQ09ORklH
X0FMSU03MTAxX1dEVD1tCkNPTkZJR19GNzE4MDhFX1dEVD1tCkNPTkZJR19TUDUxMDBfVENP
PW0KQ09ORklHX1NDNTIwX1dEVD1tCkNPTkZJR19TQkNfRklUUEMyX1dBVENIRE9HPW0KQ09O
RklHX0VVUk9URUNIX1dEVD1tCkNPTkZJR19JQjcwMF9XRFQ9bQpDT05GSUdfSUJNQVNSPW0K
Q09ORklHX1dBRkVSX1dEVD1tCkNPTkZJR19JNjMwMEVTQl9XRFQ9bQojIENPTkZJR19JRTZY
WF9XRFQgaXMgbm90IHNldApDT05GSUdfSVRDT19XRFQ9bQpDT05GSUdfSVRDT19WRU5ET1Jf
U1VQUE9SVD15CkNPTkZJR19JVDg3MTJGX1dEVD1tCkNPTkZJR19JVDg3X1dEVD1tCkNPTkZJ
R19IUF9XQVRDSERPRz1tCkNPTkZJR19IUFdEVF9OTUlfREVDT0RJTkc9eQpDT05GSUdfU0Mx
MjAwX1dEVD1tCkNPTkZJR19QQzg3NDEzX1dEVD1tCkNPTkZJR19OVl9UQ089bQpDT05GSUdf
NjBYWF9XRFQ9bQpDT05GSUdfU0JDODM2MF9XRFQ9bQpDT05GSUdfQ1BVNV9XRFQ9bQpDT05G
SUdfU01TQ19TQ0gzMTFYX1dEVD1tCkNPTkZJR19TTVNDMzdCNzg3X1dEVD1tCiMgQ09ORklH
X1ZJQV9XRFQgaXMgbm90IHNldApDT05GSUdfVzgzNjI3SEZfV0RUPW0KQ09ORklHX1c4MzY5
N0hGX1dEVD1tCkNPTkZJR19XODM2OTdVR19XRFQ9bQpDT05GSUdfVzgzODc3Rl9XRFQ9bQpD
T05GSUdfVzgzOTc3Rl9XRFQ9bQpDT05GSUdfTUFDSFpfV0RUPW0KQ09ORklHX1NCQ19FUFhf
QzNfV0FUQ0hET0c9bQoKIwojIFBDSS1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCkNPTkZJR19Q
Q0lQQ1dBVENIRE9HPW0KQ09ORklHX1dEVFBDST1tCgojCiMgVVNCLWJhc2VkIFdhdGNoZG9n
IENhcmRzCiMKQ09ORklHX1VTQlBDV0FUQ0hET0c9bQpDT05GSUdfU1NCX1BPU1NJQkxFPXkK
CiMKIyBTb25pY3MgU2lsaWNvbiBCYWNrcGxhbmUKIwpDT05GSUdfU1NCPW0KQ09ORklHX1NT
Ql9TUFJPTT15CkNPTkZJR19TU0JfQkxPQ0tJTz15CkNPTkZJR19TU0JfUENJSE9TVF9QT1NT
SUJMRT15CkNPTkZJR19TU0JfUENJSE9TVD15CkNPTkZJR19TU0JfQjQzX1BDSV9CUklER0U9
eQpDT05GSUdfU1NCX1NESU9IT1NUX1BPU1NJQkxFPXkKQ09ORklHX1NTQl9TRElPSE9TVD15
CiMgQ09ORklHX1NTQl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19TU0JfRFJJVkVSX1BDSUNP
UkVfUE9TU0lCTEU9eQpDT05GSUdfU1NCX0RSSVZFUl9QQ0lDT1JFPXkKQ09ORklHX0JDTUFf
UE9TU0lCTEU9eQoKIwojIEJyb2FkY29tIHNwZWNpZmljIEFNQkEKIwpDT05GSUdfQkNNQT1t
CkNPTkZJR19CQ01BX0JMT0NLSU89eQpDT05GSUdfQkNNQV9IT1NUX1BDSV9QT1NTSUJMRT15
CkNPTkZJR19CQ01BX0hPU1RfUENJPXkKQ09ORklHX0JDTUFfRFJJVkVSX0dNQUNfQ01OPXkK
IyBDT05GSUdfQkNNQV9ERUJVRyBpcyBub3Qgc2V0CgojCiMgTXVsdGlmdW5jdGlvbiBkZXZp
Y2UgZHJpdmVycwojCkNPTkZJR19NRkRfQ09SRT1tCiMgQ09ORklHX01GRF84OFBNODYwWCBp
cyBub3Qgc2V0CiMgQ09ORklHX01GRF84OFBNODAwIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
Xzg4UE04MDUgaXMgbm90IHNldApDT05GSUdfTUZEX1NNNTAxPW0KIyBDT05GSUdfTUZEX1NN
NTAxX0dQSU8gaXMgbm90IHNldApDT05GSUdfSFRDX1BBU0lDMz1tCiMgQ09ORklHX0hUQ19J
MkNQTEQgaXMgbm90IHNldAojIENPTkZJR19VQ0IxNDAwX0NPUkUgaXMgbm90IHNldAojIENP
TkZJR19NRkRfTE0zNTMzIGlzIG5vdCBzZXQKIyBDT05GSUdfVFBTNjEwNVggaXMgbm90IHNl
dApDT05GSUdfVFBTNjUwMTA9bQojIENPTkZJR19UUFM2NTA3WCBpcyBub3Qgc2V0CiMgQ09O
RklHX01GRF9UUFM2NTIxNyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9UUFM2NTg2WCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9UUFM2NTkxMCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9U
UFM2NTkxMl9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjU5MTJfU1BJIGlzIG5v
dCBzZXQKIyBDT05GSUdfVFdMNDAzMF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfVFdMNjA0
MF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1NUTVBFIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1RDMzU4OVggaXMgbm90IHNldAojIENPTkZJR19NRkRfVE1JTyBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9TTVNDIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1JQ19EQTkwM1ggaXMg
bm90IHNldAojIENPTkZJR19NRkRfREE5MDUyX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9EQTkwNTJfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0RBOTA1NSBpcyBub3Qgc2V0
CiMgQ09ORklHX1BNSUNfQURQNTUyMCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9MUDg3ODgg
aXMgbm90IHNldAojIENPTkZJR19NRkRfTUFYNzc2ODYgaXMgbm90IHNldAojIENPTkZJR19N
RkRfTUFYNzc2OTMgaXMgbm90IHNldAojIENPTkZJR19NRkRfTUFYODkwNyBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9NQVg4OTI1IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5OTcg
aXMgbm90IHNldAojIENPTkZJR19NRkRfTUFYODk5OCBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9TRUNfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9BUklaT05BX0kyQyBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9BUklaT05BX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9X
TTg0MDAgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004MzFYX0kyQyBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9XTTgzMVhfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODM1MF9J
MkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004OTk0IGlzIG5vdCBzZXQKQ09ORklHX01G
RF9QQ0Y1MDYzMz1tCkNPTkZJR19QQ0Y1MDYzM19BREM9bQpDT05GSUdfUENGNTA2MzNfR1BJ
Tz1tCiMgQ09ORklHX01GRF9NQzEzWFhYX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9N
QzEzWFhYX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FCWDUwMF9DT1JFIGlzIG5vdCBzZXQK
IyBDT05GSUdfRVpYX1BDQVAgaXMgbm90IHNldAojIENPTkZJR19NRkRfQ1M1NTM1IGlzIG5v
dCBzZXQKIyBDT05GSUdfTUZEX1RJTUJFUkRBTEUgaXMgbm90IHNldApDT05GSUdfTFBDX1ND
SD1tCkNPTkZJR19MUENfSUNIPW0KIyBDT05GSUdfTUZEX1JEQzMyMVggaXMgbm90IHNldAoj
IENPTkZJR19NRkRfSkFOWl9DTU9ESU8gaXMgbm90IHNldAojIENPTkZJR19NRkRfVlg4NTUg
aXMgbm90IHNldApDT05GSUdfTUZEX1dMMTI3M19DT1JFPW0KIyBDT05GSUdfTUZEX1RQUzY1
MDkwIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0FBVDI4NzBfQ09SRSBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9SQzVUNTgzIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1BBTE1BUyBpcyBu
b3Qgc2V0CkNPTkZJR19SRUdVTEFUT1I9eQojIENPTkZJR19SRUdVTEFUT1JfREVCVUcgaXMg
bm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfRFVNTVkgaXMgbm90IHNldApDT05GSUdfUkVH
VUxBVE9SX0ZJWEVEX1ZPTFRBR0U9bQojIENPTkZJR19SRUdVTEFUT1JfVklSVFVBTF9DT05T
VU1FUiBpcyBub3Qgc2V0CkNPTkZJR19SRUdVTEFUT1JfVVNFUlNQQUNFX0NPTlNVTUVSPW0K
IyBDT05GSUdfUkVHVUxBVE9SX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1Jf
QUQ1Mzk4IGlzIG5vdCBzZXQKQ09ORklHX1JFR1VMQVRPUl9GQU41MzU1NT1tCiMgQ09ORklH
X1JFR1VMQVRPUl9JU0w2MjcxQSBpcyBub3Qgc2V0CkNPTkZJR19SRUdVTEFUT1JfTUFYMTU4
Nj1tCkNPTkZJR19SRUdVTEFUT1JfTUFYODY0OT1tCkNPTkZJR19SRUdVTEFUT1JfTUFYODY2
MD1tCiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4OTUyIGlzIG5vdCBzZXQKQ09ORklHX1JFR1VM
QVRPUl9MUDM5NzE9bQojIENPTkZJR19SRUdVTEFUT1JfTFAzOTcyIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SX0xQODcyWCBpcyBub3Qgc2V0CkNPTkZJR19SRUdVTEFUT1JfUENG
NTA2MzM9bQojIENPTkZJR19SRUdVTEFUT1JfVFBTNjIzNjAgaXMgbm90IHNldApDT05GSUdf
UkVHVUxBVE9SX1RQUzY1MDIzPW0KQ09ORklHX1JFR1VMQVRPUl9UUFM2NTA3WD1tCiMgQ09O
RklHX1JFR1VMQVRPUl9UUFM2NTI0WCBpcyBub3Qgc2V0CkNPTkZJR19NRURJQV9TVVBQT1JU
PW0KCiMKIyBNdWx0aW1lZGlhIGNvcmUgc3VwcG9ydAojCkNPTkZJR19NRURJQV9DQU1FUkFf
U1VQUE9SVD15CkNPTkZJR19NRURJQV9BTkFMT0dfVFZfU1VQUE9SVD15CkNPTkZJR19NRURJ
QV9ESUdJVEFMX1RWX1NVUFBPUlQ9eQpDT05GSUdfTUVESUFfUkFESU9fU1VQUE9SVD15CkNP
TkZJR19NRURJQV9SQ19TVVBQT1JUPXkKQ09ORklHX01FRElBX0NPTlRST0xMRVI9eQpDT05G
SUdfVklERU9fREVWPW0KIyBDT05GSUdfVklERU9fVjRMMl9TVUJERVZfQVBJIGlzIG5vdCBz
ZXQKQ09ORklHX1ZJREVPX1Y0TDI9bQojIENPTkZJR19WSURFT19BRFZfREVCVUcgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19GSVhFRF9NSU5PUl9SQU5HRVMgaXMgbm90IHNldApDT05G
SUdfVklERU9fVFVORVI9bQpDT05GSUdfVjRMMl9NRU0yTUVNX0RFVj1tCkNPTkZJR19WSURF
T0JVRl9HRU49bQpDT05GSUdfVklERU9CVUZfRE1BX1NHPW0KQ09ORklHX1ZJREVPQlVGX1ZN
QUxMT0M9bQpDT05GSUdfVklERU9CVUZfRFZCPW0KQ09ORklHX1ZJREVPQlVGMl9DT1JFPW0K
Q09ORklHX1ZJREVPQlVGMl9NRU1PUFM9bQpDT05GSUdfVklERU9CVUYyX0RNQV9DT05USUc9
bQpDT05GSUdfVklERU9CVUYyX1ZNQUxMT0M9bQpDT05GSUdfRFZCX0NPUkU9bQpDT05GSUdf
RFZCX05FVD15CkNPTkZJR19EVkJfTUFYX0FEQVBURVJTPTgKQ09ORklHX0RWQl9EWU5BTUlD
X01JTk9SUz15CgojCiMgTWVkaWEgZHJpdmVycwojCkNPTkZJR19SQ19DT1JFPW0KQ09ORklH
X1JDX01BUD1tCkNPTkZJR19SQ19ERUNPREVSUz15CkNPTkZJR19MSVJDPW0KQ09ORklHX0lS
X0xJUkNfQ09ERUM9bQpDT05GSUdfSVJfTkVDX0RFQ09ERVI9bQpDT05GSUdfSVJfUkM1X0RF
Q09ERVI9bQpDT05GSUdfSVJfUkM2X0RFQ09ERVI9bQpDT05GSUdfSVJfSlZDX0RFQ09ERVI9
bQpDT05GSUdfSVJfU09OWV9ERUNPREVSPW0KQ09ORklHX0lSX1JDNV9TWl9ERUNPREVSPW0K
Q09ORklHX0lSX1NBTllPX0RFQ09ERVI9bQpDT05GSUdfSVJfTUNFX0tCRF9ERUNPREVSPW0K
Q09ORklHX1JDX0RFVklDRVM9eQpDT05GSUdfUkNfQVRJX1JFTU9URT1tCkNPTkZJR19JUl9F
TkU9bQpDT05GSUdfSVJfSU1PTj1tCkNPTkZJR19JUl9NQ0VVU0I9bQpDT05GSUdfSVJfSVRF
X0NJUj1tCkNPTkZJR19JUl9GSU5URUs9bQpDT05GSUdfSVJfTlVWT1RPTj1tCkNPTkZJR19J
Ul9SRURSQVQzPW0KQ09ORklHX0lSX1NUUkVBTVpBUD1tCkNPTkZJR19JUl9XSU5CT05EX0NJ
Uj1tCkNPTkZJR19JUl9JR1VBTkE9bQpDT05GSUdfSVJfVFRVU0JJUj1tCkNPTkZJR19SQ19M
T09QQkFDSz1tCkNPTkZJR19JUl9HUElPX0NJUj1tCkNPTkZJR19NRURJQV9VU0JfU1VQUE9S
VD15CgojCiMgV2ViY2FtIGRldmljZXMKIwpDT05GSUdfVVNCX1ZJREVPX0NMQVNTPW0KQ09O
RklHX1VTQl9WSURFT19DTEFTU19JTlBVVF9FVkRFVj15CkNPTkZJR19VU0JfR1NQQ0E9bQpD
T05GSUdfVVNCX001NjAyPW0KQ09ORklHX1VTQl9TVFYwNlhYPW0KQ09ORklHX1VTQl9HTDg2
MD1tCkNPTkZJR19VU0JfR1NQQ0FfQkVOUT1tCkNPTkZJR19VU0JfR1NQQ0FfQ09ORVg9bQpD
T05GSUdfVVNCX0dTUENBX0NQSUExPW0KQ09ORklHX1VTQl9HU1BDQV9FVE9NUz1tCkNPTkZJ
R19VU0JfR1NQQ0FfRklORVBJWD1tCkNPTkZJR19VU0JfR1NQQ0FfSkVJTElOSj1tCkNPTkZJ
R19VU0JfR1NQQ0FfSkwyMDA1QkNEPW0KQ09ORklHX1VTQl9HU1BDQV9LSU5FQ1Q9bQpDT05G
SUdfVVNCX0dTUENBX0tPTklDQT1tCkNPTkZJR19VU0JfR1NQQ0FfTUFSUz1tCkNPTkZJR19V
U0JfR1NQQ0FfTVI5NzMxMEE9bQpDT05GSUdfVVNCX0dTUENBX05XODBYPW0KQ09ORklHX1VT
Ql9HU1BDQV9PVjUxOT1tCkNPTkZJR19VU0JfR1NQQ0FfT1Y1MzQ9bQpDT05GSUdfVVNCX0dT
UENBX09WNTM0Xzk9bQpDT05GSUdfVVNCX0dTUENBX1BBQzIwNz1tCkNPTkZJR19VU0JfR1NQ
Q0FfUEFDNzMwMj1tCkNPTkZJR19VU0JfR1NQQ0FfUEFDNzMxMT1tCkNPTkZJR19VU0JfR1NQ
Q0FfU0U0MDE9bQpDT05GSUdfVVNCX0dTUENBX1NOOUMyMDI4PW0KQ09ORklHX1VTQl9HU1BD
QV9TTjlDMjBYPW0KQ09ORklHX1VTQl9HU1BDQV9TT05JWEI9bQpDT05GSUdfVVNCX0dTUENB
X1NPTklYSj1tCkNPTkZJR19VU0JfR1NQQ0FfU1BDQTUwMD1tCkNPTkZJR19VU0JfR1NQQ0Ff
U1BDQTUwMT1tCkNPTkZJR19VU0JfR1NQQ0FfU1BDQTUwNT1tCkNPTkZJR19VU0JfR1NQQ0Ff
U1BDQTUwNj1tCkNPTkZJR19VU0JfR1NQQ0FfU1BDQTUwOD1tCkNPTkZJR19VU0JfR1NQQ0Ff
U1BDQTU2MT1tCkNPTkZJR19VU0JfR1NQQ0FfU1BDQTE1Mjg9bQpDT05GSUdfVVNCX0dTUENB
X1NROTA1PW0KQ09ORklHX1VTQl9HU1BDQV9TUTkwNUM9bQpDT05GSUdfVVNCX0dTUENBX1NR
OTMwWD1tCkNPTkZJR19VU0JfR1NQQ0FfU1RLMDE0PW0KQ09ORklHX1VTQl9HU1BDQV9TVFYw
NjgwPW0KQ09ORklHX1VTQl9HU1BDQV9TVU5QTFVTPW0KQ09ORklHX1VTQl9HU1BDQV9UNjEz
PW0KQ09ORklHX1VTQl9HU1BDQV9UT1BSTz1tCkNPTkZJR19VU0JfR1NQQ0FfVFY4NTMyPW0K
Q09ORklHX1VTQl9HU1BDQV9WQzAzMlg9bQpDT05GSUdfVVNCX0dTUENBX1ZJQ0FNPW0KQ09O
RklHX1VTQl9HU1BDQV9YSVJMSU5LX0NJVD1tCkNPTkZJR19VU0JfR1NQQ0FfWkMzWFg9bQpD
T05GSUdfVVNCX1BXQz1tCiMgQ09ORklHX1VTQl9QV0NfREVCVUcgaXMgbm90IHNldApDT05G
SUdfVVNCX1BXQ19JTlBVVF9FVkRFVj15CkNPTkZJR19WSURFT19DUElBMj1tCkNPTkZJR19V
U0JfWlIzNjRYWD1tCkNPTkZJR19VU0JfU1RLV0VCQ0FNPW0KQ09ORklHX1VTQl9TMjI1NT1t
CkNPTkZJR19VU0JfU045QzEwMj1tCgojCiMgQW5hbG9nIFRWIFVTQiBkZXZpY2VzCiMKQ09O
RklHX1ZJREVPX0FVMDgyOD1tCkNPTkZJR19WSURFT19QVlJVU0IyPW0KQ09ORklHX1ZJREVP
X1BWUlVTQjJfU1lTRlM9eQpDT05GSUdfVklERU9fUFZSVVNCMl9EVkI9eQojIENPTkZJR19W
SURFT19QVlJVU0IyX0RFQlVHSUZDIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX0hEUFZSPW0K
Q09ORklHX1ZJREVPX1RMRzIzMDA9bQpDT05GSUdfVklERU9fVVNCVklTSU9OPW0KQ09ORklH
X1ZJREVPX1NUSzExNjA9bQpDT05GSUdfVklERU9fU1RLMTE2MF9BQzk3PXkKCiMKIyBBbmFs
b2cvZGlnaXRhbCBUViBVU0IgZGV2aWNlcwojCkNPTkZJR19WSURFT19DWDIzMVhYPW0KQ09O
RklHX1ZJREVPX0NYMjMxWFhfUkM9eQpDT05GSUdfVklERU9fQ1gyMzFYWF9BTFNBPW0KQ09O
RklHX1ZJREVPX0NYMjMxWFhfRFZCPW0KQ09ORklHX1ZJREVPX1RNNjAwMD1tCkNPTkZJR19W
SURFT19UTTYwMDBfQUxTQT1tCkNPTkZJR19WSURFT19UTTYwMDBfRFZCPW0KCiMKIyBEaWdp
dGFsIFRWIFVTQiBkZXZpY2VzCiMKQ09ORklHX0RWQl9VU0I9bQojIENPTkZJR19EVkJfVVNC
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0RWQl9VU0JfQTgwMD1tCkNPTkZJR19EVkJfVVNC
X0RJQlVTQl9NQj1tCkNPTkZJR19EVkJfVVNCX0RJQlVTQl9NQl9GQVVMVFk9eQpDT05GSUdf
RFZCX1VTQl9ESUJVU0JfTUM9bQpDT05GSUdfRFZCX1VTQl9ESUIwNzAwPW0KQ09ORklHX0RW
Ql9VU0JfVU1UXzAxMD1tCkNPTkZJR19EVkJfVVNCX0NYVVNCPW0KQ09ORklHX0RWQl9VU0Jf
TTkyMFg9bQpDT05GSUdfRFZCX1VTQl9ESUdJVFY9bQpDT05GSUdfRFZCX1VTQl9WUDcwNDU9
bQpDT05GSUdfRFZCX1VTQl9WUDcwMlg9bQpDT05GSUdfRFZCX1VTQl9HUDhQU0s9bQpDT05G
SUdfRFZCX1VTQl9OT1ZBX1RfVVNCMj1tCkNPTkZJR19EVkJfVVNCX1RUVVNCMj1tCkNPTkZJ
R19EVkJfVVNCX0RUVDIwMFU9bQpDT05GSUdfRFZCX1VTQl9PUEVSQTE9bQpDT05GSUdfRFZC
X1VTQl9BRjkwMDU9bQpDT05GSUdfRFZCX1VTQl9BRjkwMDVfUkVNT1RFPW0KQ09ORklHX0RW
Ql9VU0JfUENUVjQ1MkU9bQpDT05GSUdfRFZCX1VTQl9EVzIxMDI9bQpDT05GSUdfRFZCX1VT
Ql9DSU5FUkdZX1QyPW0KQ09ORklHX0RWQl9VU0JfRFRWNTEwMD1tCkNPTkZJR19EVkJfVVNC
X0ZSSUlPPW0KQ09ORklHX0RWQl9VU0JfQVo2MDI3PW0KQ09ORklHX0RWQl9VU0JfVEVDSE5J
U0FUX1VTQjI9bQpDT05GSUdfRFZCX1VTQl9WMj1tCkNPTkZJR19EVkJfVVNCX0NZUFJFU1Nf
RklSTVdBUkU9bQpDT05GSUdfRFZCX1VTQl9BRjkwMTU9bQpDT05GSUdfRFZCX1VTQl9BRjkw
MzU9bQpDT05GSUdfRFZCX1VTQl9BTllTRUU9bQpDT05GSUdfRFZCX1VTQl9BVTY2MTA9bQpD
T05GSUdfRFZCX1VTQl9BWjYwMDc9bQpDT05GSUdfRFZCX1VTQl9DRTYyMzA9bQpDT05GSUdf
RFZCX1VTQl9FQzE2OD1tCkNPTkZJR19EVkJfVVNCX0dMODYxPW0KQ09ORklHX0RWQl9VU0Jf
SVQ5MTNYPW0KQ09ORklHX0RWQl9VU0JfTE1FMjUxMD1tCkNPTkZJR19EVkJfVVNCX01YTDEx
MVNGPW0KQ09ORklHX0RWQl9VU0JfUlRMMjhYWFU9bQpDT05GSUdfRFZCX1RUVVNCX0JVREdF
VD1tCkNPTkZJR19EVkJfVFRVU0JfREVDPW0KQ09ORklHX1NNU19VU0JfRFJWPW0KQ09ORklH
X0RWQl9CMkMyX0ZMRVhDT1BfVVNCPW0KIyBDT05GSUdfRFZCX0IyQzJfRkxFWENPUF9VU0Jf
REVCVUcgaXMgbm90IHNldAoKIwojIFdlYmNhbSwgVFYgKGFuYWxvZy9kaWdpdGFsKSBVU0Ig
ZGV2aWNlcwojCkNPTkZJR19WSURFT19FTTI4WFg9bQpDT05GSUdfVklERU9fRU0yOFhYX0FM
U0E9bQpDT05GSUdfVklERU9fRU0yOFhYX0RWQj1tCkNPTkZJR19WSURFT19FTTI4WFhfUkM9
bQpDT05GSUdfTUVESUFfUENJX1NVUFBPUlQ9eQoKIwojIE1lZGlhIGNhcHR1cmUgc3VwcG9y
dAojCgojCiMgTWVkaWEgY2FwdHVyZS9hbmFsb2cgVFYgc3VwcG9ydAojCkNPTkZJR19WSURF
T19JVlRWPW0KIyBDT05GSUdfVklERU9fSVZUVl9BTFNBIGlzIG5vdCBzZXQKQ09ORklHX1ZJ
REVPX0ZCX0lWVFY9bQpDT05GSUdfVklERU9fWk9SQU49bQpDT05GSUdfVklERU9fWk9SQU5f
REMzMD1tCkNPTkZJR19WSURFT19aT1JBTl9aUjM2MDYwPW0KQ09ORklHX1ZJREVPX1pPUkFO
X0JVWj1tCkNPTkZJR19WSURFT19aT1JBTl9EQzEwPW0KQ09ORklHX1ZJREVPX1pPUkFOX0xN
TDMzPW0KQ09ORklHX1ZJREVPX1pPUkFOX0xNTDMzUjEwPW0KQ09ORklHX1ZJREVPX1pPUkFO
X0FWUzZFWUVTPW0KQ09ORklHX1ZJREVPX0hFWElVTV9HRU1JTkk9bQpDT05GSUdfVklERU9f
SEVYSVVNX09SSU9OPW0KQ09ORklHX1ZJREVPX01YQj1tCgojCiMgTWVkaWEgY2FwdHVyZS9h
bmFsb2cvaHlicmlkIFRWIHN1cHBvcnQKIwpDT05GSUdfVklERU9fQ1gxOD1tCkNPTkZJR19W
SURFT19DWDE4X0FMU0E9bQpDT05GSUdfVklERU9fQ1gyMzg4NT1tCiMgQ09ORklHX01FRElB
X0FMVEVSQV9DSSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NYMjU4MjEgaXMgbm90IHNl
dApDT05GSUdfVklERU9fQ1g4OD1tCkNPTkZJR19WSURFT19DWDg4X0FMU0E9bQpDT05GSUdf
VklERU9fQ1g4OF9CTEFDS0JJUkQ9bQpDT05GSUdfVklERU9fQ1g4OF9EVkI9bQpDT05GSUdf
VklERU9fQ1g4OF9WUDMwNTQ9bQpDT05GSUdfVklERU9fQ1g4OF9NUEVHPW0KQ09ORklHX1ZJ
REVPX0JUODQ4PW0KQ09ORklHX0RWQl9CVDhYWD1tCkNPTkZJR19WSURFT19TQUE3MTM0PW0K
Q09ORklHX1ZJREVPX1NBQTcxMzRfQUxTQT1tCkNPTkZJR19WSURFT19TQUE3MTM0X1JDPXkK
Q09ORklHX1ZJREVPX1NBQTcxMzRfRFZCPW0KQ09ORklHX1ZJREVPX1NBQTcxNjQ9bQoKIwoj
IE1lZGlhIGRpZ2l0YWwgVFYgUENJIEFkYXB0ZXJzCiMKQ09ORklHX1RUUENJX0VFUFJPTT1t
CkNPTkZJR19EVkJfQVY3MTEwPW0KQ09ORklHX0RWQl9BVjcxMTBfT1NEPXkKQ09ORklHX0RW
Ql9CVURHRVRfQ09SRT1tCkNPTkZJR19EVkJfQlVER0VUPW0KQ09ORklHX0RWQl9CVURHRVRf
Q0k9bQpDT05GSUdfRFZCX0JVREdFVF9BVj1tCkNPTkZJR19EVkJfQlVER0VUX1BBVENIPW0K
Q09ORklHX0RWQl9CMkMyX0ZMRVhDT1BfUENJPW0KIyBDT05GSUdfRFZCX0IyQzJfRkxFWENP
UF9QQ0lfREVCVUcgaXMgbm90IHNldApDT05GSUdfRFZCX1BMVVRPMj1tCkNPTkZJR19EVkJf
RE0xMTA1PW0KQ09ORklHX0RWQl9QVDE9bQpDT05GSUdfTUFOVElTX0NPUkU9bQpDT05GSUdf
RFZCX01BTlRJUz1tCkNPTkZJR19EVkJfSE9QUEVSPW0KQ09ORklHX0RWQl9OR0VORT1tCkNP
TkZJR19EVkJfRERCUklER0U9bQpDT05GSUdfVjRMX1BMQVRGT1JNX0RSSVZFUlM9eQpDT05G
SUdfVklERU9fQ0FGRV9DQ0lDPW0KQ09ORklHX1ZJREVPX1ZJQV9DQU1FUkE9bQojIENPTkZJ
R19WSURFT19USU1CRVJEQUxFIGlzIG5vdCBzZXQKQ09ORklHX1NPQ19DQU1FUkE9bQpDT05G
SUdfU09DX0NBTUVSQV9QTEFURk9STT1tCkNPTkZJR19WNExfTUVNMk1FTV9EUklWRVJTPXkK
Q09ORklHX1ZJREVPX01FTTJNRU1fREVJTlRFUkxBQ0U9bQojIENPTkZJR19WNExfVEVTVF9E
UklWRVJTIGlzIG5vdCBzZXQKCiMKIyBTdXBwb3J0ZWQgTU1DL1NESU8gYWRhcHRlcnMKIwpD
T05GSUdfU01TX1NESU9fRFJWPW0KQ09ORklHX1JBRElPX0FEQVBURVJTPXkKQ09ORklHX1JB
RElPX1NJNDcwWD15CkNPTkZJR19VU0JfU0k0NzBYPW0KQ09ORklHX0kyQ19TSTQ3MFg9bQpD
T05GSUdfVVNCX01SODAwPW0KQ09ORklHX1VTQl9EU0JSPW0KQ09ORklHX1JBRElPX01BWElS
QURJTz1tCkNPTkZJR19SQURJT19TSEFSSz1tCkNPTkZJR19SQURJT19TSEFSSzI9bQpDT05G
SUdfSTJDX1NJNDcxMz1tCkNPTkZJR19SQURJT19TSTQ3MTM9bQpDT05GSUdfVVNCX0tFRU5F
PW0KQ09ORklHX1JBRElPX1RFQTU3NjQ9bQpDT05GSUdfUkFESU9fU0FBNzcwNkg9bQpDT05G
SUdfUkFESU9fVEVGNjg2Mj1tCkNPTkZJR19SQURJT19XTDEyNzM9bQoKIwojIFRleGFzIElu
c3RydW1lbnRzIFdMMTI4eCBGTSBkcml2ZXIgKFNUIGJhc2VkKQojCiMgQ09ORklHX1JBRElP
X1dMMTI4WCBpcyBub3Qgc2V0CgojCiMgU3VwcG9ydGVkIEZpcmVXaXJlIChJRUVFIDEzOTQp
IEFkYXB0ZXJzCiMKQ09ORklHX0RWQl9GSVJFRFRWPW0KQ09ORklHX0RWQl9GSVJFRFRWX0lO
UFVUPXkKQ09ORklHX0RWQl9CMkMyX0ZMRVhDT1A9bQpDT05GSUdfVklERU9fU0FBNzE0Nj1t
CkNPTkZJR19WSURFT19TQUE3MTQ2X1ZWPW0KQ09ORklHX1NNU19TSUFOT19NRFRWPW0KQ09O
RklHX01FRElBX1NVQkRSVl9BVVRPU0VMRUNUPXkKCiMKIyBNZWRpYSBhbmNpbGxhcnkgZHJp
dmVycyAodHVuZXJzLCBzZW5zb3JzLCBpMmMsIGZyb250ZW5kcykKIwpDT05GSUdfVklERU9f
QlRDWD1tCkNPTkZJR19WSURFT19UVkVFUFJPTT1tCkNPTkZJR19WSURFT19JUl9JMkM9bQoK
IwojIEF1ZGlvIGRlY29kZXJzLCBwcm9jZXNzb3JzIGFuZCBtaXhlcnMKIwpDT05GSUdfVklE
RU9fVFZBVURJTz1tCkNPTkZJR19WSURFT19UREE3NDMyPW0KQ09ORklHX1ZJREVPX1REQTk4
NDA9bQpDT05GSUdfVklERU9fVEVBNjQxNUM9bQpDT05GSUdfVklERU9fVEVBNjQyMD1tCkNP
TkZJR19WSURFT19NU1AzNDAwPW0KQ09ORklHX1ZJREVPX0NTNTM0NT1tCkNPTkZJR19WSURF
T19DUzUzTDMyQT1tCkNPTkZJR19WSURFT19XTTg3NzU9bQpDT05GSUdfVklERU9fV004NzM5
PW0KQ09ORklHX1ZJREVPX1ZQMjdTTVBYPW0KCiMKIyBSRFMgZGVjb2RlcnMKIwpDT05GSUdf
VklERU9fU0FBNjU4OD1tCgojCiMgVmlkZW8gZGVjb2RlcnMKIwpDT05GSUdfVklERU9fQlQ4
MTk9bQpDT05GSUdfVklERU9fQlQ4NTY9bQpDT05GSUdfVklERU9fQlQ4NjY9bQpDT05GSUdf
VklERU9fS1MwMTI3PW0KQ09ORklHX1ZJREVPX1NBQTcxMTA9bQpDT05GSUdfVklERU9fU0FB
NzExWD1tCkNPTkZJR19WSURFT19UVlA1MTUwPW0KQ09ORklHX1ZJREVPX1ZQWDMyMjA9bQoK
IwojIFZpZGVvIGFuZCBhdWRpbyBkZWNvZGVycwojCkNPTkZJR19WSURFT19TQUE3MTdYPW0K
Q09ORklHX1ZJREVPX0NYMjU4NDA9bQoKIwojIE1QRUcgdmlkZW8gZW5jb2RlcnMKIwpDT05G
SUdfVklERU9fQ1gyMzQxWD1tCgojCiMgVmlkZW8gZW5jb2RlcnMKIwpDT05GSUdfVklERU9f
U0FBNzEyNz1tCkNPTkZJR19WSURFT19TQUE3MTg1PW0KQ09ORklHX1ZJREVPX0FEVjcxNzA9
bQpDT05GSUdfVklERU9fQURWNzE3NT1tCgojCiMgQ2FtZXJhIHNlbnNvciBkZXZpY2VzCiMK
Q09ORklHX1ZJREVPX09WNzY3MD1tCkNPTkZJR19WSURFT19NVDlWMDExPW0KCiMKIyBGbGFz
aCBkZXZpY2VzCiMKCiMKIyBWaWRlbyBpbXByb3ZlbWVudCBjaGlwcwojCkNPTkZJR19WSURF
T19VUEQ2NDAzMUE9bQpDT05GSUdfVklERU9fVVBENjQwODM9bQoKIwojIE1pc2NlbGFuZW91
cyBoZWxwZXIgY2hpcHMKIwpDT05GSUdfVklERU9fTTUyNzkwPW0KCiMKIyBTZW5zb3JzIHVz
ZWQgb24gc29jX2NhbWVyYSBkcml2ZXIKIwoKIwojIHNvY19jYW1lcmEgc2Vuc29yIGRyaXZl
cnMKIwpDT05GSUdfU09DX0NBTUVSQV9JTVgwNzQ9bQpDT05GSUdfU09DX0NBTUVSQV9NVDlN
MDAxPW0KQ09ORklHX1NPQ19DQU1FUkFfTVQ5TTExMT1tCkNPTkZJR19TT0NfQ0FNRVJBX01U
OVQwMzE9bQpDT05GSUdfU09DX0NBTUVSQV9NVDlUMTEyPW0KQ09ORklHX1NPQ19DQU1FUkFf
TVQ5VjAyMj1tCkNPTkZJR19TT0NfQ0FNRVJBX09WMjY0MD1tCiMgQ09ORklHX1NPQ19DQU1F
UkFfT1Y1NjQyIGlzIG5vdCBzZXQKQ09ORklHX1NPQ19DQU1FUkFfT1Y2NjUwPW0KQ09ORklH
X1NPQ19DQU1FUkFfT1Y3NzJYPW0KQ09ORklHX1NPQ19DQU1FUkFfT1Y5NjQwPW0KQ09ORklH
X1NPQ19DQU1FUkFfT1Y5NzQwPW0KQ09ORklHX1NPQ19DQU1FUkFfUko1NE4xPW0KQ09ORklH
X1NPQ19DQU1FUkFfVFc5OTEwPW0KQ09ORklHX01FRElBX0FUVEFDSD15CkNPTkZJR19NRURJ
QV9UVU5FUj1tCkNPTkZJR19NRURJQV9UVU5FUl9TSU1QTEU9bQpDT05GSUdfTUVESUFfVFVO
RVJfVERBODI5MD1tCkNPTkZJR19NRURJQV9UVU5FUl9UREE4MjdYPW0KQ09ORklHX01FRElB
X1RVTkVSX1REQTE4MjcxPW0KQ09ORklHX01FRElBX1RVTkVSX1REQTk4ODc9bQpDT05GSUdf
TUVESUFfVFVORVJfVEVBNTc2MT1tCkNPTkZJR19NRURJQV9UVU5FUl9URUE1NzY3PW0KQ09O
RklHX01FRElBX1RVTkVSX01UMjBYWD1tCkNPTkZJR19NRURJQV9UVU5FUl9NVDIwNjA9bQpD
T05GSUdfTUVESUFfVFVORVJfTVQyMDYzPW0KQ09ORklHX01FRElBX1RVTkVSX01UMjI2Nj1t
CkNPTkZJR19NRURJQV9UVU5FUl9NVDIxMzE9bQpDT05GSUdfTUVESUFfVFVORVJfUVQxMDEw
PW0KQ09ORklHX01FRElBX1RVTkVSX1hDMjAyOD1tCkNPTkZJR19NRURJQV9UVU5FUl9YQzUw
MDA9bQpDT05GSUdfTUVESUFfVFVORVJfWEM0MDAwPW0KQ09ORklHX01FRElBX1RVTkVSX01Y
TDUwMDVTPW0KQ09ORklHX01FRElBX1RVTkVSX01YTDUwMDdUPW0KQ09ORklHX01FRElBX1RV
TkVSX01DNDRTODAzPW0KQ09ORklHX01FRElBX1RVTkVSX01BWDIxNjU9bQpDT05GSUdfTUVE
SUFfVFVORVJfVERBMTgyMTg9bQpDT05GSUdfTUVESUFfVFVORVJfRkMwMDExPW0KQ09ORklH
X01FRElBX1RVTkVSX0ZDMDAxMj1tCkNPTkZJR19NRURJQV9UVU5FUl9GQzAwMTM9bQpDT05G
SUdfTUVESUFfVFVORVJfVERBMTgyMTI9bQpDT05GSUdfTUVESUFfVFVORVJfRTQwMDA9bQpD
T05GSUdfTUVESUFfVFVORVJfRkMyNTgwPW0KQ09ORklHX01FRElBX1RVTkVSX1RVQTkwMDE9
bQoKIwojIE11bHRpc3RhbmRhcmQgKHNhdGVsbGl0ZSkgZnJvbnRlbmRzCiMKQ09ORklHX0RW
Ql9TVEIwODk5PW0KQ09ORklHX0RWQl9TVEI2MTAwPW0KQ09ORklHX0RWQl9TVFYwOTB4PW0K
Q09ORklHX0RWQl9TVFY2MTEweD1tCgojCiMgTXVsdGlzdGFuZGFyZCAoY2FibGUgKyB0ZXJy
ZXN0cmlhbCkgZnJvbnRlbmRzCiMKQ09ORklHX0RWQl9EUlhLPW0KQ09ORklHX0RWQl9UREEx
ODI3MUMyREQ9bQoKIwojIERWQi1TIChzYXRlbGxpdGUpIGZyb250ZW5kcwojCkNPTkZJR19E
VkJfQ1gyNDExMD1tCkNPTkZJR19EVkJfQ1gyNDEyMz1tCkNPTkZJR19EVkJfTVQzMTI9bQpD
T05GSUdfRFZCX1pMMTAwMzY9bQpDT05GSUdfRFZCX1pMMTAwMzk9bQpDT05GSUdfRFZCX1M1
SDE0MjA9bQpDT05GSUdfRFZCX1NUVjAyODg9bQpDT05GSUdfRFZCX1NUQjYwMDA9bQpDT05G
SUdfRFZCX1NUVjAyOTk9bQpDT05GSUdfRFZCX1NUVjYxMTA9bQpDT05GSUdfRFZCX1NUVjA5
MDA9bQpDT05GSUdfRFZCX1REQTgwODM9bQpDT05GSUdfRFZCX1REQTEwMDg2PW0KQ09ORklH
X0RWQl9UREE4MjYxPW0KQ09ORklHX0RWQl9WRVMxWDkzPW0KQ09ORklHX0RWQl9UVU5FUl9J
VEQxMDAwPW0KQ09ORklHX0RWQl9UVU5FUl9DWDI0MTEzPW0KQ09ORklHX0RWQl9UREE4MjZY
PW0KQ09ORklHX0RWQl9UVUE2MTAwPW0KQ09ORklHX0RWQl9DWDI0MTE2PW0KQ09ORklHX0RW
Ql9TSTIxWFg9bQpDT05GSUdfRFZCX0RTMzAwMD1tCkNPTkZJR19EVkJfTUI4NkExNj1tCkNP
TkZJR19EVkJfVERBMTAwNzE9bQoKIwojIERWQi1UICh0ZXJyZXN0cmlhbCkgZnJvbnRlbmRz
CiMKQ09ORklHX0RWQl9TUDg4NzA9bQpDT05GSUdfRFZCX1NQODg3WD1tCkNPTkZJR19EVkJf
Q1gyMjcwMD1tCkNPTkZJR19EVkJfQ1gyMjcwMj1tCkNPTkZJR19EVkJfRFJYRD1tCkNPTkZJ
R19EVkJfTDY0NzgxPW0KQ09ORklHX0RWQl9UREExMDA0WD1tCkNPTkZJR19EVkJfTlhUNjAw
MD1tCkNPTkZJR19EVkJfTVQzNTI9bQpDT05GSUdfRFZCX1pMMTAzNTM9bQpDT05GSUdfRFZC
X0RJQjMwMDBNQj1tCkNPTkZJR19EVkJfRElCMzAwME1DPW0KQ09ORklHX0RWQl9ESUI3MDAw
TT1tCkNPTkZJR19EVkJfRElCNzAwMFA9bQpDT05GSUdfRFZCX1REQTEwMDQ4PW0KQ09ORklH
X0RWQl9BRjkwMTM9bQpDT05GSUdfRFZCX0VDMTAwPW0KQ09ORklHX0RWQl9TVFYwMzY3PW0K
Q09ORklHX0RWQl9DWEQyODIwUj1tCkNPTkZJR19EVkJfUlRMMjgzMD1tCkNPTkZJR19EVkJf
UlRMMjgzMj1tCgojCiMgRFZCLUMgKGNhYmxlKSBmcm9udGVuZHMKIwpDT05GSUdfRFZCX1ZF
UzE4MjA9bQpDT05GSUdfRFZCX1REQTEwMDIxPW0KQ09ORklHX0RWQl9UREExMDAyMz1tCkNP
TkZJR19EVkJfU1RWMDI5Nz1tCgojCiMgQVRTQyAoTm9ydGggQW1lcmljYW4vS29yZWFuIFRl
cnJlc3RyaWFsL0NhYmxlIERUVikgZnJvbnRlbmRzCiMKQ09ORklHX0RWQl9OWFQyMDBYPW0K
Q09ORklHX0RWQl9PUjUxMjExPW0KQ09ORklHX0RWQl9PUjUxMTMyPW0KQ09ORklHX0RWQl9C
Q00zNTEwPW0KQ09ORklHX0RWQl9MR0RUMzMwWD1tCkNPTkZJR19EVkJfTEdEVDMzMDU9bQpD
T05GSUdfRFZCX0xHMjE2MD1tCkNPTkZJR19EVkJfUzVIMTQwOT1tCkNPTkZJR19EVkJfQVU4
NTIyPW0KQ09ORklHX0RWQl9BVTg1MjJfRFRWPW0KQ09ORklHX0RWQl9BVTg1MjJfVjRMPW0K
Q09ORklHX0RWQl9TNUgxNDExPW0KCiMKIyBJU0RCLVQgKHRlcnJlc3RyaWFsKSBmcm9udGVu
ZHMKIwpDT05GSUdfRFZCX1M5MjE9bQpDT05GSUdfRFZCX0RJQjgwMDA9bQpDT05GSUdfRFZC
X01CODZBMjBTPW0KCiMKIyBEaWdpdGFsIHRlcnJlc3RyaWFsIG9ubHkgdHVuZXJzL1BMTAoj
CkNPTkZJR19EVkJfUExMPW0KQ09ORklHX0RWQl9UVU5FUl9ESUIwMDcwPW0KQ09ORklHX0RW
Ql9UVU5FUl9ESUIwMDkwPW0KCiMKIyBTRUMgY29udHJvbCBkZXZpY2VzIGZvciBEVkItUwoj
CkNPTkZJR19EVkJfTE5CUDIxPW0KQ09ORklHX0RWQl9MTkJQMjI9bQpDT05GSUdfRFZCX0lT
TDY0MDU9bQpDT05GSUdfRFZCX0lTTDY0MjE9bQpDT05GSUdfRFZCX0lTTDY0MjM9bQpDT05G
SUdfRFZCX0E4MjkzPW0KQ09ORklHX0RWQl9MR1M4R1hYPW0KQ09ORklHX0RWQl9BVEJNODgz
MD1tCkNPTkZJR19EVkJfVERBNjY1eD1tCkNPTkZJR19EVkJfSVgyNTA1Vj1tCkNPTkZJR19E
VkJfSVQ5MTNYX0ZFPW0KQ09ORklHX0RWQl9NODhSUzIwMDA9bQpDT05GSUdfRFZCX0FGOTAz
Mz1tCgojCiMgVG9vbHMgdG8gZGV2ZWxvcCBuZXcgZnJvbnRlbmRzCiMKIyBDT05GSUdfRFZC
X0RVTU1ZX0ZFIGlzIG5vdCBzZXQKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKQ09ORklHX0FH
UD15CiMgQ09ORklHX0FHUF9BTUQ2NCBpcyBub3Qgc2V0CkNPTkZJR19BR1BfSU5URUw9eQoj
IENPTkZJR19BR1BfU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQX1ZJQSBpcyBub3Qgc2V0
CkNPTkZJR19WR0FfQVJCPXkKQ09ORklHX1ZHQV9BUkJfTUFYX0dQVVM9MgpDT05GSUdfVkdB
X1NXSVRDSEVST089eQpDT05GSUdfRFJNPXkKQ09ORklHX0RSTV9VU0I9bQpDT05GSUdfRFJN
X0tNU19IRUxQRVI9bQojIENPTkZJR19EUk1fTE9BRF9FRElEX0ZJUk1XQVJFIGlzIG5vdCBz
ZXQKQ09ORklHX0RSTV9UVE09bQojIENPTkZJR19EUk1fVERGWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0RSTV9SMTI4IGlzIG5vdCBzZXQKQ09ORklHX0RSTV9SQURFT049bQpDT05GSUdfRFJN
X1JBREVPTl9LTVM9eQojIENPTkZJR19EUk1fTk9VVkVBVSBpcyBub3Qgc2V0CgojCiMgSTJD
IGVuY29kZXIgb3IgaGVscGVyIGNoaXBzCiMKQ09ORklHX0RSTV9JMkNfQ0g3MDA2PW0KQ09O
RklHX0RSTV9JMkNfU0lMMTY0PW0KQ09ORklHX0RSTV9JOTE1PW0KQ09ORklHX0RSTV9JOTE1
X0tNUz15CiMgQ09ORklHX0RSTV9NR0EgaXMgbm90IHNldAojIENPTkZJR19EUk1fU0lTIGlz
IG5vdCBzZXQKIyBDT05GSUdfRFJNX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9TQVZB
R0UgaXMgbm90IHNldApDT05GSUdfRFJNX1ZNV0dGWD1tCiMgQ09ORklHX0RSTV9WTVdHRlhf
RkJDT04gaXMgbm90IHNldAojIENPTkZJR19EUk1fR01BNTAwIGlzIG5vdCBzZXQKQ09ORklH
X0RSTV9VREw9bQojIENPTkZJR19EUk1fQVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX01H
QUcyMDAgaXMgbm90IHNldAojIENPTkZJR19EUk1fQ0lSUlVTX1FFTVUgaXMgbm90IHNldAoj
IENPTkZJR19TVFVCX1BPVUxTQk8gaXMgbm90IHNldApDT05GSUdfVkdBU1RBVEU9bQpDT05G
SUdfVklERU9fT1VUUFVUX0NPTlRST0w9bQpDT05GSUdfRkI9eQpDT05GSUdfRklSTVdBUkVf
RURJRD15CkNPTkZJR19GQl9EREM9bQpDT05GSUdfRkJfQk9PVF9WRVNBX1NVUFBPUlQ9eQpD
T05GSUdfRkJfQ0ZCX0ZJTExSRUNUPXkKQ09ORklHX0ZCX0NGQl9DT1BZQVJFQT15CkNPTkZJ
R19GQl9DRkJfSU1BR0VCTElUPXkKIyBDT05GSUdfRkJfQ0ZCX1JFVl9QSVhFTFNfSU5fQllU
RSBpcyBub3Qgc2V0CkNPTkZJR19GQl9TWVNfRklMTFJFQ1Q9bQpDT05GSUdfRkJfU1lTX0NP
UFlBUkVBPW0KQ09ORklHX0ZCX1NZU19JTUFHRUJMSVQ9bQojIENPTkZJR19GQl9GT1JFSUdO
X0VORElBTiBpcyBub3Qgc2V0CkNPTkZJR19GQl9TWVNfRk9QUz1tCiMgQ09ORklHX0ZCX1dN
VF9HRV9ST1BTIGlzIG5vdCBzZXQKQ09ORklHX0ZCX0RFRkVSUkVEX0lPPXkKQ09ORklHX0ZC
X0hFQ1VCQT1tCkNPTkZJR19GQl9TVkdBTElCPW0KIyBDT05GSUdfRkJfTUFDTU9ERVMgaXMg
bm90IHNldApDT05GSUdfRkJfQkFDS0xJR0hUPXkKQ09ORklHX0ZCX01PREVfSEVMUEVSUz15
CkNPTkZJR19GQl9USUxFQkxJVFRJTkc9eQoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBk
cml2ZXJzCiMKQ09ORklHX0ZCX0NJUlJVUz1tCkNPTkZJR19GQl9QTTI9bQpDT05GSUdfRkJf
UE0yX0ZJRk9fRElTQ09OTkVDVD15CkNPTkZJR19GQl9DWUJFUjIwMDA9bQpDT05GSUdfRkJf
Q1lCRVIyMDAwX0REQz15CkNPTkZJR19GQl9BUkM9bQojIENPTkZJR19GQl9BU0lMSUFOVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX0lNU1RUIGlzIG5vdCBzZXQKQ09ORklHX0ZCX1ZHQTE2
PW0KQ09ORklHX0ZCX1VWRVNBPW0KQ09ORklHX0ZCX1ZFU0E9eQpDT05GSUdfRkJfRUZJPXkK
Q09ORklHX0ZCX040MTE9bQpDT05GSUdfRkJfSEdBPW0KQ09ORklHX0ZCX1MxRDEzWFhYPW0K
IyBDT05GSUdfRkJfTlZJRElBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUklWQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZCX0k3NDAgaXMgbm90IHNldApDT05GSUdfRkJfTEU4MDU3OD1tCkNP
TkZJR19GQl9DQVJJTExPX1JBTkNIPW0KQ09ORklHX0ZCX01BVFJPWD1tCkNPTkZJR19GQl9N
QVRST1hfTUlMTEVOSVVNPXkKQ09ORklHX0ZCX01BVFJPWF9NWVNUSVFVRT15CkNPTkZJR19G
Ql9NQVRST1hfRz15CkNPTkZJR19GQl9NQVRST1hfSTJDPW0KQ09ORklHX0ZCX01BVFJPWF9N
QVZFTj1tCkNPTkZJR19GQl9SQURFT049bQpDT05GSUdfRkJfUkFERU9OX0kyQz15CkNPTkZJ
R19GQl9SQURFT05fQkFDS0xJR0hUPXkKIyBDT05GSUdfRkJfUkFERU9OX0RFQlVHIGlzIG5v
dCBzZXQKQ09ORklHX0ZCX0FUWTEyOD1tCkNPTkZJR19GQl9BVFkxMjhfQkFDS0xJR0hUPXkK
Q09ORklHX0ZCX0FUWT1tCkNPTkZJR19GQl9BVFlfQ1Q9eQojIENPTkZJR19GQl9BVFlfR0VO
RVJJQ19MQ0QgaXMgbm90IHNldApDT05GSUdfRkJfQVRZX0dYPXkKQ09ORklHX0ZCX0FUWV9C
QUNLTElHSFQ9eQpDT05GSUdfRkJfUzM9bQpDT05GSUdfRkJfUzNfRERDPXkKQ09ORklHX0ZC
X1NBVkFHRT1tCiMgQ09ORklHX0ZCX1NBVkFHRV9JMkMgaXMgbm90IHNldAojIENPTkZJR19G
Ql9TQVZBR0VfQUNDRUwgaXMgbm90IHNldApDT05GSUdfRkJfU0lTPW0KQ09ORklHX0ZCX1NJ
U18zMDA9eQpDT05GSUdfRkJfU0lTXzMxNT15CkNPTkZJR19GQl9WSUE9bQojIENPTkZJR19G
Ql9WSUFfRElSRUNUX1BST0NGUyBpcyBub3Qgc2V0CkNPTkZJR19GQl9WSUFfWF9DT01QQVRJ
QklMSVRZPXkKQ09ORklHX0ZCX05FT01BR0lDPW0KQ09ORklHX0ZCX0tZUk89bQpDT05GSUdf
RkJfM0RGWD1tCiMgQ09ORklHX0ZCXzNERlhfQUNDRUwgaXMgbm90IHNldApDT05GSUdfRkJf
M0RGWF9JMkM9eQpDT05GSUdfRkJfVk9PRE9PMT1tCkNPTkZJR19GQl9WVDg2MjM9bQpDT05G
SUdfRkJfVFJJREVOVD1tCkNPTkZJR19GQl9BUks9bQpDT05GSUdfRkJfUE0zPW0KIyBDT05G
SUdfRkJfQ0FSTUlORSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0dFT0RFIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfVE1JTyBpcyBub3Qgc2V0CkNPTkZJR19GQl9TTTUwMT1tCiMgQ09ORklH
X0ZCX1NNU0NVRlggaXMgbm90IHNldApDT05GSUdfRkJfVURMPW0KQ09ORklHX0ZCX1ZJUlRV
QUw9bQpDT05GSUdfRkJfTUVUUk9OT01FPW0KQ09ORklHX0ZCX01CODYyWFg9bQpDT05GSUdf
RkJfTUI4NjJYWF9QQ0lfR0RDPXkKQ09ORklHX0ZCX01CODYyWFhfSTJDPXkKIyBDT05GSUdf
RkJfQlJPQURTSEVFVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FVT19LMTkwWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0VYWU5PU19WSURFTyBpcyBub3Qgc2V0CkNPTkZJR19CQUNLTElHSFRf
TENEX1NVUFBPUlQ9eQojIENPTkZJR19MQ0RfQ0xBU1NfREVWSUNFIGlzIG5vdCBzZXQKQ09O
RklHX0JBQ0tMSUdIVF9DTEFTU19ERVZJQ0U9eQpDT05GSUdfQkFDS0xJR0hUX0dFTkVSSUM9
bQpDT05GSUdfQkFDS0xJR0hUX1BXTT1tCkNPTkZJR19CQUNLTElHSFRfQVBQTEU9bQpDT05G
SUdfQkFDS0xJR0hUX1NBSEFSQT1tCkNPTkZJR19CQUNLTElHSFRfQURQODg2MD1tCkNPTkZJ
R19CQUNLTElHSFRfQURQODg3MD1tCkNPTkZJR19CQUNLTElHSFRfUENGNTA2MzM9bQpDT05G
SUdfQkFDS0xJR0hUX0xNMzYzMD1tCkNPTkZJR19CQUNLTElHSFRfTE0zNjM5PW0KQ09ORklH
X0JBQ0tMSUdIVF9MUDg1NVg9bQoKIwojIENvbnNvbGUgZGlzcGxheSBkcml2ZXIgc3VwcG9y
dAojCkNPTkZJR19WR0FfQ09OU09MRT15CiMgQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJB
Q0sgaXMgbm90IHNldApDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFNRUJVRkZF
Ul9DT05TT0xFPXkKQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfREVURUNUX1BSSU1BUlk9
eQpDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ST1RBVElPTj15CiMgQ09ORklHX0ZPTlRT
IGlzIG5vdCBzZXQKQ09ORklHX0ZPTlRfOHg4PXkKQ09ORklHX0ZPTlRfOHgxNj15CkNPTkZJ
R19MT0dPPXkKIyBDT05GSUdfTE9HT19MSU5VWF9NT05PIGlzIG5vdCBzZXQKIyBDT05GSUdf
TE9HT19MSU5VWF9WR0ExNiBpcyBub3Qgc2V0CkNPTkZJR19MT0dPX0xJTlVYX0NMVVQyMjQ9
eQpDT05GSUdfU09VTkQ9bQpDT05GSUdfU09VTkRfT1NTX0NPUkU9eQojIENPTkZJR19TT1VO
RF9PU1NfQ09SRV9QUkVDTEFJTSBpcyBub3Qgc2V0CkNPTkZJR19TTkQ9bQpDT05GSUdfU05E
X1RJTUVSPW0KQ09ORklHX1NORF9QQ009bQpDT05GSUdfU05EX0hXREVQPW0KQ09ORklHX1NO
RF9SQVdNSURJPW0KQ09ORklHX1NORF9KQUNLPXkKQ09ORklHX1NORF9TRVFVRU5DRVI9bQpD
T05GSUdfU05EX1NFUV9EVU1NWT1tCkNPTkZJR19TTkRfT1NTRU1VTD15CkNPTkZJR19TTkRf
TUlYRVJfT1NTPW0KQ09ORklHX1NORF9QQ01fT1NTPW0KQ09ORklHX1NORF9QQ01fT1NTX1BM
VUdJTlM9eQojIENPTkZJR19TTkRfU0VRVUVOQ0VSX09TUyBpcyBub3Qgc2V0CkNPTkZJR19T
TkRfSFJUSU1FUj1tCkNPTkZJR19TTkRfU0VRX0hSVElNRVJfREVGQVVMVD15CkNPTkZJR19T
TkRfRFlOQU1JQ19NSU5PUlM9eQpDT05GSUdfU05EX1NVUFBPUlRfT0xEX0FQST15CkNPTkZJ
R19TTkRfVkVSQk9TRV9QUk9DRlM9eQojIENPTkZJR19TTkRfVkVSQk9TRV9QUklOVEsgaXMg
bm90IHNldAojIENPTkZJR19TTkRfREVCVUcgaXMgbm90IHNldApDT05GSUdfU05EX1ZNQVNU
RVI9eQpDT05GSUdfU05EX0tDVExfSkFDSz15CkNPTkZJR19TTkRfRE1BX1NHQlVGPXkKQ09O
RklHX1NORF9SQVdNSURJX1NFUT1tCkNPTkZJR19TTkRfT1BMM19MSUJfU0VRPW0KIyBDT05G
SUdfU05EX09QTDRfTElCX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TQkFXRV9TRVEg
aXMgbm90IHNldApDT05GSUdfU05EX0VNVTEwSzFfU0VRPW0KQ09ORklHX1NORF9NUFU0MDFf
VUFSVD1tCkNPTkZJR19TTkRfT1BMM19MSUI9bQpDT05GSUdfU05EX1ZYX0xJQj1tCkNPTkZJ
R19TTkRfQUM5N19DT0RFQz1tCkNPTkZJR19TTkRfRFJJVkVSUz15CkNPTkZJR19TTkRfUENT
UD1tCkNPTkZJR19TTkRfRFVNTVk9bQpDT05GSUdfU05EX0FMT09QPW0KQ09ORklHX1NORF9W
SVJNSURJPW0KQ09ORklHX1NORF9NVFBBVj1tCkNPTkZJR19TTkRfU0VSSUFMX1UxNjU1MD1t
CkNPTkZJR19TTkRfTVBVNDAxPW0KQ09ORklHX1NORF9BQzk3X1BPV0VSX1NBVkU9eQpDT05G
SUdfU05EX0FDOTdfUE9XRVJfU0FWRV9ERUZBVUxUPTAKQ09ORklHX1NORF9TQl9DT01NT049
bQpDT05GSUdfU05EX1NCMTZfRFNQPW0KQ09ORklHX1NORF9URUE1NzVYPW0KQ09ORklHX1NO
RF9QQ0k9eQpDT05GSUdfU05EX0FEMTg4OT1tCkNPTkZJR19TTkRfQUxTMzAwPW0KQ09ORklH
X1NORF9BTFM0MDAwPW0KQ09ORklHX1NORF9BTEk1NDUxPW0KQ09ORklHX1NORF9BU0lIUEk9
bQpDT05GSUdfU05EX0FUSUlYUD1tCkNPTkZJR19TTkRfQVRJSVhQX01PREVNPW0KQ09ORklH
X1NORF9BVTg4MTA9bQpDT05GSUdfU05EX0FVODgyMD1tCkNPTkZJR19TTkRfQVU4ODMwPW0K
IyBDT05GSUdfU05EX0FXMiBpcyBub3Qgc2V0CkNPTkZJR19TTkRfQVpUMzMyOD1tCkNPTkZJ
R19TTkRfQlQ4N1g9bQojIENPTkZJR19TTkRfQlQ4N1hfT1ZFUkNMT0NLIGlzIG5vdCBzZXQK
Q09ORklHX1NORF9DQTAxMDY9bQpDT05GSUdfU05EX0NNSVBDST1tCkNPTkZJR19TTkRfT1hZ
R0VOX0xJQj1tCkNPTkZJR19TTkRfT1hZR0VOPW0KQ09ORklHX1NORF9DUzQyODE9bQpDT05G
SUdfU05EX0NTNDZYWD1tCkNPTkZJR19TTkRfQ1M0NlhYX05FV19EU1A9eQpDT05GSUdfU05E
X0NTNTUzMD1tCkNPTkZJR19TTkRfQ1M1NTM1QVVESU89bQpDT05GSUdfU05EX0NUWEZJPW0K
Q09ORklHX1NORF9EQVJMQTIwPW0KQ09ORklHX1NORF9HSU5BMjA9bQpDT05GSUdfU05EX0xB
WUxBMjA9bQpDT05GSUdfU05EX0RBUkxBMjQ9bQpDT05GSUdfU05EX0dJTkEyND1tCkNPTkZJ
R19TTkRfTEFZTEEyND1tCkNPTkZJR19TTkRfTU9OQT1tCkNPTkZJR19TTkRfTUlBPW0KQ09O
RklHX1NORF9FQ0hPM0c9bQpDT05GSUdfU05EX0lORElHTz1tCkNPTkZJR19TTkRfSU5ESUdP
SU89bQpDT05GSUdfU05EX0lORElHT0RKPW0KQ09ORklHX1NORF9JTkRJR09JT1g9bQpDT05G
SUdfU05EX0lORElHT0RKWD1tCkNPTkZJR19TTkRfRU1VMTBLMT1tCkNPTkZJR19TTkRfRU1V
MTBLMVg9bQpDT05GSUdfU05EX0VOUzEzNzA9bQpDT05GSUdfU05EX0VOUzEzNzE9bQpDT05G
SUdfU05EX0VTMTkzOD1tCkNPTkZJR19TTkRfRVMxOTY4PW0KQ09ORklHX1NORF9FUzE5Njhf
SU5QVVQ9eQpDT05GSUdfU05EX0VTMTk2OF9SQURJTz15CkNPTkZJR19TTkRfRk04MDE9bQpD
T05GSUdfU05EX0ZNODAxX1RFQTU3NVhfQk9PTD15CkNPTkZJR19TTkRfSERBX0lOVEVMPW0K
Q09ORklHX1NORF9IREFfUFJFQUxMT0NfU0laRT02NApDT05GSUdfU05EX0hEQV9IV0RFUD15
CkNPTkZJR19TTkRfSERBX1JFQ09ORklHPXkKQ09ORklHX1NORF9IREFfSU5QVVRfQkVFUD15
CkNPTkZJR19TTkRfSERBX0lOUFVUX0JFRVBfTU9ERT0xCkNPTkZJR19TTkRfSERBX0lOUFVU
X0pBQ0s9eQpDT05GSUdfU05EX0hEQV9QQVRDSF9MT0FERVI9eQpDT05GSUdfU05EX0hEQV9D
T0RFQ19SRUFMVEVLPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQU5BTE9HPXkKQ09ORklHX1NO
RF9IREFfQ09ERUNfU0lHTUFURUw9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19WSUE9eQpDT05G
SUdfU05EX0hEQV9DT0RFQ19IRE1JPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQ0lSUlVTPXkK
Q09ORklHX1NORF9IREFfQ09ERUNfQ09ORVhBTlQ9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19D
QTAxMTA9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19DQTAxMzI9eQpDT05GSUdfU05EX0hEQV9D
T0RFQ19DTUVESUE9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19TSTMwNTQ9eQpDT05GSUdfU05E
X0hEQV9HRU5FUklDPXkKQ09ORklHX1NORF9IREFfUE9XRVJfU0FWRV9ERUZBVUxUPTAKQ09O
RklHX1NORF9IRFNQPW0KQ09ORklHX1NORF9IRFNQTT1tCkNPTkZJR19TTkRfSUNFMTcxMj1t
CkNPTkZJR19TTkRfSUNFMTcyND1tCkNPTkZJR19TTkRfSU5URUw4WDA9bQpDT05GSUdfU05E
X0lOVEVMOFgwTT1tCkNPTkZJR19TTkRfS09SRzEyMTI9bQpDT05GSUdfU05EX0xPTEE9bQpD
T05GSUdfU05EX0xYNjQ2NEVTPW0KQ09ORklHX1NORF9NQUVTVFJPMz1tCkNPTkZJR19TTkRf
TUFFU1RSTzNfSU5QVVQ9eQpDT05GSUdfU05EX01JWEFSVD1tCkNPTkZJR19TTkRfTk0yNTY9
bQpDT05GSUdfU05EX1BDWEhSPW0KQ09ORklHX1NORF9SSVBUSURFPW0KQ09ORklHX1NORF9S
TUUzMj1tCkNPTkZJR19TTkRfUk1FOTY9bQpDT05GSUdfU05EX1JNRTk2NTI9bQpDT05GSUdf
U05EX1NPTklDVklCRVM9bQpDT05GSUdfU05EX1RSSURFTlQ9bQpDT05GSUdfU05EX1ZJQTgy
WFg9bQpDT05GSUdfU05EX1ZJQTgyWFhfTU9ERU09bQpDT05GSUdfU05EX1ZJUlRVT1NPPW0K
Q09ORklHX1NORF9WWDIyMj1tCkNPTkZJR19TTkRfWU1GUENJPW0KIyBDT05GSUdfU05EX1NQ
SSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfVVNCPXkKQ09ORklHX1NORF9VU0JfQVVESU89bQpD
T05GSUdfU05EX1VTQl9VQTEwMT1tCkNPTkZJR19TTkRfVVNCX1VTWDJZPW0KQ09ORklHX1NO
RF9VU0JfQ0FJQVE9bQpDT05GSUdfU05EX1VTQl9DQUlBUV9JTlBVVD15CkNPTkZJR19TTkRf
VVNCX1VTMTIyTD1tCkNPTkZJR19TTkRfVVNCXzZGSVJFPW0KQ09ORklHX1NORF9GSVJFV0lS
RT15CkNPTkZJR19TTkRfRklSRVdJUkVfTElCPW0KQ09ORklHX1NORF9GSVJFV0lSRV9TUEVB
S0VSUz1tCkNPTkZJR19TTkRfSVNJR0hUPW0KIyBDT05GSUdfU05EX1NPQyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NPVU5EX1BSSU1FIGlzIG5vdCBzZXQKQ09ORklHX0FDOTdfQlVTPW0KCiMK
IyBISUQgc3VwcG9ydAojCkNPTkZJR19ISUQ9bQpDT05GSUdfSElEUkFXPXkKQ09ORklHX1VI
SUQ9bQpDT05GSUdfSElEX0dFTkVSSUM9bQoKIwojIFNwZWNpYWwgSElEIGRyaXZlcnMKIwpD
T05GSUdfSElEX0E0VEVDSD1tCkNPTkZJR19ISURfQUNSVVg9bQpDT05GSUdfSElEX0FDUlVY
X0ZGPXkKQ09ORklHX0hJRF9BUFBMRT1tCkNPTkZJR19ISURfQVVSRUFMPW0KQ09ORklHX0hJ
RF9CRUxLSU49bQpDT05GSUdfSElEX0NIRVJSWT1tCkNPTkZJR19ISURfQ0hJQ09OWT1tCkNP
TkZJR19ISURfUFJPRElLRVlTPW0KQ09ORklHX0hJRF9DWVBSRVNTPW0KQ09ORklHX0hJRF9E
UkFHT05SSVNFPW0KQ09ORklHX0RSQUdPTlJJU0VfRkY9eQpDT05GSUdfSElEX0VNU19GRj1t
CkNPTkZJR19ISURfRUxFQ09NPW0KQ09ORklHX0hJRF9FWktFWT1tCkNPTkZJR19ISURfSE9M
VEVLPW0KIyBDT05GSUdfSE9MVEVLX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9LRVlUT1VD
SD1tCkNPTkZJR19ISURfS1lFPW0KQ09ORklHX0hJRF9VQ0xPR0lDPW0KQ09ORklHX0hJRF9X
QUxUT1A9bQpDT05GSUdfSElEX0dZUkFUSU9OPW0KQ09ORklHX0hJRF9UV0lOSEFOPW0KQ09O
RklHX0hJRF9LRU5TSU5HVE9OPW0KQ09ORklHX0hJRF9MQ1BPV0VSPW0KQ09ORklHX0hJRF9M
RU5PVk9fVFBLQkQ9bQpDT05GSUdfSElEX0xPR0lURUNIPW0KQ09ORklHX0hJRF9MT0dJVEVD
SF9ESj1tCkNPTkZJR19MT0dJVEVDSF9GRj15CkNPTkZJR19MT0dJUlVNQkxFUEFEMl9GRj15
CkNPTkZJR19MT0dJRzk0MF9GRj15CkNPTkZJR19MT0dJV0hFRUxTX0ZGPXkKQ09ORklHX0hJ
RF9NQUdJQ01PVVNFPW0KQ09ORklHX0hJRF9NSUNST1NPRlQ9bQpDT05GSUdfSElEX01PTlRF
UkVZPW0KQ09ORklHX0hJRF9NVUxUSVRPVUNIPW0KQ09ORklHX0hJRF9OVFJJRz1tCkNPTkZJ
R19ISURfT1JURUs9bQpDT05GSUdfSElEX1BBTlRIRVJMT1JEPW0KQ09ORklHX1BBTlRIRVJM
T1JEX0ZGPXkKQ09ORklHX0hJRF9QRVRBTFlOWD1tCkNPTkZJR19ISURfUElDT0xDRD1tCkNP
TkZJR19ISURfUElDT0xDRF9GQj15CkNPTkZJR19ISURfUElDT0xDRF9CQUNLTElHSFQ9eQpD
T05GSUdfSElEX1BJQ09MQ0RfTEVEUz15CkNPTkZJR19ISURfUElDT0xDRF9DSVI9eQpDT05G
SUdfSElEX1BSSU1BWD1tCkNPTkZJR19ISURfUFMzUkVNT1RFPW0KQ09ORklHX0hJRF9ST0ND
QVQ9bQpDT05GSUdfSElEX1NBSVRFSz1tCkNPTkZJR19ISURfU0FNU1VORz1tCkNPTkZJR19I
SURfU09OWT1tCkNPTkZJR19ISURfU1BFRURMSU5LPW0KQ09ORklHX0hJRF9TVU5QTFVTPW0K
Q09ORklHX0hJRF9HUkVFTkFTSUE9bQpDT05GSUdfR1JFRU5BU0lBX0ZGPXkKQ09ORklHX0hJ
RF9IWVBFUlZfTU9VU0U9bQpDT05GSUdfSElEX1NNQVJUSk9ZUExVUz1tCkNPTkZJR19TTUFS
VEpPWVBMVVNfRkY9eQpDT05GSUdfSElEX1RJVk89bQpDT05GSUdfSElEX1RPUFNFRUQ9bQpD
T05GSUdfSElEX1RIUlVTVE1BU1RFUj1tCkNPTkZJR19USFJVU1RNQVNURVJfRkY9eQpDT05G
SUdfSElEX1dBQ09NPW0KQ09ORklHX0hJRF9XSUlNT1RFPW0KQ09ORklHX0hJRF9XSUlNT1RF
X0VYVD15CkNPTkZJR19ISURfWkVST1BMVVM9bQpDT05GSUdfWkVST1BMVVNfRkY9eQpDT05G
SUdfSElEX1pZREFDUk9OPW0KQ09ORklHX0hJRF9TRU5TT1JfSFVCPW0KCiMKIyBVU0IgSElE
IHN1cHBvcnQKIwpDT05GSUdfVVNCX0hJRD1tCkNPTkZJR19ISURfUElEPXkKQ09ORklHX1VT
Ql9ISURERVY9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX09IQ0k9eQpDT05GSUdfVVNCX0FSQ0hf
SEFTX0VIQ0k9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX1hIQ0k9eQpDT05GSUdfVVNCX1NVUFBP
UlQ9eQpDT05GSUdfVVNCX0NPTU1PTj1tCkNPTkZJR19VU0JfQVJDSF9IQVNfSENEPXkKQ09O
RklHX1VTQj1tCiMgQ09ORklHX1VTQl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfQU5O
T1VOQ0VfTkVXX0RFVklDRVM9eQoKIwojIE1pc2NlbGxhbmVvdXMgVVNCIG9wdGlvbnMKIwpD
T05GSUdfVVNCX0RZTkFNSUNfTUlOT1JTPXkKQ09ORklHX1VTQl9TVVNQRU5EPXkKIyBDT05G
SUdfVVNCX09URyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9EV0MzIGlzIG5vdCBzZXQKQ09O
RklHX1VTQl9NT049bQpDT05GSUdfVVNCX1dVU0I9bQpDT05GSUdfVVNCX1dVU0JfQ0JBRj1t
CiMgQ09ORklHX1VTQl9XVVNCX0NCQUZfREVCVUcgaXMgbm90IHNldAoKIwojIFVTQiBIb3N0
IENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklHX1VTQl9DNjdYMDBfSENEIGlzIG5vdCBz
ZXQKQ09ORklHX1VTQl9YSENJX0hDRD1tCiMgQ09ORklHX1VTQl9YSENJX0hDRF9ERUJVR0dJ
TkcgaXMgbm90IHNldApDT05GSUdfVVNCX0VIQ0lfSENEPW0KQ09ORklHX1VTQl9FSENJX1JP
T1RfSFVCX1RUPXkKQ09ORklHX1VTQl9FSENJX1RUX05FV1NDSEVEPXkKIyBDT05GSUdfVVNC
X09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMTZYX0hDRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxNzYwX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9JU1AxMzYyX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PSENJX0hDRCBpcyBub3Qg
c2V0CkNPTkZJR19VU0JfRUhDSV9IQ0RfUExBVEZPUk09eQpDT05GSUdfVVNCX1VIQ0lfSENE
PW0KIyBDT05GSUdfVVNCX1UxMzJfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TTDgxMV9I
Q0Q9bQojIENPTkZJR19VU0JfU0w4MTFfSENEX0lTTyBpcyBub3Qgc2V0CkNPTkZJR19VU0Jf
UjhBNjY1OTdfSENEPW0KQ09ORklHX1VTQl9XSENJX0hDRD1tCkNPTkZJR19VU0JfSFdBX0hD
RD1tCkNPTkZJR19VU0JfSENEX0JDTUE9bQojIENPTkZJR19VU0JfSENEX1NTQiBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9NVVNCX0hEUkMgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ0hJ
UElERUEgaXMgbm90IHNldAojIENPTkZJR19VU0JfUkVORVNBU19VU0JIUyBpcyBub3Qgc2V0
CgojCiMgVVNCIERldmljZSBDbGFzcyBkcml2ZXJzCiMKQ09ORklHX1VTQl9BQ009bQpDT05G
SUdfVVNCX1BSSU5URVI9bQpDT05GSUdfVVNCX1dETT1tCkNPTkZJR19VU0JfVE1DPW0KCiMK
IyBOT1RFOiBVU0JfU1RPUkFHRSBkZXBlbmRzIG9uIFNDU0kgYnV0IEJMS19ERVZfU0QgbWF5
CiMKCiMKIyBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1vcmUg
aW5mbwojCkNPTkZJR19VU0JfU1RPUkFHRT1tCiMgQ09ORklHX1VTQl9TVE9SQUdFX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TVE9SQUdFX1JFQUxURUs9bQpDT05GSUdfUkVBTFRF
S19BVVRPUE09eQpDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQj1tCkNPTkZJR19VU0JfU1RP
UkFHRV9GUkVFQ09NPW0KQ09ORklHX1VTQl9TVE9SQUdFX0lTRDIwMD1tCkNPTkZJR19VU0Jf
U1RPUkFHRV9VU0JBVD1tCkNPTkZJR19VU0JfU1RPUkFHRV9TRERSMDk9bQpDT05GSUdfVVNC
X1NUT1JBR0VfU0REUjU1PW0KQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9UPW0KQ09ORklH
X1VTQl9TVE9SQUdFX0FMQVVEQT1tCkNPTkZJR19VU0JfU1RPUkFHRV9PTkVUT1VDSD1tCkNP
TkZJR19VU0JfU1RPUkFHRV9LQVJNQT1tCkNPTkZJR19VU0JfU1RPUkFHRV9DWVBSRVNTX0FU
QUNCPW0KQ09ORklHX1VTQl9TVE9SQUdFX0VORV9VQjYyNTA9bQoKIwojIFVTQiBJbWFnaW5n
IGRldmljZXMKIwpDT05GSUdfVVNCX01EQzgwMD1tCkNPTkZJR19VU0JfTUlDUk9URUs9bQoK
IwojIFVTQiBwb3J0IGRyaXZlcnMKIwpDT05GSUdfVVNCX1NFUklBTD1tCkNPTkZJR19VU0Jf
U0VSSUFMX0dFTkVSSUM9eQpDT05GSUdfVVNCX1NFUklBTF9BSVJDQUJMRT1tCkNPTkZJR19V
U0JfU0VSSUFMX0FSSzMxMTY9bQpDT05GSUdfVVNCX1NFUklBTF9CRUxLSU49bQpDT05GSUdf
VVNCX1NFUklBTF9DSDM0MT1tCkNPTkZJR19VU0JfU0VSSUFMX1dISVRFSEVBVD1tCkNPTkZJ
R19VU0JfU0VSSUFMX0RJR0lfQUNDRUxFUE9SVD1tCkNPTkZJR19VU0JfU0VSSUFMX0NQMjEw
WD1tCkNPTkZJR19VU0JfU0VSSUFMX0NZUFJFU1NfTTg9bQpDT05GSUdfVVNCX1NFUklBTF9F
TVBFRz1tCkNPTkZJR19VU0JfU0VSSUFMX0ZURElfU0lPPW0KQ09ORklHX1VTQl9TRVJJQUxf
RlVOU09GVD1tCkNPTkZJR19VU0JfU0VSSUFMX1ZJU09SPW0KQ09ORklHX1VTQl9TRVJJQUxf
SVBBUT1tCkNPTkZJR19VU0JfU0VSSUFMX0lSPW0KQ09ORklHX1VTQl9TRVJJQUxfRURHRVBP
UlQ9bQpDT05GSUdfVVNCX1NFUklBTF9FREdFUE9SVF9UST1tCkNPTkZJR19VU0JfU0VSSUFM
X0Y4MTIzMj1tCkNPTkZJR19VU0JfU0VSSUFMX0dBUk1JTj1tCkNPTkZJR19VU0JfU0VSSUFM
X0lQVz1tCkNPTkZJR19VU0JfU0VSSUFMX0lVVT1tCkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQ
QU5fUERBPW0KQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTj1tCkNPTkZJR19VU0JfU0VSSUFM
X0tMU0k9bQpDT05GSUdfVVNCX1NFUklBTF9LT0JJTF9TQ1Q9bQpDT05GSUdfVVNCX1NFUklB
TF9NQ1RfVTIzMj1tCkNPTkZJR19VU0JfU0VSSUFMX01FVFJPPW0KQ09ORklHX1VTQl9TRVJJ
QUxfTU9TNzcyMD1tCkNPTkZJR19VU0JfU0VSSUFMX01PUzc4NDA9bQpDT05GSUdfVVNCX1NF
UklBTF9NT1RPUk9MQT1tCkNPTkZJR19VU0JfU0VSSUFMX05BVk1BTj1tCkNPTkZJR19VU0Jf
U0VSSUFMX1BMMjMwMz1tCkNPTkZJR19VU0JfU0VSSUFMX09USTY4NTg9bQpDT05GSUdfVVNC
X1NFUklBTF9RQ0FVWD1tCkNPTkZJR19VU0JfU0VSSUFMX1FVQUxDT01NPW0KQ09ORklHX1VT
Ql9TRVJJQUxfU1BDUDhYNT1tCkNPTkZJR19VU0JfU0VSSUFMX0hQNFg9bQpDT05GSUdfVVNC
X1NFUklBTF9TQUZFPW0KIyBDT05GSUdfVVNCX1NFUklBTF9TQUZFX1BBRERFRCBpcyBub3Qg
c2V0CkNPTkZJR19VU0JfU0VSSUFMX1NJRU1FTlNfTVBJPW0KQ09ORklHX1VTQl9TRVJJQUxf
U0lFUlJBV0lSRUxFU1M9bQpDT05GSUdfVVNCX1NFUklBTF9TWU1CT0w9bQpDT05GSUdfVVNC
X1NFUklBTF9UST1tCkNPTkZJR19VU0JfU0VSSUFMX0NZQkVSSkFDSz1tCkNPTkZJR19VU0Jf
U0VSSUFMX1hJUkNPTT1tCkNPTkZJR19VU0JfU0VSSUFMX1dXQU49bQpDT05GSUdfVVNCX1NF
UklBTF9PUFRJT049bQpDT05GSUdfVVNCX1NFUklBTF9PTU5JTkVUPW0KQ09ORklHX1VTQl9T
RVJJQUxfT1BUSUNPTj1tCkNPTkZJR19VU0JfU0VSSUFMX1ZJVk9QQVlfU0VSSUFMPW0KQ09O
RklHX1VTQl9TRVJJQUxfWklPPW0KQ09ORklHX1VTQl9TRVJJQUxfWlRFPW0KQ09ORklHX1VT
Ql9TRVJJQUxfU1NVMTAwPW0KQ09ORklHX1VTQl9TRVJJQUxfUVQyPW0KQ09ORklHX1VTQl9T
RVJJQUxfREVCVUc9bQoKIwojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMKIwpDT05GSUdf
VVNCX0VNSTYyPW0KQ09ORklHX1VTQl9FTUkyNj1tCkNPTkZJR19VU0JfQURVVFVYPW0KQ09O
RklHX1VTQl9TRVZTRUc9bQpDT05GSUdfVVNCX1JJTzUwMD1tCkNPTkZJR19VU0JfTEVHT1RP
V0VSPW0KQ09ORklHX1VTQl9MQ0Q9bQpDT05GSUdfVVNCX0xFRD1tCkNPTkZJR19VU0JfQ1lQ
UkVTU19DWTdDNjM9bQpDT05GSUdfVVNCX0NZVEhFUk09bQpDT05GSUdfVVNCX0lETU9VU0U9
bQpDT05GSUdfVVNCX0ZURElfRUxBTj1tCkNPTkZJR19VU0JfQVBQTEVESVNQTEFZPW0KQ09O
RklHX1VTQl9TSVNVU0JWR0E9bQpDT05GSUdfVVNCX1NJU1VTQlZHQV9DT049eQpDT05GSUdf
VVNCX0xEPW0KQ09ORklHX1VTQl9UUkFOQ0VWSUJSQVRPUj1tCkNPTkZJR19VU0JfSU9XQVJS
SU9SPW0KQ09ORklHX1VTQl9URVNUPW0KQ09ORklHX1VTQl9JU0lHSFRGVz1tCkNPTkZJR19V
U0JfWVVSRVg9bQpDT05GSUdfVVNCX0VaVVNCX0ZYMj1tCgojCiMgVVNCIFBoeXNpY2FsIExh
eWVyIGRyaXZlcnMKIwojIENPTkZJR19PTUFQX1VTQjIgaXMgbm90IHNldAojIENPTkZJR19V
U0JfSVNQMTMwMSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfQVRNPW0KQ09ORklHX1VTQl9TUEVF
RFRPVUNIPW0KQ09ORklHX1VTQl9DWEFDUlU9bQpDT05GSUdfVVNCX1VFQUdMRUFUTT1tCkNP
TkZJR19VU0JfWFVTQkFUTT1tCkNPTkZJR19VU0JfR0FER0VUPW0KIyBDT05GSUdfVVNCX0dB
REdFVF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfREVCVUdfRklMRVMg
aXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX0RFQlVHX0ZTIGlzIG5vdCBzZXQKQ09O
RklHX1VTQl9HQURHRVRfVkJVU19EUkFXPTIKQ09ORklHX1VTQl9HQURHRVRfU1RPUkFHRV9O
VU1fQlVGRkVSUz0yCgojCiMgVVNCIFBlcmlwaGVyYWwgQ29udHJvbGxlcgojCiMgQ09ORklH
X1VTQl9SOEE2NjU5NyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NVl9VREMgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfTTY2NTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FNRDU1MzZV
REMgaXMgbm90IHNldAojIENPTkZJR19VU0JfTkVUMjI3MiBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9ORVQyMjgwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dPS1UgaXMgbm90IHNldApD
T05GSUdfVVNCX0VHMjBUPW0KIyBDT05GSUdfVVNCX0RVTU1ZX0hDRCBpcyBub3Qgc2V0CkNP
TkZJR19VU0JfTElCQ09NUE9TSVRFPW0KIyBDT05GSUdfVVNCX1pFUk8gaXMgbm90IHNldAoj
IENPTkZJR19VU0JfQVVESU8gaXMgbm90IHNldAojIENPTkZJR19VU0JfRVRIIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX0dfTkNNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dBREdFVEZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0ZVTkNUSU9ORlMgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfRklMRV9TVE9SQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX01BU1NfU1RPUkFH
RSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfR0FER0VUX1RBUkdFVD1tCiMgQ09ORklHX1VTQl9H
X1NFUklBTCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NSURJX0dBREdFVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9HX1BSSU5URVIgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ0RDX0NP
TVBPU0lURSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HX05PS0lBIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0dfQUNNX01TIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dfTVVMVEkgaXMg
bm90IHNldAojIENPTkZJR19VU0JfR19ISUQgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19E
QkdQIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dfV0VCQ0FNIGlzIG5vdCBzZXQKCiMKIyBP
VEcgYW5kIHJlbGF0ZWQgaW5mcmFzdHJ1Y3R1cmUKIwpDT05GSUdfVVNCX09UR19VVElMUz15
CiMgQ09ORklHX1VTQl9HUElPX1ZCVVMgaXMgbm90IHNldApDT05GSUdfTk9QX1VTQl9YQ0VJ
Vj1tCkNPTkZJR19VV0I9bQpDT05GSUdfVVdCX0hXQT1tCkNPTkZJR19VV0JfV0hDST1tCkNP
TkZJR19VV0JfSTE0ODBVPW0KQ09ORklHX01NQz1tCiMgQ09ORklHX01NQ19ERUJVRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01NQ19VTlNBRkVfUkVTVU1FIGlzIG5vdCBzZXQKIyBDT05GSUdf
TU1DX0NMS0dBVEUgaXMgbm90IHNldAoKIwojIE1NQy9TRC9TRElPIENhcmQgRHJpdmVycwoj
CkNPTkZJR19NTUNfQkxPQ0s9bQpDT05GSUdfTU1DX0JMT0NLX01JTk9SUz04CkNPTkZJR19N
TUNfQkxPQ0tfQk9VTkNFPXkKQ09ORklHX1NESU9fVUFSVD1tCiMgQ09ORklHX01NQ19URVNU
IGlzIG5vdCBzZXQKCiMKIyBNTUMvU0QvU0RJTyBIb3N0IENvbnRyb2xsZXIgRHJpdmVycwoj
CkNPTkZJR19NTUNfU0RIQ0k9bQpDT05GSUdfTU1DX1NESENJX1BDST1tCkNPTkZJR19NTUNf
UklDT0hfTU1DPXkKQ09ORklHX01NQ19TREhDSV9QTFRGTT1tCkNPTkZJR19NTUNfV0JTRD1t
CkNPTkZJR19NTUNfVElGTV9TRD1tCkNPTkZJR19NTUNfU1BJPW0KQ09ORklHX01NQ19DQjcx
MD1tCkNPTkZJR19NTUNfVklBX1NETU1DPW0KQ09ORklHX01NQ19WVUIzMDA9bQpDT05GSUdf
TU1DX1VTSEM9bQpDT05GSUdfTUVNU1RJQ0s9bQojIENPTkZJR19NRU1TVElDS19ERUJVRyBp
cyBub3Qgc2V0CgojCiMgTWVtb3J5U3RpY2sgZHJpdmVycwojCiMgQ09ORklHX01FTVNUSUNL
X1VOU0FGRV9SRVNVTUUgaXMgbm90IHNldApDT05GSUdfTVNQUk9fQkxPQ0s9bQoKIwojIE1l
bW9yeVN0aWNrIEhvc3QgQ29udHJvbGxlciBEcml2ZXJzCiMKQ09ORklHX01FTVNUSUNLX1RJ
Rk1fTVM9bQpDT05GSUdfTUVNU1RJQ0tfSk1JQ1JPTl8zOFg9bQpDT05GSUdfTUVNU1RJQ0tf
UjU5Mj1tCkNPTkZJR19ORVdfTEVEUz15CkNPTkZJR19MRURTX0NMQVNTPXkKCiMKIyBMRUQg
ZHJpdmVycwojCiMgQ09ORklHX0xFRFNfTE0zNTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVE
U19MTTM2NDIgaXMgbm90IHNldApDT05GSUdfTEVEU19QQ0E5NTMyPW0KIyBDT05GSUdfTEVE
U19QQ0E5NTMyX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19MRURTX0dQSU8gaXMgbm90IHNl
dApDT05GSUdfTEVEU19MUDM5NDQ9bQojIENPTkZJR19MRURTX0xQNTUyMSBpcyBub3Qgc2V0
CiMgQ09ORklHX0xFRFNfTFA1NTIzIGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfQ0xFVk9fTUFJ
TD1tCkNPTkZJR19MRURTX1BDQTk1NVg9bQpDT05GSUdfTEVEU19QQ0E5NjMzPW0KQ09ORklH
X0xFRFNfREFDMTI0UzA4NT1tCkNPTkZJR19MRURTX1JFR1VMQVRPUj1tCkNPTkZJR19MRURT
X0JEMjgwMj1tCkNPTkZJR19MRURTX0lOVEVMX1NTNDIwMD1tCkNPTkZJR19MRURTX0xUMzU5
Mz1tCkNPTkZJR19MRURTX0RFTExfTkVUQk9PS1M9bQpDT05GSUdfTEVEU19UQ0E2NTA3PW0K
Q09ORklHX0xFRFNfTE0zNTV4PW0KQ09ORklHX0xFRFNfT1QyMDA9bQpDT05GSUdfTEVEU19C
TElOS009bQpDT05GSUdfTEVEU19UUklHR0VSUz15CgojCiMgTEVEIFRyaWdnZXJzCiMKQ09O
RklHX0xFRFNfVFJJR0dFUl9USU1FUj1tCkNPTkZJR19MRURTX1RSSUdHRVJfT05FU0hPVD1t
CkNPTkZJR19MRURTX1RSSUdHRVJfSEVBUlRCRUFUPW0KQ09ORklHX0xFRFNfVFJJR0dFUl9C
QUNLTElHSFQ9bQojIENPTkZJR19MRURTX1RSSUdHRVJfQ1BVIGlzIG5vdCBzZXQKIyBDT05G
SUdfTEVEU19UUklHR0VSX0dQSU8gaXMgbm90IHNldApDT05GSUdfTEVEU19UUklHR0VSX0RF
RkFVTFRfT049bQoKIwojIGlwdGFibGVzIHRyaWdnZXIgaXMgdW5kZXIgTmV0ZmlsdGVyIGNv
bmZpZyAoTEVEIHRhcmdldCkKIwpDT05GSUdfTEVEU19UUklHR0VSX1RSQU5TSUVOVD1tCkNP
TkZJR19BQ0NFU1NJQklMSVRZPXkKQ09ORklHX0ExMVlfQlJBSUxMRV9DT05TT0xFPXkKQ09O
RklHX0lORklOSUJBTkQ9bQpDT05GSUdfSU5GSU5JQkFORF9VU0VSX01BRD1tCkNPTkZJR19J
TkZJTklCQU5EX1VTRVJfQUNDRVNTPW0KQ09ORklHX0lORklOSUJBTkRfVVNFUl9NRU09eQpD
T05GSUdfSU5GSU5JQkFORF9BRERSX1RSQU5TPXkKQ09ORklHX0lORklOSUJBTkRfTVRIQ0E9
bQpDT05GSUdfSU5GSU5JQkFORF9NVEhDQV9ERUJVRz15CkNPTkZJR19JTkZJTklCQU5EX0lQ
QVRIPW0KQ09ORklHX0lORklOSUJBTkRfUUlCPW0KQ09ORklHX0lORklOSUJBTkRfQU1TTzEx
MDA9bQojIENPTkZJR19JTkZJTklCQU5EX0FNU08xMTAwX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX0lORklOSUJBTkRfQ1hHQjM9bQojIENPTkZJR19JTkZJTklCQU5EX0NYR0IzX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX0lORklOSUJBTkRfQ1hHQjQ9bQpDT05GSUdfTUxYNF9JTkZJ
TklCQU5EPW0KQ09ORklHX0lORklOSUJBTkRfTkVTPW0KIyBDT05GSUdfSU5GSU5JQkFORF9O
RVNfREVCVUcgaXMgbm90IHNldApDT05GSUdfSU5GSU5JQkFORF9PQ1JETUE9bQpDT05GSUdf
SU5GSU5JQkFORF9JUE9JQj1tCkNPTkZJR19JTkZJTklCQU5EX0lQT0lCX0NNPXkKQ09ORklH
X0lORklOSUJBTkRfSVBPSUJfREVCVUc9eQojIENPTkZJR19JTkZJTklCQU5EX0lQT0lCX0RF
QlVHX0RBVEEgaXMgbm90IHNldApDT05GSUdfSU5GSU5JQkFORF9TUlA9bQpDT05GSUdfSU5G
SU5JQkFORF9TUlBUPW0KQ09ORklHX0lORklOSUJBTkRfSVNFUj1tCkNPTkZJR19FREFDPXkK
CiMKIyBSZXBvcnRpbmcgc3Vic3lzdGVtcwojCkNPTkZJR19FREFDX0xFR0FDWV9TWVNGUz15
CiMgQ09ORklHX0VEQUNfREVCVUcgaXMgbm90IHNldApDT05GSUdfRURBQ19ERUNPREVfTUNF
PW0KIyBDT05GSUdfRURBQ19NQ0VfSU5KIGlzIG5vdCBzZXQKQ09ORklHX0VEQUNfTU1fRURB
Qz1tCkNPTkZJR19FREFDX0FNRDY0PW0KIyBDT05GSUdfRURBQ19BTUQ2NF9FUlJPUl9JTkpF
Q1RJT04gaXMgbm90IHNldApDT05GSUdfRURBQ19FNzUyWD1tCkNPTkZJR19FREFDX0k4Mjk3
NVg9bQpDT05GSUdfRURBQ19JMzAwMD1tCkNPTkZJR19FREFDX0kzMjAwPW0KQ09ORklHX0VE
QUNfWDM4PW0KQ09ORklHX0VEQUNfSTU0MDA9bQpDT05GSUdfRURBQ19JN0NPUkU9bQpDT05G
SUdfRURBQ19JNTAwMD1tCkNPTkZJR19FREFDX0k1MTAwPW0KQ09ORklHX0VEQUNfSTczMDA9
bQojIENPTkZJR19FREFDX1NCUklER0UgaXMgbm90IHNldApDT05GSUdfUlRDX0xJQj15CkNP
TkZJR19SVENfQ0xBU1M9eQpDT05GSUdfUlRDX0hDVE9TWVM9eQpDT05GSUdfUlRDX0hDVE9T
WVNfREVWSUNFPSJydGMwIgojIENPTkZJR19SVENfREVCVUcgaXMgbm90IHNldAoKIwojIFJU
QyBpbnRlcmZhY2VzCiMKQ09ORklHX1JUQ19JTlRGX1NZU0ZTPXkKQ09ORklHX1JUQ19JTlRG
X1BST0M9eQpDT05GSUdfUlRDX0lOVEZfREVWPXkKIyBDT05GSUdfUlRDX0lOVEZfREVWX1VJ
RV9FTVVMIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9URVNUIGlzIG5vdCBzZXQKCiMK
IyBJMkMgUlRDIGRyaXZlcnMKIwpDT05GSUdfUlRDX0RSVl9EUzEzMDc9bQpDT05GSUdfUlRD
X0RSVl9EUzEzNzQ9bQpDT05GSUdfUlRDX0RSVl9EUzE2NzI9bQojIENPTkZJR19SVENfRFJW
X0RTMzIzMiBpcyBub3Qgc2V0CkNPTkZJR19SVENfRFJWX01BWDY5MDA9bQpDT05GSUdfUlRD
X0RSVl9SUzVDMzcyPW0KQ09ORklHX1JUQ19EUlZfSVNMMTIwOD1tCiMgQ09ORklHX1JUQ19E
UlZfSVNMMTIwMjIgaXMgbm90IHNldApDT05GSUdfUlRDX0RSVl9YMTIwNT1tCkNPTkZJR19S
VENfRFJWX1BDRjg1NjM9bQpDT05GSUdfUlRDX0RSVl9QQ0Y4NTgzPW0KQ09ORklHX1JUQ19E
UlZfTTQxVDgwPW0KIyBDT05GSUdfUlRDX0RSVl9NNDFUODBfV0RUIGlzIG5vdCBzZXQKQ09O
RklHX1JUQ19EUlZfQlEzMks9bQpDT05GSUdfUlRDX0RSVl9TMzUzOTBBPW0KQ09ORklHX1JU
Q19EUlZfRk0zMTMwPW0KQ09ORklHX1JUQ19EUlZfUlg4NTgxPW0KQ09ORklHX1JUQ19EUlZf
Ulg4MDI1PW0KIyBDT05GSUdfUlRDX0RSVl9FTTMwMjcgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX1JWMzAyOUMyIGlzIG5vdCBzZXQKCiMKIyBTUEkgUlRDIGRyaXZlcnMKIwojIENP
TkZJR19SVENfRFJWX000MVQ5MyBpcyBub3Qgc2V0CkNPTkZJR19SVENfRFJWX000MVQ5ND1t
CkNPTkZJR19SVENfRFJWX0RTMTMwNT1tCkNPTkZJR19SVENfRFJWX0RTMTM5MD1tCkNPTkZJ
R19SVENfRFJWX01BWDY5MDI9bQpDT05GSUdfUlRDX0RSVl9SOTcwMT1tCkNPTkZJR19SVENf
RFJWX1JTNUMzNDg9bQpDT05GSUdfUlRDX0RSVl9EUzMyMzQ9bQpDT05GSUdfUlRDX0RSVl9Q
Q0YyMTIzPW0KCiMKIyBQbGF0Zm9ybSBSVEMgZHJpdmVycwojCkNPTkZJR19SVENfRFJWX0NN
T1M9eQpDT05GSUdfUlRDX0RSVl9EUzEyODY9bQpDT05GSUdfUlRDX0RSVl9EUzE1MTE9bQpD
T05GSUdfUlRDX0RSVl9EUzE1NTM9bQpDT05GSUdfUlRDX0RSVl9EUzE3NDI9bQpDT05GSUdf
UlRDX0RSVl9TVEsxN1RBOD1tCkNPTkZJR19SVENfRFJWX000OFQ4Nj1tCkNPTkZJR19SVENf
RFJWX000OFQzNT1tCkNPTkZJR19SVENfRFJWX000OFQ1OT1tCkNPTkZJR19SVENfRFJWX01T
TTYyNDI9bQpDT05GSUdfUlRDX0RSVl9CUTQ4MDI9bQpDT05GSUdfUlRDX0RSVl9SUDVDMDE9
bQpDT05GSUdfUlRDX0RSVl9WMzAyMD1tCkNPTkZJR19SVENfRFJWX0RTMjQwND1tCkNPTkZJ
R19SVENfRFJWX1BDRjUwNjMzPW0KCiMKIyBvbi1DUFUgUlRDIGRyaXZlcnMKIwpDT05GSUdf
RE1BREVWSUNFUz15CiMgQ09ORklHX0RNQURFVklDRVNfREVCVUcgaXMgbm90IHNldAoKIwoj
IERNQSBEZXZpY2VzCiMKQ09ORklHX0lOVEVMX01JRF9ETUFDPW0KQ09ORklHX0lOVEVMX0lP
QVRETUE9bQojIENPTkZJR19USU1CX0RNQSBpcyBub3Qgc2V0CkNPTkZJR19QQ0hfRE1BPW0K
Q09ORklHX0RNQV9FTkdJTkU9eQoKIwojIERNQSBDbGllbnRzCiMKQ09ORklHX05FVF9ETUE9
eQpDT05GSUdfQVNZTkNfVFhfRE1BPXkKIyBDT05GSUdfRE1BVEVTVCBpcyBub3Qgc2V0CkNP
TkZJR19EQ0E9bQojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBzZXQKQ09ORklHX1VJTz1t
CkNPTkZJR19VSU9fQ0lGPW0KQ09ORklHX1VJT19QRFJWPW0KQ09ORklHX1VJT19QRFJWX0dF
TklSUT1tCkNPTkZJR19VSU9fQUVDPW0KQ09ORklHX1VJT19TRVJDT1MzPW0KQ09ORklHX1VJ
T19QQ0lfR0VORVJJQz1tCkNPTkZJR19VSU9fTkVUWD1tCkNPTkZJR19WRklPX0lPTU1VX1RZ
UEUxPW0KQ09ORklHX1ZGSU89bQpDT05GSUdfVkZJT19QQ0k9bQpDT05GSUdfVklSVElPPW0K
CiMKIyBWaXJ0aW8gZHJpdmVycwojCkNPTkZJR19WSVJUSU9fUENJPW0KQ09ORklHX1ZJUlRJ
T19CQUxMT09OPW0KIyBDT05GSUdfVklSVElPX01NSU8gaXMgbm90IHNldAoKIwojIE1pY3Jv
c29mdCBIeXBlci1WIGd1ZXN0IHN1cHBvcnQKIwpDT05GSUdfSFlQRVJWPW0KQ09ORklHX0hZ
UEVSVl9VVElMUz1tCkNPTkZJR19TVEFHSU5HPXkKQ09ORklHX0VUMTMxWD1tCiMgQ09ORklH
X1NMSUNPU1MgaXMgbm90IHNldApDT05GSUdfVVNCSVBfQ09SRT1tCkNPTkZJR19VU0JJUF9W
SENJX0hDRD1tCkNPTkZJR19VU0JJUF9IT1NUPW0KIyBDT05GSUdfVVNCSVBfREVCVUcgaXMg
bm90IHNldAojIENPTkZJR19XMzVVTkQgaXMgbm90IHNldApDT05GSUdfUFJJU00yX1VTQj1t
CiMgQ09ORklHX0VDSE8gaXMgbm90IHNldApDT05GSUdfQ09NRURJPW0KIyBDT05GSUdfQ09N
RURJX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0NPTUVESV9ERUZBVUxUX0JVRl9TSVpFX0tC
PTIwNDgKQ09ORklHX0NPTUVESV9ERUZBVUxUX0JVRl9NQVhTSVpFX0tCPTIwNDgwCkNPTkZJ
R19DT01FRElfTUlTQ19EUklWRVJTPXkKQ09ORklHX0NPTUVESV9LQ09NRURJTElCPW0KQ09O
RklHX0NPTUVESV9CT05EPW0KQ09ORklHX0NPTUVESV9URVNUPW0KQ09ORklHX0NPTUVESV9Q
QVJQT1JUPW0KQ09ORklHX0NPTUVESV9TRVJJQUwyMDAyPW0KIyBDT05GSUdfQ09NRURJX1NL
RUwgaXMgbm90IHNldApDT05GSUdfQ09NRURJX1BDSV9EUklWRVJTPXkKIyBDT05GSUdfQ09N
RURJXzgyNTVfUENJIGlzIG5vdCBzZXQKQ09ORklHX0NPTUVESV9BRERJX0FQQ0lfMDM1PW0K
Q09ORklHX0NPTUVESV9BRERJX0FQQ0lfMTAzMj1tCkNPTkZJR19DT01FRElfQURESV9BUENJ
XzE1MDA9bQpDT05GSUdfQ09NRURJX0FERElfQVBDSV8xNTE2PW0KQ09ORklHX0NPTUVESV9B
RERJX0FQQ0lfMTU2ND1tCkNPTkZJR19DT01FRElfQURESV9BUENJXzE2WFg9bQpDT05GSUdf
Q09NRURJX0FERElfQVBDSV8yMDE2PW0KQ09ORklHX0NPTUVESV9BRERJX0FQQ0lfMjAzMj1t
CkNPTkZJR19DT01FRElfQURESV9BUENJXzIyMDA9bQpDT05GSUdfQ09NRURJX0FERElfQVBD
SV8zMDAxPW0KQ09ORklHX0NPTUVESV9BRERJX0FQQ0lfMzEyMD1tCkNPTkZJR19DT01FRElf
QURESV9BUENJXzM1MDE9bQpDT05GSUdfQ09NRURJX0FERElfQVBDSV8zWFhYPW0KQ09ORklH
X0NPTUVESV9BRExfUENJNjIwOD1tCiMgQ09ORklHX0NPTUVESV9BRExfUENJN1gzWCBpcyBu
b3Qgc2V0CkNPTkZJR19DT01FRElfQURMX1BDSTgxNjQ9bQpDT05GSUdfQ09NRURJX0FETF9Q
Q0k5MTExPW0KQ09ORklHX0NPTUVESV9BRExfUENJOTExOD1tCkNPTkZJR19DT01FRElfQURW
X1BDSTE3MTA9bQpDT05GSUdfQ09NRURJX0FEVl9QQ0kxNzIzPW0KQ09ORklHX0NPTUVESV9B
RFZfUENJX0RJTz1tCkNPTkZJR19DT01FRElfQU1QTENfRElPMjAwX1BDST1tCkNPTkZJR19D
T01FRElfQU1QTENfUEMyMzZfUENJPW0KQ09ORklHX0NPTUVESV9BTVBMQ19QQzI2M19QQ0k9
bQpDT05GSUdfQ09NRURJX0FNUExDX1BDSTIyND1tCkNPTkZJR19DT01FRElfQU1QTENfUENJ
MjMwPW0KQ09ORklHX0NPTUVESV9DT05URUNfUENJX0RJTz1tCkNPTkZJR19DT01FRElfREFT
MDhfUENJPW0KQ09ORklHX0NPTUVESV9EVDMwMDA9bQojIENPTkZJR19DT01FRElfRFlOQV9Q
Q0kxMFhYIGlzIG5vdCBzZXQKQ09ORklHX0NPTUVESV9VTklPWFg1PW0KQ09ORklHX0NPTUVE
SV9HU0NfSFBEST1tCkNPTkZJR19DT01FRElfSUNQX01VTFRJPW0KQ09ORklHX0NPTUVESV9J
SV9QQ0kyMEtDPW0KQ09ORklHX0NPTUVESV9EQVFCT0FSRDIwMDA9bQpDT05GSUdfQ09NRURJ
X0pSM19QQ0k9bQpDT05GSUdfQ09NRURJX0tFX0NPVU5URVI9bQpDT05GSUdfQ09NRURJX0NC
X1BDSURBUzY0PW0KQ09ORklHX0NPTUVESV9DQl9QQ0lEQVM9bQpDT05GSUdfQ09NRURJX0NC
X1BDSUREQT1tCkNPTkZJR19DT01FRElfQ0JfUENJTURBUz1tCkNPTkZJR19DT01FRElfQ0Jf
UENJTUREQT1tCkNPTkZJR19DT01FRElfTUU0MDAwPW0KQ09ORklHX0NPTUVESV9NRV9EQVE9
bQpDT05GSUdfQ09NRURJX05JXzY1Mjc9bQpDT05GSUdfQ09NRURJX05JXzY1WFg9bQpDT05G
SUdfQ09NRURJX05JXzY2MFg9bQpDT05GSUdfQ09NRURJX05JXzY3MFg9bQpDT05GSUdfQ09N
RURJX05JX0xBQlBDPW0KQ09ORklHX0NPTUVESV9OSV9QQ0lESU89bQpDT05GSUdfQ09NRURJ
X05JX1BDSU1JTz1tCkNPTkZJR19DT01FRElfUlRENTIwPW0KQ09ORklHX0NPTUVESV9TNTI2
PW0KQ09ORklHX0NPTUVESV9TNjI2PW0KQ09ORklHX0NPTUVESV9TU1ZfRE5QPW0KQ09ORklH
X0NPTUVESV9NSVRFPW0KQ09ORklHX0NPTUVESV9OSV9USU9DTUQ9bQpDT05GSUdfQ09NRURJ
X1VTQl9EUklWRVJTPXkKQ09ORklHX0NPTUVESV9EVDk4MTI9bQpDT05GSUdfQ09NRURJX1VT
QkRVWD1tCkNPTkZJR19DT01FRElfVVNCRFVYRkFTVD1tCiMgQ09ORklHX0NPTUVESV9VU0JE
VVhTSUdNQSBpcyBub3Qgc2V0CkNPTkZJR19DT01FRElfVk1LODBYWD1tCkNPTkZJR19DT01F
RElfODI1NT1tCkNPTkZJR19DT01FRElfRkM9bQpDT05GSUdfQ09NRURJX0FNUExDX0RJTzIw
MD1tCkNPTkZJR19DT01FRElfQU1QTENfUEMyMzY9bQpDT05GSUdfQ09NRURJX0FNUExDX1BD
MjYzPW0KQ09ORklHX0NPTUVESV9EQVMwOD1tCkNPTkZJR19DT01FRElfTklfVElPPW0KIyBD
T05GSUdfQVNVU19PTEVEIGlzIG5vdCBzZXQKQ09ORklHX1I4MTg3U0U9bQpDT05GSUdfUlRM
ODE5MlU9bQpDT05GSUdfUlRMTElCPW0KQ09ORklHX1JUTExJQl9DUllQVE9fQ0NNUD1tCkNP
TkZJR19SVExMSUJfQ1JZUFRPX1RLSVA9bQpDT05GSUdfUlRMTElCX0NSWVBUT19XRVA9bQpD
T05GSUdfUlRMODE5MkU9bQpDT05GSUdfUjg3MTJVPW0KQ09ORklHX1JUU19QU1RPUj1tCiMg
Q09ORklHX1JUU19QU1RPUl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19SVFM1MTM5PW0KIyBD
T05GSUdfUlRTNTEzOV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQU5aUE9SVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lERV9QSElTT04gaXMgbm90IHNldAojIENPTkZJR19MSU5FNl9V
U0IgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1FVQVRFQ0gyIGlzIG5vdCBzZXQK
IyBDT05GSUdfVlQ2NjU1IGlzIG5vdCBzZXQKQ09ORklHX1ZUNjY1Nj1tCiMgQ09ORklHX0RY
X1NFUCBpcyBub3Qgc2V0CkNPTkZJR19aUkFNPW0KIyBDT05GSUdfWlJBTV9ERUJVRyBpcyBu
b3Qgc2V0CkNPTkZJR19aU01BTExPQz1tCiMgQ09ORklHX0ZCX1NNN1hYIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1JZU1RBTEhEIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1hUMUUxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfWEdJIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9RVUlDS1NUQVJU
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0JFXzJUM0UzIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0VORVNUT1JBR0UgaXMgbm90IHNldAojIENPTkZJR19CQ01fV0lNQVggaXMgbm90IHNldAoj
IENPTkZJR19GVDEwMDAgaXMgbm90IHNldAoKIwojIFNwZWFrdXAgY29uc29sZSBzcGVlY2gK
IwpDT05GSUdfU1BFQUtVUD1tCkNPTkZJR19TUEVBS1VQX1NZTlRIX0FDTlRTQT1tCkNPTkZJ
R19TUEVBS1VQX1NZTlRIX0FDTlRQQz1tCkNPTkZJR19TUEVBS1VQX1NZTlRIX0FQT0xMTz1t
CkNPTkZJR19TUEVBS1VQX1NZTlRIX0FVRFBUUj1tCkNPTkZJR19TUEVBS1VQX1NZTlRIX0JO
Uz1tCkNPTkZJR19TUEVBS1VQX1NZTlRIX0RFQ1RMSz1tCkNPTkZJR19TUEVBS1VQX1NZTlRI
X0RFQ0VYVD1tCiMgQ09ORklHX1NQRUFLVVBfU1lOVEhfREVDUEMgaXMgbm90IHNldApDT05G
SUdfU1BFQUtVUF9TWU5USF9EVExLPW0KQ09ORklHX1NQRUFLVVBfU1lOVEhfS0VZUEM9bQpD
T05GSUdfU1BFQUtVUF9TWU5USF9MVExLPW0KQ09ORklHX1NQRUFLVVBfU1lOVEhfU09GVD1t
CkNPTkZJR19TUEVBS1VQX1NZTlRIX1NQS09VVD1tCkNPTkZJR19TUEVBS1VQX1NZTlRIX1RY
UFJUPW0KQ09ORklHX1NQRUFLVVBfU1lOVEhfRFVNTVk9bQojIENPTkZJR19UT1VDSFNDUkVF
Tl9DTEVBUlBBRF9UTTEyMTcgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9TWU5B
UFRJQ1NfSTJDX1JNSTQgaXMgbm90IHNldApDT05GSUdfU1RBR0lOR19NRURJQT15CiMgQ09O
RklHX0RWQl9BUzEwMiBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9DWEQyMDk5IGlzIG5vdCBz
ZXQKIyBDT05GSUdfVklERU9fRFQzMTU1IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fR083
MDA3IGlzIG5vdCBzZXQKIyBDT05GSUdfU09MTzZYMTAgaXMgbm90IHNldApDT05GSUdfTElS
Q19TVEFHSU5HPXkKQ09ORklHX0xJUkNfQlQ4Mjk9bQpDT05GSUdfTElSQ19JR09SUExVR1VT
Qj1tCkNPTkZJR19MSVJDX0lNT049bQpDT05GSUdfTElSQ19TQVNFTT1tCkNPTkZJR19MSVJD
X1NFUklBTD1tCkNPTkZJR19MSVJDX1NFUklBTF9UUkFOU01JVFRFUj15CkNPTkZJR19MSVJD
X1NJUj1tCkNPTkZJR19MSVJDX1pJTE9HPW0KCiMKIyBBbmRyb2lkCiMKIyBDT05GSUdfQU5E
Uk9JRCBpcyBub3Qgc2V0CkNPTkZJR19QSE9ORT1tCkNPTkZJR19QSE9ORV9JWEo9bQpDT05G
SUdfVVNCX1dQQU5fSENEPW0KIyBDT05GSUdfVVNCX0dfQ0NHIGlzIG5vdCBzZXQKQ09ORklH
X0lQQUNLX0JVUz1tCkNPTkZJR19CT0FSRF9UUENJMjAwPW0KQ09ORklHX1NFUklBTF9JUE9D
VEFMPW0KIyBDT05GSUdfV0lNQVhfR0RNNzJYWCBpcyBub3Qgc2V0CkNPTkZJR19DU1JfV0lG
ST1tCkNPTkZJR19aQ0FDSEUyPXkKIyBDT05GSUdfTkVUX1ZFTkRPUl9TSUxJQ09NIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ0VEMTQwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0RHUlAgaXMgbm90
IHNldApDT05GSUdfWDg2X1BMQVRGT1JNX0RFVklDRVM9eQojIENPTkZJR19BQ0VSX1dNSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0FDRVJIREYgaXMgbm90IHNldApDT05GSUdfQVNVU19MQVBU
T1A9bQpDT05GSUdfREVMTF9MQVBUT1A9bQpDT05GSUdfREVMTF9XTUk9bQpDT05GSUdfREVM
TF9XTUlfQUlPPW0KIyBDT05GSUdfRlVKSVRTVV9MQVBUT1AgaXMgbm90IHNldAojIENPTkZJ
R19GVUpJVFNVX1RBQkxFVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FNSUxPX1JGS0lMTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hQX0FDQ0VMIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBfV01JIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVNJX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBTkFT
T05JQ19MQVBUT1AgaXMgbm90IHNldAojIENPTkZJR19DT01QQUxfTEFQVE9QIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU09OWV9MQVBUT1AgaXMgbm90IHNldAojIENPTkZJR19JREVBUEFEX0xB
UFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RISU5LUEFEX0FDUEkgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0hEQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxfTUVOTE9XIGlz
IG5vdCBzZXQKQ09ORklHX0VFRVBDX0xBUFRPUD1tCkNPTkZJR19BU1VTX1dNST1tCkNPTkZJ
R19BU1VTX05CX1dNST1tCkNPTkZJR19FRUVQQ19XTUk9bQpDT05GSUdfQUNQSV9XTUk9bQpD
T05GSUdfTVNJX1dNST1tCiMgQ09ORklHX1RPUFNUQVJfTEFQVE9QIGlzIG5vdCBzZXQKIyBD
T05GSUdfQUNQSV9UT1NISUJBIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9TSElCQV9CVF9SRktJ
TEwgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX0NNUEMgaXMgbm90IHNldApDT05GSUdfSU5U
RUxfSVBTPW0KIyBDT05GSUdfSUJNX1JUTCBpcyBub3Qgc2V0CiMgQ09ORklHX1hPMTVfRUJP
T0sgaXMgbm90IHNldAojIENPTkZJR19TQU1TVU5HX0xBUFRPUCBpcyBub3Qgc2V0CkNPTkZJ
R19NWE1fV01JPW0KQ09ORklHX0lOVEVMX09BS1RSQUlMPW0KIyBDT05GSUdfU0FNU1VOR19R
MTAgaXMgbm90IHNldApDT05GSUdfQVBQTEVfR01VWD1tCgojCiMgSGFyZHdhcmUgU3Bpbmxv
Y2sgZHJpdmVycwojCkNPTkZJR19DTEtFVlRfSTgyNTM9eQpDT05GSUdfSTgyNTNfTE9DSz15
CkNPTkZJR19DTEtCTERfSTgyNTM9eQpDT05GSUdfSU9NTVVfQVBJPXkKQ09ORklHX0lPTU1V
X1NVUFBPUlQ9eQpDT05GSUdfQU1EX0lPTU1VPXkKIyBDT05GSUdfQU1EX0lPTU1VX1NUQVRT
IGlzIG5vdCBzZXQKQ09ORklHX0FNRF9JT01NVV9WMj1tCkNPTkZJR19ETUFSX1RBQkxFPXkK
Q09ORklHX0lOVEVMX0lPTU1VPXkKIyBDT05GSUdfSU5URUxfSU9NTVVfREVGQVVMVF9PTiBp
cyBub3Qgc2V0CkNPTkZJR19JTlRFTF9JT01NVV9GTE9QUFlfV0E9eQpDT05GSUdfSVJRX1JF
TUFQPXkKCiMKIyBSZW1vdGVwcm9jIGRyaXZlcnMgKEVYUEVSSU1FTlRBTCkKIwojIENPTkZJ
R19TVEVfTU9ERU1fUlBST0MgaXMgbm90IHNldAoKIwojIFJwbXNnIGRyaXZlcnMgKEVYUEVS
SU1FTlRBTCkKIwpDT05GSUdfVklSVF9EUklWRVJTPXkKIyBDT05GSUdfUE1fREVWRlJFUSBp
cyBub3Qgc2V0CkNPTkZJR19FWFRDT049bQoKIwojIEV4dGNvbiBEZXZpY2UgRHJpdmVycwoj
CkNPTkZJR19FWFRDT05fR1BJTz1tCiMgQ09ORklHX01FTU9SWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZNRV9CVVMgaXMgbm90IHNldApDT05GSUdf
UFdNPXkKCiMKIyBGaXJtd2FyZSBEcml2ZXJzCiMKQ09ORklHX0VERD1tCiMgQ09ORklHX0VE
RF9PRkYgaXMgbm90IHNldApDT05GSUdfRklSTVdBUkVfTUVNTUFQPXkKQ09ORklHX0VGSV9W
QVJTPW0KQ09ORklHX0RFTExfUkJVPW0KQ09ORklHX0RDREJBUz1tCkNPTkZJR19ETUlJRD15
CkNPTkZJR19ETUlfU1lTRlM9bQpDT05GSUdfSVNDU0lfSUJGVF9GSU5EPXkKQ09ORklHX0lT
Q1NJX0lCRlQ9bQojIENPTkZJR19HT09HTEVfRklSTVdBUkUgaXMgbm90IHNldAoKIwojIEZp
bGUgc3lzdGVtcwojCkNPTkZJR19EQ0FDSEVfV09SRF9BQ0NFU1M9eQojIENPTkZJR19FWFQy
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUM19GUyBpcyBub3Qgc2V0CkNPTkZJR19FWFQ0
X0ZTPW0KQ09ORklHX0VYVDRfVVNFX0ZPUl9FWFQyMz15CkNPTkZJR19FWFQ0X0ZTX1hBVFRS
PXkKQ09ORklHX0VYVDRfRlNfUE9TSVhfQUNMPXkKQ09ORklHX0VYVDRfRlNfU0VDVVJJVFk9
eQojIENPTkZJR19FWFQ0X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0pCRDI9bQojIENPTkZJ
R19KQkQyX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0ZTX01CQ0FDSEU9bQojIENPTkZJR19S
RUlTRVJGU19GUyBpcyBub3Qgc2V0CkNPTkZJR19KRlNfRlM9bQpDT05GSUdfSkZTX1BPU0lY
X0FDTD15CkNPTkZJR19KRlNfU0VDVVJJVFk9eQojIENPTkZJR19KRlNfREVCVUcgaXMgbm90
IHNldAojIENPTkZJR19KRlNfU1RBVElTVElDUyBpcyBub3Qgc2V0CkNPTkZJR19YRlNfRlM9
bQpDT05GSUdfWEZTX1FVT1RBPXkKQ09ORklHX1hGU19QT1NJWF9BQ0w9eQpDT05GSUdfWEZT
X1JUPXkKIyBDT05GSUdfWEZTX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfR0ZTMl9GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX09DRlMyX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0JUUkZTX0ZT
PW0KQ09ORklHX0JUUkZTX0ZTX1BPU0lYX0FDTD15CiMgQ09ORklHX0JUUkZTX0ZTX0NIRUNL
X0lOVEVHUklUWSBpcyBub3Qgc2V0CiMgQ09ORklHX05JTEZTMl9GUyBpcyBub3Qgc2V0CkNP
TkZJR19GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhQT1JURlM9eQpDT05GSUdfRklMRV9MT0NL
SU5HPXkKQ09ORklHX0ZTTk9USUZZPXkKQ09ORklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElG
WV9VU0VSPXkKQ09ORklHX0ZBTk9USUZZPXkKIyBDT05GSUdfRkFOT1RJRllfQUNDRVNTX1BF
Uk1JU1NJT05TIGlzIG5vdCBzZXQKQ09ORklHX1FVT1RBPXkKQ09ORklHX1FVT1RBX05FVExJ
TktfSU5URVJGQUNFPXkKQ09ORklHX1BSSU5UX1FVT1RBX1dBUk5JTkc9eQojIENPTkZJR19R
VU9UQV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19RVU9UQV9UUkVFPW0KQ09ORklHX1FGTVRf
VjE9bQpDT05GSUdfUUZNVF9WMj1tCkNPTkZJR19RVU9UQUNUTD15CkNPTkZJR19RVU9UQUNU
TF9DT01QQVQ9eQpDT05GSUdfQVVUT0ZTNF9GUz1tCkNPTkZJR19GVVNFX0ZTPW0KQ09ORklH
X0NVU0U9bQpDT05GSUdfR0VORVJJQ19BQ0w9eQoKIwojIENhY2hlcwojCkNPTkZJR19GU0NB
Q0hFPW0KQ09ORklHX0ZTQ0FDSEVfU1RBVFM9eQojIENPTkZJR19GU0NBQ0hFX0hJU1RPR1JB
TSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZTQ0FDSEVfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19GU0NBQ0hFX09CSkVDVF9MSVNUIGlzIG5vdCBzZXQKQ09ORklHX0NBQ0hFRklMRVM9bQoj
IENPTkZJR19DQUNIRUZJTEVTX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FDSEVGSUxF
U19ISVNUT0dSQU0gaXMgbm90IHNldAoKIwojIENELVJPTS9EVkQgRmlsZXN5c3RlbXMKIwpD
T05GSUdfSVNPOTY2MF9GUz1tCkNPTkZJR19KT0xJRVQ9eQpDT05GSUdfWklTT0ZTPXkKQ09O
RklHX1VERl9GUz1tCkNPTkZJR19VREZfTkxTPXkKCiMKIyBET1MvRkFUL05UIEZpbGVzeXN0
ZW1zCiMKQ09ORklHX0ZBVF9GUz1tCkNPTkZJR19NU0RPU19GUz1tCkNPTkZJR19WRkFUX0ZT
PW0KQ09ORklHX0ZBVF9ERUZBVUxUX0NPREVQQUdFPTQzNwpDT05GSUdfRkFUX0RFRkFVTFRf
SU9DSEFSU0VUPSJ1dGY4IgpDT05GSUdfTlRGU19GUz1tCiMgQ09ORklHX05URlNfREVCVUcg
aXMgbm90IHNldApDT05GSUdfTlRGU19SVz15CgojCiMgUHNldWRvIGZpbGVzeXN0ZW1zCiMK
Q09ORklHX1BST0NfRlM9eQpDT05GSUdfUFJPQ19LQ09SRT15CkNPTkZJR19QUk9DX1ZNQ09S
RT15CkNPTkZJR19QUk9DX1NZU0NUTD15CkNPTkZJR19QUk9DX1BBR0VfTU9OSVRPUj15CkNP
TkZJR19TWVNGUz15CkNPTkZJR19UTVBGUz15CkNPTkZJR19UTVBGU19QT1NJWF9BQ0w9eQpD
T05GSUdfVE1QRlNfWEFUVFI9eQpDT05GSUdfSFVHRVRMQkZTPXkKQ09ORklHX0hVR0VUTEJf
UEFHRT15CkNPTkZJR19DT05GSUdGU19GUz1tCkNPTkZJR19NSVNDX0ZJTEVTWVNURU1TPXkK
IyBDT05GSUdfQURGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FGRlNfRlMgaXMgbm90IHNl
dAojIENPTkZJR19FQ1JZUFRfRlMgaXMgbm90IHNldApDT05GSUdfSEZTX0ZTPW0KQ09ORklH
X0hGU1BMVVNfRlM9bQojIENPTkZJR19CRUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZG
UzJfRlMgaXMgbm90IHNldAojIENPTkZJR19VQklGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0xPR0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JBTUZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1FVQVNIRlMgaXMgbm90IHNldAojIENPTkZJR19WWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUlOSVhfRlMgaXMgbm90IHNldAojIENPTkZJR19PTUZTX0ZTIGlzIG5vdCBzZXQKIyBD
T05GSUdfSFBGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRGU19GUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1FOWDZGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JPTUZTX0ZTIGlzIG5v
dCBzZXQKQ09ORklHX1BTVE9SRT15CiMgQ09ORklHX1BTVE9SRV9DT05TT0xFIGlzIG5vdCBz
ZXQKQ09ORklHX1BTVE9SRV9SQU09bQojIENPTkZJR19TWVNWX0ZTIGlzIG5vdCBzZXQKIyBD
T05GSUdfVUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhPRlNfRlMgaXMgbm90IHNldApD
T05GSUdfT1JFPW0KQ09ORklHX05FVFdPUktfRklMRVNZU1RFTVM9eQpDT05GSUdfTkZTX0ZT
PW0KQ09ORklHX05GU19WMj1tCkNPTkZJR19ORlNfVjM9bQpDT05GSUdfTkZTX1YzX0FDTD15
CkNPTkZJR19ORlNfVjQ9bQojIENPTkZJR19ORlNfU1dBUCBpcyBub3Qgc2V0CkNPTkZJR19O
RlNfVjRfMT15CkNPTkZJR19QTkZTX0ZJTEVfTEFZT1VUPW0KQ09ORklHX1BORlNfQkxPQ0s9
bQpDT05GSUdfUE5GU19PQkpMQVlPVVQ9bQpDT05GSUdfTkZTX1Y0XzFfSU1QTEVNRU5UQVRJ
T05fSURfRE9NQUlOPSJrZXJuZWwub3JnIgpDT05GSUdfTkZTX0ZTQ0FDSEU9eQojIENPTkZJ
R19ORlNfVVNFX0xFR0FDWV9ETlMgaXMgbm90IHNldApDT05GSUdfTkZTX1VTRV9LRVJORUxf
RE5TPXkKQ09ORklHX05GU0Q9bQpDT05GSUdfTkZTRF9WMl9BQ0w9eQpDT05GSUdfTkZTRF9W
Mz15CkNPTkZJR19ORlNEX1YzX0FDTD15CkNPTkZJR19ORlNEX1Y0PXkKIyBDT05GSUdfTkZT
RF9GQVVMVF9JTkpFQ1RJT04gaXMgbm90IHNldApDT05GSUdfTE9DS0Q9bQpDT05GSUdfTE9D
S0RfVjQ9eQpDT05GSUdfTkZTX0FDTF9TVVBQT1JUPW0KQ09ORklHX05GU19DT01NT049eQpD
T05GSUdfU1VOUlBDPW0KQ09ORklHX1NVTlJQQ19HU1M9bQpDT05GSUdfU1VOUlBDX0JBQ0tD
SEFOTkVMPXkKQ09ORklHX1NVTlJQQ19YUFJUX1JETUE9bQpDT05GSUdfUlBDU0VDX0dTU19L
UkI1PW0KIyBDT05GSUdfU1VOUlBDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0NFUEhfRlM9
bQpDT05GSUdfQ0lGUz1tCiMgQ09ORklHX0NJRlNfU1RBVFMgaXMgbm90IHNldApDT05GSUdf
Q0lGU19XRUFLX1BXX0hBU0g9eQpDT05GSUdfQ0lGU19VUENBTEw9eQpDT05GSUdfQ0lGU19Y
QVRUUj15CkNPTkZJR19DSUZTX1BPU0lYPXkKQ09ORklHX0NJRlNfQUNMPXkKIyBDT05GSUdf
Q0lGU19ERUJVRzIgaXMgbm90IHNldApDT05GSUdfQ0lGU19ERlNfVVBDQUxMPXkKQ09ORklH
X0NJRlNfU01CMj15CkNPTkZJR19DSUZTX0ZTQ0FDSEU9eQojIENPTkZJR19OQ1BfRlMgaXMg
bm90IHNldAojIENPTkZJR19DT0RBX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZTX0ZTIGlz
IG5vdCBzZXQKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0idXRmOCIKQ09ORklH
X05MU19DT0RFUEFHRV80Mzc9bQpDT05GSUdfTkxTX0NPREVQQUdFXzczNz1tCkNPTkZJR19O
TFNfQ09ERVBBR0VfNzc1PW0KQ09ORklHX05MU19DT0RFUEFHRV84NTA9bQpDT05GSUdfTkxT
X0NPREVQQUdFXzg1Mj1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODU1PW0KQ09ORklHX05MU19D
T0RFUEFHRV84NTc9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg2MD1tCkNPTkZJR19OTFNfQ09E
RVBBR0VfODYxPW0KQ09ORklHX05MU19DT0RFUEFHRV84NjI9bQpDT05GSUdfTkxTX0NPREVQ
QUdFXzg2Mz1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODY0PW0KQ09ORklHX05MU19DT0RFUEFH
RV84NjU9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg2Nj1tCkNPTkZJR19OTFNfQ09ERVBBR0Vf
ODY5PW0KQ09ORklHX05MU19DT0RFUEFHRV85MzY9bQpDT05GSUdfTkxTX0NPREVQQUdFXzk1
MD1tCkNPTkZJR19OTFNfQ09ERVBBR0VfOTMyPW0KQ09ORklHX05MU19DT0RFUEFHRV85NDk9
bQpDT05GSUdfTkxTX0NPREVQQUdFXzg3ND1tCkNPTkZJR19OTFNfSVNPODg1OV84PW0KQ09O
RklHX05MU19DT0RFUEFHRV8xMjUwPW0KQ09ORklHX05MU19DT0RFUEFHRV8xMjUxPW0KQ09O
RklHX05MU19BU0NJST1tCkNPTkZJR19OTFNfSVNPODg1OV8xPW0KQ09ORklHX05MU19JU084
ODU5XzI9bQpDT05GSUdfTkxTX0lTTzg4NTlfMz1tCkNPTkZJR19OTFNfSVNPODg1OV80PW0K
Q09ORklHX05MU19JU084ODU5XzU9bQpDT05GSUdfTkxTX0lTTzg4NTlfNj1tCkNPTkZJR19O
TFNfSVNPODg1OV83PW0KQ09ORklHX05MU19JU084ODU5Xzk9bQpDT05GSUdfTkxTX0lTTzg4
NTlfMTM9bQpDT05GSUdfTkxTX0lTTzg4NTlfMTQ9bQpDT05GSUdfTkxTX0lTTzg4NTlfMTU9
bQpDT05GSUdfTkxTX0tPSThfUj1tCkNPTkZJR19OTFNfS09JOF9VPW0KIyBDT05GSUdfTkxT
X01BQ19ST01BTiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfQ0VMVElDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX01BQ19DRU5URVVSTyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19N
QUNfQ1JPQVRJQU4gaXMgbm90IHNldAojIENPTkZJR19OTFNfTUFDX0NZUklMTElDIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX01BQ19HQUVMSUMgaXMgbm90IHNldAojIENPTkZJR19OTFNf
TUFDX0dSRUVLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX01BQ19JQ0VMQU5EIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX01BQ19JTlVJVCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNf
Uk9NQU5JQU4gaXMgbm90IHNldAojIENPTkZJR19OTFNfTUFDX1RVUktJU0ggaXMgbm90IHNl
dApDT05GSUdfTkxTX1VURjg9bQpDT05GSUdfRExNPW0KIyBDT05GSUdfRExNX0RFQlVHIGlz
IG5vdCBzZXQKCiMKIyBLZXJuZWwgaGFja2luZwojCkNPTkZJR19UUkFDRV9JUlFGTEFHU19T
VVBQT1JUPXkKQ09ORklHX1BSSU5US19USU1FPXkKQ09ORklHX0RFRkFVTFRfTUVTU0FHRV9M
T0dMRVZFTD00CkNPTkZJR19FTkFCTEVfV0FSTl9ERVBSRUNBVEVEPXkKQ09ORklHX0VOQUJM
RV9NVVNUX0NIRUNLPXkKQ09ORklHX0ZSQU1FX1dBUk49MjA0OApDT05GSUdfTUFHSUNfU1lT
UlE9eQpDT05GSUdfU1RSSVBfQVNNX1NZTVM9eQojIENPTkZJR19SRUFEQUJMRV9BU00gaXMg
bm90IHNldAojIENPTkZJR19VTlVTRURfU1lNQk9MUyBpcyBub3Qgc2V0CkNPTkZJR19ERUJV
R19GUz15CiMgQ09ORklHX0hFQURFUlNfQ0hFQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUJV
R19TRUNUSU9OX01JU01BVENIIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0tFUk5FTD15CiMg
Q09ORklHX0RFQlVHX1NISVJRIGlzIG5vdCBzZXQKQ09ORklHX0xPQ0tVUF9ERVRFQ1RPUj15
CkNPTkZJR19IQVJETE9DS1VQX0RFVEVDVE9SPXkKIyBDT05GSUdfQk9PVFBBUkFNX0hBUkRM
T0NLVVBfUEFOSUMgaXMgbm90IHNldApDT05GSUdfQk9PVFBBUkFNX0hBUkRMT0NLVVBfUEFO
SUNfVkFMVUU9MAojIENPTkZJR19CT09UUEFSQU1fU09GVExPQ0tVUF9QQU5JQyBpcyBub3Qg
c2V0CkNPTkZJR19CT09UUEFSQU1fU09GVExPQ0tVUF9QQU5JQ19WQUxVRT0wCiMgQ09ORklH
X1BBTklDX09OX09PUFMgaXMgbm90IHNldApDT05GSUdfUEFOSUNfT05fT09QU19WQUxVRT0w
CkNPTkZJR19ERVRFQ1RfSFVOR19UQVNLPXkKQ09ORklHX0RFRkFVTFRfSFVOR19UQVNLX1RJ
TUVPVVQ9MTIwCiMgQ09ORklHX0JPT1RQQVJBTV9IVU5HX1RBU0tfUEFOSUMgaXMgbm90IHNl
dApDT05GSUdfQk9PVFBBUkFNX0hVTkdfVEFTS19QQU5JQ19WQUxVRT0wCkNPTkZJR19TQ0hF
RF9ERUJVRz15CkNPTkZJR19TQ0hFRFNUQVRTPXkKQ09ORklHX1RJTUVSX1NUQVRTPXkKIyBD
T05GSUdfREVCVUdfT0JKRUNUUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NMVUJfREVCVUdfT04g
aXMgbm90IHNldAojIENPTkZJR19TTFVCX1NUQVRTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVf
REVCVUdfS01FTUxFQUs9eQojIENPTkZJR19ERUJVR19LTUVNTEVBSyBpcyBub3Qgc2V0CkNP
TkZJR19ERUJVR19QUkVFTVBUPXkKIyBDT05GSUdfREVCVUdfUlRfTVVURVhFUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUX01VVEVYX1RFU1RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X1NQSU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTVVURVhFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX0xPQ0tfQUxMT0MgaXMgbm90IHNldAojIENPTkZJR19QUk9WRV9M
T0NLSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVkVfUkNVX0RFTEFZIGlzIG5vdCBzZXQK
IyBDT05GSUdfU1BBUlNFX1JDVV9QT0lOVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9DS19T
VEFUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfQVRPTUlDX1NMRUVQIGlzIG5vdCBzZXQK
IyBDT05GSUdfREVCVUdfTE9DS0lOR19BUElfU0VMRlRFU1RTIGlzIG5vdCBzZXQKQ09ORklH
X1NUQUNLVFJBQ0U9eQojIENPTkZJR19ERUJVR19TVEFDS19VU0FHRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFQlVHX0tPQkpFQ1QgaXMgbm90IHNldApDT05GSUdfREVCVUdfQlVHVkVSQk9T
RT15CkNPTkZJR19ERUJVR19JTkZPPXkKIyBDT05GSUdfREVCVUdfSU5GT19SRURVQ0VEIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfVk0gaXMgbm90IHNldAojIENPTkZJR19ERUJVR19W
SVJUVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0
CkNPTkZJR19ERUJVR19NRU1PUllfSU5JVD15CiMgQ09ORklHX0RFQlVHX0xJU1QgaXMgbm90
IHNldAojIENPTkZJR19URVNUX0xJU1RfU09SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X1NHIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTk9USUZJRVJTIGlzIG5vdCBzZXQKIyBD
T05GSUdfREVCVUdfQ1JFREVOVElBTFMgaXMgbm90IHNldApDT05GSUdfQVJDSF9XQU5UX0ZS
QU1FX1BPSU5URVJTPXkKIyBDT05GSUdfRlJBTUVfUE9JTlRFUiBpcyBub3Qgc2V0CkNPTkZJ
R19CT09UX1BSSU5US19ERUxBWT15CiMgQ09ORklHX1JDVV9UT1JUVVJFX1RFU1QgaXMgbm90
IHNldApDT05GSUdfUkNVX0NQVV9TVEFMTF9USU1FT1VUPTYwCkNPTkZJR19SQ1VfQ1BVX1NU
QUxMX1ZFUkJPU0U9eQojIENPTkZJR19SQ1VfQ1BVX1NUQUxMX0lORk8gaXMgbm90IHNldAoj
IENPTkZJR19SQ1VfVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19LUFJPQkVTX1NBTklUWV9U
RVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS1RSQUNFX1NFTEZfVEVTVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX0JMT0NLX0VYVF9ERVZUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfRk9SQ0VfV0VBS19QRVJfQ1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUEVSX0NQ
VV9NQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfTEtEVE0gaXMgbm90IHNldAojIENPTkZJR19O
T1RJRklFUl9FUlJPUl9JTkpFQ1RJT04gaXMgbm90IHNldAojIENPTkZJR19GQVVMVF9JTkpF
Q1RJT04gaXMgbm90IHNldAojIENPTkZJR19MQVRFTkNZVE9QIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfUEFHRUFMTE9DIGlzIG5vdCBzZXQKQ09ORklHX1VTRVJfU1RBQ0tUUkFDRV9T
VVBQT1JUPXkKQ09ORklHX05PUF9UUkFDRVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFD
RVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQpDT05GSUdfSEFWRV9G
VU5DVElPTl9HUkFQSF9GUF9URVNUPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VfTUNP
VU5UX1RFU1Q9eQpDT05GSUdfSEFWRV9EWU5BTUlDX0ZUUkFDRT15CkNPTkZJR19IQVZFX0ZU
UkFDRV9NQ09VTlRfUkVDT1JEPXkKQ09ORklHX0hBVkVfU1lTQ0FMTF9UUkFDRVBPSU5UUz15
CkNPTkZJR19IQVZFX0ZFTlRSWT15CkNPTkZJR19IQVZFX0NfUkVDT1JETUNPVU5UPXkKQ09O
RklHX1RSQUNFX0NMT0NLPXkKQ09ORklHX1JJTkdfQlVGRkVSPXkKQ09ORklHX0VWRU5UX1RS
QUNJTkc9eQpDT05GSUdfRVZFTlRfUE9XRVJfVFJBQ0lOR19ERVBSRUNBVEVEPXkKQ09ORklH
X0NPTlRFWFRfU1dJVENIX1RSQUNFUj15CkNPTkZJR19SSU5HX0JVRkZFUl9BTExPV19TV0FQ
PXkKQ09ORklHX1RSQUNJTkc9eQpDT05GSUdfR0VORVJJQ19UUkFDRVI9eQpDT05GSUdfVFJB
Q0lOR19TVVBQT1JUPXkKQ09ORklHX0ZUUkFDRT15CiMgQ09ORklHX0ZVTkNUSU9OX1RSQUNF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSUVNPRkZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05G
SUdfUFJFRU1QVF9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9UUkFDRVIgaXMg
bm90IHNldAojIENPTkZJR19GVFJBQ0VfU1lTQ0FMTFMgaXMgbm90IHNldApDT05GSUdfQlJB
TkNIX1BST0ZJTEVfTk9ORT15CiMgQ09ORklHX1BST0ZJTEVfQU5OT1RBVEVEX0JSQU5DSEVT
IGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPRklMRV9BTExfQlJBTkNIRVMgaXMgbm90IHNldAoj
IENPTkZJR19TVEFDS19UUkFDRVIgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9JT19UUkFD
RT15CiMgQ09ORklHX0tQUk9CRV9FVkVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VQUk9CRV9F
VkVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BST0JFX0VWRU5UUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZUUkFDRV9TVEFSVFVQX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19NTUlPVFJBQ0Ug
aXMgbm90IHNldAojIENPTkZJR19SSU5HX0JVRkZFUl9CRU5DSE1BUksgaXMgbm90IHNldAoj
IENPTkZJR19SQlRSRUVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVSVkFMX1RSRUVf
VEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BST1ZJREVfT0hDSTEzOTRfRE1BX0lOSVQgaXMg
bm90IHNldAojIENPTkZJR19GSVJFV0lSRV9PSENJX1JFTU9URV9ETUEgaXMgbm90IHNldAoj
IENPTkZJR19EWU5BTUlDX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BX0FQSV9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX0FUT01JQzY0X1NFTEZURVNUIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVNZTkNfUkFJRDZfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRVMgaXMg
bm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tHREI9eQojIENPTkZJR19LR0RCIGlzIG5vdCBz
ZXQKQ09ORklHX0hBVkVfQVJDSF9LTUVNQ0hFQ0s9eQojIENPTkZJR19LTUVNQ0hFQ0sgaXMg
bm90IHNldAojIENPTkZJR19URVNUX0tTVFJUT1ggaXMgbm90IHNldApDT05GSUdfU1RSSUNU
X0RFVk1FTT15CkNPTkZJR19YODZfVkVSQk9TRV9CT09UVVA9eQpDT05GSUdfRUFSTFlfUFJJ
TlRLPXkKIyBDT05GSUdfRUFSTFlfUFJJTlRLX0RCR1AgaXMgbm90IHNldAojIENPTkZJR19E
RUJVR19TVEFDS09WRVJGTE9XIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1BURFVNUCBpcyBu
b3Qgc2V0CkNPTkZJR19ERUJVR19ST0RBVEE9eQojIENPTkZJR19ERUJVR19ST0RBVEFfVEVT
VCBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19TRVRfTU9EVUxFX1JPTlg9eQojIENPTkZJR19E
RUJVR19OWF9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfVExCRkxVU0ggaXMgbm90
IHNldAojIENPTkZJR19JT01NVV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0lPTU1VX1NU
UkVTUyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX01NSU9UUkFDRV9TVVBQT1JUPXkKIyBDT05G
SUdfWDg2X0RFQ09ERVJfU0VMRlRFU1QgaXMgbm90IHNldApDT05GSUdfSU9fREVMQVlfVFlQ
RV8wWDgwPTAKQ09ORklHX0lPX0RFTEFZX1RZUEVfMFhFRD0xCkNPTkZJR19JT19ERUxBWV9U
WVBFX1VERUxBWT0yCkNPTkZJR19JT19ERUxBWV9UWVBFX05PTkU9MwpDT05GSUdfSU9fREVM
QVlfMFg4MD15CiMgQ09ORklHX0lPX0RFTEFZXzBYRUQgaXMgbm90IHNldAojIENPTkZJR19J
T19ERUxBWV9VREVMQVkgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV9OT05FIGlzIG5v
dCBzZXQKQ09ORklHX0RFRkFVTFRfSU9fREVMQVlfVFlQRT0wCiMgQ09ORklHX0RFQlVHX0JP
T1RfUEFSQU1TIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1BBX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX09QVElNSVpFX0lOTElOSU5HPXkKIyBDT05GSUdfREVCVUdfU1RSSUNUX1VTRVJfQ09Q
WV9DSEVDS1MgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19OTUlfU0VMRlRFU1QgaXMgbm90
IHNldAoKIwojIFNlY3VyaXR5IG9wdGlvbnMKIwpDT05GSUdfS0VZUz15CiMgQ09ORklHX1RS
VVNURURfS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQ1JZUFRFRF9LRVlTIGlzIG5vdCBz
ZXQKQ09ORklHX0tFWVNfREVCVUdfUFJPQ19LRVlTPXkKIyBDT05GSUdfU0VDVVJJVFlfRE1F
U0dfUkVTVFJJQ1QgaXMgbm90IHNldApDT05GSUdfU0VDVVJJVFk9eQpDT05GSUdfU0VDVVJJ
VFlGUz15CkNPTkZJR19TRUNVUklUWV9ORVRXT1JLPXkKQ09ORklHX1NFQ1VSSVRZX05FVFdP
UktfWEZSTT15CkNPTkZJR19TRUNVUklUWV9QQVRIPXkKQ09ORklHX0lOVEVMX1RYVD15CiMg
Q09ORklHX1NFQ1VSSVRZX1NFTElOVVggaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9U
T01PWU8gaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9BUFBBUk1PUiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFQ1VSSVRZX1lBTUEgaXMgbm90IHNldAojIENPTkZJR19JTUEgaXMgbm90
IHNldAojIENPTkZJR19FVk0gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9TRUNVUklUWV9E
QUM9eQpDT05GSUdfREVGQVVMVF9TRUNVUklUWT0iIgpDT05GSUdfWE9SX0JMT0NLUz1tCkNP
TkZJR19BU1lOQ19DT1JFPW0KQ09ORklHX0FTWU5DX01FTUNQWT1tCkNPTkZJR19BU1lOQ19Y
T1I9bQpDT05GSUdfQVNZTkNfUFE9bQpDT05GSUdfQVNZTkNfUkFJRDZfUkVDT1Y9bQpDT05G
SUdfQVNZTkNfVFhfRElTQUJMRV9QUV9WQUxfRE1BPXkKQ09ORklHX0FTWU5DX1RYX0RJU0FC
TEVfWE9SX1ZBTF9ETUE9eQpDT05GSUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29yZSBvciBo
ZWxwZXIKIwpDT05GSUdfQ1JZUFRPX0ZJUFM9eQpDT05GSUdfQ1JZUFRPX0FMR0FQST15CkNP
TkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19DUllQVE9fQUVBRD1tCkNPTkZJR19DUllQ
VE9fQUVBRDI9eQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUj1tCkNPTkZJR19DUllQVE9fQkxL
Q0lQSEVSMj15CkNPTkZJR19DUllQVE9fSEFTSD15CkNPTkZJR19DUllQVE9fSEFTSDI9eQpD
T05GSUdfQ1JZUFRPX1JORz1tCkNPTkZJR19DUllQVE9fUk5HMj15CkNPTkZJR19DUllQVE9f
UENPTVA9bQpDT05GSUdfQ1JZUFRPX1BDT01QMj15CkNPTkZJR19DUllQVE9fTUFOQUdFUj15
CkNPTkZJR19DUllQVE9fTUFOQUdFUjI9eQojIENPTkZJR19DUllQVE9fVVNFUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19NQU5BR0VSX0RJU0FCTEVfVEVTVFMgaXMgbm90IHNldApD
T05GSUdfQ1JZUFRPX0dGMTI4TVVMPW0KQ09ORklHX0NSWVBUT19OVUxMPW0KQ09ORklHX0NS
WVBUT19QQ1JZUFQ9bQpDT05GSUdfQ1JZUFRPX1dPUktRVUVVRT15CkNPTkZJR19DUllQVE9f
Q1JZUFREPW0KQ09ORklHX0NSWVBUT19BVVRIRU5DPW0KQ09ORklHX0NSWVBUT19URVNUPW0K
Q09ORklHX0NSWVBUT19BQkxLX0hFTFBFUl9YODY9bQpDT05GSUdfQ1JZUFRPX0dMVUVfSEVM
UEVSX1g4Nj1tCgojCiMgQXV0aGVudGljYXRlZCBFbmNyeXB0aW9uIHdpdGggQXNzb2NpYXRl
ZCBEYXRhCiMKQ09ORklHX0NSWVBUT19DQ009bQpDT05GSUdfQ1JZUFRPX0dDTT1tCkNPTkZJ
R19DUllQVE9fU0VRSVY9bQoKIwojIEJsb2NrIG1vZGVzCiMKQ09ORklHX0NSWVBUT19DQkM9
bQpDT05GSUdfQ1JZUFRPX0NUUj1tCkNPTkZJR19DUllQVE9fQ1RTPW0KQ09ORklHX0NSWVBU
T19FQ0I9bQpDT05GSUdfQ1JZUFRPX0xSVz1tCkNPTkZJR19DUllQVE9fUENCQz1tCkNPTkZJ
R19DUllQVE9fWFRTPW0KCiMKIyBIYXNoIG1vZGVzCiMKQ09ORklHX0NSWVBUT19ITUFDPW0K
Q09ORklHX0NSWVBUT19YQ0JDPW0KQ09ORklHX0NSWVBUT19WTUFDPW0KCiMKIyBEaWdlc3QK
IwpDT05GSUdfQ1JZUFRPX0NSQzMyQz1tCkNPTkZJR19DUllQVE9fQ1JDMzJDX0lOVEVMPW0K
Q09ORklHX0NSWVBUT19HSEFTSD1tCkNPTkZJR19DUllQVE9fTUQ0PW0KQ09ORklHX0NSWVBU
T19NRDU9eQpDT05GSUdfQ1JZUFRPX01JQ0hBRUxfTUlDPW0KQ09ORklHX0NSWVBUT19STUQx
Mjg9bQpDT05GSUdfQ1JZUFRPX1JNRDE2MD1tCkNPTkZJR19DUllQVE9fUk1EMjU2PW0KQ09O
RklHX0NSWVBUT19STUQzMjA9bQpDT05GSUdfQ1JZUFRPX1NIQTE9bQpDT05GSUdfQ1JZUFRP
X1NIQTFfU1NTRTM9bQpDT05GSUdfQ1JZUFRPX1NIQTI1Nj1tCkNPTkZJR19DUllQVE9fU0hB
NTEyPW0KQ09ORklHX0NSWVBUT19UR1IxOTI9bQpDT05GSUdfQ1JZUFRPX1dQNTEyPW0KQ09O
RklHX0NSWVBUT19HSEFTSF9DTE1VTF9OSV9JTlRFTD1tCgojCiMgQ2lwaGVycwojCkNPTkZJ
R19DUllQVE9fQUVTPXkKQ09ORklHX0NSWVBUT19BRVNfWDg2XzY0PW0KQ09ORklHX0NSWVBU
T19BRVNfTklfSU5URUw9bQpDT05GSUdfQ1JZUFRPX0FOVUJJUz1tCkNPTkZJR19DUllQVE9f
QVJDND1tCkNPTkZJR19DUllQVE9fQkxPV0ZJU0g9bQpDT05GSUdfQ1JZUFRPX0JMT1dGSVNI
X0NPTU1PTj1tCkNPTkZJR19DUllQVE9fQkxPV0ZJU0hfWDg2XzY0PW0KQ09ORklHX0NSWVBU
T19DQU1FTExJQT1tCkNPTkZJR19DUllQVE9fQ0FNRUxMSUFfWDg2XzY0PW0KQ09ORklHX0NS
WVBUT19DQVNUNT1tCkNPTkZJR19DUllQVE9fQ0FTVDVfQVZYX1g4Nl82ND1tCkNPTkZJR19D
UllQVE9fQ0FTVDY9bQpDT05GSUdfQ1JZUFRPX0NBU1Q2X0FWWF9YODZfNjQ9bQpDT05GSUdf
Q1JZUFRPX0RFUz1tCkNPTkZJR19DUllQVE9fRkNSWVBUPW0KQ09ORklHX0NSWVBUT19LSEFa
QUQ9bQpDT05GSUdfQ1JZUFRPX1NBTFNBMjA9bQpDT05GSUdfQ1JZUFRPX1NBTFNBMjBfWDg2
XzY0PW0KQ09ORklHX0NSWVBUT19TRUVEPW0KQ09ORklHX0NSWVBUT19TRVJQRU5UPW0KQ09O
RklHX0NSWVBUT19TRVJQRU5UX1NTRTJfWDg2XzY0PW0KQ09ORklHX0NSWVBUT19TRVJQRU5U
X0FWWF9YODZfNjQ9bQpDT05GSUdfQ1JZUFRPX1RFQT1tCkNPTkZJR19DUllQVE9fVFdPRklT
SD1tCkNPTkZJR19DUllQVE9fVFdPRklTSF9DT01NT049bQpDT05GSUdfQ1JZUFRPX1RXT0ZJ
U0hfWDg2XzY0PW0KQ09ORklHX0NSWVBUT19UV09GSVNIX1g4Nl82NF8zV0FZPW0KQ09ORklH
X0NSWVBUT19UV09GSVNIX0FWWF9YODZfNjQ9bQoKIwojIENvbXByZXNzaW9uCiMKQ09ORklH
X0NSWVBUT19ERUZMQVRFPW0KQ09ORklHX0NSWVBUT19aTElCPW0KQ09ORklHX0NSWVBUT19M
Wk89eQoKIwojIFJhbmRvbSBOdW1iZXIgR2VuZXJhdGlvbgojCkNPTkZJR19DUllQVE9fQU5T
SV9DUFJORz1tCkNPTkZJR19DUllQVE9fVVNFUl9BUEk9bQpDT05GSUdfQ1JZUFRPX1VTRVJf
QVBJX0hBU0g9bQpDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX1NLQ0lQSEVSPW0KQ09ORklHX0NS
WVBUT19IVz15CkNPTkZJR19DUllQVE9fREVWX1BBRExPQ0s9bQpDT05GSUdfQ1JZUFRPX0RF
Vl9QQURMT0NLX0FFUz1tCkNPTkZJR19DUllQVE9fREVWX1BBRExPQ0tfU0hBPW0KQ09ORklH
X0FTWU1NRVRSSUNfS0VZX1RZUEU9bQpDT05GSUdfQVNZTU1FVFJJQ19QVUJMSUNfS0VZX1NV
QlRZUEU9bQpDT05GSUdfUFVCTElDX0tFWV9BTEdPX1JTQT1tCkNPTkZJR19YNTA5X0NFUlRJ
RklDQVRFX1BBUlNFUj1tCkNPTkZJR19IQVZFX0tWTT15CiMgQ09ORklHX1ZJUlRVQUxJWkFU
SU9OIGlzIG5vdCBzZXQKQ09ORklHX0JJTkFSWV9QUklOVEY9eQoKIwojIExpYnJhcnkgcm91
dGluZXMKIwpDT05GSUdfUkFJRDZfUFE9bQpDT05GSUdfQklUUkVWRVJTRT15CkNPTkZJR19H
RU5FUklDX1NUUk5DUFlfRlJPTV9VU0VSPXkKQ09ORklHX0dFTkVSSUNfU1RSTkxFTl9VU0VS
PXkKQ09ORklHX0dFTkVSSUNfRklORF9GSVJTVF9CSVQ9eQpDT05GSUdfR0VORVJJQ19QQ0lf
SU9NQVA9eQpDT05GSUdfR0VORVJJQ19JT01BUD15CkNPTkZJR19HRU5FUklDX0lPPXkKQ09O
RklHX0NSQ19DQ0lUVD1tCkNPTkZJR19DUkMxNj1tCkNPTkZJR19DUkNfVDEwRElGPXkKQ09O
RklHX0NSQ19JVFVfVD1tCkNPTkZJR19DUkMzMj15CiMgQ09ORklHX0NSQzMyX1NFTEZURVNU
IGlzIG5vdCBzZXQKQ09ORklHX0NSQzMyX1NMSUNFQlk4PXkKIyBDT05GSUdfQ1JDMzJfU0xJ
Q0VCWTQgaXMgbm90IHNldAojIENPTkZJR19DUkMzMl9TQVJXQVRFIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JDMzJfQklUIGlzIG5vdCBzZXQKQ09ORklHX0NSQzc9bQpDT05GSUdfTElCQ1JD
MzJDPW0KQ09ORklHX0NSQzg9bQpDT05GSUdfWkxJQl9JTkZMQVRFPXkKQ09ORklHX1pMSUJf
REVGTEFURT1tCkNPTkZJR19MWk9fQ09NUFJFU1M9eQpDT05GSUdfTFpPX0RFQ09NUFJFU1M9
eQpDT05GSUdfWFpfREVDPXkKQ09ORklHX1haX0RFQ19YODY9eQpDT05GSUdfWFpfREVDX1BP
V0VSUEM9eQpDT05GSUdfWFpfREVDX0lBNjQ9eQpDT05GSUdfWFpfREVDX0FSTT15CkNPTkZJ
R19YWl9ERUNfQVJNVEhVTUI9eQpDT05GSUdfWFpfREVDX1NQQVJDPXkKQ09ORklHX1haX0RF
Q19CQ0o9eQojIENPTkZJR19YWl9ERUNfVEVTVCBpcyBub3Qgc2V0CkNPTkZJR19ERUNPTVBS
RVNTX0daSVA9eQpDT05GSUdfREVDT01QUkVTU19CWklQMj15CkNPTkZJR19ERUNPTVBSRVNT
X0xaTUE9eQpDT05GSUdfREVDT01QUkVTU19YWj15CkNPTkZJR19ERUNPTVBSRVNTX0xaTz15
CkNPTkZJR19HRU5FUklDX0FMTE9DQVRPUj15CkNPTkZJR19SRUVEX1NPTE9NT049bQpDT05G
SUdfUkVFRF9TT0xPTU9OX0VOQzg9eQpDT05GSUdfUkVFRF9TT0xPTU9OX0RFQzg9eQpDT05G
SUdfUkVFRF9TT0xPTU9OX0RFQzE2PXkKQ09ORklHX1RFWFRTRUFSQ0g9eQpDT05GSUdfVEVY
VFNFQVJDSF9LTVA9bQpDT05GSUdfVEVYVFNFQVJDSF9CTT1tCkNPTkZJR19URVhUU0VBUkNI
X0ZTTT1tCkNPTkZJR19CVFJFRT15CkNPTkZJR19IQVNfSU9NRU09eQpDT05GSUdfSEFTX0lP
UE9SVD15CkNPTkZJR19IQVNfRE1BPXkKQ09ORklHX0NIRUNLX1NJR05BVFVSRT15CkNPTkZJ
R19DUFVfUk1BUD15CkNPTkZJR19EUUw9eQpDT05GSUdfTkxBVFRSPXkKQ09ORklHX0FSQ0hf
SEFTX0FUT01JQzY0X0RFQ19JRl9QT1NJVElWRT15CkNPTkZJR19MUlVfQ0FDSEU9bQpDT05G
SUdfQVZFUkFHRT15CkNPTkZJR19DTFpfVEFCPXkKQ09ORklHX0NPUkRJQz1tCkNPTkZJR19E
RFI9eQpDT05GSUdfTVBJTElCPW0KQ09ORklHX09JRF9SRUdJU1RSWT1tCgo=
--------------060806000304070006020108--
