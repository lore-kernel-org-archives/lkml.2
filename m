Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab2FDKSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:18:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33523 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab2FDKSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:18:49 -0400
Date: Mon, 4 Jun 2012 05:18:47 -0500
From: Robin Holt <holt@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: 2048 CPU system panic while sitting idle.
Message-ID: <20120604101847.GB4948@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a 1024 core / 2048 thread system which had been running aim7 more
than an hour before sitting idle.

###30286.149797 (28156.419861)| BUG: unable to handle kernel NULL pointer dereference at 000000000000008d
   30286.169399 (    0.019602)| IP: [<ffffffff8105f071>] load_balance+0xb0/0xfa2
   30286.169515 (    0.000116)| PGD 0
   30286.169547 (    0.000032)| Oops: 0002 [#1] SMP
   30286.169604 (    0.000057)| xpc : all partitions have deactivated
   30286.179717 (    0.010113)| CPU 1246
   30286.179763 (    0.000046)| Modules linked in:
   30286.179812 (    0.000049)|
   30286.179830 (    0.000018)| Pid: 0, comm: swapper/1246 Not tainted 3.4.0-holt-09547-gfb21aff-dirty #26 Intel Corp. Stoutland Platform
   30286.189405 (    0.009575)| RIP: 0010:[<ffffffff8105f071>]  [<ffffffff8105f071>] load_balance+0xb0/0xfa2
   30286.199995 (    0.010590)| RSP: 0018:ffff8b5ffedc3c10  EFLAGS: 00010206
   30286.200113 (    0.000118)| RAX: 00000000000004de RBX: ffff8b5ff8bce400 RCX: 0000000000000012
   30286.200260 (    0.000147)| RDX: ffff8b5ffedd1480 RSI: ffffffff81a7fe7e RDI: ffff88207daabcee
   30286.209437 (    0.009177)| RBP: ffff8b5ffedc3e50 R08: ffff8b5ffedc3e84 R09: ffff8b5ffedc3e38
   30286.219981 (    0.010544)| R10: ffff88203f12be58 R11: 0000000000000010 R12: 0000000000000000
   30286.220134 (    0.000153)| R13: 000000010088ccc1 R14: 0000000000000000 R15: ffff8b5ff8bce400
   30286.229418 (    0.009284)| FS:  0000000000000000(0000) GS:ffff8b5ffedc0000(0000) knlGS:0000000000000000
   30286.239960 (    0.010542)| CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
   30286.249945 (    0.009985)| CR2: 000000000000008d CR3: 0000000001a0b000 CR4: 00000000000007e0
   30286.250090 (    0.000145)| DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   30286.259423 (    0.009333)| DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
   30286.259562 (    0.000139)| Process swapper/1246 (pid: 0, threadinfo ffff88203f12a000, task ffff88203f128280)
   30286.270024 (    0.010462)| Stack:
   30286.270176 (    0.000152)|  ffff8b5ffedc3c20 0000000000011480 0000000000011480 0000000000011480
   30286.270335 (    0.000159)|  0000000000011478 fffffffffffffff8 ffff8b5ffedc3c40 ffff8b5ffedc3c40
   30286.309938 (    0.039603)|  ffff8b5ffedc3c70 ffffffff81008f64 00000000000004de ffff8b5ffedd1e80
   30286.310090 (    0.000152)| Call Trace:
   30286.310128 (    0.000038)|  <IRQ>
   30286.310157 (    0.000029)|  [<ffffffff81008f64>] ? native_sched_clock+0x40/0x8b
   30286.310262 (    0.000105)|  [<ffffffff81008fc6>] ? sched_clock+0x17/0x1b
   30286.310354 (    0.000092)|  [<ffffffff8105ecea>] ? enqueue_task_fair+0x2a8/0x3f8
   30286.310461 (    0.000107)|  [<ffffffff8105bad0>] ? wake_up_process+0x10/0x12
   30286.310560 (    0.000099)|  [<ffffffff81008fc6>] ? sched_clock+0x17/0x1b
   30286.319949 (    0.009389)|  [<ffffffff81060049>] rebalance_domains+0xe6/0x156
   30286.330017 (    0.010068)|  [<ffffffff810603e3>] run_rebalance_domains+0x47/0x164
   30286.330184 (    0.000167)|  [<ffffffff8103cf84>] __do_softirq+0x9a/0x147
   30286.330282 (    0.000098)|  [<ffffffff81473a4c>] call_softirq+0x1c/0x30
   30286.339961 (    0.009679)|  [<ffffffff81004489>] do_softirq+0x61/0xbf
   30286.340132 (    0.000171)|  [<ffffffff8103ccd4>] irq_exit+0x43/0xb0
   30286.349978 (    0.009846)|  [<ffffffff8101da3a>] smp_apic_timer_interrupt+0x86/0x94
   30286.350177 (    0.000199)|  [<ffffffff814730fa>] apic_timer_interrupt+0x6a/0x70
   30286.360010 (    0.009833)|  <EOI>
   30286.360093 (    0.000083)|  [<ffffffff8105c604>] ? sched_clock_cpu+0xd3/0xde
   

Disassembly of section .text:

00000000000026f1 <load_balance>:
load_balance():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/kernel/sched/fair.c:4216
    26f1:       55                      push   %rbp
...
load_balance():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/kernel/sched/fair.c:4229
    277b:       89 8d 68 ff ff ff       mov    %ecx,-0x98(%rbp)
bitmap_copy():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/include/linux/bitmap.h:186
    2781:       48 63 0d 00 00 00 00    movslq 0x0(%rip),%rcx        # 2788 <load_balance+0x97>
load_balance():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/kernel/sched/fair.c:4229
    2788:       89 85 58 ff ff ff       mov    %eax,-0xa8(%rbp)
    278e:       48 89 95 60 ff ff ff    mov    %rdx,-0xa0(%rbp)
bitmap_copy():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/include/linux/bitmap.h:186
    2795:       48 83 c1 3f             add    $0x3f,%rcx
    2799:       48 c1 f9 03             sar    $0x3,%rcx
    279d:       48 83 e1 f8             and    $0xfffffffffffffff8,%rcx
    27a1:       f3 a4                   rep movsb %ds:(%rsi),%es:(%rdi)
update_sg_lb_stats():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/kernel/sched/fair.c:3642
    27a3:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
load_balance():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/kernel/sched/fair.c:4233
    27aa:       8b 85 4c fe ff ff       mov    -0x1b4(%rbp),%eax
    27b0:       41 ff 44 87 70          incl   0x70(%r15,%rax,4)
update_sg_lb_stats():
/data/lwork/gulag1b/holt/nate-test/uv/linux-2.6/linux/kernel/sched/fair.c:3642
    27b5:       48 89 bd d8 fd ff ff    mov    %rdi,-0x228(%rbp)
target_load():


fair.c:
4213 static int load_balance(int this_cpu, struct rq *this_rq,
4214                         struct sched_domain *sd, enum cpu_idle_type idle,
4215                         int *balance)
4216 {
4217         int ld_moved, active_balance = 0;
4218         struct sched_group *group;
4219         struct rq *busiest;
4220         unsigned long flags;
4221         struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
4222 
4223         struct lb_env env = {
4224                 .sd             = sd,
4225                 .dst_cpu        = this_cpu,
4226                 .dst_rq         = this_rq,
4227                 .idle           = idle,
4228                 .loop_break     = sched_nr_migrate_break,
4229         };
4230 
4231         cpumask_copy(cpus, cpu_active_mask);
4232 
4233         schedstat_inc(sd, lb_count[idle]);


I am just rushing out for the day and wanted to report this problem
before going.

My quick glance at it did not make any sense so I really have nothing
more to contribute at the time.

Thanks,
Robin
