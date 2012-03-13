Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2CMOeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:34:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35852 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab2CMOeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:34:08 -0400
Date: Tue, 13 Mar 2012 07:33:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: RCU stalls in linux-next
Message-ID: <20120313143327.GA2349@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120313134822.GA5158@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313134822.GA5158@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031314-6148-0000-0000-00000436C21A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 04:48:23PM +0300, Dan Carpenter wrote:
> I've been getting RCU hangs in linux-next.
> 
> Also sometimes, when I'm building my smatch database after a kernel
> compile, my system hangs.  I'm not certain if the two things are related.
> 
> regards,
> dan carpenter
> 
> Mar 13 14:32:11 elgon kernel: [265405.604199] Pid: 665, comm: kswapd0 Not tainted 3.3.0-rc6-next-20120308+ #141
> Mar 13 14:32:11 elgon kernel: [265405.604200] Call Trace:
> Mar 13 14:32:11 elgon kernel: [265405.604201]  <IRQ>  [<ffffffff810ab9da>] __rcu_pending+0x19a/0x4d0
> Mar 13 14:32:11 elgon kernel: [265405.604208]  [<ffffffff810ac1d0>] rcu_check_callbacks+0xb0/0x1a0
> Mar 13 14:32:11 elgon kernel: [265405.604210]  [<ffffffff81044293>] update_process_times+0x43/0x80
> Mar 13 14:32:11 elgon kernel: [265405.604220]  [<ffffffff8107eb0f>] tick_sched_timer+0x5f/0xb0
> Mar 13 14:32:11 elgon kernel: [265405.604230]  [<ffffffff81058f68>] __run_hrtimer+0x78/0x1d0
> Mar 13 14:32:11 elgon kernel: [265405.604232]  [<ffffffff8107eab0>] ? tick_nohz_handler+0xf0/0xf0
> Mar 13 14:32:11 elgon kernel: [265405.604234]  [<ffffffff8103ba91>] ? __do_softirq+0xf1/0x210
> Mar 13 14:32:11 elgon kernel: [265405.604235]  [<ffffffff81059843>] hrtimer_interrupt+0xe3/0x200
> Mar 13 14:32:11 elgon kernel: [265405.604238]  [<ffffffff8170c74c>] ? call_softirq+0x1c/0x30
> Mar 13 14:32:11 elgon kernel: [265405.604241]  [<ffffffff8101f7c4>] smp_apic_timer_interrupt+0x64/0xa0
> Mar 13 14:32:11 elgon kernel: [265405.604243]  [<ffffffff8170be07>] apic_timer_interrupt+0x67/0x70
> Mar 13 14:32:11 elgon kernel: [265405.604244]  <EOI>  [<ffffffff810d87ac>] ? zone_watermark_ok_safe+0x8c/0x170

Looks like kswapd is having a bad hair day, CCing linux-mm to see if they
can help.

							Thanx, Paul

> Mar 13 14:32:11 elgon kernel: [265405.604248]  [<ffffffff810e73c8>] balance_pgdat+0x1a8/0x680
> Mar 13 14:32:11 elgon kernel: [265405.604250]  [<ffffffff810e7a08>] kswapd+0x168/0x3f0
> Mar 13 14:32:11 elgon kernel: [265405.604253]  [<ffffffff81702916>] ? __schedule+0x3a6/0x750
> Mar 13 14:32:11 elgon kernel: [265405.604255]  [<ffffffff810556b0>] ? add_wait_queue+0x60/0x60
> Mar 13 14:32:11 elgon kernel: [265405.604256]  [<ffffffff810e78a0>] ? balance_pgdat+0x680/0x680
> Mar 13 14:32:11 elgon kernel: [265405.604258]  [<ffffffff81054c7e>] kthread+0x8e/0xa0
> Mar 13 14:32:11 elgon kernel: [265405.604260]  [<ffffffff8170c654>] kernel_thread_helper+0x4/0x10
> Mar 13 14:32:11 elgon kernel: [265405.604262]  [<ffffffff81054bf0>] ? kthread_freezable_should_stop+0x70/0x70
> Mar 13 14:32:11 elgon kernel: [265405.604264]  [<ffffffff8170c650>] ? gs_change+0xb/0xb
> Mar 13 14:35:11 elgon kernel: [265585.490971] Pid: 665, comm: kswapd0 Not tainted 3.3.0-rc6-next-20120308+ #141
> Mar 13 14:35:11 elgon kernel: [265585.490972] Call Trace:
> Mar 13 14:35:11 elgon kernel: [265585.490973]  <IRQ>  [<ffffffff810ab9da>] __rcu_pending+0x19a/0x4d0
> Mar 13 14:35:11 elgon kernel: [265585.490987]  [<ffffffff810ac1d0>] rcu_check_callbacks+0xb0/0x1a0
> Mar 13 14:35:11 elgon kernel: [265585.490989]  [<ffffffff81044293>] update_process_times+0x43/0x80
> Mar 13 14:35:11 elgon kernel: [265585.490991]  [<ffffffff8107eb0f>] tick_sched_timer+0x5f/0xb0
> Mar 13 14:35:11 elgon kernel: [265585.490994]  [<ffffffff81058f68>] __run_hrtimer+0x78/0x1d0
> Mar 13 14:35:11 elgon kernel: [265585.490995]  [<ffffffff8107eab0>] ? tick_nohz_handler+0xf0/0xf0
> Mar 13 14:35:11 elgon kernel: [265585.490997]  [<ffffffff8103ba91>] ? __do_softirq+0xf1/0x210
> Mar 13 14:35:11 elgon kernel: [265585.490999]  [<ffffffff81059843>] hrtimer_interrupt+0xe3/0x200
> Mar 13 14:35:11 elgon kernel: [265585.491002]  [<ffffffff8170c74c>] ? call_softirq+0x1c/0x30
> Mar 13 14:35:11 elgon kernel: [265585.491005]  [<ffffffff8101f7c4>] smp_apic_timer_interrupt+0x64/0xa0
> Mar 13 14:35:11 elgon kernel: [265585.491007]  [<ffffffff8170be07>] apic_timer_interrupt+0x67/0x70
> Mar 13 14:35:11 elgon kernel: [265585.491008]  <EOI>  [<ffffffff810d876d>] ? zone_watermark_ok_safe+0x4d/0x170
> Mar 13 14:35:11 elgon kernel: [265585.491012]  [<ffffffff810e73c8>] balance_pgdat+0x1a8/0x680
> Mar 13 14:35:11 elgon kernel: [265585.491014]  [<ffffffff810e7a08>] kswapd+0x168/0x3f0
> Mar 13 14:35:11 elgon kernel: [265585.491017]  [<ffffffff81702916>] ? __schedule+0x3a6/0x750
> Mar 13 14:35:11 elgon kernel: [265585.491019]  [<ffffffff810556b0>] ? add_wait_queue+0x60/0x60
> Mar 13 14:35:11 elgon kernel: [265585.491021]  [<ffffffff810e78a0>] ? balance_pgdat+0x680/0x680
> Mar 13 14:35:11 elgon kernel: [265585.491023]  [<ffffffff81054c7e>] kthread+0x8e/0xa0
> Mar 13 14:35:11 elgon kernel: [265585.491024]  [<ffffffff8170c654>] kernel_thread_helper+0x4/0x10
> Mar 13 14:35:11 elgon kernel: [265585.491026]  [<ffffffff81054bf0>] ? kthread_freezable_should_stop+0x70/0x70
> Mar 13 14:35:11 elgon kernel: [265585.491028]  [<ffffffff8170c650>] ? gs_change+0xb/0xb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

