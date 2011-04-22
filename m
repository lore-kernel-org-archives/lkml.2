Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1DVPC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:02:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51266 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1DVPCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:02:25 -0400
Date: Fri, 22 Apr 2011 08:02:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110422150222.GA2300@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTikVW9Z=WxD7=w9c=Z6kHO-Za2ru8A@mail.gmail.com>
 <20110414224411.GF2141@linux.vnet.ibm.com>
 <20110421050823.GA4487@linux.vnet.ibm.com>
 <BANLkTinFmG5GVq6D8+wq_89OPF8snsQ=Jw@mail.gmail.com>
 <BANLkTi=c=+JnU9dQsVhgjZbOtArhHQz+EQ@mail.gmail.com>
 <BANLkTimEWqBVdq8MWbjAAfXCLPQdiHkuNg@mail.gmail.com>
 <20110421142853.GA2235@linux.vnet.ibm.com>
 <BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
 <20110422005046.GQ2235@linux.vnet.ibm.com>
 <BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 11:40:54AM +0200, Sedat Dilek wrote:
> On Fri, Apr 22, 2011 at 2:50 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Apr 21, 2011 at 04:47:31PM +0200, Sedat Dilek wrote:
> >> On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote:
> >> >> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
> >> >> <sedat.dilek@googlemail.com> wrote:
> >
> > [ . . . ]
> >
> >> >> Here the results from the 2nd-run (PREEMPT_RCU enabled).
> >> >
> >> > OK, and the grace periods clearly stopped advancing early on.
> >> >
> >> > Beyond that point, the per-CPU kthread is blocked, but RCU has some
> >> > work for it to do.  So someone has called invoke_rcu_cpu_kthread(),
> >> > but rcu_cpu_kthread() is still blocked.  I don't see a bug right
> >> > off-hand, but it is early in the morning for me, so I might easily
> >> > be missing something.
> >> >
> >> > Hmmm...
> >> >
> >> > The synchronization between these two assumes that the per-CPU
> >> > kthread is always bound to the respective CPU, so if was somehow
> >> > being migrated off, that might explain these results.
> >> >
> >> > I will add some more diagnostics, test them locally, then push
> >> > out an update.  Seem reasonable?
> >> >
> >> > And thank you again for the testing!!!
> >>
> >> Ping me when you have new stuff for testing.
> >> Tomorrow (friday), here is public holiday and monday, too.
> >> So a looong weekend.
> >
> > ;-)
> >
> > OK, I have a new sedat.2011.04.21a branch in the -rcu git tree:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >
> > This is against 2.6.39-rc3, as before.  (Yes, I do need to rebase to
> > 2.6.39-rc4, but didn't want to change any more than I had to.)
> >
> > I also have an updated script, which is attached.  The output is similar
> > to the earlier one, and it operated is pretty much the same way.
> >
> > Have a great weekend, and I look forward to seeing what shows up on
> > this round.  I confess to still being quite puzzled!
> >
> >                                                        Thanx, Paul
> >
> 
> Here are the results of the Sedat's vote (European song contest :-)).

;-)

Very strange.  RCU has told the per-CPU kthread that it needs to get
to work, but this kthread is still waiting from RCU's viewpoint.
Yet the "ps" command believes that this kthread is in fact runnable
at SCHED_FIFO priority 1.

I can tell that this one will require some thought...  And more
diagnostics...

							Thanx, Paul
