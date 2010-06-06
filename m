Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0FFNr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 09:47:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56858 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab0FFNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 09:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=onCaPNjLM2luneQXURFWCTeRKNOiTmuw24it2G95JtsCrxFGwicpl9utDPnIthWxgt
         /bFrXBylx9RUgIzyDdswujRrtjsUwckrQ4VhYOsqbkk2e7VjRuiX/RA5lV1vKWs0Xn0J
         XtJ+JiVVTtBaN7VGePYqLJrcgV2ZutcZRhFFo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
Date: Sun, 6 Jun 2010 15:47:52 +0200
Message-ID: <AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC:Alex for the radeon KMS problem]

On Sun, Jun 6, 2010 at 6:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So -rc2 is out there, and hopefully fixes way more problems than it
> introduces.

It fixes the crash that prevented -rc1 from booting for me, but my
system is still not working with it.

The first problem that shows up is, that after the KMS switches to the
correct video mode (1280x1024 for an DVI attached LCD), the display
begins to flicker. Every 1..2 seconds (guesstimated) the display turns
off and on again. Something in the new powersaving?

This keeps up during userspace bootup, but probably around the time
Xorg starts the display goes blank and does not come back on. I'm not
sure if this final part is really a bug with KMS/radeon/Xorg because
the system died at that point because of the second problem with
2.6.35-rc2, but I wanted to mention it anyway.

The system as a X300 card, that worked perfectly in 2.6.34 (and
previous versions) with KMS:
01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60
[Radeon X300 (PCIE)] (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 0083
        Flags: bus master, fast devsel, latency 0, IRQ 28
        Memory at e0000000 (32-bit, prefetchable) [size=128M]
        I/O ports at d000 [size=256]
        Memory at efbf0000 (32-bit, non-prefetchable) [size=64K]
        Expansion ROM at efbc0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint, MSI 00
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Kernel driver in use: radeon

01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
        Subsystem: ASUSTeK Computer Inc. Device 0082
        Flags: bus master, fast devsel, latency 0
        Memory at efbe0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint, MSI 00

The second problem is more serious, an OOPS and after that the system
hangs. Ctrl+Alt+Del did not initiate a shutdown, although the magic
SysRq still party worked (A first SysRq+S worked, but SysRq+U or a
second SysRq+S after that did not. SysRq+B still rebooted)
[   90.040053] general protection fault: 0000 [#1] SMP

[   90.045062] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:06.0/resource

[   90.050007] CPU 0

[   90.050007] Modules linked in: sg

[   90.050007]

[   90.050007] Pid: 335, comm: kblockd/0 Not tainted 2.6.35-rc2 #1
KFN5-D SLI/KFN5-D SLI

[   90.050007] RIP: 0010:[<ffffffff8135aa64>]  [<ffffffff8135aa64>]
ata_find_dev+0x24/0x90

[   90.050007] RSP: 0018:ffff88007ffdbda0  EFLAGS: 00010082

[   90.050007] RAX: 0720072007200720 RBX: ffff88007ffc7000 RCX: 0720072007202558

[   90.050007] RDX: ffff880007009e38 RSI: 0000000000000000 RDI: ffff880007008000

[   90.050007] RBP: ffff880006cef700 R08: 0000000000000001 R09: 0000000000000008

[   90.050007] R10: 0000000000000000 R11: ffff88000723edb0 R12: ffff88007f3a3800

[   90.050007] R13: ffff880007008000 R14: ffffffff81340f80 R15: ffff88007ffc7138

[   90.050007] FS:  00007f558bc58700(0000) GS:ffff880001c00000(0000)
knlGS:0000000000000000

[   90.050007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b

[   90.050007] CR2: 00007fffa9653000 CR3: 0000000006429000 CR4: 00000000000006f0

[   90.050007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

[   90.050007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

[   90.050007] Process kblockd/0 (pid: 335, threadinfo
ffff88007ffda000, task ffff88007ff8a7d0)

[   90.050007] Stack:

[   90.050007]  ffffffff8135ab25 ffffffff8135e7cb ffff880006cef700
ffff88007f3a3800

[   90.050007] <0> ffff88000723ecd0 0000000000000287 ffff88007ffc7048
ffffffff81341c49

[   90.050007] <0> ffff88000723ecd0 ffff88007ffc7000 ffff880007290000
ffff88000723ecd0

[   90.050007] Call Trace:

[   90.050007]  [<ffffffff8135ab25>] ? ata_scsi_find_dev+0x5/0x30

[   90.050007]  [<ffffffff8135e7cb>] ? ata_scsi_queuecmd+0x4b/0x2c0

[   90.050007]  [<ffffffff81341c49>] ? scsi_dispatch_cmd+0xd9/0x210

[   90.050007]  [<ffffffff81348530>] ? scsi_request_fn+0x300/0x3e0

[   90.050007]  [<ffffffff811e31e0>] ? blk_unplug_work+0x0/0x20

[   90.050007]  [<ffffffff811e4624>] ? generic_unplug_device+0x24/0x30

[   90.050007]  [<ffffffff8104ca6b>] ? worker_thread+0xeb/0x180

[   90.050007]  [<ffffffff81050690>] ? autoremove_wake_function+0x0/0x30

[   90.050007]  [<ffffffff8104c980>] ? worker_thread+0x0/0x180

[   90.050007]  [<ffffffff810501fe>] ? kthread+0x8e/0xa0

[   90.050007]  [<ffffffff81003194>] ? kernel_thread_helper+0x4/0x10

[   90.050007]  [<ffffffff81050170>] ? kthread+0x0/0xa0

[   90.050007]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10

[   90.050007] Code: 1f 84 00 00 00 00 00 8b 87 00 29 00 00 85 c0 75
46 48 8b 87 38 1e 00 00 48 8d 97 38 1e 00 00 48 8d 88 38 1e 00 00 48
39 ca 74 4c <48> 3b 90 f8 28 00 00 74 43 ba 01 00 00 00 39 d6 7d 47 48
63 f6

[   90.050007] RIP  [<ffffffff8135aa64>] ata_find_dev+0x24/0x90

[   90.050007]  RSP <ffff88007ffdbda0>

[   90.050007] ---[ end trace c14df2a6b8b3b357 ]---


(gdb) list *0xffffffff8135aa64
0xffffffff8135aa64 is in ata_find_dev (include/linux/libata.h:1201).
1196            return ap->nr_pmp_links != 0;
1197    }
1198
1199    static inline int ata_is_host_link(const struct ata_link *link)
1200    {
1201            return link == &link->ap->link || link == link->ap->slave_link;
1202    }
1203    #else /* CONFIG_SATA_PMP */
1204    static inline bool sata_pmp_supported(struct ata_port *ap)
1205    {

CONFIG_SATA_PMP ist set to 'y', because my SiI 3132 should be PMP
capable. (But there are only two normal hdds attached to this
controller)

Please ask, if you need more information or have something to try for me.

Thanks

Torsten
