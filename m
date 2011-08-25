Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1HYHjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:39:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45883 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HYHjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <CADpTngV3rR0A1RN+WP=eBJXQBEj9aZx5SXUiLFgG3wWtH1h4yA@mail.gmail.com>
References: <CADpTngV3rR0A1RN+WP=eBJXQBEj9aZx5SXUiLFgG3wWtH1h4yA@mail.gmail.com>
Date: Thu, 25 Aug 2011 09:39:44 +0200
Message-ID: <CADpTngXhc9RCHvQLUpF5YiiifHj+hV5y7uUBYs1SzsJzSAMdwQ@mail.gmail.com>
Subject: Re: 3.0.3 [BUG] unable to handle kernel NULL pointer dereference
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added bugzilla report: https://bugzilla.kernel.org/show_bug.cgi?id=41702

2011/8/24 Fabio Coatti <fabio.coatti@gmail.com>:
> HI all, I'm getting several BUG: messages in a dmesg of a BL465c 2CPU
> / 8 cores each, all the same of the attached examples along with my
> config.gz from /proc/config.gz;
>
> (DMI: HP ProLiant BL465c G7, BIOS A19 09/30/2010)
>
> I've just spotted it and reported here, if more data is needed just
> let me know (right now I'm not subcribed to the list, so please keep
> me CC'ed, thanks)
>
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> IP: [<ffffffff8166e792>] mutex_unlock+0x1/0x18
> PGD 3e59dd067 PUD 3065e2067 PMD 0
> Oops: 0002 [#3] SMP
> CPU 2
> Pid: 26637, comm: php Tainted: G      D     3.0.3 #3 HP ProLiant BL465c G7
> RIP: 0010:[<ffffffff8166e792>]  [<ffffffff8166e792>] mutex_unlock+0x1/0x18
> RSP: 0000:ffff880006c37e58  EFLAGS: 00010202
> RAX: 00000000fffffffe RBX: ffff88018639c780 RCX: ffff88018639c7dc
> RDX: 0000000000000001 RSI: ffff88018639c780 RDI: 0000000000000038
> RBP: ffff880006c37e88 R08: ffff8800474a12c0 R09: ffffffff81186349
> R10: ffff880006c37e28 R11: ffff88012a9f05d8 R12: ffff88012a9f05d8
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f696bfab700(0000) GS:ffff88023f900000(0000) knlGS:00000000f75496c0
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 0000000000000050 CR3: 0000000419ecf000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process php (pid: 26637, threadinfo ffff880006c36000, task ffff88009caa34e0)
> Stack:
>  ffff880006c37e88 ffffffff810b209f 000041ed00000063 00000000fffffffe
>  ffff880006c37e98 ffff88018639c780 ffff880006c37f68 ffffffff810b3f99
>  ffff880233737d00 ffff88015d4d4cc0 000000030022a749 ffff880219ae4016
> Call Trace:
>  [<ffffffff810b209f>] ? vfs_rmdir+0xac/0xc5
>  [<ffffffff810b3f99>] do_rmdir+0xdf/0x137
>  [<ffffffff810b4028>] sys_rmdir+0x11/0x13
>  [<ffffffff81671243>] ia32_do_call+0x13/0x13
> Code: 5d c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 f0 ff 0f 79 05 e8
> 00 02 00 00 65 48 8b 04 25 c0 b5 00 00 48 89 43 18 58 5b c9 c3 55
>  c7 47 18 00 00 00 00 48 89 e5 f0 ff 07 7f 05 e8 02 00 00 00
> RIP  [<ffffffff8166e792>] mutex_unlock+0x1/0x18
>  RSP <ffff880006c37e58>
> CR2: 0000000000000050
> ---[ end trace af3863e4c2a03b55 ]---
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> IP: [<ffffffff8166e792>] mutex_unlock+0x1/0x18
> PGD 362bc7067 PUD 42417d067 PMD 0
> Oops: 0002 [#1] SMP
> CPU 4
> Pid: 16630, comm: php Not tainted 3.0.3 #3 HP ProLiant BL465c G7
> RIP: 0010:[<ffffffff8166e792>]  [<ffffffff8166e792>] mutex_unlock+0x1/0x18
> RSP: 0000:ffff88037e4fde58  EFLAGS: 00010202
> RAX: 00000000fffffffe RBX: ffff8801931ffe00 RCX: ffff8801931ffe5c
> RDX: 0000000000000001 RSI: ffff8801931ffe00 RDI: 0000000000000038
> RBP: ffff88037e4fde88 R08: ffff8803f2d17b00 R09: ffffffff81186349
> R10: ffff88037e4fde28 R11: ffff8803b21b3aa8 R12: ffff8803b21b3aa8
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f65d10c5700(0000) GS:ffff88023fa00000(0000) knlGS:00000000f75b7940
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 0000000000000050 CR3: 00000003066cc000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process php (pid: 16630, threadinfo ffff88037e4fc000, task ffff8801d91c0bc0)
> Stack:
>  ffff88037e4fde88 ffffffff810b209f 000041ed00000063 00000000fffffffe
>  ffff88037e4fde98 ffff8801931ffe00 ffff88037e4fdf68 ffffffff810b3f99
>  ffff880233737300 ffff8800b96b8900 0000000300132a21 ffff8802026f2018
> Call Trace:
>  [<ffffffff810b209f>] ? vfs_rmdir+0xac/0xc5
>  [<ffffffff810b3f99>] do_rmdir+0xdf/0x137
>  [<ffffffff810b4028>] sys_rmdir+0x11/0x13
>  [<ffffffff81671243>] ia32_do_call+0x13/0x13
> Code: 5d c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 f0 ff 0f 79 05 e8
> 00 02 00 00 65 48 8b 04 25 c0 b5 00 00 48 89 43 18 58 5b c9 c3 55
>  c7 47 18 00 00 00 00 48 89 e5 f0 ff 07 7f 05 e8 02 00 00 00
> RIP  [<ffffffff8166e792>] mutex_unlock+0x1/0x18
>  RSP <ffff88037e4fde58>
> CR2: 0000000000000050
> ---[ end trace af3863e4c2a03b53 ]---
>
>
> Thanks in advance for any answer.
>
> --
> Fabio
>



-- 
Fabio
