Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1G2GFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:05:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42021 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754520Ab1G2GFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:05:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+fKRspEemfzR05Y9voTMFlG3qnEYkX53WmJW+m7w
	0ei6goNuLiRMHP
Subject: Re: [ANNOUNCE] 3.0-rt6
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.02.1107282213000.31246@ionos>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 08:05:27 +0200
Message-ID: <1311919527.5500.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, I took rt6 for a very brief ride on a 64 core DL980 this morning.
Didn't have time to play with it, was just taking a peek at rt future,
so this is only an fyi (vs proper bug report with circles and arrows),
and probably not a very useful one.

After boot (bloated distro config), ksoftirqd was eating ~20% on all
CPUs, and the guy below was at 100%.  While watching, box started
spewing this endlessly, with the same trace shown for all CPUs.

I'll poke it with sharp sticks when I have time (dream on) to tinker,
but the bug will likely have died of old age before then.

I booted the box with intel_idle.max_cstate=1 fwtw. 
 
[  338.747588] NMI backtrace for cpu 63
[  338.747590] CPU 63 
[  338.747591] Modules linked in: autofs4 edd nfs lockd fscache auth_rpcgss nfs_acl sunrpc af_packet mperf loop dm_mod sr_mod iTCO_wdt shpchp joydev serio_raw cdrom i7core_edac iTCO_vendor_support bnx2 pci_hotplug hpwdt pcspkr hpilo sg edac_core netxen_nic container acpi_power_meter button usbhid radeon uhci_hcd ttm drm_kms_helper drm ehci_hcd usbcore i2c_algo_bit fan thermal processor thermal_sys ata_generic hpsa
[  338.747608] 
[  338.747610] Pid: 0, comm: kworker/0:1 Not tainted 3.0.0-rt6 #3 Hewlett-Packard ProLiant DL980 G7
[  338.747613] RIP: 0010:[<ffffffff8147f596>]  [<ffffffff8147f596>] _raw_spin_lock_irqsave+0x36/0x40
[  338.747619] RSP: 0018:ffff88027f5e3ea0  EFLAGS: 00000093
[  338.747620] RAX: 000000000000ca7f RBX: ffff880274ccc080 RCX: 000000000000ca68
[  338.747622] RDX: 0000000000000013 RSI: 000000000000003f RDI: ffff880274ccc0f8
[  338.747624] RBP: 000000000000003f R08: 0000000000000001 R09: 00000000000017d6
[  338.747626] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[  338.747628] R13: ffff880274ccc0f8 R14: 0000000000000001 R15: 000000000000043f
[  338.747630] FS:  0000000000000000(0000) GS:ffff88027f5e0000(0000) knlGS:0000000000000000
[  338.747632] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  338.747633] CR2: 00000000006c2000 CR3: 0000000001a06000 CR4: 00000000000006e0
[  338.747635] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  338.747636] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  338.747638] Process kworker/0:1 (pid: 0, threadinfo ffff880274ca8000, task ffff880274c91790)
[  338.747639] Stack:
[  338.747640]  ffffffff810b12f6 ffff88027f5e3f48 ffff880274c57100 ffff88027f5ef540
[  338.747644]  ffff88027f5ef540 ffff88027f5ef540 0000000000000062 0000000000000000
[  338.747649]  ffffffff8103f4bc ffffffff81008e15 ffff88027f5ef540 ffff880274c57638
[  338.747653] Call Trace:
[  338.747654]  <IRQ> 
[  338.747658]  [<ffffffff810b12f6>] ? cpupri_set+0x76/0x150
[  338.747662]  [<ffffffff8103f4bc>] ? enqueue_task_rt+0x2fc/0x320
[  338.747665]  [<ffffffff81008e15>] ? sched_clock+0x5/0x10
[  338.747668]  [<ffffffff8103bf41>] ? activate_task+0x21/0x30
[  338.747672]  [<ffffffff81044ef4>] ? try_to_wake_up+0x294/0x330
[  338.747675]  [<ffffffff810524e5>] ? irq_exit+0x55/0x60
[  338.747678]  [<ffffffff8101d228>] ? smp_apic_timer_interrupt+0x68/0xa0
[  338.747681]  [<ffffffff81485873>] ? apic_timer_interrupt+0x13/0x20
[  338.747682]  <EOI> 
[  338.747685]  [<ffffffff8106dc3e>] ? __hrtimer_start_range_ns+0x13e/0x2b0
[  338.747689]  [<ffffffff81269051>] ? intel_idle+0xc1/0x120
[  338.747692]  [<ffffffff81269030>] ? intel_idle+0xa0/0x120
[  338.747695]  [<ffffffff81357961>] ? cpuidle_idle_call+0x81/0x100
[  338.747699]  [<ffffffff810011cf>] ? cpu_idle+0x4f/0x80
[  338.747702]  [<ffffffff81478877>] ? start_secondary+0x22c/0x231
[  338.747704] Code: 66 66 90 66 66 90 65 48 8b 04 25 c8 95 00 00 83 80 44 e0 ff ff 01 b8 00 00 01 00 f0 0f c1 07 0f b7 c8 c1 e8 10 39 c1 74 07 f3 90 <0f> b7 0f eb f5 48 89 d0 c3 90 fa 66 66 90 66 66 90 65 48 8b 04 
[  338.747717] Call Trace:
[  338.747718]  <IRQ>  [<ffffffff810b12f6>] ? cpupri_set+0x76/0x150
[  338.747723]  [<ffffffff8103f4bc>] ? enqueue_task_rt+0x2fc/0x320
[  338.747726]  [<ffffffff81008e15>] ? sched_clock+0x5/0x10
[  338.747729]  [<ffffffff8103bf41>] ? activate_task+0x21/0x30
[  338.747732]  [<ffffffff81044ef4>] ? try_to_wake_up+0x294/0x330
[  338.747735]  [<ffffffff810524e5>] ? irq_exit+0x55/0x60
[  338.747737]  [<ffffffff8101d228>] ? smp_apic_timer_interrupt+0x68/0xa0
[  338.747740]  [<ffffffff81485873>] ? apic_timer_interrupt+0x13/0x20
[  338.747742]  <EOI>  [<ffffffff8106dc3e>] ? __hrtimer_start_range_ns+0x13e/0x2b0
[  338.747747]  [<ffffffff81269051>] ? intel_idle+0xc1/0x120
[  338.747750]  [<ffffffff81269030>] ? intel_idle+0xa0/0x120
[  338.747753]  [<ffffffff81357961>] ? cpuidle_idle_call+0x81/0x100
[  338.747756]  [<ffffffff810011cf>] ? cpu_idle+0x4f/0x80
[  338.747759]  [<ffffffff81478877>] ? start_secondary+0x22c/0x231


