Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab1EWUO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:14:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19539 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1EWUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:14:54 -0400
Message-ID: <4DDAC01E.7050602@kernel.org>
Date: Mon, 23 May 2011 13:14:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <tip-80d02085d99039b3b7f3a73c8896226b0cb1ba07@git.kernel.org> <4DD6D746.6070107@kernel.org> <20110520224250.GL2366@linux.vnet.ibm.com> <4DD6F4A2.1070401@kernel.org> <20110520231428.GN2366@linux.vnet.ibm.com> <4DD6F64C.3030402@kernel.org> <20110520234923.GQ2366@linux.vnet.ibm.com> <4DD70120.9090801@kernel.org> <20110521131844.GE2271@linux.vnet.ibm.com> <20110521140845.GA12157@linux.vnet.ibm.com>
In-Reply-To: <20110521140845.GA12157@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DDAC028.000D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2011 07:08 AM, Paul E. McKenney wrote:
> On Sat, May 21, 2011 at 06:18:44AM -0700, Paul E. McKenney wrote:
>> On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
>>> On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
>>>> On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
>>> ...
>>>>>
>>>>> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
>>>>
>>>> OK, just to make sure I understand...  You are compiling exactly the
>>>> same kernel source tree with exactly the same .config, just with two
>>>> different versions of gcc, correct?
>>> yes.
>>>>
>>>> If so, it is quite possible that the slow one is the correct one.  :-/
>>> yeah, new version always have problem.
>>>
>>> looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1
>>
>> OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
>> one (4.5.0), correct?
> 
> And does commit c7a3786030 help?  This commit (from Peter Zijlstra)
> tidied up RCU kthreads' scheduler interactions.  The patch is below,
> though it is probably more convenient to pull it from the rcu/next
> branch of:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> 

[  337.132517] INFO: task rcun0:8 blocked for more than 120 seconds.
[  337.133238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.160396] rcun0           D 0000000000000000     0     8      2 0x00000000
[  337.161232]  ffff882070d3fe90 0000000000000046 ffff882070d3e000 0000000000004000
[  337.161291]  00000000001d1f80 ffff882070d3ffd8 00000000001d1f80 ffff882070d3ffd8
[  337.161348]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff882070d422b0
[  337.161404] Call Trace:
[  337.161433]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.161459]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.161486]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.161512]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.161533]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.161558]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.161584]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.161606]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.161627]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.161645]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.161651] no locks held by rcun0/8.
[  337.161723] INFO: task rcun3:171 blocked for more than 120 seconds.
[  337.161729] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.161736] rcun3           D 0000000000000000     0   171      2 0x00000000
[  337.161748]  ffff8820705bfe90 0000000000000046 ffff8820705be000 0000000000004000
[  337.161786]  00000000001d1f80 ffff8820705bffd8 00000000001d1f80 ffff8820705bffd8
[  337.161825]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff8820705ca2b0
[  337.161863] Call Trace:
[  337.161879]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.161895]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.161913]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.161930]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.161947]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.161963]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.161979]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.161995]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.162011]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.162026]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.162032] no locks held by rcun3/171.
[  337.162110] INFO: task rcun5:333 blocked for more than 120 seconds.
[  337.162117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.162123] rcun5           D 0000000000000000     0   333      2 0x00000000
[  337.162134]  ffff882070079e90 0000000000000046 ffff882070078000 0000000000004000
[  337.162173]  00000000001d1f80 ffff882070079fd8 00000000001d1f80 ffff882070079fd8
[  337.162213]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff882070070000
[  337.162250] Call Trace:
[  337.162265]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.162282]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.162299]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.162316]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.162333]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.162349]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.162366]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.162382]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.162399]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.162415]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.162421] no locks held by rcun5/333.
[  337.162469] INFO: task rcun6:414 blocked for more than 120 seconds.
[  337.162475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.162481] rcun6           D 0000000000000000     0   414      2 0x00000000
[  337.162493]  ffff8820701b3e90 0000000000000046 ffff8820701b2000 0000000000004000
[  337.162532]  00000000001d1f80 ffff8820701b3fd8 00000000001d1f80 ffff8820701b3fd8
[  337.162571]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff8820701ac560
[  337.162610] Call Trace:
[  337.162625]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.162640]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.162659]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.162676]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.162692]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.162709]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.162726]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.162741]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.162757]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.162773]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.162779] no locks held by rcun6/414.
[  337.162816] INFO: task rcun7:495 blocked for more than 120 seconds.
[  337.162822] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.162828] rcun7           D 0000000000000000     0   495      2 0x00000000
[  337.162839]  ffff8820703d1e90 0000000000000046 ffff8820703d0000 0000000000004000
[  337.162880]  00000000001d1f80 ffff8820703d1fd8 00000000001d1f80 ffff8820703d1fd8
[  337.162919]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff8820703ca2b0
[  337.162957] Call Trace:
[  337.162973]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.162989]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.163006]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.163022]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.163039]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.163055]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.163072]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.163087]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.163104]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.163120]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.163125] no locks held by rcun7/495.
[  337.163166] INFO: task rcun8:576 blocked for more than 120 seconds.
[  337.163172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.163178] rcun8           D 0000000000000000     0   576      2 0x00000000
[  337.163190]  ffff881fff913e90 0000000000000046 ffff881fff912000 0000000000004000
[  337.163231]  00000000001d1f80 ffff881fff913fd8 00000000001d1f80 ffff881fff913fd8
[  337.163271]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff881fff90a2b0
[  337.163309] Call Trace:
[  337.163324]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.163340]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.163358]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.163375]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.163392]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.163409]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.163425]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.163440]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.163457]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.163473]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.163479] no locks held by rcun8/576.
[  337.163558] INFO: task rcun10:738 blocked for more than 120 seconds.
[  337.163564] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  337.163570] rcun10          D 0000000000000000     0   738      2 0x00000000
[  337.163582]  ffff881fffbb5e90 0000000000000046 ffff881fffbb4000 0000000000004000
[  337.163620]  00000000001d1f80 ffff881fffbb5fd8 00000000001d1f80 ffff881fffbb5fd8
[  337.163659]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff881fffbba2b0
[  337.163697] Call Trace:
[  337.163712]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
[  337.163728]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
[  337.163744]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.163760]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
[  337.163777]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
[  337.163793]  [<ffffffff81099e41>] kthread+0x8c/0xa8
[  337.163810]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
[  337.163826]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
[  337.163842]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
[  337.163857]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
[  337.163863] no locks held by rcun10/738.
