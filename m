Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030527Ab2EQWly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:41:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42196 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030488Ab2EQWlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:41:53 -0400
Date: Thu, 17 May 2012 15:41:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
Message-ID: <20120517224146.GP2567@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120517222322.GA15766@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517222322.GA15766@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051722-6148-0000-0000-000005F0DFA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 03:23:22PM -0700, Josh Triplett wrote:
> On Thu, May 17, 2012 at 03:12:45PM -0700, Paul E. McKenney wrote:
> > @@ -1184,27 +1183,27 @@ rcu_torture_printk(char *page)
> >  	}
> >  	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
> >  	cnt += sprintf(&page[cnt],
> > -		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
> > -		       "rtmbe: %d rtbke: %ld rtbre: %ld "
> > -		       "rtbf: %ld rtb: %ld nt: %ld "
> > -		       "onoff: %ld/%ld:%ld/%ld "
> > -		       "barrier: %ld/%ld:%ld",
> > +		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
> >  		       rcu_torture_current,
> >  		       rcu_torture_current_version,
> >  		       list_empty(&rcu_torture_freelist),
> >  		       atomic_read(&n_rcu_torture_alloc),
> >  		       atomic_read(&n_rcu_torture_alloc_fail),
> > -		       atomic_read(&n_rcu_torture_free),
> > +		       atomic_read(&n_rcu_torture_free));
> > +	cnt += sprintf(&page[cnt], "rtmbe: %d rtbke: %ld rtbre: %ld ",
> >  		       atomic_read(&n_rcu_torture_mberror),
> >  		       n_rcu_torture_boost_ktrerror,
> > -		       n_rcu_torture_boost_rterror,
> > +		       n_rcu_torture_boost_rterror);
> > +	cnt += sprintf(&page[cnt], "rtbf: %ld rtb: %ld nt: %ld ",
> >  		       n_rcu_torture_boost_failure,
> >  		       n_rcu_torture_boosts,
> > -		       n_rcu_torture_timers,
> > +		       n_rcu_torture_timers);
> > +	cnt += sprintf(&page[cnt], "onoff: %ld/%ld:%ld/%ld ",
> >  		       n_online_successes,
> >  		       n_online_attempts,
> >  		       n_offline_successes,
> > -		       n_offline_attempts,
> > +		       n_offline_attempts);
> > +	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
> >  		       n_barrier_successes,
> >  		       n_barrier_attempts,
> >  		       n_rcu_torture_barrier_error);
> 
> A change like this placates tools like checkpatch, but doesn't actually
> fix the problem. :)

The formatting would frustrate most people trying to grep for the
debugfs output anyway, though.

But the main reason for the change is that it makes it easier to see
which quantity goes with which sprintf() format specifier.  (Lazy and
self-indulgent, I know!!!)

						Thanx, Paul

