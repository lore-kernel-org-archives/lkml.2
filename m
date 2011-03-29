Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1C2ERl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:17:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56200 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1C2ERk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:17:40 -0400
Date: Mon, 28 Mar 2011 21:17:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: linux-next: Tree for March 25 (Call trace:
 RCU|workqueues|block|VFS|ext4 related?)
Message-ID: <20110329041734.GC2272@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110327213220.GE2322@linux.vnet.ibm.com>
 <AANLkTi=ti+PVC8N-3Bt2fzuHHQz6kuMdUPeb3Gudn7EU@mail.gmail.com>
 <20110328040823.GG2322@linux.vnet.ibm.com>
 <AANLkTinQiDSXLP1o-HfdedYOMKtnsbBrcOfuqw9sFf2X@mail.gmail.com>
 <20110328132436.GL2322@linux.vnet.ibm.com>
 <20110328151143.GA4859@linux.vnet.ibm.com>
 <AANLkTikcX75FaFDcDnYFxMtaE03w7-UbNaeL6h-VeRPo@mail.gmail.com>
 <AANLkTimtKP9ypNzf4ZpLK-CvGnqY+UigJaALHbFzUwg+@mail.gmail.com>
 <20110329001040.GT2287@linux.vnet.ibm.com>
 <AANLkTiktOrExWPkk1zG=Y7wk9-RAAFC61eRMjtv6vgLB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiktOrExWPkk1zG=Y7wk9-RAAFC61eRMjtv6vgLB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 04:42:31AM +0200, Sedat Dilek wrote:
> On Tue, Mar 29, 2011 at 2:10 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Mon, Mar 28, 2011 at 06:46:48PM +0200, Sedat Dilek wrote:
> >> On Mon, Mar 28, 2011 at 6:38 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> >> > On Mon, Mar 28, 2011 at 5:11 PM, Paul E. McKenney
> >> > <paulmck@linux.vnet.ibm.com> wrote:
> >> >> On Mon, Mar 28, 2011 at 06:24:36AM -0700, Paul E. McKenney wrote:
> >> >>> On Mon, Mar 28, 2011 at 02:33:36PM +0200, Sedat Dilek wrote:
> >
> > [ . . . ]
> >
> >> >>> > Ah, before I forget...
> >> >>> >
> >> >>> > I used TREE_RCU (was the default before noticing RCU issue) for
> >> >>> > finding the culprit commit.
> >> >>> > If it is from your POV more helpful to switch to PREEMPT + PREEMPT_RCU
> >> >>> > + RCU_BOOST, please let me *now* know.
> >> >>> > ( Both RCU setups freaks up the system. )
> >> >>>
> >> >>> If TREE_RCU hits problems faster, it is probably best to stay with
> >> >>> TREE_RCU.
> >> >>
> >> >> And of course, one exception to this advice is if TREE_RCU hangs so hard
> >> >> and fast that you don't have time to get any diagnostics.  If this is the
> >> >> case, then TREE_PREEMPT_RCU might be more productive.
> >> >>
> >> >
> >> > OK, that would somehow explain why I could not really get some debug
> >> > infos when doing "my stress-test" and checking via:
> >> >
> >> > $ LC_ALL=C tail -f /sys/kernel/debug/rcu/rcudata
> >> >
> >> > Then I remembered I saw a snippet for a RCU torture script mentionned
> >> > in the kernel-docs (see Documentation/RCU/torture.txt).
> >> >
> >> > 189 The following script may be used to torture RCU:
> >> > 190
> >> > 191         #!/bin/sh
> >> > 192
> >> > 193         modprobe rcutorture
> >> > 194         sleep 100
> >> > 195         rmmod rcutorture
> >> > 196         dmesg | grep torture:
> >> >
> >> > So, I recompiled a new TREE_RC-based kernel and build with
> >> > CONFIG_RCU_TORTURE_TEST=m.
> >> >
> >> > Unfortunately, the rmmod (I prefer modprobe -r -v) hangs... the
> >> > messages in the logs look promising.
> >> >
> >> > - Sedat -
> >> >
> >>
> >> Wrong attachment, correct attached.
> >
> > And one stupid problem located thus far.  I can make a (tortured) case
> > for it resulting in the symptoms you see, but it does seem unlikely to
> > happen repeatedly, as it would require a burst of CPU just at the wrong
> > time.  But who knows?
> >
> > In any case, I am still looking.
> >
> >                                                        Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > Fix stupid typo.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 5477764..f311228 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1618,7 +1618,7 @@ static int rcu_node_kthread(void *arg)
> >                rnp->wakemask = 0;
> >                raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >                rcu_initiate_boost(rnp);
> > -               for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {
> > +               for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
> >                        if ((mask & 0x1) == 0)
> >                                continue;
> >                        preempt_disable();
> >
> 
> I have tested this patch and the previous one you send:
> 
>   (+) OK   rcu-fix/rcu-further-lower-priority-in-rcu_yield.patch
>   (+) OK   rcu-fix/Fix-stupid-typo.patch
> 
> As you suggested I switched to PREEMPT and RCU with rcu-boost:
> 
> # egrep 'RCU|PREEMPT|_HZ' /boot/config-2.6.38-next20110328-5-686-iniza
> # RCU Subsystem
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_TRACE=y
> CONFIG_RCU_FANOUT=32
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_TREE_RCU_TRACE=y
> CONFIG_RCU_BOOST=y
> CONFIG_RCU_BOOST_PRIO=1
> CONFIG_RCU_BOOST_DELAY=500
> CONFIG_NO_HZ=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_DEBUG_PREEMPT=y
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_RCU_TORTURE_TEST=m
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> CONFIG_PREEMPT_TRACER=y
> 
> Unfortunately, the rcu-torture script hangs again on unloading the
> rcu-torture-test module.
> Attached are RCU-related messages in my logs.
> ( I tailed for rcudata changes - no logs. )

OK, still looks like grace periods are being stalled, which would
explain the hang at module-unload time.

On /debug/rcu/rcudata, you need to "cat" it each time.  It just
dumps some internal RCU state once, it is not a running log.
So could you please "cat" it out once the problem has occured?

							Thanx, Paul

> - Sedat -

> Mar 29 04:21:20 tbox kernel: [  132.160108] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4
> Mar 29 04:25:08 tbox kernel: [  360.352072] INFO: task rcu_torture_fak:1750 blocked for more than 120 seconds.
> Mar 29 04:25:08 tbox kernel: [  360.364505] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:25:08 tbox kernel: [  360.377380] rcu_torture_fak D 00000036     0  1750      2 0x00000000
> Mar 29 04:25:08 tbox kernel: [  360.389888]  f5169f08 00000046 10c2d7ee 00000036 c1467400 000036da 00000000 c1467400
> Mar 29 04:25:08 tbox kernel: [  360.405450]  00000000 00000036 f5971ce0 c108395c c129f22b 00000001 f5169ed0 c12a313a
> Mar 29 04:25:08 tbox kernel: [  360.417251]  f6406400 f5169ed8 c1025e91 f5169f54 c129f230 1a975683 00000021 c1467400
> Mar 29 04:25:08 tbox kernel: [  360.429130] Call Trace:
> Mar 29 04:25:08 tbox kernel: [  360.440754]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:08 tbox kernel: [  360.452377]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:25:08 tbox kernel: [  360.463904]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:08 tbox kernel: [  360.475636]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:25:08 tbox kernel: [  360.487202]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:25:08 tbox kernel: [  360.498801]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:25:08 tbox kernel: [  360.510305]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:25:08 tbox kernel: [  360.521903]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:25:08 tbox kernel: [  360.533342]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:08 tbox kernel: [  360.544920]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:08 tbox kernel: [  360.556383]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:25:08 tbox kernel: [  360.567690]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:08 tbox kernel: [  360.578785]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:25:08 tbox kernel: [  360.589832]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:25:08 tbox kernel: [  360.600831]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:25:08 tbox kernel: [  360.611948]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:25:08 tbox kernel: [  360.623083]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:25:08 tbox kernel: [  360.634254]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:25:08 tbox kernel: [  360.645301]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:25:08 tbox kernel: [  360.656373]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:25:08 tbox kernel: [  360.667452]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:25:08 tbox kernel: [  360.678588]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:25:08 tbox kernel: [  360.689635]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:25:08 tbox kernel: [  360.700677] INFO: task rcu_torture_fak:1751 blocked for more than 120 seconds.
> Mar 29 04:25:08 tbox kernel: [  360.711751] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:25:08 tbox kernel: [  360.723000] rcu_torture_fak D 00000021     0  1751      2 0x00000000
> Mar 29 04:25:08 tbox kernel: [  360.734284]  f5807f08 00000046 1b8afabc 00000021 c1467400 21ab5ecd 00000000 c1467400
> Mar 29 04:25:08 tbox kernel: [  360.745904]  00000000 00000021 f5970840 c108395c c129f22b 00000001 f5807ed0 c12a313a
> Mar 29 04:25:08 tbox kernel: [  360.757524]  f6406400 f5807ed8 c1025e91 f5807f54 c129f230 1a975e7e 00000021 c1467400
> Mar 29 04:25:08 tbox kernel: [  360.769310] Call Trace:
> Mar 29 04:25:08 tbox kernel: [  360.780844]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:08 tbox kernel: [  360.792587]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:25:08 tbox kernel: [  360.804259]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:08 tbox kernel: [  360.816103]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:25:08 tbox kernel: [  360.827845]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:25:08 tbox kernel: [  360.839621]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:25:08 tbox kernel: [  360.851319]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:25:08 tbox kernel: [  360.863052]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:25:08 tbox kernel: [  360.874618]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:08 tbox kernel: [  360.886321]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:08 tbox kernel: [  360.897896]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:25:08 tbox kernel: [  360.909449]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:08 tbox kernel: [  360.920917]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:25:08 tbox kernel: [  360.932305]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:25:08 tbox kernel: [  360.943525]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:25:08 tbox kernel: [  360.954839]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  360.966148]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:25:09 tbox kernel: [  360.977617]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:25:09 tbox kernel: [  360.989076]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:25:09 tbox kernel: [  361.000603]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  361.012020]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:25:09 tbox kernel: [  361.023329]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:25:09 tbox kernel: [  361.034680]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:25:09 tbox kernel: [  361.046110] INFO: task rcu_torture_fak:1752 blocked for more than 120 seconds.
> Mar 29 04:25:09 tbox kernel: [  361.057508] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:25:09 tbox kernel: [  361.068706] rcu_torture_fak D 00000021     0  1752      2 0x00000000
> Mar 29 04:25:09 tbox kernel: [  361.079547]  f59aff08 00000046 1c05091a 00000021 c1467400 2144d81f 00000000 c1467400
> Mar 29 04:25:09 tbox kernel: [  361.090601]  00000000 00000021 f5b2cc60 c108395c c129f22b 00000001 f59afed0 c12a313a
> Mar 29 04:25:09 tbox kernel: [  361.101522]  f6406400 f59afed8 c1025e91 f59aff54 c129f230 1a973f63 00000021 c1467400
> Mar 29 04:25:09 tbox kernel: [  361.112488] Call Trace:
> Mar 29 04:25:09 tbox kernel: [  361.123082]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:09 tbox kernel: [  361.133760]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:25:09 tbox kernel: [  361.144275]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.154858]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:25:09 tbox kernel: [  361.165231]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:25:09 tbox kernel: [  361.175636]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:25:09 tbox kernel: [  361.185990]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:25:09 tbox kernel: [  361.196475]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:25:09 tbox kernel: [  361.206819]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.217327]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:09 tbox kernel: [  361.227750]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:25:09 tbox kernel: [  361.238216]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.248644]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:25:09 tbox kernel: [  361.259051]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:25:09 tbox kernel: [  361.269341]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:25:09 tbox kernel: [  361.279737]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  361.290095]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:25:09 tbox kernel: [  361.300570]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:25:09 tbox kernel: [  361.310963]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:25:09 tbox kernel: [  361.321416]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  361.331890]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:25:09 tbox kernel: [  361.342365]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:25:09 tbox kernel: [  361.352806]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:25:09 tbox kernel: [  361.363332] INFO: task rcu_torture_fak:1753 blocked for more than 120 seconds.
> Mar 29 04:25:09 tbox kernel: [  361.373899] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:25:09 tbox kernel: [  361.384605] rcu_torture_fak D 00000021     0  1753      2 0x00000000
> Mar 29 04:25:09 tbox kernel: [  361.395327]  f591bf08 00000046 3d298aff 00000021 c1467400 002590a2 00000000 c1467400
> Mar 29 04:25:09 tbox kernel: [  361.406361]  00000000 00000021 f5844840 c108395c c129f22b 00000001 f591bed0 c12a313a
> Mar 29 04:25:09 tbox kernel: [  361.417290]  f6406400 f591bed8 c1025e91 f591bf54 c129f230 1a974f36 00000021 c1467400
> Mar 29 04:25:09 tbox kernel: [  361.428261] Call Trace:
> Mar 29 04:25:09 tbox kernel: [  361.438867]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:09 tbox kernel: [  361.449542]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:25:09 tbox kernel: [  361.460061]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.470675]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:25:09 tbox kernel: [  361.481046]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:25:09 tbox kernel: [  361.491448]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:25:09 tbox kernel: [  361.501801]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:25:09 tbox kernel: [  361.512251]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:25:09 tbox kernel: [  361.522588]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.533084]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:09 tbox kernel: [  361.543495]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:25:09 tbox kernel: [  361.553946]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.564368]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:25:09 tbox kernel: [  361.574778]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:25:09 tbox kernel: [  361.585055]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:25:09 tbox kernel: [  361.595446]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  361.605792]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:25:09 tbox kernel: [  361.616270]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:25:09 tbox kernel: [  361.626652]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:25:09 tbox kernel: [  361.637107]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  361.647577]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:25:09 tbox kernel: [  361.658037]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:25:09 tbox kernel: [  361.668459]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:25:09 tbox kernel: [  361.678968] INFO: task modprobe:1759 blocked for more than 120 seconds.
> Mar 29 04:25:09 tbox kernel: [  361.689455] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:25:09 tbox kernel: [  361.700107] modprobe        D 00000036     0  1759   1747 0x00000000
> Mar 29 04:25:09 tbox kernel: [  361.710781]  f5995ea4 00000082 10c2f37d 00000036 c1467400 00000c21 00000000 c1467400
> Mar 29 04:25:09 tbox kernel: [  361.721757]  00000000 00000036 f5844420 ffffffff ffffffff c1027d65 10c2d7ee f6406444
> Mar 29 04:25:09 tbox kernel: [  361.732657]  002dab31 f5995e84 3d090000 00000000 f584444c 00001b8f 00000000 f5995e94
> Mar 29 04:25:09 tbox kernel: [  361.743604] Call Trace:
> Mar 29 04:25:09 tbox kernel: [  361.754185]  [<c1027d65>] ? finish_task_switch+0x67/0x6d
> Mar 29 04:25:09 tbox kernel: [  361.764863]  [<c10219ba>] ? wakeup_preempt_entity+0x36/0x53
> Mar 29 04:25:09 tbox kernel: [  361.775397]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:25:09 tbox kernel: [  361.785917]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:25:09 tbox kernel: [  361.796240]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:25:09 tbox kernel: [  361.806599]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:25:09 tbox kernel: [  361.816960]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:25:09 tbox kernel: [  361.827308]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:25:09 tbox kernel: [  361.837555]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:25:09 tbox kernel: [  361.847902]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:25:09 tbox kernel: [  361.858181]  [<c1045576>] kthread_stop+0x60/0xaf
> Mar 29 04:25:09 tbox kernel: [  361.868503]  [<f8760592>] rcu_torture_cleanup+0x1d5/0x318 [rcutorture]
> Mar 29 04:25:09 tbox kernel: [  361.878857]  [<c10592bc>] sys_delete_module+0x198/0x1f5
> Mar 29 04:25:09 tbox kernel: [  361.889253]  [<c10c1612>] ? vfs_write+0xa4/0xd7
> Mar 29 04:25:09 tbox kernel: [  361.899525]  [<c11aade0>] ? tty_write_lock+0x3d/0x3d
> Mar 29 04:25:09 tbox kernel: [  361.909876]  [<c10c17ca>] ? sys_write+0x53/0x5d
> Mar 29 04:25:09 tbox kernel: [  361.920083]  [<c12a575f>] sysenter_do_call+0x12/0x28
> Mar 29 04:27:09 tbox kernel: [  481.928074] INFO: task rcu_torture_fak:1750 blocked for more than 120 seconds.
> Mar 29 04:27:09 tbox kernel: [  481.940037] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:27:09 tbox kernel: [  481.953070] rcu_torture_fak D 00000036     0  1750      2 0x00000000
> Mar 29 04:27:10 tbox kernel: [  481.972056]  f5169f08 00000046 10c2d7ee 00000036 c1467400 000036da 00000000 c1467400
> Mar 29 04:27:10 tbox kernel: [  481.984708]  00000000 00000036 f5971ce0 c108395c c129f22b 00000001 f5169ed0 c12a313a
> Mar 29 04:27:10 tbox kernel: [  481.996536]  f6406400 f5169ed8 c1025e91 f5169f54 c129f230 1a975683 00000021 c1467400
> Mar 29 04:27:10 tbox kernel: [  482.008580] Call Trace:
> Mar 29 04:27:10 tbox kernel: [  482.020181]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:10 tbox kernel: [  482.031882]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:27:10 tbox kernel: [  482.043546]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.055367]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:27:10 tbox kernel: [  482.067076]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:27:10 tbox kernel: [  482.078839]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:27:10 tbox kernel: [  482.090503]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:27:10 tbox kernel: [  482.102239]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:27:10 tbox kernel: [  482.113842]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.125558]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:10 tbox kernel: [  482.137128]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:27:10 tbox kernel: [  482.148707]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.160239]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:27:10 tbox kernel: [  482.171766]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:27:10 tbox kernel: [  482.183180]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:27:10 tbox kernel: [  482.194676]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:27:10 tbox kernel: [  482.206123]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:27:10 tbox kernel: [  482.217623]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:27:10 tbox kernel: [  482.228876]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:27:10 tbox kernel: [  482.240065]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:27:10 tbox kernel: [  482.251134]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:27:10 tbox kernel: [  482.262103]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:27:10 tbox kernel: [  482.272901]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:27:10 tbox kernel: [  482.283635] INFO: task rcu_torture_fak:1751 blocked for more than 120 seconds.
> Mar 29 04:27:10 tbox kernel: [  482.294244] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:27:10 tbox kernel: [  482.304837] rcu_torture_fak D 00000021     0  1751      2 0x00000000
> Mar 29 04:27:10 tbox kernel: [  482.315409]  f5807f08 00000046 1b8afabc 00000021 c1467400 21ab5ecd 00000000 c1467400
> Mar 29 04:27:10 tbox kernel: [  482.326258]  00000000 00000021 f5970840 c108395c c129f22b 00000001 f5807ed0 c12a313a
> Mar 29 04:27:10 tbox kernel: [  482.337071]  f6406400 f5807ed8 c1025e91 f5807f54 c129f230 1a975e7e 00000021 c1467400
> Mar 29 04:27:10 tbox kernel: [  482.348016] Call Trace:
> Mar 29 04:27:10 tbox kernel: [  482.358653]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:10 tbox kernel: [  482.369453]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:27:10 tbox kernel: [  482.380116]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.390934]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:27:10 tbox kernel: [  482.401650]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:27:10 tbox kernel: [  482.412396]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:27:10 tbox kernel: [  482.423046]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:27:10 tbox kernel: [  482.433759]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:27:10 tbox kernel: [  482.444321]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.455086]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:10 tbox kernel: [  482.465806]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:27:10 tbox kernel: [  482.476454]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.486994]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:27:10 tbox kernel: [  482.497590]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:27:10 tbox kernel: [  482.508130]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:27:10 tbox kernel: [  482.518661]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:27:10 tbox kernel: [  482.529095]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:27:10 tbox kernel: [  482.539659]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:27:10 tbox kernel: [  482.550091]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:27:10 tbox kernel: [  482.560540]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:27:10 tbox kernel: [  482.571002]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:27:10 tbox kernel: [  482.581466]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:27:10 tbox kernel: [  482.591845]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:27:10 tbox kernel: [  482.602246] INFO: task rcu_torture_fak:1752 blocked for more than 120 seconds.
> Mar 29 04:27:10 tbox kernel: [  482.612710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:27:10 tbox kernel: [  482.623331] rcu_torture_fak D 00000021     0  1752      2 0x00000000
> Mar 29 04:27:10 tbox kernel: [  482.634036]  f59aff08 00000046 1c05091a 00000021 c1467400 2144d81f 00000000 c1467400
> Mar 29 04:27:10 tbox kernel: [  482.645198]  00000000 00000021 f5b2cc60 c108395c c129f22b 00000001 f59afed0 c12a313a
> Mar 29 04:27:10 tbox kernel: [  482.656175]  f6406400 f59afed8 c1025e91 f59aff54 c129f230 1a973f63 00000021 c1467400
> Mar 29 04:27:10 tbox kernel: [  482.667124] Call Trace:
> Mar 29 04:27:10 tbox kernel: [  482.677703]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:10 tbox kernel: [  482.688365]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:27:10 tbox kernel: [  482.698868]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.709440]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:27:10 tbox kernel: [  482.719793]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:27:10 tbox kernel: [  482.730182]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:27:10 tbox kernel: [  482.740519]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:27:10 tbox kernel: [  482.750947]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:27:10 tbox kernel: [  482.761271]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.771756]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:10 tbox kernel: [  482.782160]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:27:10 tbox kernel: [  482.792602]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:10 tbox kernel: [  482.803006]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:27:10 tbox kernel: [  482.813393]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:27:10 tbox kernel: [  482.823666]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:27:10 tbox kernel: [  482.834058]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:27:10 tbox kernel: [  482.844417]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:27:10 tbox kernel: [  482.854887]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:27:10 tbox kernel: [  482.865264]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:27:10 tbox kernel: [  482.875699]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:27:10 tbox kernel: [  482.886157]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:27:10 tbox kernel: [  482.896608]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:27:10 tbox kernel: [  482.907033]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:27:10 tbox kernel: [  482.917579] INFO: task rcu_torture_fak:1753 blocked for more than 120 seconds.
> Mar 29 04:27:10 tbox kernel: [  482.928135] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:27:10 tbox kernel: [  482.938831] rcu_torture_fak D 00000021     0  1753      2 0x00000000
> Mar 29 04:27:10 tbox kernel: [  482.949547]  f591bf08 00000046 3d298aff 00000021 c1467400 002590a2 00000000 c1467400
> Mar 29 04:27:11 tbox kernel: [  482.960568]  00000000 00000021 f5844840 c108395c c129f22b 00000001 f591bed0 c12a313a
> Mar 29 04:27:11 tbox kernel: [  482.971488]  f6406400 f591bed8 c1025e91 f591bf54 c129f230 1a974f36 00000021 c1467400
> Mar 29 04:27:11 tbox kernel: [  482.982445] Call Trace:
> Mar 29 04:27:11 tbox kernel: [  482.993023]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:11 tbox kernel: [  483.003687]  [<c129f22b>] ? schedule+0x3e5/0x3fa
> Mar 29 04:27:11 tbox kernel: [  483.014180]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:11 tbox kernel: [  483.024748]  [<c1025e91>] ? need_resched+0x14/0x1e
> Mar 29 04:27:11 tbox kernel: [  483.035095]  [<c129f230>] ? schedule+0x3ea/0x3fa
> Mar 29 04:27:11 tbox kernel: [  483.045485]  [<c108397d>] ? trace_preempt_off+0xf/0x22
> Mar 29 04:27:11 tbox kernel: [  483.055817]  [<c103a53b>] ? lock_timer_base.isra.29+0x1e/0x3c
> Mar 29 04:27:11 tbox kernel: [  483.066241]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:27:11 tbox kernel: [  483.076562]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:11 tbox kernel: [  483.087036]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:11 tbox kernel: [  483.097426]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:27:11 tbox kernel: [  483.107856]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:11 tbox kernel: [  483.118256]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:27:11 tbox kernel: [  483.128627]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:27:11 tbox kernel: [  483.138884]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:27:11 tbox kernel: [  483.149275]  [<f875f93e>] ? rcu_torture_fqs+0xc6/0xc6 [rcutorture]
> Mar 29 04:27:11 tbox kernel: [  483.159611]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:27:11 tbox kernel: [  483.170072]  [<c1077004>] synchronize_rcu+0x38/0x3a
> Mar 29 04:27:11 tbox kernel: [  483.180444]  [<c1043868>] ? find_ge_pid+0x2f/0x2f
> Mar 29 04:27:11 tbox kernel: [  483.190875]  [<f875f9b1>] rcu_torture_fakewriter+0x73/0xd0 [rcutorture]
> Mar 29 04:27:11 tbox kernel: [  483.201327]  [<c1045511>] kthread+0x62/0x67
> Mar 29 04:27:11 tbox kernel: [  483.211784]  [<c10454af>] ? kthread_worker_fn+0x111/0x111
> Mar 29 04:27:11 tbox kernel: [  483.222207]  [<c12a5cfe>] kernel_thread_helper+0x6/0xd
> Mar 29 04:27:11 tbox kernel: [  483.232717] INFO: task modprobe:1759 blocked for more than 120 seconds.
> Mar 29 04:27:11 tbox kernel: [  483.243213] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 29 04:27:11 tbox kernel: [  483.253882] modprobe        D 00000036     0  1759   1747 0x00000000
> Mar 29 04:27:11 tbox kernel: [  483.264562]  f5995ea4 00000082 10c2f37d 00000036 c1467400 00000c21 00000000 c1467400
> Mar 29 04:27:11 tbox kernel: [  483.275540]  00000000 00000036 f5844420 ffffffff ffffffff c1027d65 10c2d7ee f6406444
> Mar 29 04:27:11 tbox kernel: [  483.286424]  002dab31 f5995e84 3d090000 00000000 f584444c 00001b8f 00000000 f5995e94
> Mar 29 04:27:11 tbox kernel: [  483.297363] Call Trace:
> Mar 29 04:27:11 tbox kernel: [  483.307928]  [<c1027d65>] ? finish_task_switch+0x67/0x6d
> Mar 29 04:27:11 tbox kernel: [  483.318648]  [<c10219ba>] ? wakeup_preempt_entity+0x36/0x53
> Mar 29 04:27:11 tbox kernel: [  483.329172]  [<c129f514>] schedule_timeout+0x21/0xaa
> Mar 29 04:27:11 tbox kernel: [  483.339689]  [<c108395c>] ? trace_preempt_on+0xf/0x21
> Mar 29 04:27:11 tbox kernel: [  483.350012]  [<c129ed68>] ? wait_for_common+0x6f/0xca
> Mar 29 04:27:11 tbox kernel: [  483.360371]  [<c12a313a>] ? sub_preempt_count.part.167+0x67/0x74
> Mar 29 04:27:11 tbox kernel: [  483.370729]  [<c12a3188>] ? sub_preempt_count+0x41/0x43
> Mar 29 04:27:11 tbox kernel: [  483.381108]  [<c129ed6f>] wait_for_common+0x76/0xca
> Mar 29 04:27:11 tbox kernel: [  483.391338]  [<c102ca4a>] ? try_to_wake_up+0x181/0x181
> Mar 29 04:27:11 tbox kernel: [  483.401670]  [<c129ee44>] wait_for_completion+0x12/0x14
> Mar 29 04:27:11 tbox kernel: [  483.411936]  [<c1045576>] kthread_stop+0x60/0xaf
> Mar 29 04:27:11 tbox kernel: [  483.422248]  [<f8760592>] rcu_torture_cleanup+0x1d5/0x318 [rcutorture]
> Mar 29 04:27:11 tbox kernel: [  483.432594]  [<c10592bc>] sys_delete_module+0x198/0x1f5
> Mar 29 04:27:11 tbox kernel: [  483.442984]  [<c10c1612>] ? vfs_write+0xa4/0xd7
> Mar 29 04:27:11 tbox kernel: [  483.453255]  [<c11aade0>] ? tty_write_lock+0x3d/0x3d
> Mar 29 04:27:11 tbox kernel: [  483.463598]  [<c10c17ca>] ? sys_write+0x53/0x5d
> Mar 29 04:27:11 tbox kernel: [  483.473787]  [<c12a575f>] sysenter_do_call+0x12/0x28

