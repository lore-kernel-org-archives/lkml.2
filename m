Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0EDKnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:43:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab0EDKm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:42:58 -0400
Message-ID: <4BDFFAEB.2000203@redhat.com>
Date: Tue, 04 May 2010 18:46:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Jones <davej@redhat.com>, Miles Lane <miles.lane@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.34-rc5-git7 -- INFO: possible circular locking dependency
 detected - &per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff8139f077>]
 lock_policy_rwsem_read+0x4a/0x7a
References: <v2sa44ae5cd1004261830wd566507by56131aa9ececb3d@mail.gmail.com>	<20100427014136.GA14719@redhat.com> <4BD8196E.3000407@redhat.com> <m1ljc7prq9.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljc7prq9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Cong Wang <amwang@redhat.com> writes:
> 
>> (Adding Eric B. into Cc.)
>>
>> Dave Jones wrote:
>>> On Mon, Apr 26, 2010 at 09:30:41PM -0400, Miles Lane wrote:
>>>  > Dave, is this the same?   http://marc.info/?l=linux-kernel&m=127207512031810&w=2
>>>
>>> looks like it to me.  499bca9b6d3243f9278a1f5a22d00e67acdd844d should have fixed it,
>>> but it looks like that's present in -git7, so something is still missing..
>>>
>>> 	Dave
>>>
>>>  > I produced this one by running "find /sys | xargs cat"
>>>  >  > [ 2982.773548] [ INFO: possible circular locking dependency detected ]
>>>  > [ 2982.773551] 2.6.34-rc5-git7 #33
>>>  > [ 2982.773554] -------------------------------------------------------
>>>  > [ 2982.773557] head/6335 is trying to acquire lock:
>>>  > [ 2982.773560]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
>>>  > [<ffffffff8139f077>] lock_policy_rwsem_read+0x4a/0x7a
>>>  > [ 2982.773571]
>>>  > [ 2982.773572] but task is already holding lock:
>>>  > [ 2982.773575]  (s_active#102){++++.+}, at: [<ffffffff81153a23>]
>>>  > sysfs_read_file+0x8d/0x139
>>>  > [ 2982.773586]
>>>  > [ 2982.773586] which lock already depends on the new lock.
>>>  > [ 2982.773587]
>>>  > [ 2982.773590]
>>>  > [ 2982.773591] the existing dependency chain (in reverse order) is:
>>>  > [ 2982.773593]
>>>  > [ 2982.773594] -> #2 (s_active#102){++++.+}:
>>>  > [ 2982.773601]        [<ffffffff8107654d>] __lock_acquire+0xb59/0xd11
>>>  > [ 2982.773608]        [<ffffffff8107681a>] lock_acquire+0x115/0x150
>>>  > [ 2982.773613]        [<ffffffff81154556>] sysfs_deactivate+0x9b/0xec
>>>  > [ 2982.773619]        [<ffffffff81154d0a>] sysfs_addrm_finish+0x31/0x50
>>>  > [ 2982.773624]        [<ffffffff81152e05>] sysfs_hash_and_remove+0x4e/0x65
>>>  > [ 2982.773629]        [<ffffffff81155fc0>] sysfs_remove_group+0x8c/0xc5
>>>  > [ 2982.773634]        [<ffffffffa00a3d26>]
>>>  > cpufreq_governor_dbs+0x2a6/0x33c [cpufreq_ondemand]
>>>  > [ 2982.773642]        [<ffffffff8139da32>] __cpufreq_governor+0x5d/0xa3
>>>  > [ 2982.773648]        [<ffffffff8139e4e2>] __cpufreq_remove_dev+0x231/0x2e2
>>>  > [ 2982.773653]        [<ffffffff81454e40>] cpufreq_cpu_callback+0x62/0x7a
>>>  > [ 2982.773660]        [<ffffffff8145d636>] notifier_call_chain+0x63/0x97
>>>  > [ 2982.773666]        [<ffffffff810680dc>] __raw_notifier_call_chain+0x9/0xb
>>>  > [ 2982.773672]        [<ffffffff8144337b>] _cpu_down+0x90/0x29e
>>>  > [ 2982.773679]        [<ffffffff81048cd7>] disable_nonboot_cpus+0x6f/0x105
>>>  > [ 2982.773685]        [<ffffffff81083b94>] suspend_devices_and_enter+0xe8/0x1ec
>>>  > [ 2982.773691]        [<ffffffff81083d72>] enter_state+0xda/0x12b
>>>  > [ 2982.773696]        [<ffffffff810834d5>] state_store+0xb1/0xce
>>>  > [ 2982.773702]        [<ffffffff811f2fb3>] kobj_attr_store+0x17/0x19
>>>  > [ 2982.773708]        [<ffffffff8115395a>] sysfs_write_file+0x103/0x13f
>>>  > [ 2982.773713]        [<ffffffff810fb933>] vfs_write+0xa9/0x106
>>>  > [ 2982.773719]        [<ffffffff810fba46>] sys_write+0x45/0x69
>>>  > [ 2982.773723]        [<ffffffff81009d82>] system_call_fastpath+0x16/0x1b
>>>  > [ 2982.773730]
>>>  > [ 2982.773731] -> #1 (dbs_mutex){+.+.+.}:
>>>  > [ 2982.773737]        [<ffffffff8107654d>] __lock_acquire+0xb59/0xd11
>>>  > [ 2982.773742]        [<ffffffff8107681a>] lock_acquire+0x115/0x150
>>>  > [ 2982.773747]        [<ffffffff814582ce>] __mutex_lock_common+0x57/0x558
>>>  > [ 2982.773752]        [<ffffffff81458875>] mutex_lock_nested+0x34/0x39
>>>  > [ 2982.773757]        [<ffffffffa00a3af6>]
>>>  > cpufreq_governor_dbs+0x76/0x33c [cpufreq_ondemand]
>>>  > [ 2982.773763]        [<ffffffff8139da32>] __cpufreq_governor+0x5d/0xa3
>>>  > [ 2982.773769]        [<ffffffff8139e7ec>] __cpufreq_set_policy+0x1a8/0x222
>>>  > [ 2982.773774]        [<ffffffff8139ecca>] store_scaling_governor+0x19f/0x1ed
>>>  > [ 2982.773779]        [<ffffffff8139e622>] store+0x56/0x78
>>>  > [ 2982.773783]        [<ffffffff8115395a>] sysfs_write_file+0x103/0x13f
>>>  > [ 2982.773788]        [<ffffffff810fb933>] vfs_write+0xa9/0x106
>>>  > [ 2982.773793]        [<ffffffff810fba46>] sys_write+0x45/0x69
>>>  > [ 2982.773798]        [<ffffffff81009d82>] system_call_fastpath+0x16/0x1b
>>>  > [ 2982.773803]
>>>  > [ 2982.773804] -> #0 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
>>>  > [ 2982.773810]        [<ffffffff810763f7>] __lock_acquire+0xa03/0xd11
>>>  > [ 2982.773815]        [<ffffffff8107681a>] lock_acquire+0x115/0x150
>>>  > [ 2982.773820]        [<ffffffff81458bba>] down_read+0x42/0x57
>>>  > [ 2982.773825]        [<ffffffff8139f077>] lock_policy_rwsem_read+0x4a/0x7a
>>>  > [ 2982.773830]        [<ffffffff8139f0d7>] show+0x30/0x69
>>>  > [ 2982.773835]        [<ffffffff81153a4a>] sysfs_read_file+0xb4/0x139
>>>  > [ 2982.773840]        [<ffffffff810fbb10>] vfs_read+0xa6/0x103
>>>  > [ 2982.773844]        [<ffffffff810fbc23>] sys_read+0x45/0x69
>>>  > [ 2982.773849]        [<ffffffff81009d82>] system_call_fastpath+0x16/0x1b
>>>  > [ 2982.773854]
>>>  > [ 2982.773855] other info that might help us debug this:
>>>  > [ 2982.773856]
>>>  > [ 2982.773860] 2 locks held by head/6335:
>>>  > [ 2982.773862]  #0:  (&buffer->mutex){+.+.+.}, at:
>>>  > [<ffffffff811539ca>] sysfs_read_file+0x34/0x139
>>>  > [ 2982.773871]  #1:  (s_active#102){++++.+}, at: [<ffffffff81153a23>]
>>>  > sysfs_read_file+0x8d/0x139
>>>  > [ 2982.773881]
>>>  > [ 2982.773882] stack backtrace:
>>>  > [ 2982.773886] Pid: 6335, comm: head Not tainted 2.6.34-rc5-git7 #33
>>>  > [ 2982.773889] Call Trace:
>>>  > [ 2982.773893]  [<ffffffff810755c3>] print_circular_bug+0xa8/0xb7
>>>  > [ 2982.773893]  [<ffffffff810763f7>] __lock_acquire+0xa03/0xd11
>>>  > [ 2982.773893]  [<ffffffff810766f6>] ? __lock_acquire+0xd02/0xd11
>>>  > [ 2982.773893]  [<ffffffff8139f077>] ? lock_policy_rwsem_read+0x4a/0x7a
>>>  > [ 2982.773893]  [<ffffffff8107681a>] lock_acquire+0x115/0x150
>>>  > [ 2982.773893]  [<ffffffff8139f077>] ? lock_policy_rwsem_read+0x4a/0x7a
>>>  > [ 2982.773893]  [<ffffffff81458bba>] down_read+0x42/0x57
>>>  > [ 2982.773893]  [<ffffffff8139f077>] ? lock_policy_rwsem_read+0x4a/0x7a
>>>  > [ 2982.773893]  [<ffffffff81459cb9>] ? _raw_spin_unlock_irqrestore+0x87/0x95
>>>  > [ 2982.773893]  [<ffffffff8139f077>] lock_policy_rwsem_read+0x4a/0x7a
>>>  > [ 2982.773893]  [<ffffffff8139f0d7>] show+0x30/0x69
>>>  > [ 2982.773893]  [<ffffffff81153a4a>] sysfs_read_file+0xb4/0x139
>>>  > [ 2982.773893]  [<ffffffff810fbb10>] vfs_read+0xa6/0x103
>>>  > [ 2982.773893]  [<ffffffff81074eae>] ? trace_hardirqs_on_caller+0x127/0x152
>>>  > [ 2982.773893]  [<ffffffff810fbc23>] sys_read+0x45/0x69
>>>  > [ 2982.773893]  [<ffffffff81009d82>] system_call_fastpath+0x16/0x1b
>>>  
>> With Eric B.'s patch, lockdep will treat s_active as a rwsem too, thus causes
>> this warning...
> 
> Something seems to be missing from the trace I was copied on, but this
> appears to be a classic case of holding a lock over removing a sysfs
> attribute that the sysfs attribute grabs in it's show or store method.
> 
> The kernel blocks when a sysfs attribute is removed waiting for all
> in process  readers and writers to finish.  The removes the need for
> nasty module refcounting, and concerns about data being accessed after
> it has been freed.

Hmm, I see the problem now. Lockdep chose a wrong target to blame.
There is a circular locking between writing to cpufreq sysfs files and
suspend, the cpu offline notifier of cpufreq, i.e. cpufreq_cpu_callback()
also tries to remove an sysfs file while the cpufreq daemon is writing
an sysfs file.

Dave, any ideas about how to fix this?

Thanks.
