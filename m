Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1CIOuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:50:05 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:35807 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab1CIOuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:50:02 -0500
X-ASG-Debug-ID: 1299682201-03d6a54f63333b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D779396.7050905@fusionio.com>
Date: Wed, 9 Mar 2011 15:49:58 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>,
        <hch@infradead.org>
Subject: Re: [PATCHSET] block: Convert block drivers to ->check_events(),
 take#2
References: <1299662016-7721-1-git-send-email-tj@kernel.org> <4D774641.3070806@kernel.dk>
X-ASG-Orig-Subj: Re: [PATCHSET] block: Convert block drivers to ->check_events(),
 take#2
In-Reply-To: <4D774641.3070806@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299682201
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57510
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-09 10:20, Jens Axboe wrote:
> On 2011-03-09 10:13, Tejun Heo wrote:
>> Hello,
>>
>> This is the second take of convert-block-drivers-to-check_events
>> patchset.  Other than addition of Acked-by's and rebasing on top of
>> the current block:for-2.6.39/core (df457f845e), nothing really
>> changed.
> 
> Thanks Tejun, applied.

No worky:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000238
IP: [<ffffffff81216741>] disk_unblock_events+0x1/0x20
PGD 87573c067 PUD 877a29067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/net/lo/operstate
CPU 3 
Modules linked in: hid_apple usbhid uhci_hcd
input: Mitsumi Electric Apple Extended USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.1/8-1.1.3/8-1.1.3:1.0/input/input6
generic-usb 0003:05AC:020B.0005: input: USB HID v1.10 Keyboard [Mitsumi Electric Apple Extended USB Keyboard] on usb-0000:00:1d.2-1.1.3/input0
input: Mitsumi Electric Apple Extended USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.1/8-1.1.3/8-1.1.3:1.1/input/input7
generic-usb 0003:05AC:020B.0006: input: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0000:00:1d.2-1.1.3/input1
 ehci_hcd igb usbcore ahci libahci nls_base

Pid: 4283, comm: swapon Not tainted 2.6.38-rc6+ #40 QCI QSSC-S4R/QSSC-S4R
RIP: 0010:[<ffffffff81216741>]  [<ffffffff81216741>] disk_unblock_events+0x1/0x20
RSP: 0018:ffff880674183b78  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff8808774c5040 RCX: ffff880477b20800
RDX: ffff8808774c5040 RSI: 000000000000001d RDI: 0000000000000000
RBP: ffff880674183bd8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000010 R12: 0000000000000000
R13: ffff8808774c5060 R14: 0000000000000000 R15: 000000000000001d
FS:  00007f8e9f34b740(0000) GS:ffff88087fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000238 CR3: 0000000875761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapon (pid: 4283, threadinfo ffff880674182000, task ffff880676632090)
Stack:
 ffff880674183bd8 ffffffff8112a388 ffff8808774c5040 00000001812230c7
 ffff880674183bb8 0000000076536c48 ffff880674183bb8 ffff8808775aaa80
 ffff880276536c00 ffff8808775aaaa0 0000000000000004 000000000000001d
Call Trace:
 [<ffffffff8112a388>] ? __blkdev_get+0x168/0x3b0
 [<ffffffff8112a444>] __blkdev_get+0x224/0x3b0
 [<ffffffff8112a8e0>] ? blkdev_open+0x0/0x80
 [<ffffffff8112a61f>] blkdev_get+0x4f/0x310
 [<ffffffff8112988a>] ? bdget+0x10a/0x120
 [<ffffffff8112a8e0>] ? blkdev_open+0x0/0x80
 [<ffffffff8112a940>] blkdev_open+0x60/0x80
 [<ffffffff810f6410>] __dentry_open+0x100/0x360
 [<ffffffff81101f9e>] ? generic_permission+0x1e/0xb0
 [<ffffffff810f6791>] nameidata_to_filp+0x71/0x80
 [<ffffffff81104318>] finish_open+0xc8/0x1a0
 [<ffffffff8110598d>] ? do_path_lookup+0x5d/0xe0
 [<ffffffff81106a7d>] do_filp_open+0x27d/0x7d0
 [<ffffffff81114e91>] ? mntput_no_expire+0x71/0x1a0
 [<ffffffff81112292>] ? alloc_fd+0xf2/0x140
 [<ffffffff810f6214>] do_sys_open+0x64/0x110
 [<ffffffff810f62eb>] sys_open+0x1b/0x20
 [<ffffffff81002d3b>] system_call_fastpath+0x16/0x1b
Code: ff ff ff 48 8b 1b 48 8b 03 48 81 fb 80 8f 5e 81 0f 18 08 75 e5 48 c7 c7 60 8f 5e 81 e8 59 30 1f 00 31 c0 48 83 c4 08 5b c9 c3 55 <48> 83 bf 38 02 00 00 00 48 89 e5 74 07 31 f6 e8 2b fe ff ff c9 

-- 
Jens Axboe

