Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1GFPlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:41:14 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:49921 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1GFPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:41:10 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.9
Message-ID: <4E148212.1060805@tudelft.nl>
Date: Wed, 06 Jul 2011 17:41:06 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Regression 3.0-rc6+ : khubd blocked (usbnet_cdc_unbind)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
It seems I'm very unlucky this week and I've come across to what looks 
like a second regression in the kernel. I'm running a version few 
commits after 3.0-rc6, which includes commit e534c5b831c8 "fix 
regression occurring during device removal".

When I plug/unplug/plug a mobile phone, after waiting a few minutes I 
get a "task khubd:621 blocked for more than 120 seconds." Note that it's 
directly connected to my laptop, not via an external hub (although the 
bug also happens with an external hub).

Below is the whole dmesg log (with usb debug messages on)

Let me know if you need me to investigate more, or maybe there is
already a fix for that bug?

Cheers,
Éric


hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0002
ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK POWER sig=j 
CSC CONNECT
hub 2-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001005 0  ACK POWER 
sig=se0 PE CONNECT
usb 2-1: new high speed USB device number 8 using ehci_hcd
ehci_hcd 0000:00:1d.7: port 1 high speed
ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001005 0  ACK POWER 
sig=se0 PE CONNECT
usb 2-1: skipped 3 descriptors after interface
usb 2-1: skipped 4 descriptors after interface
usb 2-1: skipped 4 descriptors after interface
usb 2-1: skipped 3 descriptors after interface
usb 2-1: skipped 2 descriptors after interface
usb 2-1: skipped 3 descriptors after interface
usb 2-1: default language 0x0409
usb 2-1: udev 8, busnum 2, minor = 135
usb 2-1: New USB device found, idVendor=0fce, idProduct=d0f3
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Sony Ericsson W595
usb 2-1: Manufacturer: Sony Ericsson
usb 2-1: SerialNumber: 3529650311339760
usb 2-1: usb_probe_device
usb 2-1: configuration #3 chosen from 1 choice
usb 2-1: adding 2-1:3.0 (config #3, interface 0)
usb 2-1: adding 2-1:3.1 (config #3, interface 1)
usb 2-1: adding 2-1:3.2 (config #3, interface 2)
usb 2-1: adding 2-1:3.3 (config #3, interface 3)
usb 2-1: adding 2-1:3.4 (config #3, interface 4)
usb 2-1: adding 2-1:3.5 (config #3, interface 5)
usb 2-1: adding 2-1:3.6 (config #3, interface 6)
usb 2-1: adding 2-1:3.7 (config #3, interface 7)
usb 2-1: adding 2-1:3.8 (config #3, interface 8)
usb 2-1: adding 2-1:3.9 (config #3, interface 9)
usb 2-1: adding 2-1:3.10 (config #3, interface 10)
drivers/usb/core/inode.c: creating file '008'
usb usb1: usb auto-resume
ehci_hcd 0000:00:1a.7: resume root hub
hub 1-0:1.0: hub_resume
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
usb usb3: usb auto-resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: usb auto-resume
usb usb4: wakeup_rh
hub 4-0:1.0: hub_resume
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb5: usb auto-resume
usb usb5: wakeup_rh
hub 5-0:1.0: hub_resume
hub 5-0:1.0: port 2: status 0107 change 0000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb 5-2: usb auto-resume
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.0: port 2 portsc 00a5,01
usb 5-2: finish resume
usb usb6: usb auto-resume
usb usb6: wakeup_rh
hub 6-0:1.0: hub_resume
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb7: usb auto-resume
usb usb7: wakeup_rh
hub 7-0:1.0: hub_resume
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
cdc_acm 2-1:3.1: usb_probe_interface
cdc_acm 2-1:3.1: usb_probe_interface
cdc_acm 2-1:3.1: usb_probe_interface - got id
cdc_acm 2-1:3.1: ttyACM0: USB ACM device
cdc_acm 2-1:3.3: usb_probe_interface
cdc_acm 2-1:3.3: usb_probe_interface - got id
cdc_acm 2-1:3.3: ttyACM1: USB ACM device
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
cdc_ether 2-1:3.8: usb_probe_interface
cdc_ether 2-1:3.8: usb_probe_interface - got id
cdc_ether 2-1:3.8: usb0: register 'cdc_ether' at usb-0000:00:1d.7-1, CDC 
Ethernet Device, 02:80:37:0f:03:00
usbcore: registered new interface driver cdc_ether
cdc_wdm 2-1:3.7: usb_probe_interface
cdc_wdm 2-1:3.7: usb_probe_interface - got id
cdc_wdm 2-1:3.7: looking for a minor, starting at 0
cdc_wdm 2-1:3.7: cdc-wdm-176: USB WDM device
usbcore: registered new interface driver cdc_wdm
usb 2-1: link qh16-0001/ffff88011a072b80 start 5 [1/0 us]
usb 2-1: link qh16-0001/ffff88011a361680 start 6 [1/0 us]
usb 2-1: link qh8-0001/ffff88011a072680 start 7 [1/0 us]
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
usb usb6: suspend_rh (auto-stop)
usb usb7: suspend_rh (auto-stop)
usb 2-1: unlink qh16-0001/ffff88011a072b80 start 5 [1/0 us]
usb 2-1: unlink qh16-0001/ffff88011a361680 start 6 [1/0 us]
ehci_hcd 0000:00:1d.7: reused qh ffff88011a072b80 schedule
usb 2-1: link qh16-0001/ffff88011a072b80 start 5 [1/0 us]
usb 2-1: unlink qh16-0001/ffff88011a072b80 start 5 [1/0 us]
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1a.7: suspend root hub
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
usb 5-2: usb auto-suspend
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 7-0:1.0: hub_suspend
usb usb7: bus auto-suspend
usb usb7: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
usb0: no IPv6 routers present
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 1
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0002
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 2
ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001002 0  ACK POWER 
sig=se0 CSC
hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
usb 2-1: USB disconnect, device number 8
usb 2-1: unregistering device
usb 2-1: unregistering interface 2-1:3.0
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 3
usb 2-1: unregistering interface 2-1:3.1
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 4
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 5
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 6
usb 2-1: unregistering interface 2-1:3.2
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 7
usb 2-1: unregistering interface 2-1:3.3
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 8
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 9
usb 2-1: unregistering interface 2-1:3.4
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 10
usb 2-1: unregistering interface 2-1:3.5
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 11
usb 2-1: unregistering interface 2-1:3.6
usb 2-1: unregistering interface 2-1:3.7
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 12
drivers/usb/core/file.c: removing 0 minor
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 13
usb 2-1: unregistering interface 2-1:3.8
usb 2-1: unlink qh8-0001/ffff88011a072680 start 7 [1/0 us]
ehci_hcd 0000:00:1d.7: detected XactErr len 0/1514 retry 14
ehci_hcd 0000:00:1d.7: shutdown urb ffff880124ba3540 ep7in-intr
cdc_ether 2-1:3.8: usb0: unregister 'cdc_ether' usb-0000:00:1d.7-1, CDC 
Ethernet Device
INFO: task khubd:621 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd           D ffff88013a309fd8     0   621      2 0x00000000
  ffff88013a309a30 0000000000000046 ffff88013ba9acc0 ffff88013b8bacc0
  ffff88013b8bacc0 ffff88013a309fd8 ffff88013a309fd8 ffff88013a309fd8
  ffff88013b8a4320 ffff88013b8bacc0 ffffffff81542714 ffff88013a05a440
Call Trace:
  [<ffffffff8138b0ce>] ? apic_timer_interrupt+0xe/0x20
  [<ffffffff8109ccd0>] ? rcu_batches_completed+0x10/0x10
  [<ffffffff81388674>] __mutex_lock_slowpath+0xf4/0x190
  [<ffffffff813880ad>] mutex_lock+0x1d/0x40
  [<ffffffffa00e324e>] usb_set_interface+0x6e/0x2a0 [usbcore]
  [<ffffffffa00e50cf>] usb_unbind_interface+0x10f/0x180 [usbcore]
  [<ffffffff81269227>] __device_release_driver+0x77/0xd0
  [<ffffffff812692a7>] device_release_driver+0x27/0x40
  [<ffffffffa00e51c8>] usb_driver_release_interface+0x88/0x90 [usbcore]
  [<ffffffff8105b89b>] ? __cancel_work_timer+0x7b/0x130
  [<ffffffffa04c60b7>] usbnet_cdc_unbind+0x97/0xb0 [cdc_ether]
  [<ffffffffa04b281e>] usbnet_disconnect+0x7e/0x100 [usbnet]
  [<ffffffffa00e500d>] usb_unbind_interface+0x4d/0x180 [usbcore]
  [<ffffffff81269227>] __device_release_driver+0x77/0xd0
  [<ffffffff812692a7>] device_release_driver+0x27/0x40
  [<ffffffff81268d93>] bus_remove_device+0x73/0xb0
  [<ffffffff81266855>] device_del+0x125/0x1a0
  [<ffffffffa00e2ce6>] usb_disable_device+0x76/0x200 [usbcore]
  [<ffffffffa00da3a8>] usb_disconnect+0xb8/0x170 [usbcore]
  [<ffffffffa00dcacc>] hub_thread+0xbfc/0x1640 [usbcore]
  [<ffffffff8138713a>] ? schedule+0x44a/0x9e0
  [<ffffffff8105ff70>] ? abort_exclusive_wait+0xb0/0xb0
  [<ffffffffa00dbed0>] ? usb_remote_wakeup+0x60/0x60 [usbcore]
  [<ffffffff8105f7a7>] kthread+0x87/0x90
  [<ffffffff8138b464>] kernel_thread_helper+0x4/0x10
  [<ffffffff8105f720>] ? kthread_worker_fn+0x190/0x190
  [<ffffffff8138b460>] ? gs_change+0x13/0x13
