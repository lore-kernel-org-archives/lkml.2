Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2KJAcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:32:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47360 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2KJAcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:32:09 -0500
Date: Fri, 9 Nov 2012 16:31:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/rcutree.c:1562 rcu_do_batch()
Message-ID: <20121110003153.GJ2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121109042330.GA16556@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109042330.GA16556@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111000-4834-0000-0000-0000004D7FAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 12:23:30PM +0800, Fengguang Wu wrote:
> Paul,
> 
> I got the below warning in stable kernel 3.6.3. linux-next does
> not have this issue. Bisect shows that the first bad commit is
> 
> commit b1420f1c8bfc30ecf6380a31d0f686884834b599
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Thu Mar 1 13:18:08 2012 -0800
> 
>     rcu: Make rcu_barrier() less disruptive
> 
> 
> [   92.252733] do_IRQ: 1.59 No irq handler for vector (irq -1)
> [   92.253257] ------------[ cut here ]------------
> [   92.253675] WARNING: at /c/kernel-tests/src/stable/kernel/rcutree.c:1562 rcu_do_batch+0x17e/0x63b()
> [   92.254474] Hardware name: Bochs
> [   92.254766] Modules linked in:
> [   92.256689] Pid: 9, comm: migration/1 Not tainted 3.6.3 #1306
> [   92.256689] Call Trace:
> [   92.256689]  <IRQ>  [<ffffffff81033dbd>] warn_slowpath_common+0x83/0x9c
> [   92.256689]  [<ffffffff81033df0>] warn_slowpath_null+0x1a/0x1c
> [   92.256689]  [<ffffffff810a70fd>] rcu_do_batch+0x17e/0x63b
> [   92.256689]  [<ffffffff810a6705>] ? rcu_report_qs_rnp+0x28b/0x2d5
> [   92.256689]  [<ffffffff810a769d>] ? rcu_process_callbacks+0xe3/0x236
> [   92.256689]  [<ffffffff810a772c>] rcu_process_callbacks+0x172/0x236
> [   92.256689]  [<ffffffff8103b6cc>] __do_softirq+0xf6/0x231
> [   92.256689]  [<ffffffff8107fe2c>] ? tick_program_event+0x24/0x26
> [   92.256689]  [<ffffffff817d23bc>] call_softirq+0x1c/0x30
> [   92.256689]  [<ffffffff81003f7c>] do_softirq+0x4a/0xa6
> [   92.256689]  [<ffffffff8103ba98>] irq_exit+0x51/0xbc
> [   92.256689]  [<ffffffff817d2a2f>] smp_apic_timer_interrupt+0x8b/0x99
> [   92.256689]  [<ffffffff817d1c2f>] apic_timer_interrupt+0x6f/0x80
> [   92.256689]  <EOI>  [<ffffffff81067440>] ? local_clock+0x1d/0x5a
> [   92.256689]  [<ffffffff8109ea37>] ? stop_machine_cpu_stop+0x104/0x119
> [   92.256689]  [<ffffffff8109e6d5>] cpu_stopper_thread+0xdd/0x17d
> [   92.256689]  [<ffffffff8109e933>] ? queue_stop_cpus_work+0x130/0x130
> [   92.256689]  [<ffffffff817ca044>] ? _raw_spin_unlock_irqrestore+0x47/0x65
> [   92.256689]  [<ffffffff81086613>] ? trace_hardirqs_on_caller+0x125/0x181
> [   92.256689]  [<ffffffff8108667c>] ? trace_hardirqs_on+0xd/0xf
> [   92.256689]  [<ffffffff8109e5f8>] ? cpu_stop_signal_done+0x2c/0x2c
> [   92.256689]  [<ffffffff81055e74>] kthread+0x9a/0xa2
> [   92.256689]  [<ffffffff817d22c4>] kernel_thread_helper+0x4/0x10
> [   92.256689]  [<ffffffff817ca4b0>] ? retint_restore_args+0x13/0x13
> [   92.256689]  [<ffffffff81055dda>] ? __init_kthread_worker+0x5a/0x5a
> [   92.317029]  [<ffffffff817d22c0>] ? gs_change+0x13/0x13
> 
> Thanks,
> Fengguang

Hello, Fengguang,

You need commit #bfa00b4c, which prevents offline CPUs from getting
into rcu_do_batch.

							Thanx, Paul

