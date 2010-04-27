Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0D0S4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:56:15 -0400
Received: from www.tglx.de ([62.245.132.106]:45738 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0D0S4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:56:13 -0400
Date: Tue, 27 Apr 2010 20:56:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Xianghua Xiao wrote:

cc'ed John

> 2.6.33.2-rt13 worked fine, however on 2.6.33.3-rt16, when I do reboot, it oops:
> 
> # reboot
> # Oops: Kernel access of bad area, sig: 11 [#1]
> PREEMPT 83xx Sys
> Modules linked in:
> NIP: c00efc68 LR: c00efc38 CTR: 00000000
> REGS: ce6e3dc0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
> MSR: 00009032 <EE,ME,IR,DR>  CR: 24000448  XER: 00000000
> DAR: 00000038, DSISR: 20000000
> TASK = cd89ccc0[1613] 'umount' THREAD: ce6e2000
> GPR00: 00000000 ce6e3e70 cd89ccc0 ce6e3ddc 22222222 00000000 ce6e3e24 ce6e3e04
> GPR08: 00008000 00000010 cdfa2130 cdfa26e0 44000442 100bbc1c 0fffd000 ffffffff
> GPR16: 00000001 00000000 007fff00 00000000 00000000 00000001 ce6e3eb8 00000021
> GPR24: 00000060 00000000 00000000 ceb94c40 00000000 ceb94cc0 c065781c ce6e3e70
> NIP [c00efc68] fs_may_remount_ro+0x6c/0xd8
> LR [c00efc38] fs_may_remount_ro+0x3c/0xd8
> Call Trace:
> [ce6e3e70] [c00efc38] fs_may_remount_ro+0x3c/0xd8 (unreliable)
> [ce6e3e90] [c00f1198] do_remount_sb+0x11c/0x164
> [ce6e3eb0] [c0113a3c] do_mount+0x538/0x86c
> [ce6e3f10] [c0113e30] sys_mount+0xc0/0x120
> [ce6e3f40] [c00178d8] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfe5f8c4
>     LR = 0x10051b88
> Instruction dump:
> 38000000 817d00c0 3bbd00c0 60088000 814b0000 2f8a0000 419e0008 7c00522c
> 7f8be800 419e004c 812b000c 81290040 <80090028> 2f800000 419e0028 a009006e
> ---[ end trace 17c711f9d369c3a3 ]---
> ------------[ cut here ]------------
> Kernel BUG at c045eeac [verbose debug info unavailable]
> Oops: Exception in kernel mode, sig: 5 [#2]
> PREEMPT 83xx Sys
> Modules linked in:
> NIP: c045eeac LR: c045ee84 CTR: 00000000
> REGS: ce6e3a80 TRAP: 0700   Tainted: G      D     (2.6.33.3-rt16)
> MSR: 00021032 <ME,CE,IR,DR>  CR: 44004428  XER: 00000000
> TASK = cd89ccc0[1613] 'umount' THREAD: ce6e2000
> GPR00: 00000001 ce6e3b30 cd89ccc0 c068f6b4 c045fc68 00000000 ce6e3b84 ce6e3b64
> GPR08: ce6e3b5c c0690000 cd89ccc0 ce6e3b30 24004422 100bbc1c 0fffd000 ffffffff
> GPR16: 00000001 00000000 007fff00 00000000 00000000 c0657824 ce6e3eb8 ce6e3b3c
> GPR24: cf028ea0 cec84d1c c065781c cec86a60 00009032 c065781c c065781c ce6e3b30
> NIP [c045eeac] rt_spin_lock_slowlock+0xa8/0x394
> LR [c045ee84] rt_spin_lock_slowlock+0x80/0x394
> Call Trace:
> [ce6e3b30] [c045ee84] rt_spin_lock_slowlock+0x80/0x394 (unreliable)
> [ce6e3bc0] [c045fc68] rt_spin_lock+0x58/0x90
> [ce6e3bd0] [c00efbbc] file_sb_list_del+0x48/0x88
> [ce6e3bf0] [c00f03ac] __fput+0x168/0x274
> [ce6e3c20] [c00f04f8] fput+0x40/0x58
> [ce6e3c30] [c00d3f74] remove_vma+0x78/0xd8
> [ce6e3c50] [c00d4150] exit_mmap+0x17c/0x1e4
> [ce6e3cc0] [c00318c0] mmput+0x6c/0x144
> [ce6e3ce0] [c003712c] exit_mm+0x15c/0x190
> [ce6e3d10] [c00391e8] do_exit+0xf0/0x670
> [ce6e3d60] [c0014c9c] die+0x1cc/0x1d4
> [ce6e3d90] [c001cdb8] bad_page_fault+0x98/0xf0
> [ce6e3db0] [c0017d8c] handle_page_fault+0x7c/0x80
> --- Exception: 300 at fs_may_remount_ro+0x6c/0xd8
>     LR = fs_may_remount_ro+0x3c/0xd8
> [ce6e3e90] [c00f1198] do_remount_sb+0x11c/0x164
> [ce6e3eb0] [c0113a3c] do_mount+0x538/0x86c
> [ce6e3f10] [c0113e30] sys_mount+0xc0/0x120
> [ce6e3f40] [c00178d8] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfe5f8c4
>     LR = 0x10051b88
> Instruction dump:
> 38600001 4bbc95d1 801a0004 3aba0008 2f800000 419e0264 801a0018 7c4a1378
> 5400003a 7c400278 7c000034 5400d97e <0f000000> 83a20000 39200002 2f9d0002
> ---[ end trace 17c711f9d369c3a4 ]---
> Fixing recursive fault but reboot is needed!
> BUG: scheduling while atomic: umount/0x00000001/1613, CPU#0
> Modules linked in:
> Call Trace:
> [ce6e3800] [c000b6a0] show_stack+0xe8/0x244 (unreliable)
> [ce6e3850] [c04608c0] dump_stack+0x2c/0x44
> [ce6e3860] [c00282b0] __schedule_bug+0x9c/0xc4
> [ce6e3880] [c045cfe8] __schedule+0x488/0x5a4
> [ce6e38b0] [c045d2e0] schedule+0x40/0xa8
> [ce6e38c0] [c003973c] do_exit+0x644/0x670
> [ce6e3910] [c0014c9c] die+0x1cc/0x1d4
> [ce6e3940] [c0014fd0] _exception+0x130/0x170
> [ce6e3a30] [c00151d0] program_check_exception+0xd0/0x634
> [ce6e3a70] [c0017f38] ret_from_except_full+0x0/0x4c
> --- Exception: 700 at rt_spin_lock_slowlock+0xa8/0x394
>     LR = rt_spin_lock_slowlock+0x80/0x394
> [ce6e3bc0] [c045fc68] rt_spin_lock+0x58/0x90
> [ce6e3bd0] [c00efbbc] file_sb_list_del+0x48/0x88
> [ce6e3bf0] [c00f03ac] __fput+0x168/0x274
> [ce6e3c20] [c00f04f8] fput+0x40/0x58
> [ce6e3c30] [c00d3f74] remove_vma+0x78/0xd8
> [ce6e3c50] [c00d4150] exit_mmap+0x17c/0x1e4
> [ce6e3cc0] [c00318c0] mmput+0x6c/0x144
> [ce6e3ce0] [c003712c] exit_mm+0x15c/0x190
> [ce6e3d10] [c00391e8] do_exit+0xf0/0x670
> [ce6e3d60] [c0014c9c] die+0x1cc/0x1d4
> [ce6e3d90] [c001cdb8] bad_page_fault+0x98/0xf0
> [ce6e3db0] [c0017d8c] handle_page_fault+0x7c/0x80
> --- Exception: 300 at fs_may_remount_ro+0x6c/0xd8
>     LR = fs_may_remount_ro+0x3c/0xd8
> [ce6e3e90] [c00f1198] do_remount_sb+0x11c/0x164
> [ce6e3eb0] [c0113a3c] do_mount+0x538/0x86c
> [ce6e3f10] [c0113e30] sys_mount+0xc0/0x120
> [ce6e3f40] [c00178d8] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfe5f8c4
>     LR = 0x10051b88
> 
