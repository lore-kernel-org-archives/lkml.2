Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2DYVAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:00:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49780 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758835Ab2DYVAA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <1335365016.6263.28.camel@ierdnac-hp>
References: <1335365016.6263.28.camel@ierdnac-hp>
Date: Wed, 25 Apr 2012 23:59:58 +0300
Message-ID: <CAMXE1-rhPegy+97JwKQKBqrza-PZZX4H0RAYp35oDePmgEWHJw@mail.gmail.com>
Subject: Re: bluetooth oops
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: andrei.popa@i-neo.ro
Cc: linux-kernel@vger.kernel.org,
        Bluetooth Linux <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrei

On Wed, Apr 25, 2012 at 5:43 PM, Andrei Popa <andrei.popa@i-neo.ro> wrote:
>
> I was using kernel (Linux hp 3.3.3-pf-c236 #1 SMP PREEMPT Mon Apr 23
> 21:09:50 EEST 2012 x86_64 Intel(R) Core(TM) i3 CPU M 380 @ 2.53GHz
> GenuineIntel GNU/Linux) with pf patchset and when I was pairing a
> bluettoth phone with the computer it oopses:
>
>
> BUG: unable to handle kernel paging request at 0000000100000000
> IP: [<ffffffff817a42f5>] _raw_spin_lock_irqsave+0x25/0x50
> PGD 0
> Oops: 0002 [#1] PREEMPT SMP
> CPU 2
> Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
> rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
>
> Pid: 15651, comm: bluetoothd Not tainted 3.3.3-pf-c236 #1
> Hewlett-Packard HP ProBook 4320s/1423
> RIP: 0010:[<ffffffff817a42f5>]  [<ffffffff817a42f5>]
> _raw_spin_lock_irqsave+0x25/0x50
> RSP: 0000:ffff8801f1143d10  EFLAGS: 00010002
> RAX: 0000000000000100 RBX: 0000000100000000 RCX: 000000000000006d
> RDX: 0000000000000206 RSI: ffff8801f1143d50 RDI: 0000000100000000
> RBP: ffff8801f2ba08f0 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000000a R11: 0000000000000000 R12: ffff8801f1143d50
> R13: 0000000100000000 R14: 00007fff2cfa5880 R15: 00007fa7c6e08760
> FS:  00007fa7c6db5700(0000) GS:ffff88023bc80000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000100000000 CR3: 000000010868a000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bluetoothd (pid: 15651, threadinfo ffff8801f1142000, task
> ffff88022a8eed70)
> Stack:
> ffffffff8107e3b3 0000000000000000 ffff8801f2ba08d8 0000000000000000
> ffff8801f1143db0 ffff8801ef429570 ffffffff8107e82f ffff8801f1143d68
> ffffffff8174abe0 ffffffff819b715b ffff8801f2ba0800 0000000000000000
> atkbd serio0: Unknown key released (translated set 2, code 0xf8 on
> isa0060/serio0).
> atkbd serio0: Use 'setkeycodes e078 <keycode>' to make it known.
> Call Trace:
> [<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
> [<ffffffff8107e82f>] ? del_timer+0x1f/0x80
> [<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
> [<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
> [<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0

Probably related to:

https://lkml.org/lkml/2012/3/7/68

Could you try those patches below:

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=2a5a5ec620a29d4ba07743c3151cdf0a417c8f8c
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=3c4e0df028935618d052235ba85bc7079be13394


Regards,
Andrei
