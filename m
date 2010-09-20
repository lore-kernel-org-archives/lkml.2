Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0ITRF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:05:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57841 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab0ITRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pVrG8VnCobBqVTC0wmxhco5a/MsKJRKLdKXTfEzB4VJLQufaG35uVWL7BjsVOPCTGC
         neZKOfyodXGjxvGQgKL5Y2oko3sDzZ5sYZ2vOrmcJdUTyLJ61Gei/EUWkj0gWZu2Ffmv
         ExBBJeIf/bPzK/eg6QwgHh/idfRR/k4lKR7Ts=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz>
References: <4C96B9DB.8030403@turmel.org>
	<AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com>
	<alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz>
	<4C975F79.9060609@turmel.org>
	<alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
	<AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com>
	<alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz>
Date: Mon, 20 Sep 2010 19:05:56 +0200
Message-ID: <AANLkTinOifECqoDzgVgpAXP8+no1+SuVt2vvrNYZy9VK@mail.gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
From: Mat <jackdachef@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>,
        Phil Turmel <philip@turmel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 5:10 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Thanks Matt and Phill for confirming the line that triggers the oops. As I
> am not able to reproduce it myself, it's a bit tricky to track down what
> went wrong.
>
> Could you please apply the patch below? It's printing the hid <-> hiddev
> <-> usb_interface connections at various stages of probing and open.
> Hopefully it'll reveal a little bit what goes wrong and where.
>
> Thanks.
>
[snip]

> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

Hi Jiri,

sure, you're welcome,

this kernel-version (2.6.36) is one of the best releases so far in
performance, stability and features so I want to use it for some time
without any adverse effects or serious regressions connected to it ;)

here's the information after having connected the transmitter (the
previous mentioned debug-kernel with your patch added and
re-compiled):

[  110.002297] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0008
[  110.002624] hub 1-1:1.0: port 3, status 0101, change 0001, 12 Mb/s
[  110.106254] hub 1-1:1.0: debounce: port 3: total 100ms stable 100ms
status 0x101
[  110.117240] hub 1-1:1.0: port 3 not reset yet, waiting 10ms
[  110.178988] usb 1-1.3: new low speed USB device using ehci_hcd and address 5
[  110.190934] hub 1-1:1.0: port 3 not reset yet, waiting 10ms
[  110.268859] usb 1-1.3: skipped 1 descriptor after interface
[  110.268866] usb 1-1.3: skipped 1 descriptor after interface
[  110.269288] usb 1-1.3: default language 0x0409
[  110.271199] usb 1-1.3: udev 5, busnum 1, minor = 4
[  110.271203] usb 1-1.3: New USB device found, idVendor=046d, idProduct=c521
[  110.271207] usb 1-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  110.271211] usb 1-1.3: Product: USB Receiver
[  110.271214] usb 1-1.3: Manufacturer: Logitech
[  110.271338] usb 1-1.3: usb_probe_device
[  110.271343] usb 1-1.3: configuration #1 chosen from 1 choice
[  110.273070] usb 1-1.3: adding 1-1.3:1.0 (config #1, interface 0)
[  110.273136] usbhid 1-1.3:1.0: usb_probe_interface
[  110.273139] usbhid 1-1.3:1.0: usb_probe_interface - got id
[  110.273148] HID debug: usbhid_probe() -- set
intfdata(ffff8801bae85000, ffff8801bb0c0000)
[  110.277028] HID debug: hid_connect() -- hid: ffff8801bb0c0000
[  110.277117] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input4
[  110.277188] usb 1-1.3: link qh8-0e01/ffff8801bb1ce440 start 4 [1/2 us]
[  110.277274] generic-usb 0003:046D:C521.0004: input,hidraw2: USB HID
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.3/input0
[  110.277308] usb 1-1.3: adding 1-1.3:1.1 (config #1, interface 1)
[  110.277359] usbhid 1-1.3:1.1: usb_probe_interface
[  110.277362] usbhid 1-1.3:1.1: usb_probe_interface - got id
[  110.277369] HID debug: usbhid_probe() -- set
intfdata(ffff8801bae85800, ffff8801bfefc000)
[  110.283896] HID debug: hid_connect() -- hid: ffff8801bfefc000
[  110.284022] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input5
[  110.284053] usb 1-1.3: link qh8-0e01/ffff8801bb1ce6c0 start 5 [1/2 us]
[  110.284106] HID debug: hiddev_connect() -- hid: ffff8801bfefc000,
hiddev: ffff8801bca645c0, intf: ffff8801bae85800
[  110.284110] drivers/usb/core/file.c: looking for a minor, starting at 0
[  110.284164] HID debug: hid_connect() -- after hiddev_connect(),
hid: ffff8801bfefc000, hiddev: ffff8801bca645c0
[  110.284261] generic-usb 0003:046D:C521.0005: input,hiddev0,hidraw3:
USB HID v1.11 Device [Logitech USB Receiver] on
usb-0000:00:1a.0-1.3/input1
[  110.284332] drivers/usb/core/inode.c: creating file '005'
[  110.308876] HID debug: hiddev_open(): hid: ffff8801bafb4000,
hiddev: (null), intf: ffff8801bca99800
[  110.308881] BUG: unable to handle kernel NULL pointer dereference at (null)
[  110.308883] IP: [<ffffffff815a0873>] hiddev_open+0xe3/0x1e0
[  110.308887] PGD 0
[  110.308888] Oops: 0000 [#1] PREEMPT SMP
[  110.308890] last sysfs file:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input4/capabilities/sw
[  110.308892] CPU 7
[  110.308892] Modules linked in: it87 hwmon_vid hwmon e1000e
firewire_ohci shpchp firewire_core i2c_i801 wmi tg3 libphy e1000
scsi_wait_scan sl811_hcd ohci_hcd ssb usb_storage ehci_hcd
[  110.308899]
[  110.308900] Pid: 5670, comm: hald-probe-hidd Not tainted
2.6.36-rc4_hiddev+ #2 FMP55/ipower G3710
[  110.308902] RIP: 0010:[<ffffffff815a0873>]  [<ffffffff815a0873>]
hiddev_open+0xe3/0x1e0
[  110.308904] RSP: 0018:ffff8801bb59fc98  EFLAGS: 00010296
[  110.308905] RAX: 0000000000000000 RBX: 00000000ffffffed RCX: 000000000000006a
[  110.308906] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  110.308907] RBP: ffff8801bc8afcc0 R08: 0000000000000000 R09: 0000000000000000
[  110.308908] R10: 000000000000000a R11: 0000000000000001 R12: ffff8801bbca0000
[  110.308909] R13: ffff8801bafb4000 R14: 0000000000000000 R15: ffff8801bca99800
[  110.308911] FS:  00007fb95dead700(0000) GS:ffff8800021c0000(0000)
knlGS:0000000000000000
[  110.308912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  110.308913] CR2: 0000000000000000 CR3: 00000001bb361000 CR4: 00000000000006e0
[  110.308914] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  110.308915] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  110.308916] Process hald-probe-hidd (pid: 5670, threadinfo
ffff8801bb59e000, task ffff8801bb041810)
[  110.308917] Stack:
[  110.308918]  0000000000000001 ffff8801bc8afcc0 ffffffff818e2b00
ffff8801bb161608
[  110.308920] <0> ffffffff818f24e0 00000000ffffffed 0000000000000000
ffffffff814dc885
[  110.308922] <0> ffff8801bb161608 ffff8801bc8afcc0 ffff8801bf4d92c0
0000000000000000
[  110.308924] Call Trace:
[  110.308928]  [<ffffffff814dc885>] ? usb_open+0xf5/0x1d0
[  110.308930]  [<ffffffff810d9350>] ? chrdev_open+0x0/0x210
[  110.308932]  [<ffffffff810d9495>] ? chrdev_open+0x145/0x210
[  110.308935]  [<ffffffff810d3b40>] ? __dentry_open.clone.16+0x100/0x320
[  110.308937]  [<ffffffff810e2390>] ? do_last.clone.45+0x3f0/0x690
[  110.308939]  [<ffffffff810e2823>] ? do_filp_open+0x1f3/0x5f0
[  110.308942]  [<ffffffff8160f66c>] ? move_addr_to_user+0x4c/0x60
[  110.308943]  [<ffffffff81610142>] ? sys_getsockname+0xe2/0x100
[  110.308946]  [<ffffffff81042b89>] ? get_parent_ip+0x9/0x20
[  110.308949]  [<ffffffff8174b7e3>] ? _raw_spin_unlock+0x13/0x40
[  110.308951]  [<ffffffff810eda94>] ? alloc_fd+0xe4/0x140
[  110.308953]  [<ffffffff810d4ca6>] ? do_sys_open+0x66/0x130
[  110.308955]  [<ffffffff810026ab>] ? system_call_fastpath+0x16/0x1b
[  110.308956] Code: 24 18 c0 00 00 31 c0 4c 89 a5 c0 00 00 00 4c 89
f9 4c 89 f2 4c 89 ee 48 c7 c7 20 de a2 81 e8 99 78 1a 00 49 8b 84 24
18 c0 00 00 <83> 38 00 0f 84 b7 00 00 00 8b 50 04 8d 4a 01 85 d2 89 48
04 75
[  110.308969] RIP  [<ffffffff815a0873>] hiddev_open+0xe3/0x1e0
[  110.308971]  RSP <ffff8801bb59fc98>
[  110.308971] CR2: 0000000000000000
[  110.308973] ---[ end trace a4574c242f54f8b3 ]---

Thanks !

Mat
