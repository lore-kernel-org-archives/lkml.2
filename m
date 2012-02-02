Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2BBRWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:22:37 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45665 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2BBRWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:22:36 -0500
Date: Thu, 2 Feb 2012 09:08:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 13/41] rcu: Make rcutorture flag
 online/offline failures
Message-ID: <20120202170825.GO2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202014656.GJ29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202014656.GJ29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-5806-0000-0000-000011FC6564
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:46:56PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:31AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Make rcutorture check for CPU-hotplug failures and complain if there
> > were any.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutorture.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 88f17b8..a94eaef 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -1602,6 +1602,10 @@ rcu_torture_cleanup(void)
> >  		cur_ops->cleanup();
> >  	if (atomic_read(&n_rcu_torture_error))
> >  		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
> > +	else if (n_online_successes != n_online_attempts ||
> > +		 n_offline_successes != n_offline_attempts)
> > +		rcu_torture_print_module_parms(cur_ops,
> > +					       "End of test: RCU_HOTPLUG");
> >  	else
> >  		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
> 
> OK, I must admit that when I saw the addition of RCU_HOTPLUG to the
> existing cases of FAILURE and SUCCESS, my mind went to
> http://thedailywtf.com/Articles/What_Is_Truth_0x3f_.aspx .

;-) ;-) ;-)

> More seriously, though, shouldn't this just say FAILURE, perhaps with
> further explanation attached?

I see a big difference between an occasional instance of a CPU refusing
to go offline and RCU grace periods being too short.  The former can
be annoying, but if you retry, it will likely succeed the second time.
The latter is fatal.

							Thanx, Paul

