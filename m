Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2GDOub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:50:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33225 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GDOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:50:29 -0400
Date: Wed, 4 Jul 2012 17:50:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [bug -next] NULL dereference disconnecting USB serial modem
Message-ID: <20120704145019.GD4462@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't seem to affect 3.5, it's only in linux-next.  I'm
getting a very reproducable NULL dereference when I unplug my USB
serial modem dongle.  It works as a storage device as well.

regards,
dan carpenter

Jul  4 17:32:20 longonot kernel: [  208.217275] usb 2-1.5: new high-speed USB device number 4 using ehci_hcd
Jul  4 17:32:20 longonot kernel: [  208.294901] usb 2-1.5: New USB device found, idVendor=12d1, idProduct=1446
Jul  4 17:32:20 longonot kernel: [  208.294969] usb 2-1.5: New USB device strings: Mfr=3, Product=2, SerialNumber=0
Jul  4 17:32:20 longonot kernel: [  208.295036] usb 2-1.5: Product: HUAWEI Mobile
Jul  4 17:32:20 longonot kernel: [  208.295086] usb 2-1.5: Manufacturer: HUAWEI Technology
Jul  4 17:32:20 longonot kernel: [  208.297118] scsi4 : usb-storage 2-1.5:1.0
Jul  4 17:32:20 longonot kernel: [  208.297432] scsi5 : usb-storage 2-1.5:1.1
Jul  4 17:32:20 longonot mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5"
Jul  4 17:32:20 longonot mtp-probe: bus: 2, device: 4 was not an MTP device
Jul  4 17:32:21 longonot usb_modeswitch: switching 12d1:1446 (HUAWEI Technology: HUAWEI Mobile)
Jul  4 17:32:21 longonot kernel: [  209.318197] usb 2-1.5: USB disconnect, device number 4
Jul  4 17:32:26 longonot kernel: [  214.101997] usb 2-1.5: new high-speed USB device number 5 using ehci_hcd
Jul  4 17:32:26 longonot kernel: [  214.190741] usb 2-1.5: New USB device found, idVendor=12d1, idProduct=1001
Jul  4 17:32:26 longonot kernel: [  214.190823] usb 2-1.5: New USB device strings: Mfr=3, Product=2, SerialNumber=0
Jul  4 17:32:26 longonot kernel: [  214.190904] usb 2-1.5: Product: HUAWEI Mobile
Jul  4 17:32:26 longonot kernel: [  214.190956] usb 2-1.5: Manufacturer: HUAWEI Technology
Jul  4 17:32:26 longonot kernel: [  214.194650] scsi9 : usb-storage 2-1.5:1.3
Jul  4 17:32:26 longonot kernel: [  214.195385] scsi10 : usb-storage 2-1.5:1.4
Jul  4 17:32:26 longonot mtp-probe: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5"
Jul  4 17:32:26 longonot mtp-probe: bus: 2, device: 5 was not an MTP device
Jul  4 17:32:26 longonot kernel: [  214.520885] usbcore: registered new interface driver usbserial
Jul  4 17:32:26 longonot kernel: [  214.520935] usbserial: USB Serial Driver core
Jul  4 17:32:26 longonot kernel: [  214.574385] usbcore: registered new interface driver option
Jul  4 17:32:26 longonot kernel: [  214.574521] USB Serial support registered for GSM modem (1-port)
Jul  4 17:32:26 longonot kernel: [  214.574702] option 2-1.5:1.0: GSM modem (1-port) converter detected
Jul  4 17:32:26 longonot kernel: [  214.574844] usb 2-1.5: GSM modem (1-port) converter now attached to ttyUSB0
Jul  4 17:32:26 longonot kernel: [  214.574912] option 2-1.5:1.1: GSM modem (1-port) converter detected
Jul  4 17:32:26 longonot kernel: [  214.574990] usb 2-1.5: GSM modem (1-port) converter now attached to ttyUSB1
Jul  4 17:32:26 longonot kernel: [  214.575033] option 2-1.5:1.2: GSM modem (1-port) converter detected
Jul  4 17:32:26 longonot kernel: [  214.575098] usb 2-1.5: GSM modem (1-port) converter now attached to ttyUSB2
Jul  4 17:32:26 longonot modem-manager[10085]: <info>  (ttyUSB0) opening serial port...
Jul  4 17:32:27 longonot kernel: [  215.197283] scsi 9:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
Jul  4 17:32:27 longonot kernel: [  215.197675] scsi 10:0:0:0: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
Jul  4 17:32:27 longonot kernel: [  215.198803] sd 10:0:0:0: Attached scsi generic sg2 type 0
Jul  4 17:32:27 longonot usb_modeswitch: switched to 12d1:1001 (HUAWEI Technology: HUAWEI Mobile)
Jul  4 17:32:27 longonot kernel: [  215.201943] sd 10:0:0:0: [sdb] Attached SCSI removable disk
Jul  4 17:32:27 longonot kernel: [  215.204842] sr1: scsi-1 drive
Jul  4 17:32:27 longonot kernel: [  215.206457] sr 9:0:0:0: Attached scsi generic sg3 type 5
Jul  4 17:32:30 longonot modem-manager[10085]: <info>  (ttyUSB0) closing serial port...
Jul  4 17:32:30 longonot modem-manager[10085]: <info>  (ttyUSB0) serial port closed
Jul  4 17:32:30 longonot kernel: [  218.018958] usb 2-1.5: USB disconnect, device number 5
Jul  4 17:32:30 longonot kernel: [  218.019098] option1 ttyUSB0: option_instat_callback: error -108
Jul  4 17:32:30 longonot kernel: [  218.019212] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
Jul  4 17:32:30 longonot kernel: [  218.019271] BUG: unable to handle kernel NULL pointer dereference at           (null)
Jul  4 17:32:30 longonot kernel: [  218.019326] IP: [<ffffffffa03df53d>] stop_read_write_urbs+0x3d/0x90 [usb_wwan]
Jul  4 17:32:30 longonot kernel: [  218.019377] PGD 0 
Jul  4 17:32:30 longonot kernel: [  218.019398] Oops: 0000 [#1] SMP 
Jul  4 17:32:30 longonot kernel: [  218.019434] Modules linked in: option usb_wwan usbserial udf crc_itu_t fuse brcmsmac brcmutil cordic b43 ssb bcma kvm_intel kvm r8169
Jul  4 17:32:30 longonot kernel: [  218.019681] CPU 0 
Jul  4 17:32:30 longonot kernel: [  218.019729] Pid: 525, comm: khubd Not tainted 3.5.0-rc5-next-20120703+ #76 SAMSUNG ELECTRONICS CO., LTD. RV411/RV511/E3511/S3511    /RV411/RV511/E3511/S3511    
Jul  4 17:32:30 longonot kernel: [  218.019978] RIP: 0010:[<ffffffffa03df53d>]  [<ffffffffa03df53d>] stop_read_write_urbs+0x3d/0x90 [usb_wwan]
Jul  4 17:32:30 longonot kernel: [  218.020159] RSP: 0018:ffff8800b3201bc0  EFLAGS: 00010286
Jul  4 17:32:30 longonot kernel: [  218.020252] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8800a406ba28
Jul  4 17:32:30 longonot kernel: [  218.022844] RDX: ffff8800a6d6be28 RSI: ffff8800a76f8c98 RDI: ffff8800a406b610
Jul  4 17:32:30 longonot kernel: [  218.025707] RBP: ffff8800b3201bf0 R08: 0000000000000001 R09: ffff8800b7014f20
Jul  4 17:32:30 longonot kernel: [  218.025709] R10: ffffea0002779600 R11: ffffffff812b887b R12: 0000000000000000
Jul  4 17:32:30 longonot kernel: [  218.025711] R13: ffff8800a84c06c0 R14: ffff8800a84c06c0 R15: 0000000000000000
Jul  4 17:32:30 longonot kernel: [  218.025713] FS:  0000000000000000(0000) GS:ffff8800b7000000(0000) knlGS:0000000000000000
Jul  4 17:32:30 longonot kernel: [  218.025716] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul  4 17:32:30 longonot kernel: [  218.025717] CR2: 0000000000000000 CR3: 00000000a42aa000 CR4: 00000000000007f0
Jul  4 17:32:30 longonot kernel: [  218.025719] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  4 17:32:30 longonot kernel: [  218.025721] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  4 17:32:30 longonot kernel: [  218.025724] Process khubd (pid: 525, threadinfo ffff8800b3200000, task ffff8800b3143c80)
Jul  4 17:32:30 longonot kernel: [  218.025725] Stack:
Jul  4 17:32:30 longonot kernel: [  218.025726]  ffff8800b3201bd0 ffff8800a406b400 0000000000000001 ffff8800a84c06c8
Jul  4 17:32:30 longonot kernel: [  218.025729]  ffff8800a84c06c0
Jul  4 17:32:30 longonot kernel: [  218.025730]  ffff8800af144000
Jul  4 17:32:30 longonot kernel: [  218.025731]  ffff8800b3201c00
Jul  4 17:32:30 longonot kernel: [  218.025732]  ffffffffa03df59e
Jul  4 17:32:30 longonot kernel: [  218.025732] 
Jul  4 17:32:30 longonot kernel: [  218.025733]  ffff8800b3201c50
Jul  4 17:32:30 longonot kernel: [  218.025734]  ffffffffa03b967d
Jul  4 17:32:30 longonot kernel: [  218.025734]  ffff8800b37cfe88
Jul  4 17:32:30 longonot kernel: [  218.025735]  ffff8800aae71830
Jul  4 17:32:30 longonot kernel: [  218.025736] 
Jul  4 17:32:30 longonot kernel: [  218.025737] Call Trace:
Jul  4 17:32:30 longonot kernel: [  218.025740] 
Jul  4 17:32:30 longonot kernel: [  218.025746]  [<ffffffffa03df59e>] usb_wwan_disconnect+0xe/0x10 [usb_wwan]
Jul  4 17:32:30 longonot kernel: [  218.025747] 
Jul  4 17:32:30 longonot kernel: [  218.025752]  [<ffffffffa03b967d>] usb_serial_disconnect+0xdd/0x130 [usbserial]
Jul  4 17:32:30 longonot kernel: [  218.025753] 
Jul  4 17:32:30 longonot kernel: [  218.025760]  [<ffffffff814812fd>] usb_unbind_interface+0x5d/0x120
Jul  4 17:32:30 longonot kernel: [  218.025761] 
Jul  4 17:32:30 longonot kernel: [  218.025766]  [<ffffffff813df0e6>] __device_release_driver+0x66/0xd0
Jul  4 17:32:30 longonot kernel: [  218.025767] 
Jul  4 17:32:30 longonot kernel: [  218.025770]  [<ffffffff813df35c>] device_release_driver+0x2c/0x40
Jul  4 17:32:30 longonot kernel: [  218.025777]  [<ffffffff813deb81>] bus_remove_device+0xe1/0x120
Jul  4 17:32:30 longonot kernel: [  218.025784]  [<ffffffff813dc2ea>] device_del+0x12a/0x1c0
Jul  4 17:32:30 longonot kernel: [  218.025788]  [<ffffffff8147f7c9>] usb_disable_device+0xa9/0x290
Jul  4 17:32:30 longonot kernel: [  218.025792]  [<ffffffff81477381>] usb_disconnect+0xb1/0x140
Jul  4 17:32:30 longonot kernel: [  218.025795]  [<ffffffff8147898d>] hub_thread+0x4ad/0x14c0
Jul  4 17:32:30 longonot kernel: [  218.025801]  [<ffffffff81070720>] ? dequeue_task_fair+0x1c0/0x1d0
Jul  4 17:32:30 longonot kernel: [  218.025806]  [<ffffffff8105bff0>] ? finish_wait+0x80/0x80
Jul  4 17:32:30 longonot kernel: [  218.025809]  [<ffffffff814784e0>] ? usb_new_device+0x220/0x220
Jul  4 17:32:30 longonot kernel: [  218.025812]  [<ffffffff8105bc53>] kthread+0x93/0xa0
Jul  4 17:32:30 longonot kernel: [  218.025820]  [<ffffffff8174a8b4>] kernel_thread_helper+0x4/0x10
Jul  4 17:32:30 longonot kernel: [  218.025824]  [<ffffffff8105bbc0>] ? flush_kthread_worker+0x80/0x80
Jul  4 17:32:30 longonot kernel: [  218.025828]  [<ffffffff8174a8b0>] ? gs_change+0xb/0xb
Jul  4 17:32:30 longonot kernel: [  218.025828] Code: 66 66 66 90 45 31 e4 80 7f 1a 00 49 89 fe 49 89 fd 74 53 0f 1f 00 49 8b 7d 20 31 db 48 81 c7 10 02 00 00 e8 d6 f9 ff e0 49 89 c7 <49> 8b 3c 1f 48 83 c3 08 e8 76 e4 09 e1 48 83 fb 20 75 ed 30 db 
Jul  4 17:32:30 longonot kernel: [  218.025862] RIP 
Jul  4 17:32:30 longonot kernel: [  218.025865]  [<ffffffffa03df53d>] stop_read_write_urbs+0x3d/0x90 [usb_wwan]
Jul  4 17:32:30 longonot kernel: [  218.025866]  RSP <ffff8800b3201bc0>
Jul  4 17:32:30 longonot kernel: [  218.025867] CR2: 0000000000000000
Jul  4 17:32:30 longonot kernel: [  218.025909] ---[ end trace 608f6de816940a06 ]---

