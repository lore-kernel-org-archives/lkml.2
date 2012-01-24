Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2AXNUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:20:08 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:24325 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab2AXNUG (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 24 Jan 2012 08:20:06 -0500
Message-ID: <4F1EAFE9.5000306@suse.com>
Date: Tue, 24 Jan 2012 18:49:37 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Slab corruption in floppy driver module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Got a spew of slab corruption messages during boot on 3.2 vanilla
kernel with DEBUG_SLAB enabled.

--- cut-here ---
[    9.643858] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   10.792691] Slab corruption: blkdev_queue start=ffff88042407e088, len=2104
[   10.799280] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   10.805825] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   10.812404] 4e0: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
[   10.818984] Single bit error detected. Probably bad RAM.
[   10.825554] Run memtest86+ or a similar memory test tool.
[   10.832125] Next obj: start=ffff88042407e8d8, len=2104
[   10.838656] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   10.845168] Last user: [<          (null)>](0x0)
[   10.851646] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   10.858222] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   10.865320] loop: module loaded
[   10.896232] kjournald starting.  Commit interval 5 seconds
[   10.896368] EXT3-fs (sda5): using internal journal
[   10.896373] EXT3-fs (sda5): mounted filesystem with ordered data mode
[   10.915290] kjournald starting.  Commit interval 5 seconds
[   10.915385] EXT3-fs (sda3): using internal journal
[   10.915388] EXT3-fs (sda3): mounted filesystem with ordered data mode
[   12.361444] fuse init (API version 7.17)
[   15.776067] Slab corruption: blkdev_queue start=ffff880424d72148, len=2104
[   15.776074] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   15.776076] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   15.776087] 4e0: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
[   15.776092] Single bit error detected. Probably bad RAM.
[   15.776095] Run memtest86+ or a similar memory test tool.
[   15.776100] Next obj: start=ffff880424d72998, len=2104
[   15.776103] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   15.776106] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   15.776111] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   15.776116] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   15.776122] Slab corruption: blkdev_queue start=ffff880424d72998, len=2104
[   15.776126] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   15.776128] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   15.776133] 4e0: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
[   15.776137] Single bit error detected. Probably bad RAM.
[   15.776139] Run memtest86+ or a similar memory test tool.
[   15.776144] Prev obj: start=ffff880424d72148, len=2104
[   15.776146] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   15.776150] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   15.776155] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   15.776159] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   15.776164] Next obj: start=ffff880424d731e8, len=2104
[   15.776168] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   15.776170] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   15.776175] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   15.776178] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
kkkkkkkkkkkkkkkk
[   15.776185] Slab corruption: blkdev_queue start=ffff880424d731e8, len=2104
[   15.776188] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[   15.776190] Last user: [<ffffffff812c6580>](kobject_cleanup+0x80/0x1d0)
[   15.776195] 4e0: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
jkkkkkkkkkkkkkkk
[   15.776199] Single bit error detected. Probably bad RAM.
[   15.776202] Run memtest86+ or a similar memory test tool.
[   15.776206] Prev obj: start=ffff880424d72998, len=2104
--- cut-here ---

After enabling DEBUG_PAGEALLOC the box oopsed and I was able to see the
problem.

--- cut-here ---
[   33.228029] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   33.228029] CPU 5
[   33.228029] Modules linked in: dcdbas i5k_amb bnx2 i5000_edac vhost_net
iTCO_wdt edac_core macvtap macvlan tun ses enclosure kvm_intel
iTCO_vendor_support shpchp kvm pci_hotplug sg serio_raw sr_mod cdrom button
rtc_cmos pcspkr floppy(+) usbhid hid radeon ttm drm_kms_helper drm i2c_algo_bit
i2c_core uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif processor
thermal_sys hwmon ext3 mbcache jbd ata_generic ata_piix libata megaraid_sas
scsi_mod
[   33.228029] Supported: Yes
[   33.228029]
[   33.228029] Pid: 1161, comm: modprobe Tainted: G           N  3.2.0-1-debug
#2 Dell Inc. PowerEdge 2950/0H603H
[   33.228029] RIP: 0010:[<ffffffff81275371>]  [<ffffffff81275371>]
kobject_put+0x11/0x60
[   33.228029] RSP: 0018:ffff88041dd9bda8  EFLAGS: 00010286
[   33.228029] RAX: 0000000000000000 RBX: ffff88041d986c60 RCX:
ffff88043fd40000
[   33.228029] RDX: 000000000000e1ac RSI: 0000000000000286 RDI:
ffff88041d986c60
[   33.228029] RBP: ffff88041dd9bdb8 R08: 0000000000000000 R09:
0000000000000009
[   33.228029] R10: 0000000000000028 R11: 0000000000000000 R12:
ffff88041da9bc58
[   33.228029] R13: 0000000000000000 R14: 0000000000000008 R15:
00000000ffffffed
[   33.228029] FS:  00007f86dd2ba700(0000) GS:ffff88043fd40000(0000)
knlGS:0000000000000000
[   33.228029] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   33.228029] CR2: ffff88041d986c9c CR3: 0000000424796000 CR4:
00000000000006e0
[   33.228029] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   33.228029] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[   33.228029] Process modprobe (pid: 1161, threadinfo ffff88041dd9a000, task
ffff88041d998680)
[   33.228029] Stack:
[   33.228029]  ffff88041da9bbf0 ffff88041da9bbf0 ffff88041dd9bdc8
ffffffff81243a15
[   33.372026]  ffff88041dd9bde8 ffffffff8124d4ff 0000000000000000
ffffffff81a794e0
[   33.372026]  ffff88041dd9be08 ffffffff8134f517 ffff88041dd9be28
ffff88041da9bc68
[   33.372026] Call Trace:
[   33.372026]  [<ffffffff81243a15>] blk_put_queue+0x15/0x20
[   33.372026]  [<ffffffff8124d4ff>] disk_release+0x8f/0xd0
[   33.372026]  [<ffffffff8134f517>] device_release+0x27/0xa0
[   33.372026]  [<ffffffff812754fd>] kobject_cleanup+0x6d/0x1b0
[   33.372026]  [<ffffffff8127564d>] kobject_release+0xd/0x10
[   33.372026]  [<ffffffff81276b17>] kref_put+0x37/0x70
[   33.372026]  [<ffffffff81275387>] kobject_put+0x27/0x60
[   33.372026]  [<ffffffff8124dbf7>] put_disk+0x17/0x20
[   33.372026]  [<ffffffffa00fa92c>] floppy_init+0x1c1/0x675 [floppy]
[   33.372026]  [<ffffffffa00fae37>] floppy_module_init+0x57/0x220 [floppy]
[   33.372026]  [<ffffffff810001d3>] do_one_initcall+0x43/0x180
[   33.372026]  [<ffffffff810a526d>] sys_init_module+0xcd/0x240
[   33.372026]  [<ffffffff8148d4c2>] system_call_fastpath+0x16/0x1b
[   33.372026]  [<00007f86dce3406a>] 0x7f86dce34069
[   33.372026] Code: eb cc 48 89 fe 31 c0 48 c7 c7 60 aa 7a 81 e8 26 c4 20 00
e8 92 c1 20 00 eb 8e 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 16 <f6> 47
3c 01 74 19 48 8d 7b 38 48 c7 c6 40 56 27 81 e8 59 17 00
[   33.372026] RIP  [<ffffffff81275371>] kobject_put+0x11/0x60
[   33.372026]  RSP <ffff88041dd9bda8>
[   33.372026] CR2: ffff88041d986c9c
[   33.372026] ---[ end trace f624c17dc6e4672a ]---
--- cut-here ---

What seems to be happening is after commit f992ae80, add_disk takes a
extra reference to the queue which is supposed to be put in disk_release().
In floppy_init() when there were "no floppy controllers found" the control
goes to out_flush_work. Note that add_disk() is not being called at all and
so extra reference not taken. We try to put_disk() and the call sequence is
  put_disk()
   kobject_put()
    kref_put()
     kobject_release()
      kobject_cleanup()
       device_release()
        disk_release()
         blk_put_queue()  <-- put without a get
          kobject_put()


Reverting f992ae80 makes the oops and the slab corruption messages disappear.
The "no floppy controllers found" message was found in the dmesg.


Thanks
Suresh
