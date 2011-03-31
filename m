Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1CaNdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:33:53 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:34824 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab1CaNdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:33:50 -0400
X-ASG-Debug-ID: 1301578428-03d6a569fb2b910001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D9482BA.8080807@fusionio.com>
Date: Thu, 31 Mar 2011 15:33:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Tejun Heo <tj@kernel.org>, Rob Landley <rlandley@parallels.com>,
        Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net>	 <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com>	 <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com>	 <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com>	 <4D945976.8000401@fusionio.com> <20110331121100.GD3385@htj.dyndns.org>	 <4D9474AA.4070402@fusionio.com> <4D947D12.6070505@rsk.demon.co.uk>	 <4D947F29.5050203@fusionio.com> <1301577831.1984.2.camel@castor.rsk>
X-ASG-Orig-Subj: Re: Commit 7eaceaccab5f40 causing boot hang.
In-Reply-To: <1301577831.1984.2.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301578428
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59505
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-31 15:23, Richard Kennedy wrote:
> On Thu, 2011-03-31 at 15:18 +0200, Jens Axboe wrote:
>> On 2011-03-31 15:09, Richard Kennedy wrote:
>>> On 31/03/11 13:33, Jens Axboe wrote:
>>>> On 2011-03-31 14:11, Tejun Heo wrote:
>>>>> Hello,
>>>>>
>>>>> On Thu, Mar 31, 2011 at 12:37:42PM +0200, Jens Axboe wrote:
>>>>>> It seems to hard hang, looks very odd:
>>>>>>
>>>>>> [   84.056007] BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:2:743]
>>>>>> [   84.056008] Modules linked in:
>>>>>> [   84.056008] irq event stamp: 334859658
>>>>>> [   84.056008] hardirqs last  enabled at (334859657): [<ffffffff815c40c7>] _raw_spin_unlock_irq+0x2b/0x30
>>>>>> [   84.056008] hardirqs last disabled at (334859658): [<ffffffff815c42e7>] save_args+0x67/0x70
>>>>>> [   84.056008] softirqs last  enabled at (334855538): [<ffffffff81044819>] __do_softirq+0x1a3/0x1c2
>>>>>> [   84.056008] softirqs last disabled at (334855525): [<ffffffff815cb9cc>] call_softirq+0x1c/0x30
>>>>>> [   84.056008] CPU 0 
>>>>>> [   84.056008] Modules linked in:
>>>>>> [   84.056008] 
>>>>>> [   84.056008] Pid: 743, comm: kworker/0:2 Not tainted 2.6.39-rc1+ #12 Bochs Bochs
>>>>>> [   84.056008] RIP: 0010:[<ffffffff815c40c9>]  [<ffffffff815c40c9>] _raw_spin_unlock_irq+0x2d/0x30
>>>>>> [   84.056008] RSP: 0018:ffff88003d343d98  EFLAGS: 00000202
>>>>>> [   84.056008] RAX: 0000000013f58d89 RBX: 0000000000000006 RCX: ffff88003d2c5998
>>>>>> [   84.056008] RDX: 0000000000000006 RSI: ffff88003d343da0 RDI: ffff88003db19508
>>>>>> [   84.056008] RBP: ffff88003d343da0 R08: ffff88003fc15c00 R09: 0000000000000001
>>>>>> [   84.056008] R10: ffffffff81e0d040 R11: ffff88003d343d60 R12: ffffffff815cb18e
>>>>>> [   84.056008] R13: 0000000000000001 R14: ffff88003d2c5998 R15: ffffffff81069aec
>>>>>> [   84.056008] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
>>>>>> [   84.056008] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>>> [   84.056008] CR2: 000000000060d828 CR3: 000000003d3f8000 CR4: 00000000000006f0
>>>>>> [   84.056008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>> [   84.056008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>>>> [   84.056008] Process kworker/0:2 (pid: 743, threadinfo ffff88003d342000, task ffff88003db18f60)
>>>>>> [   84.056008] Stack:
>>>>>> [   84.056008]  ffff88003d2c5870 ffff88003d343dc0 ffffffff812171d3 ffff88003fc15c00
>>>>>> [   84.056008]  ffff88003d31e6c0 ffff88003d343e50 ffffffff81053e99 ffffffff81053e0b
>>>>>> [   84.056008]  ffff88003d342010 ffff88003db18f60 0000000000000046 ffff88003fc15c05
>>>>>> [   84.056008] Call Trace:
>>>>>> [   84.056008]  [<ffffffff812171d3>] blk_delay_work+0x32/0x36
>>>>>> [   84.056008]  [<ffffffff81053e99>] process_one_work+0x230/0x397
>>>>>> [   84.056008]  [<ffffffff81053e0b>] ? process_one_work+0x1a2/0x397
>>>>>> [   84.056008]  [<ffffffff8105612a>] worker_thread+0x136/0x255
>>>>>> [   84.056008]  [<ffffffff81055ff4>] ? manage_workers+0x190/0x190
>>>>>> [   84.056008]  [<ffffffff8105974a>] kthread+0x7d/0x85
>>>>>> [   84.056008]  [<ffffffff815cb8d4>] kernel_thread_helper+0x4/0x10
>>>>>> [   84.056008]  [<ffffffff815c4440>] ? retint_restore_args+0xe/0xe
>>>>>> [   84.056008]  [<ffffffff810596cd>] ? __init_kthread_worker+0x56/0x56
>>>>>> [   84.056008]  [<ffffffff815cb8d0>] ? gs_change+0xb/0xb
>>>>>> [   84.056008] Code: 01 00 00 00 48 89 e5 53 48 89 fb 48 83 c7 18 48 83 ec 08 48 8b 55 08 e8 11 7b aa ff 48 89 df e8 03 05 c7 ff e8 f3 5e aa ff fb 5e <5b> c9 c3 55 48 89 e5 41 54 49 89 fc 48 8b 55 08 48 83 c7 18 53 
>>>>>
>>>>> Is CONFIG_PREEMPT[_VOLUNTARY] set?  The soft lockup detection works by
>>>>> checking whether a high pri RT task is scheduled periodically and busy
>>>>> looping in kernel code with preemption disabled or CONFIG_PREEMPT
>>>>> disabled would trigger it.  The backtrace doesn't mean the CPU is
>>>>> stuck there not progressing.  It just shows where the CPU is at the
>>>>> moment of triggering and the softlockup triggering itself indicates
>>>>> that IRQ and bottom halves are running fine.
>>>>>
>>>>> I think more likely failure mode is something is looping in block path
>>>>> expecting someone else to do something but as it is busy looping and
>>>>> preemption isn't enabled the someone else can't proceed.  We had a
>>>>> similar problem in md lately.
>>>>>
>>>>>  http://thread.gmane.org/gmane.linux.raid/33020
>>>>
>>>> I think this sound exactly right, and also explains why SMP works. And
>>>> yes CONFIG_PREEMPT_VOLUNTARY=y is set.
>>>>
>>>>> If this is the case, a good way to debug would be triggering sysrq-l
>>>>> multiple times while the machine is hung and see where the CPU is busy
>>>>> looping.
>>>>
>>>> Doesn't respond to sysrq. I'll poke around.
>>>>
>>>
>>> Hi Jens,
>>>
>>> I'm seeing a problem with fio never completing when writing to 2 disks
>>> simultaneously. In my test case I'm writing 2Gb to both a LVM volume & a
>>> pata drive on x86_64 on a AMD X2. Could this be a related issue?
>>>
>>> I'm not getting anything reported in the log, lockup detection doesn't
>>> report anything either. The write seems to have finished (the disk light
>>> activity has stopped) and the cpu cores are both below 10% usage, but
>>> fio never returns. The test does complete some times, but it seems to be
>>> one 1 in 4.
>>
>> So when you say PATA, it's /dev/hdaX something as well?
>>
>>> I'm going to try tracing it and see if I can spot where it's stuck.
>>
>> Thanks, that would be nice.
>>
> The second drive is /dev/sdb1 mounted on /opt, both file systems are
> ext4.

So probably not related. What does the fio job look like?

-- 
Jens Axboe

