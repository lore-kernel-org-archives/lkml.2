Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1GSLdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:33:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51511 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GSLdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:33:37 -0400
MIME-Version: 1.0
Date: Tue, 19 Jul 2011 13:33:36 +0200
Message-ID: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
Subject: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this with the latest linux.git (git 3a5c37) at boot:

[    7.204114] usb 1-1: khubd timed out on ep0in len=0/255
[    7.244493] usb 1-1: udev 2, busnum 1, minor = 1
[    7.245791] usb 1-1: New USB device found, idVendor=9ac4, idProduct=4b8f
[    7.247330] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.249000] usb 1-1: Product: ProxMark-3 RFID Instrument
[    7.250433] usb 1-1: Manufacturer: J. Westhues
[    7.252377] usb 1-1: usb_probe_device
[    7.253911] usb 1-1: configuration #1 chosen from 1 choice
husb: config #1 need 1
husb: 1 interfaces claimed for configuration 1
[    7.258089] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    7.259765] usbhid 1-1:1.0: usb_probe_interface
[    7.261003] usbhid 1-1:1.0: usb_probe_interface - got id
[    7.455562] usbhid 1-1:1.0: looking for a minor, starting at 96
[    7.457603] generic-usb 0003:9AC4:4B8F.0001: hiddev0,hidraw0: USB
HID v1.00 Device [J. Westhues ProxMark-3 RFID Instrument] on
usb-0000:00:01.2-1/input0
[    7.462993] drivers/usb/core/inode.c: creating file '002'
[   74.921035] ------------[ cut here ]------------
[   74.923120] WARNING: at drivers/tty/tty_ldisc.c:766
tty_ldisc_reinit+0x7d/0x90()
[   74.926744] Hardware name: Bochs
[   74.927882] Pid: 1386, comm: login Not tainted 3.0.0-rc7+ #5
[   74.929408] Call Trace:
[   74.930391]  [<c15e9879>] ? printk+0x18/0x1a
[   74.931650]  [<c103e128>] warn_slowpath_common+0x68/0xa0
[   74.933367]  [<c128515d>] ? tty_ldisc_reinit+0x7d/0x90
[   74.934907]  [<c128515d>] ? tty_ldisc_reinit+0x7d/0x90
[   74.936242]  [<c103e1fd>] warn_slowpath_null+0x1d/0x20
[   74.937584]  [<c128515d>] tty_ldisc_reinit+0x7d/0x90
[   74.939152]  [<c128577f>] tty_ldisc_hangup+0xdf/0x200
[   74.968743]  [<c127e4f5>] __tty_hangup+0xe5/0x360
[   74.970158]  [<c127ff3c>] disassociate_ctty+0x6c/0x200
[   74.971526]  [<c104198b>] do_exit+0x55b/0x7d0
[   74.972745]  [<c127dd20>] ? tty_write_lock+0x50/0x50
[   74.974052]  [<c1041c79>] do_group_exit+0x39/0xa0
[   74.975338]  [<c1041cf3>] sys_exit_group+0x13/0x20
[   74.976658]  [<c15ec85c>] sysenter_do_call+0x12/0x2c
[   74.977938]  [<c15e0000>] ? pci_fixup_i450gx+0x40/0x53
[   74.979462] ---[ end trace c3cfae8b1239077b ]---

This is inside qemu/kvm with usb pass-through: -usbdevice host:9ac4:4b8f

Any ideas?

Thanks,


Vegard
