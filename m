Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1GZGAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:00:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:33398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1GZGAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,267,1309762800"; 
   d="scan'208";a="31447772"
Message-ID: <4E2E57FF.7030206@linux.intel.com>
Date: Mon, 25 Jul 2011 23:00:31 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
References: <alpine.LFD.2.02.1107241223560.2702@ionos> <4E2C2ED6.4040904@gmail.com> <alpine.LFD.2.02.1107241807390.3136@ionos> <4E2DEC1A.5070109@linux.intel.com>
In-Reply-To: <4E2DEC1A.5070109@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/25/2011 03:20 PM, Darren Hart wrote:
> 
> 
> On 07/24/2011 09:12 AM, Thomas Gleixner wrote:
>> On Sun, 24 Jul 2011, Maarten Lankhorst wrote:
> 
> ...
> 
>>> Also not sure where this one came from:
>>> [   37.456688] BUG: spinlock bad magic on CPU#3, threaded-ml/1619
>>> [   37.456690]  lock: ffff8801fdc74d50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>>> [   37.456692] Pid: 1619, comm: threaded-ml Tainted: G         C  3.0.0-rt3-patser+ #39
>>> [   37.456693] Call Trace:
>>> [   37.456697]  [<ffffffff81607a78>] spin_bug+0xa0/0xa8
>>> [   37.456699]  [<ffffffff8132b412>] do_raw_spin_lock+0xa2/0x170
>>> [   37.456702]  [<ffffffff8104a201>] ? get_parent_ip+0x11/0x50
>>> [   37.456704]  [<ffffffff8160d783>] _raw_spin_lock+0x23/0x30
>>> [   37.456706]  [<ffffffff810931ce>] rt_mutex_start_proxy_lock+0x2e/0xd0
>>> [   37.456708]  [<ffffffff8109093a>] futex_requeue+0x47a/0x850
>>> [   37.456710]  [<ffffffff8109138e>] do_futex+0xae/0xb00
>>> [   37.456712]  [<ffffffff81157dcd>] ? fget_light+0x6d/0x110
>>> [   37.456714]  [<ffffffff810b77b7>] ? audit_syscall_entry+0x2e7/0x310
>>> [   37.456715]  [<ffffffff814c9375>] ? sys_recvmsg+0x75/0x90
>>> [   37.456717]  [<ffffffff810923e6>] compat_sys_futex+0xf6/0x190
>>> [   37.456719]  [<ffffffff8100e864>] ? syscall_trace_enter+0x184/0x210
>>> [   37.456721]  [<ffffffff816158b3>] ia32_do_call+0x13/0x13
>>
>> Urrgh, that's not a good one. Darren, can you please have a look at that?
>>
> 
> Will do.
> 
> Maarten, what are you running when you hit this?
> rt_mutex_start_proxy_lock() is only called by the requeue_pi code and
> there is no libc support for that yet, so I'm surprised to see that in
> the stack trace (unless you're running my futextest suite).

I've run a couple iterations of functional/run.sh from futextest which
exercises the requeue_pi code with no errors. I also wrote a new test to
improperly use the requeue_pi path, and the kernel properly detects the
abuse and kicks the user back with -EINVAL.

Could you try running futextest on your system to see if you can
reproduce the above? Specifically the functional/run.sh script (no need
to run the performance bits).

http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
