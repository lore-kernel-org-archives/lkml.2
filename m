Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1G2ASG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:18:06 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:34251 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755472Ab1G2ASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:18:03 -0400
Message-ID: <4E31FC37.7080803@localhost>
Date: Thu, 28 Jul 2011 17:17:59 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt4
References: <alpine.LFD.2.02.1107272222420.2660@ionos>	 <4E31B59F.1000607@localhost> <1311888176.2617.379.camel@laptop>
In-Reply-To: <1311888176.2617.379.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 02:22 PM, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 12:16 -0700, Fernando Lopez-Lezcano wrote:
>> [    0.000000] =============================================
>> [    0.000000] [ INFO: possible recursive locking detected ]
>> [    0.000000] 3.0.0-1.rt5.1.fc15.ccrma.i686.rtPAE #1
>> [    0.000000] ---------------------------------------------
>> [    0.000000] swapper/0 is trying to acquire lock:
>> [    0.000000]  (&parent->list_lock){+.+...}, at: [<c04fb406>] __cache_free+0x43/0xc3
>> [    0.000000]
>> [    0.000000] but task is already holding lock:
>> [    0.000000]  (&parent->list_lock){+.+...}, at: [<c04fc538>] do_tune_cpucache+0xf2/0x2bb
>> [    0.000000]
>> [    0.000000] other info that might help us debug this:
>> [    0.000000]  Possible unsafe locking scenario:
>> [    0.000000]
>> [    0.000000]        CPU0
>> [    0.000000]        ----
>> [    0.000000]   lock(&parent->list_lock);
>> [    0.000000]   lock(&parent->list_lock);
>> [    0.000000]
>> [    0.000000]  *** DEADLOCK ***
>> [    0.000000]
>> [    0.000000]  May be due to missing lock nesting notation
>> [    0.000000]
>> [    0.000000] 3 locks held by swapper/0:
>> [    0.000000]  #0:  (cache_chain_mutex){+.+...}, at: [<c0bd9d2b>] kmem_cache_init_late+0xe/0x61
>> [    0.000000]  #1:  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: [<c04faa65>] __local_lock_irq+0x1e/0x5b
>> [    0.000000]  #2:  (&parent->list_lock){+.+...}, at: [<c04fc538>] do_tune_cpucache+0xf2/0x2bb
>> [    0.000000]
>> [    0.000000] stack backtrace:
>> [    0.000000] Pid: 0, comm: swapper Not tainted 3.0.0-1.rt5.1.fc15.ccrma.i686.rtPAE #1
>> [    0.000000] Call Trace:
>> [    0.000000]  [<c0856355>] ? printk+0x2d/0x2f
>> [    0.000000]  [<c0474a4b>] __lock_acquire+0x805/0xb57
>> [    0.000000]  [<c0472604>] ? lock_release_holdtime.part.10+0x4b/0x51
>> [    0.000000]  [<c085ecb4>] ? _raw_spin_unlock+0x31/0x3d
>> [    0.000000]  [<c085dbc5>] ? rt_spin_lock_slowlock+0x75/0x190
>> [    0.000000]  [<c04720c3>] ? trace_hardirqs_off+0xb/0xd
>> [    0.000000]  [<c04fb406>] ? __cache_free+0x43/0xc3
>> [    0.000000]  [<c0475215>] lock_acquire+0xde/0x11d
>> [    0.000000]  [<c04fb406>] ? __cache_free+0x43/0xc3
>> [    0.000000]  [<c085e24f>] rt_spin_lock+0x50/0x56
>> [    0.000000]  [<c04fb406>] ? __cache_free+0x43/0xc3
>> [    0.000000]  [<c04fb406>] __cache_free+0x43/0xc3
>> [    0.000000]  [<c043646d>] ? test_ti_thread_flag+0x8/0x10
>> [    0.000000]  [<c04fb23f>] kmem_cache_free+0x6c/0xdc
>> [    0.000000]  [<c04fb2fe>] slab_destroy+0x4f/0x53
>> [    0.000000]  [<c04fb396>] free_block+0x94/0xc1
>> [    0.000000]  [<c04fc551>] do_tune_cpucache+0x10b/0x2bb
>> [    0.000000]  [<c04fc8dc>] enable_cpucache+0x7b/0xa7
>> [    0.000000]  [<c0bd9d3c>] kmem_cache_init_late+0x1f/0x61
>> [    0.000000]  [<c0bba687>] start_kernel+0x24c/0x363
>> [    0.000000]  [<c0bba1c4>] ? loglevel+0x18/0x18
>> [    0.000000]  [<c0bba0ba>] i386_start_kernel+0xa9/0xaf
>
> Ooh, fun.. one does wonder why mainline doesn't show this..
>
> This is the normal OFF_SLAB recursion, and the reason this shows up is
> because this is ran before we do the lockdep fixup.
>
> Fernando, does something like the below (not actually against -rt, but
> it shouldn't matter much) fix things?

Strange. Looks like it only happens on a cold start (I would have to 
test more to be sure), so far two warm starts and it is not there, one 
cold start and it is there - sorry, I have run out of time now for more 
tests... (I checked my build logs and the patch applied cleanly, no 
complains there). Come to think of it I think this was not always 
happening before the patch (ie: not getting the error on all boots).

-- Fernando


[    0.000000] =============================================
[    0.000000] [ INFO: possible recursive locking detected ]
[    0.000000] 3.0.0-1.rt6.1.fc15.ccrma.i686.rtPAE #1
[    0.000000] ---------------------------------------------
[    0.000000] swapper/0 is trying to acquire lock:
[    0.000000]  (&parent->list_lock){+.+...}, at: [<c04fb406>] 
__cache_free+0x43/0xc3
[    0.000000]
[    0.000000] but task is already holding lock:
[    0.000000]  (&parent->list_lock){+.+...}, at: [<c04fc538>] 
do_tune_cpucache+0xf2/0x2bb
[    0.000000]
[    0.000000] other info that might help us debug this:
[    0.000000]  Possible unsafe locking scenario:
[    0.000000]
[    0.000000]        CPU0
[    0.000000]        ----
[    0.000000]   lock(&parent->list_lock);
[    0.000000]   lock(&parent->list_lock);
[    0.000000]
[    0.000000]  *** DEADLOCK ***
[    0.000000]
[    0.000000]  May be due to missing lock nesting notation
[    0.000000]
[    0.000000] 3 locks held by swapper/0:
[    0.000000]  #0:  (cache_chain_mutex){+.+...}, at: [<c0bd9d3b>] 
kmem_cache_init_late+0x1e/0x6a
[    0.000000]  #1:  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: 
[<c04faa65>] __local_lock_irq+0x1e/0x5b
[    0.000000]  #2:  (&parent->list_lock){+.+...}, at: [<c04fc538>] 
do_tune_cpucache+0xf2/0x2bb
[    0.000000]
[    0.000000] stack backtrace:
[    0.000000] Pid: 0, comm: swapper Not tainted 
3.0.0-1.rt6.1.fc15.ccrma.i686.rtPAE #1
[    0.000000] Call Trace:
[    0.000000]  [<c0856355>] ? printk+0x2d/0x2f
[    0.000000]  [<c0474a5b>] __lock_acquire+0x805/0xb57
[    0.000000]  [<c0472614>] ? lock_release_holdtime.part.10+0x4b/0x51
[    0.000000]  [<c085ecb4>] ? _raw_spin_unlock+0x31/0x3d
[    0.000000]  [<c085dbc5>] ? rt_spin_lock_slowlock+0x75/0x190
[    0.000000]  [<c04720d3>] ? trace_hardirqs_off+0xb/0xd
[    0.000000]  [<c04fb406>] ? __cache_free+0x43/0xc3
[    0.000000]  [<c0475225>] lock_acquire+0xde/0x11d
[    0.000000]  [<c04fb406>] ? __cache_free+0x43/0xc3
[    0.000000]  [<c085e24f>] rt_spin_lock+0x50/0x56
[    0.000000]  [<c04fb406>] ? __cache_free+0x43/0xc3
[    0.000000]  [<c04fb406>] __cache_free+0x43/0xc3
[    0.000000]  [<c043646d>] ? test_ti_thread_flag+0x8/0x10
[    0.000000]  [<c04fb23f>] kmem_cache_free+0x6c/0xdc
[    0.000000]  [<c04fb2fe>] slab_destroy+0x4f/0x53
[    0.000000]  [<c04fb396>] free_block+0x94/0xc1
[    0.000000]  [<c04fc551>] do_tune_cpucache+0x10b/0x2bb
[    0.000000]  [<c04fc8dc>] enable_cpucache+0x7b/0xa7
[    0.000000]  [<c0bd9d4c>] kmem_cache_init_late+0x2f/0x6a
[    0.000000]  [<c0bba687>] start_kernel+0x24c/0x363
[    0.000000]  [<c0bba1c4>] ? loglevel+0x18/0x18
[    0.000000]  [<c0bba0ba>] i386_start_kernel+0xa9/0xaf
[    0.000000] Console: colour VGA+ 80x25



