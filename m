Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0H3Ovi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:51:38 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:39079 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754962Ab0H3Ovg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:51:36 -0400
Date: Mon, 30 Aug 2010 10:51:24 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1706089082.1537331283179884183.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <331762715.1536681283179646594.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "CAI Qian" <caiqian@redhat.com> wrote:

> ----- "Tejun Heo" <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > On 08/30/2010 04:02 PM, CAI Qian wrote:
> > >> Hmm, odd.  So, here's the said debug patch.  It will
> periodically
> > >> check all works and report if any work is being delayed for too
> > long.
> > >> If the max wait goes over 30secs, it will dump all task states
> and
> > >> disable itself.  Can you please apply the patch on top of rc2 +
> > >> wq#for-linus and report the output?  It should tell us who's
> stuck
> > >> where.
> > >
> > > Nothing new was printed after around 10 minutes.
> > 
> > Eh... that's interesting.  That means no work is stalled on
> > workqueues, so it at least is not a workqueue stall.  Can you
> please
> > try the following then?  Or if sysrq wasn't working because your
> ...
> SMP alternatives: switching to UP code
> ACPI: Core revision 20100702
> ftrace: converting mcount calls to 0f 1f 44 00 00
> ftrace: allocating 18488 entries in 73 pages
> XXX show_state_timer registered
> Not enabling x2apic, Intr-remapping init failed.
> Setting APIC routing to physical flat
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz stepping 06
> Brought up 1 CPUs
> Total of 1 processors activated (3990.10 BogoMIPS).
> devtmpfs: initialized
> regulator: core version 0.5
> NET: Registered protocol family 16
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable
> it
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
> 0x80000000-0x8fffffff] (base 0x80000000)
> PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
Hit return too quickly, and here were something new,

  task                        PC stack   pid father
swapper       R  running task        0     1      0 0x00000000
 ffff88046dc1bcf0 0000000000000046 ffffffff81796812 ffffffff81a90700
 ffffffff81c21420 0000000000015d00 ffff88106e5dc040 0000000000015d00
 ffff88106e5dc5d0 ffff88046dc1bfd8 ffff88106e5dc5d8 ffff88046dc1bfd8
Call Trace:
 [<ffffffff8105757a>] __cond_resched+0x2a/0x40
 [<ffffffff8149c8a0>] _cond_resched+0x30/0x40
 [<ffffffff81136cf0>] kmem_cache_alloc_node_notrace+0xa0/0x120
 [<ffffffff810f6bd0>] ? mempool_alloc_slab+0x0/0x20
 [<ffffffff810f6fb1>] mempool_create_node+0x41/0x1a0
 [<ffffffff810f6bb0>] ? mempool_free_slab+0x0/0x20
 [<ffffffff810f7124>] mempool_create+0x14/0x20
 [<ffffffff81176d53>] bioset_create+0x1a3/0x2f0
 [<ffffffff81c685a8>] ? init_bio+0x0/0x141
 [<ffffffff81c68693>] init_bio+0xeb/0x141
 [<ffffffff81c64ff4>] ? default_bdi_init+0x9b/0xa2
 [<ffffffff81002053>] do_one_initcall+0x43/0x190
 [<ffffffff81c418ab>] kernel_init+0x2a0/0x330
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c4160b>] ? kernel_init+0x0/0x330
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
kthreadd      S 0000000000000000     0     2      0 0x00000000
 ffff88046dc1fe90 0000000000000046 ffff88046dc1fe90 ffffffff81013596
 0000000000000000 0000000000015d00 ffff88046dc1d4c0 0000000000015d00
 ffff88046dc1da50 ffff88046dc1ffd8 ffff88046dc1da58 ffff88046dc1ffd8
Call Trace:
 [<ffffffff81013596>] ? kernel_thread+0x76/0x80
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
 [<ffffffff8107fe85>] kthreadd+0x275/0x280
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fc10>] ? kthreadd+0x0/0x280
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
ksoftirqd/0   S 0000000000000000     0     3      2 0x00000000
 ffff88046dc43ea0 0000000000000046 ffffffff81a5a4a0 ffff880002415d00
 ffffffff81a5a4a0 0000000000015d00 ffff88046dc1ca80 0000000000015d00
 ffff88046dc1d010 ffff88046dc43fd8 ffff88046dc1d018 ffff88046dc43fd8
Call Trace:
 [<ffffffff81065c35>] run_ksoftirqd+0xe5/0x140
 [<ffffffff81065b50>] ? run_ksoftirqd+0x0/0x140
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
kworker/0:0   S 0000000000000000     0     4      2 0x00000000
 ffff88046dc45e50 0000000000000046 ffff88046dc45db0 ffffffff8104ac80
 ffff88046dc45e00 0000000000015d00 ffff88046dc1c040 0000000000015d00
 ffff88046dc1c5d0 ffff88046dc45fd8 ffff88046dc1c5d8 ffff88046dc45fd8
Call Trace:
 [<ffffffff8104ac80>] ? __dequeue_entity+0x30/0x50
 [<ffffffff8107b949>] worker_thread+0x259/0x3c0
 [<ffffffff8107b6f0>] ? worker_thread+0x0/0x3c0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
kworker/u:0   S 0000000000000000     0     5      2 0x00000000
 ffff88046dc49e50 0000000000000046 ffff88046dc49db0 ffffffff8104ac80
 ffff88046dc49e00 0000000000015d00 ffff88046dc47500 0000000000015d00
 ffff88046dc47a90 ffff88046dc49fd8 ffff88046dc47a98 ffff88046dc49fd8
Call Trace:
 [<ffffffff8104ac80>] ? __dequeue_entity+0x30/0x50
 [<ffffffff8107b949>] worker_thread+0x259/0x3c0
 [<ffffffff8107b6f0>] ? worker_thread+0x0/0x3c0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
migration/0   S 0000000000000000     0     6      2 0x00000000
 ffff88046dc4dde0 0000000000000046 ffff88046dc4dd60 ffffffff8104a7e8
 ffff88046dc4dd70 0000000000015d00 ffff88046dc46ac0 0000000000015d00
 ffff88046dc47050 ffff88046dc4dfd8 ffff88046dc47058 ffff88046dc4dfd8
Call Trace:
 [<ffffffff8104a7e8>] ? update_curr+0xf8/0x1e0
 [<ffffffff81009630>] ? __switch_to+0xd0/0x320
 [<ffffffff810b1ec0>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b1ffd>] cpu_stopper_thread+0x13d/0x1d0
 [<ffffffff810b1ec0>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff810b1ec0>] ? cpu_stopper_thread+0x0/0x1d0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
cpuset        S 0000000000000000     0     7      2 0x00000000
 ffff88046dc6fe60 0000000000000046 ffff88046dc460b8 ffff88046dc460b8
 0000000000000000 0000000000015d00 ffff88046dc46080 0000000000015d00
 ffff88046dc46610 ffff88046dc6ffd8 ffff88046dc46618 ffff88046dc6ffd8
Call Trace:
 [<ffffffff81050e39>] ? set_user_nice+0xc9/0x130
 [<ffffffff81079789>] rescuer_thread+0x1a9/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
khelper       S 0000000000000000     0     8      2 0x00000000
 ffff88046dc73e60 0000000000000046 ffff88046dc71578 ffff88046dc71578
 0000000000000000 0000000000015d00 ffff88046dc71540 0000000000015d00
 ffff88046dc71ad0 ffff88046dc73fd8 ffff88046dc71ad8 ffff88046dc73fd8
Call Trace:
 [<ffffffff81050e39>] ? set_user_nice+0xc9/0x130
 [<ffffffff81079789>] rescuer_thread+0x1a9/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
netns         S 0000000000000000     0     9      2 0x00000000
 ffff88046dca7e60 0000000000000046 ffff88046dc70b38 ffff88046dc70b38
 0000000000000000 0000000000015d00 ffff88046dc70b00 0000000000015d00
 ffff88046dc71090 ffff88046dca7fd8 ffff88046dc71098 ffff88046dca7fd8
Call Trace:
 [<ffffffff81050e39>] ? set_user_nice+0xc9/0x130
 [<ffffffff81079789>] rescuer_thread+0x1a9/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
pm            S 0000000000000000     0    10      2 0x00000000
 ffff88046dca9e60 0000000000000046 ffff88046dc700f8 ffff88046dc700f8
 0000000000000000 0000000000015d00 ffff88046dc700c0 0000000000015d00
 ffff88046dc70650 ffff88046dca9fd8 ffff88046dc70658 ffff88046dca9fd8
Call Trace:
 [<ffffffff81050e39>] ? set_user_nice+0xc9/0x130
 [<ffffffff81079789>] rescuer_thread+0x1a9/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
sync_supers   R  running task        0    11      2 0x00000000
 ffff88046dcebeb0 0000000000000046 ffffffff81a5a4a0 0000000000000000
 ffff88106e5dc040 0000000000015d00 ffff88046dce9580 0000000000015d00
 ffff88046dce9b10 ffff88046dcebfd8 ffff88046dce9b18 ffff88046dcebfd8
Call Trace:
 [<ffffffff8110e780>] ? bdi_sync_supers+0x0/0x60
 [<ffffffff8110e7c4>] bdi_sync_supers+0x44/0x60
 [<ffffffff8110e780>] ? bdi_sync_supers+0x0/0x60
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
bdi-default   S 0000000000000000     0    12      2 0x00000000
 ffff88046dcefd40 0000000000000046 0000000000000000 0000000000000000
 0000000000000000 0000000000015d00 ffff88046dce8b40 0000000000015d00
 ffff88046dce90d0 ffff88046dceffd8 ffff88046dce90d8 ffff88046dceffd8
Call Trace:
 [<ffffffff8149cd1c>] schedule_timeout+0x18c/0x2e0
 [<ffffffff8106e260>] ? process_timeout+0x0/0x10
 [<ffffffff8110f46d>] bdi_forker_thread+0x22d/0x500
 [<ffffffff8110f240>] ? bdi_forker_thread+0x0/0x500
 [<ffffffff8110f240>] ? bdi_forker_thread+0x0/0x500
 [<ffffffff8107fc06>] kthread+0x96/0xa0
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
kintegrityd   R  running task        0    13      2 0x00000008
 ffffffffffffff10 ffffffff81078e25 0000000000000010 0000000000000206
 ffff88046dcf1e40 0000000000000018 ffff88046dc9a440 ffff88046dc9a440
 ffff88088e231f00 ffff88088e239300 ffff88046dcf1ee0 ffffffff810796e8
Call Trace:
 [<ffffffff81078e25>] ? worker_maybe_bind_and_lock+0x55/0xf0
 [<ffffffff810796e8>] ? rescuer_thread+0x108/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
 [<ffffffff8107fc06>] ? kthread+0x96/0xa0
 [<ffffffff8100be84>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8107fb70>] ? kthread+0x0/0xa0
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
Sched Debug Version: v0.09, 2.6.36-rc2-wq+ #20
now at 180552.999849 msecs
  .jiffies                                 : 4294847851
  .sysctl_sched_latency                    : 6.000000
  .sysctl_sched_min_granularity            : 2.000000
  .sysctl_sched_wakeup_granularity         : 1.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 15471
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 1995.053 MHz
  .nr_running                    : 3
  .load                          : 90809
  .nr_switches                   : 57
  .nr_load_updates               : 180566
  .nr_uninterruptible            : 0
  .next_balance                  : 4294.668298
  .curr->pid                     : 13
  .clock                         : 181316.279544
  .cpu_load[0]                   : 90809
  .cpu_load[1]                   : 90809
  .cpu_load[2]                   : 90809
  .cpu_load[3]                   : 90809
  .cpu_load[4]                   : 90809
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 59
  .sched_goidle                  : 1
  .avg_idle                      : 1000000
  .ttwu_count                    : 34
  .ttwu_local                    : 34
  .bkl_count                     : 0

cfs_rq[0]:/
  .exec_clock                    : 181045.961245
  .MIN_vruntime                  : 293.512617
  .min_vruntime                  : 296.512617
  .max_vruntime                  : 296.512617
  .spread                        : 3.000000
  .spread0                       : 0.000000
  .nr_running                    : 3
  .load                          : 90809
  .nr_spread_over                : 0
  .shares                        : 0

rt_rq[0]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         swapper     1       296.512617        23   120       296.512617       282.090606         0.046441 /
     sync_supers    11       293.512617         2   120       293.512617         0.002502      5354.887736 /
R    kintegrityd    13      2382.377879         1   100      2382.377879    180846.751167         0.001076 /


> > keyboard wasn't initialized at that point, you can setup serial
> > console and trigger sysrq that way.
> Yes, it was triggered from a serial console.
> > Thanks.
> > 
> > diff --git a/init/main.c b/init/main.c
> > index 94ab488..e156b8f 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -423,11 +423,19 @@ static void __init setup_command_line(char
> > *command_line)
> > 
> >  static __initdata DECLARE_COMPLETION(kthreadd_done);
> > 
> > +static void show_state_timer_fn(unsigned long data)
> > +{
> > +	show_state();
> > +}
> > +static DEFINE_TIMER(show_state_timer, show_state_timer_fn, 0, 0);
> > +
> >  static noinline void __init_refok rest_init(void)
> >  	__releases(kernel_lock)
> >  {
> >  	int pid;
> > 
> > +	printk("XXX show_state_timer registered\n");
> > +	mod_timer(&show_state_timer, jiffies + 180 * HZ);
> >  	rcu_scheduler_starting();
> >  	/*
> >  	 * We need to spawn init first so that it obtains pid 1, however
> > 
> > _______________________________________________
> > kexec mailing list
> > kexec@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kexec
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
