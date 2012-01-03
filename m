Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2ACUKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:10:13 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:58498
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab2ACUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:10:10 -0500
Date: Tue, 3 Jan 2012 21:10:05 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <167823371.20120103211005@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: neilb@suse.de, john.stultz@linaro.org, stefan.bader@canonical.com,
        <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable to handle kernel NULL pointer dereference at 0000000000000598 [    1.478005] IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
In-Reply-To: <20120103190754.GA27651@phenom.dumpdata.com>
References: <1599287628.20120103171351@eikelenboom.it> <20120103190754.GA27651@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday, January 3, 2012, 8:07:54 PM, you wrote:

> On Tue, Jan 03, 2012 at 05:13:51PM +0100, Sander Eikelenboom wrote:
>> Hi all,
>> 
>> While trying a vanilla 3.2.0-rc7+ kernel (commit 115e8e705e4be071b9e06ff72578e3b603f2ba65) as host and guest kernels under Xen:
>> 
>> The kernels only boot when a guest has MORE than 1 cpu, with ONE CPU it gives this stacktrace:

> Yikes. So without the 115e8e705e4be071b9e06ff72578e3b603f2ba65 it boots right? So
> regression? Lets CC Rafeal.

> But the git commit:

> ommit 115e8e705e4be071b9e06ff72578e3b603f2ba65
> Merge: 733bbb7 f88e1ae
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Jan 2 12:34:03 2012 -0800

>     Merge branch 'devicetree/merge' of git://git.secretlab.ca/git/linux-2.6
>     
>     * 'devicetree/merge' of git://git.secretlab.ca/git/linux-2.6:
>       dt/device: Fix auxdata matching to handle entries without a name override

> Looks to be unrelated? Or is there some other bug?

> Is this by any chance related to "rtc: Expire alarms after the time is set."
> (93b2ec0128c431148b216b8f7337c1a52131ef03) which breaks Amazon EC2 instances?

> I think Stefan had a patch for this..

> Ah, please see attached file.

> Sander, could you please do two tests:

>  1). Revert the 93b2ec0128c431148b216b8f7337c1a52131ef03 and see if that fixes it
>  2). Use the latest linus/master and try the attached patch?

Both 1 and 2 make the problem disappear !
(no panic and no long delay on boot seen on 64bit with 1 and multiple cpu's)

Thanks !

--
Sander

> Thanks!

>> 
>> [    1.074218] i8042: No controller found
>> [    1.074510] mousedev: PS/2 mouse device common for all mice
>> [    1.233365] BUG: unable to handle kernel NULL pointer dereference at 0000000000000598
>> [    1.233382] IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
>> [    1.233394] PGD 0
>> [    1.233399] Oops: 0002 [#1] SMP
>> [    1.233406] CPU 0
>> [    1.233409] Modules linked in:
>> [    1.233415]
>> [    1.233419] Pid: 586, comm: kworker/0:1 Not tainted 3.2.0-rc7+ #1
>> [    1.233427] RIP: e030:[<ffffffff8107a6c4>]  [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
>> [    1.233436] RSP: e02b:ffff88000ee07b20  EFLAGS: 00010002
>> [    1.233441] RAX: ffff88000ecea000 RBX: ffffffff82729c80 RCX: 00005684b0256000
>> [    1.233447] RDX: 0000000000000598 RSI: ffff88000ecea000 RDI: 0000000000000000
>> [    1.233452] RBP: ffff88000ee07b20 R08: 0000000000000000 R09: 0000000000000001
>> [    1.233458] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffd0
>> [    1.233464] R13: 00000000000000ff R14: 0000000000000023 R15: 0000000000000014
>> [    1.233472] FS:  0000000000000000(0000) GS:ffff88000ffd5000(0000) knlGS:0000000000000000
>> [    1.233479] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    1.233484] CR2: 0000000000000598 CR3: 0000000001e05000 CR4: 0000000000000660
>> [    1.233490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [    1.233496] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [    1.233502] Process kworker/0:1 (pid: 586, threadinfo ffff88000ee06000, task ffff88000edbbe80)
>> [    1.233508] Stack:
>> [    1.233511]  ffff88000ee07b30 ffffffff8107a72a ffff88000ee07b40 ffffffff8107a743
>> [    1.233522]  ffff88000ee07b50 ffffffff81575250 ffff88000ee07b80 ffffffff815779c7
>> [    1.233533]  ffffffff81e10500 00000000000000df 0000000000000020 ffffffff82729c80
>> [    1.233545] Call Trace:
>> [    1.233550]  [<ffffffff8107a72a>] queue_work+0x1a/0x20
>> [    1.233556]  [<ffffffff8107a743>] schedule_work+0x13/0x20
>> [    1.233564]  [<ffffffff81575250>] rtc_update_irq+0x10/0x20
>> [    1.233571]  [<ffffffff815779c7>] cmos_checkintr+0x67/0x70
>> [    1.233577]  [<ffffffff81577a1d>] cmos_irq_disable+0x4d/0x60
>> [    1.233583]  [<ffffffff81578ad1>] ? cmos_set_alarm+0xc1/0x220
>> [    1.234342]  [<ffffffff81578ade>] cmos_set_alarm+0xce/0x220
>> [    1.234342]  [<ffffffff81574c43>] ? rtc_time_to_tm+0xe3/0x1b0
>> [    1.234342]  [<ffffffff8157541b>] __rtc_set_alarm+0x9b/0xa0
>> [    1.234342]  [<ffffffff81575899>] rtc_timer_do_work+0x1c9/0x1e0
>> [    1.234342]  [<ffffffff81096127>] ? lock_acquire+0x97/0xb0
>> [    1.234342]  [<ffffffff81079d20>] process_one_work+0x190/0x450
>> [    1.234342]  [<ffffffff81079cbf>] ? process_one_work+0x12f/0x450
>> [    1.234342]  [<ffffffff815756d0>] ? rtc_timer_start+0x80/0x80
>> [    1.234342]  [<ffffffff8107cb21>] worker_thread+0x171/0x3a0
>> [    1.234342]  [<ffffffff8107c9b0>] ? manage_workers+0x210/0x210
>> [    1.234342]  [<ffffffff81081526>] kthread+0x96/0xa0
>> [    1.234342]  [<ffffffff818ed774>] kernel_thread_helper+0x4/0x10
>> [    1.234342]  [<ffffffff818eb7f8>] ? int_ret_from_sys_call+0x7/0x1b
>> [    1.234342]  [<ffffffff818e4e45>] ? retint_restore_args+0x5/0x6
>> [    1.234342]  [<ffffffff818ed770>] ? gs_change+0x13/0x13
>> [    1.234342] Code: 48 89 e5 48 89 ce 40 80 e6 00 83 e1 04 48 0f 45 c6 48 8b 70 08 65 8b 3c 25 b0 d9 00 00 e8 65 fc ff ff c9 c3 0f 1f 00 55 48 89 e5 <3e> 0f ba 2a 00 19 c9 31 c0 85 c9 74 07 c9 c3 0f 1f 44 00 00 e8
>> [    1.234342] RIP  [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
>> [    1.234342]  RSP <ffff88000ee07b20>
>> [    1.234342] CR2: 0000000000000598
>> [    1.234342] ---[ end trace e13f105b060373ec ]---
>> [    1.277121] BUG: unable to handle kernel paging request at fffffffffffffff8
>> [    1.277130] IP: [<ffffffff81080f8b>] kthread_data+0xb/0x20
>> [    1.277138] PGD 1e07067 PUD 1e08067 PMD 0
>> [    1.277147] Oops: 0000 [#2] SMP
>> [    1.277153] CPU 0
>> [    1.277156] Modules linked in:
>> [    1.277162]
>> [    1.277166] Pid: 586, comm: kworker/0:1 Tainted: G      D      3.2.0-rc7+ #1
>> [    1.277175] RIP: e030:[<ffffffff81080f8b>]  [<ffffffff81080f8b>] kthread_data+0xb/0x20
>> [    1.277184] RSP: e02b:ffff88000ee07708  EFLAGS: 00010096
>> [    1.277189] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> [    1.278053] RDX: ffff88000ffe7100 RSI: 0000000000000000 RDI: ffff88000edbbe80
>> [    1.278053] RBP: ffff88000ee07708 R08: ffff88000edbbef0 R09: 0000000000000001
>> [    1.278053] R10: 0000000000000800 R11: 0000000000000000 R12: ffff88000edbc1f0
>> [    1.278053] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88000ee07840
>> [    1.278053] FS:  0000000000000000(0000) GS:ffff88000ffd5000(0000) knlGS:0000000000000000
>> [    1.278053] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    1.278053] CR2: fffffffffffffff8 CR3: 0000000001e05000 CR4: 0000000000000660
>> [    1.278053] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [    1.278053] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [    1.278053] Process kworker/0:1 (pid: 586, threadinfo ffff88000ee06000, task ffff88000edbbe80)
>> [    1.278053] Stack:
>> [    1.278053]  ffff88000ee07728 ffffffff8107b050 ffff88000ee07728 ffff88000ffe7100
>> [    1.278053]  ffff88000ee077c8 ffffffff818e1d7c ffffffff81066d79 0000000000000000
>> [    1.278053]  ffff88000edbbe80 0000000000012100 ffff88000ee07fd8 ffff88000ee06010
>> [    1.278053] Call Trace:
>> [    1.278053]  [<ffffffff8107b050>] wq_worker_sleeping+0x10/0xa0
>> [    1.278053]  [<ffffffff818e1d7c>] __schedule+0x54c/0x8b0
>> [    1.278053]  [<ffffffff81066d79>] ? do_exit+0x519/0x850
>> [    1.278053]  [<ffffffff810087af>] ? xen_restore_fl_direct_reloc+0x4/0x4
>> [    1.278053]  [<ffffffff818e23ea>] schedule+0x3a/0x60
>> [    1.278053]  [<ffffffff81066def>] do_exit+0x58f/0x850
>> [    1.278053]  [<ffffffff81063d3d>] ? kmsg_dump+0xfd/0x140
>> [    1.278053]  [<ffffffff818e5b67>] oops_end+0xc7/0x120
>> [    1.278053]  [<ffffffff810640ff>] ? console_unlock+0x21f/0x290
>> [    1.278053]  [<ffffffff81036285>] no_context+0xf5/0x270
>> [    1.278053]  [<ffffffff8103654d>] __bad_area_nosemaphore+0x14d/0x220
>> [    1.278053]  [<ffffffff8103662e>] bad_area_nosemaphore+0xe/0x10
>> [    1.278053]  [<ffffffff818e8826>] do_page_fault+0x336/0x490
>> [    1.278053]  [<ffffffff81007fed>] ? xen_force_evtchn_callback+0xd/0x10
>> [    1.278053]  [<ffffffff810087c2>] ? check_events+0x12/0x20
>> [    1.278053]  [<ffffffff818e50b5>] page_fault+0x25/0x30
>> [    1.278053]  [<ffffffff8107a6c4>] ? queue_work_on+0x4/0x30
>> [    1.278053]  [<ffffffff8107a72a>] queue_work+0x1a/0x20
>> [    1.278053]  [<ffffffff8107a743>] schedule_work+0x13/0x20
>> [    1.278053]  [<ffffffff81575250>] rtc_update_irq+0x10/0x20
>> [    1.278053]  [<ffffffff815779c7>] cmos_checkintr+0x67/0x70
>> [    1.278053]  [<ffffffff81577a1d>] cmos_irq_disable+0x4d/0x60
>> [    1.278053]  [<ffffffff81578ad1>] ? cmos_set_alarm+0xc1/0x220
>> [    1.278053]  [<ffffffff81578ade>] cmos_set_alarm+0xce/0x220
>> [    1.278053]  [<ffffffff81574c43>] ? rtc_time_to_tm+0xe3/0x1b0
>> [    1.278053]  [<ffffffff8157541b>] __rtc_set_alarm+0x9b/0xa0
>> [    1.278053]  [<ffffffff81575899>] rtc_timer_do_work+0x1c9/0x1e0
>> [    1.278053]  [<ffffffff81096127>] ? lock_acquire+0x97/0xb0
>> [    1.278053]  [<ffffffff81079d20>] process_one_work+0x190/0x450
>> [    1.278053]  [<ffffffff81079cbf>] ? process_one_work+0x12f/0x450
>> [    1.278053]  [<ffffffff815756d0>] ? rtc_timer_start+0x80/0x80
>> [    1.278053]  [<ffffffff8107cb21>] worker_thread+0x171/0x3a0
>> [    1.278053]  [<ffffffff8107c9b0>] ? manage_workers+0x210/0x210
>> [    1.278053]  [<ffffffff81081526>] kthread+0x96/0xa0
>> [    1.278053]  [<ffffffff818ed774>] kernel_thread_helper+0x4/0x10
>> [    1.278053]  [<ffffffff818eb7f8>] ? int_ret_from_sys_call+0x7/0x1b
>> [    1.278053]  [<ffffffff818e4e45>] ? retint_restore_args+0x5/0x6
>> [    1.278053]  [<ffffffff818ed770>] ? gs_change+0x13/0x13
>> [    1.278053] Code: 55 65 48 8b 04 25 40 c4 00 00 48 8b 80 18 03 00 00 48 89 e5 8b 40 f0 c9 c3 0f 1f 80 00 00 00 00 48 8b 87 18 03 00 00 55 48 89 e5 <48> 8b 40 f8 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
>> [    1.278053] RIP  [<ffffffff81080f8b>] kthread_data+0xb/0x20
>> [    1.278053]  RSP <ffff88000ee07708>
>> [    1.278053] CR2: fffffffffffffff8
>> [    1.278053] ---[ end trace e13f105b060373ed ]---
>> [    1.278053] Fixing recursive fault but reboot is needed!
>> 
>> --
>> Sander


