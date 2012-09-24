Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2IXXfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:35:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51124 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2IXXft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <5060E863.6020006@gmail.com>
References: <20120921121346.GD2458@linux.vnet.ibm.com>
	<505C6B03.7020305@gmail.com>
	<20120921151203.GA2454@linux.vnet.ibm.com>
	<505C855F.3060301@gmail.com>
	<505D7621.4040505@gmail.com>
	<20120922150913.GA2934@linux.vnet.ibm.com>
	<505DDBE7.7010706@gmail.com>
	<20120922155613.GB2934@linux.vnet.ibm.com>
	<505DFA65.3080805@gmail.com>
	<20120922212735.GG2934@linux.vnet.ibm.com>
	<20120923002105.GA1112@linux.vnet.ibm.com>
	<505EA09B.6040105@gmail.com>
	<CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
	<5060E31B.3070203@gmail.com>
	<5060E498.7030003@gmail.com>
	<CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
	<5060E863.6020006@gmail.com>
Date: Tue, 25 Sep 2012 01:35:48 +0200
Message-ID: <CAFTL4hyOMSb2LW+HX1LG+KJCLzazKFmp+nHtEW8CnxG4MX_bsQ@mail.gmail.com>
Subject: Re: RCU idle CPU detection is broken in linux-next
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/25 Sasha Levin <levinsasha928@gmail.com>:
> On 09/25/2012 01:06 AM, Frederic Weisbecker wrote:
>> 2012/9/25 Sasha Levin <levinsasha928@gmail.com>:
>>> On 09/25/2012 12:47 AM, Sasha Levin wrote:
>>>>  - While I no longer see the warnings I've originally noticed, if I run with Paul's last debug patch I see the following warning:
>>>
>>> Correction: Original warnings are still there, they just got buried in the huge spew that was caused by additional debug warnings
>>> so I've missed them initially.
>>
>> Are they the same? Could you send me your dmesg?
>>
>> Thanks.
>>
>
> Log is attached, you can go directly to 168.703017 when the warnings begin.

Thanks!

So here is the first relevant warning:

[  168.703017] ------------[ cut here ]------------
[  168.708117] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common+0x4a/0x3a0()
[  168.710034] Pid: 7871, comm: trinity-child65 Tainted: G        W
3.6.0-rc6-next-20120924-sasha-00030-g71f256c #5
[  168.710034] Call Trace:
[  168.710034]  <IRQ>  [<ffffffff811c737a>] ? rcu_eqs_exit_common+0x4a/0x3a0
[  168.710034]  [<ffffffff811078b6>] warn_slowpath_common+0x86/0xb0
[  168.710034]  [<ffffffff811079a5>] warn_slowpath_null+0x15/0x20
[  168.710034]  [<ffffffff811c737a>] rcu_eqs_exit_common+0x4a/0x3a0
[  168.710034]  [<ffffffff811c79cc>] rcu_eqs_exit+0x9c/0xb0
[  168.710034]  [<ffffffff811c7a4c>] rcu_user_exit+0x6c/0xd0
[  168.710034]  [<ffffffff8106eb1f>] do_general_protection+0x1f/0x170
[  168.710034]  [<ffffffff83a0e624>] ? restore_args+0x30/0x30
[  168.710034]  [<ffffffff83a0e875>] general_protection+0x25/0x30
[  168.710034]  [<ffffffff810a3f06>] ? native_read_msr_safe+0x6/0x20
[  168.710034]  [<ffffffff81a0b34b>] __rdmsr_safe_on_cpu+0x2b/0x50
[  168.710034]  [<ffffffff819ec971>] ? list_del+0x11/0x40
[  168.710034]  [<ffffffff811886dc>]
generic_smp_call_function_single_interrupt+0xec/0x120
[  168.710034]  [<ffffffff81151147>] ? account_system_vtime+0xd7/0x140
[  168.710034]  [<ffffffff81096f72>]
smp_call_function_single_interrupt+0x22/0x40
[  168.710034]  [<ffffffff83a0fe2f>] call_function_single_interrupt+0x6f/0x80
[  168.710034]  <EOI>  [<ffffffff83a0e5f4>] ? retint_restore_args+0x13/0x13
[  168.710034]  [<ffffffff811c7285>] ? rcu_user_enter+0x105/0x110
[  168.710034]  [<ffffffff8107e06d>] syscall_trace_leave+0xfd/0x150
[  168.710034]  [<ffffffff83a0f1ef>] int_check_syscall_exit_work+0x34/0x3d
[  168.710034] ---[ end trace fd408dd21b70b87c ]---

This is an exception inside an interrupt, and the interrupt
interrupted RCU user mode.
And we have that nesting:

rcu_irq_enter(); <--- irq entry
rcu_user_exit(); <--- exception entry

And rcu_eqs_exit() doesn't handle that very well...
