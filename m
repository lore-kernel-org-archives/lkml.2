Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0FFQZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:25:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64790 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0FFQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xirHe+EffWTIsmpQyvx/TbbD3J5h+efUyU3F4hLZdzUK8T3iC4Ej+yelzOkhhw7woZ
         RVVphpaUT+msKKIR7iNVj21EtMfPEmihjZ37zA0SdTj76yzkukwdFWofhG3d8bA74Nhx
         Zx1/OtA3Ipe2Bw+qnRpIbQYODGaOOvqPHG6do=
MIME-Version: 1.0
In-Reply-To: <4C0BC45A.6080104@gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
Date: Sun, 6 Jun 2010 18:25:10 +0200
Message-ID: <AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 5:52 PM, Tejun Heo <htejun@gmail.com> wrote:
> On 06/06/2010 05:48 PM, Tejun Heo wrote:
>> Can you please try w/o KMS just in case?

2 out of 2 attempts without KMS worked without any OOPS.
Sorry to have bother you with this, it now really looks KMS related.

> Also, does it always crash the same way?

It seemed so, both attempts with KMS crashed the same way.

Could you suggest a KConfig option, that might catch the culprit?
DEBUG_PAGEALLOC or DEBUG_OBJECTS?

Torsten

Just for reference, here is the other crash with KMS:
[   82.500052] general protection fault: 0000 [#1] SMP
[   82.505057] last sysfs file: /sys/devices/virtual/block/md3/uevent
[   82.510007] CPU 0
[   82.510007] Modules linked in: sg
[   82.510007]
[   82.510007] Pid: 335, comm: kblockd/0 Not tainted 2.6.35-rc2 #1
KFN5-D SLI/KFN5-D SLI
[   82.510007] RIP: 0010:[<ffffffff8135aa64>]  [<ffffffff8135aa64>]
ata_find_dev+0x24/0x90
[   82.510007] RSP: 0018:ffff88007f40bda0  EFLAGS: 00010082
[   82.510007] RAX: 0720072007200720 RBX: ffff88011f307c00 RCX: 0720072007202558
[   82.510007] RDX: ffff8800070d1e38 RSI: 0000000000000000 RDI: ffff8800070d0000
[   82.510007] RBP: ffff880006c1c300 R08: 0000000000000001 R09: 0000000000000010
[   82.510007] R10: 0000000000000000 R11: ffff880007246c68 R12: ffff88011f30c000
[   82.510007] R13: ffff8800070d0000 R14: ffffffff81340f80 R15: ffff88011f307d38
[   82.510007] FS:  00007f97bcf66700(0000) GS:ffff880001c00000(0000)
knlGS:0000000000000000
[   82.510007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.510007] CR2: 00007f97bbe18900 CR3: 0000000001a05000 CR4: 00000000000006f0
[   82.510007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.510007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   82.510007] Process kblockd/0 (pid: 335, threadinfo
ffff88007f40a000, task ffff88007ff9a7d0)
[   82.510007] Stack:
[   82.510007]  ffffffff8135ab25 ffffffff8135e7cb ffff880006c1c300
ffff88011f30c000
[   82.510007] <0> ffff880007246b88 0000000000000287 ffff88011f307c48
ffffffff81341c49
[   82.510007] <0> ffff880007246b88 ffff88011f307c00 ffff88011f3a0888
ffff880007246b88
[   82.510007] Call Trace:
[   82.510007]  [<ffffffff8135ab25>] ? ata_scsi_find_dev+0x5/0x30
[   82.510007]  [<ffffffff8135e7cb>] ? ata_scsi_queuecmd+0x4b/0x2c0
[   82.510007]  [<ffffffff81341c49>] ? scsi_dispatch_cmd+0xd9/0x210
[   82.510007]  [<ffffffff81348530>] ? scsi_request_fn+0x300/0x3e0
[   82.510007]  [<ffffffff811e31e0>] ? blk_unplug_work+0x0/0x20
[   82.510007]  [<ffffffff811e4624>] ? generic_unplug_device+0x24/0x30
[   82.510007]  [<ffffffff8104ca6b>] ? worker_thread+0xeb/0x180
[   82.510007]  [<ffffffff81050690>] ? autoremove_wake_function+0x0/0x30
[   82.510007]  [<ffffffff8104c980>] ? worker_thread+0x0/0x180
[   82.510007]  [<ffffffff810501fe>] ? kthread+0x8e/0xa0
[   82.510007]  [<ffffffff81003194>] ? kernel_thread_helper+0x4/0x10
[   82.510007]  [<ffffffff81050170>] ? kthread+0x0/0xa0
[   82.510007]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
[   82.510007] Code: 1f 84 00 00 00 00 00 8b 87 00 29 00 00 85 c0 75 46 48
8b 87 38 1e 00 00 48 8d 97 38 1e 00 00 48 8d 88 38 1e 00 00 48 39 ca 74 4c
<48> 3b 90 f8 28 00 00 74 43 ba 01 00 00 00 39 d6 7d 47 48 63 f6
[   82.510007] RIP  [<ffffffff8135aa64>] ata_find_dev+0x24/0x90
[   82.510007]  RSP <ffff88007f40bda0>
[   82.510007] ---[ end trace 63f75d1cde008d47 ]---
