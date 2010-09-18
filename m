Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0IRSJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:09:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:43896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0IRSJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:09:07 -0400
Date: Sat, 18 Sep 2010 20:09:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mat <jackdachef@gmail.com>
Cc: raa.lkml@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        guichaz@gmail.com
Subject: Re: OOPS in hiddev_open on connecting "Logitech MX620 Laser Cordless
 Mouse"
In-Reply-To: <AANLkTimpXSrbZ6pAi3OWTmHrUnHPxwAnE1kEvmCj7G+r@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009182008220.26813@pobox.suse.cz>
References: <AANLkTimpXSrbZ6pAi3OWTmHrUnHPxwAnE1kEvmCj7G+r@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010, Mat wrote:

> Hi everybody,
> 
> I've been noticing this also since a few days and have the same mouse
> model. For me it's getting triggered when hald (which seemingly still
> is needed by KDE4) is started:
> 
>    50.778558] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   50.779448] IP: [<ffffffff8159c4b3>] hiddev_open+0xa3/0x1b0
> [   50.780371] PGD 0
> [   50.781480] Oops: 0000 [#1] PREEMPT SMP
> [   50.782671] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.2/host5/target5:0:0/5:0:0:0/block/sdd/size
> [   50.783649] CPU 7
> [   50.783659] Modules linked in: fglrx(P) firewire_ohci i2c_i801
> firewire_core e1000e wmi shpchp tg3 libphy e1000 scsi_wait_scan
> sl811_hcd ohci_hcd ssb usb_storage ehci_hcd
> [   50.785661]
> [   50.786647] Pid: 5576, comm: hald-probe-hidd Tainted: P
> 2.6.36-rc4_plus_v2+ #2 FMP55/ipower G3710
> [   50.787712] RIP: 0010:[<ffffffff8159c4b3>]  [<ffffffff8159c4b3>]
> hiddev_open+0xa3/0x1b0
> [   50.788784] RSP: 0018:ffff8801bafe9ca8  EFLAGS: 00010296
> [   50.789889] RAX: 0000000000000000 RBX: ffff8801bb155400 RCX: 0000000000000004
> [   50.790998] RDX: ffffffff81de4008 RSI: ffffffff81a03638 RDI: ffff8801bb1fc030
> [   50.792105] RBP: ffff8801bb1f0000 R08: ffffea00060eec88 R09: 0000000000000000
> [   50.793266] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000000
> [   50.794478] R13: 00000000ffffffed R14: ffffffff818f24e0 R15: ffff8801bfa8abd0
> [   50.795639] FS:  00007f17699ba700(0000) GS:ffff8800023c0000(0000)
> knlGS:0000000000000000
> [   50.796810] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   50.798021] CR2: 0000000000000000 CR3: 00000001bc3e5000 CR4: 00000000000006e0
> [   50.799250] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   50.800541] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   50.801786] Process hald-probe-hidd (pid: 5576, threadinfo
> ffff8801bafe8000, task ffff8801bc3c5dc0)
> [   50.803057] Stack:
> [   50.804341]  ffff8801bafe9d24 0000000000000000 ffff8801bb155400
> ffffffff818e2b00
> [   50.804378] <0> ffff8801bb0fb850 ffffffff814d9a74 ffff8801bb0fb850
> ffff8801bb155400
> [   50.805709] <0> ffff8801bfdd4900 0000000000000000 ffffffff810daf10
> ffffffff810db035
> [   50.808363] Call Trace:
> [   50.809664]  [<ffffffff814d9a74>] ? usb_open+0xf4/0x1d0
> [   50.811008]  [<ffffffff810daf10>] ? chrdev_open+0x0/0x210
> [   50.812387]  [<ffffffff810db035>] ? chrdev_open+0x125/0x210
> [   50.813721]  [<ffffffff810d5730>] ? __dentry_open.clone.16+0x100/0x320
> [   50.815010]  [<ffffffff810e3ed0>] ? do_last.clone.45+0x3f0/0x690
> [   50.816367]  [<ffffffff810e4363>] ? do_filp_open+0x1f3/0x5f0
> [   50.817662]  [<ffffffff816b90a5>] ? unix_getname+0x65/0xe0
> [   50.818947]  [<ffffffff81742609>] ? _raw_spin_unlock+0x9/0x40
> [   50.820280]  [<ffffffff810ef5f4>] ? alloc_fd+0xe4/0x140
> [   50.821639]  [<ffffffff810d6896>] ? do_sys_open+0x66/0x130
> [   50.822931]  [<ffffffff810026ab>] ? system_call_fastpath+0x16/0x1b
> [   50.824283] Code: c0 00 00 48 c7 c2 08 40 de 81 48 c7 c6 38 36 a0
> 81 e8 d2 8a ac ff 4c 89 a5 18 c0 00 00 48 89 ab c0 00 00 00 48 8b 85
> 18 c0 00 00 <44> 8b 00 45 85 c0 0f 84 e1 00 00 00 8b 50 04 8d 4a 01 85
> d2 89
> [   50.827599] RIP  [<ffffffff8159c4b3>] hiddev_open+0xa3/0x1b0
> [   50.829040]  RSP <ffff8801bafe9ca8>
> [   50.830557] CR2: 0000000000000000
> [   50.831998] ---[ end trace e966fc680b209e8f ]---
> 
> the first significant related change that catches my eye is:
> 
> http://git.eu.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8fe294caf8c868edd9046251824a0af91991bf43
> HID: fix hiddev's use of usb_find_interface
> 
> Could this be the cause ?
> 
> @Alex Riesen:
> 
> maybe you could try to revert that commit
> (http://git.eu.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=patch;h=8fe294caf8c868edd9046251824a0af91991bf43)
> and see whether that fixes it, I'll do the same in my free time

Yeah, please let me know whether reverting that commit fixes the problem 
you are seeing. It would mean that intfdata is NULL, which'd be a little 
bit strange, as it is set in usbhid_probe() already.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
