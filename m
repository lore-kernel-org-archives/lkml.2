Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1JQWs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:48:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54055 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1JQWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:48:54 -0400
Message-ID: <4E9CB0C2.3030902@gmail.com>
Date: Mon, 17 Oct 2011 19:48:34 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel OOPS when releasing usb webcam (random)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

im getting the following null pointer dereference from time to time when 
releasing a usb camera.

maybe this trace is of assistance...please reply to my mail since im not 
subscribed.


thanks.

Tomas M.
---
BUG: unable to handle kernel NULL pointer dereference at 0000006c
IP: [<f90be6c2>] v4l2_device_release+0xa2/0xf0 [videodev]
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: fuse arc4 rt73usb rt2x00usb rt2x00lib mac80211 
cfg80211 rfkill gspca_zc3xx gspca_main videodev joydev 
snd_hda_codec_si3054 sg 8139too snd_hda_codec_realtek firewire_ohci 
firewire_core mmc_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm 
snd_timer snd soundcore mii crc_itu_t snd_page_alloc iTCO_wdt 
iTCO_vendor_support i2c_i801 evdev psmouse thermal battery serio_raw ac 
cpufreq_ondemand acpi_cpufreq freq_table processor mperf usbhid hid ext3 
jbd mbcache sd_mod sr_mod cdrom pata_acpi uhci_hcd ata_piix ehci_hcd 
libata scsi_mod usbcore [last unloaded: sdhci]

Pid: 171, comm: khubd Not tainted 3.1.0-rc9 #66 Everex Systems, Inc. 
Everex StepNote Series/Everex StepNote Series
EIP: 0060:[<f90be6c2>] EFLAGS: 00010292 CPU: 0
EIP is at v4l2_device_release+0xa2/0xf0 [videodev]
EAX: 00000000 EBX: f5636004 ECX: 00000000 EDX: 00000000
ESI: f5636000 EDI: 00000000 EBP: f563600c ESP: f5627e38
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process khubd (pid: 171, ti=f5626000 task=f554dc00 task.ti=f5626000)
Stack:
  ef000480 c1433780 f5474b00 c12343f8 f54e7e1c 00000000 c114737a f563600c
  f5636028 c114605d f5636028 c1146020 f91512d4 00000000 c114737a f54e7e1c
  f54e7e00 f81623f4 f56d4000 f54e7e1c f91512d4 f56d4064 00000001 c12373b7
Call Trace:
  [<c12343f8>] ? device_release+0x18/0x80
  [<c114737a>] ? kref_put+0x2a/0x60
  [<c114605d>] ? kobject_release+0x3d/0xa0
  [<c1146020>] ? kobject_del+0x30/0x30
  [<c114737a>] ? kref_put+0x2a/0x60
  [<f81623f4>] ? usb_unbind_interface+0x34/0x130 [usbcore]
  [<c12373b7>] ? __device_release_driver+0x57/0xb0
  [<c123742d>] ? device_release_driver+0x1d/0x30
  [<c1236fc2>] ? bus_remove_device+0x72/0x90
  [<c12350bf>] ? device_del+0xdf/0x150
  [<f8160591>] ? usb_disable_device+0x81/0x180 [usbcore]
  [<f8159b3b>] ? usb_disconnect+0x8b/0x110 [usbcore]
  [<f815b76c>] ? hub_thread+0x97c/0x1180 [usbcore]
  [<c102d80b>] ? pick_next_task_fair+0x8b/0xe0
  [<c1052600>] ? abort_exclusive_wait+0x90/0x90
  [<f815adf0>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
  [<c1052029>] ? kthread+0x69/0x70
  [<c1051fc0>] ? kthread_worker_fn+0x150/0x150
  [<c130d8be>] ? kernel_thread_helper+0x6/0xd
Code: 83 94 01 00 00 c7 83 60 01 00 00 00 00 00 00 0f b7 93 9c 01 00 00 
c1 e0 05 f0 0f b3 90 c0 e7 0c f9 b8 20 e1 0c f9 e8 4e cf 24 c8 <8b> 57 
6c 89 f0 85 d2 74 25 ff 93 c8 01 00 00 85 ff 74 21 89 f8
EIP: [<f90be6c2>] v4l2_device_release+0xa2/0xf0 [videodev] SS:ESP 
0068:f5627e38
CR2: 000000000000006c
---[ end trace 39522f0f1757c8f8 ]---
