Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1KVMw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:52:58 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40189 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1KVMw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:52:57 -0500
Date: Tue, 22 Nov 2011 21:52:56 +0900
From: Norbert Preining <preining@logic.at>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [regression 3.1.0 -> 3.20rc] USB Oops
Message-ID: <20111122125256.GB32440@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please Cc)

running current git kernel (commit f8f5ed7c9) I see this Oops
when connecting an USB stick:
[   65.428179] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[   65.563400] usb 2-1: New USB device found, idVendor=1687, idProduct=3252
[   65.565004] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   65.566519] usb 2-1: Product: USB2.0 FlashDisk
[   65.567998] usb 2-1: Manufacturer: Kingmax
[   65.569460] usb 2-1: SerialNumber: AA04012700039580
[   66.045924] Initializing USB Mass Storage driver...
[   66.047551] scsi6 : usb-storage 2-1:1.0
[   66.049146] usbcore: registered new interface driver usb-storage
[   66.050606] USB Mass Storage support registered.
[   67.808567] scsi 6:0:0:0: Direct-Access     Kingmax  USB2.0 FlashDisk 1100 PQ: 0 ANSI: 0 CCS
[   67.813844] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   67.821873] sd 6:0:0:0: [sdb] 7471104 512-byte logical blocks: (3.82 GB/3.56 GiB)
[   67.827475] sd 6:0:0:0: [sdb] Write Protect is off
[   67.832164] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   67.837710] sd 6:0:0:0: [sdb] No Caching mode page present
[   67.842228] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   67.848325] sd 6:0:0:0: [sdb] No Caching mode page present
[   67.849838] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   67.852328] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d9
[   67.853898] IP: [<ffffffffa0249e6b>] last_sector_hacks.part.2+0x72/0xe0 [usb_storage]
[   67.855441] PGD 0 
[   67.856296] Oops: 0000 [#2] PREEMPT SMP 
[   67.856296] CPU 0 
[   67.856296] Modules linked in: usb_storage rfcomm bnep bluetooth crc16 snd_hrtimer vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop(+) uinput snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mxm_wmi snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq firewire_ohci firewire_core crc_itu_t iwlwifi joydev snd_timer snd_seq_device mac80211 cfg80211 snd sony_laptop(O) rfkill tpm_infineon soundcore snd_page_alloc
[   67.856296] 
[   67.856296] Pid: 3349, comm: usb-storage Tainted: G      D    O 3.2.0-rc2+ #47 Sony Corporation VGN-Z11VN_B/VAIO
[   67.856296] RIP: 0010:[<ffffffffa0249e6b>]  [<ffffffffa0249e6b>] last_sector_hacks.part.2+0x72/0xe0 [usb_storage]
[   67.856296] RSP: 0018:ffff880126ab1db0  EFLAGS: 00010202
[   67.856296] RAX: ffff88013a20ab80 RBX: ffff88012f3e3670 RCX: 0000000000000001
[   67.856296] RDX: ffff88012f3e3670 RSI: 0000000000000000 RDI: 0000000000000000
[   67.856296] RBP: ffff880126ab1db0 R08: 0000000000000051 R09: 0000000000000f00
[   67.856296] R10: 0000000000626b98 R11: ffff88013a285e80 R12: ffff88013a20ab80
[   67.856296] R13: ffff88012f3e37d8 R14: 0000000000000000 R15: 0000000000000000
[   67.856296] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[   67.856296] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   67.856296] CR2: 00000000000002d9 CR3: 0000000001805000 CR4: 00000000000006f0
[   67.856296] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   67.856296] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   67.856296] Process usb-storage (pid: 3349, threadinfo ffff880126ab0000, task ffff88012acf2b00)
[   67.856296] Stack:
[   67.856296]  ffff880126ab1e60 ffffffffa024acdd ffffffff8102b330 ffff880126ab1df0
[   67.856296]  ffff880126ab1df0 ffffffff8106489c ffff880126ab1df0 ffffffff814093ce
[   67.856296]  ffff880126ab1e60 ffffffff814075ff ffff880126ab1e10 0000000000000001
[   67.856296] Call Trace:
[   67.856296]  [<ffffffffa024acdd>] usb_stor_invoke_transport+0x3c3/0x3d2 [usb_storage]
[   67.856296]  [<ffffffff8102b330>] ? test_ti_thread_flag+0x9/0x11
[   67.856296]  [<ffffffff8106489c>] ? test_ti_thread_flag.constprop.8+0x9/0x19
[   67.856296]  [<ffffffff814093ce>] ? _raw_spin_unlock_irq+0x24/0x2f
[   67.856296]  [<ffffffff814075ff>] ? wait_for_common+0xdf/0xf1
[   67.856296]  [<ffffffff81033f50>] ? try_to_wake_up+0x1bc/0x1bc
[   67.856296]  [<ffffffffa0249b09>] usb_stor_transparent_scsi_command+0xe/0x10 [usb_storage]
[   67.856296]  [<ffffffffa024bb43>] usb_stor_control_thread+0x139/0x1fa [usb_storage]
[   67.856296]  [<ffffffffa024ba0a>] ? fill_inquiry_response+0xea/0xea [usb_storage]
[   67.856296]  [<ffffffff8105265d>] kthread+0x84/0x8c
[   67.856296]  [<ffffffff8140af14>] kernel_thread_helper+0x4/0x10
[   67.856296]  [<ffffffff810525d9>] ? kthread_worker_fn+0x148/0x148
[   67.856296]  [<ffffffff8140af10>] ? gs_change+0xb/0xb
[   67.856296] Code: 00 00 4d 8b 80 30 03 00 00 4d 85 c0 74 76 40 0f b6 ff c1 e1 18 40 0f b6 f6 c1 e7 10 09 f9 09 f1 41 0f b6 f1 c1 e6 08 09 f1 ff c1 
[   67.856296]  3b 88 88 02 00 00 75 50 83 b8 e0 00 00 00 00 75 12 83 78 6c 
[   67.856296] RIP  [<ffffffffa0249e6b>] last_sector_hacks.part.2+0x72/0xe0 [usb_storage]
[   67.856296]  RSP <ffff880126ab1db0>
[   67.856296] CR2: 00000000000002d9
[   67.930444] ---[ end trace e59796b1a256462f ]---


Running on 3.1.0 I see:
$ lsusb -v
...
Bus 002 Device 004: ID 1687:3252 Kingmax Digital Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1687 Kingmax Digital Inc.
  idProduct          0x3252 
  bcdDevice           11.00
  iManufacturer           1 Kingmax
  iProduct                2 USB2.0 FlashDisk
  iSerial                 3 AA04012700039580
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
    MaxPower              200mA
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval             255
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval             255
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
$


That is Intel laptop:
[    4.533921] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.546279] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.576026] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.580177] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.584385] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1


Let me know how I can help

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GLASGOW (n.)
The feeling of infinite sadness engendered when walking through a
place filled with happy people fifteen years younger than yourself.
			--- Douglas Adams, The Meaning of Liff
