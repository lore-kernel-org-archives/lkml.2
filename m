Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1C0M0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 08:26:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39706 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1C0M0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 08:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ZY/hV9tsrk/hT6r66dTltF7DPPl7Ei9w2nHFEP2r703AzCUUitvyiK19BrLRz5CTjd
         cXNXHyGG2m3ivmGs+QlWx0i/IPT3EfqWSXf7gTcWeyTCCo+LYujswNp3hifFX4SsJ3CX
         /+u2xMeq80syqkFyEeW2SAg9YaooLk2+lpTWM=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110327050720.GA31424@linux.vnet.ibm.com>
References: <AANLkTi=N6Z0bDg1YXVFkUbv7phM8XvQ5U3=vS6Ej8Af5@mail.gmail.com>
	<20110325174855.GR2322@linux.vnet.ibm.com>
	<AANLkTin9HxOTwavbtbsMd0quYsEvhDNmuO5kOpquqoF=@mail.gmail.com>
	<20110326034210.GX2322@linux.vnet.ibm.com>
	<AANLkTi=zJZ26i14D-kyWQ1uqUPifrv+DN4So4+fC5V=d@mail.gmail.com>
	<20110326160229.GZ2322@linux.vnet.ibm.com>
	<AANLkTikzLm+ArYkG20F41JOgfNygfdhxC0+A4tV4ez-R@mail.gmail.com>
	<20110327000900.GB2322@linux.vnet.ibm.com>
	<AANLkTikpq2CiSTk9Br7DdkVt=E1p8OFGa+Ls2BzkkhcO@mail.gmail.com>
	<20110327032529.GC2322@linux.vnet.ibm.com>
	<20110327050720.GA31424@linux.vnet.ibm.com>
Date: Sun, 27 Mar 2011 14:26:15 +0200
Message-ID: <AANLkTimpbGGcxNJUDMjdg1wijYhvXQ3KySvRYnEsUYsy@mail.gmail.com>
Subject: Re: linux-next: Tree for March 25 (Call trace: RCU|workqueues|block|VFS|ext4
 related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 7:07 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sat, Mar 26, 2011 at 08:25:29PM -0700, Paul E. McKenney wrote:
>> On Sun, Mar 27, 2011 at 03:30:34AM +0200, Sedat Dilek wrote:
>> > On Sun, Mar 27, 2011 at 1:09 AM, Paul E. McKenney
>> > <paulmck@linux.vnet.ibm.com> wrote:
>> > > On Sat, Mar 26, 2011 at 11:15:22PM +0100, Sedat Dilek wrote:
>
> [ . . . ]
>
>> > >> But then came RCU :-(.
>> > >
>> > > Well, if it turns out to be a problem in RCU I will certainly apologize.
>> > >
>> >
>> > No, that's not so dramatic.
>> > Dealing with this RCU issue has nice side-effects: I remembered (and
>> > finally did) to use a reduced kernel-config set.
>> > The base for it I created with 'make localmodconfig' and did some
>> > manual fine-tuning afterwards (throw out media, rc, dvd, unneeded FSs,
>> > etc.).
>> > Also, I can use fresh gcc-4.6 (4.6.0-1) from the official Debian repos.
>> >
>> > So, I started building with
>> > "revert-rcu-patches/0001-Revert-rcu-introduce-kfree_rcu.patch".
>> > I will let you know.
>>
>> And please also check for tasks consuming all available CPU.
>
> And I still cannot reproduce with the full RCU stack (but based off of
> 2.6.38 rather than -next).  Nevertheless, if you would like to try a
> speculative patch, here you go.
>

You are right and my strategy on handling the (possible RCU?) issue is wrong.
Surely, you tested your RCU stuff in your own repo and everything
might be OK on top of stable 2.6.38.
Linux-next gets daily updates from a lot of different trees, so there
might be interferences with other stuff.
Please, understand I am interested in finding out what is the cause
for my issues, my aim is not to blame you.

As I was wrong and want to be 99.9% sure it is RCU stuff, I reverted
all (18) RCU patches from linux-next (next-20110325) by keeping the
RCU|PREEMPT|HZ settings from last working next-20110323.

$ egrep 'RCU|PREEMPT|_HZ' /boot/config-2.6.38-next20110325-7-686-iniza
# RCU Subsystem
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_NO_HZ=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set

I will work and stress this kernel before doing any step-by-step
revert of RCU stuff.

Thanks for your patch, I applied it on top of "naked" next-20110325,
but I still see call-traces.

- Sedat -



>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: further lower priority in rcu_yield()
>
> Although rcu_yield() dropped from real-time to normal priority, there
> is always the possibility that the competing tasks have been niced.
> So nice to 19 in rcu_yield() to help ensure that other tasks have a
> better chance of running.
>
>    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 759f54b..5477764 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1492,6 +1492,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
>        mod_timer(&yield_timer, jiffies + 2);
>        sp.sched_priority = 0;
>        sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
> +       set_user_nice(current, 19);
>        schedule();
>        sp.sched_priority = RCU_KTHREAD_PRIO;
>        sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
>
