Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1FZM6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:58:24 -0400
Received: from bld14.srv.portugalmail.net ([195.170.168.142]:53449 "EHLO
	bld14.srv.portugalmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab1FZM6S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:58:18 -0400
Date: Sun, 26 Jun 2011 13:58:04 +0100
Message-ID: <20110626135804.Horde.IiupYH4CivROByzcfG61BJA@correio.portugalmail.pt>
From: abrantino@portugalmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: kernel panic using ipv6 module - openwrt
User-Agent: Internet Messaging Program (IMP) H4 (5.0.8-git)
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   I'm trying use ipv6 in bifferboard runnig openwrt (r23226 - kernel
2.6.32.20) but during the boot have a kernel panic.
   After disabling and enabling openwrt modules, I discovered that the
problem is kmod-ipv6 module.
   http://sites.google.com/site/bifferboard/Home/openwrt-git

   (...)
   gpio-buttons driver version 0.1.2
   input: gpio-buttons as /devices/platform/gpio-buttons/input/input0
   USB Serial support registered for FTDI USB Serial Device
   usbcore: registered new interface driver ftdi_sio
   ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
   usbcore: registered new interface driver hiddev
   usbcore: registered new interface driver usbhid
   usbhid: v2.6:USB HID core driver
   BUG: unable to handle kernel NULL pointer dereference at 00000004
   IP: [<c34038aa>] 0xc34038aa
   *pde = 00000000
   Oops: 0000 [#1]
   last sysfs file: /sys/kernel/uevent_seqnum
   Modules linked in: usbhid ftdi_sio gpio_buttons hid usb_storage
   usbserial evdev ohci_hcd rdc321x_wdt ehci_hcd sd_mod ext3 jbd tun
   usbcore scsi_mod nls_base input_polldev input_core ipv6 r6040 libphy
Pid: 449, comm: sysctl Not tainted (2.6.32.20 #5)
EIP: 0060:[<c34038aa>] EFLAGS: 00000293 CPU: 0
EIP is at 0xc34038aa
EAX: 00000004 EBX: 0001e870 ECX: c1d0bc00 EDX: 0000e866
ESI: 00000000 EDI: 0001e800 EBP: 00000000 ESP: c1ec5e84
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process sysctl (pid: 449, ti=c1ec4000 task=c1d6d7d0 task.ti=c1ec4000)
I-pipe domain Linux
Stack:
 c1d0bc00 05000000 42000000 c1d0bc00 c34049a0 c1d0bc00 c1ec1ea0
c01f0b8d
<0> 00000000 c1ec5ec8 c01f5b54 c1ec1ea0 c1d0bc00 c1ec5ec8 c35a8634
00000000
<0> c1e983e0 00003333 c1e90200 c1c49400 00000000 c1cc8540 c1cc8550
c0149915
Call Trace:
 [<c01f0b8d>] ? __dev_set_rx_mode+0x70/0x73
 [<c01f5b54>] ? dev_mc_add+0x35/0x40
 [<c35a8634>] ? ipv6_mc_destroy_dev+0x9f/0x165 [ipv6]
 [<c0149915>] ? kmem_cache_alloc+0x5d/0x8c
 [<c35a893e>] ? ipv6_dev_mc_inc+0x21e/0x305 [ipv6]
 [<c3596eea>] ? addrconf_join_solict+0x77/0x708 [ipv6]
 [<c3596fa9>] ? addrconf_join_solict+0x136/0x708 [ipv6]
 [<c359703a>] ? addrconf_join_solict+0x1c7/0x708 [ipv6]
 [<c0176910>] ? proc_sys_call_handler+0x6e/0x8a
 [<c017692c>] ? proc_sys_write+0x0/0xe
 [<c0176937>] ? proc_sys_write+0xb/0xe
 [<c014c49c>] ? vfs_write+0x73/0x92
 [<c014c81e>] ? sys_write+0x3e/0x65
 [<c01026b6>] ? syscall_call+0x7/0xb
Code: 0f b7 44 24 06 e8 42 3f da fc 8d 57 64 0f b7 44 24 08 e8 35 3f
da fc 8d 57 66 0f b7 44 24 0a e8 28 3f da fc 8d 5f 70 31 f6 eb 2a <0f>
b7 45 04 89 da e8 16 3f da fc 8d 53 02 0f b7 45 06 e8 0a 3f
EIP: [<c34038aa>] 0xc34038aa SS:ESP 0068:c1ec5e84
CR2: 0000000000000004
---[ end trace 4dfcd2082dff476d ]---
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 3 seconds..
Uhhuh. NMI received for unknown reason 3c on CPU 0.
Do you have a strange power saving mode enabled?
Kernel panic - not syncing: NMI: Not continuing
Rebooting in 3 seconds..
