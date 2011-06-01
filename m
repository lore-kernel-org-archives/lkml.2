Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab1FAQnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:43:43 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:64059 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758389Ab1FAQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:43:40 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.0-rc1 problem with usb, cdrom
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Wed, 01 Jun 2011 12:43:36 -0400
Message-ID: <web-538043386@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.0-rc1 have the following problems, on my computer 
and some laptops:

/ during booting, udev initialization, it stops several 
times  appr. 1 minute  (but don't crash)

/ At the beginning, the system behaves normal, but later 
the usb system don't work at all; then no periferics 
connected (like: printer, usb key , ...) is recognized 
with lsusb, and the KDE3 device manager stops to work

/ On mounting a dvd with /mount /dev/sr0 /cdrom  ,  an 
error messages comes, it dont mount


Below see the syslog.    At 13:30, attempt to find sdb , 
is a sucessless attempt to find the usb key  (lsusb dont 
find it).    At 13:33, attempt to mount a dvd.


W.Landgraf



==================
Jun  1 13:30:13 werner kernel: sd 7:0:0:0: [sdb] No 
Caching mode page present
Jun  1 13:30:13 werner kernel: sd 7:0:0:0: [sdb] Assuming 
drive cache: write through
Jun  1 13:30:13 werner kernel: sd 7:0:0:0: [sdb] No 
Caching mode page present
Jun  1 13:30:13 werner kernel: sd 7:0:0:0: [sdb] Assuming 
drive cache: write through
Jun  1 13:30:13 werner kernel: sd 7:0:0:0: [sdb] No 
Caching mode page present
Jun  1 13:30:13 werner kernel: sd 7:0:0:0: [sdb] Assuming 
drive cache: write through
Jun  1 13:30:45 werner kernel: sd 8:0:0:0: [sdb] No 
Caching mode page present
Jun  1 13:30:45 werner kernel: sd 8:0:0:0: [sdb] Assuming 
drive cache: write through
Jun  1 13:30:45 werner kernel: sd 8:0:0:0: [sdb] No 
Caching mode page present
Jun  1 13:30:45 werner kernel: sd 8:0:0:0: [sdb] Assuming 
drive cache: write through
Jun  1 13:30:45 werner kernel: sd 8:0:0:0: [sdb] No 
Caching mode page present
Jun  1 13:30:45 werner kernel: sd 8:0:0:0: [sdb] Assuming 
drive cache: write through
Jun  1 13:33:25 werner kernel: BUG: unable to handle 
kernel NULL pointer dereference at 000001cd
Jun  1 13:33:25 werner kernel: IP: [<c10ffe3e>] 
blkdev_get+0xe7/0x125
Jun  1 13:33:25 werner kernel: *pde = 00000000
Jun  1 13:33:25 werner kernel: Oops: 0000 [#1] SMP
Jun  1 13:33:25 werner kernel: Modules linked in: rfcomm 
hidp bluetooth snd_usb_audio snd_usbmidi_lib snd_rawmidi 
snd_seq_device uvcvideo tpm_tis tpm tpm_bios rtc_cmos 
8139too snd_hda_codec_realtek k8temp snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm forcedeth snd_timer snd 
i2c_nforce2 soundcore snd_page_alloc
Jun  1 13:33:25 werner kernel:
Jun  1 13:33:25 werner kernel: Pid: 1520, comm: mount Not 
tainted 3.0.0-rc1-i486-1sys #1 Gigabyte Technology Co., 
Ltd. M68M-S2P/M68M-S2P
Jun  1 13:33:25 werner kernel: EIP: 0060:[<c10ffe3e>] 
EFLAGS: 00010282 CPU: 0
Jun  1 13:33:25 werner kernel: EIP is at 
blkdev_get+0xe7/0x125
Jun  1 13:33:25 werner kernel: EAX: 00000000 EBX: f5423600 
ECX: 00000000 EDX: f542362c
Jun  1 13:33:25 werner kernel: ESI: f5423600 EDI: c2402bfc 
EBP: e1ddde54 ESP: e1ddde38
Jun  1 13:33:25 werner kernel:  DS: 007b ES: 007b FS: 00d8 
GS: 00e0 SS: 0068
Jun  1 13:33:25 werner kernel: Process mount (pid: 1520, 
ti=e1ddc000 task=f295e440 task.ti=e1ddc000)
Jun  1 13:33:25 werner kernel: Stack:
Jun  1 13:33:25 werner kernel:  00000083 f5423610 ffffffe2 
00000000 f5423600 00000083 c2402bfc e1ddde68
Jun  1 13:33:25 werner kernel:  c11000d1 f291e600 00000083 
00000000 e1dddeb8 c10dc51f c10b753d c11e2ede
Jun  1 13:33:25 werner kernel:  00000000 c2402bfc 00004be8 
00000004 00000199 0000000c 00005410 00000000
Jun  1 13:33:25 werner kernel: Call Trace:
Jun  1 13:33:25 werner kernel:  [<c11000d1>] 
blkdev_get_by_path+0x26/0x56
Jun  1 13:33:25 werner kernel:  [<c10dc51f>] 
mount_bdev+0x4b/0x187
Jun  1 13:33:25 werner kernel:  [<c10b753d>] ? 
pcpu_populate_chunk+0x197/0x266
Jun  1 13:33:25 werner kernel:  [<c11e2ede>] ? 
isofs_iget5_test+0x25/0x25
Jun  1 13:33:25 werner kernel:  [<c11e1e93>] 
isofs_mount+0x1f/0x24
Jun  1 13:33:25 werner kernel:  [<c11e2ede>] ? 
isofs_iget5_test+0x25/0x25
Jun  1 13:33:25 werner kernel:  [<c10dc382>] 
mount_fs+0x67/0x13d
Jun  1 13:33:25 werner kernel:  [<c10f05db>] 
vfs_kern_mount+0x53/0x7f
Jun  1 13:33:25 werner kernel:  [<c10f065b>] 
do_kern_mount+0x38/0x70
Jun  1 13:33:25 werner kernel:  [<c10f06d3>] 
do_new_mount+0x40/0x6c
Jun  1 13:33:25 werner kernel:  [<c10f0872>] 
do_mount+0x173/0x18e
Jun  1 13:33:25 werner kernel:  [<c10f08fa>] 
sys_mount+0x6d/0x99
Jun  1 13:33:25 werner kernel:  [<c1f062ac>] 
syscall_call+0x7/0xb
Jun  1 13:33:25 werner kernel: Code: 55 ec 0f c1 89 7e 30 
39 7b 2c 74 04 0f 0b eb fe c7 43 2c 00 00 00 00 8d 43 2c 
31 d2 e8 5a 5e f5 ff f0 fe 05 40 1d 3f c2 8b 45 f0 <f6> 80 
cd 01 00 00 01 74 1b 83 7d ec 00 75 15 f6 45 e4 02 74 0f
Jun  1 13:33:25 werner kernel: EIP: [<c10ffe3e>] 
blkdev_get+0xe7/0x125 SS:ESP 0068:e1ddde38
Jun  1 13:33:25 werner kernel: CR2: 00000000000001cd
Jun  1 13:33:25 werner kernel: ---[ end trace 
9b11eeec630c71b2 ]---
---
Professional hosting for everyone - http://www.host.ru
