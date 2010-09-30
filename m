Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0I3SrR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 30 Sep 2010 14:47:17 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:34004 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0I3SrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:47:14 -0400
From: =?koi8-r?Q?=F2=CF=CD=C1=CE_=E6=D2=C1=CE=DE=D5=CB?= 
	<franchukrom@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?PROBLEM=3A_Bluetooth_crashes_system?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [94.153.201.66]
Date: Thu, 30 Sep 2010 22:43:40 +0400
Reply-To: =?koi8-r?Q?=F2=CF=CD=C1=CE_=E6=D2=C1=CE=DE=D5=CB?= 
	  <franchukrom@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1P1O6W-0001in-00.franchukrom-mail-ru@f202.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROBLEM: Bluetooth crashes system

My smartphone sometimes reboots because of overflowing of memory. Sometimes after it bluetooth does not work. Wvdial (and other dialers that i tested - simple pppd, pon/poff, kppp) simply freezes after it. I can not kill it by `killall wvdial` or `killall -s 9 wvdial`.

I found that it prints following strings to kern.log:
Sep 30 20:45:26 debiankomp kernel: [ 5141.956200] BUG: unable to handle kernel NULL pointer dereference at 00000038
Sep 30 20:45:26 debiankomp kernel: [ 5141.956213] IP: [<c11d38a5>] __sock_sendmsg+0x45/0x4e
Sep 30 20:45:26 debiankomp kernel: [ 5141.956232] *pde = 00000000 
Sep 30 20:45:26 debiankomp kernel: [ 5141.956238] Oops: 0000 [#1] SMP 
Sep 30 20:45:26 debiankomp kernel: [ 5141.956244] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host1/target1:0:0/1:0:0:0/block/sr0/uevent
Sep 30 20:45:26 debiankomp kernel: [ 5141.956252] Modules linked in: udf crc_itu_t nls_cp437 vfat fat usb_storage ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc binfmt_misc rfcomm l2cap crc16 ppdev lp ext2 nls_utf8 isofs fuse loop snd_cmipci gameport snd_pcm_oss snd_mixer_oss nvidia(P) snd_pcm dst snd_page_alloc snd_opl3_lib snd_hwdep snd_mpu401_uart dvb_bt8xx dvb_core ir_sony_decoder ir_jvc_decoder snd_seq_midi snd_rawmidi ir_rc6_decoder snd_seq_midi_event snd_seq ir_rc5_decoder bt878 bttv v4l2_common ir_nec_decoder snd_timer snd_seq_device videodev v4l1_compat i2c_algo_bit videobuf_dma_sg videobuf_core btcx_risc ir_common ir_core snd tveeprom processor button soundcore parport_pc parport btusb bluetooth usblp rfkill evdev tpm_tis tpm tpm_bios pcspkr shpchp i2c_i801 rng_core i2c_core pci_hotplug ext3 jbd mbcache sg usbhid hid sd_mod sr_mod crc_t10dif cdrom ata_generic ata_piix libata uhci_hcd ehci_hcd fan 8139cp 8139too usbcore scsi_mod mii thermal fl
 oppy thermal_sys nls_base [last unloaded:
Sep 30 20:45:26 debiankomp kernel: scsi_wait_scan]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956390] 
Sep 30 20:45:26 debiankomp kernel: [ 5141.956399] Pid: 1889, comm: wvdial Tainted: P            2.6.35-trunk-686 #1 845PE-W83637F/ 
Sep 30 20:45:26 debiankomp kernel: [ 5141.956405] EIP: 0060:[<c11d38a5>] EFLAGS: 00010246 CPU: 0
Sep 30 20:45:26 debiankomp kernel: [ 5141.956412] EIP is at __sock_sendmsg+0x45/0x4e
Sep 30 20:45:26 debiankomp kernel: [ 5141.956416] EAX: f680dc7c EBX: 00000000 ECX: f680dd48 EDX: f4e33800
Sep 30 20:45:26 debiankomp kernel: [ 5141.956422] ESI: f4e33800 EDI: f680dc7c EBP: f680dd48 ESP: f680dc60
Sep 30 20:45:26 debiankomp kernel: [ 5141.956427]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Sep 30 20:45:26 debiankomp kernel: [ 5141.956433] Process wvdial (pid: 1889, ti=f680c000 task=f5491ce0 task.ti=f680c000)
Sep 30 20:45:26 debiankomp kernel: [ 5141.956437] Stack:
Sep 30 20:45:26 debiankomp kernel: [ 5141.956440]  00000004 f680dc7c f680c000 f680dd64 f617c400 c11d3ad4 00000004 c2008140
Sep 30 20:45:26 debiankomp kernel: [ 5141.956452] <0> f708f5a0 00000000 00000001 ffffffff 00000000 00000000 00000000 00000000
Sep 30 20:45:26 debiankomp kernel: [ 5141.956463] <0> 00000000 f5491ce0 00000000 00000000 f6e360e0 c10cedce f680dcec 00000000
Sep 30 20:45:26 debiankomp kernel: [ 5141.956476] Call Trace:
Sep 30 20:45:26 debiankomp kernel: [ 5141.956485]  [<c11d3ad4>] ? sock_sendmsg+0x78/0x8f
Sep 30 20:45:26 debiankomp kernel: [ 5141.956495]  [<c10cedce>] ? __find_get_block+0x14f/0x159
Sep 30 20:45:26 debiankomp kernel: [ 5141.956504]  [<c1088e7d>] ? find_get_page+0x1d/0x6d
Sep 30 20:45:26 debiankomp kernel: [ 5141.956513]  [<c1020631>] ? kmap_atomic_prot+0xa6/0xc1
Sep 30 20:45:26 debiankomp kernel: [ 5141.956520]  [<c10cee03>] ? __getblk+0x2b/0x2f7
Sep 30 20:45:26 debiankomp kernel: [ 5141.956540]  [<c11d3b12>] ? kernel_sendmsg+0x27/0x35
Sep 30 20:45:26 debiankomp kernel: [ 5141.956552]  [<f956d0df>] ? rfcomm_send_frame+0x2e/0x35 [rfcomm]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956562]  [<f956d138>] ? rfcomm_send_disc+0x52/0x54 [rfcomm]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956571]  [<f956d55a>] ? __rfcomm_dlc_close+0x4e/0x199 [rfcomm]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956581]  [<c12763be>] ? mutex_lock+0xb/0x24
Sep 30 20:45:26 debiankomp kernel: [ 5141.956590]  [<f956d96e>] ? rfcomm_dlc_close+0x1d/0x2e [rfcomm]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956601]  [<f95709f8>] ? rfcomm_tty_close+0x3b/0xa6 [rfcomm]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956611]  [<c1194166>] ? tty_release+0x1d7/0x4c6
Sep 30 20:45:26 debiankomp kernel: [ 5141.956618]  [<c1275ba7>] ? schedule+0x4a0/0x4df
Sep 30 20:45:26 debiankomp kernel: [ 5141.956628]  [<c11d9505>] ? skb_dequeue+0x40/0x46
Sep 30 20:45:26 debiankomp kernel: [ 5141.956637]  [<f9570c64>] ? rfcomm_tty_open+0x201/0x23a [rfcomm]
Sep 30 20:45:26 debiankomp kernel: [ 5141.956646]  [<c102aeb4>] ? default_wake_function+0x0/0x8
Sep 30 20:45:26 debiankomp kernel: [ 5141.956653]  [<c1194c40>] ? tty_open+0x334/0x459
Sep 30 20:45:26 debiankomp kernel: [ 5141.956662]  [<c10b6c82>] ? chrdev_open+0xfa/0x110
Sep 30 20:45:26 debiankomp kernel: [ 5141.956669]  [<c10b3428>] ? __dentry_open+0x131/0x21a
Sep 30 20:45:26 debiankomp kernel: [ 5141.956676]  [<c10b35a1>] ? nameidata_to_filp+0x29/0x39
Sep 30 20:45:26 debiankomp kernel: [ 5141.956682]  [<c10b6b88>] ? chrdev_open+0x0/0x110
Sep 30 20:45:26 debiankomp kernel: [ 5141.956691]  [<c10bc572>] ? do_last+0x35f/0x446
Sep 30 20:45:26 debiankomp kernel: [ 5141.956697]  [<c10bdaf3>] ? do_filp_open+0x1a0/0x49c
Sep 30 20:45:26 debiankomp kernel: [ 5141.956705]  [<c10b3204>] ? do_sys_open+0x49/0xdd
Sep 30 20:45:26 debiankomp kernel: [ 5141.956712]  [<c10b32dc>] ? sys_open+0x1e/0x23
Sep 30 20:45:26 debiankomp kernel: [ 5141.956720]  [<c1002f1f>] ? sysenter_do_call+0x12/0x28
Sep 30 20:45:26 debiankomp kernel: [ 5141.956725] Code: c7 43 18 00 00 00 00 89 6b 1c 8b 44 24 14 89 43 0c 89 c1 89 f0 e8 29 03 f3 ff 85 c0 75 11 8b 5e 18 89 f8 89 e9 ff 74 24 14 89 f2 <ff> 53 38 5f 5b 5e 5f 5d c3 55 57 89 d7 56 89 ce 53 89 f2 83 ec 
Sep 30 20:45:26 debiankomp kernel: [ 5141.956785] EIP: [<c11d38a5>] __sock_sendmsg+0x45/0x4e SS:ESP 0068:f680dc60
Sep 30 20:45:26 debiankomp kernel: [ 5141.956795] CR2: 0000000000000038
Sep 30 20:45:26 debiankomp kernel: [ 5141.956802] ---[ end trace c02da668bc28d534 ]---

Now I am using ASUS BT-211 (ath3k kernel module), but i got the same bug with other bluetooth adapters.

Keywords: modules, bluetooth, crash

I use Debian GNU/Linux 5.0 (with updated kernel). Now I am using experimental prebuilt 2.6.35-trunk kernel, but i had the same bug with 2.6.32 from squeeze and with 2.6.34 vanilla. I did not use git bisect because i have slow internet (i can not download git kernel tree) and i need much time to reproduce this bug. But I detected that this bug does not affects 2.6.26 and older (but now i can not use it - ath3k are only supported by 2.6.33 and newer).
/proc/version:
Linux version 2.6.35-trunk-686 (Debian 2.6.35-1~experimental.3) (maks@debian.org) (gcc version 4.4.5 20100728 (prerelease) (Debian 4.4.4-8) ) #1 SMP Mon Sep 6 17:54:16 UTC 2010
/proc/cpuinfo:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 1
model name      : Intel(R) Celeron(R) CPU 1.80GHz
stepping        : 3
cpu MHz         : 1795.361
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm up pebs bts
bogomips        : 3590.72
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 32 bits virtual
power management:

/proc/modules:
nls_cp437 4835 1 - Live 0xf81f7000
vfat 6707 1 - Live 0xf81a1000
fat 38029 1 vfat, Live 0xf81dc000
ppp_deflate 2994 0 - Live 0xf815c000
zlib_deflate 16799 1 ppp_deflate, Live 0xf8151000
bsd_comp 4035 0 - Live 0xf8124000
ppp_async 5468 1 - Live 0xf8113000
crc_ccitt 1311 1 ppp_async, Live 0xf80dc000
ppp_generic 18395 7 ppp_deflate,bsd_comp,ppp_async, Live 0xf80ce000
slhc 4214 1 ppp_generic, Live 0xf8078000
binfmt_misc 5344 1 - Live 0xf95b9000
rfcomm 25909 5 - Live 0xf95a5000
l2cap 26064 7 rfcomm, Live 0xf958a000
crc16 1303 1 l2cap, Live 0xf9577000
ppdev 4712 0 - Live 0xf956d000
lp 6380 0 - Live 0xf9561000
ext2 47589 1 - Live 0xf9547000
nls_utf8 997 6 - Live 0xf952b000
isofs 26080 5 - Live 0xf950e000
fuse 49720 7 - Live 0xf94ed000
loop 10855 12 - Live 0xf94ce000
snd_cmipci 25019 1 - Live 0xf9463000
dst 22264 1 - Live 0xf944a000
gameport 7773 1 snd_cmipci, Live 0xf9442000
snd_pcm_oss 28040 0 - Live 0xf9424000
snd_mixer_oss 10670 1 snd_pcm_oss, Live 0xf940f000
nvidia 4692093 22 - Live 0xf8ebd000 (P)
snd_pcm 57103 2 snd_cmipci,snd_pcm_oss, Live 0xf93a8000
snd_page_alloc 6240 1 snd_pcm, Live 0xf8eb6000
dvb_bt8xx 10989 0 - Live 0xf8d76000
snd_opl3_lib 7502 1 snd_cmipci, Live 0xf8d69000
snd_hwdep 4408 1 snd_opl3_lib, Live 0xf8d5c000
snd_mpu401_uart 4625 1 snd_cmipci, Live 0xf8d50000
dvb_core 73035 2 dst,dvb_bt8xx, Live 0xf8d27000
ir_sony_decoder 2590 0 - Live 0xf8d06000
ir_jvc_decoder 2609 0 - Live 0xf8cfc000
snd_seq_midi 3998 0 - Live 0xf8cf2000
snd_rawmidi 15712 2 snd_mpu401_uart,snd_seq_midi, Live 0xf8ce2000
ir_rc6_decoder 3005 0 - Live 0xf8cdc000
snd_seq_midi_event 5101 1 snd_seq_midi, Live 0xf8cc7000
ir_rc5_decoder 2637 0 - Live 0xf8cbc000
snd_seq 38568 2 snd_seq_midi,snd_seq_midi_event, Live 0xf8ca6000
bt878 6575 2 dst,dvb_bt8xx, Live 0xf8c8b000
bttv 96004 2 dvb_bt8xx,bt878, Live 0xf8c27000
snd_timer 14813 3 snd_pcm,snd_opl3_lib,snd_seq, Live 0xf8c77000
ir_nec_decoder 2837 0 - Live 0xf8c24000
snd_seq_device 4816 4 snd_opl3_lib,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8c1d000
v4l2_common 15537 1 bttv, Live 0xf8bc0000
snd 44384 13 snd_cmipci,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_opl3_lib,snd_hwdep,snd_mpu401_uart,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf8b7e000
videodev 35773 2 bttv,v4l2_common, Live 0xf8ba2000
v4l1_compat 10677 1 videodev, Live 0xf8b76000
i2c_algo_bit 4026 1 bttv, Live 0xf8b6a000
videobuf_dma_sg 8636 1 bttv, Live 0xf8b46000
videobuf_core 14493 2 bttv,videobuf_dma_sg, Live 0xf8b2c000
btcx_risc 3344 1 bttv, Live 0xf8b1e000
ir_common 4478 1 bttv, Live 0xf85e6000
ir_core 11254 7 ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,bttv,ir_common, Live 0xf85d8000
processor 28002 0 - Live 0xf8587000
tveeprom 10286 1 bttv, Live 0xf85af000
soundcore 5378 1 snd, Live 0xf8561000
button 4474 0 - Live 0xf8555000
parport_pc 17206 1 - Live 0xf8544000
btusb 8922 4 - Live 0xf8527000
parport 26678 3 ppdev,lp,parport_pc, Live 0xf8519000
bluetooth 41908 7 rfcomm,l2cap,btusb, Live 0xf84b6000
evdev 5954 9 - Live 0xf84d0000
rfkill 13674 1 bluetooth, Live 0xf8498000
tpm_tis 6578 0 - Live 0xf8464000
i2c_i801 7329 0 - Live 0xf8474000
tpm 11821 1 tpm_tis, Live 0xf842b000
pcspkr 1318 0 - Live 0xf8438000
tpm_bios 4225 1 tpm, Live 0xf841c000
shpchp 23331 0 - Live 0xf83ea000
i2c_core 18031 9 dst,nvidia,dvb_bt8xx,bttv,v4l2_common,videodev,i2c_algo_bit,tveeprom,i2c_i801, Live 0xf83d9000
rng_core 2912 0 - Live 0xf83bd000
pci_hotplug 20657 1 shpchp, Live 0xf83ac000
ext3 96786 1 - Live 0xf837e000
jbd 37811 1 ext3, Live 0xf8346000
mbcache 5436 2 ext2,ext3, Live 0xf832e000
sg 16776 0 - Live 0xf8315000
usbhid 30270 0 - Live 0xf82e0000
hid 55417 1 usbhid, Live 0xf82bd000
usb_storage 34984 1 - Live 0xf8294000
sd_mod 28346 8 - Live 0xf8260000
sr_mod 11260 0 - Live 0xf8275000
cdrom 28530 1 sr_mod, Live 0xf8245000
crc_t10dif 1195 1 sd_mod, Live 0xf8233000
ata_generic 2343 0 - Live 0xf822a000
ata_piix 18515 5 - Live 0xf821a000
libata 143896 2 ata_generic,ata_piix, Live 0xf81a5000
ehci_hcd 28697 0 - Live 0xf81e9000
uhci_hcd 16457 0 - Live 0xf8200000
8139cp 14248 0 - Live 0xf815e000
fan 2759 0 - Live 0xf816c000
8139too 16740 0 - Live 0xf814a000
usbcore 121252 6 btusb,usbhid,usb_storage,uhci_hcd,ehci_hcd, Live 0xf804d000
scsi_mod 151927 5 sg,usb_storage,sr_mod,sd_mod,libata, Live 0xf80a6000
mii 3773 2 8139cp,8139too, Live 0xf8139000
thermal 10520 0 - Live 0xf812c000
thermal_sys 11304 3 processor,fan,thermal, Live 0xf811b000
floppy 45347 0 - Live 0xf80ff000
nls_base 5877 6 nls_cp437,vfat,fat,nls_utf8,isofs,usbcore, Live 0xf8018000

/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
0294-0297 : pnp 00:01
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
03f7-03f7 : floppy
03f8-03ff : serial
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0428-042f : ACPI GPE0_BLK
0480-04bf : 0000:00:1f.0
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0800-0805 : pnp 00:01
0a78-0a7b : pnp 00:01
0b78-0b7b : pnp 00:01
0bbc-0bbf : pnp 00:01
0cf8-0cff : PCI conf1
0e78-0e7b : pnp 00:01
0f78-0f7b : pnp 00:01
0fbc-0fbf : pnp 00:01
c000-cfff : PCI Bus 0000:02
  c000-c0ff : 0000:02:00.0
    c000-c0ff : CMI8738-MC6
  c400-c4ff : 0000:02:06.0
    c400-c4ff : 8139too
d000-d01f : 0000:00:1d.1
  d000-d01f : uhci_hcd
d400-d41f : 0000:00:1d.2
  d400-d41f : uhci_hcd
d800-d81f : 0000:00:1d.0
  d800-d81f : uhci_hcd
f000-f00f : 0000:00:1f.1
  f000-f00f : ata_piix

/proc/iomem:
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-4ffeffff : System RAM
  01000000-0127c2ab : Kernel code
  0127c2ac-01427d3f : Kernel data
  0148d000-0153ec67 : Kernel bss
4fff0000-4fff2fff : ACPI Non-volatile Storage
4fff3000-4fffffff : ACPI Tables
50000000-500003ff : 0000:00:1f.1
d0000000-d7ffffff : 0000:00:00.0
d8000000-dfffffff : PCI Bus 0000:01
  d8000000-dfffffff : 0000:01:00.0
e0000000-e1ffffff : PCI Bus 0000:01
  e0000000-e0ffffff : 0000:01:00.0
    e0000000-e0ffffff : nvidia
  e1000000-e101ffff : 0000:01:00.0
e2000000-e20fffff : PCI Bus 0000:02
  e2000000-e20000ff : 0000:02:06.0
    e2000000-e20000ff : 8139too
e2100000-e21fffff : PCI Bus 0000:02
  e2100000-e2100fff : 0000:02:03.0
    e2100000-e2100fff : bttv0
  e2101000-e2101fff : 0000:02:03.1
    e2101000-e2101fff : bt878
e2200000-e22003ff : 0000:00:1d.7
  e2200000-e22003ff : ehci_hcd
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fee00000-fee00fff : Local APIC

lspci -vvv:
00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface (rev 03)
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [e4] Vendor Specific Information <?>
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- Rate=x4
        Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE Host-to-AGP Bridge (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: e0000000-e1ffffff
        Prefetchable memory behind bridge: d8000000-dfffffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at d800 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at d000 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at d400 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at e2200000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
        Latency: 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: e2000000-e20fffff
        Prefetchable memory behind bridge: e2100000-e21fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Kernel modules: shpchp

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Kernel modules: intel-rng, iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at f000 [size=16]
        Region 5: Memory at 50000000 (32-bit, non-prefetchable) [size=1K]
        Kernel driver in use: ata_piix
        Kernel modules: ata_piix

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 02)
        Subsystem: Elitegroup Computer Systems Device 1862
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 0500 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX 440 AGP 8x] (rev a4) (prog-if 00 [VGA controller])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 248 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at d8000000 (32-bit, prefetchable) [size=128M]
        [virtual] Expansion ROM at e1000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 3.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=32 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- Rate=x4
        Kernel driver in use: nvidia
        Kernel modules: nvidiafb, nvidia

02:00.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
        Subsystem: C-Media Electronics Inc CMI8738/C3DX PCI Audio Device
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (500ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at c000 [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: C-Media PCI
        Kernel modules: snd-cmipci

02:03.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
        Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB card
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e2100000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bttv
        Kernel modules: bttv

02:03.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
        Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB Card
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e2101000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bt878
        Kernel modules: bt878

02:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: I/O ports at c400 [size=256]
        Region 1: Memory at e2000000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: 8139too
        Kernel modules: 8139too, 8139cp

lsusb -vvv:
Bus 002 Device 004: ID 0458:003a KYE Systems Corp. (Mouse Systems) NetScroll+ Mini Traveler
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0458 KYE Systems Corp. (Mouse Systems)
  idProduct          0x003a NetScroll+ Mini Traveler
  bcdDevice            1.00
  iManufacturer           1 Genius
  iProduct                2 Optical Mouse
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 HID-compliant MOUSE
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      62
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.35-trunk-686 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0303 lowspeed power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 003: ID 0cf3:3002 Atheros Communications, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x0cf3 Atheros Communications, Inc.
  idProduct          0x3002
  bcdDevice            0.01
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          177
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.35-trunk-686 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 003 Device 004: ID 058f:6387 Alcor Micro Corp. Transcend JetFlash Flash Drive
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x6387 Transcend JetFlash Flash Drive
  bcdDevice            1.00
  iManufacturer           1 JetFlash
  iProduct                2 Mass Storage Device
  iSerial                 3 RXDQALXA
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
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
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.35-trunk-686 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0503 highspeed power enable connect
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.35-trunk-686 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled
