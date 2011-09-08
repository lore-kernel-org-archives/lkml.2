Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1IHJHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:07:51 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56267 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab1IHJHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:07:50 -0400
MIME-Version: 1.0
In-Reply-To: <CADpTngV3rR0A1RN+WP=eBJXQBEj9aZx5SXUiLFgG3wWtH1h4yA@mail.gmail.com>
References: <CADpTngV3rR0A1RN+WP=eBJXQBEj9aZx5SXUiLFgG3wWtH1h4yA@mail.gmail.com>
Date: Thu, 8 Sep 2011 10:59:39 +0200
Message-ID: <CADpTngVjZ6pn49Mdk38AZ_Py3jA5XQ+Mo-mobfzCA2GXG_fM2Q@mail.gmail.com>
Subject: Re: 3.0.3 [BUG] unable to handle kernel NULL pointer dereference
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem is still there in 3.0.4, any hint about what problem it could
be? a NULL pointer dereference seems something we want to avoid :) but
I'm not sure if this could be a "my setup problem" or n ot.

Here latest BUG report in dmesg, same machine, same situation:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
IP: [<ffffffff81632820>] mutex_lock+0x22/0x22
PGD 265e60067 PUD 24a85d067 PMD 0
Oops: 0002 [#6] SMP
CPU 1
Pid: 18235, comm: php Tainted: G      D     3.0.4 #2 HP ProLiant BL465c G7
RIP: 0010:[<ffffffff81632820>]  [<ffffffff81632820>] mutex_lock+0x22/0x22
RSP: 0000:ffff88029ef89e80  EFLAGS: 00010202
RAX: 00000000fffffffe RBX: ffff88003f81bbc0 RCX: ffff880035c312a8
RDX: 0000000040000200 RSI: ffff88003f81bbc0 RDI: 0000000000000038
RBP: ffff8801279d6b68 R08: ffffea00040d3b70 R09: ffffffff81178c0e
R10: ffff880200000003 R11: ffff880232ba32d8 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe3275cc700(0000) GS:ffff88023f880000(0000) knlGS:00000000f75866c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000000000050 CR3: 0000000282733000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process php (pid: 18235, threadinfo ffff88029ef88000, task ffff880001c1ad80)
Stack:
 ffffffff810ab2b1 ffff88023254eb00 ffff8800fffffffe 000041ed00000063
 0000000009dc490c ffff88003f81bbc0 ffffffff810ad145 ffff88023254eb00
 ffff8801294edbc0 000000030024777a ffff88010ac92016 0000000000000000
Call Trace:
 [<ffffffff810ab2b1>] ? vfs_rmdir+0xa7/0xc2
 [<ffffffff810ad145>] ? do_rmdir+0xcb/0x11c
 [<ffffffff81634bf5>] ? device_not_available+0x15/0x20
 [<ffffffff816351c3>] ? ia32_do_call+0x13/0x13
Code: 48 83 c4 50 5b 5d 41 5c c3 53 48 89 fb 48 83 ec 08 f0 ff 0f 79
05 e8 e1 01 00 00 65 48 8b 04 25 c0 b5 00 00 48 89 43 18 58 5b c3
 c7 47 18 00 00 00 00 f0 ff 07 7f 05 e8 01 00 00 00 c3 53 48
RIP  [<ffffffff81632820>] mutex_lock+0x22/0x22
 RSP <ffff88029ef89e80>
CR2: 0000000000000050
---[ end trace b22f2fee9e6f2fb3 ]---


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
