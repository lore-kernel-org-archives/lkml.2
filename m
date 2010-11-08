Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0KHNzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:55:45 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42967 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab0KHNzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:55:44 -0500
Message-ID: <4CD80162.9000607@fusionio.com>
Date: Mon, 08 Nov 2010 14:55:46 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1] sys_ioprio_set and RCU locking...
References: <AANLkTi=xj6xW5SnrdQos4P-MtJP8+fwfaa3r7LPfdLh4@mail.gmail.com> <20101107185433.GD15561@linux.vnet.ibm.com> <4CD7FAFD.1060802@fusionio.com> <20101108135204.GE2580@linux.vnet.ibm.com>
In-Reply-To: <20101108135204.GE2580@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-08 14:52, Paul E. McKenney wrote:
> On Mon, Nov 08, 2010 at 02:28:29PM +0100, Jens Axboe wrote:
>> On 2010-11-07 19:54, Paul E. McKenney wrote:
>>> On Tue, Nov 02, 2010 at 12:15:30PM +0000, Daniel J Blueman wrote:
>>>> With 2.6.37-rc1, I observe sys_ioprio_set not taking the RCU lock [1]
>>>> across access to the task credentials.
>>>>
>>>> Inspecting the code in fs/ioprio.c, the tasklist_lock is held for read
>>>> across the __task_cred call, which is presumably sufficient to prevent
>>>> the task credentials becoming stale.
>>>>
>>>> Thus, is there preference to take the RCU lock for read across the
>>>> credential access eg at [2], or annotate the call?
>>>>
>>>> Thanks,
>>>>   Daniel
>>>>
>>>> --- [1]
>>>>
>>>> ===================================================
>>>>
>>>> [ INFO: suspicious rcu_dereference_check() usage. ]
>>>>
>>>> ---------------------------------------------------
>>>>
>>>> kernel/pid.c:419 invoked rcu_dereference_check() without protection!
>>>>
>>>>
>>>>
>>>> other info that might help us debug this:
>>>>
>>>>
>>>>
>>>>
>>>> rcu_scheduler_active = 1, debug_locks = 1
>>>>
>>>> 1 lock held by start-stop-daem/2246:
>>>>
>>>>  #0:  (tasklist_lock){.?.?..}, at: [<ffffffff811a2dfa>]
>>>> sys_ioprio_set+0x8a/0x400
>>>>
>>>>
>>>>
>>>> stack backtrace:
>>>>
>>>> Pid: 2246, comm: start-stop-daem Not tainted 2.6.37-rc1-330cd+ #2
>>>>
>>>> Call Trace:
>>>>
>>>>  [<ffffffff8109f5f4>] lockdep_rcu_dereference+0xa4/0xc0
>>>>
>>>>  [<ffffffff81085651>] find_task_by_pid_ns+0x81/0x90
>>>>
>>>>  [<ffffffff8108567d>] find_task_by_vpid+0x1d/0x20
>>>>
>>>>  [<ffffffff811a3160>] sys_ioprio_set+0x3f0/0x400
>>>>
>>>>  [<ffffffff816efa79>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>>>
>>>>  [<ffffffff81003482>] system_call_fastpath+0x16/0x1b
>>>>
>>>>
>>>> --- [2]
>>>>
>>>> Take the RCU lock for read across acquiring the pointer to the task
>>>> credentials and dereferencing it.
>>>
>>> Jens, does this look sane?
>>
>> Yes, looks clean enough to me.
> 
> Very good!  Are you willing to take the patch in your tree?

Certainly, I'm in the middle of patch monkeying now anyway. Will queue
it up.


-- 
Jens Axboe

