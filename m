Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2AHOZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:25:48 -0500
Received: from hera.cwi.nl ([192.16.191.8]:42852 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab2AHOZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:25:46 -0500
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jan 2012 09:25:46 EST
Message-ID: <4F09A1B7.7080407@science.uva.nl>
Date: Sun, 08 Jan 2012 14:01:27 +0000
From: "Wouter M. Koolen" <wmkoolen@science.uva.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3 memleaks in btusb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi btusb maintainers,

I am running 3.2.0 with kmemleak enabled. It detected the below three 
leaks in btusb.
Before I was tracking the latest 3.1.X versions, and I never observed 
these before.

Note, the last blurb is similar to the one that got fixed by
https://lkml.org/lkml/2011/12/1/158
I double checked that that fix is included in my 3.2.0.

My bluetooth usb controller is a
Bus 003 Device 006: ID 05ac:8205 Apple, Inc. Bluetooth HCI

Don't hesitate to ask for more information.

With kind regards,

Wouter M. Koolen



unreferenced object 0xffff880037cfcb60 (size 208):
   comm "khubd", pid 358, jiffies 4297412982 (age 8684.400s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     be a7 af 2d 80 f9 66 12 00 00 00 00 00 00 00 00  ...-..f.........
   backtrace:
     [<ffffffff813f91c1>] kmemleak_alloc+0x21/0x50
     [<ffffffff8111bbaa>] kmem_cache_alloc+0xda/0x1f0
     [<ffffffff81321351>] __alloc_skb+0x41/0x230
     [<ffffffffa047f0c1>] hci_send_cmd+0x41/0x130 [bluetooth]
     [<ffffffffa047f1c7>] hci_reset_req+0x17/0x20 [bluetooth]
     [<ffffffffa047b373>] __hci_request+0x93/0x130 [bluetooth]
     [<ffffffffa047c7ea>] hci_dev_do_close+0x1ba/0x200 [bluetooth]
     [<ffffffffa047ee26>] hci_unregister_dev+0x56/0x140 [bluetooth]
     [<ffffffffa0426bcb>] btusb_disconnect+0x5b/0xd0 [btusb]
     [<ffffffffa01e50f0>] usb_unbind_interface+0x50/0x180 [usbcore]
     [<ffffffff812eeab7>] __device_release_driver+0x77/0xd0
     [<ffffffff812eeb39>] device_release_driver+0x29/0x40
     [<ffffffff812ee619>] bus_remove_device+0x79/0xb0
     [<ffffffff812ebabd>] device_del+0x12d/0x1b0
     [<ffffffffa01e2ecf>] usb_disable_device+0xaf/0x1d0 [usbcore]
     [<ffffffffa01db23a>] usb_disconnect+0x9a/0x130 [usbcore]

unreferenced object 0xffff880057d4c0d8 (size 512):
   comm "khubd", pid 358, jiffies 4297412982 (age 8684.412s)
   hex dump (first 32 bytes):
     5a 5a 5a 5a 5a 5a 5a 5a 03 0c 00 5a 5a 5a 5a 5a  ZZZZZZZZ...ZZZZZ
     5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
   backtrace:
     [<ffffffff813f91c1>] kmemleak_alloc+0x21/0x50
     [<ffffffff8111bdee>] __kmalloc_track_caller+0x12e/0x240
     [<ffffffff8132137e>] __alloc_skb+0x6e/0x230
     [<ffffffffa047f0c1>] hci_send_cmd+0x41/0x130 [bluetooth]
     [<ffffffffa047f1c7>] hci_reset_req+0x17/0x20 [bluetooth]
     [<ffffffffa047b373>] __hci_request+0x93/0x130 [bluetooth]
     [<ffffffffa047c7ea>] hci_dev_do_close+0x1ba/0x200 [bluetooth]
     [<ffffffffa047ee26>] hci_unregister_dev+0x56/0x140 [bluetooth]
     [<ffffffffa0426bcb>] btusb_disconnect+0x5b/0xd0 [btusb]
     [<ffffffffa01e50f0>] usb_unbind_interface+0x50/0x180 [usbcore]
     [<ffffffff812eeab7>] __device_release_driver+0x77/0xd0
     [<ffffffff812eeb39>] device_release_driver+0x29/0x40
     [<ffffffff812ee619>] bus_remove_device+0x79/0xb0
     [<ffffffff812ebabd>] device_del+0x12d/0x1b0
     [<ffffffffa01e2ecf>] usb_disable_device+0xaf/0x1d0 [usbcore]
     [<ffffffffa01db23a>] usb_disconnect+0x9a/0x130 [usbcore]


unreferenced object 0xffff8800748f7538 (size 32):
   comm "softirq", pid 0, jiffies 4297412982 (age 8684.412s)
   hex dump (first 32 bytes):
     20 00 00 00 00 00 03 00 5a 5a 5a 5a 5a 5a 5a 5a   .......ZZZZZZZZ
     5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
   backtrace:
     [<ffffffff813f91c1>] kmemleak_alloc+0x21/0x50
     [<ffffffff8111bfdb>] kmem_cache_alloc_trace+0xdb/0x1d0
     [<ffffffffa0426f2e>] btusb_send_frame+0x2ce/0x400 [btusb]
     [<ffffffffa047b47e>] hci_send_frame+0x4e/0x80 [bluetooth]
     [<ffffffffa047b7f3>] hci_cmd_task+0x83/0x110 [bluetooth]
     [<ffffffff8104fe76>] tasklet_action+0x76/0x140
     [<ffffffff81050290>] __do_softirq+0xa0/0x230
     [<ffffffff8105053b>] run_ksoftirqd+0x11b/0x230
     [<ffffffff8106d282>] kthread+0xa2/0xb0
     [<ffffffff81417f94>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff

