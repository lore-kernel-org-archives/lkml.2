Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2AXWrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:47:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40684 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2AXWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:47:44 -0500
Message-ID: <4F1F350B.6010508@suse.cz>
Date: Tue, 24 Jan 2012 23:47:39 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <4F1ED9C4.9020503@linux.vnet.ibm.com> <4F1EDB41.2070303@suse.cz> <201201242336.22482.rjw@sisk.pl>
In-Reply-To: <201201242336.22482.rjw@sisk.pl>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 11:36 PM, Rafael J. Wysocki wrote:
> On Tuesday, January 24, 2012, Jiri Slaby wrote:
>> On 01/24/2012 05:18 PM, Srivatsa S. Bhat wrote:
>>> Hi Jiri,
>>>
>>> On 01/24/2012 08:35 PM, Jiri Slaby wrote:
>>>
>>>> Hi,
>>>>
>>>> this is a freshly booted system. When I do s2dsk, I see:
>>>> ...
>>>> Freezing remaining freezable tasks ... BUG: 'workqueue_freezing' is true!
>>>> ------------[ cut here ]------------
>>>> kernel BUG at /l/latest/linux/kernel/workqueue.c:3659!
>>>> invalid opcode: 0000 [#1] SMP
>>>> CPU 0
>>>> Modules linked in:
>>>>
>>>> Pid: 2669, comm: s2disk Not tainted 3.3.0-rc1-next-20120124_64+ #1627
>>>> Bochs Bochs
>>>> RIP: 0010:[<ffffffff8107e365>]  [<ffffffff8107e365>]
>>>> freeze_workqueues_begin+0x195/0x1a0
>>>> RSP: 0018:ffff880046f01d68  EFLAGS: 00010292
>>>> RAX: 0000000000000023 RBX: 0000000000000001 RCX: 00000000000000c9
>>>> RDX: 0000000000000077 RSI: 0000000000000046 RDI: ffffffff81b51f7c
>>>> RBP: ffff880046f01d98 R08: ffffffff81a9d760 R09: 0000000000000000
>>>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>>> R13: 00007fff579464dc R14: ffffffffffffffff R15: 0000000000000004
>>>> FS:  00007f3c65d54700(0000) GS:ffff880049600000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> CR2: 00007f3c64f58c20 CR3: 0000000045b64000 CR4: 00000000000006f0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> Process s2disk (pid: 2669, threadinfo ffff880046f00000, task
>>>> ffff880047251980)
>>>> Stack:
>>>>  ffff880046f01d98 0000000000000001 0000000000000000 00007fff579464dc
>>>>  ffffffffffffffff 0000000000000004 ffff880046f01e18 ffffffff81096cb9
>>>>  00000000ffff0124 0000000000000004 ffff880046f01e18 000000004f1ec7d1
>>>> Call Trace:
>>>>  [<ffffffff81096cb9>] try_to_freeze_tasks+0x1b9/0x2d0
>>>>  [<ffffffff81096ed5>] freeze_kernel_threads+0x25/0x90
>>>>  [<ffffffff81097b55>] hibernation_snapshot+0x75/0x2e0
>>>>  [<ffffffff8109d724>] snapshot_ioctl+0x314/0x4e0
>>>>  [<ffffffff81130856>] do_vfs_ioctl+0x96/0x550
>>>>  [<ffffffff8111ff7b>] ? vfs_write+0x10b/0x180
>>>>  [<ffffffff81130d5a>] sys_ioctl+0x4a/0x80
>>>>  [<ffffffff81630e22>] system_call_fastpath+0x16/0x1b
>>>> Code: c7 c6 0a a4 92 81 48 c7 c7 16 65 92 81 31 c0 e8 19 94 5a 00 0f 0b
>>>> 48 c7 c6 27 a4 92 81 48 c7 c7 16 65 92 81 31 c0 e8 02 94 5a 00 <0f> 0b
>>>> 66 0f 1f 84 00 00 00 00 00 55 48 c7 c7 82 4b b9 81 48 89
>>>> RIP  [<ffffffff8107e365>] freeze_workqueues_begin+0x195/0x1a0
>>>>  RSP <ffff880046f01d68>
>>>> ---[ end trace 632574abdc098963 ]---
>>>>
>>>
>>>
>>> I couldn't find any obvious root-cause from a quick check. Is this completely
>>> reproducible upon a fresh boot?
>>
>> True.
>>
>> The cause is that the function is called twice:
> 
> Which function?

The one where the BUG is. Maybe the functions which should clear the
flag is not called in between? See:

>>  [<ffffffff8107e206>] freeze_workqueues_begin+0x36/0x1b0
                         ^^^^^^^^^^^^^^^^^^^^^^^
>>  [<ffffffff81096cc9>] try_to_freeze_tasks+0x1b9/0x2d0
>>  [<ffffffff81096ee5>] freeze_kernel_threads+0x25/0x90
>>  [<ffffffff81097b65>] hibernation_snapshot+0x75/0x2e0
>>  [<ffffffff8109d734>] snapshot_ioctl+0x314/0x4e0
>>  [<ffffffff81130866>] do_vfs_ioctl+0x96/0x550
>>  [<ffffffff8111ff8b>] ? vfs_write+0x10b/0x180
>>  [<ffffffff81130d6a>] sys_ioctl+0x4a/0x80
>>  [<ffffffff81630e22>] system_call_fastpath+0x16/0x1b
>> (elapsed 0.03 seconds) done.
...
>> Freezing remaining freezable tasks ... BUG: 'workqueue_freezing' is true!
>> ------------[ cut here ]------------
>> kernel BUG at /l/latest/linux/kernel/workqueue.c:3659!
...
>> RIP: 0010:[<ffffffff8107e371>]  [<ffffffff8107e371>
>> freeze_workqueues_begin+0x1a1/0x1b0
   ^^^^^^^^^^^^^^^^^^^^^^^
>> Call Trace:
>>  [<ffffffff81096cc9>] try_to_freeze_tasks+0x1b9/0x2d0
>>  [<ffffffff81096ee5>] freeze_kernel_threads+0x25/0x90
>>  [<ffffffff81097b65>] hibernation_snapshot+0x75/0x2e0
>>  [<ffffffff8109d734>] snapshot_ioctl+0x314/0x4e0
>>  [<ffffffff81130866>] do_vfs_ioctl+0x96/0x550
>>  [<ffffffff8111ff8b>] ? vfs_write+0x10b/0x180
>>  [<ffffffff81130d6a>] sys_ioctl+0x4a/0x80
>>  [<ffffffff81630e22>] system_call_fastpath+0x16/0x1b

-- 
js
suse labs
