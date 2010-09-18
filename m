Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0IRTY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:24:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49367 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab0IRTYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MntIc2cN+CnNuOE8cdPYNrNfO5bURFTFXxZm9idJT5280iigYpNRG3NtgeX1CIBzoR
         4dJjFP5jv5AEhcKbSThz9z2eKS0MQjyUvZYUZmkaubWyw5RporOoKxmOyY/2+StVhAkn
         t4jlPVgYG66Xo/bto8zdreLYdaYzJQUhv4AFY=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1009182008220.26813@pobox.suse.cz>
References: <AANLkTimpXSrbZ6pAi3OWTmHrUnHPxwAnE1kEvmCj7G+r@mail.gmail.com>
	<alpine.LNX.2.00.1009182008220.26813@pobox.suse.cz>
Date: Sat, 18 Sep 2010 21:24:52 +0200
Message-ID: <AANLkTimOGXH0cEv3Zg+ic6g6F8gH=r6+p-uT1nYpZr6S@mail.gmail.com>
Subject: Re: OOPS in hiddev_open on connecting "Logitech MX620 Laser Cordless Mouse"
From: Mat <jackdachef@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: raa.lkml@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guillaume Chazarain <guichaz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 8:09 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 18 Sep 2010, Mat wrote:
>
>> Hi everybody,
>>
>> I've been noticing this also since a few days and have the same mouse
>> model. For me it's getting triggered when hald (which seemingly still
>> is needed by KDE4) is started:
>>
>>    50.778558] BUG: unable to handle kernel NULL pointer dereference at (null)
>> [   50.779448] IP: [<ffffffff8159c4b3>] hiddev_open+0xa3/0x1b0
>> [   50.780371] PGD 0
>> [   50.781480] Oops: 0000 [#1] PREEMPT SMP
>> [   50.782671] last sysfs file:
>> /sys/devices/pci0000:00/0000:00:1f.2/host5/target5:0:0/5:0:0:0/block/sdd/size
>> [   50.783649] CPU 7
>> [   50.783659] Modules linked in: fglrx(P) firewire_ohci i2c_i801
>> firewire_core e1000e wmi shpchp tg3 libphy e1000 scsi_wait_scan
>> sl811_hcd ohci_hcd ssb usb_storage ehci_hcd
>> [   50.785661]
>> [   50.786647] Pid: 5576, comm: hald-probe-hidd Tainted: P
>> 2.6.36-rc4_plus_v2+ #2 FMP55/ipower G3710
>> [   50.787712] RIP: 0010:[<ffffffff8159c4b3>]  [<ffffffff8159c4b3>]
>> hiddev_open+0xa3/0x1b0
>> [   50.788784] RSP: 0018:ffff8801bafe9ca8  EFLAGS: 00010296
>> [   50.789889] RAX: 0000000000000000 RBX: ffff8801bb155400 RCX: 0000000000000004
>> [   50.790998] RDX: ffffffff81de4008 RSI: ffffffff81a03638 RDI: ffff8801bb1fc030
>> [   50.792105] RBP: ffff8801bb1f0000 R08: ffffea00060eec88 R09: 0000000000000000
>> [   50.793266] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000000
>> [   50.794478] R13: 00000000ffffffed R14: ffffffff818f24e0 R15: ffff8801bfa8abd0
>> [   50.795639] FS:  00007f17699ba700(0000) GS:ffff8800023c0000(0000)
>> knlGS:0000000000000000
>> [   50.796810] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   50.798021] CR2: 0000000000000000 CR3: 00000001bc3e5000 CR4: 00000000000006e0
>> [   50.799250] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   50.800541] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [   50.801786] Process hald-probe-hidd (pid: 5576, threadinfo
>> ffff8801bafe8000, task ffff8801bc3c5dc0)
>> [   50.803057] Stack:
>> [   50.804341]  ffff8801bafe9d24 0000000000000000 ffff8801bb155400
>> ffffffff818e2b00
>> [   50.804378] <0> ffff8801bb0fb850 ffffffff814d9a74 ffff8801bb0fb850
>> ffff8801bb155400
>> [   50.805709] <0> ffff8801bfdd4900 0000000000000000 ffffffff810daf10
>> ffffffff810db035
>> [   50.808363] Call Trace:
>> [   50.809664]  [<ffffffff814d9a74>] ? usb_open+0xf4/0x1d0
>> [   50.811008]  [<ffffffff810daf10>] ? chrdev_open+0x0/0x210
>> [   50.812387]  [<ffffffff810db035>] ? chrdev_open+0x125/0x210
>> [   50.813721]  [<ffffffff810d5730>] ? __dentry_open.clone.16+0x100/0x320
>> [   50.815010]  [<ffffffff810e3ed0>] ? do_last.clone.45+0x3f0/0x690
>> [   50.816367]  [<ffffffff810e4363>] ? do_filp_open+0x1f3/0x5f0
>> [   50.817662]  [<ffffffff816b90a5>] ? unix_getname+0x65/0xe0
>> [   50.818947]  [<ffffffff81742609>] ? _raw_spin_unlock+0x9/0x40
>> [   50.820280]  [<ffffffff810ef5f4>] ? alloc_fd+0xe4/0x140
>> [   50.821639]  [<ffffffff810d6896>] ? do_sys_open+0x66/0x130
>> [   50.822931]  [<ffffffff810026ab>] ? system_call_fastpath+0x16/0x1b
>> [   50.824283] Code: c0 00 00 48 c7 c2 08 40 de 81 48 c7 c6 38 36 a0
>> 81 e8 d2 8a ac ff 4c 89 a5 18 c0 00 00 48 89 ab c0 00 00 00 48 8b 85
>> 18 c0 00 00 <44> 8b 00 45 85 c0 0f 84 e1 00 00 00 8b 50 04 8d 4a 01 85
>> d2 89
>> [   50.827599] RIP  [<ffffffff8159c4b3>] hiddev_open+0xa3/0x1b0
>> [   50.829040]  RSP <ffff8801bafe9ca8>
>> [   50.830557] CR2: 0000000000000000
>> [   50.831998] ---[ end trace e966fc680b209e8f ]---
>>
>> the first significant related change that catches my eye is:
>>
>> http://git.eu.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8fe294caf8c868edd9046251824a0af91991bf43
>> HID: fix hiddev's use of usb_find_interface
>>
>> Could this be the cause ?
>>
>> @Alex Riesen:
>>
>> maybe you could try to revert that commit
>> (http://git.eu.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=patch;h=8fe294caf8c868edd9046251824a0af91991bf43)
>> and see whether that fixes it, I'll do the same in my free time
>
> Yeah, please let me know whether reverting that commit fixes the problem
> you are seeing. It would mean that intfdata is NULL, which'd be a little
> bit strange, as it is set in usbhid_probe() already.
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

Hi Jiri,

sorry for the delay :(

yeah, it definitely fixes it for me: grepping for BUG or hiddev
doesn't show up anything anymore (I rebooted into a kernel without the
fglrx so that results wouldn't get falsified)

it now only shows:

dmesg | grep hiddev[    2.560945] usbcore: registered new interface
driver hiddev
[    8.449492] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1:
USB HID v1.11 Device [Logitech USB Receiver] on
usb-0000:00:1a.0-1.3/input1


FWIW:

I removed the transmitter of the mouse (it's a wireless mouse) and
during insert (after the boot was finished) it showed a different
error message - perhaps it's useful in tracking down the culprit [I
hope that the fglrx-module was loaded doesn't make any change in its
usefulness]:

[  130.065747] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0008
[  130.066025] hub 1-1:1.0: port 3, status 0101, change 0001, 12 Mb/s
[  130.170281] hub 1-1:1.0: debounce: port 3: total 100ms stable 100ms
status 0x101
[  130.181259] hub 1-1:1.0: port 3 not reset yet, waiting 10ms
[  130.243163] usb 1-1.3: new low speed USB device using ehci_hcd and address 4
[  130.254993] hub 1-1:1.0: port 3 not reset yet, waiting 10ms
[  130.332878] usb 1-1.3: skipped 1 descriptor after interface
[  130.332884] usb 1-1.3: skipped 1 descriptor after interface
[  130.333438] usb 1-1.3: default language 0x0409
[  130.335534] usb 1-1.3: udev 4, busnum 1, minor = 3
[  130.335540] usb 1-1.3: New USB device found, idVendor=046d, idProduct=c521
[  130.335545] usb 1-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  130.335550] usb 1-1.3: Product: USB Receiver
[  130.335554] usb 1-1.3: Manufacturer: Logitech
[  130.335709] usb 1-1.3: usb_probe_device
[  130.335716] usb 1-1.3: configuration #1 chosen from 1 choice
[  130.337653] usb 1-1.3: adding 1-1.3:1.0 (config #1, interface 0)
[  130.337761] usbhid 1-1.3:1.0: usb_probe_interface
[  130.337765] usbhid 1-1.3:1.0: usb_probe_interface - got id
[  130.341047] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input4
[  130.341148] usb 1-1.3: link qh8-0e01/ffff8801bf421580 start 4 [1/2 us]
[  130.341261] generic-usb 0003:046D:C521.0004: input,hidraw2: USB HID
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.3/input0
[  130.341303] usb 1-1.3: adding 1-1.3:1.1 (config #1, interface 1)
[  130.341373] usbhid 1-1.3:1.1: usb_probe_interface
[  130.341378] usbhid 1-1.3:1.1: usb_probe_interface - got id
[  130.347635] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input5
[  130.347664] usb 1-1.3: link qh8-0e01/ffff8801bf421900 start 5 [1/2 us]
[  130.347698] drivers/usb/core/file.c: looking for a minor, starting at 0
[  130.347758] generic-usb 0003:046D:C521.0005: input,hiddev0,hidraw3:
USB HID v1.11 Device [Logitech USB Receiver] on
usb-0000:00:1a.0-1.3/input1
[  130.347805] drivers/usb/core/inode.c: creating file '004'
[  130.368286] BUG: unable to handle kernel NULL pointer dereference at (null)
[  130.368288] IP: [<ffffffff8159c4b3>] hiddev_open+0xa3/0x1b0
[  130.368293] PGD 0
[  130.368294] Oops: 0000 [#1] PREEMPT SMP
[  130.368295] last sysfs file:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input4/capabilities/sw
[  130.368297] CPU 4
[  130.368298] Modules linked in: it87 hwmon_vid hwmon fglrx(P)
i2c_i801 firewire_ohci firewire_core e1000e wmi shpchp tg3 libphy
e1000 scsi_wait_scan sl811_hcd ohci_hcd ssb usb_storage ehci_hcd
[  130.368304]
[  130.368306] Pid: 5776, comm: hald-probe-hidd Tainted: P
2.6.36-rc4_plus_v2+ #2 FMP55/ipower G3710
[  130.368307] RIP: 0010:[<ffffffff8159c4b3>]  [<ffffffff8159c4b3>]
hiddev_open+0xa3/0x1b0
[  130.368310] RSP: 0018:ffff8801bb06fca8  EFLAGS: 00010296
[  130.368311] RAX: 0000000000000000 RBX: ffff8801baf27400 RCX: 0000000000000004
[  130.368312] RDX: ffffffff81de4008 RSI: ffffffff81a03638 RDI: ffff8801bb28c030
[  130.368313] RBP: ffff8801bb280000 R08: ffffea00060f0c08 R09: 0000000000000000
[  130.368314] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000000
[  130.368315] R13: 00000000ffffffed R14: ffffffff818f24e0 R15: ffff8801bd1ba1b0
[  130.368316] FS:  00007f9ba9f78700(0000) GS:ffff880002300000(0000)
knlGS:0000000000000000
[  130.368317] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  130.368318] CR2: 0000000000000000 CR3: 00000001bad83000 CR4: 00000000000006e0
[  130.368319] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  130.368320] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  130.368322] Process hald-probe-hidd (pid: 5776, threadinfo
ffff8801bb06e000, task ffff8801bafb9770)
[  130.368323] Stack:
[  130.368323]  ffff8801bb06fd24 0000000000000000 ffff8801baf27400
ffffffff818e2b00
[  130.368325] <0> ffff8801bc8e87c0 ffffffff814d9a74 ffff8801bc8e87c0
ffff8801baf27400
[  130.368327] <0> ffff8801bfdd4900 0000000000000000 ffffffff810daf10
ffffffff810db035
[  130.368329] Call Trace:
[  130.368332]  [<ffffffff814d9a74>] ? usb_open+0xf4/0x1d0
[  130.368335]  [<ffffffff810daf10>] ? chrdev_open+0x0/0x210
[  130.368336]  [<ffffffff810db035>] ? chrdev_open+0x125/0x210
[  130.368339]  [<ffffffff810d5730>] ? __dentry_open.clone.16+0x100/0x320
[  130.368341]  [<ffffffff810e3ed0>] ? do_last.clone.45+0x3f0/0x690
[  130.368342]  [<ffffffff810e4363>] ? do_filp_open+0x1f3/0x5f0
[  130.368346]  [<ffffffff816b90a5>] ? unix_getname+0x65/0xe0
[  130.368349]  [<ffffffff81742609>] ? _raw_spin_unlock+0x9/0x40
[  130.368352]  [<ffffffff810ef5f4>] ? alloc_fd+0xe4/0x140
[  130.368354]  [<ffffffff810d6896>] ? do_sys_open+0x66/0x130
[  130.368356]  [<ffffffff810026ab>] ? system_call_fastpath+0x16/0x1b
[  130.368357] Code: c0 00 00 48 c7 c2 08 40 de 81 48 c7 c6 38 36 a0
81 e8 d2 8a ac ff 4c 89 a5 18 c0 00 00 48 89 ab c0 00 00 00 48 8b 85
18 c0 00 00 <44> 8b 00 45 85 c0 0f 84 e1 00 00 00 8b 50 04 8d 4a 01 85
d2 89
[  130.368368] RIP  [<ffffffff8159c4b3>] hiddev_open+0xa3/0x1b0
[  130.368370]  RSP <ffff8801bb06fca8>
[  130.368370] CR2: 0000000000000000
[  130.368372] ---[ end trace 56b8e483c48eb892 ]---

Regards & Thanks !

Mat
