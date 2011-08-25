Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1HYFFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:05:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47264 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab1HYFE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:04:59 -0400
Date: Wed, 24 Aug 2011 22:04:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the rcu tree
Message-ID: <20110825050456.GB2411@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110824142337.78715e4d6f9db2de68d87fe4@canb.auug.org.au>
 <20110824122739.GB2320@linux.vnet.ibm.com>
 <CACqU3MVZRjxo-C+z-WRKnMMFfkr35c4FDUpoY6Kbkh1y1J45kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MVZRjxo-C+z-WRKnMMFfkr35c4FDUpoY6Kbkh1y1J45kQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 08:46:15PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Wed, Aug 24, 2011 at 8:27 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Aug 24, 2011 at 02:23:37PM +1000, Stephen Rothwell wrote:
> >> Hi Paul,
> >>
> >> After merging the rcu tree, today's linux-next build (powerpc
> >> ppc64_defconfig) produced this warning:
> >>
> >> kernel/rtmutex.c: In function '__rt_mutex_slowlock':
> >> kernel/rtmutex.c:605:3: warning: suggest parentheses around assignment used as truth value
> >
> > There actually already are parentheses around it, and the first pass
> > through the loop it is uninitialized at that point.  But hey, that
> > is gcc for you!  Does the patch below cure it?
> >
> Yes.

Thank you!

							Thanx, Paul

>  - Arnaud
> 
> >> Introduced by commit 83841f021d4b ("rcu: Permit rt_mutex_unlock() with
> >> irqs disabled").
> >
> > If it does, then I will fold into that commit.
> >
> >                                                        Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> > diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> > index 0222e34..2548f44 100644
> > --- a/kernel/rtmutex.c
> > +++ b/kernel/rtmutex.c
> > @@ -602,7 +602,8 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
> >
> >                raw_spin_unlock(&lock->wait_lock);
> >
> > -               if (was_disabled = irqs_disabled())
> > +               was_disabled = irqs_disabled();
> > +               if (was_disabled)
> >                        local_irq_enable();
> >
> >                debug_rt_mutex_print_deadlock(waiter);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
