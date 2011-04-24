Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1DXG1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 02:27:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39361 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1DXG1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 02:27:41 -0400
Date: Sat, 23 Apr 2011 23:27:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110424062728.GM2628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110421142853.GA2235@linux.vnet.ibm.com>
 <BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
 <20110422005046.GQ2235@linux.vnet.ibm.com>
 <BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
 <20110422150222.GA2300@linux.vnet.ibm.com>
 <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
 <20110423210539.GI2628@linux.vnet.ibm.com>
 <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
 <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
 <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 01:08:42AM +0200, Sedat Dilek wrote:
> On Sun, Apr 24, 2011 at 1:04 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> > On Sat, Apr 23, 2011 at 11:16 PM, Sedat Dilek
> > <sedat.dilek@googlemail.com> wrote:
> >> On Sat, Apr 23, 2011 at 11:05 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >>> On Fri, Apr 22, 2011 at 07:36:58PM +0200, Sedat Dilek wrote:
> >>>> On Fri, Apr 22, 2011 at 5:02 PM, Paul E. McKenney
> >>>> <paulmck@linux.vnet.ibm.com> wrote:
> >>>> > On Fri, Apr 22, 2011 at 11:40:54AM +0200, Sedat Dilek wrote:
> >>>> >> On Fri, Apr 22, 2011 at 2:50 AM, Paul E. McKenney
> >>>> >> <paulmck@linux.vnet.ibm.com> wrote:
> >>>> >> > On Thu, Apr 21, 2011 at 04:47:31PM +0200, Sedat Dilek wrote:
> >>>> >> >> On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
> >>>> >> >> <paulmck@linux.vnet.ibm.com> wrote:
> >>>> >> >> > On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote:
> >>>> >> >> >> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
> >>>> >> >> >> <sedat.dilek@googlemail.com> wrote:
> >>>> >> >
> >>>> >> > [ . . . ]
> >>>> >> >
> >>>> >> >> >> Here the results from the 2nd-run (PREEMPT_RCU enabled).
> >>>> >> >> >
> >>>> >> >> > OK, and the grace periods clearly stopped advancing early on.
> >>>> >> >> >
> >>>> >> >> > Beyond that point, the per-CPU kthread is blocked, but RCU has some
> >>>> >> >> > work for it to do.  So someone has called invoke_rcu_cpu_kthread(),
> >>>> >> >> > but rcu_cpu_kthread() is still blocked.  I don't see a bug right
> >>>> >> >> > off-hand, but it is early in the morning for me, so I might easily
> >>>> >> >> > be missing something.
> >>>> >> >> >
> >>>> >> >> > Hmmm...
> >>>> >> >> >
> >>>> >> >> > The synchronization between these two assumes that the per-CPU
> >>>> >> >> > kthread is always bound to the respective CPU, so if was somehow
> >>>> >> >> > being migrated off, that might explain these results.
> >>>> >> >> >
> >>>> >> >> > I will add some more diagnostics, test them locally, then push
> >>>> >> >> > out an update.  Seem reasonable?
> >>>> >> >> >
> >>>> >> >> > And thank you again for the testing!!!
> >>>> >> >>
> >>>> >> >> Ping me when you have new stuff for testing.
> >>>> >> >> Tomorrow (friday), here is public holiday and monday, too.
> >>>> >> >> So a looong weekend.
> >>>> >> >
> >>>> >> > ;-)
> >>>> >> >
> >>>> >> > OK, I have a new sedat.2011.04.21a branch in the -rcu git tree:
> >>>> >> >
> >>>> >> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >>>> >> >
> >>>> >> > This is against 2.6.39-rc3, as before.  (Yes, I do need to rebase to
> >>>> >> > 2.6.39-rc4, but didn't want to change any more than I had to.)
> >>>> >> >
> >>>> >> > I also have an updated script, which is attached.  The output is similar
> >>>> >> > to the earlier one, and it operated is pretty much the same way.
> >>>> >> >
> >>>> >> > Have a great weekend, and I look forward to seeing what shows up on
> >>>> >> > this round.  I confess to still being quite puzzled!
> >>>> >> >
> >>>> >> >                                                        Thanx, Paul
> >>>> >> >
> >>>> >>
> >>>> >> Here are the results of the Sedat's vote (European song contest :-)).
> >>>> >
> >>>> > ;-)
> >>>> >
> >>>> > Very strange.  RCU has told the per-CPU kthread that it needs to get
> >>>> > to work, but this kthread is still waiting from RCU's viewpoint.
> >>>> > Yet the "ps" command believes that this kthread is in fact runnable
> >>>> > at SCHED_FIFO priority 1.
> >>>> >
> >>>> > I can tell that this one will require some thought...  And more
> >>>> > diagnostics...
> >>>> >
> >>>> >                                                        Thanx, Paul
> >>>> >
> >>>>
> >>>> "We are with you in spirit."
> >>>>
> >>>> ( Level XX from Hybris shooter-game on Amiga (1989) )
> >>>
> >>> OK, I added a few more diagnostics: sedat.2011.04.23a in -rcu:
> >>>
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >>>
> >>> When you get a chance, could you please give it a try?
> >>>
> >>>                                                        Thanx, Paul
> >>>
> >>
> >> As soon as I can clone/pull from new GIT repo/branch.
> >> Currently, I don't see it only, but kernel-mirrors are sometimes slow.
> >>
> >> I will report later.
> >>
> >> - Sedat -
> >>
> >
> > Hi Paul,
> >
> > I have seen CONFIG_DEBUG_OBJECTS_RCU_HEAD mentionned in the commits,
> > so I enabled it here together with CONFIG_DEBUG_OBJECTS=y.
> > Hope this is OK.
> > Am I missing other useful (*DEBUG_OBJECT*) kernel options?
> >
> > - Sedat -
> >
> > P.S.: Enabled CONFIG_DEBUG_OBJECTS=y and
> > CONFIG_DEBUG_OBJECTS_RCU_HEAD=y (and some more)
> >
> > # diff -uprN for-paulk-3/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.21a+
> > for-paulk-4/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.23a+
> > --- for-paulk-3/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.21a+
> >  2011-04-22 10:25:42.000000000 +0200
> > +++ for-paulk-4/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.23a+
> >  2011-04-24 00:35:37.000000000 +0200
> > @@ -1,7 +1,7 @@
> >  #
> >  # Automatically generated make config: don't edit
> >  # Linux/i386 2.6.39-rc3 Kernel Configuration
> > -# Fri Apr 22 09:54:37 2011
> > +# Sat Apr 23 23:58:52 2011
> >  #
> >  # CONFIG_64BIT is not set
> >  CONFIG_X86_32=y
> > @@ -3065,7 +3065,14 @@ CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> >  CONFIG_SCHED_DEBUG=y
> >  # CONFIG_SCHEDSTATS is not set
> >  CONFIG_TIMER_STATS=y
> > -# CONFIG_DEBUG_OBJECTS is not set
> > +CONFIG_DEBUG_OBJECTS=y
> > +# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> > +# CONFIG_DEBUG_OBJECTS_FREE is not set
> > +CONFIG_DEBUG_OBJECTS_TIMERS=y
> > +# CONFIG_DEBUG_OBJECTS_WORK is not set
> > +CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> > +CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> > +CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> >  # CONFIG_SLUB_DEBUG_ON is not set
> >  # CONFIG_SLUB_STATS is not set
> >  # CONFIG_DEBUG_KMEMLEAK is not set
> >
> 
> Oops, forget the dmesg output.

OK, this looks unrelated, but just in case, could you please try it
again with the following patch?  (Not mainlinable, debug only.)

Also, it does look like you are still seeing a grace-period hang.
Could you please send the output of the script?  Same one as last time.

							Thanx, Paul

------------------------------------------------------------------------

 debugobjects.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 9d86e45..10a7c7a 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -289,10 +289,12 @@ static void debug_object_is_on_stack(void *addr, int onstack)
 		return;
 
 	limit++;
-	if (is_on_stack)
+	if (is_on_stack) {
+		struct rcu_head *p = (struct rcu_head *)addr;
 		printk(KERN_WARNING
-		       "ODEBUG: object is on stack, but not annotated\n");
-	else
+		       "ODEBUG: object is on stack, but not annotated: %p\n",
+		       p->func);
+	} else
 		printk(KERN_WARNING
 		       "ODEBUG: object is not on stack, but annotated\n");
 	WARN_ON(1);
