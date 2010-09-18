Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0IRR4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 13:56:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0IRR4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 13:56:42 -0400
Date: Sat, 18 Sep 2010 19:56:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guillaume Chazarain <guichaz@gmail.com>, Mat <jackdachef@gmail.com>,
        Andreas Bombe <aeb@debian.org>
Subject: Re: OOPS in hiddev_open on connecting "Logitech MX620 Laser Cordless
 Mouse"
In-Reply-To: <AANLkTikOowB=8=3cnJ0QgJNfBsVeMUrkNT0E0uH2LDXL@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009181954010.26813@pobox.suse.cz>
References: <AANLkTikOowB=8=3cnJ0QgJNfBsVeMUrkNT0E0uH2LDXL@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Guillame and other reporters to CC ]

On Sat, 18 Sep 2010, Alex Riesen wrote:

> Happens with Linus' master at 509344b8b4d365b7ff3bce97198d83a57b7c3f31
> The tree is modified, but I doubt the patches I have can cause this. I attach
> then anyway. They never caused a conflict, so just the patches (in case of doubt
> I can push the tree somewhere).
> 
> This is a regression from v2.6.35.
> The machine is 64bit Core2Duo laptop (Dell XPS M1330).
> The oops happens only with Ubuntu's hald running (9.04, hald 0.5.12).
> The oops is reproducable. lsusb hangs (D state) after the oops.
> Full dmesg and other machine data attached.
> 
> [    2.926332] input: Logitech USB Receiver as
> /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input15
> [    2.929221] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID
> v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-2/input0
> [    2.962276] input: Logitech USB Receiver as
> /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input16
> [    2.966583] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1:
> USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:1d.0-2/input1
> [    9.965857] udevd (1025): /proc/1025/oom_adj is deprecated, please
> use /proc/1025/oom_score_adj instead.
> [    9.969114] udev: starting version 141
> ...
> [  192.656508] BUG: unable to handle kernel NULL pointer dereference at (null)
> [  192.658212] IP: [<ffffffff81331108>] hiddev_open+0xd1/0x19f
> [  192.660745] PGD 79849067 PUD 79a9d067 PMD 0
> [  192.661291] Oops: 0000 [#1] SMP
> [  192.663348] last sysfs file:
> /sys/devices/virtual/backlight/acpi_video0/max_brightness
> [  192.663348] CPU 1
> [  192.663348] Modules linked in: cpufreq_powersave
> cpufreq_conservative cpufreq_userspace power_meter pci_slot dm_crypt
> dm_mod sbp2 uvcvideo dell_wmi videodev iwlagn v4l1_compat
> v4l2_compat_ioctl32 ohci1394 wmi ieee1394
> [  192.663348]
> [  192.670199] Pid: 3724, comm: hald-probe-hidd Not tainted
> 2.6.36-rc4-t+ #81 0N6705/XPS M1330
> [  192.670199] RIP: 0010:[<ffffffff81331108>]  [<ffffffff81331108>]
> hiddev_open+0xd1/0x19f
> [  192.670199] RSP: 0018:ffff88007d9fdc68  EFLAGS: 00010286
> [  192.670199] RAX: ffff88003ffcc038 RBX: 00000000ffffffed RCX: 0000000000000000
> [  192.670199] RDX: ffffffff81baa3a0 RSI: ffffffff817b353a RDI: ffff88003ffcc030
> [  192.670199] RBP: ffff88007d9fdc88 R08: ffff880001d157c8 R09: ffffffff81a6e230
> [  192.670199] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003ffc0000
> [  192.670199] R13: 0000000000000000 R14: ffff88007d9f80c0 R15: ffff88007d9f80c0
> [  192.670199] FS:  00007f3379d9a700(0000) GS:ffff880001d00000(0000)
> knlGS:0000000000000000
> [  192.670199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  192.670199] CR2: 0000000000000000 CR3: 000000007da17000 CR4: 00000000000006e0
> [  192.670199] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  192.670199] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  192.670199] Process hald-probe-hidd (pid: 3724, threadinfo
> ffff88007d9fc000, task ffff88007db10000)
> [  192.670199] Stack:
> [  192.670199]  0000000000000000 0000000000000000 00000000ffffffed
> ffffffff81652220
> [  192.670199] <0> ffff88007d9fdcc8 ffffffff812d74b5 ffff88007e2b3090
> ffff88007f0ec780
> [  192.670199] <0> 0000000000000000 0000000000000000 ffff88007f0ec780
> ffff88007e2b3090
> [  192.670199] Call Trace:
> [  192.670199]  [<ffffffff812d74b5>] usb_open+0xaf/0x14e
> [  192.670199]  [<ffffffff810d2214>] chrdev_open+0x169/0x18a
> [  192.700618]  [<ffffffff810d20ab>] ? chrdev_open+0x0/0x18a
> [  192.700618]  [<ffffffff810cdbaa>] __dentry_open+0x175/0x298
> [  192.700618]  [<ffffffff810cdd97>] nameidata_to_filp+0x3e/0x4f
> [  192.700618]  [<ffffffff810d91d5>] do_last+0x518/0x641
> [  192.700618]  [<ffffffff810db094>] do_filp_open+0x23d/0x5f7
> [  192.700618]  [<ffffffff8146c264>] ? do_page_fault+0x379/0x3b8
> [  192.700618]  [<ffffffff810cd962>] do_sys_open+0x5a/0xf0
> [  192.700618]  [<ffffffff810cda21>] sys_open+0x1b/0x1d
> [  192.700618]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
> [  192.700618] Code: a3 ba 81 48 c7 c6 3a 35 7b 81 bb ed ff ff ff e8
> 77 42 d2 ff 4d 89 ac 24 18 c0 00 00 4d 89 a6 a0 00 00 00 49 8b 8c 24
> 18 c0 00 00 <83> 39 00 0f 84 a3 00 00 00 8b 51 04 8d 42 01 85 d2 89 41
> 04 75
> [  192.700618] RIP  [<ffffffff81331108>] hiddev_open+0xd1/0x19f
> [  192.700618]  RSP <ffff88007d9fdc68>
> [  192.700618] CR2: 0000000000000000
> [  192.723591] ---[ end trace bd4debade6f95880 ]---

Does reverting of commit 8fe294caf8c868edd9046251824a0af91991bf43 fix the 
problem please?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
