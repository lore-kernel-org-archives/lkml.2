Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1KPUjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:39:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40935 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1KPUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:39:07 -0500
Date: Wed, 16 Nov 2011 12:38:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 3/9] rcu: Control rcutorture startup from
 kernel boot parameters
Message-ID: <20111116203851.GM2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111115214932.GE31473@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115214932.GE31473@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111620-5112-0000-0000-0000021CA902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:49:32PM -0800, Josh Triplett wrote:
> On Tue, Nov 15, 2011 at 12:27:59PM -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > Currently, if rcutorture is built into the kernel, it must be manually
> > started or started from an init script.  This is inconvenient for
> > automated KVM testing, where it is good to be able to fully control
> > rcutorture execution from the kernel parameters.  This patch therefore
> > adds a module parameter named "rcutorture_runnable" that defaults
> > to zero ("don't start automatically"), but which can be set to one
> > to cause rcutorture to start up immediately during boot.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutorture.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 41802be..fd7a0e6 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -164,6 +164,8 @@ static int stutter_pause_test;
> >  #define RCUTORTURE_RUNNABLE_INIT 0
> >  #endif
> >  int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
> > +module_param(rcutorture_runnable, int, 0444);
> > +MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
> 
> Perhaps this should become a bool rather than an int, so that the kernel
> would recognize various variations on the parameter value, such as "on"
> or "true".

I had a funny feeling that I would be needing other values to do things
like say at what phase of boot the test was to start.

But if no need for this sort of function appears in the next while, then
switching to bool would indeed make a lot of sense.

							Thanx, Paul

